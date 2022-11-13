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
    
    let tabBar = UITabBarController()
    
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
        self.tabBar.tabBar.clipsToBounds = true
        self.tabBar.tabBar.layer.masksToBounds = true
        self.tabBar.tabBar.layer.cornerRadius = 25
        self.tabBar.viewControllers = [
            self.feedCoordinator.navigationController,
            self.chatRoomCoordinator.navigationController,
            self.profileCoordinator.navigationController,
            self.subscriptionCoordinator.navigationController
        ]
    }
    
}
