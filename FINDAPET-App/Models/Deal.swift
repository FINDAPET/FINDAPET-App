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
        var mode: DealMode?
        var petTypeID: UUID?
        var petBreedID: UUID?
        var petClass: PetClass?
        var isMale: Bool?
        var birthDate: String
        var color: String?
        var price: Double?
        var currencyName: Currency
        var catteryID: UUID
        var country: String?
        var city: String?
        var description: String?
        var buyerID: UUID?
        
        init(id: UUID? = nil, title: String, photoDatas: [Data], tags: [String] = .init(), isPremiumDeal: Bool = false, isActive: Bool = true, mode: DealMode? = nil, petTypeID: UUID? = nil, petBreedID: UUID? = nil, petClass: PetClass? = nil, isMale: Bool? = nil, birthDate: Date, color: String? = nil, price: Double? = nil, currencyName: Currency = .USD, catteryID: UUID, country: String? = nil, city: String? = nil, description: String? = nil, buyerID: UUID? = nil) {
            self.id = id
            self.title = title
            self.photoDatas = photoDatas
            self.tags = tags
            self.isPremiumDeal = isPremiumDeal
            self.isActive = isActive
            self.mode = mode
            self.petTypeID = petTypeID
            self.petBreedID = petBreedID
            self.petClass = petClass
            self.isMale = isMale
            self.birthDate = DateFormatter().string(from: birthDate)
            self.color = color
            self.price = price
            self.catteryID = catteryID
            self.country = country
            self.city = city
            self.description = description
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
        var petType: PetType.Output
        var petBreed: PetBreed.Output
        var petClass: PetClass
        var isMale: Bool
        var birthDate: String
        var color: String
        var price: Double?
        var currencyName: String
        var cattery: User.Output
        var country: String?
        var city: String?
        var description: String?
        var buyer: User.Output?
        var offers: [Offer.Output]
        var score: Int
    }
}

//MARK: - Hashable
extension Deal.Output: Hashable { }
