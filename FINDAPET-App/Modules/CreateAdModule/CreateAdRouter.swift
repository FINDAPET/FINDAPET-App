//
//  CreateAdRouter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 26.10.2022.
//

import Foundation

final class CreateAdRouter: ProfileCoordinatable {
    
    var coordinatorDelegate: ProfileCoordinator?
    
    func goToProfile() {
        self.coordinatorDelegate?.goToProfile()
    }
    
}
