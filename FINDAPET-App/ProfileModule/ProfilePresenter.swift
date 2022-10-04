//
//  ProfilePresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 30.08.2022.
//

import Foundation

final class ProfilePresenter {
    
    let userID: UUID?
    private let router: ProfileRouter
    private let interactor: ProfileInteractor
    
    init(router: ProfileRouter, interactor: ProfileInteractor, userID: UUID? = nil) {
        self.router = router
        self.interactor = interactor
        self.userID = userID
    }
    
    var user: User.Output?
        
//    MARK: Routing
    
    func goToOnboarding() {
        self.router.goToOnboarding()
    }
    
    func goToDeals() {
        self.router.goToDeals(isFindable: false)
    }
    
    func goToOffers() {
        self.router.goToOffers()
    }
    
    func goToAds() {
        self.router.goToAds()
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
        self.router.gotoEditProfile(user: User.Input(
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
    
//    MARK: User Defaults
    
    func getMyID() -> UUID? {
        self.interactor.getMyID()
    }
    
    func writeIsFirstEditing() {
        self.interactor.writeIsFirstEditing()
    }
    
//    MARK: Keychain
    
    func deleteKeychainData() {
        self.interactor.deleteKeychainData()
    }
    
}
