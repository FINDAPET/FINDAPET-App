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
    
//    MARK: - Properties
    let navigationController = UINavigationController()
    private let mainTabBarCoordinator = MainTabBarCoordinator()
    
//    MARK: - Start
    func start() {
        self.setupViews()
        
        if let email = self.getEmail(), let password = self.getPassword() {
            self.goToLaunchScreen()
            self.logIn(email: email, password: password) { [ weak self ] token, error in
                if error != nil {
                    self?.goToOnboarding(false)
                    
                    return
                }
                
                guard let token = token else {
                    self?.goToOnboarding(false)
                    
                    return
                }
                
                self?.setBearrerToken(token.value)
                
                if token.user.name.isEmpty {
                    self?.goToEditProfile(user: .init(id: self?.getUserID()))
                } else {
                    self?.goToMainTabBar(false)
                }
            }
        } else {
            self.goToOnboarding(false)
        }
    }
    
    func goToOnboarding(_ animated: Bool = true) {
        let router = OnboardingRouter()
        let interactor = OnboardingInteractor()
        let presenter = OnboardingPresenter(router: router, interactor: interactor)
        let viewController = OnboardingViewController(presenter: presenter)
        
        router.coordinatorDelegate = self
        
        self.navigationController.pushViewController(viewController, animated: animated)
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
    
    func goToMainTabBar(_ animated: Bool = true) {
        self.mainTabBarCoordinator.coordinatorDelegate = self
        self.mainTabBarCoordinator.start()
        self.navigationController.pushViewController(self.mainTabBarCoordinator.tabBarController, animated: animated)
        
        UserDefaultsManager.write(data: false, key: .isFirstEditing)
    }
    
//    MARK: Launch Screen
    func getLaunchScreen() -> LaunchScreenViewController {
        let router = LaunchScreenRouter()
        let interactor = LaunchScreenInteractor()
        let presenter = LaunchScreenPresenter(router: router, interactor: interactor)
        let viewController = LaunchScreenViewController(presenter: presenter)
        
        return viewController
    }
    
    func goToLaunchScreen() {
        self.navigationController.pushViewController(self.getLaunchScreen(), animated: true)
    }
    
//    MARK: User Defaults
    private func getUserID() -> UUID? {
        guard let string = UserDefaultsManager.read(key: .id) as? String else {
            return nil
        }
        
        return .init(uuidString: string)
    }
    
//    MARK: Keychain
    private func getEmail() -> String? {
        KeychainManager.shared.read(key: .email)
    }
    
    private func getPassword() -> String? {
        KeychainManager.shared.read(key: .password)
    }
    
    private func setBearrerToken(_ value: String?) {
        KeychainManager.shared.write(value: value, key: .token)
    }
    
//    MARK: Requests
    private func logIn(email: String, password: String, completionHandler: @escaping (UserToken.Output?, Error?) -> Void) {
        RequestManager.request(
            method: .GET,
            authMode: .base(email: email, password: password),
            url: URLConstructor.defaultHTTP.auth(),
            completionHandler: completionHandler
        )
    }
    
//    MARK: Setup Views
    private func setupViews() {
        self.navigationController.navigationBar.isHidden = true
        
        if #unavailable(iOS 13.0) {
            self.navigationController.navigationBar.tintColor = .accentColor
        }
    }
    
}
