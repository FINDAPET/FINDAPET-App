//
//  UserToken.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 13.08.2022.
//

import Foundation

struct UserToken {
    struct Input: Encodable {
        var id: UUID?
        var value: String
        var userID: UUID
        
        init(id: UUID? = nil, value: String, userID: UUID) {
            self.id = id
            self.value = value
            self.userID = userID
        }
    }
    
    struct Output: Decodable {
        var id: UUID?
        var value: String
        var user: User
    }
}
