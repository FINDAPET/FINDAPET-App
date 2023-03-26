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
            authMode: .bearer(value: self.getBearrerToken() ?? ""),
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
        guard let string = UserDefaultsManager.read(key: .id) as? String else {
            return nil
        }
        
        return UUID(uuidString: string)
    }
    
    func getCurrency() -> String? {
        UserDefaultsManager.read(key: .currency) as? String
    }
    
    func writeIsFirstEditing() {
        UserDefaultsManager.write(data: true, key: .isFirstEditing)
    }
    
    func setUserDefaults(_ value: Any?, with key: UserDefaultsKeys) {
        UserDefaultsManager.write(data: value, key: key)
    }
    
//    MARK: Notification Center
    func notificationCenterManagerAddObserver(
        _ observer: Any,
        name: NotificationCenterManagerKeys,
        additional parameter: String? = nil,
        action: Selector
    ) {
        NotificationCenterManager.addObserver(observer, name: name, additional: parameter, action: action)
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
