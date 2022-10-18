//
//  MyOffersInteractor.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 18.10.2022.
//

import Foundation

final class MyOffersInteractor {
    
//    MARK: Requests
    func getUserOffers(userID: UUID, completionHandler: @escaping ([Offer.Output]?, Error?) -> Void) {
        RequestManager.request(
            method: .GET,
            url: URLConstructor.defaultHTTP.someUserOffers(userID: userID),
            completionHandler: completionHandler
        )
    }
    
}
