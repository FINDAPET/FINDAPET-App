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
        var buyerID: UUID
        var dealID: UUID
        var catteryID: UUID
        
        init(id: UUID? = nil, buyerID: UUID, dealID: UUID, catteryID: UUID) {
            self.id = id
            self.buyerID = buyerID
            self.dealID = dealID
            self.catteryID = catteryID
        }
    }
    
    struct Output: Decodable {
        var id: UUID?
        var buyer: User.Output
        var deal: Deal.Output
        var cattery: User.Output
    }
}
