//
//  SubscriptionPresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 24.10.2022.
//

import Foundation
import StoreKit

final class SubscriptionPresenter {
    
    var callBack: (() -> Void)?
    private let router: SubscriptionRouter
    private let interactor: SubscriptionInteractor
    
    init(router: SubscriptionRouter, interactor: SubscriptionInteractor) {
        self.router = router
        self.interactor = interactor
    }
    
//    MARK: Properties
    private(set) var products = [SKProduct]() {
        didSet {
            self.callBack?()
        }
    }
    
//    MARK: Requestss
    func makeUserPremium(_ subscription: Subscription, completionHandler: @escaping (Error?) -> Void = { _ in }) {
        self.interactor.makePremium(subscription: subscription, completionHandler: completionHandler)
    }
    
    func getSubscriptionsProducts(callBack: @escaping ([SKProduct]) -> Void = { _ in }) {
        let newCallBack: ([SKProduct]) -> Void = { [ weak self ] products in
            callBack(products)
            
            self?.products = products
        }
        
        self.interactor.getProducts(with: ProductsID.getSubscriptions(), callBack: newCallBack)
    }
    
    func makePayment(_ product: SKProduct, callBack: @escaping (Error?) -> Void) {
        self.interactor.makePayment(product, callBack: callBack)
    }
    
//    MARK: Notification Center
    func reloadProfileScreen() {
        self.interactor.notificationCenterManagerPost(.reloadProfileScreen)
    }
    
//    MARK: User Defaults
    func setPremiumUserDate(_ value: Date) {
        self.interactor.set(value, to: .premiumUserDate)
    }
    
    func setSubscription(_ value: ProductsID) {
        self.interactor.set(value.rawValue, to: .subscription)
    }
    
    func getSubscription() -> String? {
        self.interactor.get(.subscription) as? String
    }
    
    func getUserID() -> String? {
        self.interactor.get(.id) as? String
    }
    
//    MARK: Routing
    func getSubscriptionInforamation() -> SubscriptionInformationView? {
        self.router.getSubscriptionInforamation()
    }
    
}
