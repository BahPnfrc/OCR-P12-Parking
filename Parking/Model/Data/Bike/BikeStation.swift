import Foundation
import SwiftyXMLParser

// MARK: - BikeStation

class BikeStation {

    static var metadata: BikeMetaData?
    static var allStations = [StationCellItem]()

    let name: String
    let id: Int
    let latitude: Double
    let longitude: Double
    let free: Int
    let total: Int

    enum CodingKeys: String, CodingKey {
        case name = "na"
        case id
        case latitude = "la"
        case longitude = "lg"
        case free = "fr"
        case total = "to"
    }

    let lastTimeReloaded: Date?

    init(name: String, id: Int, latitude: Double, longitude: Double, free: Int, total: Int) {
        self.name = name
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.free = free
        self.total = total
        self.lastTimeReloaded = Date()
    }
}

// MARK: BikeStation Extension

extension BikeStation {

    /// Func : Parse MetaData JSON for a single XML file retrieving all stations details at once.
    ///  - parameter metadata: a JSON object retrieved from the bike MetaData func.
    ///  - returns : an array of bike stations objects with all details inside.
    static func getBikeStations(from metadata: BikeMetaData, completion: @escaping (Result<[BikeStation], ApiError>) -> Void) {
        let url = metadata.result.result.url
        NetworkService.shared.getRemoteXmlData(fromUrl: url) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let accessor):
                guard let stations = accessor["vcs", "sl", "si"].all, stations.count > 0 else {
                    return
                }
                var allStations = [BikeStation]()
                for station in stations {
                    if let bikeStation = BikeStation.parseBikeXML(with: station) {
                        allStations.append(bikeStation)
                    }
                }
                completion(.success(allStations))
            }
        }
    }

    // MARK: XML Data Parsing

    static func parseBikeXML(with element: XML.Element) -> BikeStation? {
        guard let name = element.attributes[CodingKeys.name.rawValue],
              let id = element.attributes[CodingKeys.id.rawValue],
              let latitude = element.attributes[CodingKeys.latitude.rawValue],
              let longitude = element.attributes[CodingKeys.longitude.rawValue],
              let free = element.attributes[CodingKeys.free.rawValue],
              let total = element.attributes[CodingKeys.total.rawValue] else {
                  print("🟥 BIKE STATION XML : KO")
                  return nil
              }

        let bikeStation = BikeStation(
            name: name,
            id: Int(id) ?? 0,
            latitude: Double(latitude) ?? 0,
            longitude: Double(longitude) ?? 0,
            free: Int(free) ?? 0,
            total: Int(total) ?? 0)
        print("🟩 BIKE STATION \(name) :", free, "libre(s) sur", total)
        return bikeStation
    }
}
