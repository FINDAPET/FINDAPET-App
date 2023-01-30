//
//  SubscriptionPresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 24.10.2022.
//

import Foundation

final class SubscriptionPresenter {
    
    var callBack: (() -> Void)?
    private let router: SubscriptionRouter
    private let interactor: SubscriptionInteractor
    
    init(router: SubscriptionRouter, interactor: SubscriptionInteractor) {
        self.router = router
        self.interactor = interactor
    }
    
//    MARK: Properties
    private(set) var subscriptions = [TitleSubscription]() {
        didSet {
            self.callBack?()
        }
    }
    
//    MARK: Requestss
    func makeUserPremium(_ subscription: Subscription.Input, completionHandler: @escaping (Error?) -> Void = { _ in }) {
        self.interactor.makePremium(subscription: subscription, completionHandler: completionHandler)
    }
    
    func getSubscriptions(completionHandler: @escaping ([TitleSubscription]?, Error?) -> Void = { _, _ in }) {
        let newCompletionHandler: ([TitleSubscription]?, Error?) -> Void = { [ weak self ] newSubscriptions, error in
            completionHandler(newSubscriptions, error)
            
            guard let newSubscriptions = newSubscriptions, error == nil else {
                return
            }
            
            self?.subscriptions = newSubscriptions
        }
        
        self.interactor.getSubscrptions(completionHandler: newCompletionHandler)
    }
    
//    MARK: User Defaults
    func setPremiumUserDate(_ value: Date) {
        self.interactor.set(value, to: .premiumUserDate)
    }
    
    func setSubscription(_ value: ProductsID) {
        self.interactor.set(value.rawValue, to: .subscription)
    }
    
    func getSubscription() -> String? {
        self.interactor.get(.subscription) as? String
    }
    
    func getUserID() -> String? {
        self.interactor.get(.id) as? String
    }
    
}
