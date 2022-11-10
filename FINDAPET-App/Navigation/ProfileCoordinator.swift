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
    
//    MARK: Settings Block
    func getSettingsBlock(
        goToAction: @escaping () -> Void,
        currencyValueTextFieldTapAction: @escaping () -> Void
    ) -> SettingsBlockView {
        let router = SettingsBlockRouter(goToAction: goToAction)
        let interactor = SettingsBlockInteractor()
        let presenter = SettingsBlockPresenter(
            router: router,
            interactor: interactor,
            currencyValueTextFieldTapAction: currencyValueTextFieldTapAction
        )
        let view = SettingsBlockView(presenter: presenter)
        
        return view
    }
    
//    MARK: Ad
    func goToAds(userID: UUID? = nil, ads: [Ad.Output] = [Ad.Output]()) {
        self.navigationController.pushViewController(self.getAds(userID: userID, ads: ads), animated: true)
    }
    
    func goToOffers(mode: OffersMode, offers: [Offer.Output] = [Offer.Output](), userID: UUID? = nil) {
        self.navigationController.pushViewController(self.getOffers(mode: mode, offers: offers, userID: userID), animated: true)
    }
    
//    MARK: Settings
    func getSettings() -> SettingsViewController {
        let router = SettingsRouter()
        let interactor = SettingsInteractor()
        let presenter = SettingsPresenter(router: router, interator: interactor)
        let viewController = SettingsViewController(presenter: presenter)
        
        router.coordinatorDelegate = self
        
        return viewController
    }
    
    func goToSettings() {
        self.navigationController.pushViewController(self.getSettings(), animated: true)
    }
    
//    MARK: Create Ad
    func getCreateAd(user: User.Output? = nil) -> CreateAdViewController {
        let router = CreateAdRouter()
        let interactor = CreateAdInteractor()
        let presenter = CreateAdPresenter(user: user, router: router, interactor: interactor)
        let viewController = CreateAdViewController(presenter: presenter)
        
        router.coordinatorDelegate = self
        
        return viewController
    }
    
    func goToCreateAd(user: User.Output? = nil) {
        self.navigationController.pushViewController(self.getCreateAd(user: user), animated: true)
    }
    
//     MARK: Create Offer
    func getCreateOffer(deal: Deal.Output) -> CreateOfferViewController {
        let router = CreateOfferRouter()
        let interactor = CreateOfferInteractor()
        let presenter = CreateOfferPresenter(deal: deal, router: router, interactor: interactor)
        let viewController = CreateOfferViewController(presenter: presenter)
        
        router.coordinatorDelegate = self
        
        return viewController
    }
    
    func goToCreateOffer(deal: Deal.Output) {
        self.navigationController.pushViewController(self.getCreateOffer(deal: deal), animated: true)
    }
    
//    MARK: Edit Profile
    func goToEditProfile(user: User.Input) {
        self.coordinatorDelegate?.coordinatorDelegate?.goToEditProfile(user: user)
    }
    
//    MARK: Deal
    func getDeal(dealID: UUID? = nil, deal: Deal.Output? = nil) -> DealViewController {
        let router = DealRouter()
        let interactor = DealInteractor()
        
        router.coordinatorDelegate = self
        
        if let deal = deal {
            let presenter = DealPresenter(deal: deal, router: router, interactor: interactor)
            let viewController = DealViewController(presenter: presenter)
            
            return viewController
        }
        
        let presenter = DealPresenter(dealID: dealID, router: router, interactor: interactor)
        let viewController = DealViewController(presenter: presenter)
        
        return viewController
    }
    
    func goToDeal(dealID: UUID? = nil, deal: Deal.Output? = nil) {
        self.navigationController.pushViewController(self.getDeal(dealID: dealID, deal: deal), animated: true)
    }
    
//    MARK: Chat Room
    func getChatRoom(chatRoom: ChatRoom.Output? = nil, userID: UUID? = nil) -> ChatRoomViewController {
        let coordinator = ChatRoomCoordinator()
        
        coordinator.start()
        
        return coordinator.getChatRoom(chatRoom: chatRoom, userID: userID)
    }
    
    func goToChatRoom(chatRoom: ChatRoom.Output? = nil, userID: UUID? = nil) {
        self.navigationController.pushViewController(self.getChatRoom(chatRoom: chatRoom, userID: userID), animated: true)
    }
    
//    MARK: Info
    func getInfo() -> InfoViewController {
        let router = InfoRouter()
        let interactor = InfoInteractor()
        let presenter = InfoPresenter(router: router, interactor: interactor)
        let viewController = InfoViewController(presenter: presenter)
        
        return viewController
    }
    
    func goToInfo() {
        self.navigationController.pushViewController(self.getInfo(), animated: true)
    }
    
//    MARK: Onboarding
    func goToOnboarding() {
        let registrationCoordinator = RegistrationCoordinator()
        
        registrationCoordinator.start()
        
        self.coordinatorDelegate?.coordinatorDelegate?.start()
    }
    
//    MARK: Setup Views
    private func setupViews() {
        self.navigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Profile", comment: ""),
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person")
        )
        self.navigationController.navigationBar.isHidden = true
    }
    
}
