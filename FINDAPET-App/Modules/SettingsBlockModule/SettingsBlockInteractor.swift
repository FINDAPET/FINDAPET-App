//
//  SettingsBlockInteractor.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 21.10.2022.
//

import Foundation

final class SettingsBlockInteractor {
    
//    MARK: User Defaults
    func userDefaultsSet(_ value: Any?, key: UserDefaultsKeys) {
        UserDefaultsManager.write(data: value, key: key)
    }
    
    func userDefaultsGet(key: UserDefaultsKeys) -> Any? {
        UserDefaultsManager.read(key: key)
    }
    
//    MARK: Requests
    func changeUserBaseCurrencyName(currencyName: String, completionHandler: @escaping (Error?) -> Void) {
        RequestManager.request(
            method: .PUT,
            authMode: .bearer(value: self.getBearer() ?? String()),
            url: URLConstructor.defaultHTTP.changeUser(baseCurrencyName: currencyName),
            completionHandler: completionHandler
        )
    }
    
//    MARK: Keychain
    private func getBearer() -> String? {
        KeychainManager.shared.read(key: .token)
    }
    
}
