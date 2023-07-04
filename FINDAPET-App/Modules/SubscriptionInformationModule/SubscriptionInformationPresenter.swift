//
//  SubscriptionInformationPresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 17.03.2023.
//

import Foundation

final class SubscriptionInformationPresenter {
    
//    MARK: Properties
    private let router: SubscriptionInformationRouter
    private let interactor: SubscriptionInformationInteractor
    
//    MARK: Init
    init(router: SubscriptionInformationRouter, interactor: SubscriptionInformationInteractor) {
        self.router = router
        self.interactor = interactor
    }
    
//    MARK: User Defaults
    func getPremiumUserDate() -> Date? {
        self.interactor.userDefaultsGet(with: .premiumUserDate) as? Date
    }
    
}
