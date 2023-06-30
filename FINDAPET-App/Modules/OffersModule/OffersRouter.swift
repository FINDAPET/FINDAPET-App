//
//  MyOffersRouter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 18.10.2022.
//

import Foundation

final class OffersRouter: ProfileCoordinatable {
    
    var coordinatorDelegate: ProfileCoordinator?
    
    func goToProfile(userID: UUID? = nil) {
        self.coordinatorDelegate?.goToProfile(userID: userID)
    }
    
    func goToChatRoom(chatRoom: ChatRoom.Output? = nil, userID: UUID? = nil) {
        self.coordinatorDelegate?.goToChatRoom(chatRoom: chatRoom, userID: userID)
    }
    
    func goToDeal(deal: Deal.Output) {
        self.coordinatorDelegate?.goToDeal(deal: deal)
    }
    
}
