//
//  DealPresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 30.10.2022.
//

import Foundation

final class DealPresenter {
    
    var callBack: (() -> Void)?
    private(set) var deal: Deal.Output? {
        didSet {
            self.callBack?()
        }
    }
    private(set) var dealID: UUID?
    private let router: DealRouter
    private let interactor: DealInteractor
    
    init(deal: Deal.Output? = nil, router: DealRouter, interactor: DealInteractor) {
        self.deal = deal
        self.router = router
        self.interactor = interactor
    }
    
    init(dealID: UUID? = nil, router: DealRouter, interactor: DealInteractor) {
        self.dealID = dealID
        self.router = router
        self.interactor = interactor
    }
    
//    MARK: Requests
    func getDeal(completionHandler: @escaping (Deal.Output?, Error?) -> Void) {
        guard let dealID = self.dealID else {
            completionHandler(nil, nil)
            
            return
        }
        
        let newCompletionHandler: (Deal.Output?, Error?) -> Void = { [ weak self ] deal, error in
            completionHandler(deal, error)
            
            guard error == nil else {
                return
            }
            
            self?.deal = deal
        }
        
        self.interactor.getDeal(dealID: dealID, completionHandler: newCompletionHandler)
    }
    
    func deleteDeal(completionHandler: @escaping (Error?) -> Void) {
        guard let dealID = self.deal?.id else {
            print("❌ Error: deal id is equal to nil.")
            
            completionHandler(RequestErrors.statusCodeError(statusCode: 404))
            
            return
        }
        
        self.interactor.deleteDeal(with: dealID, competionHandler: completionHandler)
    }
    
//    MARK: User Defaults
    func getUserID() -> UUID? {
        self.interactor.getUserDefaults(.id) as? UUID
    }
    
//    MARK: Notification Center
    func notificationCenterManagerPostUpdateProfileScreen() {
        self.interactor.notificationCenterManagerPost(.reloadProfileScreen)
    }
    
//    MARK: Routing
    func goToProfile() {
        self.router.goToProfile(with: self.deal?.cattery.id)
    }
    
    func goToChatRoom(with id: UUID) {
        self.router.goToChatRoom(with: id)
    }
    
    func getCreateOffer() -> CreateOfferViewController?{
        guard let deal = self.deal else {
            return nil
        }
        
        return self.router.getCreateOffer(deal: deal)
    }
    
}
