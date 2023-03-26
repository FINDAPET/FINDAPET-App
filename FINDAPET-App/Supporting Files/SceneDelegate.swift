//
//  SceneDelegate.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 12.08.2022.
//

import UIKit

@available(iOS 13.0, *)
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
//    MARK: - Properties
    var window: UIWindow?
    private let registrationCoordinator: RegistrationCoordinator = {
        let coordinator = RegistrationCoordinator()
        
        coordinator.start()
        
        return coordinator
    }()
    
//    MARK: Scene
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = self.registrationCoordinator.navigationController
        self.window?.makeKeyAndVisible()
        self.window?.windowScene = windowScene
    }
    
}
