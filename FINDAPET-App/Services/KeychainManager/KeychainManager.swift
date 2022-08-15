//
//  KeychainManager.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 13.08.2022.
//

import Foundation
import KeychainAccess

final class KeychainManager {
    
    static func write(value: String, key: KeychainKeys) {
        Keychain()[key.rawValue] = value
    }
    
    static func read(key: KeychainKeys) -> String? {
        Keychain()[key.rawValue]
    }
    
}
