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
    }
    
    func goToDeals() {
        // push deals
    }
    
    func goToOffers() {
        // push offers
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
