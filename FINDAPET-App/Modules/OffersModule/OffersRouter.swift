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
    
    func goToChatRoom(with id: UUID) {
        
    }
    
}
