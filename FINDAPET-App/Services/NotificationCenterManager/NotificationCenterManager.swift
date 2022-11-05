//
//  NotificationCenterManager.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 30.10.2022.
//

import Foundation

final class NotificationCenterManager {
    
    static func addObserver(_ observer: Any, name: NotificationCenterManagerKeys, action: Selector) {
        NotificationCenter.default.addObserver(observer, selector: action, name: .init(name.rawValue), object: nil)
    }
    
    static func post(_ name: NotificationCenterManagerKeys) {
        NotificationCenter.default.post(name: .init(name.rawValue), object: nil)
    }
    
}
