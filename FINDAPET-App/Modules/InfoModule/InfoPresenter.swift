//
//  InfoPresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 27.10.2022.
//

import Foundation

final class InfoPresenter {
    
    private let router: InfoRouter
    private let interactor: InfoInteractor
    
    init(router: InfoRouter, interactor: InfoInteractor) {
        self.router = router
        self.interactor = interactor
    }
    
//    MARK: Application Requests
    func goToSupportingTeamMail() {
        self.interactor.applicationGo(to: URLConstructor(mailTo: suportingTeamEmail).mailTo())
    }
    
    func goToAdvertisingTeamMail() {
        self.interactor.applicationGo(to: URLConstructor(mailTo: advertisingTeamEmail).mailTo())
    }
    
}
