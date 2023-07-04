//
//  MyOffersPresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 18.10.2022.
//

import Foundation

final class OffersPresenter {
    
    var callBack: (() -> Void)?
    let mode: OffersMode
    private(set) var offers = [Offer.Output]() {
        didSet {
            self.callBack?()
        }
    }
    private(set) var userID: UUID?
    private let router: OffersRouter
    private let interactor: OffersInteractor
    
    init(router: OffersRouter, interactor: OffersInteractor, mode: OffersMode, offers: [Offer.Output]) {
        self.mode = mode
        self.router = router
        self.interactor = interactor
        self.offers = offers
    }
    
    init(router: OffersRouter, interactor: OffersInteractor, mode: OffersMode, userID: UUID) {
        self.mode = mode
        self.router = router
        self.interactor = interactor
        self.userID = userID
    }
    
//    MARK: Requests
    func getUserOffers(completionHandler: @escaping ([Offer.Output]?, Error?) -> Void) {
        guard let userID = self.userID else {
            print("❌ Error: userID is equal to nil.")
            
            completionHandler(nil, nil)
            
            return
        }
        
        self.interactor.getUserOffers(userID: userID) { [ weak self ] offers, error in
            completionHandler(offers, error)
            
            guard error == nil, let offers else { return }
            
            self?.offers = offers
        }
    }
    
    func getUserMyOffers(completionHandler: @escaping ([Offer.Output]?, Error?) -> Void) {
        guard let userID = self.userID else {
            print("❌ Error: userID is equal to nil.")
            
            completionHandler(nil, nil)
            
            return
        }
        
        self.interactor.getUserMyOffers(userID: userID) { [ weak self ] offers, error in
            completionHandler(offers, error)
            
            guard error == nil, let offers else { return }
            
            self?.offers = offers
        }
    }
    
    func acceptOffer(offer: Offer.Output, completionHandler: @escaping (Error?) -> Void) {
        guard let dealID = offer.deal.id, let offerID = offer.id else {
            print("❌ Error: dealID or userID is equal to nil.")
            
            completionHandler(nil)
            
            return
        }
        
        self.interactor.acceptOffer(dealID: dealID, offerID: offerID, completionHandler: completionHandler)
    }
    
    func deleteOffer(_ offerID: UUID, completionHandler: @escaping (Error?) -> Void = { _ in }) {
        self.offers.removeAll { $0.id == offerID }
        self.interactor.deleteOffer(offerID: offerID, completionHandler: completionHandler)
    }
    
//    MARK: Routing
    func goToChatRoom(_ chatRoom: ChatRoom.Output) {
        self.router.goToChatRoom(chatRoom: chatRoom)
    }
    
    func goToProfile(userID: UUID? = nil) {
        self.router.goToProfile(userID: userID)
    }
    
    func goToDeal(_ deal: Deal.Output) {
        self.router.goToDeal(deal: deal)
    }
    
}
