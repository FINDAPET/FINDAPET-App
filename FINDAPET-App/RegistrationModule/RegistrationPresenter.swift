//
//  RegistrationPresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 17.08.2022.
//

import Foundation

final class RegistrationPresenter {
    
    let mode: RegistrationMode
    private let router: RegistrationRouter
    private let interactor: RegistrationInteractor
    
    init(router: RegistrationRouter, interactor: RegistrationInteractor, mode: RegistrationMode) {
        self.router = router
        self.interactor = interactor
        self.mode = mode
    }
    
    var isAgreeWithPrivacyPolicy = false
    
//    MARK: Routing
    
    func goToEditProfile(user: User.Input) {
        self.router.goToEditProfile(user: user)
    }
    
    func goToMainTabBar() {
        self.router.goToMainTabBar()
    }
    
    func goToPrivacyPolicy() {
        self.router.goToPrivacyPolicy()
    }
    
//    MARK: Requests
    
    func createUser(user: User.Create, completionHandler: @escaping (Error?) -> Void) {
        self.isValidData(email: user.email, password: user.password) { [ weak self ] error in
            if let error = error {
                completionHandler(error)
                
                return
            }
            
            self?.interactor.createUser(user: user, completionHandler: completionHandler)
        }
    }
    
    func auth(email: String, password: String, completionHandler: @escaping (UserToken.Output?, Error?) -> Void) {
        let newCompletionHandler: (UserToken.Output?, Error?) -> Void = { [ weak self ] token, error in
            completionHandler(token, error)
            
            if error == nil && token != nil {
                self?.writeKeychainBasic(email: email, password: password)
            }
        }
        
        self.interactor.auth(email: email, password: password, completionHandler: newCompletionHandler)
    }
    
//    MARK: Keychain
    
    func writeKeychainBearer(token: String) {
        self.interactor.writeKeychainBearer(token: token)
    }
    
    private func writeKeychainBasic(email: String, password: String) {
        self.interactor.writeKeychainBasic(email: email, password: password)
    }
    
//    MARK: Registration
    
    private func isValidData(email: String, password: String, completionHandler: @escaping (Error?) -> Void) {
        self.interactor.isValidData(email: email, password: password, completionHandler: completionHandler)
    }
    
}
