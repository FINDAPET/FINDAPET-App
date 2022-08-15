//
//  RegistrationManager.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 13.08.2022.
//

import Foundation

final class RegistrationManager {
    
    static func isValidData(userCreate: User.Create, completionHandler: (Error?) -> Void) {
        guard userCreate.email.isValidEmail else {
            print("❌ Error: email is not valid.")
            
            completionHandler(RegistrationErrors.emailIsNotValid)
            
            return
        }
        
        guard userCreate.password.count >= 8 else {
            print("❌ Error: password is too short.")
            
            completionHandler(RegistrationErrors.passwordIsTooShort)
            
            return
        }
        
        completionHandler(nil)
    }
    
}
