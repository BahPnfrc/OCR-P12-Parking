//
//  CarProtocol.swift
//  Parking
//
//  Created by Genapi on 20/01/2022.
//

import Foundation

extension CarStation: StationCellItem {
    var cellType: CellType {
        .Car
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
        nil
    }

    func cellUpdatedTime() -> Date? {
        nil
    }
}
