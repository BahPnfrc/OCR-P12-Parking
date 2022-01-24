//
//  CoreDataService.swift
//  Parking
//
//  Created by Genapi on 22/01/2022.
//

import Foundation
import CoreData

// MARK: - CoreDataService

class CoreDataService {

    static let shared = CoreDataService()
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

// MARK: - CoreDataService Extension

extension CoreDataService {

    func add(_ station: StationCellItem) {
        let newFavorite = StationFavorite(context: context)
        newFavorite.name = station.cellName()
        newFavorite.timeStamp = Date()
        try? saveContext()
    }

    func isFavorite(_ station: StationCellItem) -> Bool {
        let request = StationFavorite.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", "\(station.cellName())")
        guard let stations = try? context.fetch(request) else { return false }
        return !stations.isEmpty
    }

    func getAllFavorites(ascending: Bool = false) throws -> [StationCellItem] {
        let request = StationFavorite.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "timeStamp", ascending: ascending)
        ]
        do {
            return try context.fetch(request).compactMap({ $0.getStation() })
        } catch {
            throw error
        }
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
