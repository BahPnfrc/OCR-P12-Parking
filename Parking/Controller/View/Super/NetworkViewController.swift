//
//  GlobalViewController.swift
//  Parking
//
//  Created by Genapi on 20/01/2022.
//

import UIKit

class NetworkViewController: UIViewController {

    var updateSpan: TimeInterval = 60*5 // 5 min
    var lastBikeUpdate = Date()
    var lastCarUpdate = Date()

    func canAutoUpdate() -> (bike: Bool, car: Bool) {
        let now = Date()
        let bikeInterval = lastBikeUpdate.distance(to: now)
        let carInterval = lastCarUpdate.distance(to: now)
        return (bikeInterval > updateSpan, carInterval > updateSpan)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Network Metadata

    func reloadBikeMetaData(forced: Bool) {
        guard forced == true || canAutoUpdate().bike else { return }

        NotificationCenter.default.post(Notification.bikeIsRequesting)
        NetworkService.shared.getBikeMetaData { [weak self] result in
            NotificationCenter.default.post(Notification.bikeIsDone)
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error)
            case .success(let metaData):
                BikeStation.metadata = metaData
                self.reloadBikeStations()
            }
        }
    }

    func reloadCarMetaData(forced: Bool) {
        guard forced == true || canAutoUpdate().car else { return }

        NotificationCenter.default.post(Notification.carIsRequesting)
        NetworkService.shared.getCarMetaData { [weak self] result in
            guard let self = self else { return }
            NotificationCenter.default.post(Notification.carIsDone)
            switch result {
            case .failure(let error):
                print(error)
            case .success(let metaData):
                CarStation.metadata = metaData
                self.reloadCarStations()
            }
        }
    }


    // MARK: - Network Stations

    func reloadBikeStations() {
        guard let metadata = BikeStation.metadata else { return }
        NotificationCenter.default.post(Notification.bikeIsRequesting)
        NetworkService.shared.getBikeStations(from: metadata) { [weak self] result in
            guard let self = self else { return }
            NotificationCenter.default.post(Notification.bikeIsDone)
            switch result {
            case .failure(let error):
                print(error)
            case .success(let allStations):
                BikeStation.allStations = allStations
                self.lastBikeUpdate = Date()
                NotificationCenter.default.post(Notification.bikeHasNewData)
            }
        }
    }

    func reloadCarStations() {
        guard let metadata = CarStation.metadata else { return }
        NotificationCenter.default.post(Notification.carIsRequesting)
        NetworkService.shared.getCarStations(from: metadata) { [weak self] result in
            guard let self = self else { return }
            NotificationCenter.default.post(Notification.carIsDone)
            switch result {
            case .failure(let error):
                print(error)
            case .success(let allStations):
                CarStation.allStations = allStations
                self.lastCarUpdate = Date()
                if CarStation.canReloadValues() {
                    CarStation.allStations.forEach({
                        ($0 as! CarStation).reloadValues(inLoopOf: allStations.count)
                    })
                }
                NotificationCenter.default.post(Notification.carHasNewData)
            }
        }
    }

}
