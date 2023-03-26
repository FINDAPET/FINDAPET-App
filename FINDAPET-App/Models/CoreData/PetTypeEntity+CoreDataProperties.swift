//
//  PetTypeEntity+CoreDataProperties.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 19.03.2023.
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
    @NSManaged public var name: String
    @NSManaged public var petBreeds: Set<PetBreedEntity>

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

//MARK: Extension Identifiable
extension PetTypeEntity: Identifiable { }
