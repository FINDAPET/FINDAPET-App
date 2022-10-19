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
    
//    MARK: Profile
    func getProfile(userID: UUID? = nil) -> ProfileViewController {
        let router = ProfileRouter()
        let interactor = ProfileInteractor()
        let presenter = ProfilePresenter(router: router, interactor: interactor, userID: userID)
        let viewController = ProfileViewController(presenter: presenter)
        
        router.coordinatorDelegate = self
        
        return viewController
    }
    
    func goToProfile(userID: UUID? = nil) {
        self.navigationController.pushViewController(self.getProfile(userID: userID), animated: true)
    }
    
//    MARK: Offers
    func getOffers(mode: OffersMode, offers: [Offer.Output] = [Offer.Output](), userID: UUID? = nil) -> OffersViewController {
        let router = OffersRouter()
        let interactor = OffersInteractor()
        
        router.coordinatorDelegate = self
        
        if let userID = userID {
            let presenter = OffersPresenter(router: router, interactor: interactor, mode: mode, userID: userID)
            let viewController = OffersViewController(presenter: presenter)
            
            return viewController
        }
        
        let presenter = OffersPresenter(router: router, interactor: interactor, mode: mode, offers: offers)
        let viewController = OffersViewController(presenter: presenter)
        
        return viewController
    }
    
//    MARK: Ads
    func getAds(userID: UUID? = nil, ads: [Ad.Output] = [Ad.Output]()) -> AdsViewController {
        let router = AdsRouter()
        let interactor = AdsInteractor()
        
        router.coordinatorDelegate = self
        
        if let userID = userID {
            let presenter = AdsPresenter(userID: userID, router: router, interactor: interactor)
            let viewController = AdsViewController(presenter: presenter)
            
            return viewController
        }
        
        let presenter = AdsPresenter(ads: ads, router: router, interactor: interactor)
        let viewController = AdsViewController(presenter: presenter)
        
        return viewController
    }
    
    func goToAds(userID: UUID? = nil, ads: [Ad.Output] = [Ad.Output]()) {
        self.navigationController.pushViewController(self.getAds(userID: userID, ads: ads), animated: true)
    }
    
    func goToOffers(mode: OffersMode, offers: [Offer.Output] = [Offer.Output](), userID: UUID? = nil) {
        self.navigationController.pushViewController(self.getOffers(mode: mode, offers: offers, userID: userID), animated: true)
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
