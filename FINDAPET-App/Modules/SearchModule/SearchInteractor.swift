//
//  SearchInteractor.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 14.03.2023.
//

import Foundation

final class SearchInteractor {
    
//    MARK: Requests
    func getAll(_ completionHandler: @escaping ([SearchTitle.Output]?, Error?) -> Void) {
        RequestManager.request(
            method: .GET,
            authMode: .bearer(value: self.getBearrerToken() ?? .init()),
            url: URLConstructor.defaultHTTP.getUserSearchTitles(),
            completionHandler: completionHandler
        )
    }
    
    func create(_ model: SearchTitle.Input, completionHandler: @escaping (Error?) -> Void) {
        RequestManager.request(
            model: model,
            method: .POST,
            authMode: .bearer(value: getBearrerToken() ?? .init()),
            url: URLConstructor.defaultHTTP.newSearchTitle(),
            completionHandler: completionHandler
        )
    }
    
//    MARK: User Defaults
    func getUserDefaults(with key: UserDefaultsKeys) -> Any? {
        UserDefaultsManager.read(key: key)
    }
    
//    MARK: Keychain
    private func getBearrerToken() -> String? {
        KeychainManager.shared.read(key: .token)
    }
    
}
