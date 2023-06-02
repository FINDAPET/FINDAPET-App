//
//  TitleSubscription.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 10.04.2023.
//

import Foundation

struct TitleSubscription: Decodable {
    typealias CountryCode = String
    
    var id: UUID?
    var localizedNames: [CountryCode : String]
    var price: Int
    var monthsCount: Int
}

//MARK: - Extensions
extension TitleSubscription: Hashable { }
