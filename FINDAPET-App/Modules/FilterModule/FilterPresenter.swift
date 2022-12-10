//
//  FilterPresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 14.11.2022.
//

import Foundation

final class FilterPresenter {
    
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
    
//    MARK: Editing
    func setPetType(_ petType: String? = nil) {
        self.filter.petType = .getPetType(petType ?? .init())
    }
    
    func setPetBreed(_ petBreed: String? = nil) {
        self.filter.petBreed = .getPetBreed(petBreed ?? .init())
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
    
    func getTypesClasses() -> [String]? {
        self.interactor.getUserDefaults(.petTypes) as? [String]
    }
    
    func getPetBreeds() -> [String]? {
        self.interactor.getUserDefaults(.petBreeds) as? [String]
    }
    
    func getCatBreeds() -> [String]? {
        self.interactor.getUserDefaults(.catBreeds) as? [String]
    }
    
    func getDogBreeds() -> [String]? {
        self.interactor.getUserDefaults(.dogBreeds) as? [String]
    }
    
    func getPetType() -> [String]? {
        self.interactor.getUserDefaults(.petTypes) as? [String]
    }
    
}
