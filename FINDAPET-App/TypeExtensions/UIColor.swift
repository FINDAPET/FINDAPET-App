//
//  UIColor.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 16.08.2022.
//

import Foundation
import UIKit

extension UIColor {
    
//    MARK: - Init
    convenience init?(hex: String, alpha: CGFloat = 1) {
        guard hex.hasPrefix("#") else { return nil }
        
        let hexColor = String(hex.lowercased()[hex.index(hex.startIndex, offsetBy: 1)...])
        
        guard hexColor.count == 8 else { return nil }
        
        let scanner = Scanner(string: hexColor)
        var hexNumber = UInt64.zero
        
        guard scanner.scanHexInt64(&hexNumber) else { return nil }
                
        self.init(
            red: .init((hexNumber & 0xff000000) >> 24) / 255,
            green: .init((hexNumber & 0x00ff0000) >> 16) / 255,
            blue: .init((hexNumber & 0x0000ff00) >> 8) / 255,
            alpha: alpha
        )
    }
}

extension UIColor {
    
//    MARK: Default App Colors
    static let textColor = UIColor.createColor(lightMode: .black, darkMode: .white)
    static let borderColor = UIColor.createColor(lightMode: .black, darkMode: .systemGray)
    static let secondaryTextColor = UIColor.createColor(lightMode: .systemGray, darkMode: .white)
    static let backgroundColor = UIColor.createColor(
        lightMode: {
            if #available(iOS 13.0, *) {
                return .systemGray6
            }
            
            return .init(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        }(),
        darkMode: UIColor(red: 30/255, green: 29/255,  blue: 42/255, alpha: 1)
    )
    static let textFieldColor = UIColor.createColor(
        lightMode: .white,
        darkMode: UIColor(red: 39/255, green: 38/255, blue: 51/255, alpha: 1)
    )
    static let accentColor = UIColor(red: 0.384, green: 0.212, blue: 1, alpha: 1)
    
//    MARK: Create Color
    static func createColor(lightMode: UIColor, darkMode: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else { return lightMode }
        
        return UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .light ? lightMode : darkMode
        }
    }
    
}

//MARK: HEX String To Color
extension UIColor {
    
    static func hexStringToUIColor(hex: String, alpha: CGFloat = 1) -> UIColor? {
        guard hex.hasPrefix("#") else { return nil }
        
        let hexColor = String(hex.lowercased()[hex.index(hex.startIndex, offsetBy: 1)...])
        
        guard hexColor.count == 8 else { return nil }
        
        let scanner = Scanner(string: hexColor)
        var hexNumber = UInt64.zero
        
        guard scanner.scanHexInt64(&hexNumber) else { return nil }
                
        return UIColor(
            red: .init((hexNumber & 0xff000000) >> 24) / 255,
            green: .init((hexNumber & 0x00ff0000) >> 16) / 255,
            blue: .init((hexNumber & 0x0000ff00) >> 8) / 255,
            alpha: alpha
        )
    }
    
}
