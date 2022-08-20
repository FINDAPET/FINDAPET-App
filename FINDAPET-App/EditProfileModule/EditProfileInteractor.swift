//
//  EditProfileInteractor.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 19.08.2022.
//

import Foundation

final class EditProfileInteractor {
    
//    MARK: Requests
    
    func editUser(model: User.Input, completionHandler: @escaping (Error?) -> Void) {
        RequestManager.request(
            model: model,
            method: .PUT,
            authMode: .bearer(value: self.getToken() ?? ""),
            url: URLConstructor.default.changeUser(),
            completionHandler: completionHandler
        )
    }
    
//    MARK: WebSockets
    
    func webSocket(completionHandler: @escaping (String?, Error?) -> Void) {
        WebSocketManager.webSocket(
            url: URLConstructor.default.userWaitVerify(),
            authMode: .bearer(value: self.getToken() ?? ""),
            completionHandler: completionHandler
        )
    }
    
//    MARK: UserDefaults
    
    func readUserDefaultsProperty(with key: UserDefaultsKeys) -> Any? {
        UserDefaultsManager.read(key: key)
    }
    
    func writeUserDefaultsProperty(_ value: Any, with key: UserDefaultsKeys) {
        UserDefaultsManager.write(data: value, key: key)
    }
    
//    MARK: Notifications
    
    func createNotification(title: String) {
        NotificationManager.sheduleNotification(title: title)
    }
    
//    MARK: Keychain
    
    private func getToken() -> String? {
        KeychainManager.shared.read(key: .token)
    }
    
}
