//
//  CustomNavigationController.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 15.04.2023.
//

import UIKit

final class CustomNavigationController: UINavigationController {

//    MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.delegate = self
    }

}

//MARK: - Extensions
extension CustomNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard navigationController == self else { return }
        
        self.interactivePopGestureRecognizer?.isEnabled = false
    }
}
