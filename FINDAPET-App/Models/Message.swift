//
//  Message.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 11.10.2022.
//

import Foundation
import MessageKit

struct Message {
    struct Input: Encodable {
        var id: UUID?
        var text: String
        var isViewed: Bool
        var bodyData: Data?
        var userID: UUID
        var chatRoomID: UUID?
        
        init(
            id: UUID? = nil,
            text: String,
            isViewed: Bool = false,
            bodyData: Data? = nil,
            userID: UUID,
            chatRoomID: UUID? = nil
        ) {
            self.id = id
            self.text = text
            self.isViewed = isViewed
            self.bodyData = bodyData
            self.userID = userID
            self.chatRoomID = chatRoomID
        }
    }
    
    struct Output: Decodable {
        var id: UUID?
        var text: String
        var isViewed: Bool
        var bodyData: Data?
        var user: User.Output
        var createdAt: Date?
        var chatRoom: ChatRoom.Output
    }
}

extension Message.Output: MessageType {
    
    var sender: MessageKit.SenderType { self.user }
    var messageId: String { self.id?.uuidString ?? String() }
    var sentDate: Date { self.createdAt ?? Date() }
    var kind: MessageKit.MessageKind { .text(self.text) }
    
}
