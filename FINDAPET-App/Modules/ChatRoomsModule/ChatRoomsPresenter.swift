//
//  ChatsPresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 05.11.2022.
//

import Foundation
import UIKit

final class ChatRoomsPresenter {
    
    var callBack: (() -> Void)?
    private let router: ChatRoomsRouter
    private let interactor: ChatRoomsInteractor
    
    init(router: ChatRoomsRouter, interactor: ChatRoomsInteractor) {
        self.router = router
        self.interactor = interactor
    }
    
//    MARK: Properties
    private(set) var chatRooms = [ChatRoom.Output]() {
        didSet {
            self.callBack?()
        }
    }
    
//    MARK: Requests
    func getAllChatRooms(completionHandler: @escaping ([ChatRoom.Output]?, Error?) -> Void = { _, _ in }) {
        let newCompletionHandler: ([ChatRoom.Output]?, Error?) -> Void = { [ weak self ] chatRooms, error in
            completionHandler(chatRooms, error)
            
            guard error == nil, let chatRooms = chatRooms else {
                return
            }
            
            self?.chatRooms = chatRooms.sorted { first, second in
                let firstMessages = first.messages.sorted {
                    ISO8601DateFormatter().date(from: $0.createdAt ?? .init()) ?? .init() >
                    ISO8601DateFormatter().date(from: $1.createdAt ?? .init()) ?? .init()
                }
                let secondMessages = second.messages.sorted {
                    ISO8601DateFormatter().date(from: $0.createdAt ?? .init()) ?? .init() >
                    ISO8601DateFormatter().date(from: $1.createdAt ?? .init()) ?? .init()
                }
                
                return ISO8601DateFormatter().date(from: firstMessages.first?.createdAt ?? .init()) ?? .init() >
                ISO8601DateFormatter().date(from: secondMessages.first?.createdAt ?? .init()) ?? .init()
            }
        }
        
        self.interactor.getAllChatRooms(completionHandler: newCompletionHandler)
    }
    
//    MARK: Web Socket
    func updateUserChats(_ completionHandler: @escaping (String?, Error?) -> Void = { _, _ in }) {
        self.interactor.updateUserChats(completionHandler: completionHandler)
    }
    
    func closeWS(_ completionHandler: @escaping (Error?) -> Void = { _ in }) {
        self.interactor.closeWS(completionHandler)
    }
    
//    MARK: Routing
    func goToChatRoom(_ chatRoom: ChatRoom.Output) {
        self.router.goToChatRoom(chatRoom)
    }
    
//    MARK: - Notification Center
    func notififcationCenterMakeChatRoomsRefreshing(_ observer: Any, action: Selector) {
        self.interactor.notificationCenterManagerAddObserver(observer, name: .makeChatRoomsRefreshing, action: action)
    }
    
    func notificationCenterMakeChatRoomsEmpty(_ observer: Any, action: Selector) {
        self.interactor.notificationCenterManagerAddObserver(observer, name: .makeChatRoomsEmpty, action: action)
    }
    
//    MARK: - Editing
    func makeChatRoomsEmpty() {
        self.chatRooms = .init()
    }
    
}
