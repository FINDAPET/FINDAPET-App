//
//  SceneDelegate.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 12.08.2022.
//

import UIKit
import SideMenu

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let coordinator = ProfileCoordinator()
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = coordinator.navigationController
        self.window?.makeKeyAndVisible()
        self.window?.windowScene = windowScene
        
        coordinator.start()
    }
    
}

