//
//  PetType.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 13.11.2022.
//

import Foundation

enum PetType: String, CaseIterable, Encodable {
    case dog = "A Dog"
    case cat = "A Cat"
    
    static func getPetType(_ value: String) -> PetType? {
        for petType in PetType.allCases {
            if petType.rawValue == value {
                return petType
            }
        }
        
        return nil
    }
}
