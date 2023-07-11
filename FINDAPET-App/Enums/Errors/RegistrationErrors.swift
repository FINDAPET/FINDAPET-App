//
//  RegistrationErrors.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 13.08.2022.
//

import Foundation

enum RegistrationErrors: Error {
    case emailIsNotValid, passwordIsTooShort
}
