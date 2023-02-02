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
    func getDeal(completionHandler: @escaping (Deal.Output?, Error?) -> Void) {
        guard let dealID = self.dealID else {
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
                age: deal.age,
                color: deal.color,
                price: Double(deal.price),
                currencyName: Currency.getCurrency(wtih: deal.currencyName) ?? .USD,
                catteryID: deal.cattery.id ?? UUID(),
                country: deal.country,
                city: deal.city,
                description: deal.description,
                whatsappNumber: deal.whatsappNumber,
                telegramUsername: deal.telegramUsername,
                instagramUsername: deal.instagramUsername,
                facebookUsername: deal.facebookUsername,
                vkUsername: deal.vkUsername,
                mail: deal.mail,
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
    
//    MARK: Routing
    func goToProfile(with id: UUID? = nil) {
        self.router.goToProfile(with: id ?? self.deal?.cattery.id)
    }
    
    func goToChatRoom() {
        self.router.goToChatRoom(userID: self.deal?.cattery.id)
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
    
}
