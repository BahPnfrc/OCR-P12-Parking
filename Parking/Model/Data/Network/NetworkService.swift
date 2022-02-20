import Foundation
import UIKit
import SwiftyXMLParser
import Alamofire

// MARK: - NetworkService

class NetworkService {

    static let shared = NetworkService()
    private init() {}

    private let printXmlToConsole = false // Debugging purpose
    typealias handler<T> = (Result<T, ApiError>) -> Void

    /// Private default sessions for internal use.
    private var carSession = Alamofire.Session(configuration: URLSessionConfiguration.default)
    private var bikeSession = Alamofire.Session(configuration: URLSessionConfiguration.default)
    private var xmlSession = Alamofire.Session(configuration: URLSessionConfiguration.default)

    /// Public sessions init for testing use.
    init(bikeSession: Session) { self.bikeSession = bikeSession }
    init(carSession: Session) { self.carSession = carSession }
    init(xmlSession: Session) { self.xmlSession = xmlSession }

    private let montpellier3mURL = "https://data.montpellier3m.fr/api/3/"
    private let bikeEndpoint = "action/resource_show?"
    private let carEndpoint = "action/package_show?"
    private let bikeMetaDataID = "adb98f8d-c4d2-4012-8abe-cf02903e2ea0"
    private let carMetaDataID = "90e17b94-989f-4d66-83f4-766d4587bec2"

    private struct MetaParams: Encodable {
        let id: String
    }

    // MARK: - Bike MetaData

    private lazy var bikeMetaParams = MetaParams(
        id: bikeMetaDataID
    )

    /// Func : Retrieve a JSON file linking to a *single XML file* for all stations.
    func getBikeMetaData(completion: @escaping handler<BikeMetaData>) {
        bikeSession.request(montpellier3mURL + bikeEndpoint,
                            method: .get,
                            parameters: bikeMetaParams).response { response in
            guard response.error == nil,
                  response.response?.statusCode == 200,
                  let data = response.data else {
                      completion(.failure(.server))
                      return
                  }
            guard let meta = try? JSONDecoder().decode(BikeMetaData.self, from: data) else {
                completion(.failure(.decoding))
                return
            }
            completion(.success(meta))
        }
    }

    // MARK: - Bike Station

    /// Func : Parse MetaData JSON for a single XML file retrieving all stations details.
    ///  - parameter metadata: a JSON object retrieved from the bike MetaData func.
    ///  - returns : an array of bike stations objects with all details inside.
    func getBikeStations(from metadata: BikeMetaData, completion: @escaping handler<[BikeStation]>) {
        let url = metadata.result.result.url
        getRemoteXmlData(fromUrl: url) { result in
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

    // MARK: - Car MetaData

    private lazy var carMetaParams = MetaParams(
        id: carMetaDataID
    )

    /// Func : Retrieve a JSON file linking to an individual XML file *for each station*.
    func getCarMetaData(completion: @escaping handler<CarMetaData>) {
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
                guard let meta = try? JSONDecoder().decode(CarMetaData.self, from: data) else {
                    completion(.failure(.decoding))
                    return
                }
                completion(.success(meta))
            }
    }

    // MARK: - Car Stations

    /// - returns: return a CarValues object *after assigning* it to the car.
    func reloadCarValues(for car: CarStation, completion: @escaping handler<CarValues>) {
        getRemoteXmlData(fromUrl: car.url) { result in
            switch result {
            case .failure(let error):
                car.values = nil
                completion(.failure(error))
            case .success(let accessor):
                guard let values = CarStation.parseCarXML(for: car.name, with: accessor) else {
                    completion(.failure(.other(error: "Parsing Car XML")))
                    return
                }
                car.values = values
                completion(.success(values))
            }
        }
    }

    // MARK: - XML File

    /// - returns : an XML.Accessor object to help read the file via the SwiftyXMLParser Pod.
    private func getRemoteXmlData(fromUrl url: String, completion: @escaping handler<XML.Accessor>) {
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

