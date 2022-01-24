//
//  BikeProtocol.swift
//  Parking
//
//  Created by Genapi on 20/01/2022.
//

import Foundation

// MARK: BikeStation Protocol conforming

extension BikeStation: StationCellItem {
    var cellType: CellType {
        .Bike
    }

    var cellIsLoaded: Bool {
        true
    }

    func cellName() -> String {
        self.name
    }

    func cellFreePlaces() -> Int {
        self.free
    }

    func cellTotalPlaces() -> Int {
        self.total
    }

    func cellCoordonates() -> (Lat: Double, Lon: Double)? {
        (self.latitude, self.longitude)
    }

    func cellUpdatedTime() -> Date? {
        self.lastTimeReloaded ?? nil
    }
}
