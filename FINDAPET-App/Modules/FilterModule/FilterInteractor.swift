//
//  FilterInteractor.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 14.11.2022.
//

import Foundation

final class FilterInteractor {
    
//    MARK: Properties
    private let petTypeCoreData = CoreDataManager<PetTypeEntity>()
    
//    MARK: User Defaults
    func getUserDefaults(_ key: UserDefaultsKeys) -> Any? {
        UserDefaultsManager.read(key: key)
    }
    
    func setUserDefaults(_ value: Any?, with key: UserDefaultsKeys) {
        UserDefaultsManager.write(data: value, key: key)
    }
    
//    MARK: Core Data
    func getAllPetTypes(_ completionHandler: @escaping ([PetTypeEntity], Error?) -> Void) {
        self.petTypeCoreData.all(completionHandler)
    }
    
}
