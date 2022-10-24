//
//  AdsPresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 19.10.2022.
//

import Foundation

final class AdsPresenter {
    
    var completionHandler: (() -> Void)?
    private(set) var userID: UUID? = nil
    private(set) var ads = [Ad.Output]() {
        didSet {
            self.completionHandler?()
        }
    }
    private let router: AdsRouter
    private let interactor: AdsInteractor
    
    init(userID: UUID, router: AdsRouter, interactor: AdsInteractor) {
        self.userID = userID
        self.router = router
        self.interactor = interactor
    }
    
    init(ads: [Ad.Output], router: AdsRouter, interactor: AdsInteractor) {
        self.ads = ads
        self.router = router
        self.interactor = interactor
    }
    
//    MARK: Requests
    func getAds(completionHandler: @escaping ([Ad.Output]?, Error?) -> Void) {
        let newCompletionHandler: ([Ad.Output]?, Error?) -> Void = { [ weak self ] ads, error in
            completionHandler(ads, error)
            
            guard error == nil else {
                return
            }
            
            self?.ads = ads ?? [Ad.Output]()
        }
        
        guard let userID = userID else {
            completionHandler(nil, nil)
            
            return
        }
        
        self.interactor.getAds(userID: userID, completionHandler: newCompletionHandler)
    }
    
//    MARK: Application Manager
    func goTo(url: URL) {
        self.interactor.goTo(url: url)
    }
    
//    MARK: Routing
    func goToProfile(userID: UUID? = nil) {
        self.router.goToProfile(userID: userID)
    }
    
}
