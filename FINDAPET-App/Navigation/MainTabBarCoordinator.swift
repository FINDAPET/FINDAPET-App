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
        self.tabBar.navigationController?.navigationBar.isHidden = true
        self.tabBar.viewControllers = [
            self.feedCoordinator.navigationController,
            self.profileCoordinator.navigationController,
            self.subscriptionCoordinator.navigationController
        ]
    }
    
}
