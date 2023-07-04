//
//  FeedInteractor.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 11.11.2022.
//

import Foundation

final class FeedInteractor {
    
//    MARK: Requests
    func getDeals(_ filter: Filter, completionHandler: @escaping ([Deal.Output]?, Error?) -> Void) {
        RequestManager.request(
            sendModel: filter,
            method: .PUT,
            authMode: .bearer(value: self.getBearrerToken() ?? .init()),
            url: URLConstructor.defaultHTTP.allDeals(),
            completionHandler: completionHandler
        )
    }
    
    func getRandomAd(completionHandler: @escaping (Ad.Output?, Error?) -> Void) {
        RequestManager.request(
            method: .GET,
            authMode: .bearer(value: self.getBearrerToken() ?? .init()),
            url: URLConstructor.defaultHTTP.randomAd(),
            completionHandler: completionHandler
        )
    }
    
//    MARK: Aplication Requests
    func goTo(url: URL) {
        ApplicationRequestManager.request(url)
    }
    
//    MARK: Notification Center
    func notificationCenterManagerAddObserver(
        _ observer: Any,
        name: NotificationCenterManagerKeys,
        additional parameter: String? = nil,
        action: Selector
    ) {
        NotificationCenterManager.addObserver(observer, name: name, additional: parameter, action: action)
    }
    
//    MARK: Keychain
    private func getBearrerToken() -> String? {
        KeychainManager.shared.read(key: .token)
    }
    
}
