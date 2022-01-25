import Foundation
import UIKit
import SwiftyXMLParser
import Alamofire

// MARK: - NetworkService

class NetworkService {

    static let shared = NetworkService()
    private init() {}

    let printXmlToConsole = false // Debugging purpose

    /// Private default sessions for internal use.
    private var carSession = Alamofire.Session(configuration: URLSessionConfiguration.default)
    private var bikeSession = Alamofire.Session(configuration: URLSessionConfiguration.default)
    private var xmlSession = Alamofire.Session(configuration: URLSessionConfiguration.default)

    /// Public sessions init for testing use.
    init(bikeSession: Session) { self.bikeSession = bikeSession }
    init(carSession: Session) { self.carSession = carSession }
    init(xmlSession: Session) { self.xmlSession = xmlSession }

    let montpellier3mURL = "https://data.montpellier3m.fr/api/3/"
    let bikeEndpoint = "action/resource_show?"
    let carEndpoint = "action/package_show?"
    static let bikeMetaDataID = "adb98f8d-c4d2-4012-8abe-cf02903e2ea0"
    static let carMetaDataID = "90e17b94-989f-4d66-83f4-766d4587bec2"

    private struct MetaParams: Encodable {
        let id: String
    }

    // MARK: - Bike Stations

    private let bikeMetaParams = MetaParams(
        id: NetworkService.bikeMetaDataID
    )

    /// Func : Retrieve a JSON file linking to a *single XML file* for all stations.
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
            guard let meta = try? JSONDecoder().decode(BikeMetaData.self, from: data) else {
                completion(.failure(.decoding))
                return
            }
            completion(.success(meta))
        }
    }

    // MARK: - Car Stations

    private let carMetaParams = MetaParams(
        id: NetworkService.carMetaDataID
    )

    /// Func : Retrieve a JSON file linking to an individual XML file *for each station*.
    func getCarMetaData(completion: @escaping (Result<CarMetaData, ApiError>) -> Void) {
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

    /// - returns: return a CarValues object *after assigning* it to the car.
    func reloadCarValues(for car: CarStation, completion: @escaping (Result<CarValues, ApiError>) -> Void) {
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

