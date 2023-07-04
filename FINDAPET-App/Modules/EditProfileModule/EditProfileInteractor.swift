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
            url: URLConstructor.defaultHTTP.changeUser(),
            completionHandler: completionHandler
        )
    }
    
    func createDeviceToken(_ deviceToken: DeviceToken.Input, completionHandler: @escaping (Error?) -> Void) {
        RequestManager.request(
            model: deviceToken,
            method: .POST,
            authMode: .bearer(value: self.getToken() ?? .init()),
            url: URLConstructor.defaultHTTP.createDeviceToken(),
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
        NotificationManager.shared.sheduleNotification(title: title)
    }
    
    func registerForPushNotifications(completionHandler: @escaping (Error?) -> Void) {
        NotificationManager.shared.registerForPushNotifications(completionHandler: completionHandler)
    }
    
//    MARK: - Notification Center
    func notificationCenterManagerAddObserver(
        _ observer: Any,
        name: NotificationCenterManagerKeys,
        additional parameter: String? = nil,
        action: Selector
    ) {
        NotificationCenterManager.addObserver(observer, name: name, additional: parameter, action: action)
    }
    
    func notificationCenterManagerPost(_ name: NotificationCenterManagerKeys, additional: String? = nil) {
        NotificationCenterManager.post(name, additional: additional)
    }
    
//    MARK: Keychain
    
    private func getToken() -> String? {
        KeychainManager.shared.read(key: .token)
    }
    
}
