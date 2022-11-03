//
//  CreateOfferInteractor.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 02.11.2022.
//

import Foundation

final class CreateOfferInteractor {
    
//    MARK: Requests
    func makeOffer(offer: Offer.Input, completionHandler: @escaping (Error?) -> Void) {
        RequestManager.request(
            model: offer,
            method: .POST,
            authMode: .bearer(value: self.getBearrerToken() ?? String()),
            url: URLConstructor.defaultHTTP.newOffer(),
            completionHandler: completionHandler
        )
    }
    
//    MARK: Notification Center
    func notificationCenterManagerPost(_ key: NotificationCenterManagerKeys) {
        NotificationCenterManager.post(key)
    }
    
//    MARK: User Defaults
    func setUserDefaults(_ value: Any?, key: UserDefaultsKeys) {
        UserDefaultsManager.write(data: value, key: key)
    }
    
    func getUserDefaults(key: UserDefaultsKeys) -> Any? {
        UserDefaultsManager.read(key: key)
    }
    
//    MARK: Keychain
    func getBearrerToken() -> String? {
        KeychainManager.shared.read(key: .token)
    }
    
}
