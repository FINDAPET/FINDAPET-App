//
//  WSAuthentaficationMode.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 13.08.2022.
//

import Foundation

enum WSAuthentaficationMode {
    case base(email: String, password: String), bearer(value: String)
}
