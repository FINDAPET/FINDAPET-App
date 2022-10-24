//
//  SettingsBlockPresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 21.10.2022.
//

import Foundation

final class SettingsBlockPresenter {
    
    let currencyValueTextFieldTapAction: () -> Void
    private let router: SettingsBlockRouter
    private let interactor: SettingsBlockInteractor
    
    init(router: SettingsBlockRouter, interactor: SettingsBlockInteractor, currencyValueTextFieldTapAction: @escaping () -> Void) {
        self.router = router
        self.interactor = interactor
        self.currencyValueTextFieldTapAction = currencyValueTextFieldTapAction
    }
    
//    MARK: User Defaults
    func getUserCurrency() -> String? {
        self.interactor.userDefaultsGet(key: .currency) as? String
    }
    
    func getUserCountry() -> String? {
        self.interactor.userDefaultsGet(key: .country) as? String
    }
    
    func getUserCity() -> String? {
        self.interactor.userDefaultsGet(key: .city) as? String
    }
    
    func setUserCurrency(_ currency: Currency) {
        self.interactor.userDefaultsSet(currency.rawValue, key: .currency)
    }
    
    func setUserCountry(_ country: String) {
        self.interactor.userDefaultsSet(country, key: .country)
    }
    
    func setUserCity(_ city: String) {
        self.interactor.userDefaultsSet(city, key: .city)
    }
    
//    MARK: Routing
    func goTo() {
        self.router.goTo()
    }
    
//    MARK: Requests
    func changeUserBaseCurrencyName(currencyName: String, completionHandler: @escaping (Error?) -> Void) {
        self.interactor.changeUserBaseCurrencyName(currencyName: currencyName, completionHandler: completionHandler)
    }
    
}
