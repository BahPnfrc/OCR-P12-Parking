//
//  CoreDataController.swift
//  Parking
//
//  Created by Genapi on 22/01/2022.
//

import Foundation
import CoreData

class CoreDataController {

    static let shared = CoreDataController()
    private init(){}

    private let context = AppDelegate.viewContext
    private func saveContext() throws -> Void {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                throw error
            }
        }
    }
}

extension CoreDataController {

    func add(_ station: StationCellItem) {
        let newFavorite = StationFavorite(context: context)
        newFavorite.name = station.cellName()
        newFavorite.timeStamp = Date()
        try? saveContext()
    }

//    func get(stationNamed name: String = "",
//             ascending: Bool = false)  throws -> [StationCellItem] {
//        let request = StationFavorite.fetchRequest()
//        if name.count > 0 {
//            request.predicate = NSPredicate(format: "label CONTAINS[cd] %@", name)
//        }
//        request.sortDescriptors = [
//            NSSortDescriptor(key: "timestamp", ascending: ascending)
//        ]
//        do {
//            return try context.fetch(request).map({ $0.getStations() })
//        } catch <#pattern#> {
//            <#statements#>
//        }
//    }

    func isFavorite(_ station: StationCellItem) -> Bool {
        let request = StationFavorite.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", "\(station.cellName())")
        guard let stations = try? context.fetch(request) else { return false }
        return !stations.isEmpty
    }

    func delete(_ station: StationCellItem) throws -> Void {
        let request = StationFavorite.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", "\(station.cellName())")
        do {
            let result = try context.fetch(request)
            for object in result { context.delete(object)}
            try? saveContext()
        } catch {
            throw error
        }
    }
}
