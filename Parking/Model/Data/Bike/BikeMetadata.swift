//   let bikeMetadata = try? newJSONDecoder().decode(BikeMetadata.self, from: jsonData)

import Foundation

// MARK: - BikeMetadata
struct BikeMetadata: Codable {
    let help: String
    let success: Bool
    let result: BikeTopResult
}

// MARK: - BikeTopResult
struct BikeTopResult: Codable {
    let help: String
    let success: Bool
    let result: BikeSubResult
}

// MARK: - BikeSubResult
struct BikeSubResult: Codable {
    let id: String
    let url: String
    let format, revisionTimestamp, name, mimetype: String
    let size, created, lastModified: String

    enum CodingKeys: String, CodingKey {
        case id, url, format
        case revisionTimestamp = "revision_timestamp"
        case name, mimetype, size, created
        case lastModified = "last_modified"
    }
}
