//
//  SubscriptionInformationInteractor.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 17.03.2023.
//

import Foundation

final class SubscriptionInformationInteractor {
    
//    MARK: User Defaults
    func userDefaultsGet(with key: UserDefaultsKeys) -> Any? {
        UserDefaultsManager.read(key: key)
    }
    
}
