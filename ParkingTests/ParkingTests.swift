//
//  ParkingTests.swift
//  ParkingTests
//
//  Created by Genapi on 07/01/2022.
//

import XCTest
import Alamofire
import Mocker

@testable import Parking

class ParkingTests: XCTestCase {

    private let timeout = 10.0
    var configuration = URLSessionConfiguration.af.default

    var mockedBikeSession: Session!
    var mockedCarSession: Session!
    var mockedXmlSession: Session!

    /* setUpWithError() or run this for each function :
    let configuration = URLSessionConfiguration.af.default
    configuration.protocolClasses = [MockingURLProtocol.self]
    let sessionManager = Alamofire.Session(configuration: configuration) */
    override func setUpWithError() throws {
        configuration.protocolClasses = [MockingURLProtocol.self]
        mockedBikeSession = Alamofire.Session(configuration: configuration)
        mockedCarSession = Alamofire.Session(configuration: configuration)
        mockedXmlSession = Alamofire.Session(configuration: configuration)
    }

    // MARK: - Network Test



    // MARK: Bike MetaData

    func testGivenInvalidCode_whenCallingBikeMetaData_thenCompletionFails() throws {
        let mock = Mock(
            url: MockedData.bikeMetaDataURL,
            ignoreQuery: true,
            dataType: .json,
            statusCode: 404,
            data: [.get: MockedData.bikeMetaDataOK])
        mock.register()

        let expectation = expectation(description: "Test passed")
        let session = NetworkService.init(bikeSession: mockedBikeSession)
        session.getBikeMetaData { result in
            switch result {
            case .failure:
                expectation.fulfill()
            case .success:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: timeout)
    }

    func testGivenInvalidData_whenCallingBikeMetaData_thenCompletionFails() throws {
        let mock = Mock(
            url: MockedData.bikeMetaDataURL,
            ignoreQuery: true,
            dataType: .json,
            statusCode: 200,
            data: [.get: MockedData.bikeMetaDataKO])
        mock.register()

        let expectation = expectation(description: "Test passed")
        let session = NetworkService.init(bikeSession: mockedBikeSession)
        session.getBikeMetaData { result in
            switch result {
            case .failure:
                expectation.fulfill()
            case .success:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: timeout)
    }

    // MARK: Bike Station

    func testGivenValidData_whenCallingBikeStation_thenCompletionSuccess() throws {
        let mock = Mock(
            url: MockedData.bikeMetaDataURL,
            ignoreQuery: true,
            dataType: .json,
            statusCode: 200,
            data: [.get: MockedData.bikeMetaDataOK])
        mock.register()

        let expectation = expectation(description: "Test passed")
        let session = NetworkService.init(bikeSession: mockedBikeSession)
        session.getBikeMetaData { result in
            switch result {
            case .failure:
                XCTFail()
            case .success:
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: timeout)
    }

    // MARK: Car MetaData

    func testGivenInvalidCode_whenCallingCarMetaData_thenCompletionFails() throws {
        let mock = Mock(
            url: MockedData.carMetaDataURL,
            ignoreQuery: true,
            dataType: .json,
            statusCode: 404,
            data: [.get: MockedData.carMetaDataOK])
        mock.register()

        let expectation = expectation(description: "Test passed")
        let session = NetworkService.init(carSession: mockedCarSession)
        session.getCarMetaData { result in
            switch result {
            case .failure:
                expectation.fulfill()
            case .success:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: timeout)
    }

    func testGivenInvalidData_whenCallingCarMetaData_thenCompletionFails() throws {
        let mock = Mock(
            url: MockedData.carMetaDataURL,
            ignoreQuery: true,
            dataType: .json,
            statusCode: 200,
            data: [.get: MockedData.carMetaDataKO])
        mock.register()

        let expectation = expectation(description: "Test passed")
        let session = NetworkService.init(carSession: mockedCarSession)
        session.getCarMetaData { result in
            switch result {
            case .failure:
                expectation.fulfill()
            case .success:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: timeout)
    }

    func testGivenValidData_whenCallingCarMetaData_thenCompletionSuccess() throws {
        let mock = Mock(
            url: MockedData.carMetaDataURL,
            ignoreQuery: true,
            dataType: .json,
            statusCode: 200,
            data: [.get: MockedData.carMetaDataOK])
        mock.register()

        let expectation = expectation(description: "Test passed")
        let session = NetworkService.init(carSession: mockedCarSession)
        session.getCarMetaData { result in
            switch result {
            case .failure:
                XCTFail()
            case .success(let metadata):
                let stations = CarStation.getCarStations(from: metadata)
                XCTAssertTrue(stations.count > 0)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: timeout)
    }

    // MARK: Car Station

    func testGivenInvalidURL_whenCallingCarStation_thenCompletionFails() throws {
        let mock = Mock(
            url: MockedData.carMetaDataURL,
            ignoreQuery: true,
            dataType: .json,
            statusCode: 200,
            data: [.get: MockedData.carDataOK])
        mock.register()

        let expectation = expectation(description: "Test passed")
        let carStation = CarStation(name: "someName", url: mock.url.description)
        let session = NetworkService.init(xmlSession: mockedXmlSession)
        session.reloadCarValues(for: carStation) { result in
            switch result {
            case .failure:
                expectation.fulfill()
            case .success:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: timeout)
    }

    func testGivenInvalidCode_whenCallingCarStation_thenCompletionFails() throws {
        let mock = Mock(
            url: MockedData.carXmlURL,
            ignoreQuery: true,
            dataType: .json,
            statusCode: 404,
            data: [.get: MockedData.carDataOK])
        mock.register()

        let expectation = expectation(description: "Test passed")
        let carStation = CarStation(name: "someName", url: mock.url.description)
        let session = NetworkService.init(xmlSession: mockedXmlSession)
        session.reloadCarValues(for: carStation) { result in
            switch result {
            case .failure:
                expectation.fulfill()
            case .success:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: timeout)
    }

    func testGivenInvalidData_whenCallingCarStation_thenCompletionFails() throws {
        let mock = Mock(
            url: MockedData.carXmlURL,
            ignoreQuery: true,
            dataType: .json,
            statusCode: 200,
            data: [.get: MockedData.carDataKO])
        mock.register()

        let expectation = expectation(description: "Test passed")
        let carStation = CarStation(name: "someName", url: mock.url.description)
        let session = NetworkService.init(xmlSession: mockedXmlSession)
        session.reloadCarValues(for: carStation) { result in
            switch result {
            case .failure:
                expectation.fulfill()
            case .success:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: timeout)
    }

    func testGivenValidData_whenCallingSingleCarValues_thenCompletionSuccess() throws {
        let mock = Mock(
            url: MockedData.carXmlURL,
            ignoreQuery: true,
            dataType: .json,
            statusCode: 200,
            data: [.get: MockedData.carDataOK])
        mock.register()

        let expectation = expectation(description: "Test passed")
        let carStation = CarStation(name: "someName", url: mock.url.description)
        let session = NetworkService.init(xmlSession: mockedXmlSession)
        session.reloadCarValues(for: carStation) { result in
            switch result {
            case .failure:
                XCTFail()
            case .success:
                XCTAssertNotNil(carStation.values)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: timeout)
    }

    func testGivenValidData_whenCallingLoopCarValues_thenCompletionSuccess() throws {
        let mock = Mock(
            url: MockedData.carXmlURL,
            ignoreQuery: true,
            dataType: .json,
            statusCode: 200,
            data: [.get: MockedData.carDataOK])
        mock.register()

        let expectation = expectation(
            forNotification: Notification.Name.carHasNewData,
            object: nil, handler: nil)

        guard let meta = try? JSONDecoder().decode(CarMetaData.self, from: MockedData.carMetaDataOK) else {
            XCTFail()
            return
        }

        let carStations = CarStation.getCarStations(from: meta)
        let session = NetworkService.init(xmlSession: mockedXmlSession)
        session.reloadCarValues(for: carStations)
        wait(for: [expectation], timeout: timeout)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
