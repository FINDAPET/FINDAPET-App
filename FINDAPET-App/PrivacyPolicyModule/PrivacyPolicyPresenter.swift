//
//  PrivacyPolicyPresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 26.08.2022.
//

import Foundation

final class PrivacyPolicyPresenter {
    
    private let router: PrivacyPolicyRouter
    private let interactor: PrivacyPolicyInteractor
    
    init(router: PrivacyPolicyRouter, interactor: PrivacyPolicyInteractor) {
        self.router = router
        self.interactor = interactor
    }
    
}
