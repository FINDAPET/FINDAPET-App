//
//  NotificationScreenInteractor.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 09.12.2022.
//

import Foundation

final class NotificationScreenInteractor {
    
//    MARK: User Defaults
    func getUserDefaults(_ key: UserDefaultsKeys) -> Any? {
        UserDefaultsManager.read(key: key)
    }
    
    func setUserDefaults(_ value: Any?, with key: UserDefaultsKeys) {
        UserDefaultsManager.write(data: value, key: key)
    }
    
}
