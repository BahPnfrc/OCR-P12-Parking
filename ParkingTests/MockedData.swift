import Foundation

class MockedData {

    // MARK: - URL

    static let bikeMetaDataURL = URL(string: "https://data.montpellier3m.fr/api/3/action/resource_show?id=adb98f8d-c4d2-4012-8abe-cf02903e2ea0")!

    static let carMetaDataURL = URL(string: "https://data.montpellier3m.fr/api/3/action/package_show?id=90e17b94-989f-4d66-83f4-766d4587bec2")!

    static let carXmlURL = URL(string: "https://data.montpellier3m.fr/sites/default/files/ressources/FR_MTP_ANTI.xml")!

    static let bikeXmlURL = URL(string: "https://data.montpellier3m.fr/sites/default/files/ressources/TAM_MMM_VELOMAG.xml")!

    // MARK: - DATA OK

    public static var bikeMetaDataOK: Data = try! Data(
        contentsOf: Bundle(for: MockedData.self)
            .url(forResource: "BikeMetaData", withExtension: "json")!)
    public static var carMetaDataOK: Data = try! Data(
        contentsOf: Bundle(for: MockedData.self)
            .url(forResource: "CarMetaData", withExtension: "json")!)
    public static var carXmlDataOK: Data = try! Data(
        contentsOf: Bundle(for: MockedData.self)
            .url(forResource: "CarXmlData", withExtension: "xml")!)
    public static var bikeXmlDataOK: Data = try! Data(
        contentsOf: Bundle(for: MockedData.self)
            .url(forResource: "BikeXmlData", withExtension: "xml")!)

    // MARK: - DATA KO

    public static let bikeMetaDataKO = "someBikeMetaData".data(using: .utf8)!
    public static let carMetaDataKO = "someCarMetaData".data(using: .utf8)!
    public static let bikeXmlDataKO = "someBikeData".data(using: .utf8)!
    public static let carXmlDataKO = "someCarData".data(using: .utf8)!

    
}
