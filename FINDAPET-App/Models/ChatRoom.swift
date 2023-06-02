//
//  ChatRoom.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 11.10.2022.
//

import Foundation

struct ChatRoom {
    struct Input: Encodable {
        var id: String?
        var usersID: [UUID]
        
        init(id: String? = nil, usersID: [UUID] = [UUID]()) {
            self.id = id
            self.usersID = usersID
        }
    }
    
    struct Output: Decodable {
        var id: String?
        var users: [User.Output]
        var messages: [Message.Output]
    }
}

//MARK: - Extensions
extension ChatRoom.Output: Hashable { }
