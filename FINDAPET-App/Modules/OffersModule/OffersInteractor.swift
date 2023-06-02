//
//  MyOffersInteractor.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 18.10.2022.
//

import Foundation

final class OffersInteractor {
    
//    MARK: Requests
    func getUserOffers(userID: UUID, completionHandler: @escaping ([Offer.Output]?, Error?) -> Void) {
        RequestManager.request(
            method: .GET,
            url: URLConstructor.defaultHTTP.someUserOffers(userID: userID),
            completionHandler: completionHandler
        )
    }
    
    func getUserMyOffers(userID: UUID, completionHandler: @escaping ([Offer.Output]?, Error?) -> Void) {
        RequestManager.request(
            method: .GET,
            authMode: .bearer(value: self.getBearerToken() ?? String()),
            url: URLConstructor.defaultHTTP.someUserMyOffers(userID: userID),
            completionHandler: completionHandler
        )
    }
    
    func acceptOffer(dealID: UUID, offerID: UUID, completionHandler: @escaping (Error?) -> Void) {
        RequestManager.request(
            method: .POST,
            authMode: .bearer(value: self.getBearerToken() ?? String()),
            url: URLConstructor.defaultHTTP.soldDeal(dealID: dealID, offerID: offerID),
            completionHandler: completionHandler
        )
    }
    
    func deleteOffer(offerID: UUID, completionHandler: @escaping (Error?) -> Void) {
        RequestManager.request(
            method: .DELETE,
            authMode: .bearer(value: self.getBearerToken() ?? .init()),
            url: URLConstructor.defaultHTTP.deleteOffer(offerID: offerID),
            completionHandler: completionHandler
        )
    }
    
//    MARK: Keychain Manager
    private func getBearerToken() -> String? {
        KeychainManager.shared.read(key: .token)
    }
    
}
