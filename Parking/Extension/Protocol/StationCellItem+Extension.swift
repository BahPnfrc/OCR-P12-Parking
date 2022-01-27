import Foundation
import UIKit

// MARK: - Displayable Extension

/// Extension : contains defaults StationCellItem values for all object conforming to this protocol
extension StationCellItem {
    func cellLabelForFreePlace() -> String {
        let free = cellFreePlaces()
        switch free {
        case 0:
            return "Libre : aucune sur \(cellTotalPlaces())"
        case 1:
            return "Libre : \(free) seule sur \(cellTotalPlaces())"
        default:
            return "Libres : \(free) sur \(cellTotalPlaces())"
        }
    }

    /// Time can be displayed in two different ways :
    /// - staticUpdatedTime : date time of last reloading
    /// - dynamicUpdatedTime : time passed since last reloading
    func cellLabelForUpdatedTime() -> String {
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
            dateAsString = timePassedIn(interval)
        }
        return "Délai : \(dateAsString)"
    }

    private func timePassedIn(_ interval: TimeInterval) -> String {
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

/// Extension : contains defaults StationCellItem values for all object CoreData's operation
extension StationCellItem {
    func cellIsFavorite() -> Bool {
        do {
            return try CoreDataService.shared.isFavorite(self)
        } catch {
            print("🟥 COREDATA : \(#function) failed.")
            return false
        }
    }
    func cellFavoriteAdd() -> Void {
        do {
            try CoreDataService.shared.add(self)
        } catch {
            print("🟥 COREDATA : \(#function) failed.")
            return
        }
    }
    func cellFavoriteDelete() throws -> Void {
        do {
            try CoreDataService.shared.delete(self)
        } catch {
            print("🟥 COREDATA : \(#function) failed.")
            return
        }
    }
}
