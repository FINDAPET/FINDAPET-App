//
//  LaunchScreenPresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 28.12.2022.
//

import Foundation

final class LaunchScreenPresenter {
    
    private let router: LaunchScreenRouter
    private let interactor: LaunchScreenInteractor
    
    init(router: LaunchScreenRouter, interactor: LaunchScreenInteractor) {
        self.router = router
        self.interactor = interactor
    }
    
}
