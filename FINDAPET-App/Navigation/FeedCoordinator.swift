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
    
//    MARK: Properties
    weak var coordinatorDelegate: MainTabBarCoordinator?
    let navigationController = UINavigationController()
    
//    MARK: Start
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
    func getDeal(dealID: UUID? = nil, deal: Deal.Output? = nil) -> DealViewController? {
        self.coordinatorDelegate?.getDeal(dealID: dealID, deal: deal)
    }
    
    func goToDeal(dealID: UUID? = nil, deal: Deal.Output? = nil) {
        guard let dealViewController = self.getDeal(dealID: dealID, deal: deal) else {
            return
        }
        
        self.navigationController.pushViewController(dealViewController, animated: true)
    }
    
//    MARK: Profile
    func getProfile(userID: UUID? = nil) -> ProfileViewController? {
        self.coordinatorDelegate?.getProfile(userID: userID)
    }
    
    func goToProfile(userID: UUID? = nil) {
        guard let profileViewController = self.getProfile(userID: userID) else {
            return
        }
        
        self.navigationController.pushViewController(profileViewController, animated: true)
    }
    
//    MARK: Filter
    func getFilter(filter: Filter, saveAction: @escaping (Filter) -> Void) -> FilterViewController {
        let router = FilterRouter()
        let interactor = FilterInteractor()
        let presenter = FilterPresenter(filter: filter, saveAction: saveAction, rotuer: router, interactor: interactor)
        let viewController = FilterViewController(presenter: presenter)
        
        router.coordinatorDelegate = self
        
        return viewController
    }
    
    func goToFilter(filter: Filter, saveAction: @escaping (Filter) -> Void) {
        self.navigationController.pushViewController(self.getFilter(filter: filter, saveAction: saveAction), animated: true)
    }
    
//    MARK: Search
    func getSearch(with title: String?, _ onTapSearchButtonAction: @escaping (String) -> Void) -> SearchViewController {
        let router = SearchRouter()
        let interactor = SearchInteractor()
        let presenter = SearchPresenter(
            router: router,
            interactor: interactor,
            title: title,
            onTapSearchButtonAction: onTapSearchButtonAction
        )
        let viewController = SearchViewController(presenter: presenter)
        
        router.coordinatorDelegate = self
        
        return viewController
    }
    
    func goToSearch(with title: String?, _ onTapSearchButtonAction: @escaping (String) -> Void) {
        self.navigationController.pushViewController(self.getSearch(with: title, onTapSearchButtonAction), animated: false)
    }
    
//    MARK: Setup Views
    private func setupViews() {
        if #available(iOS 13.0, *) {
            self.navigationController.tabBarItem = UITabBarItem(
                title: NSLocalizedString("Feed", comment: ""),
                image: UIImage(systemName: "house"),
                selectedImage: UIImage(systemName: "house")
            )
        } else {
            self.navigationController.navigationBar.tintColor = .accentColor
            self.navigationController.tabBarItem = UITabBarItem(
                title: NSLocalizedString("Feed", comment: ""),
                image: UIImage(named: "house")?.withRenderingMode(.alwaysTemplate),
                selectedImage: UIImage(named: "house")?.withRenderingMode(.alwaysTemplate)
            )
        }
        
        self.navigationController.navigationBar.isHidden = true
    }
    
}
