//
//  Complaint.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 05.12.2022.
//

import Foundation

struct Complaint {
    struct Input: Encodable {
        var id: UUID?
        var text: String
        var senderID: UUID
        var dealID: UUID?
        var userID: UUID?
    }
    
    struct Output: Decodable {
        var id: UUID?
        var text: String
        var sender: User.Output
        var createdAt: Date?
        var deal: Deal.Output?
        var user: User.Output?
    }
}
