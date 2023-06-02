//
//  Platform.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 19.05.2023.
//

import Foundation

enum Platform: Codable {
    case iOS, Android, custom(name: String)
}
