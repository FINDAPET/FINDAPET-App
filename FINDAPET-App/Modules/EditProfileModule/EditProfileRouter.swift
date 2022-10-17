//
//  EditProfileRouter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 19.08.2022.
//

import Foundation

final class EditProfileRouter: RegistrationCoordinatable {
    
    weak var coordinatorDelegate: RegistrationCoordinator?
    
    func goToMainTabBar() {
        self.coordinatorDelegate?.goToMainTabBar()
    }
    
}
