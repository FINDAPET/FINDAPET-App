//
//  PetClass.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 03.01.2023.
//

import Foundation

struct PetBreed {
    struct Output: Decodable {
        var id: UUID?
        var name: String
    }
    
    struct Entity: Hashable {
        var id: UUID?
        var name: String
        var petType: PetType.Entity?
    }
}
