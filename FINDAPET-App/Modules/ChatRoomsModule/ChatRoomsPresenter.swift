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
    private(set) var chatRooms = [ChatRoom.Output(users: [User.Output(id: UUID(uuidString: "514BA760-F705-4FF2-9997-B723BA117185"), name: "Me", avatarData: UIImage(systemName: "globe")?.pngData(), deals: [Deal.Output](), boughtDeals: [Deal.Output](), ads: [Ad.Output](), myOffers: [Offer.Output](), offers: [Offer.Output](), chatRooms: [ChatRoom.Output](), isPremiumUser: true), User.Output(id: UUID(), name: "Not Me", avatarData: UIImage(named: "empty avatar")?.pngData(), deals: [Deal.Output](), boughtDeals: [Deal.Output](), ads: [Ad.Output](), myOffers: [Offer.Output](), offers: [Offer.Output](), chatRooms: [ChatRoom.Output](), isPremiumUser: true)], messages: [Message.Output(text: "It's me!", user: User.Output(id: UUID(uuidString: "514BA760-F705-4FF2-9997-B723BA117185"), name: "Me", avatarData: UIImage(systemName: "globe")?.pngData(), deals: [Deal.Output](), boughtDeals: [Deal.Output](), ads: [Ad.Output](), myOffers: [Offer.Output](), offers: [Offer.Output](), chatRooms: [ChatRoom.Output](), isPremiumUser: true), createdAt: Date(), chatRoom: ChatRoom.Output(users: [User.Output](), messages: [Message.Output]())), Message.Output(text: "It's not me!", user: User.Output(id: UUID(), name: "Not Me", avatarData: UIImage(systemName: "globe")?.pngData(), deals: [Deal.Output](), boughtDeals: [Deal.Output](), ads: [Ad.Output](), myOffers: [Offer.Output](), offers: [Offer.Output](), chatRooms: [ChatRoom.Output](), isPremiumUser: true), createdAt: Date(), chatRoom: ChatRoom.Output(users: [User.Output](), messages: [Message.Output]()))])] {
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
            
            self?.chatRooms = chatRooms.sorted {
                $0.messages.sorted {
                    $0.sentDate < $1.sentDate
                }
                .first?.sentDate ?? Date() < $1.messages.sorted {
                    $0.sentDate < $1.sentDate
                }
                .first?.sentDate ?? Date()
            }
        }
        
        self.interactor.getAllChatRooms(completionHandler: newCompletionHandler)
    }
    
//    MARK: Web Socket
    func updateUserChats() {
        self.interactor.updateUserChats { message, error in
            guard error == nil, message != nil else {
                return
            }
            
            self.getAllChatRooms()
        }
    }
    
//    MARK: Routing
    func goToChatRoom(_ chatRoom: ChatRoom.Output) {
        self.router.goToChatRoom(chatRoom)
    }
    
}
