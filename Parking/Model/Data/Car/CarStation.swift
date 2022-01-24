import Foundation
import SwiftyXMLParser

// MARK: - CarValues

struct CarValues {
    /// Force dateTime as optionnal because it might be converted while parsing XML.
    let lastTimeReloaded: Date?
    let shortName, status: String
    let free, total: Int

    enum CodingKeys: String, CodingKey {
        case dateTime = "DateTime"
        case shortName = "Name"
        case status = "Status"
        case free = "Free"
        case total = "Total"
    }
}

// MARK: - CarParking

class CarStation {

    static var metadata: CarMetaData?
    static var allStations = [StationCellItem]()

    let name: String
    let url: String
    var values: CarValues?

    init(name: String, url: String) {
        self.name = name
        self.url = url
    }

    /// CarStation are divided into several XML files which all imply their own API call.
    /// Var and func here help  keep track of syncronous return to make sure all XML were loaded.
    private static var reloadedValuesCount = 0
    static func canReloadValues() -> Bool { reloadedValuesCount == 0 }
    static func initReloadvalues() -> Void { CarStation.reloadedValuesCount = 0 }

    /// Func : reload a single object or several in a loop.
    /// SInce it's done a syncronous way, a notification will be sent only once all object sent back a result.
    /// - parameter totalElements: number of elements to loop through and expect result from.
    func reloadValues(inLoopOf totalElements: Int? = nil) {
        NetworkService.shared.reloadCarValues(for: self) { result in
            CarStation.reloadedValuesCount += 1
            guard let totalElements = totalElements else { return }
            if CarStation.reloadedValuesCount == totalElements {
                NotificationCenter.default.post(Notification.carIsReadyToCount)
                CarStation.initReloadvalues()
            }
        }
    }
}

// MARK: - XML Data Parsing

extension CarStation {
static func parseCarXML(for name: String, with accessor: XML.Accessor) -> CarValues? {
        guard let dateTime = accessor["park", CarValues.CodingKeys.dateTime.rawValue].text,
              let shortName = accessor["park", CarValues.CodingKeys.shortName.rawValue].text,
              let status = accessor["park", CarValues.CodingKeys.status.rawValue].text,
              let free = accessor["park", CarValues.CodingKeys.free.rawValue].text,
              let total = accessor["park", CarValues.CodingKeys.total.rawValue].text else {
                  print("🟥 CAR STATION XML : KO")
                  return nil
              }

        let values = CarValues(
            lastTimeReloaded: dateTime.formattedDate(),
            shortName: shortName,
            status: status,
            free: Int(free) ?? 0,
            total: Int(total) ?? 0)
        print("🟦 CAR STATION \(name) :", free, "libre(s) sur", total)
        return values
    }
}
