//
//  Subscription.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 11.11.2022.
//

import Foundation

struct Subscription {
    typealias CountryCode = String
    
    struct Input: Encodable {
        var id: UUID?
        var localizedNames: [CountryCode : String]
        var expirationDate: Date
        var userID: UUID?
    }
    
    struct Output: Decodable {
        var id: UUID?
        var localizedNames: [CountryCode : String]
        var expirationDate: Date
        var user: User
        var createdAt: Date?
    }
}
