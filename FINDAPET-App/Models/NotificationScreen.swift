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
        var isRequired: Bool
        
        init(
            id: UUID? = nil,
            backgroundImageData: Data,
            title: String,
            text: String,
            buttonTitle: String,
            textColorHEX: String,
            buttonTitleColorHEX: String,
            buttonColorHEX: String,
            isRequired: Bool
        ) {
            self.id = id
            self.backgroundImageData = backgroundImageData
            self.title = title
            self.text = text
            self.buttonTitle = buttonTitle
            self.textColorHEX = textColorHEX
            self.buttonTitleColorHEX = buttonTitleColorHEX
            self.buttonColorHEX = buttonColorHEX
            self.isRequired = isRequired
        }
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
        var isRequired: Bool
    }
}
