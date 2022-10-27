//
//  SubscriptionInteractor.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 24.10.2022.
//

import Foundation
import StoreKit

final class SubscriptionInteractor {
    
//    MARK: Purchase
    func getProducts(with productsID: [ProductsID], callBack: @escaping ([SKProduct]) -> Void) {
        PurchaseManager.shared.getProducts(productsID, callBack: callBack)
    }
    
    func makePayment(_ product: SKProduct, callBack: @escaping (Error?) -> Void) {
        PurchaseManager.shared.makePayment(product, callBack: callBack)
    }
    
//    MARK: User Defaults
    func get(_ key: UserDefaultsKeys) -> Any? {
        UserDefaultsManager.read(key: key)
    }
    
    func set(_ value: Any?, to key: UserDefaultsKeys) {
        UserDefaultsManager.write(data: value, key: key)
    }
    
}
