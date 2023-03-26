//
//  ProfilePresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 30.08.2022.
//

import Foundation
import UIKit

final class ProfilePresenter {
    
    let userID: UUID?
    var callBack: (() -> Void)?
    private let router: ProfileRouter
    private let interactor: ProfileInteractor
    
    init(router: ProfileRouter, interactor: ProfileInteractor, userID: UUID? = nil) {
        self.router = router
        self.interactor = interactor
        self.userID = userID
    }
    
//    MARK: Properties
    var user: User.Output? {
        didSet {
            self.saveDealsID()
            self.callBack?()
        }
    }
        
//    MARK: Routing
    func goToOnboarding() {
        self.router.goToOnboarding()
    }
    
    func goToOffers() {
        self.router.goToOffers(mode: .offers, offers: self.user?.offers ?? [Offer.Output]())
    }
    
    func goToMyOffers() {
        self.router.goToOffers(mode: .myOffers, offers: self.user?.myOffers ?? [Offer.Output]())
    }
    
    func goToAds() {
        self.router.goToAds(ads: self.user?.ads ?? [Ad.Output]())
    }
    
    func goToCreateAd() {
        self.router.goToCreateAd(user: self.user)
    }
    
    func goToInfo() {
        self.router.goToInfo()
    }
    
    func goToSettings() {
        self.router.goToSettings()
    }
    
    func goToEditProfile() {
        self.router.goToEditProfile(user: .init(
            id: self.user?.id,
            name: self.user?.name ?? String(),
            avatarData: self.user?.avatarData,
            documentData: self.user?.documentData,
            description: self.user?.description,
            chatRoomsID: self.user?.chatRooms.map { $0.id ?? .init() } ?? .init()
        ))
    }
    
    func goToDeal(deal: Deal.Output) {
        self.router.goToDeal(deal: deal)
    }
    
    func getComplaint() -> ComplaintViewController? {
        guard let id = self.getMyID() else {
            return nil
        }
        
        return self.router.getComplaint(.init(text: .init(), senderID: id))
    }
    
//    MARK: Requests
    func getUser(completionHandler: @escaping (User.Output?, Error?) -> Void) {
        self.interactor.getUser(completionHandler: completionHandler)
    }
    
    func getSomeUser(completionHandler: @escaping (User.Output?, Error?) -> Void) {
        if let userID = self.userID {
            self.interactor.getSomeUser(userID: userID, completionHandler: completionHandler)
        }
    }
    
    func logOut(completionHandler: @escaping (Error?) -> Void) {
        self.interactor.logOut(completionHandler: completionHandler)
    }
    
//    MARK: Notification Center
    func notificationCenterManagerAddObserver(
        _ observer: Any,
        name: NotificationCenterManagerKeys,
        additional parameter: String? = nil,
        action: Selector
    ) {
        self.interactor.notificationCenterManagerAddObserver(observer, name: name, additional: parameter, action: action)
    }
    
//    MARK: User Defaults
    func getMyID() -> UUID? {
        self.interactor.getMyID()
    }
    
    func getCurrency() -> String {
        self.interactor.getCurrency() ?? "USD"
    }
    
    func writeIsFirstEditing() {
        self.interactor.writeIsFirstEditing()
    }
    
    func deleteUserID() {
        self.interactor.setUserDefaults(nil, with: .id)
    }
    
    func deleteDealsID() {
        self.interactor.setUserDefaults(nil, with: .dealsID)
    }
    
    func deleteDeviceToken() {
        self.interactor.setUserDefaults(nil, with: .deviceToken)
    }
    
    func deleteUserName() {
        self.interactor.setUserDefaults(nil, with: .userName)
    }
    
    func deleteUserCurrency() {
        self.interactor.setUserDefaults(nil, with: .currency)
    }
    
    func deleteNotificationScreensID() {
        self.interactor.setUserDefaults(nil, with: .notificationScreensID)
    }
    
    func deleteCountry() {
        self.interactor.setUserDefaults(nil, with: .country)
    }
    
    func deleteCity() {
        self.interactor.setUserDefaults(nil, with: .city)
    }
    
    private func saveDealsID() {
        guard let user = self.user else {
            return
        }
        
        self.interactor.setUserDefaults(
            user.boughtDeals.map { $0.id?.uuidString }.filter { $0 != nil } + user.deals.map { $0.id?.uuidString }.filter { $0 != nil },
            with: .dealsID
        )
    }
    
//    MARK: Keychain
    func deleteKeychainData() {
        self.interactor.deleteKeychainData()
    }
    
}
