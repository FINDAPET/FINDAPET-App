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
    func makeUserPremium(_ subscription: Subscription, completionHandler: @escaping (Error?) -> Void) {
        self.interactor.makePremium(subscription: subscription, completionHandler: completionHandler)
    }
    
//    MARK: Purchase
    func getSubscriptionProducts(callBack: @escaping ([SKProduct]) -> Void = { _ in }) {
        let newCallBack: ([SKProduct]) -> Void = { [ weak self ] products in
            self?.products = products
            
            callBack(products)
        }
        
        self.interactor.getProducts(with: ProductsID.getSubscriptions(), callBack: newCallBack)
    }
    
    func makePayment(_ product: SKProduct, callBack: @escaping (Error?) -> Void) {
        self.interactor.makePayment(product, callBack: callBack)
    }
    
//    MARK: User Defaults
    func setSubscription(_ value: String) {
        self.interactor.set(value, to: .subscription)
    }
    
    func getSubscription() -> String? {
        self.interactor.get(.subscription) as? String
    }
    
}
