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
    
    func viewAllMessages(with id: UUID, completionHandler: @escaping (Error?) -> Void) {
        RequestManager.request(
            method: .PUT,
            authMode: .bearer(value: self.getBearrerToken() ?? .init()),
            url: URLConstructor.defaultHTTP.viewAllMessages(in: id),
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
    
//    MARK: Notification Center
    func notificationCenterManagerPost(_ key: NotificationCenterManagerKeys, additional parameter: String? = nil) {
        NotificationCenterManager.post(key, additional: parameter)
    }
    
//    MARK: Keychain
    private func getBearrerToken() -> String? {
        KeychainManager.shared.read(key: .token)
    }
    
}
