//
//  CreateAdInteractor.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 26.10.2022.
//

import Foundation

final class CreateAdInteractor {
    
//    MARK: Requests
    func createAd(ad: Ad.Input, completionHandler: @escaping (Error?) -> Void) {
        RequestManager.request(
            model: ad,
            method: .POST,
            authMode: .bearer(value: self.getBearerToken() ?? String()),
            url: URLConstructor.defaultHTTP.newAd(),
            completionHandler: completionHandler
        )
    }
    
    func getUser(completionHandler: @escaping (User.Output?, Error?) -> Void) {
        RequestManager.request(
            method: .GET,
            authMode: .bearer(value: self.getBearerToken() ?? String()),
            url: URLConstructor.defaultHTTP.user(),
            completionHandler: completionHandler
        )
    }
    
//    MARK: Keychain
    private func getBearerToken() -> String? {
        KeychainManager.shared.read(key: .token)
    }
    
}
