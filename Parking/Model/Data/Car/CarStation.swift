import Foundation
import SwiftyXMLParser

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
}

// MARK: - CarStation Extension

extension CarStation {
    ///  - returns : an array of car stations objects containing name and URL to load details from.
    static func getCarStations(from metadata: CarMetaData) -> [CarStation] {
        let ressources = metadata.result.resources
        var stations = [CarStation]()
        for resource in ressources {
            let url = resource.url
            let name = resource.name
            guard !name.contains("_") else { continue } // Skip certains objects
            let parking = CarStation(name: name, url: url)
            stations.append(parking)
        }
        return stations
    }

    // MARK: - XML Data Parsing

    static func parseCarXML(for name: String, with accessor: XML.Accessor) -> CarValues? {
        guard let dateTime = accessor["park", CarValues.CodingKeys.dateTime.rawValue].text,
              let shortName = accessor["park", CarValues.CodingKeys.shortName.rawValue].text,
              let status = accessor["park", CarValues.CodingKeys.status.rawValue].text,
              let free = accessor["park", CarValues.CodingKeys.free.rawValue].text,
              let total = accessor["park", CarValues.CodingKeys.total.rawValue].text else {
                  if Setting.showXML {
                      print("🟥 CAR STATION : XML KO")
                  }
                  return nil
              }

        let values = CarValues(
            lastTimeReloaded: dateTime.formattedDate(),
            shortName: shortName,
            status: status,
            free: Int(free) ?? 0,
            total: Int(total) ?? 0)
        if Setting.showXML {
            print("🟦 CAR STATION", name, ":", free, "libre(s) sur", total)
        }
        return values
    }
}
