//
//  CoreDataManager.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 03.01.2023.
//

import Foundation
import CoreData

//MARK: - Core Data Managers
let coreDataPetBreedManager = CoreDataManager<PetBreedEntity>()
let coreDataLocalizedPetTypeName = CoreDataManager<LocalizedPetTypeNameEntity>()
let coreDataPetTypeManager = CoreDataManager<PetTypeEntity>()

//MARK: - Core Data Manager
final class CoreDataManager<T : NSManagedObject>: NSObject {
    
//    MARK: - Properties    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FINDAPET_App")
        
        container.viewContext.mergePolicy = NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("❌ Error: \(error)")
            }
        }
        
        return container
    }()
    
    private(set) lazy var fetchedResultController: NSFetchedResultsController<T> = {
        let request = NSFetchRequest<T>(entityName: .init(describing: T.self))
        
        request.sortDescriptors = [.init(key: "id", ascending: false)]
        
        return .init(
            fetchRequest: request,
            managedObjectContext: self.persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }()
    
//    MARK: - Actions
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
        let viewContext = self.persistentContainer.newBackgroundContext()
        
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
