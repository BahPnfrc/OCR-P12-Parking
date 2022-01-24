//
//  StationCellItem+Extension.swift
//  Parking
//
//  Created by Genapi on 22/01/2022.
//

import Foundation

// MARK: - Displayable Extension

extension StationCellItem {
    func cellDisplayableFreePlace() -> String {
        let free = cellFreePlaces()
        if free > 1 {
            return "Libres : \(free) sur \(cellTotalPlaces())"
        } else {
            return "Libre : \(free) sur \(cellTotalPlaces())"
        }
    }
    func cellDisplayableUpdatedTime() -> String {
        staticUpdatedTime()
    }

    private func staticUpdatedTime() -> String {
        var dateAsString = "Inconnue"
        if let date = cellUpdatedTime() {
            let format = DateFormatter()
            format.dateFormat = "dd/MM/yy à HH:mm"
            dateAsString = format.string(from: date)
        }
        return "Date : \(dateAsString)"
    }

    private func dynamicUpdatedTime() -> String {
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

// MARK: - Favorite Extension

extension StationCellItem {
    func cellIsFavorite() -> Bool {
        return CoreDataService.shared.isFavorite(self)
    }
    func cellFavoriteAdd() -> Void {
        CoreDataService.shared.add(self)
    }
    func cellFavoriteDelete() throws -> Void {
        try CoreDataService.shared.delete(self)
    }
}
