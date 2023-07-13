//
//  CreateDealPresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 26.11.2022.
//

import Foundation
import StoreKit

final class EditDealPresenter {
    
    let isCreate: Bool
    var callBack: ((Deal.Input) -> Void)?
    var secondCallBack: (() -> Void)?
    lazy var deal = Deal.Input(
        title: .init(),
        photoDatas: .init(),
        isPremiumDeal: self.getNextDealIsPremium() ?? false,
        mode: .everywhere,
        petClass: .allClass,
        birthDate: .init(),
        price: .zero,
        currencyName: .getCurrency(wtih: self.getUserCurrency() ?? .init()) ?? .USD,
        catteryID: self.getUserID() ?? .init()
    ) {
        didSet {            
            self.callBack?(self.deal)
        }
    }
    private let router: EditDealRouter
    private let interactor: EditDealInteractor
    
    
    init(router: EditDealRouter, interactor: EditDealInteractor, deal: Deal.Input? = nil, isCreate: Bool = true) {
        self.router = router
        self.interactor = interactor
        self.isCreate = isCreate
        
        guard let deal = deal else {
            return
        }
        
        self.deal = deal
    }
    
//    MARK: Properties
    private(set) var petTypes = [PetType.Entity]() {
        didSet {            
            self.secondCallBack?()
        }
    }
        
    var allBreeds: [PetBreed.Entity] {
        var petBreeds = [PetBreed.Entity]()
        
        for petType in self.petTypes {
            petBreeds += petType.petBreeds
        }
        
        return petBreeds
            .sorted { $0.name.first ?? "a" < $1.name.first ?? "a" }
            .sorted { $0.name != "Other" && $1.name == "Other" }
    }
    
//    MARK: Requests
    func createDeal(completionHandler: @escaping (Error?) -> Void) {
        self.interactor.createDeal(self.deal, completionHandler: completionHandler)
    }
    
    func changeDeal(completionHandler: @escaping (Error?) -> Void) {
        self.interactor.changeDeal(self.deal, completionHandler: completionHandler)
    }
    
//    MARK: Notifcation Center
    func notificationCenterManagerPostUpdateProfileScreen() {
        self.interactor.notificationCenterManagerPost(.reloadProfileScreen)
    }
    
    func notificationCenterManagerPostUpdateDealScreen() {
        self.interactor.notificationCenterManagerPost(.reloadDealScreen, additional: self.deal.id?.uuidString)
    }
    
    func notificationCenterManagerPostUpdateFeedScreen() {
        self.interactor.notificationCenterManagerPost(.reloadFeedScreen)
    }
    
//    MARK: User Defaults
    func getUserID() -> UUID? {
        .init(uuidString: self.interactor.getUserDefaults(.id) as? String ?? .init())
    }
    
    func getUserCurrency() -> String? {
        self.interactor.getUserDefaults(.currency) as? String
    }
    
    func getNextDealIsPremium() -> Bool? {
        self.interactor.getUserDefaults(.nextDealIsPremium) as? Bool
    }
    
    func getPremiumUserDate() -> Date? {
        self.interactor.getUserDefaults(.premiumUserDate) as? Date
    }
    
    func setNextDealIsPremium(_ value: Bool) {
        self.interactor.setUserDefaults(value, with: .nextDealIsPremium)
    }
    
    func getDealModes() -> [String]? {
        self.interactor.getUserDefaults(.dealModes) as? [String]
    }
    
    func getPetClasses() -> [String]? {
        self.interactor.getUserDefaults(.petClasses) as? [String]
    }
    
    func getAllCurrencies() -> [String]? {
        self.interactor.getUserDefaults(.currencies) as? [String]
    }
    
    func getCountry() -> String? {
        self.interactor.getUserDefaults(.country) as? String
    }
    
    func getCity() -> String? {
        self.interactor.getUserDefaults(.city) as? String
    }
    
//    MARK: Purchase
    func getProducts(_ completionHandler: @escaping ([SKProduct]) -> Void) {
        PurchaseManager.shared.getProducts([.premiumDeal], callBack: completionHandler)
    }
    
    func makePayment(_ product: SKProduct, completionHandler: @escaping (Error?) -> Void) {
        PurchaseManager.shared.makePayment(product, callBack: completionHandler)
    }
    
//    MARK: Core Data
    func getAllPetTypes(_ completionHandler: @escaping ([PetTypeEntity], Error?) -> Void = { _, _ in }) {
        let newCompletionHandler: ([PetTypeEntity], Error?) -> Void = { [ weak self ] newPetTypes, error in
            completionHandler(newPetTypes, error)
            
            var types = [PetType.Entity]()
            
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                
                return
            }
            
            guard !newPetTypes.isEmpty else {
                print("❌ Error: pet types is empty.")
                
                return
            }
            
            for newPetType in Set(newPetTypes) {
                var type = PetType.Entity(
                    id: newPetType.id,
                    name: newPetType.getLocalizedName() ?? .init(),
                    imageData: newPetType.imageData,
                    petBreeds: .init()
                )
                
                for petBreed in newPetType.petBreeds {
                    type.petBreeds.append(.init(
                        id: petBreed.id,
                        name: "\(petBreed.name ?? .init())",
                        petType: type
                    ))
                }
                
                type.petBreeds = type.petBreeds
                    .sorted { $0.name.first ?? "a" < $1.name.first ?? "a" }
                    .sorted { $0.name != "Other" && $1.name == "Other" }
                
                types.append(type)
            }
            
            self?.petTypes = types.sorted { ["A Cat", "Кошки"].contains($0.name) && !["A Cat", "Кошки"].contains($1.name) }
        }
        
        self.interactor.getAllPetTypes(newCompletionHandler)
    }
    
}
