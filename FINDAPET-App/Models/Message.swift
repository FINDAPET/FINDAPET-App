//
//  Message.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 11.10.2022.
//

import Foundation
import MessageKit
import UIKit

struct Message {
    struct Input: Encodable {
        var id: UUID?
        var text: String?
        var isViewed: Bool
        var bodyData: Data?
        var userID: UUID
        var chatRoomID: String?
        
        init(
            id: UUID? = nil,
            text: String? = nil,
            isViewed: Bool = false,
            bodyData: Data? = nil,
            userID: UUID,
            chatRoomID: String? = nil
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
        var text: String?
        var isViewed: Bool
        var bodyData: Data?
        var user: User.Output
        var createdAt: String?
        var chatRoom: ChatRoom.Output
    }
}

extension Message {
    struct MessageType: MessageKit.MessageType {
        var sender: MessageKit.SenderType
        var messageId: String
        var sentDate: Date
        var kind: MessageKit.MessageKind
    }
}

extension Message {
    struct MediaItem: MessageKit.MediaItem {
        var url: URL?
        var size: CGSize
        var image: UIImage?
        var placeholderImage: UIImage
    }
}
