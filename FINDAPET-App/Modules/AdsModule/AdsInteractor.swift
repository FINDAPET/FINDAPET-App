//
//  AdsInteractor.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 19.10.2022.
//

import Foundation

final class AdsInteractor {
    
//    MARK: Requests
    func getAds(userID: UUID, completionHandler: @escaping ([Ad.Output]?, Error?) -> Void) {
        RequestManager.request(
            method: .GET,
            authMode: .bearer(value: self.getBearerToken() ?? String()),
            url: URLConstructor.defaultHTTP.someUserAds(userID: userID),
            completionHandler: completionHandler
        )
    }
    
//    MARK: Application Requests
    func goTo(url: URL) {
        ApplicationRequestManager.request(url)
    }
    
//    MARK: Keychain
    private func getBearerToken() -> String? {
        KeychainManager.shared.read(key: .token)
    }
    
}
