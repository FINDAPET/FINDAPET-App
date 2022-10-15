//
//  ProfileInteractor.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 30.08.2022.
//

import Foundation

final class ProfileInteractor {
    
//    MARK: Requests
    
    func getUser(completionHandler: @escaping (User.Output?, Error?) -> Void) {
        RequestManager.request(
            method: .GET,
            authMode: .bearer(value: self.getBearrerToken() ?? ""),
            url: URLConstructor.defaultHTTP.user(),
            completionHandler: completionHandler
        )
    }
    
    func getSomeUser(userID: UUID, completionHandler: @escaping (User.Output?, Error?) -> Void) {
        RequestManager.request(
            method: .GET,
            url: URLConstructor.defaultHTTP.someUser(userID: userID),
            completionHandler: completionHandler
        )
    }
    
    func logOut(completionHandler: @escaping (Error?) -> Void) {
        RequestManager.request(
            method: .DELETE,
            authMode: .bearer(value: self.getBearrerToken() ?? ""),
            url: URLConstructor.defaultHTTP.logOut(),
            completionHandler: completionHandler
        )
    }
    
//    MARK: User Defaults
    
    func getMyID() -> UUID? {
        UserDefaultsManager.read(key: .id) as? UUID
    }
    
    func writeIsFirstEditing() {
        UserDefaultsManager.write(data: true, key: .isFirstEditing)
    }
    
//    MARK: Keychain
    
    func deleteKeychainData() {
        KeychainManager.shared.write(value: nil, key: .token)
        KeychainManager.shared.write(value: nil, key: .email)
        KeychainManager.shared.write(value: nil, key: .password)
    }
    
    private func getBearrerToken() -> String? {
        KeychainManager.shared.read(key: .token)
    }
    
}
