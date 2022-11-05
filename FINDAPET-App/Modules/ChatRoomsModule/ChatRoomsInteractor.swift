//
//  ChatsInteractor.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 05.11.2022.
//

import Foundation

final class ChatRoomsInteractor {
    
//    MARK: Requests
    func getAllChatRooms(completionHandler: @escaping ([ChatRoom.Output]?, Error?) -> Void) {
        RequestManager.request(
            method: .GET,
            authMode: .bearer(value: self.getBearrerToken() ?? String()),
            url: URLConstructor.defaultHTTP.allChatRooms(),
            completionHandler: completionHandler
        )
    }
    
//    MARK: Keychain
    func getBearrerToken() -> String? {
        KeychainManager.shared.read(key: .token)
    }
    
}
