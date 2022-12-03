//
//  CreateDealPresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 26.11.2022.
//

import Foundation
import StoreKit

final class EditDealPresenter {
    
    var callBack: (() -> Void)?
    lazy var deal = Deal.Input(
        title: .init(),
        photoDatas: .init(),
        isPremiumDeal: self.getNextDealIsPremium() ?? false,
        catteryID: self.getUserID() ?? .init()
    ) {
        didSet {
            self.callBack?()
        }
    }
    private let router: EditDealRouter
    private let interactor: EditDealInteractor
    
    
    init(router: EditDealRouter, interactor: EditDealInteractor, deal: Deal.Input? = nil) {
        self.router = router
        self.interactor = interactor
        
        guard let deal = deal else {
            return
        }
        
        self.deal = deal
    }
    
//    MARK: Requests
    func createDeal(completionHandler: @escaping (Error?) -> Void) {
        self.interactor.createDeal(deal, completionHandler: completionHandler)
    }
    
//    MARK: Notifcation Center
    func notificationCenterManagerPostUpdateProfileScreen() {
        self.interactor.notificationCenterManagerPost(.reloadProfileScreen)
    }
    
//    MARK: User Defaults
    func getUserID() -> UUID? {
        self.interactor.getUserDefaults(.id) as? UUID
    }
    
    func getUserCurrency() -> String? {
        self.interactor.getUserDefaults(.currency) as? String
    }
    
    func getNextDealIsPremium() -> Bool? {
        self.interactor.getUserDefaults(.nextDealIsPremium) as? Bool
    }
    
    func getPremiumUserDate() -> Date? {
        self.interactor.getUserDefaults(.premiumUserDate) as? Date
    }
    
    func setNextDealIsPremium(_ value: Bool) {
        self.interactor.setUserDefaults(value, with: .nextDealIsPremium)
    }
    
//    MARK: Purchase
    func getProducts(_ completionHandler: @escaping ([SKProduct]) -> Void) {
        PurchaseManager.shared.getProducts([.premiumDeal], callBack: completionHandler)
    }
    
    func makePayment(_ product: SKProduct, completionHandler: @escaping (Error?) -> Void) {
        PurchaseManager.shared.makePayment(product, callBack: completionHandler)
    }
    
}
