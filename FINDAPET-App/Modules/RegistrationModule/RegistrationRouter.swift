//
//  RegistrationRouter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 17.08.2022.
//

import Foundation

final class RegistrationRouter: RegistrationCoordinatable {
    
    var coordinatorDelegate: RegistrationCoordinator?
    
    func goToEditProfile(user: User.Input) {
        self.coordinatorDelegate?.goToEditProfile(user: user)
    }
    
    func goToMainTabBar() {
        self.coordinatorDelegate?.goToMainTabBar()
    }
    
    func goToPrivacyPolicy() {
        self.coordinatorDelegate?.goToPrivacyPolicy()
    }
    
}
