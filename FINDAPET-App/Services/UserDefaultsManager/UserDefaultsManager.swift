//
//  UserDefaultsManager.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 13.08.2022.
//

import Foundation

final class UserDefaultsManager {
    
    static func write(data: Any?, key: UserDefaultsKeys) {
        UserDefaults().set(data, forKey: key.rawValue)
    }
    
    static func read(key: UserDefaultsKeys) -> Any? {
        UserDefaults().object(forKey: key.rawValue)
    }
    
}
