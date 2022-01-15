import Foundation
import UIKit
import SwiftyXMLParser
import Alamofire

class NetworkService {

    static let shared = NetworkService()
    private init() {}

    private var task: URLSessionDataTask?
    private var carDataSession = URLSession(configuration: .default)
    private var bikeDataSession = URLSession(configuration: .default)

    init(carDataSession: URLSession) {
        self.carDataSession = carDataSession
    }
    init(bikeDataSession: URLSession) {
        self.bikeDataSession = bikeDataSession
    }

    private let montpellier3mURL = "https://data.montpellier3m.fr/api/3/"

    private let carEndpoint = "action/package_show?"
    private let bikeEndpoint = "action/resource_show?"

    private static let carMetaDataID = "90e17b94-989f-4d66-83f4-766d4587bec2"
    private static let bikeMetaDataID = "adb98f8d-c4d2-4012-8abe-cf02903e2ea0"

    private struct MetaParams: Encodable {
        let id: String
    }

    // MARK: - Car
    /// https://data.montpellier3m.fr/dataset/disponibilite-des-places-dans-les-parkings-de-montpellier-mediterranee-metropole

    private let carMetaParams = MetaParams(
        id: NetworkService.carMetaDataID
    )

    func getCarMetaData(
        completion: @escaping (Result<CarMetaData, ApiError>) -> Void) {
            AF.request(montpellier3mURL + carEndpoint,
                       method: .get,
                       parameters: carMetaParams).response { response in
                guard let data = response.data,
                        response.error == nil,
                        response.response?.statusCode == 200 else {
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

    // MARK: - Bike
    /// https://data.montpellier3m.fr/dataset/disponibilite-des-places-velomagg-en-temps-reel/resource/adb98f8d-c4d2-4012-8abe

    private let bikeMetaParams = MetaParams(
        id: NetworkService.bikeMetaDataID
    )

    func getBikeMetaData(completion: @escaping (Result<BikeMetadata, ApiError>) -> Void) {
        AF.request(montpellier3mURL + bikeEndpoint,
                   method: .get,
                   parameters: bikeMetaParams).response { response in
            guard let data = response.data,
                  response.error == nil,
                  response.response?.statusCode == 200 else {
                      completion(.failure(.server))
                      return
                  }
            guard let bikeMetadata = try? JSONDecoder().decode(BikeMetadata.self, from: data) else {
                completion(.failure(.decoding))
                return
            }
            completion(.success(bikeMetadata))
        }
    }

    // MARK: - XML File

    func getRemoteXmlData(fromUrl url: String, completion: @escaping (Result<XML.Accessor, ApiError>) -> Void) {
        guard url.hasPrefix("https://"), url.hasSuffix(".xml") else {
            completion(.failure(.url))
            return
        }

        AF.request(url, method: .get).response { response in
            guard let data = response.data,
                  response.error == nil,
                  response.response?.statusCode == 200 else {
                      completion(.failure(.server))
                      return
                  }

            #if targetEnvironment(simulator)
            let xml = String(decoding: data, as: UTF8.self)
            print(String.init(repeating: "=", count: 20))
            print("🟧", url, " : \n", xml)
            #endif

            let accessor = XML.parse(data) // -> XML.Accessor
            completion(.success(accessor))
            return
        }
    }
}

