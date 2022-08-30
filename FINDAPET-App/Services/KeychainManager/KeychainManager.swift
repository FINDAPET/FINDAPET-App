//
//  KeychainManager.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 13.08.2022.
//

import Foundation
import KeychainAccess

final class KeychainManager {
    
    private let keychain: Keychain
    
    init(keychain: Keychain) {
        self.keychain = keychain
    }
    
    static let shared = KeychainManager(keychain: Keychain())
    
    func write(value: String?, key: KeychainKeys) {
        self.keychain[key.rawValue] = value
    }
    
    func read(key: KeychainKeys) -> String? {
        self.keychain[key.rawValue]
    }
    
}
