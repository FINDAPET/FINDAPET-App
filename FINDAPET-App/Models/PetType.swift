//
//  PetType.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 03.01.2023.
//

import Foundation

struct PetType {
    struct Output: Decodable {
        var id: UUID?
        var localizedNames: [String : String]
        var imageData: Data
        var petBreeds: [PetBreed.Output]
    }
    
    struct Entity: Hashable {
        var id: UUID?
        var name: String
        var imageData: Data
        var petBreeds: [PetBreed.Entity]
    }
}
