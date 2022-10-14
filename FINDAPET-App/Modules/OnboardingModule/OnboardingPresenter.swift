//
//  OnboardingPresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 17.08.2022.
//

import Foundation

final class OnboardingPresenter {
    
    private let router: OnboardingRouter
    private let interactor: OnboardingInteractor
    
    init(router: OnboardingRouter, interactor: OnboardingInteractor) {
        self.router = router
        self.interactor = interactor
    }
    
//    MARK: Routing
    
    func goToLogIn() {
        self.router.goToRegistration(mode: .logIn)
    }
    
    func goToSignIn() {
        self.router.goToRegistration(mode: .signIn)
    }
    
}
