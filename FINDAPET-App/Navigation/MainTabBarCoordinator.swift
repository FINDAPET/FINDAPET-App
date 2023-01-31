//
//  MainTabBarRouter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 16.08.2022.
//

import Foundation
import UIKit
import CoreData

protocol MainTabBarCoordinatable {
    var coordinatorDelegate: MainTabBarCoordinator? { get set }
}

final class MainTabBarCoordinator: RegistrationCoordinatable, Coordinator {
    
    var coordinatorDelegate: RegistrationCoordinator?
    
    let tabBarController = UITabBarController()
    
    private lazy var feedCoordinator: FeedCoordinator = {
        let coordinator = FeedCoordinator()
        
        coordinator.coordinatorDelegate = self
        coordinator.start()
        
        return coordinator
    }()
    
    private lazy var chatRoomCoordinator: ChatRoomCoordinator = {
        let coordinator = ChatRoomCoordinator()
        
        coordinator.coordinatorDelegate = self
        coordinator.start()
        
        return coordinator
    }()
    
    private lazy var createDealCoordinator: EditDealCoordinator = {
        let coordinator = EditDealCoordinator()
        
        coordinator.coordinatorDelegate = self
        coordinator.start()
        
        return coordinator
    }()
    
    private lazy var profileCoordinator: ProfileCoordinator = {
        let coordinator = ProfileCoordinator()
        
        coordinator.coordinatorDelegate = self
        coordinator.start()
        
        return coordinator
    }()
    
    private lazy var subscriptionCoordinator: SubscriptionCoordinator = {
        let coordinator = SubscriptionCoordinator()
        
        coordinator.coordinatorDelegate = self
        coordinator.start()
        
        return coordinator
    }()
    
    func start() {
        self.setupViews()
        
        self.getNotificationScreens { notificationScreens, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                
                return
            }
            
            guard let IDs = self.getUserDefaultsNotificationScreensID(),
                  let notificationScreen = (notificationScreens ?? .init())
                .filter({ !IDs.contains($0.id?.uuidString ?? .init()) || $0.isRequired })
                .sorted(by: { $0.isRequired == true && $1.isRequired == false }).first else {
                print("❌ Error: not found.")
                
                return
            }
            
            self.tabBarController.present(self.getNotificationScreen(notificationScreen), animated: true)
        }
        
        self.getCurrencies { currencies, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                
                return
            }
            
            guard let currencies = currencies else {
                print("❌ Error: not found.")
                
                return
            }
            
            UserDefaultsManager.write(data: currencies, key: .currencies)
        }
        
        self.getPetClasses { classes, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                
                return
            }
            
            guard let classes = classes else {
                print("❌ Error: not found.")
                
                return
            }
            
            UserDefaultsManager.write(data: classes, key: .petClasses)
        }
        
        self.getPetTypes { types, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                
                return
            }
            
            guard let types = types else {
                print("❌ Error: not found.")
                
                return
            }
            
            for type in types {
                _ = self.coreDataSavePetType(type)
            }
        }
        
        self.getDealModes { modes, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                
                return
            }
            
            guard let modes = modes else {
                print("❌ Error: not found.")
                
                return
            }
            
            UserDefaultsManager.write(data: modes, key: .dealModes)
        }
    }
    
//    MARK: Notification Screen
    func getNotificationScreen(_ notificationScreen: NotificationScreen.Output) -> NotificationScreenViewController {
        let router = NotificationScreenRouter()
        let interactor = NotificationScreenInteractor()
        let presenter = NotificationScreenPresenter(
            notificationScreen: notificationScreen,
            router: router,
            interactor: interactor
        )
        let viewController = NotificationScreenViewController(presenter: presenter)
        
        router.coordinatorDelegate = self
        
        return viewController
    }
    
