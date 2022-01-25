import Foundation
import CoreData

// MARK: - StationFavorite Extension

extension StationFavorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StationFavorite> {
        return NSFetchRequest<StationFavorite>(entityName: "StationFavorite")
    }

    @NSManaged public var name: String?
    @NSManaged public var timeStamp: Date?

}

extension StationFavorite : Identifiable {}
