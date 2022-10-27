//
//  CreateAdPresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 26.10.2022.
//

import Foundation

final class CreateAdPresenter {
    
    var user: User.Output?
    private let router: CreateAdRouter
    private let interactor: CreateAdInteractor
    
    init(user: User.Output? = nil, router: CreateAdRouter, interactor: CreateAdInteractor) {
        self.user = user
        self.router = router
        self.interactor = interactor
    }
    
//    MARK: Requests
    func getUser(completionHandler: @escaping (User.Output?, Error?) -> Void) {
        let newCompletionHandler: (User.Output?, Error?) -> Void = { [ weak self ] user, error in
            completionHandler(user, error)
            
            guard error == nil else {
                return
            }
            
            self?.user = user
        }
        
        self.interactor.getUser(completionHandler: newCompletionHandler)
    }
    
    func createAd(ad: Ad.Input, completionHandler: @escaping (Error?) -> Void) {
        self.interactor.createAd(ad: ad, completionHandler: completionHandler)
    }
    
//    MARK: Routing
    func goToProfile() {
        self.router.goToProfile()
    }
    
}
