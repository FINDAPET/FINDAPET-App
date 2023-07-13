//
//  PetTypeEntity+CoreDataProperties.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 13.07.2023.
//
//

import Foundation
import CoreData


extension PetTypeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PetTypeEntity> {
        return NSFetchRequest<PetTypeEntity>(entityName: "PetTypeEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var imageData: Data
    @NSManaged public var petBreeds: Set<PetBreedEntity>
    @NSManaged public var localizedNames: Set<LocalizedPetTypeNameEntity>
    
    func getLocalizedName(for languageCode: String) -> String? {
        self.localizedNames.first { $0.languageCode == languageCode }?.value ?? self.localizedNames.first { $0.languageCode == "en" }?.value
    }
    
    func getLocalizedName() -> String? {
        if #available(iOS 16, *) {
            return self.getLocalizedName(for: Locale.current.language.languageCode?.identifier.lowercased() ?? "en") ?? self.getLocalizedName(for: "en")
        }
        
        return self.getLocalizedName(for: Locale.current.languageCode?.lowercased() ?? "en") ?? self.getLocalizedName(for: "en")
    }

}

// MARK: Generated accessors for petBreeds
extension PetTypeEntity {

    @objc(addPetBreedsObject:)
    @NSManaged public func addToPetBreeds(_ value: PetBreedEntity)

    @objc(removePetBreedsObject:)
    @NSManaged public func removeFromPetBreeds(_ value: PetBreedEntity)

    @objc(addPetBreeds:)
    @NSManaged public func addToPetBreeds(_ values: Set<PetBreedEntity>)

    @objc(removePetBreeds:)
    @NSManaged public func removeFromPetBreeds(_ values: Set<PetBreedEntity>)

}

// MARK: Generated accessors for localizedNames
extension PetTypeEntity {

    @objc(addLocalizedNamesObject:)
    @NSManaged public func addToLocalizedNames(_ value: LocalizedPetTypeNameEntity)

    @objc(removeLocalizedNamesObject:)
    @NSManaged public func removeFromLocalizedNames(_ value: LocalizedPetTypeNameEntity)

    @objc(addLocalizedNames:)
    @NSManaged public func addToLocalizedNames(_ values: Set<LocalizedPetTypeNameEntity>)

    @objc(removeLocalizedNames:)
    @NSManaged public func removeFromLocalizedNames(_ values: Set<LocalizedPetTypeNameEntity>)

}
