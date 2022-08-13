//
//  Ad.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 13.08.2022.
//

import Foundation

struct Ad {
    struct Input: Encodable {
        var id: UUID?
        var contentData: Data
        var customerName: String?
        var link: String?
        var catteryID: UUID?
        
        init(id: UUID? = nil, contentData: Data, customerName: String? = nil, link: String? = nil, catteryID: UUID?) {
            self.id = id
            self.contentData = contentData
            self.customerName = customerName
            self.link = link
            self.catteryID = catteryID
        }
    }
    
    struct Output: Decodable {
        var id: UUID?
        var contentData: Data
        var custromerName: String?
        var link: String?
        var cattery: User.Output?
    }
}
