//
//  ProfileCoordinator.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 16.08.2022.
//

import Foundation
import UIKit

protocol ProfileCoordinatable {
    var coordinatorDelegate: ProfileCoordinator? { get set }
}

final class ProfileCoordinator: MainTabBarCoordinatable, Coordinator {
    
    var coordinatorDelegate: MainTabBarCoordinator?
    
    let navigationController = UINavigationController()
    
    func start() {
        self.setupViews()
    }
    
    func goToProfile() {
        // push profile
    }
    
    func goToDeals() {
        // push deals
    }
    
    func goToAds() {
        // push ads
    }
    
    func goToOffers() {
        // push offers
    }
    
    private func setupViews() {
        self.navigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Profile", comment: ""),
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person")
        )
        self.navigationController.navigationBar.isHidden = true
    }
    
}
