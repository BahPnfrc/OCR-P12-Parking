//
//  GlobalViewController.swift
//  Parking
//
//  Created by Genapi on 20/01/2022.
//

import UIKit

// MARK: - NetworkViewController

class NetworkViewController: UIViewController {

    /// This class handle network call of its subclasses.
    /// This class cannot access subclasses outlets directly.
    /// Instead, notifications are used to tell subclasses when important events occur.
    /// This truly matters since operations on car are syncronous.
    /// In this case notifications help reload subclasses only when syncronous calls are done.

    // MARK: - Properties

    /// Span before an auto update can occur on changing Tab.
    var updateSpan: TimeInterval = 300 // 5 min
    var lastBikeUpdate = Date()
    var lastCarUpdate = Date()

    /// - returns : A tuple telling wheither or not bike and car can autoupdate based on last time update.
    func canAutoUpdate() -> (bike: Bool, car: Bool) {
        let now = Date()
        let bikeInterval = lastBikeUpdate.distance(to: now)
        let carInterval = lastCarUpdate.distance(to: now)
        return (bikeInterval > updateSpan, carInterval > updateSpan)
    }

    // MARK: - Loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Network Metadata

    /// - parameter forced: force reloading even though autoupdate span is not reached.
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
                self.reloadBikeStations() // Call objects update on termination
            }
        }
    }

    /// - parameter forced: force reloading even though autoupdate span is not reached.
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
                self.reloadCarStations() // Call objects update on termination
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
                        // A notification is also sent when all objects are reloaded.
                    })
                }
                NotificationCenter.default.post(Notification.carHasNewData)
            }
        }
    }

}
