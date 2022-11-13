//
//  DealRouter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 30.10.2022.
//

import Foundation

final class DealRouter: ProfileCoordinatable {
    
    var coordinatorDelegate: ProfileCoordinator?
    
    func goToProfile(with id: UUID? = nil) {
        self.coordinatorDelegate?.goToProfile(userID: id)
    }
    
    func goToChatRoom(chatRoom: ChatRoom.Output? = nil, userID: UUID? = nil) {
        self.coordinatorDelegate?.goToChatRoom(chatRoom: chatRoom, userID: userID)
    }
    
    func getCreateOffer(deal: Deal.Output) -> CreateOfferViewController? {
        self.coordinatorDelegate?.getCreateOffer(deal: deal)
    }
    
}
