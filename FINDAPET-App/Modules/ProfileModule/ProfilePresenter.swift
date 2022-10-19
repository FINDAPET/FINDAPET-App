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
    
    var user: User.Output? {
        didSet {
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
    
    func goToCreateDeal() {
        self.router.goToCreateDeal()
    }
    
    func goToCreateAd() {
        self.router.goToCreateAd()
    }
    
    func goToInfo() {
        self.router.goToInfo()
    }
    
    func goToEditProfile() {
        self.router.goToEditProfile(user: User.Input(
            id: self.user?.id,
            name: self.user?.name ?? "",
            avatarData: self.user?.avatarData,
            documentData: self.user?.documentData,
            description: self.user?.description ?? ""
        ))
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
    
//    MARK: Currency Converter
    
    func convert(
        _ first: String,
        to second: String,
        value: Int,
        completionHandler: @escaping (ExchangeConvert.Output?, Error?) -> Void
    ) {
        self.interactor.convert(first, to: second, value: value, completionHandler: completionHandler)
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
    
//    MARK: Keychain
    
    func deleteKeychainData() {
        self.interactor.deleteKeychainData()
    }
    
}