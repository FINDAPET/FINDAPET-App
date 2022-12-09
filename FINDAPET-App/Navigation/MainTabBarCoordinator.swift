//
//  MainTabBarRouter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 16.08.2022.
//

import Foundation
import UIKit

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
                .filter({ !IDs.contains($0.id?.uuidString ?? .init()) }).first else {
                print("❌ Error: not found.")
                
                return
            }
            
            self.tabBarController.present(self.getNotificationScreen(notificationScreen), animated: true)
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
    
//    MARK: Keychain
    private func getBearrerToken() -> String? {
        KeychainManager.shared.read(key: .token)
    }
    
//    MARK: User Defaults
    private func getUserDefaultsNotificationScreensID() -> [String]? {
        UserDefaultsManager.read(key: .notificationScreensID) as? [String]
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
