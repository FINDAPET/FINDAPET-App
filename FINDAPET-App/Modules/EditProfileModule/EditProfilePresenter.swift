//
//  EditProfilePresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 19.08.2022.
//

import Foundation

final class EditProfilePresenter {
    
    var user: User.Input
    private let router: EditProfileRouter
    private let interactor: EditProfileInteractor
    
    init(router: EditProfileRouter, interactor: EditProfileInteractor, user: User.Input) {
        self.user = user
        self.router = router
        self.interactor = interactor
    }
    
//    MARK: Routing
    
    func goToMainTabBar() {
        self.router.goToMainTabBar()
    }
    
//    MARK: Requests
    
    func editUser(completionHandler: @escaping (Error?) -> Void) {
        self.interactor.editUser(model: self.user, completionHandler: completionHandler)
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
    
//    MARK: Notifications
    
    func createNotification(title: String) {
        self.interactor.createNotification(title: title)
    }
    
}
