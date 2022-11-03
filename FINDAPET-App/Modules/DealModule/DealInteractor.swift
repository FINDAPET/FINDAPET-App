//
//  DealInteractor.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 30.10.2022.
//

import Foundation

final class DealInteractor {
    
//    MARK: Requests
    func getDeal(dealID: UUID, completionHandler: @escaping (Deal.Output?, Error?) -> Void) {
        RequestManager.request(
            method: .GET,
            authMode: .bearer(value: self.getBearrerToken() ?? String()),
            url: URLConstructor.defaultHTTP.someDeal(dealID: dealID),
            completionHandler: completionHandler
        )
    }
    
    func deleteDeal(with id: UUID, competionHandler: @escaping (Error?) -> Void) {
        RequestManager.request(
            method: .DELETE,
            authMode: .bearer(value: self.getBearrerToken() ?? String()),
            url: URLConstructor.defaultHTTP.deleteDeal(dealID: id),
            completionHandler: competionHandler
        )
    }
    
//    MARK: User Defaults
    func getUserDefaults(_ key: UserDefaultsKeys) -> Any? {
        UserDefaultsManager.read(key: key)
    }
    
    func setUserDefaults(_ value: Any?, to key: UserDefaultsKeys) {
        UserDefaultsManager.write(data: value, key: key)
    }
    
//    MARK: Notification Center
    func notificationCenterManagerPost(_ key: NotificationCenterManagerKeys) {
        NotificationCenterManager.post(key)
    }
    
//    MARK: Keychain
    private func getBearrerToken() -> String? {
        KeychainManager.shared.read(key: .token)
    }
    
}
