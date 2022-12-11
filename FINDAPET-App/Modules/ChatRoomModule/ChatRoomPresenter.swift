//
//  ChatRoomPresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 05.11.2022.
//

import Foundation

final class ChatRoomPresenter {
    
    var callBack: (() -> Void)?
    private(set) var chatRoom: ChatRoom.Output? {
        didSet {
            if let id = self.getUserID() {
                self.userID = self.chatRoom?.users.filter { $0.id != id }.first?.id
            }
            
            self.callBack?()
        }
    }
    private var userID: UUID?
    private let router: ChatRoomRouter
    private let interactor: ChatRoomInteractor
    
    init(chatRoom: ChatRoom.Output, router: ChatRoomRouter, interactor: ChatRoomInteractor) {
        var chatRoom = chatRoom
        
        chatRoom.messages = chatRoom.messages.sorted { $0.sentDate < $1.sentDate }
        
        self.chatRoom = chatRoom
        self.router = router
        self.interactor = interactor
        self.userID = chatRoom.users.filter { [ weak self ] in $0.id != self?.getUserID() }.first?.id
    }
    
    init(userID: UUID, router: ChatRoomRouter, interactor: ChatRoomInteractor) {
        self.userID = userID
        self.router = router
        self.interactor = interactor
    }
    
//    MARK: Request
    func getChatRoom(comletionHandler: @escaping (ChatRoom.Output?, Error?) -> Void = { _, _ in }) {
        guard let id = self.userID else {
            print("❌ Error: id is equal to nil.")
            
            comletionHandler(nil, RequestErrors.statusCodeError(statusCode: 404))
            
            return
        }
        
        let newCompletionHandler: (ChatRoom.Output?, Error?) -> Void = { [ weak self ] chatRoom, error in
            comletionHandler(chatRoom, error)
            
            guard error == nil, let chatRoom = chatRoom else {
                return
            }
            
            self?.chatRoom = chatRoom
        }
        
        self.interactor.getChatRoom(userID: id, completionHandler: newCompletionHandler)
    }
    
    func viewAllMessages(completionHandler: @escaping (Error?) -> Void = { _ in }) {
        guard let id = chatRoom?.id else {
            print("❌ Error: id is equal to nil.")
            
            completionHandler(RequestErrors.statusCodeError(statusCode: 404))
            
            return
        }
        
        self.interactor.viewAllMessages(with: id, completionHandler: completionHandler)
    }
    
//    MARK: Web Sockets
    func chatRoom(completionHandler: @escaping (Message.Output?, Error?) -> Void = { _, _ in }) {
        guard let id = self.userID else {
            print("❌ Error: id is equal to nil.")
            
            completionHandler(nil, RequestErrors.statusCodeError(statusCode: 404))
            
            return
        }
        
        let newCompletionHandler: (Message.Output?, Error?) -> Void = { [ weak self ] message, error in
            completionHandler(message, error)
            
            guard error == nil, let message = message, self?.chatRoom != nil else {
                return
            }
            
            self?.chatRoom?.messages.append(message)
        }
        
        self.interactor.chatRoom(with: id, completionHandler: newCompletionHandler)
    }
    
    func sendMessage(_ message: Message.Input, completionHandler: @escaping (Error?) -> Void = { _ in }) {
        if let chatRoom = self.chatRoom, let user = chatRoom.users.filter({ $0.id == message.userID }).first {
            self.chatRoom?.messages.append(Message.Output(
                text: message.text,
                isViewed: message.isViewed,
                user: user,
                createdAt: .init(),
                chatRoom: chatRoom
            ))
        }
        
        self.interactor.sendMessage(message: message, completionHander: completionHandler)
    }
    
    func closeWS() {
        self.interactor.closeWS()
    }
    
//    MARK: User Defautls
    func getUserID() -> UUID? {
        guard let string = self.interactor.getUserDefautls(.id) as? String else {
            return nil
        }
        
        return UUID(uuidString: string)
    }
    
    func getUserName() -> String? {
        self.interactor.getUserDefautls(.userName) as? String
    }
    
//    MARK: Notification Center
    func notificationCenterManagerHideNotViewedMessagesCountLabel() {
        self.interactor.notificationCenterManagerPost(
            .hideNotViewedMessagesCountLabelInChatRoomWithID,
            additional: self.chatRoom?.id?.uuidString
        )
    }
    
//    MARK: Routing
    func goToProfile() {
        self.router.goToProfile(userID: self.userID)
    }
    
}
