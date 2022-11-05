//
//  YandexMobileMetricaManager.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 12.10.2022.
//

import Foundation
import YandexMobileMetrica

final class YandexMobileMetricaManager {
    
    static func start(with apiKey: String) throws {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: apiKey) else {
            throw YandexMobileMetricaErrors.configurationIsEqualToNil
        }
        
        YMMYandexMetrica.activate(with: configuration)
    }
    
}
