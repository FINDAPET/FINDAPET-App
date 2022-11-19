//
//  ShowClass.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 13.11.2022.
//

import Foundation

enum PetClass: String, CaseIterable, Codable {
    case showClass = "Show Class"
    case breedClass = "Breed Class"
    case allClass = "Show/Breed Class"
    
    static func getPetClass(_ value: String) -> PetClass? {
        for showClass in PetClass.allCases {
            if showClass.rawValue == value {
                return showClass
            }
        }
        
        return nil
    }
}
