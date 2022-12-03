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
