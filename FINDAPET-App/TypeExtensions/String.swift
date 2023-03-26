//
//  String.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 13.08.2022.
//

import Foundation

extension String {
    
//    MARK: Init With StaticString
    init(_ str: StaticString) {
        self = str.withUTF8Buffer { String(decoding: $0, as: UTF8.self) }
    }
    
//    MARK: Is Valid Email
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailPred.evaluate(with: self)
    }
    
}
