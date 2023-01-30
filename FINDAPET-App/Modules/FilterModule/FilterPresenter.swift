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
    private(set) var petTypes = [PetTypeEntity]() {
        didSet {
            self.callBack?()
        }
    }
        
    var allBreeds: [PetBreedEntity] {
        var petBreeds = [PetBreedEntity]()
        
        for petType in self.petTypes {
            guard let breeds = petType.petBreeds else {
                continue
            }
            
            petBreeds += breeds
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
        let newCompletionHandler = { [ weak self ] petTypes, error in
            completionHandler(petTypes, error)
            
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                
                return
            }
            
            guard !petTypes.isEmpty else {
                print("❌ Error: pet types is empty.")
                
                return
            }
            
            self?.petTypes = petTypes
        }
        
        self.interactor.getAllPetTypes(newCompletionHandler)
    }
    
}
