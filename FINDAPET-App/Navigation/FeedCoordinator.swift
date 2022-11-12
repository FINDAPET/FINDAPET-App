//
//  FeedTabBarCoordinator.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 16.08.2022.
//

import Foundation
import UIKit

protocol FeedCoordinatable {
    var coordinatorDelegate: FeedCoordinator? { get set }
}

final class FeedCoordinator: MainTabBarCoordinatable, Coordinator {
    
    var coordinatorDelegate: MainTabBarCoordinator?
    
    let navigationController = UINavigationController()
    
    func start() {
        self.setupViews()
        self.goToFeed()
    }
    
//    MARK: Feed
    func getFeed() -> FeedViewController {
        let router = FeedRouter()
        let interactor = FeedInteractor()
        let presenter = FeedPresenter(router: router, interactor: interactor)
        let viewController = FeedViewController(presenter: presenter)
        
        router.coordinatorDelegate = self
        
        return viewController
    }
    
    func goToFeed() {
        self.navigationController.pushViewController(self.getFeed(), animated: true)
    }
    
//    MARK: Deal
    func getDeal(dealID: UUID? = nil, deal: Deal.Output? = nil) -> DealViewController {
        let coordinator = ProfileCoordinator()
        
        coordinator.start()
        
        return coordinator.getDeal(dealID: dealID, deal: deal)
    }
    
    func goToDeal(dealID: UUID? = nil, deal: Deal.Output? = nil) {
        self.navigationController.pushViewController(self.getDeal(dealID: dealID, deal: deal), animated: true)
    }
    
    private func setupViews() {
        self.navigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Feed", comment: ""),
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house")
        )
        self.navigationController.navigationBar.isHidden = true
    }
    
}
