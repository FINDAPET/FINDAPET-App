//
//  ChatRoomInteractor.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 05.11.2022.
//

import Foundation

final class ChatRoomInteractor {
    
//    MARK: Properties
    private var webSocketSender: WebSocketSender?
    
//    MARK: Requests
    func getChatRoom(userID: UUID, completionHandler: @escaping (ChatRoom.Output?, Error?) -> Void) {
        RequestManager.request(
            method: .GET,
            authMode: .bearer(value: self.getBearrerToken() ?? String()),
            url: URLConstructor.defaultHTTP.chatRoomWithUser(userID: userID),
            completionHandler: completionHandler
        )
    }
    
//    MARK: Web Sockets
    func chatRoom(with id: UUID, completionHandler: @escaping (Message.Output?, Error?) -> Void) {
        self.webSocketSender = WebSocketManager.webSocket(
            url: URLConstructor.defaultWS.chatRoomWith(userID: id),
            authMode: .bearer(value: self.getBearrerToken() ?? String()),
            completionHandler: completionHandler
        )
    }
    
    func sendMessage(message: Message.Input, completionHander: @escaping (Error?) -> Void) {
        self.webSocketSender?.send(model: message, completionHandler: completionHander)
    }
    
    func closeWS() {
        self.webSocketSender?.close()
    }
    
//    MARK: User Defaults
    func getUserDefautls(_ key: UserDefaultsKeys) -> Any? {
        UserDefaultsManager.read(key: key)
    }
    
    func setUserDefaults(_ value: Any?, to key: UserDefaultsKeys) {
        UserDefaultsManager.write(data: value, key: key)
    }
    
//    MARK: Keychain
    private func getBearrerToken() -> String? {
        KeychainManager.shared.read(key: .token)
    }
    
}
