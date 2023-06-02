//
//  Subscription.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 11.11.2022.
//

import Foundation

struct Subscription: Encodable {        
        struct Input: Encodable {
            var id: UUID?
            var titleSubscriptionID: UUID
            var expirationDate: Date
            var userID: UUID?
        }
        
        struct Output: Decodable {
            var id: UUID?
            var titleSubscription: TitleSubscription
            var expirationDate: Date
            var user: User
            var createdAt: Date?
        }
}

//MARK: - Extensions
extension Subscription.Output: Hashable { }
