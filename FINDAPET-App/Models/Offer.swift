//
//  Offer.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 13.08.2022.
//

import Foundation

struct Offer {
    struct Input: Encodable {
        var id: UUID?
        var price: Int
        var currencyName: String
        var buyerID: UUID
        var dealID: UUID
        var catteryID: UUID
        
        init(id: UUID? = nil, buyerID: UUID, dealID: UUID, catteryID: UUID, price: Int, currencyName: String) {
            self.id = id
            self.price = price
            self.currencyName = currencyName
            self.buyerID = buyerID
            self.dealID = dealID
            self.catteryID = catteryID
        }
    }
    
    struct Output: Decodable {
        var id: UUID?
        var price: Int
        var currencyName: String
        var buyer: User.Output
        var deal: Deal.Output
        var cattery: User.Output
    }
}
