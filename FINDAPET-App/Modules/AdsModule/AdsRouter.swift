//
//  AdsRouter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 19.10.2022.
//

import Foundation

final class AdsRouter: ProfileCoordinatable {
    
    var coordinatorDelegate: ProfileCoordinator?
    
    func goToProfile(userID: UUID? = nil) {
        self.coordinatorDelegate?.goToProfile(userID: userID)
    }
    
}
