import XCTest
import Foundation
import CoreData
@testable import Parking

public extension NSManagedObject {
    /// Help void "warning: Multiple NSEntityDescriptions claim the NSManagedObject subclass"
    convenience init(usedContext: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: usedContext)!
        self.init(entity: entity, insertInto: usedContext)
    }
}

class CoreDataServiceTests: XCTestCase {

    // MARK: - Properties

    var service: CoreDataService!

    // MARK: - Initializing

    override func setUpWithError() throws {
        try super.setUpWithError()
        CarStation.allStations.removeAll()
        service = CoreDataService(.inMemory)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        service = nil
    }

    // MARK: - Mocked Data

    private func randomString(_ length: Int = 10) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }

    private func randomArray(_ lines: Int = 3) -> [String] {
        var array = [String]()
        for _ in 0...abs(lines) - 1 { array.append(randomString()) }
        return array
    }

    private func randomInt(_ from: Int = 1, _ to: Int = 1000) -> Int {
        return Int.random(in: from..<to)
    }

    private func randomValues() -> CarValues {
        return CarValues(
            lastTimeReloaded: Date(),
            shortName: randomString(),
            status: randomString(),
            free: randomInt(),
            total: randomInt())
    }

    private func randomCell(named name: String? = nil) -> StationCellItem {
        let carStation = CarStation(
            name: name ?? randomString(),
            url: randomString())
        carStation.values = randomValues()
        CarStation.allStations.append(carStation)
        return carStation as StationCellItem
    }

    // MARK: - add tests

    func testGiven_when_then() throws {
        // Given
        // When
        // Then
    }

    func testGivenAnyCell_whenSaving_thenCellIsSaved() throws {
        // Given
        let cell = randomCell()
        // When
        do { try service.add(cell) }
        catch { XCTFail() }
        do { let result = try service.getAll()
            XCTAssertNotNil(result)
            // Then
            XCTAssertEqual(result.count, 1)
        } catch {
            print(error)
            XCTFail()
        }
    }

    // MARK: - isFavorite tests

    func testGivenAnyCell_whenSaving_thenCellIsFavorite() throws {
        // Given
        let cell = randomCell()
        // When
        do { try service.add(cell) }
        catch { XCTFail() }
        do { let result = try service.getAll()
            XCTAssertNotNil(result)
            // Then
            XCTAssertTrue(try service.isFavorite(cell))
        } catch {
            print(error)
            XCTFail()
        }
    }

    // MARK: - getAllFavorites tests

    // Not required

    // MARK: - delete tests

    func testGivenAnyCellIsFavorite_whenDeleting_thenCellIsNotFavorite() throws {
        // Given
        let cell = randomCell()
        do {
            try service.add(cell)
            XCTAssertTrue(try service.isFavorite(cell))
        }
        catch { XCTFail() }
        // When
        do { try service.delete(cell)
            // Then
            XCTAssertTrue(try !service.isFavorite(cell))
        } catch {
            print(error)
            XCTFail()
        }
    }

    // MARK: - error test

    func testGivenAnyCellIsFavorite_whenSaving_thenErrorIsThrown() throws {
        // Given
        let cell = randomCell()
        do {
            try service.add(cell)
            XCTAssertTrue(try service.isFavorite(cell))
        }
        catch { XCTFail() }
        // When
        XCTAssertThrowsError(try service.add(cell)) { error in
            // Then
            XCTAssertEqual(error as! CoreDataError, CoreDataError.saving)
        }
    }
}
