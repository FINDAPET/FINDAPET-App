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
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
//    MARK: - Porperties
    var window: UIWindow?
    private let registrationCoordinator: RegistrationCoordinator = {
        let coordinator = RegistrationCoordinator()
        
        coordinator.start()
        
        return coordinator
    }()
    
//    MARK: - Application
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #unavailable(iOS 13.0) {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = self.registrationCoordinator.navigationController
            self.window?.makeKeyAndVisible()
        }
        
        self.checkSusbscription()
        
        do {
            try YandexMobileMetricaManager.start(with: .init(ymmYnadexMetricaAPIKey))
        } catch {
            print("❌ Error: \(error.localizedDescription)")
        }
        
        return true
    }
    
//    MARK: - Notifications
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        
        UserDefaultsManager.write(data: token, key: .deviceToken)
        NotificationManager.shared.callBack?()
        
        print("❕Device Token: \(token)")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("❌ Failed to register for remote notifications: \(error)")
    }
    
//    MARK: - Check Subscription
    private func checkSusbscription() {
        guard let date = UserDefaultsManager.read(key: .premiumUserDate) as? Date, date >= .init() else {
            UserDefaultsManager.write(data: nil, key: .premiumUserDate)
            UserDefaultsManager.write(data: nil, key: .subscription)
            
            return
        }
    }
    
}

