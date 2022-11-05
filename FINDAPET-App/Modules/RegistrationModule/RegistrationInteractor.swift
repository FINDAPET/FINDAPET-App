//
//  RegistrationInteractor.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 17.08.2022.
//

import Foundation

final class RegistrationInteractor {
    
//    MARK: Rquests
    
    func createUser(user: User.Create, completionHandler: @escaping (Error?) -> Void) {
        RequestManager.request(
            model: user,
            method: .POST,
            url: URLConstructor.defaultHTTP.newUser(),
            completionHandler: completionHandler
        )
    }
    
    func auth(email: String, password: String, completionHandler: @escaping (UserToken.Output?, Error?) -> Void) {
        RequestManager.request(
            method: .GET,
            authMode: .base(email: email, password: password),
            url: URLConstructor.defaultHTTP.auth(),
            completionHandler: completionHandler
        )
    }
    
//    MARK: Keychain
    
    func writeKeychainBasic(email: String, password: String) {
        KeychainManager.shared.write(value: email, key: .email)
        KeychainManager.shared.write(value: password, key: .password)
    }
    
    func writeKeychainBearer(token: String) {
        KeychainManager.shared.write(value: token, key: .token)
    }
    
//    MARK: Registration
    
    func isValidData(email: String, password: String, completionHandler: @escaping (Error?) -> Void) {
        RegistrationManager.isValidData(email: email, password: password, completionHandler: completionHandler)
    }
    
//    MARK: User Defaults
    
    func write(key: UserDefaultsKeys, data: Any) {
        UserDefaultsManager.write(data: data, key: key)
    }
    
}
