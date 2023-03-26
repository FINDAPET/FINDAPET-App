//
//  FilterPresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 14.11.2022.
//

import Foundation

final class FilterPresenter {
    
    var callBack: (() -> Void)?
    private(set) var filter: Filter
    private let saveAction: (Filter) -> Void
    private let rotuer: FilterRouter
    private let interactor: FilterInteractor
    
    init(filter: Filter, saveAction: @escaping (Filter) -> Void, rotuer: FilterRouter, interactor: FilterInteractor) {
        self.filter = filter
        self.saveAction = saveAction
        self.rotuer = rotuer
        self.interactor = interactor
    }
    
//    MARK: Properties
    private(set) var petTypes = [PetType.Entity]() {
        didSet {
            self.callBack?()
        }
    }
        
    var allBreeds: [PetBreed.Entity] {
        var petBreeds = [PetBreed.Entity]()
        
        for petType in self.petTypes {
            petBreeds += petType.petBreeds
        }
        
        return petBreeds
    }
    
//    MARK: Editing
    func setPetType(_ petTypeID: UUID? = nil) {
        self.filter.petTypeID = petTypeID
    }
    
    func setPetBreed(_ petBreedID: UUID? = nil) {
        self.filter.petBreedID = petBreedID
    }
    
    func setPetClass(_ petClass: String? = nil) {
        self.filter.petClass = .getPetClass(petClass ?? .init())
    }
    
    func setIsMale(_ isMale: Bool? = nil) {
        self.filter.isMale = isMale
    }
    
    func setCountry(_ country: String? = nil) {
        self.filter.country = country
    }
    
    func setCity(_ city: String? = nil) {
        self.filter.city = city
    }
    
    func resetFilter() {
        self.filter = Filter(title: self.filter.title)
    }
    
//    MARK: Actions
    func saveFilter() {
        self.saveAction(self.filter)
    }
    
//    MARK: User Defaults
    func getDealModes() -> [String]? {
        self.interactor.getUserDefaults(.dealModes) as? [String]
    }
    
    func getPetClasses() -> [String]? {
        self.interactor.getUserDefaults(.petClasses) as? [String]
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
                    name: newPetType.name,
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
            
            self?.petTypes = types
        }
        
        self.interactor.getAllPetTypes(newCompletionHandler)
    }
    
}
