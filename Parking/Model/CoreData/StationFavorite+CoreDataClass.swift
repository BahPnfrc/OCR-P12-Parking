import Foundation
import CoreData

@objc(StationFavorite)
public class StationFavorite: NSManagedObject {}

// MARK: - StationFavorite Extension

extension StationFavorite {
    /// Func : return the matching stationCellItem from a CodeData object
    func getStation() -> StationCellItem? {
        return BikeStation.allStations.first(where: { $0.cellName() == self.name })
        ?? CarStation.allStations.first(where: { $0.cellName() == self.name })
        ?? nil
    }
}
