import Foundation

// MARK: - CarMetadata
struct CarMetaData: Codable {
    let help: String
    let success: Bool
    let result: CarMetaResult
}

// MARK: - CarResult
struct CarMetaResult: Codable {
    let revisionTimestamp, metadataCreated, metadataModified: String
    let resources: [CarMetaRessource]
    let numResources: Int

    enum CodingKeys: String, CodingKey {
        case revisionTimestamp = "revision_timestamp"
        case metadataCreated = "metadata_created"
        case metadataModified = "metadata_modified"
        case resources
        case numResources = "num_resources"
    }
}

// MARK: - Resource
struct CarMetaRessource: Codable {
    let id, url, name: String
    let created: String
    let modified: String
    let position: Int

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case name
        case created
        case modified = "last_modified"
        case position
    }
}
