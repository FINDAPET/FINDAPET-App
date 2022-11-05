//
//  ChatRoom.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 11.10.2022.
//

import Foundation

struct ChatRoom {
    struct Input: Encodable {
        var id: UUID?
        var usersID: [UUID]
        
        init(id: UUID? = nil, usersID: [UUID] = [UUID]()) {
            self.id = id
            self.usersID = usersID
        }
    }
    
    struct Output: Decodable {
        var id: UUID?
        var users: [User.Output]
        var messages: [Message.Output]
    }
}
