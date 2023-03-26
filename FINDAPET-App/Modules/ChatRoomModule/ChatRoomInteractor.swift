//
//  ChatRoomInteractor.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 05.11.2022.
//

import Foundation
import Gzip

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
    
    func viewAllMessages(with id: String, completionHandler: @escaping (Error?) -> Void) {
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
            authMode: .bearer(value: self.getBearrerToken() ?? .init())) { data, error in
                guard let data = (try? data?.gunzipped()) ?? data,
                      let model = try? JSONSerialization.jsonObject(with: data) as? [String : Any],
                      let isViewed = model["isViewed"] as? Bool else {
                    print("❌ Error: decodint failed.")
                    
                    DispatchQueue.main.async {
                        completionHandler(nil, RequestErrors.decodingFailed)
                    }
                    
                    return
                }
                
                completionHandler(.init(
                    id: model["id"] as? UUID,
                    text: model["text"] as? String,
                    isViewed: isViewed,
                    bodyData: model["bodyData"] as? Data,
                    user: .init(
                        id: (model["user"] as? [String : Any])?["id"] as? UUID,
                        name: .init(),
                        deals: .init(),
                        boughtDeals: .init(),
                        ads: .init(),
                        myOffers: .init(),
                        offers: .init(),
                        chatRooms: .init(),
                        score: .zero,
                        isPremiumUser: .random()
                    ),
                    createdAt: model["createdAt"] as? String,
                    chatRoom: .init(
                        id: (model["chatRoom"] as? [String : Any])?["id"] as? String,
                        users: .init(),
                        messages: .init()
                    )
                ), nil)
            }
    }
    
    func sendMessage(message: Message.Input, completion: @escaping () -> Void = { }) {
        self.webSocketSender?.send(message, completion: completion)
    }
    
    func sendString(_ string: String, completion: @escaping () -> Void = { }) {
        self.webSocketSender?.send(string, completion: completion)
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
    
//    MARK: Sound Manager
    func playSound(with name: SoundFileName, for type: SoundFileType) throws {
        try SoundManager.playSound(with: name, of: type)
    }
    
//    MARK: Keychain
    private func getBearrerToken() -> String? {
        KeychainManager.shared.read(key: .token)
    }
    
}
