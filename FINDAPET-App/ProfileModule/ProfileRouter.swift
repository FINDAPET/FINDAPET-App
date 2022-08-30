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
    
    func goToDeals(isFindable: Bool) {
        self.coordinatorDelegate?.goToDeals(isFindable: isFindable)
    }
    
    func goToOffers() {
        self.coordinatorDelegate?.goToOffers()
    }
    
    func goToAds() {
        self.coordinatorDelegate?.goToAds()
    }
    
    func goToCreateDeal() {
        self.coordinatorDelegate?.goToCreateDeal()
    }
    
    func goToCreateAd() {
        self.coordinatorDelegate?.goToCreateAd()
    }
    
    func goToInfo() {
        self.coordinatorDelegate?.goToInfo()
    }
    
}
