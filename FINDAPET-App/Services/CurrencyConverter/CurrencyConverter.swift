//
//  CurrencyConverter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 17.10.2022.
//

import Foundation

final class CurrencyConverter {
    
    static func convert(
        _ first: String,
        to second: String,
        value: Int,
        completionHandler: @escaping (ExchangeConvert.Output?, Error?) -> Void
    ) {
        RequestManager.request(
            sendModel: ExchangeConvert.Input(from: first, to: second, amount: Double(value)),
            method: .GET,
            url: URLConstructor.exchange.convert(),
            completionHandler: completionHandler
        )
    }
    
}
