//
//  Filter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 11.11.2022.
//

import Foundation

struct Filter: Encodable {
    var title: String?
    var petType: PetType?
    var petBreed: PetBreed?
    var petClass: PetClass?
    var isMale: Bool?
    var country: String?
    var city: String?
}
