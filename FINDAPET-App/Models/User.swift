//
//  User.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 13.08.2022.
//

import Foundation

struct User: Decodable {
    var id: UUID?
}

extension User {
    struct Input: Encodable {
        var id: UUID?
        var name: String
        var avatarData: Data?
        var documentData: Data?
        var description: String?
        var isCatteryWaitVerify: Bool
        
        init(id: UUID? = nil, name: String = "", avatarData: Data? = nil, documentData: Data? = nil, description: String? = nil, isCatteryWaitVerify: Bool = false) {
            self.id = id
            self.name = name
            self.avatarData = avatarData
            self.documentData = documentData
            self.description = description
            self.isCatteryWaitVerify = isCatteryWaitVerify
        }
    }
}

extension User {
    struct Output: Decodable {
        var id: UUID?
        var name: String
        var avatarData: Data?
        var documentData: Data?
        var description: String?
        var deals: [Deal.Output]
        var boughtDeals: [Deal.Output]
        var ads: [Ad.Output]
        var myOffers: [Offer.Output]
        var offers: [Offer.Output]
    }
}


extension User {
    struct Create: Encodable {
        var email: String
        var password: String
    }
}
