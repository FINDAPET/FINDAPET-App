//
//  NotificationScreenPresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 09.12.2022.
//

import Foundation

final class NotificationScreenPresenter {
    
    let notificationScreen: NotificationScreen.Output
    private let router: NotificationScreenRouter
    private let interactor: NotificationScreenInteractor
    
    init(notificationScreen: NotificationScreen.Output, router: NotificationScreenRouter, interactor: NotificationScreenInteractor) {
        self.notificationScreen = notificationScreen
        self.router = router
        self.interactor = interactor
    }
    
//    MARK: User Defaults
    func getUserDefaultsNotificationScreensID() -> [String]? {
        self.interactor.getUserDefaults(.notificationScreensID) as? [String]
    }
    
    func setUserDefaultsNotificationScreensID(_ value: [String]) {
        self.interactor.setUserDefaults(value, with: .notificationScreensID)
    }
    
}
