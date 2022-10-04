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
        self.goToProfile()
    }
    
    func goToProfile(userID: UUID? = nil) {
        let router = ProfileRouter()
        let interactor = ProfileInteractor()
        let presenter = ProfilePresenter(router: router, interactor: interactor, userID: userID)
        let viewController = ProfileViewController(presenter: presenter)
        
        router.coordinatorDelegate = self
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToDeals(isFindable: Bool) {
        // push deals
    }
    
    func goToAds() {
        // push ads
    }
    
    func goToOffers() {
        // push offers
    }
    
    func goToCreateDeal() {
        // push create deal
    }
    
    func goToCreateOffer() {
        // push create offer
    }
    
    func goToCreateAd() {
        // push create ad
    }
    
    func goToInfo() {
        // push info
    }
    
    func goToEditProfile(user: User.Input) {
        self.navigationController.pushViewController(
            RegistrationCoordinator().getEditProfile(user: user),
            animated: true
        )
    }
    
    func goToOnboarding() {
        let registrationCoordinator = RegistrationCoordinator()
        
        registrationCoordinator.start()
        
        self.navigationController.pushViewController(registrationCoordinator.navigationController, animated: true)
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
