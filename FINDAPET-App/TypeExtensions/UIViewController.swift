//
//  UIViewController.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 17.08.2022.
//

import Foundation
import UIKit

extension UIViewController {
    
//    MARK: Alerts
    
    func presentAlert(title: String, message: String? = nil) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        self.present(controller, animated: true)
    }
    
    func presentAlert(title: String, message: String? = nil, actions: (title: String, style: UIAlertAction.Style, action: () -> Void)...) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for action in actions {
            controller.addAction(UIAlertAction(
                title: action.title,
                style: action.style,
                handler: { _ in action.action() }
            ))
        }
        
        self.present(controller, animated: true)
    }
    
//    MARK: Action Sheets
    func presentActionsSheet(title: String, message: String? = nil, contents: [String], action: @escaping (UIAlertAction) -> Void) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for content in contents {
            controller.addAction(UIAlertAction(title: content, style: .default, handler: action))
        }
        
        controller.addAction(UIAlertAction(title: NSLocalizedString("Back", comment: String()), style: .cancel))
        
        self.present(controller, animated: true)
    }
    
    func presentActionsSheet(title: String, message: String? = nil, contents: [(title: String, action: (UIAlertAction) -> Void)]) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for content in contents {
            controller.addAction(UIAlertAction(title: content.title, style: .default, handler: content.action))
        }
        
        controller.addAction(UIAlertAction(title: NSLocalizedString("Back", comment: String()), style: .cancel))
        
        self.present(controller, animated: true)
    }
    
//    MARK: Errors
    
    func error(_ error: Error?, completionHandler: @escaping () -> Void) {
        if let error = error as? RegistrationErrors {
            switch error {
            case .emailIsNotValid:
                self.presentAlert(title: NSLocalizedString("Email isn't valid", comment: ""))
            case .passwordIsTooShort:
                self.presentAlert(
                    title: NSLocalizedString("Password is too short", comment: ""),
                    message: NSLocalizedString("Password must be 8 charecters long.", comment: "")
                )
            }
        } else if let error = error as? RequestErrors {
            switch error {
            case .statusCodeError(let statusCode):
                switch statusCode {
                case 401:
                    self.presentAlert(title: NSLocalizedString("Not Autorized", comment: ""))
                case 404:
                    self.presentAlert(title: NSLocalizedString("Not Found", comment: ""))
                case 500:
                    self.presentAlert(title: NSLocalizedString("Server Error", comment: ""))
                default:
                    self.presentAlert(title: NSLocalizedString("Error", comment: ""))
                }
            case .encodingFailed:
                self.presentAlert(title: NSLocalizedString("Incorrect Data", comment: ""))
            default:
                self.presentAlert(title: NSLocalizedString("Failed to make a request", comment: ""))
            }
        } else {
            completionHandler()
        }
    }
    
}
