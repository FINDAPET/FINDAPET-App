//
//  SearchTitle.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 14.03.2023.
//

import Foundation

struct SearchTitle {
    
    struct Input: Encodable {
        var id: UUID?
        var title: String
        var userID: UUID
    }
    
    struct Output: Decodable {
        var id: UUID?
        var title: String
        var user: User
        var createdAt: String?
    }
    
}
