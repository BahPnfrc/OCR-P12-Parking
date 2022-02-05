import UIKit

// MARK: - Delegate

protocol NetworkCallerDelegate {
    /// Help update UI on certain events
    func didUpdateRequestState(_ isRequesting: Bool) -> Void
    func didUpdateBikeData() -> Void
    func didUpdateCarData() -> Void
}

// MARK: - NetworkHandler

class NetworkCaller {

    static let shared = NetworkCaller()
    private init() {}

    // MARK: - Properties

    // Assign to active viewController in viewWillAppear()
    var delegate: NetworkCallerDelegate?

    private var requestCount: Int = 0
    private var isRequesting: Bool {
        get {
            return requestCount > 0
        }
        set(newValue) {
            requestCount += (newValue ? 1 : -1)
            if requestCount < 0 { requestCount = 0 }
            delegate?.didUpdateRequestState(isRequesting)
        }
    }

    // MARK: - AutoUpdate

    /// Span before an auto update can occur while changing tab.
    private let updateSpan: TimeInterval = 300 // 5 min
    private lazy var lastBikeUpdate = Date() - updateSpan
    private lazy var lastCarUpdate = Date() - updateSpan

    /// - returns : A tuple telling wheither or not bike and car can autoupdate based on last time update.
    private func canAutoUpdate() -> (bike: Bool, car: Bool) {
        let now = Date()
        let bikeInterval = lastBikeUpdate.distance(to: now)
        let carInterval = lastCarUpdate.distance(to: now)
        return (bikeInterval > updateSpan, carInterval > updateSpan)
    }

    // MARK: - Bike calls

    /// - parameter forced: force reloading even though autoupdate span is not reached.
    func reloadBikeMetaData(forced: Bool) {
        guard forced == true || canAutoUpdate().bike else { return }

        isRequesting = true
        NetworkService.shared.getBikeMetaData { [weak self] result in
            guard let self = self else { return }
            self.isRequesting = false
            switch result {
            case .failure(let error):
                print(error)
            case .success(let metaData):
                BikeStation.metadata = metaData
                self.reloadBikeStations()
            }
        }
    }

    private func reloadBikeStations() {
        guard let metadata = BikeStation.metadata else { return }
        isRequesting = true
        NetworkService.shared.getBikeStations(from: metadata) { [weak self] result in
            guard let self = self else { return }
            self.isRequesting = false
            switch result {
            case .failure(let error):
                print(error)
            case .success(let allStations):
                BikeStation.allStations = allStations
                self.lastBikeUpdate = Date()
                self.delegate?.didUpdateBikeData()
            }
        }
    }

    // MARK: - Car calls

    /// - parameter forced: force reloading even though autoupdate span is not reached.
    func reloadCarMetaData(forced: Bool) {
        guard forced == true || canAutoUpdate().car else { return }

        isRequesting = true
        NetworkService.shared.getCarMetaData { [weak self] result in
            guard let self = self else { return }
            self.isRequesting = false
            switch result {
            case .failure(let error):
                print(error)
            case .success(let metaData):
                CarStation.metadata = metaData
                self.reloadCarStations()
            }
        }
    }

    private func reloadCarStations() {
        guard let metadata = CarStation.metadata else { return }
        CarStation.allStations = CarStation.getCarStations(from: metadata)
        reloadCarValues(for: CarStation.allStations as! [CarStation])
    }

    /// Each CarStation has  its own XML files to call for new values.
    /// Var and func here help  keep track of returned values before letting UI update.
    private var returnedXML = 0
    private func canReloadCarValues() -> Bool { returnedXML == 0 }
    private func resetCounter() -> Void { returnedXML = 0 }

    private func reloadCarValues(for cars: [CarStation]) {
        if canReloadCarValues() { // Wait for previous run to end
            isRequesting = true
            cars.forEach({
                NetworkService.shared.reloadCarValues(for: $0) { _ in
                    self.returnedXML += 1 // Count returns
                    if self.returnedXML == cars.count { // When all returned
                        self.isRequesting = false
                        self.lastCarUpdate = Date()
                        self.delegate?.didUpdateCarData()
                        self.resetCounter() // Allow next run
                    }
                }
            })
        }
    }
}
