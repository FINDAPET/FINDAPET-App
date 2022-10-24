//
//  SettingsPresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 21.10.2022.
//

import Foundation

final class SettingsPresenter {
    
    private let router: SettingsRouter
    private let interator: SettingsInteractor
    
    init(router: SettingsRouter, interator: SettingsInteractor) {
        self.router = router
        self.interator = interator
    }
    
//    MARK: Routing
    func goToProfile(userID: UUID? = nil) {
        self.router.goToProfile(userID: userID)
    }
    
    func getSettingsBlock(
        goToAction: @escaping () -> Void,
        currencyValueTextFieldTapAction: @escaping () -> Void
    ) -> SettingsBlockView? {
        self.router.getSettingsBlock(goToAction: goToAction, currencyValueTextFieldTapAction: currencyValueTextFieldTapAction)
    }
    
//    MARK: User Defaults
    func getAllCurrencies() -> [Currency] {
        self.interator.getAllCurrencies()
    }
    
}
