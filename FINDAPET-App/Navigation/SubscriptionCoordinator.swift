//
//  SubscriptionCoordinator.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 27.10.2022.
//

import Foundation
import UIKit

protocol SubscriptionCoordinatable {
    var coordinatorDelegate: SubscriptionCoordinator? { get set }
}

final class SubscriptionCoordinator: MainTabBarCoordinatable, Coordinator {
    
    var coordinatorDelegate: MainTabBarCoordinator?
    
    let navigationController = UINavigationController()
    
    func start() {
        self.setupViews()
    }
    
//    MARK: Subscription
    func getSubscritpion() -> SubscriptionViewController {
        let router = SubscriptionRouter()
        let interactor = SubscriptionInteractor()
        let presenter = SubscriptionPresenter(router: router, interactor: interactor)
        let viewController = SubscriptionViewController(presenter: presenter)
        
        return viewController
    }
    
    func goToSubscription() {
        self.navigationController.pushViewController(self.getSubscritpion(), animated: true)
    }
    
//    MARK: Setup Views
    private func setupViews() {
        self.navigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Subscription", comment: ""),
            image: UIImage(systemName: "crown"),
            selectedImage: UIImage(systemName: "crown")
        )
        self.navigationController.navigationBar.isHidden = true
    }
    
}
