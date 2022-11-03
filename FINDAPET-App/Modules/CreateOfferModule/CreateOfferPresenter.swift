//
//  CreateOfferPresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 02.11.2022.
//

import Foundation

final class CreateOfferPresenter {
    
    let deal: Deal.Output
    private let router: CreateOfferRouter
    private let interactor: CreateOfferInteractor
    
    init(deal: Deal.Output, router: CreateOfferRouter, interactor: CreateOfferInteractor) {
        self.deal = deal
        self.router = router
        self.interactor = interactor
    }
    
//    MARK: User Defaults
    func getUserDefautlsCurrency() -> String? {
        self.interactor.getUserDefaults(key: .currency) as? String
    }
    
    private func getUserDefautlsUserID() -> UUID? {
        self.interactor.getUserDefaults(key: .id) as? UUID
    }
    
//    MARK: Requests
    func createOffer(price: Int, currencyName: Currency, completionHandler: @escaping (Error?) -> Void) {
        guard let buyerID = self.getUserDefautlsUserID(), let dealID = self.deal.id, let catteryID = self.deal.cattery.id else {
            print("❌ Error: id is equal to nil.")
            
            completionHandler(RequestErrors.statusCodeError(statusCode: 500))
            
            return
        }
        
        self.interactor.makeOffer(
            offer: Offer.Input(
                buyerID: buyerID,
                dealID: dealID,
                catteryID: catteryID,
                price: price,
                currencyName: currencyName.rawValue
            ),
            completionHandler: completionHandler
        )
    }
    
//    MARK: Notification Center
    func notificationCenterManagerPostUpdateProfileScreen() {
        self.interactor.notificationCenterManagerPost(.reloadProfileScreen)
    }
    
}
