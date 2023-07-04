//
//  ChatsInteractor.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 05.11.2022.
//

import Foundation

final class ChatRoomsInteractor {
    
//    MARK: - Properties
    private var wsSender: WebSocketSender?
    
//    MARK: Requests
    func getAllChatRooms(completionHandler: @escaping ([ChatRoom.Output]?, Error?) -> Void) {
        RequestManager.request(
            method: .GET,
            authMode: .bearer(value: self.getBearrerToken() ?? String()),
            url: URLConstructor.defaultHTTP.getChats(),
            completionHandler: completionHandler
        )
    }
    
//    MARK: Web Sockets
    func updateUserChats(completionHandler: @escaping (String?, Error?) -> Void) {
        self.wsSender = WebSocketManager.webSocket(
            url: URLConstructor.defaultWS.userUpdate(),
            authMode: .bearer(value: self.getBearrerToken() ?? String()),
            completionHandler: completionHandler
        )
    }
    
    func closeWS(_ completionHandler: @escaping (Error?) -> Void) {
        guard let wsSender else { return }
        
        wsSender.close(completionHandler)
    }
    
//    MARK: Keychain
    func getBearrerToken() -> String? {
        KeychainManager.shared.read(key: .token)
    }
    
//    MARK: - Notification Center
    func notificationCenterManagerAddObserver(
        _ observer: Any,
        name: NotificationCenterManagerKeys,
        additional parameter: String? = nil,
        action: Selector
    ) {
        NotificationCenterManager.addObserver(observer, name: name, additional: parameter, action: action)
    }
    
}
