import Foundation
import UIKit
import SwiftyXMLParser
import Alamofire

class NetworkService {

    static let shared = NetworkService()
    private init() {}

    let printXmlToConsole = false

    private var carSession = Alamofire.Session(configuration: URLSessionConfiguration.default)
    private var bikeSession = Alamofire.Session(configuration: URLSessionConfiguration.default)
    private var xmlSession = Alamofire.Session(configuration: URLSessionConfiguration.default)

    init(bikeSession: Session) {
        self.bikeSession = bikeSession
    }
    init(carSession: Session) {
        self.carSession = carSession
    }
    init(xmlSession: Session) {
        self.xmlSession = xmlSession
    }

    private let montpellier3mURL = "https://data.montpellier3m.fr/api/3/"

    private let bikeEndpoint = "action/resource_show?"
    private let carEndpoint = "action/package_show?"

    private static let bikeMetaDataID = "adb98f8d-c4d2-4012-8abe-cf02903e2ea0"
    private static let carMetaDataID = "90e17b94-989f-4d66-83f4-766d4587bec2"

    private struct MetaParams: Encodable {
        let id: String
    }

    // MARK: - Bike Stations

    private let bikeMetaParams = MetaParams(
        id: NetworkService.bikeMetaDataID
    )

    func getBikeMetaData(completion: @escaping (Result<BikeMetaData, ApiError>) -> Void) {
        bikeSession.request(montpellier3mURL + bikeEndpoint,
                   method: .get,
                   parameters: bikeMetaParams).response { response in
            guard response.error == nil,
                  response.response?.statusCode == 200,
                  let data = response.data else {
                      completion(.failure(.server))
                      return
                  }
            guard let bikeMetadata = try? JSONDecoder().decode(BikeMetaData.self, from: data) else {
                completion(.failure(.decoding))
                return
            }
            completion(.success(bikeMetadata))
        }
    }

    func getBikeStations(from metadata: BikeMetaData, completion: @escaping (Result<[BikeStation], ApiError>) -> Void) {
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

    // MARK: - Car Stations

    private let carMetaParams = MetaParams(
        id: NetworkService.carMetaDataID
    )

    func getCarMetaData(
        completion: @escaping (Result<CarMetaData, ApiError>) -> Void) {
            carSession.request(
                montpellier3mURL + carEndpoint,
                method: .get,
                parameters: carMetaParams).response { response in
                    guard response.error == nil,
                          response.response?.statusCode == 200,
                          let data = response.data else {
                              completion(.failure(.server))
                              return
                          }
                    guard let carMetaData = try? JSONDecoder().decode(CarMetaData.self, from: data) else {
                        completion(.failure(.decoding))
                        return
                    }
                    completion(.success(carMetaData))
                }
        }

    func getCarStations(from metadata: CarMetaData, completion: @escaping (Result<[CarStation], ApiError>) -> Void) {

        var allStations = [CarStation]()
        let ressources = metadata.result.resources
        guard !ressources.isEmpty else {
            completion(.failure(.other(error: "No ressources in Metadata")))
            return
        }
        for resource in ressources {
            let url = resource.url
            let name = resource.name
            guard !name.contains("_") else { continue }
            let parking = CarStation(name: name, url: url)
            allStations.append(parking)
        }
        guard !allStations.isEmpty else {
            completion(.failure(.other(error: "No station decoded")))
            return
        }
        completion(.success(allStations))
    }

    func getCarValues(for station: CarStation, completion: @escaping (Result<CarValues, ApiError>) -> Void) {
        NetworkService.shared.getRemoteXmlData(fromUrl: station.url) { result in
            switch result {
            case .failure(let error):
                print(error)
                completion(.failure(error))
            case .success(let accessor):
                guard let values = CarStation.parseCarXML(for: station.name, with: accessor) else {
                    completion(.failure(.other(error: "Parsing Car XML")))
                    return
                }
                station.values = values
                completion(.success(values))
            }
        }
    }

    // MARK: - XML File

    func getRemoteXmlData(fromUrl url: String, completion: @escaping (Result<XML.Accessor, ApiError>) -> Void) {
        guard url.hasPrefix("https://"), url.hasSuffix(".xml") else {
            completion(.failure(.url))
            return
        }

        xmlSession.request(url, method: .get).response { response in
            guard response.error == nil,
                  response.response?.statusCode == 200,
                  let data = response.data else {
                      completion(.failure(.server))
                      return
                  }

            #if targetEnvironment(simulator)
            if self.printXmlToConsole {
                let xml = String(decoding: data, as: UTF8.self)
                print(String.init(repeating: "=", count: 20))
                print("🟧 REQUEST", url, " : \n", xml)
            }
            #endif

            let accessor = XML.parse(data) // -> XML.Accessor
            completion(.success(accessor))
            return
        }
    }
}

