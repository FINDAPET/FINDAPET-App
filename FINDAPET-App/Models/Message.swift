//
//  Message.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 11.10.2022.
//

import Foundation

struct Message {
    struct Input: Encodable {
        var id: UUID?
        var text: String
        var bodyData: Data?
        var userID: UUID
        var chatRoomID: UUID?
        
        init(id: UUID? = nil, text: String, bodyData: Data? = nil, userID: UUID, chatRoomID: UUID? = nil) {
            self.id = id
            self.text = text
            self.bodyData = bodyData
            self.userID = userID
            self.chatRoomID = chatRoomID
        }
    }
    
    struct Output: Decodable {
        var id: UUID?
        var text: String
        var bodyData: Data?
        var user: User.Output
        var createdAt: Date?
        var chatRoom: ChatRoom.Output
    }
}
