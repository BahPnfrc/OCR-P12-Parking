import Foundation
import SwiftyXMLParser

// MARK: - BikeStation
class BikeStation {

    static var metadata: BikeMetaData?
    static var allStations = [BikeStation]()

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

    init(name: String, id: Int, latitude: Double, longitude: Double, free: Int, total: Int) {
        self.name = name
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.free = free
        self.total = total
    }
}

// MARK: XML Data Parsing
extension BikeStation {
    static func parseBikeXML(with element: XML.Element) -> BikeStation? {
        guard let name = element.attributes[CodingKeys.name.rawValue],
              let id = element.attributes[CodingKeys.id.rawValue],
              let latitude = element.attributes[CodingKeys.latitude.rawValue],
              let longitude = element.attributes[CodingKeys.longitude.rawValue],
              let free = element.attributes[CodingKeys.free.rawValue],
              let total = element.attributes[CodingKeys.total.rawValue] else {
                  print("🟥 BIKE STATION : KO")
                  return nil
              }

        let bikeStation = BikeStation(
            name: name,
            id: Int(id) ?? 0,
            latitude: Double(latitude) ?? 0,
            longitude: Double(longitude) ?? 0,
            free: Int(free) ?? 0,
            total: Int(total) ?? 0)
        print("🟩 BIKE STATION : OK @\(name) :", free, "sur", total)
        return bikeStation
    }

    private static func formattedDate(from dateStr: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss"
        let trimmedDateStr = dateStr.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        return dateFormatter.date(from: trimmedDateStr)!
    }
}
