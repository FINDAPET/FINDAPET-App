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
            url: URLConstructor.default.changeUser(),
            completionHandler: completionHandler
        )
    }
    
//    MARK: UserDefaults
    
    func readUserDefaultsProperty(with key: UserDefaultsKeys) -> Any? {
        UserDefaultsManager.read(key:)
    }
    
    func writeUserDefaultsProperty(_ value: Any, with key: UserDefaultsKeys) {
        UserDefaultsManager.write(data: value, key: key)
    }
    
}
