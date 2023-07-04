//
//  SubscriptionSoonPresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 10.04.2023.
//

import Foundation

final class SubscriptionSoonPresenter {
    
//    MARK: - Properties
    private let router: SubscriptionSoonRouter
    private let interactor: SubscriptionSoonInteractor
    
//    MARK: - Init
    init(router: SubscriptionSoonRouter, interactor: SubscriptionSoonInteractor) {
        self.router = router
        self.interactor = interactor
    }
    
}
