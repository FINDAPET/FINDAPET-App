//
//  Deal.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 13.08.2022.
//

import Foundation

struct Deal {
    struct Input: Encodable {
        var id: UUID?
        var title: String
        var photoDatas: [Data]
        var tags: [String]
        var isPremiumDeal: Bool
        var isActive: Bool
        var mode: String
        var petType: String
        var petBreed: String
        var showClass: String
        var isMale: Bool
        var age: String
        var color: String
        var price: Double
        var currencyName: String
        var catteryID: UUID
        var country: String?
        var city: String?
        var description: String?
        var whatsappNumber: String?
        var telegramUsername: String?
        var instagramUsername: String?
        var facebookUsername: String?
        var vkUsername: String?
        var mail: String?
        var buyerID: UUID?
        
        init(id: UUID? = nil, title: String, photoDatas: [Data], tags: [String] = [String](), isPremiumDeal: Bool = false, isActive: Bool = true, mode: String, petType: String, petBreed: String, showClass: String, isMale: Bool, age: String, color: String, price: Double, currencyName: String, catteryID: UUID, country: String? = nil, city: String? = nil, description: String? = nil, whatsappNumber: String? = nil, telegramUsername: String? = nil, instagramUsername: String? = nil, facebookUsername: String? = nil, vkUsername: String? = nil, mail: String? = nil, buyerID: UUID?) {
            self.id = id
            self.title = title
            self.photoDatas = photoDatas
            self.tags = tags
            self.isPremiumDeal = isPremiumDeal
            self.isActive = isActive
            self.mode = mode
            self.petType = petType
            self.petBreed = petBreed
            self.showClass = showClass
            self.isMale = isMale
            self.age = age
            self.color = color
            self.price = price
            self.catteryID = catteryID
            self.country = country
            self.city = city
            self.description = description
            self.whatsappNumber = whatsappNumber
            self.telegramUsername = telegramUsername
            self.instagramUsername = instagramUsername
            self.facebookUsername = facebookUsername
            self.vkUsername = vkUsername
            self.mail = mail
            self.buyerID = buyerID
            self.currencyName = currencyName
        }
    }
    
    struct Output: Decodable {
        var id: UUID?
        var title: String
        var photoDatas: [Data]
        var tags: [String]
        var isPremiumDeal: Bool
        var isActive: Bool
        var viewsCount: Int
        var mode: String
        var petType: String
        var petBreed: String
        var showClass: String
        var isMale: Bool
        var age: String
        var color: String
        var price: Double
        var currencyName: String
        var cattery: User.Output
        var country: String?
        var city: String?
        var description: String?
        var whatsappNumber: String?
        var telegramUsername: String?
        var instagramUsername: String?
        var facebookUsername: String?
        var vkUsername: String?
        var mail: String?
        var buyer: User.Output?
        var offers: [Offer.Output]
        var score: Int
    }
}
