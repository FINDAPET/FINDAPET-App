//
//  ChatRoomPresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 05.11.2022.
//

import Foundation

final class ChatRoomPresenter {
    
//    MARK: Properties
    var callBack: (() -> Void)?
    private(set) var chatRoom: ChatRoom.Output? {
        didSet {
            if let id = self.getUserID(), self.userID == nil {
                self.userID = self.chatRoom?.users.filter { $0.id != id }.first?.id
            }
            
            DispatchQueue.main.async { [ weak self ] in self?.callBack?() }
        }
    }
    private var userID: UUID?
    private(set) lazy var myID = self.getUserID()
    private(set) lazy var myName = self.getUserName()
    private let router: ChatRoomRouter
    private let interactor: ChatRoomInteractor
    
//    MARK: Init
    init(chatRoom: ChatRoom.Output, router: ChatRoomRouter, interactor: ChatRoomInteractor) {
        var chatRoom = chatRoom

        chatRoom.messages = chatRoom.messages.sorted {
            ISO8601DateFormatter().date(from: $0.createdAt ?? .init()) ?? .init() > ISO8601DateFormatter().date(from: $1.createdAt ?? .init()) ?? .init()
        }
        
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
    
//    MARK: Editing
    func addID() {
        var string = String()
        
        for id in self.chatRoom?.users.map({ $0.id?.uuidString }).filter({ $0 != nil }) as? [String] ?? .init() {
            string += id
        }
        
        self.chatRoom?.id = string
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
            
            guard error == nil, let chatRoom = chatRoom else { return }
            
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
            
            guard error == nil, let message else { return }
            
            self?.chatRoom?.messages.append(message)
        }
        
        print(id)
        
        self.interactor.chatRoom(with: id, completionHandler: newCompletionHandler)
    }
    
    func sendMessage(_ message: Message.Input, completionHandler: @escaping () -> Void = { }) {
        guard let chatRoom, let user = chatRoom.users.first(where: { $0.id == message.userID }) else { return }
        
        self.chatRoom?.messages.append(
            .init(
                text: message.text,
                isViewed: message.isViewed,
                bodyData: message.bodyData,
                user: user,
                createdAt: ISO8601DateFormatter().string(from: .init()),
                chatRoom: chatRoom
            )
        )
        self.interactor.sendMessage(message: message)
        completionHandler()
    }
    
    func sendString(_ string: String) {
        self.interactor.sendString(string)
    }
    
    func closeWS(_ completionHandler: @escaping (Error?) -> Void = { _ in }) {
        self.interactor.closeWS(completionHandler)
    }
    
//    MARK: Sound Manager
    func playOnSendMessageSound() {
        do {
            try self.interactor.playSound(with: .onSendMessage, for: .mp3)
        } catch {
            print("❌ Error: \(error.localizedDescription)")
        }
    }
    
    func playOnGetMessageSound() {
        do {
            try self.interactor.playSound(with: .onGetMessage, for: .mp3)
        } catch {
            print("❌ Error: \(error.localizedDescription)")
        }
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
    
    func getChatRoomsID() -> [String] {
        (self.interactor.getUserDefautls(.chatRoomsID) as? [String]) ?? .init()
    }
    
//    MARK: Notification Center
    func notificationCenterManagerHideNotViewedMessagesCountLabel() {
        self.interactor.notificationCenterManagerPost(
            .hideNotViewedMessagesCountLabelInChatRoomWithID,
            additional: self.chatRoom?.id
        )
    }
    
    func notificationCenterManagerMakeChatRoomsEmpty() {
        self.interactor.notificationCenterManagerPost(.makeChatRoomsEmpty)
    }
    
    func notificationCenterManagerMakeChatRoomsRefreshing() {
        self.interactor.notificationCenterManagerPost(.makeChatRoomsRefreshing)
    }
    
//    MARK: Routing
    func getProfile() -> ProfileViewController? {
        self.router.getProfile(userID: self.userID)
    }
    
    func getBrowseImage(_ dataSource: BrowseImagesViewControllerDataSource) -> BrowseImagesViewController? {
        self.router.getBrowseImage(dataSource)
    }
    
}
