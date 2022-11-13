//
//  ShowClass.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 13.11.2022.
//

import Foundation

enum ShowClass: String, CaseIterable, Codable {
    case showPetClass = "Show Pet Class"
    case showBreedClass = "Show Breed Class"
    case allClass = "Show Pet Class/Show Breed Class"
}
