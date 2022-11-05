//
//  ChatsPresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 05.11.2022.
//

import Foundation

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
    func getAllChatRooms(completionHandler: @escaping ([ChatRoom.Output]?, Error?) -> Void) {
        let newCompletionHandler: ([ChatRoom.Output]?, Error?) -> Void = { [ weak self ] chatRooms, error in
            completionHandler(chatRooms, error)
            
            guard error == nil, let chatRooms = chatRooms else {
                return
            }
            
            self?.chatRooms = chatRooms
        }
        
        self.interactor.getAllChatRooms(completionHandler: newCompletionHandler)
    }
    
//    MARK: Routing
    func goToChatRoom(_ chatRoom: ChatRoom.Output) {
        self.router.goToChatRoom(chatRoom)
    }
    
}
