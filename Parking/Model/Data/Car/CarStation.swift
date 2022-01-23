import Foundation
import SwiftyXMLParser

// MARK: - CarValues

struct CarValues {
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

    func reloadValues() {
        NetworkService.shared.getRemoteXmlData(fromUrl: url) { result in
            switch result {
            case .failure:
                print("🟧 CAR STATION XML : \(self.name)")
                self.values = nil
                return
            case .success(let accessor):
                guard let values = CarStation.parseCarXML(for: self.name, with: accessor) else {
                    self.values = nil
                    return
                }
                self.values = values
                return
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
                  print("🟥 CAR STATION XML : \(name)")
                  return nil
              }

        let values = CarValues(
            dateTime: formattedDate(from: dateTime),
            shortName: shortName,
            status: status,
            free: Int(free) ?? 0,
            total: Int(total) ?? 0)
        print("🟦 CAR STATION : OK@\(name) :", free, "sur", total)
        return values
    }

    private static func formattedDate(from dateStr: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss"
        let trimmedDateStr = dateStr.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        return dateFormatter.date(from: trimmedDateStr)!
    }
}
