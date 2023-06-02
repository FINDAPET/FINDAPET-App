//
//  NotificationManager.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 13.08.2022.
//

import Foundation
import UserNotifications
import UIKit

final class NotificationManager {
    
//    MARK: - Properties
    static let shared = NotificationManager()
    
    private(set) var callBack: (() -> Void)?
    
//    MARK: - Funcs
    func sheduleNotification(title: String, body: String? = nil) {
        let content = UNMutableNotificationContent()
        
        content.title = title
        
        if let body = body {
            content.body = body
        }
        
        UNUserNotificationCenter.current().add(
            UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        )
    }
    
    func sheduleNotification(title: String, body: String? = nil, triger: UNNotificationTrigger) {
        let content = UNMutableNotificationContent()
        
        content.title = title
        
        if let body = body {
            content.body = body
        }
        
        UNUserNotificationCenter.current().add(
            UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: triger)
        )
    }
    
    func registerForPushNotifications(completionHandler: @escaping (Error?) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { [ weak self ] granted, error in
            print("❕Permission granted: \(granted)")
            
            if let error {
                print("❌ Error: \(error)")
                
                completionHandler(error)
                
                return
            }
            
            guard granted else {
                completionHandler(RequestErrors.statusCodeError(statusCode: 500))
                
                return
            }
          
            self?.getNotificationSettings(completionHandler)
        }
    }
    
    func getNotificationSettings(_ completionHanler: @escaping (Error?) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { [ weak self ] settings in
            print("❕Notification settings: \(settings)")
          
            guard settings.authorizationStatus == .authorized else {
                print("❌ Error: unauthorized.")
                
                completionHanler(RequestErrors.statusCodeError(statusCode: 500))
                
                return
            }
            
            self?.callBack = { completionHanler(nil) }
          
            DispatchQueue.main.sync(execute: UIApplication.shared.registerForRemoteNotifications)
        }
    }
    
}
