//
//  MyOffersPresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 18.10.2022.
//

import Foundation

final class MyOffersPresenter {
    
    var callBack: (() -> Void)?
    var offers = [Offer.Output]() {
        didSet {
            self.callBack?()
        }
    }
    private let router: MyOffersRouter
    private let interactor: MyOffersInteractor
    private(set) var userID: UUID? = nil
    
    init(router: MyOffersRouter, interactor: MyOffersInteractor, offers: [Offer.Output]) {
        self.router = router
        self.interactor = interactor
        self.offers = offers
    }
    
    init(router: MyOffersRouter, interactor: MyOffersInteractor, userID: UUID) {
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
    
}
