//
//  OnboardingRouter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 17.08.2022.
//

import Foundation

final class OnboardingRouter: RegistrationCoordinatable {
    
    var coordinatorDelegate: RegistrationCoordinator?
    
    func goToRegistration(mode: RegistrationMode) {
        self.coordinatorDelegate?.goToRegistration(mode: mode)
    }
    
}
