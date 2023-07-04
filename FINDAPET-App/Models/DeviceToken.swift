//
//  DeviceToken.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 19.05.2023.
//

import Foundation

struct DeviceToken {
    struct Input: Encodable {
        var id: UUID?
        var value: String
        var platform: Platform
        var userID: UUID
    }
    
    struct Output: Decodable {
        var id: UUID?
        var value: String
        var platform: Platform
        var user: User
    }
}
