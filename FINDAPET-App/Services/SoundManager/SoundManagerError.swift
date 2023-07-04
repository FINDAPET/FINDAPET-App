//
//  SoundManagerErrors.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 19.03.2023.
//

import Foundation

enum SoundManagerError: Error {
    case notFoundSound(path: String)
}
