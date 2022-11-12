//
//  Filter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 11.11.2022.
//

import Foundation

struct Filter: Encodable {
    var title: String?
    var mode: String?
    var petType: String?
    var petBreed: String?
    var showClass: String?
    var isMale: Bool?
    var country: String?
    var city: String?
}
