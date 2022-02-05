import XCTest
import Alamofire
import Mocker

@testable import Parking

class NetworkServiceTests: XCTestCase {

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

    // MARK: - Bike MetaData

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

    func testGivenValidData_whenCallingBikeMetaData_thenCompletionSuccess() throws {
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

    // MARK: - Bike Station

    func testGivenInvalidData_whenCallingBikeStation_thenCompletionFails() throws {
        let mock = Mock(
            url: MockedData.bikeXmlURL,
            ignoreQuery: true,
            dataType: .html,
            statusCode: 404,
            data: [.get: MockedData.bikeXmlDataKO])
        mock.register()

        guard let meta = try? JSONDecoder().decode(BikeMetaData.self, from: MockedData.bikeMetaDataOK) else {
            XCTFail()
            return
        }

        let expectation = expectation(description: "Test passed")
        let session = NetworkService.init(xmlSession: mockedXmlSession)
        session.getBikeStations(from: meta) { result in
            switch result {
            case .failure:
                expectation.fulfill()
            case .success:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: timeout)
    }

    func testGivenValidData_whenCallingBikeStation_thenCompletionSuccess() throws {
        let mock = Mock(
            url: MockedData.bikeXmlURL,
            ignoreQuery: true,
            dataType: .html,
            statusCode: 200,
            data: [.get: MockedData.bikeXmlDataOK])
        mock.register()

        guard let meta = try? JSONDecoder().decode(BikeMetaData.self, from: MockedData.bikeMetaDataOK) else {
            XCTFail()
            return
        }

        let expectation = expectation(description: "Test passed")
        let session = NetworkService.init(xmlSession: mockedXmlSession)
        session.getBikeStations(from: meta) { result in
            switch result {
            case .failure:
                XCTFail()
            case .success(let bikeStations):
                XCTAssertTrue(bikeStations.count > 0)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: timeout)
    }

    // MARK: - Car MetaData

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

    // MARK: - Car Station

    func testGivenInvalidURL_whenCallingCarStation_thenCompletionFails() throws {
        let mock = Mock(
            url: MockedData.carMetaDataURL,
            ignoreQuery: true,
            dataType: .json,
            statusCode: 200,
            data: [.get: MockedData.carXmlDataOK])
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
            data: [.get: MockedData.carXmlDataOK])
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
            data: [.get: MockedData.carXmlDataKO])
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
            data: [.get: MockedData.carXmlDataOK])
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

}
