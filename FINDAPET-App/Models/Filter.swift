//
//  Filter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 11.11.2022.
//

import Foundation

struct Filter: Encodable {
    
    var title: String?
    var petTypeID: UUID?
    var petBreedID: UUID?
    var petClass: PetClass?
    var isMale: Bool?
    var country: String?
    var city: String?
    var checkedIDs: [UUID]
    
    init(
        title: String? = nil,
        petTypeID: UUID? = nil,
        petBreedID: UUID? = nil,
        petClass: PetClass? = nil,
        isMale: Bool? = nil,
        country: String? = nil,
        city: String? = nil,
        checkedIDs: [UUID] = .init()
    ) {
        self.title = title
        self.petTypeID = petTypeID
        self.petBreedID = petBreedID
        self.petClass = petClass
        self.isMale = isMale
        self.country = country
        self.city = city
        self.checkedIDs = checkedIDs
    }
    
}
