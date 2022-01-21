//
//  StationCell+Protocole.swift
//  Parking
//
//  Created by Genapi on 20/01/2022.
//

import Foundation

enum CellType {
    case Car, Bike
}

protocol StationCellItem {
    var cellType: CellType { get }
    var isLoaded: Bool { get }

    func cellName() -> String
    func cellFreePlaces() -> Int
    func cellTotalPlaces() ->Int
    func cellCoordonates() -> (Lat: Double, Lon: Double)?
    func cellUpdatedTime() -> Date?

    func cellPlacesLabel() -> String
    func cellUpdatedLabel() -> String

}

extension StationCellItem {
    func cellPlacesLabel() -> String {
        "Disponibilité :\t\(cellFreePlaces()) sur \(cellTotalPlaces())"
    }

    func cellUpdatedLabel() -> String {
        "Mise-à-jour :\t*inconnue*"
    }
}
