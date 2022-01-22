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
    func getStations() -> [StationCellItem] {
        let car = CarStation.allStations
            .filter({ $0.cellName() == self.name }) as [StationCellItem]
        let bike = BikeStation.allStations
            .filter({ $0.cellName() == self.name }) as [StationCellItem]
        return car + bike
    }
}
