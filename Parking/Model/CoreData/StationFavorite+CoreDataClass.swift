//
//  StationFavorite+CoreDataClass.swift
//  Parking
//
//  Created by Genapi on 22/01/2022.
//
//

import Foundation
import CoreData

@objc(StationFavorite)
public class StationFavorite: NSManagedObject {}

extension StationFavorite {
    func getStation() -> StationCellItem? {
        return BikeStation.allStations.first(where: { $0.cellName() == self.name })
        ?? CarStation.allStations
            .first(where: { $0.cellName() == self.name })
        ?? nil
    }
}
