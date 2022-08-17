//
//  RegistrationCoordinator.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 16.08.2022.
//

import Foundation
import UIKit

protocol RegistrationCoordinatable {
    var coordinatorDelegate: RegistrationCoordinator? { get set }
}

final class RegistrationCoordinator: Coordinator {
    
    let navigationController = UINavigationController()
    
    func start() {
        self.setupViews()
        
        if KeychainManager.read(key: .token) != nil {
            self.goToMainTabBar()
        } else {
            self.goToOnboarding()
        }
    }
    
    func goToOnboarding() {
        let router = OnboardingRouter()
        let interactor = OnboardingInteractor()
        let presenter = OnboardingPresenter(router: router, interactor: interactor)
        let viewController = OnboardingViewController(presenter: presenter)
        
        router.coordinatorDelegate = self
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToRegistration(mode: RegistrationMode) {
        let router = RegistrationRouter()
        let interactor = RegistrationInteractor()
        let presenter = RegistrationPresenter(router: router, interactor: interactor, mode: mode)
        let viewController = RegistrationViewController(presenter: presenter)
        
        router.coordinatorDelegate = self
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToEditProfile(user: User.Input? = nil) {
        // push edit profile
    }
    
    func goToMainTabBar() {
        let coordinator = MainTabBarCoordinator()
        
        coordinator.coordinatorDelegate = self
        coordinator.start()
        
        self.navigationController.pushViewController(coordinator.tabBar, animated: true)
    }
    
    private func setupViews() {
        self.navigationController.navigationBar.isHidden = true
    }
    
}
