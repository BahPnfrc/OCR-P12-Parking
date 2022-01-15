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

    private struct MetaParams: Encodable {
        let id: String
        let utm_source: String
        let utm_campaign: String
        let utm_term: String
    }

    // MARK: - Car
    
    /// https://data.montpellier3m.fr/dataset/disponibilite-des-places-dans-les-parkings-de-montpellier-mediterranee-metropole
    private let carMetaURL = "https://data.montpellier3m.fr/api/3/action/package_show?"
    private let carMetaParams = MetaParams(
        id: "90e17b94-989f-4d66-83f4-766d4587bec2",
        utm_source: "Site%20internet",
        utm_campaign: "Clic%20sur%20%3A%20https%3A//data.montpellier3m.fr/api/3/action/package_show/90e17b94-989f-4d66-83f4-766d4587bec2",
        utm_term: "https%3A//data.montpellier3m.fr/api/3/action/package_show/90e17b94-989f-4d66-83f4-766d4587bec2")

    func getCarMetaData(
        completion: @escaping (Result<CarMetaData, ApiError>) -> Void) {
            AF.request(carMetaURL,
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
    private let bikeMetaURL = "https://data.montpellier3m.fr/api/3/action/resource_show?"
    private let bikeMetaParams = MetaParams(
        id: "adb98f8d-c4d2-4012-8abe-cf02903e2ea0",
        utm_source: "Site%20internet",
        utm_campaign: "Clic%20sur%20%3A%20https%3A//data.montpellier3m.fr/api/3/action/resource_show/adb98f8d-c4d2-4012-8abe-cf02903e2ea0",
        utm_term: "https%3A//data.montpellier3m.fr/api/3/action/resource_show/adb98f8d-c4d2-4012-8abe-cf02903e2ea0")

    func getBikeMetaData(completion: @escaping (Result<BikeMetadata, ApiError>) -> Void) {
        AF.request(bikeMetaURL,
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
            print("🟧", url, " : \n", xml)
            #endif

            let accessor = XML.parse(data) // -> XML.Accessor
            completion(.success(accessor))
            return
        }
    }
}

