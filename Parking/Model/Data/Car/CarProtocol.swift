import Foundation

// MARK: CarStation Protocol conforming

extension CarStation: StationCellItem {
    var cellType: CellType {
        .Car
    }

    var cellIsLoaded: Bool {
        self.values != nil
    }

    func cellName() -> String {
        self.name
    }

    func cellFreePlaces() -> Int {
        self.values?.free ?? 0
    }

    func cellTotalPlaces() -> Int {
        self.values?.total ?? 0
    }

    func cellCoordonates() -> (Lat: Double, Lon: Double)? {
        nil
    }

    func cellUpdatedTime() -> Date? {
        self.values?.lastTimeReloaded ?? nil
    }
}
