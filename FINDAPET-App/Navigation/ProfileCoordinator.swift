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

final class ProfileCoordinator: NSObject, MainTabBarCoordinatable, Coordinator {
    
//    MARK: Properties
    weak var coordinatorDelegate: MainTabBarCoordinator?
    let navigationController = CustomNavigationController()
    
//    MARK: Start
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
    func getChatRoom(chatRoom: ChatRoom.Output? = nil, userID: UUID? = nil) -> ChatRoomViewController? {
        self.coordinatorDelegate?.getChatRoom(chatRoom: chatRoom, userID: userID)
    }
    
    func goToChatRoom(chatRoom: ChatRoom.Output? = nil, userID: UUID? = nil) {
        guard let chatRoomViewController = self.getChatRoom(chatRoom: chatRoom, userID: userID) else {
            return
        }
        
        self.navigationController.pushViewController(chatRoomViewController, animated: true)
    }
    
//    MARK: Info
    func getInfo() -> InfoViewController {
        let router = InfoRouter()
        let interactor = InfoInteractor()
        let presenter = InfoPresenter(router: router, interactor: interactor)
        let viewController = InfoViewController(presenter: presenter)
        
        router.coordinatorDelegate = self
        
        return viewController
    }
    
    func goToInfo() {
        self.navigationController.pushViewController(self.getInfo(), animated: true)
    }
    
//    MARK: Complaint
    func getComplaint(_ complaint: Complaint.Input) -> ComplaintViewController {
        let router = ComplaintRouter()
        let interactor = ComplaintInteractor()
        let presenter = ComplaintPresenter(complaint: complaint, router: router, interactor: interactor)
        let viewController = ComplaintViewController(presenter: presenter)
        
        router.coordinatorDelegate = self
        
        return viewController
    }
    
    func goToComlaint(_ complaint: Complaint.Input, didTapSendButtonCallBack: (() -> Void)? = nil) {
        let viewController = self.getComplaint(complaint)
        
        viewController.didTapSendButtonCallBack = didTapSendButtonCallBack
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
//    MARK: Onboarding
    func goToOnboarding(_ animated: Bool = true) {
        self.coordinatorDelegate?.goToOnboarding(animated)
    }
    
//    MARK: Browse Image
    func getBrowseImage(_ dataSource: BrowseImagesViewControllerDataSource) -> BrowseImagesViewController {
        let viewController = BrowseImagesViewController()
        
        viewController.dataSource = dataSource
        
        return viewController
    }
    
    func goToBrowseImage(_ dataSource: BrowseImagesViewControllerDataSource) {
        self.navigationController.pushViewController(self.getBrowseImage(dataSource), animated: true)
    }
    
//    MARK: Edit Deal
    func getEditDeal(_ deal: Deal.Input, isCreate: Bool = true) -> EditDealViewController {
        EditDealCoordinator().getEditDeal(deal: deal, isCreate: isCreate)
    }
    
    func goToEditDeal(_ deal: Deal.Input, isCreate: Bool = true) {
        self.navigationController.pushViewController(self.getEditDeal(deal, isCreate: isCreate), animated: true)
    }
    
//    MARK: Web View
    func getWebView(_ url: URL) -> WebViewViewController { .init(url) }
    func getWebView(_ str: String) throws -> WebViewViewController { try .init(str) }
    
    func goToWebView(_ url: URL) {
        self.navigationController.pushViewController(self.getWebView(url), animated: true)
    }
    
    func goToWebView(_ str: String) throws {
        self.navigationController.pushViewController(try self.getWebView(str), animated: true)
    }
       
//    MARK: Setup Views
    private func setupViews() {
        if #available(iOS 13.0, *) {
            self.navigationController.tabBarItem = UITabBarItem(
                title: NSLocalizedString("Profile", comment: ""),
                image: UIImage(systemName: "person"),
                selectedImage: UIImage(systemName: "person")
            )
        } else {
            self.navigationController.navigationBar.tintColor = .accentColor
            self.navigationController.tabBarItem = UITabBarItem(
                title: NSLocalizedString("Profile", comment: ""),
                image: UIImage(named: "person")?.withRenderingMode(.alwaysTemplate),
                selectedImage: UIImage(named: "person")?.withRenderingMode(.alwaysTemplate)
            )
        }
        
        self.navigationController.navigationBar.isHidden = true
    }
    
}
