import Foundation

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
