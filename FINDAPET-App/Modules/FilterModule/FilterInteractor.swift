//
//  FilterInteractor.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 14.11.2022.
//

import Foundation

final class FilterInteractor {
    
//    MARK: User Defaults
    func getUserDefaults(_ key: UserDefaultsKeys) -> Any? {
        UserDefaultsManager.read(key: key)
    }
    
    func setUserDefaults(_ value: Any?, with key: UserDefaultsKeys) {
        UserDefaultsManager.write(data: value, key: key)
    }
    
}
