//
//  ProfileRouter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 30.08.2022.
//

import Foundation

final class ProfileRouter: ProfileCoordinatable {
    
    var coordinatorDelegate: ProfileCoordinator?
    
    func goToOnboarding() {
        self.coordinatorDelegate?.goToOnboarding()
    }
    
    func goToOffers(mode: OffersMode, offers: [Offer.Output]) {
        self.coordinatorDelegate?.goToOffers(mode: mode, offers: offers)
    }
    
    func goToAds(ads: [Ad.Output]) {
        self.coordinatorDelegate?.goToAds(ads: ads)
    }
    
    func goToEditProfile(user: User.Input) {
        self.coordinatorDelegate?.goToEditProfile(user: user)
    }
    
    func goToSettings() {
        self.coordinatorDelegate?.goToSettings()
    }
    
    func goToSubscription() {
        self.coordinatorDelegate?.goToSubscription()
    }
    
    func goToCreateDeal() {
        self.coordinatorDelegate?.goToCreateDeal()
    }
    
    func goToCreateAd(user: User.Output? = nil) {
        self.coordinatorDelegate?.goToCreateAd(user: user)
    }
    
    func goToInfo() {
        self.coordinatorDelegate?.goToInfo()
    }
    
}
