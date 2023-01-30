//
//  AppDelegate.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 12.08.2022.
//

import UIKit
import CoreData
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.registerForPushNotifications()
        self.checkSusbscription()
        
        if #available(iOS 16, *) {
            self.setCurrency(Locale.current.currency?.identifier ?? Currency.USD.rawValue)
        } else {
            self.setCurrency(Locale.current.currencyCode ?? Currency.USD.rawValue)
        }
        
        do {
            try YandexMobileMetricaManager.start(with: ymmYnadexMetricaAPIKey)
        } catch {
            print("❌ Error: \(error.localizedDescription)")
        }
        
        return true
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FINDAPET_App")
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
//    MARK: - Notifications
    func registerForPushNotifications() {
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
        (granted, error) in
          print("Permission granted: \(granted)")
          
          guard granted else { return }
        
          self.getNotificationSettings()
      }
    }
    
    func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { (settings) in
          print("Notification settings: \(settings)")
          
          guard settings.authorizationStatus == .authorized else { return }
          
          DispatchQueue.main.sync {
              UIApplication.shared.registerForRemoteNotifications()
          }
      }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
      
        let token = tokenParts.joined()
        
        UserDefaultsManager.write(data: token, key: .deviceToken)
        
        print("Device Token: \(token)")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    private func setCurrency(_ value: String) {
        UserDefaultsManager.write(data: value, key: .currency)
    }
    
    private func checkSusbscription() {
        guard let date = UserDefaultsManager.read(key: .premiumUserDate) as? Date, date >= .init() else {
            UserDefaultsManager.write(data: nil, key: .premiumUserDate)
            UserDefaultsManager.write(data: nil, key: .subscription)
            
            return
        }
    }
    
}

