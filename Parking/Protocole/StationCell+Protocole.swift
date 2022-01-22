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
        "Place : \(cellFreePlaces()) sur \(cellTotalPlaces())"
    }

    func cellUpdatedLabel() -> String {
        staticDateTime()
    }

    private func staticDateTime() -> String {
        var dateAsString = "Inconnue"
        if let date = cellUpdatedTime() {
            let format = DateFormatter()
            format.dateFormat = "d/MM @ HH:mm:ss"
            dateAsString = format.string(from: date)
        }
        return "Date : \(dateAsString)"
    }

    private func dynamicDateTime() -> String {
        var dateAsString = "Inconnu"
        if let date = cellUpdatedTime() {
            let now = Date()
            let interval = date.distance(to: now)
            dateAsString = distanceToString(interval)
        }
        return "Délai : \(dateAsString)"
    }

    private func distanceToString(_ interval: TimeInterval) -> String {
        var min = 0
        var hour = 0
        var interval = interval
        while interval >= 60 {
            interval -= 60
            min += 1
        }
        while min >= 60 {
            min -= 60
            hour += 1
        }
        if hour > 1 {
            return "\(hour) heures"
        } else if min > 1 {
            return "\(min) minutes"
        } else {
            return "Très récent"
        }
    }
}