//    MARK: Requests
    private func getNotificationScreens(_ completionHandler: @escaping ([NotificationScreen.Output]?, Error?) -> Void) {
        if #available(iOS 16, *), let countryCode = Locale.current.region?.identifier {
            RequestManager.request(
                method: .GET,
                authMode: .bearer(value: self.getBearrerToken() ?? .init()),
                url: URLConstructor.defaultHTTP.allNotificationScreens(countryCode: countryCode),
                completionHandler: completionHandler
            )
        } else if let countryCode = Locale.current.regionCode {
            RequestManager.request(
                method: .GET,
                authMode: .bearer(value: self.getBearrerToken() ?? .init()),
                url: URLConstructor.defaultHTTP.allNotificationScreens(countryCode: countryCode),
                completionHandler: completionHandler
            )
        } else {
            completionHandler(nil, RequestErrors.statusCodeError(statusCode: 500))
            
            return
        }
    }
    
    private func getCurrencies(_ completionHandler: @escaping ([String]?, Error?) -> Void) {
        RequestManager.request(
            method: .GET,
            authMode: .bearer(value: self.getBearrerToken() ?? .init()),
            url: URLConstructor.defaultHTTP.getAllCurrencies(),
            completionHandler: completionHandler
        )
    }
    
    private func getPetClasses(_ completionHandler: @escaping ([String]?, Error?) -> Void) {
        RequestManager.request(
            method: .GET,
            authMode: .bearer(value: self.getBearrerToken() ?? .init()),
            url: URLConstructor.defaultHTTP.getAllPetClasses(),
            completionHandler: completionHandler
        )
    }
    
    private func getPetTypes(_ completionHandler: @escaping ([PetType.Output]?, Error?) -> Void) {
        RequestManager.request(
            method: .GET,
            authMode: .bearer(value: self.getBearrerToken() ?? .init()),
            url: URLConstructor.defaultHTTP.getAllPetTypes(),
            completionHandler: completionHandler
        )
    }
    
    private func getDealModes(_ completionHandler: @escaping ([String]?, Error?) -> Void) {
        RequestManager.request(
            method: .GET,
            authMode: .bearer(value: self.getBearrerToken() ?? .init()),
            url: URLConstructor.defaultHTTP.getAllDealModes(),
            completionHandler: completionHandler
        )
    }
    
//    MARK: Keychain
    private func getBearrerToken() -> String? {
        KeychainManager.shared.read(key: .token)
    }
    
//    MARK: User Defaults
    private func getUserDefaultsNotificationScreensID() -> [String]? {
        UserDefaultsManager.read(key: .notificationScreensID) as? [String]
    }
    
//    MARK: Core Data
    private func coreDataSavePetType(
        _ petType: PetType.Output,
        completionHandler: @escaping (Error?) -> Void = { _ in }
    ) -> PetTypeEntity? {
        let manager = CoreDataManager<PetTypeEntity>()
        let context = manager.persistentContainer.newBackgroundContext()
        
        guard let description = NSEntityDescription.entity(
            forEntityName: .init(describing: PetTypeEntity.self),
            in: context
        ) else {
            completionHandler(RequestErrors.statusCodeError(statusCode: 500))
            
            return nil
        }
        
        let model = PetTypeEntity(entity: description, insertInto: context)
        
        var languageCode = String()
        
        if #available(iOS 16, *) {
            languageCode = Locale.current.language.languageCode?.identifier ?? .init()
        } else {
            languageCode = Locale.current.languageCode ?? .init()
        }
        
        model.id = petType.id
        model.name = petType.localizedNames[languageCode] ?? petType.localizedNames["en"] ?? "-"
        model.imageData = petType.imageData
        
        for petBreed in petType.petBreeds {
            guard let petBreedDescription = NSEntityDescription.entity(
                forEntityName: .init(describing: PetBreedEntity.self),
                in: context
            ) else {
                continue
            }
            
            let breed = PetBreedEntity(entity: petBreedDescription, insertInto: context)
            
            breed.id = petBreed.id
            breed.name = petBreed.name
            breed.petType = model

            model.addToPetBreeds(breed)
        }
        
        manager.save(model, completionHandler: completionHandler)
        
        return model
    }
    
//    MARK: Setup Views
    private func setupViews() {
        self.tabBarController.tabBar.clipsToBounds = true
        self.tabBarController.tabBar.layer.masksToBounds = true
        self.tabBarController.viewControllers = [
            self.feedCoordinator.navigationController,
            self.chatRoomCoordinator.navigationController,
            self.createDealCoordinator.navigationController,
            self.profileCoordinator.navigationController,
            self.subscriptionCoordinator.navigationController
        ]
    }
    
}
