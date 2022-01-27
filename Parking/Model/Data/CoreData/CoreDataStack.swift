import Foundation
import CoreData

public enum CoreDataStorage {
  case persistent, inMemory
}

public enum CoreDataError: Error {
    case saving
}

open class CoreDataStack {

    // MARK: - Variable

    let persistentContainer: NSPersistentContainer

    // MARK: - Initializer

    public init(_ storageType: CoreDataStorage = .persistent) {
        self.persistentContainer = NSPersistentContainer(name: "Parking")
        if storageType == .inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            self.persistentContainer.persistentStoreDescriptions = [description]
        }
        self.persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }

    // MARK: - Core Data stack

    public var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    public func saveContext() throws {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
            throw CoreDataError.saving
        }
    }
}
