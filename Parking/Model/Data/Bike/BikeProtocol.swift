//
//  BikeProtocol.swift
//  Parking
//
//  Created by Genapi on 20/01/2022.
//

import Foundation

extension BikeStation: StationCellItem {
    var cellType: CellType {
        .Bike
    }

    var isLoaded: Bool {
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
        nil
    }
}
