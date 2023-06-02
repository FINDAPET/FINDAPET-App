//
//  KeychainManager.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 13.08.2022.
//

import Foundation
import SimpleKeychain

final class KeychainManager {
    
//    MARK: - Properties
    private let keychain: SimpleKeychain
    
    
//    MARK: - Init
    init(keychain: SimpleKeychain) {
        self.keychain = keychain
    }
    
//    MARK: - Shared
    static let shared = KeychainManager(keychain: .init())
    
//    MARK: Write
    func write(value: String?, key: KeychainKeys) {
        guard let value else {
            do {
                try self.keychain.deleteItem(forKey: key.rawValue)
            } catch {
                print("❌ Error: \(error.localizedDescription)")
            }

            return
        }

        do {
            try self.keychain.set(value, forKey: key.rawValue)
        } catch {
            print("❌ Error: \(error.localizedDescription)")
        }
    }
    
//    MARK: Read
    func read(key: KeychainKeys) -> String? {
        do {
            return try self.keychain.string(forKey: key.rawValue)
        } catch {
            print("❌ Error: \(error.localizedDescription)")
            
            return nil
        }
    }
    
//    MARK: - Delete All
    func delteAll() {
        do {
            try self.keychain.deleteAll()
        } catch {
            print("❌ Error: \(error.localizedDescription)")
        }
    }
    
}
