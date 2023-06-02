//
//  CreateDealInteractor.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 26.11.2022.
//

import Foundation
import StoreKit

final class EditDealInteractor {
    
//    MARK: Properties
    private let petTypeCoreData = coreDataPetTypeManager
    
//    MARK: Requests
    func createDeal(_ deal: Deal.Input, completionHandler: @escaping (Error?) -> Void) {
        RequestManager.request(
            model: deal,
            method: .POST,
            authMode: .bearer(value: self.getBearrerToken() ?? .init()),
            url: URLConstructor.defaultHTTP.newDeal(),
            completionHandler: completionHandler
        )
    }
    
    func changeDeal(_ deal: Deal.Input, completionHandler: @escaping (Error?) -> Void) {
        RequestManager.request(
            model: deal,
            method: .PUT,
            authMode: .bearer(value: self.getBearrerToken() ?? .init()),
            url: URLConstructor.defaultHTTP.changeDeal(),
            completionHandler: completionHandler
        )
    }
    
//    MARK: Notification Center
    func notificationCenterManagerPost(_ key: NotificationCenterManagerKeys, additional parameters: String? = nil) {
        NotificationCenterManager.post(key, additional: parameters)
    }
    
//    MARK: User Defaults
    func getUserDefaults(_ key: UserDefaultsKeys) -> Any? {
        UserDefaultsManager.read(key: key)
    }
    
    func setUserDefaults(_ value: Any?, with key: UserDefaultsKeys) {
        UserDefaultsManager.write(data: value, key: key)
    }
    
//    MARK: Purchase
    func getProducts(_ completionHandler: @escaping ([SKProduct]) -> Void) {
        PurchaseManager.shared.getProducts([.premiumDeal], callBack: completionHandler)
    }
    
    func makePayment(_ product: SKProduct, completionHandler: @escaping (Error?) -> Void) {
        PurchaseManager.shared.makePayment(product, callBack: completionHandler)
    }
    
//    MARK: Keychain
    private func getBearrerToken() -> String? {
        KeychainManager.shared.read(key: .token)
    }
    
//    MARK: Core Data
    func getAllPetTypes(_ completionHandler: @escaping ([PetTypeEntity], Error?) -> Void) {
        self.petTypeCoreData.all(completionHandler)
    }
    
}
