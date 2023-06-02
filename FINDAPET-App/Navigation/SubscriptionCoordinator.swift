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

final class SubscriptionCoordinator: NSObject, MainTabBarCoordinatable, Coordinator {
    
    weak var coordinatorDelegate: MainTabBarCoordinator?
    let navigationController = CustomNavigationController()
    
    func start() {
        self.setupViews()
        
//        full version
//        self.goToSubscription()
        
//        beta version
        self.goToSubscriptionSoon()
    }
    
//    MARK: Subscription
    func getSubscription() -> SubscriptionViewController {
        let router = SubscriptionRouter()
        let interactor = SubscriptionInteractor()
        let presenter = SubscriptionPresenter(router: router, interactor: interactor)
        let viewController = SubscriptionViewController(presenter: presenter)
        
        router.coordinatorDelegate = self
        
        return viewController
    }
    
    func goToSubscription() {
        self.navigationController.pushViewController(self.getSubscription(), animated: true)
    }
    
//    MARK: Subscription Information
    func getSubscriptionInformation() -> SubscriptionInformationView {
        let router = SubscriptionInformationRouter()
        let interactor = SubscriptionInformationInteractor()
        let presenter = SubscriptionInformationPresenter(router: router, interactor: interactor)
        let view = SubscriptionInformationView(presenter: presenter)
        
        router.coordinatorDelegate = self
        
        return view
    }
    
//    MARK: Subscription Soon
    func getSubscriptionSoon() -> SubscriptionSoonViewController {
        let router = SubscriptionSoonRouter()
        let interactor = SubscriptionSoonInteractor()
        let presenter = SubscriptionSoonPresenter(router: router, interactor: interactor)
        let viewController = SubscriptionSoonViewController(presenter: presenter)
        
        router.coordinatorDelegate = self
        
        return viewController
    }
    
    func goToSubscriptionSoon() {
        self.navigationController.pushViewController(self.getSubscriptionSoon(), animated: false)
    }
    
//    MARK: Setup Views
    private func setupViews() {
        self.navigationController.navigationBar.tintColor = .accentColor
        
        if #available(iOS 13.0, *) {
            self.navigationController.tabBarItem = UITabBarItem(
                title: NSLocalizedString("Subscription", comment: ""),
                image: UIImage(systemName: "crown"),
                selectedImage: UIImage(systemName: "crown")
            )
        } else {
            self.navigationController.navigationBar.tintColor = .accentColor
            self.navigationController.tabBarItem = UITabBarItem(
                title: NSLocalizedString("Subscription", comment: ""),
                image: UIImage(named: "crown")?.withRenderingMode(.alwaysTemplate),
                selectedImage: UIImage(named: "crown")?.withRenderingMode(.alwaysTemplate)
            )
        }
    }
    
}
