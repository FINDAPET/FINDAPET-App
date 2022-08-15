//
//  NotificationManager.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 13.08.2022.
//

import Foundation
import UserNotifications

final class NotificationManager {
    
    static func sheduleNotification(title: String, body: String? = nil) {
        let content = UNMutableNotificationContent()
        
        content.title = title
        
        if let body = body {
            content.body = body
        }
        
        UNUserNotificationCenter.current().add(
            UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        )
    }
    
    static func sheduleNotification(title: String, body: String? = nil, triger: UNNotificationTrigger) {
        let content = UNMutableNotificationContent()
        
        content.title = title
        
        if let body = body {
            content.body = body
        }
        
        UNUserNotificationCenter.current().add(
            UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: triger)
        )
    }
    
}
