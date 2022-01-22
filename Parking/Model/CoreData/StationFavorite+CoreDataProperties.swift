//
//  StationFavorite+CoreDataProperties.swift
//  Parking
//
//  Created by Genapi on 22/01/2022.
//
//

import Foundation
import CoreData


extension StationFavorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StationFavorite> {
        return NSFetchRequest<StationFavorite>(entityName: "StationFavorite")
    }

    @NSManaged public var name: String?
    @NSManaged public var timeStamp: Date?

}

extension StationFavorite : Identifiable {

}
