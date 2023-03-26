//
//  DealPresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 30.10.2022.
//

import Foundation
import StoreKit

final class DealPresenter {
    
    var callBack: (() -> Void)?
    private(set) var deal: Deal.Output? {
        didSet {            
            self.callBack?()
        }
    }
    private(set) var dealID: UUID?
    private let router: DealRouter
    private let interactor: DealInteractor
    
    init(deal: Deal.Output? = nil, router: DealRouter, interactor: DealInteractor) {
        self.deal = deal
        self.router = router
        self.interactor = interactor
    }
    
    init(dealID: UUID? = nil, router: DealRouter, interactor: DealInteractor) {
        self.dealID = dealID
        self.router = router
        self.interactor = interactor
    }
    
//    MARK: Editing
    func makeDealPremium() {
        self.deal?.isPremiumDeal = true
    }
    
//    MARK: Purchase
    func getPremiumDealProduct(callBack: @escaping ([SKProduct]) -> Void = { _ in }) {
        self.interactor.getProducts(with: [.premiumDeal], callBack: callBack)
    }
    
    func makePayment(_ product: SKProduct, callBack: @escaping (Error?) -> Void) {
        self.interactor.makePayment(product, callBack: callBack)
    }
    
//    MARK: Requests
    func getDeal(completionHandler: @escaping (Deal.Output?, Error?) -> Void = { _, _ in }) {
        guard let dealID = self.dealID ?? self.deal?.id else {
            completionHandler(nil, nil)
            
            return
        }
        
        let newCompletionHandler: (Deal.Output?, Error?) -> Void = { [ weak self ] deal, error in
            completionHandler(deal, error)
            
            guard error == nil else {
                return
            }
            
            self?.deal = deal
        }
        
        self.interactor.getDeal(dealID: dealID, completionHandler: newCompletionHandler)
    }
    
    func changeDeal(completionHandler: @escaping (Error?) -> Void) {
        guard let deal = self.deal else {
            print("❌ Error: deal is equal to nil.")
            
            completionHandler(RequestErrors.statusCodeError(statusCode: 404))
            
            return
        }
        
        self.interactor.changeDeal(
            deal: Deal.Input(
                id: deal.id,
                title: deal.title,
                photoDatas: deal.photoDatas,
                tags: deal.tags,
                isPremiumDeal: deal.isPremiumDeal,
                isActive: deal.isActive,
                mode: DealMode.getDealMode(deal.mode) ?? .everywhere,
                petTypeID: deal.petType.id,
                petBreedID: deal.petBreed.id,
                petClass: deal.petClass,
                isMale: deal.isActive,
                birthDate: ISO8601DateFormatter().date(from: deal.birthDate) ?? .init(),
                color: deal.color,
                price: Double(deal.price),
                currencyName: Currency.getCurrency(wtih: deal.currencyName) ?? .USD,
                catteryID: deal.cattery.id ?? UUID(),
                country: deal.country,
                city: deal.city,
                description: deal.description,
                buyerID: deal.buyer?.id
            ),
            completionHandler: completionHandler
        )
    }
    
    func deleteDeal(completionHandler: @escaping (Error?) -> Void) {
        guard let dealID = self.deal?.id else {
            print("❌ Error: deal id is equal to nil.")
            
            completionHandler(RequestErrors.statusCodeError(statusCode: 404))
            
            return
        }
        
        self.interactor.deleteDeal(with: dealID, competionHandler: completionHandler)
    }
    
    func viewDeal(completionHandler: @escaping (Error?) -> Void = { _ in }) {
        guard self.deal?.cattery.id != self.getUserID() else {
            print("❌ Error: bad request")
            
            completionHandler(RequestErrors.statusCodeError(statusCode: 500))
            
            return
        }
        
        guard let id = self.deal?.id else {
            print("❌ Error: deal id is equal to nil.")
            
            completionHandler(RequestErrors.statusCodeError(statusCode: 404))
            
            return
        }
        
        self.interactor.viewDeal(with: id, completionHandler: completionHandler)
    }
    
//    MARK: User Defaults
    func getUserID() -> UUID? {
        guard let string = self.interactor.getUserDefaults(.id) as? String else {
            return nil
        }
        
        return UUID(uuidString: string)
    }
    
//    MARK: Notification Center
    func notificationCenterManagerPostUpdateProfileScreen() {
        self.interactor.notificationCenterManagerPost(.reloadProfileScreen)
    }
    
    func notificationCenterManagerAddObserverUpdateDealScreen(
        _ observer: Any,
        action: Selector
    ) {
        self.interactor.notificationCenterManagerAddObserver(
            observer,
            name: .reloadDealScreen,
            additional: self.deal?.id?.uuidString,
            action: action
        )
    }
    
//    MARK: Routing
    func getProfile(with id: UUID? = nil) -> ProfileViewController? {
        self.router.getProfile(with: id)
    }
    
    func getChatRoom() -> ChatRoomViewController? {
        guard let cattery = self.deal?.cattery else {
            return nil
        }
        
        return self.router.getChatRoom(chatRoom: .init(users: [cattery, .init(
            id: self.getUserID(),
            name: .init(),
            deals: .init(),
            boughtDeals: .init(),
            ads: .init(),
            myOffers: .init(),
            offers: .init(),
            chatRooms: .init(),
            score: .zero,
            isPremiumUser: .random()
        )], messages: .init()))
    }
    
    func getCreateOffer() -> CreateOfferViewController? {
        guard let deal = self.deal else {
            return nil
        }
        
        return self.router.getCreateOffer(deal: deal)
    }
    
    func getComplaint() -> ComplaintViewController? {
        guard let id = self.getUserID() else {
            return nil
        }
        
        return self.router.getComplaint(.init(text: .init(), senderID: id, dealID: self.deal?.id))
    }
    
    func getBrowseImage(_ dataSource: BrowseImagesViewControllerDataSource) -> BrowseImagesViewController? {
        self.router.getBrowseImage(dataSource)
    }
    
    func getEditDeal() -> EditDealViewController? {
        guard let deal = self.deal else {
            return nil
        }
        
        return self.router.getEditDeal(
            .init(
                id: deal.id,
                title: deal.title,
                photoDatas: deal.photoDatas,
                tags: deal.tags,
                isPremiumDeal: deal.isPremiumDeal,
                isActive: deal.isActive,
                mode: .getDealMode(deal.mode),
                petTypeID: deal.petType.id,
                petBreedID: deal.petBreed.id,
                petClass: deal.petClass,
                isMale: deal.isMale,
                birthDate: ISO8601DateFormatter().date(from: deal.birthDate) ?? .init(),
                color: deal.color,
                price: deal.price,
                currencyName: .getCurrency(wtih: deal.currencyName) ?? .USD,
                catteryID: deal.cattery.id ?? .init(),
                country: deal.country,
                city: deal.city,
                description: deal.description,
                buyerID: deal.buyer?.id
            ),
            isCreate: false
        )
    }
    
}
