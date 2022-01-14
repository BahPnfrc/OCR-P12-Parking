import Foundation
import UIKit
import SwiftyXMLParser

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

    // MARK: - Car

    /* URL :
     https://data.montpellier3m.fr/dataset/disponibilite-des-places-dans-les-parkings-de-montpellier-mediterranee-metropole
     https://data.montpellier3m.fr/dataset/disponibilite-des-places-velomagg-en-temps-reel/resource/adb98f8d-c4d2-4012-8abe
     */

    private let carMetaURL = "https://data.montpellier3m.fr/api/3/action/package_show?id=90e17b94-989f-4d66-83f4-766d4587bec2&utm_source=Site%20internet&utm_campaign=Clic%20sur%20%3A%20https%3A//data.montpellier3m.fr/api/3/action/package_show/90e17b94-989f-4d66-83f4-766d4587bec2&utm_term=https%3A//data.montpellier3m.fr/api/3/action/package_show/90e17b94-989f-4d66-83f4-766d4587bec2"

    func getCarMetaData(
        completion: @escaping (Result<CarMetaData, ApiError>) -> Void) {

            let url = URL(string: carMetaURL)
            guard let url = url else {
                completion(.failure(.url))
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            task?.cancel()
            task = carDataSession.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    guard let data = data, error == nil,
                          let response = response as? HTTPURLResponse,
                          response.statusCode == 200 else {
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
            task?.resume()
        }

    // MARK: - Bike

    private let bikeMetaURL = "https://data.montpellier3m.fr/api/3/action/resource_show?id=adb98f8d-c4d2-4012-8abe-cf02903e2ea0&utm_source=Site%20internet&utm_campaign=Clic%20sur%20%3A%20https%3A//data.montpellier3m.fr/api/3/action/resource_show/adb98f8d-c4d2-4012-8abe-cf02903e2ea0&utm_term=https%3A//data.montpellier3m.fr/api/3/action/resource_show/adb98f8d-c4d2-4012-8abe-cf02903e2ea0"

    func getBikeMetaData(completion: @escaping (Result<BikeMetadata, ApiError>) -> Void) {

        let url = URL(string: bikeMetaURL)
        guard let url = url else {
            completion(.failure(.url))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        task?.cancel()
        task = bikeDataSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
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
        task?.resume()
    }

    // MARK: - XML File

    func getRemoteXmlData(fromUrl url: String, completionHandler: @escaping (Result<XML.Accessor, ApiError>) -> Void) {
        guard url.hasPrefix("https://"), url.hasSuffix(".xml") else {
            completionHandler(.failure(.url))
            return
        }
        let url = URL(string: url)!

        task?.cancel()
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completionHandler(.failure(.server))
                return
            }

            #if targetEnvironment(simulator)
            let xml = String(decoding: data, as: UTF8.self)
            print(url, " : \n", xml)
            #endif

            let accessor = XML.parse(data) // -> XML.Accessor
            completionHandler(.success(accessor))
            return
        }
        task.resume()
    }
}

