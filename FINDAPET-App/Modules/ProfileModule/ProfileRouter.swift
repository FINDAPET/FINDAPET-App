//
//  ProfileRouter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 30.08.2022.
//

import Foundation

final class ProfileRouter: ProfileCoordinatable {
    
    var coordinatorDelegate: ProfileCoordinator?
    
    func goToOnboarding(_ animated: Bool = true) {
        self.coordinatorDelegate?.goToOnboarding(animated)
    }
    
    func goToOffers(mode: OffersMode, userID: UUID? = nil) {
        self.coordinatorDelegate?.goToOffers(mode: mode, userID: userID)
    }
    
    func goToAds(userID: UUID? = nil) {
        self.coordinatorDelegate?.goToAds(userID: userID)
    }
    
    func goToEditProfile(user: User.Input) {
        self.coordinatorDelegate?.goToEditProfile(user: user)
    }
    
    func goToSettings() {
        self.coordinatorDelegate?.goToSettings()
    }
    
    func goToCreateAd(user: User.Output? = nil) {
        self.coordinatorDelegate?.goToCreateAd(user: user)
    }
    
    func goToInfo() {
        self.coordinatorDelegate?.goToInfo()
    }
    
    func goToDeal(dealID: UUID? = nil, deal: Deal.Output? = nil) {
        self.coordinatorDelegate?.goToDeal(dealID: dealID, deal: deal)
    }
    
    func getComplaint(_ complaint: Complaint.Input) -> ComplaintViewController? {
        self.coordinatorDelegate?.getComplaint(complaint)
    }
    
    func getDeal(dealID: UUID? = nil, deal: Deal.Output? = nil) -> DealViewController? {
        self.coordinatorDelegate?.getDeal(dealID: dealID, deal: deal)
    }
    
    func getBrowseImage(dataSource: BrowseImagesViewControllerDataSource) -> BrowseImagesViewController? {
        self.coordinatorDelegate?.getBrowseImage(dataSource)
    }
    
}
