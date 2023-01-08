//
//  CoreDataManager.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 03.01.2023.
//

import Foundation
import CoreData

final class CoreDataManager<T : NSManagedObject>: NSObject {
    
//    MARK: Properties
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FINDAPET_App")
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("❌ Error: \(error)")
            }
        }
        
        return container
    }()
    
    private(set) lazy var fetchedResultController = NSFetchedResultsController<T>(
        fetchRequest: NSFetchRequest<T>(entityName: .init(describing: T.self)),
        managedObjectContext: self.persistentContainer.viewContext,
        sectionNameKeyPath: nil,
        cacheName: nil
    )
    
//    MARK: Actions
    func all(_ completionHandler: @escaping ([T], Error?) -> Void) {
        let viewContext = self.persistentContainer.viewContext
        
        viewContext.perform { [ weak self ] in
            do {
                try self?.fetchedResultController.performFetch()
                
                guard let fetchRequest = try viewContext.fetch(T.fetchRequest()) as? [T] else {
                    throw RequestErrors.statusCodeError(statusCode: 500)
                }
                
                completionHandler(fetchRequest, nil)
            } catch {
                print("❌ Error: \(error.localizedDescription)")
                
                completionHandler(.init(), error)
                
                return
            }
        }
    }
    
    func save(_ model: T, completionHandler: @escaping (Error?) -> Void) {
        do {
            try model.managedObjectContext?.save()
            
            completionHandler(nil)
        } catch {
            print("❌ Error: \(error.localizedDescription)")
            
            completionHandler(error)
            
            return
        }
    }
    
    func delete(_ model: T, completionHadler: @escaping (Error?) -> Void) {
        let viewContext = self.persistentContainer.viewContext
        
        viewContext.perform {
            do {
                viewContext.delete(model)
                
                try viewContext.save()
                
                completionHadler(nil)
            } catch {
                print("❌ Error: \(error.localizedDescription)")
                
                completionHadler(error)
                
                return
            }
        }
    }
    
}
