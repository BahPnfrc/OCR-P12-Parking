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

    func cellDisplayableFreePlace() -> String
    func cellDisplayableUpdatedTime() -> String

    func cellIsFavorite() -> Bool
    func cellFavoriteAdd() -> Void
    func cellFavoriteDelete() throws -> Void
}
