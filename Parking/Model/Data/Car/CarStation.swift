import Foundation
import SwiftyXMLParser

// MARK: - CarParking
class CarStation {

    static var metadata: CarMetaData?
    static var allStations = [CarStation]()

    let name: String
    let url: String
    let dateTime: Date
    let shortName, status: String
    let free, total: Int

    enum CodingKeys: String, CodingKey {
        case dateTime = "DateTime"
        case shortName = "Name"
        case status = "Status"
        case free = "Free"
        case total = "Total"
    }

    private init(name: String, url: String, dateTime: Date, shortName: String, status: String, free: Int, total: Int) {
        self.name = name
        self.url = url
        self.dateTime = dateTime
        self.shortName = shortName
        self.status = status
        self.free = free
        self.total = total
    }
}

// MARK: - XML Data Parsing
extension CarStation {
    static func parseCarXML(name: String, url: String, with accessor: XML.Accessor) -> CarStation? {
        guard let dateTime = accessor["park", CodingKeys.dateTime.rawValue].text,
              let shortName = accessor["park", CodingKeys.shortName.rawValue].text,
              let status = accessor["park", CodingKeys.status.rawValue].text,
              let free = accessor["park", CodingKeys.free.rawValue].text,
              let total = accessor["park", CodingKeys.total.rawValue].text else {
                  print("🟥 CAR PARKING : KO")
                  return nil
              }

        let carParKing = CarStation(
            name: name,
            url: url,
            dateTime: formattedDate(from: dateTime),
            shortName: shortName,
            status: status,
            free: Int(free) ?? 0,
            total: Int(total) ?? 0)
        print("🟩 CAR PARKING : OK @\(name) :", free, "sur", total)
        return carParKing
    }

    private static func formattedDate(from dateStr: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss"
        let trimmedDateStr = dateStr.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        return dateFormatter.date(from: trimmedDateStr)!
    }
}
