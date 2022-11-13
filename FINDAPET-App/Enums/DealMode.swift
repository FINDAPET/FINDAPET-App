//
//  DealMode.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 13.11.2022.
//

import Foundation

enum DealMode: String, CaseIterable, Encodable {
    case onlyInCity = "Only in the City"
    case onlyInCountry = "Only in the Country"
    case onlyAbroad = "Only Abroad"
    case everywhere = "Everywhere"
    
    static func getDealMode(_ value: String) -> DealMode? {
        for dealMode in DealMode.allCases {
            if dealMode.rawValue == value {
                return dealMode
            }
        }
        
        return nil
    }
}
