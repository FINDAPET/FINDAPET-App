//
//  MyOffersPresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 18.10.2022.
//

import Foundation

final class OffersPresenter {
    
    var callBack: (() -> Void)?
    var offers = [Offer.Output]() {
        didSet {
            self.callBack?()
        }
    }
    let mode: OffersMode
    private let router: OffersRouter
    private let interactor: OffersInteractor
    private(set) var userID: UUID? = nil
    
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
        
        self.interactor.getUserOffers(userID: userID, completionHandler: completionHandler)
    }
    
    func getUserMyOffers(completionHandler: @escaping ([Offer.Output]?, Error?) -> Void) {
        guard let userID = self.userID else {
            print("❌ Error: userID is equal to nil.")
            
            completionHandler(nil, nil)
            
            return
        }
        
        self.interactor.getUserMyOffers(userID: userID, completionHandler: completionHandler)
    }
    
    func acceptOffer(offer: Offer.Output, completionHandler: @escaping (Error?) -> Void) {
        guard let dealID = offer.deal.id, let offerID = offer.id else {
            print("❌ Error: dealID or userID is equal to nil.")
            
            completionHandler(nil)
            
            return
        }
        
        self.interactor.acceptOffer(dealID: dealID, offerID: offerID, completionHandler: completionHandler)
    }
    
//    MARK: Routing
    func goToChatRoom(with id: UUID) {
        self.router.goToChatRoom(with: id)
    }
    
}
