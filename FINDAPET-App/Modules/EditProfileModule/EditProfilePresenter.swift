//
//  EditProfilePresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 19.08.2022.
//

import Foundation

final class EditProfilePresenter {
    
    var user: User.Input
    let isCatteryWaitVerify: Bool
    private let router: EditProfileRouter
    private let interactor: EditProfileInteractor
    
    init(router: EditProfileRouter, interactor: EditProfileInteractor, user: User.Input){
        self.user = user
        self.router = router
        self.interactor = interactor
        self.isCatteryWaitVerify = user.isCatteryWaitVerify
    }
    
//    MARK: Routing
    
    func goToMainTabBar() {
        self.router.goToMainTabBar()
    }
    
//    MARK: Requests
    
    func editUser(completionHandler: @escaping (Error?) -> Void) {
        self.interactor.editUser(model: self.user, completionHandler: completionHandler)
    }
    
    func createDeviceToken(_ completionHandler: @escaping (Error?) -> Void = { _ in }) {
        guard let token = self.readUserDefaultsDeviceToken(), let id = self.getUserID() else {
            print("❌ Error: device token or user id is equal to nil.")
            
            completionHandler(RequestErrors.encodingFailed)
            
            return
        }
        
        self.interactor.createDeviceToken(
            .init(value: token, platform: .iOS, userID: id),
            completionHandler: completionHandler
        )
    }
    
//    MARK: UserDefaults
    
    func readUserDefaultsIsFirstEdititng() -> Bool {
        self.interactor.readUserDefaultsProperty(with: .isFirstEditing) as? Bool ?? true
    }
    
    func writeUserDefaultsIsFirstEdititng() {
        self.interactor.writeUserDefaultsProperty(false, with: .isFirstEditing)
    }
    
    func readUserDefaultsDeviceToken() -> String? {
        self.interactor.readUserDefaultsProperty(with: .deviceToken) as? String
    }
    
    func writeUserDefaultsUserName() {
        self.interactor.writeUserDefaultsProperty(self.user.name, with: .userName)
    }
    
    func getUserID() -> UUID? {
        .init(uuidString: self.interactor.readUserDefaultsProperty(with: .id) as? String ?? .init())
    }
    
//    MARK: - Notifications
    func createNotification(title: String) {
        self.interactor.createNotification(title: title)
    }
    
    func registerForPushNotifications(_ completionHandler: @escaping (Error?) -> Void = { _ in }) {
        self.interactor.registerForPushNotifications(completionHandler: completionHandler)
    }
    
//    MARK: - Notification Center
    func postNotificationCenterReloadProfileScreen() {
        self.interactor.notificationCenterManagerPost(.reloadProfileScreen)
    }
    
}
