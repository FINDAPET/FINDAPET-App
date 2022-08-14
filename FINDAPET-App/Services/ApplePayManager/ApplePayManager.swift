//
//  ApplePayManager.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 14.08.2022.
//

import Foundation
import PassKit

final class ApplePayManager {
    
    static func producePay(countryCode: String, currencyCode: String, title: String, sum: Int, delegate: PKPaymentAuthorizationViewControllerDelegate & UIViewController) {
        let req = PKPaymentRequest()
        
        guard let controller = PKPaymentAuthorizationViewController(paymentRequest: req) else {
            print("❌ Error: controller is equal to nil.")
            
            return
        }
                
        controller.delegate = delegate
        
        req.merchantIdentifier = "merchant.artemiy.FINDAPET-App"
        req.supportedNetworks = [.visa, .masterCard, .discover, .mir, .chinaUnionPay, .quicPay]
        req.merchantCapabilities = .capability3DS
        req.countryCode = countryCode
        req.currencyCode = currencyCode
        req.paymentSummaryItems = [PKPaymentSummaryItem(label: title, amount: NSDecimalNumber(value: sum))]
        req.supportedCountries = [
            "AM", "AZ", "BY", "BE", "BG", "CA", "CN", "HR", "CY", "CZ", "DO", "EE", "FI", "FR", "DE", "GR", "RU"
        ]
        
        delegate.present(controller, animated: true)
    }
    
}
