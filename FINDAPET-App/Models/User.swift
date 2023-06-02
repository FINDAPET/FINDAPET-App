//
//  User.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 13.08.2022.
//

import Foundation
import MessageKit

struct User: Decodable {
    var id: UUID?
    var name: String
    var isActiveCattery: Bool
    var isCatteryWaitVerify: Bool
    var avatarPath: String?
    var documentPath: String?
    var description: String?
    var basicCurrencyName: String
}

//MARK: - Extensions
extension User {
    struct Input: Encodable {
        var id: UUID?
        var name: String
        var avatarData: Data?
        var documentData: Data?
        var description: String?
        var isCatteryWaitVerify: Bool
        var chatRoomsID: [String]
        var countryCode: String?
        var basicCurrencyName: Currency
        
        init(id: UUID? = nil, name: String = "", avatarData: Data? = nil, documentData: Data? = nil, description: String? = nil, isCatteryWaitVerify: Bool = false, chatRoomsID: [String] = .init(), countryCode: String? = nil, basicCurrencyName: Currency = .USD) {
            self.id = id
            self.name = name
            self.avatarData = avatarData
            self.documentData = documentData
            self.description = description
            self.isCatteryWaitVerify = isCatteryWaitVerify
            self.chatRoomsID = chatRoomsID
            self.countryCode = countryCode
            self.basicCurrencyName = basicCurrencyName
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
        var chatRooms: [ChatRoom.Output]
        var score: Int
        var subscription: Subscription.Output?
        var isCatteryWaitVerify: Bool?
    }
}


extension User {
    struct Create: Encodable {
        var email: String
        var password: String
    }
}

extension User {
    struct SenderType: MessageKit.SenderType {
        var senderId: String
        var displayName: String
    }
}

extension User.Output: Hashable { }
extension User: Hashable { }
