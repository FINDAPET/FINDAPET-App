//
//  SettingsBlockRouter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 21.10.2022.
//

import Foundation

final class SettingsBlockRouter {
    
    private let goToAction: () -> Void
    
    init(goToAction: @escaping () -> Void) {
        self.goToAction = goToAction
    }
    
    func goTo() {
        self.goToAction()
    }
    
}
