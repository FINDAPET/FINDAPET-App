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

        if KeychainManager.shared.read(key: .token) != nil, !(UserDefaultsManager.read(key: .isFirstEditing) as? Bool ?? true) {
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
    
    func goToEditProfile(user: User.Input) {
        let router = EditProfileRouter()
        let interactor = EditProfileInteractor()
        let presenter = EditProfilePresenter(router: router, interactor: interactor, user: user)
        let viewController = EditProfileViewController(presenter: presenter)
        
        router.coordinatorDelegate = self
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func getEditProfile(user: User.Input) -> EditProfileViewController {
        let router = EditProfileRouter()
        let interactor = EditProfileInteractor()
        let presenter = EditProfilePresenter(router: router, interactor: interactor, user: user)
        
        return EditProfileViewController(presenter: presenter)
    }
    
    func goToPrivacyPolicy() {
        let router = PrivacyPolicyRouter()
        let interactor = PrivacyPolicyInteractor()
        let presenter = PrivacyPolicyPresenter(router: router, interactor: interactor)
        let viewController = PrivacyPolicyViewController(presenter: presenter)
        
        router.coordinatorDelegate = self
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToMainTabBar() {
        let coordinator = MainTabBarCoordinator()
        
        coordinator.coordinatorDelegate = self
        coordinator.start()
                
        self.navigationController.pushViewController(coordinator.tabBarController, animated: true)
        
        UserDefaultsManager.write(data: false, key: .isFirstEditing)
    }
    
    private func setupViews() {
        self.navigationController.navigationBar.isHidden = true
    }
    
}
