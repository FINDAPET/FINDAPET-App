//
//  SettingsRouter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 21.10.2022.
//

import Foundation

final class SettingsRouter: ProfileCoordinatable {
    
    var coordinatorDelegate: ProfileCoordinator?
    
    func goToProfile(userID: UUID? = nil) {
        self.coordinatorDelegate?.goToProfile(userID: userID)
    }
    
    func getSettingsBlock(
        goToAction: @escaping () -> Void,
        currencyValueTextFieldTapAction: @escaping () -> Void
    ) -> SettingsBlockView? {
        self.coordinatorDelegate?.getSettingsBlock(
            goToAction: goToAction,
            currencyValueTextFieldTapAction: currencyValueTextFieldTapAction
        )
    }
    
}
