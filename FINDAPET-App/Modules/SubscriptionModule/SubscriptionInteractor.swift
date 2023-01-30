//
//  SubscriptionInteractor.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 24.10.2022.
//

import Foundation

final class SubscriptionInteractor {
    
//    MARK: Requests
    func makePremium(subscription: Subscription.Input, completionHandler: @escaping (Error?) -> Void) {
        RequestManager.request(
            model: subscription,
            method: .POST,
            authMode: .bearer(value: self.getBearrerToken() ?? .init()),
            url: URLConstructor.defaultHTTP.newSubscriptions(),
            completionHandler: completionHandler
        )
    }
    
    func getSubscrptions(completionHandler: @escaping ([TitleSubscription]?, Error?) -> Void) {
        RequestManager.request(
            method: .GET,
            authMode: .bearer(value: self.getBearrerToken() ?? .init()),
            url: URLConstructor.defaultHTTP.titleSubscriptions(),
            completionHandler: completionHandler
        )
    }
    
//    MARK: User Defaults
    func get(_ key: UserDefaultsKeys) -> Any? {
        UserDefaultsManager.read(key: key)
    }
    
    func set(_ value: Any?, to key: UserDefaultsKeys) {
        UserDefaultsManager.write(data: value, key: key)
    }
    
//    MARK: Keychain
    private func getBearrerToken() -> String? {
        KeychainManager.shared.read(key: .token)
    }
    
}
