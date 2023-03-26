//
//  SubscriptionInteractor.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 24.10.2022.
//

import Foundation
import StoreKit

final class SubscriptionInteractor {
    
//    MARK: - Requests
    func makePremium(subscription: Subscription, completionHandler: @escaping (Error?) -> Void) {
        RequestManager.request(
            model: subscription,
            method: .PUT,
            authMode: .bearer(value: self.getBearrerToken() ?? .init()),
            url: URLConstructor.defaultHTTP.makeUserPremium(),
            completionHandler: completionHandler
        )
    }
    
//    MARK: - Purchase
    func getProducts(with products: [ProductsID], callBack: @escaping ([SKProduct]) -> Void) {
        PurchaseManager.shared.getProducts(products, callBack: callBack)
    }
    
    func makePayment(_ product: SKProduct, callBack: @escaping (Error?) -> Void) {
        PurchaseManager.shared.makePayment(product, callBack: callBack)
    }
    
//    MARK: - User Defaults
    func get(_ key: UserDefaultsKeys) -> Any? {
        UserDefaultsManager.read(key: key)
    }
    
    func set(_ value: Any?, to key: UserDefaultsKeys) {
        UserDefaultsManager.write(data: value, key: key)
    }
    
//    MARK: Notification Center
    func notificationCenterManagerPost(_ key: NotificationCenterManagerKeys, additional parameters: String? = nil) {
        NotificationCenterManager.post(key, additional: parameters)
    }
    
//    MARK: - Keychain
    private func getBearrerToken() -> String? {
        KeychainManager.shared.read(key: .token)
    }
    
}
