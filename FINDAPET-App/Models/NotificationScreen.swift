//
//  NotificationScreen.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 05.12.2022.
//

import Foundation

struct NotificationScreen {
    struct Input: Encodable {
        var id: UUID?
        var backgroundImageData: Data
        var title: String
        var text: String
        var buttonTitle: String
        var textColorHEX: String
        var buttonTitleColorHEX: String
        var buttonColorHEX: String
    }
    
    struct Output: Decodable {
        var id: UUID?
        var backgroundImageData: Data
        var title: String
        var text: String
        var buttonTitle: String
        var textColorHEX: String
        var buttonTitleColorHEX: String
        var buttonColorHEX: String
    }
}
