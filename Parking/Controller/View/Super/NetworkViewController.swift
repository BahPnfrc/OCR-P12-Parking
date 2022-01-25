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
    static let updateSpan: TimeInterval = 300 // 5 min
    static var lastBikeUpdate = Date() - updateSpan
    static var lastCarUpdate = Date() - updateSpan

    /// - returns : A tuple telling wheither or not bike and car can autoupdate based on last time update.
    func canAutoUpdate() -> (bike: Bool, car: Bool) {
        let now = Date()
        let bikeInterval = NetworkViewController.lastBikeUpdate.distance(to: now)
        let carInterval = NetworkViewController.lastCarUpdate.distance(to: now)
        return (bikeInterval > NetworkViewController.updateSpan, carInterval > NetworkViewController.updateSpan)
    }

    // MARK: - Loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Bike functions

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

    func reloadBikeStations() {
        guard let metadata = BikeStation.metadata else { return }
        NotificationCenter.default.post(Notification.bikeIsRequesting)
        NetworkService.shared.getBikeStations(from: metadata) { [weak self] result in
            guard self != nil else { return }
            NotificationCenter.default.post(Notification.bikeIsDone)
            switch result {
            case .failure(let error):
                print(error)
            case .success(let allStations):
                BikeStation.allStations = allStations
                NotificationCenter.default.post(Notification.bikeHasNewData)
            }
        }
    }

    // MARK: - Car functions

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

    func reloadCarStations() {
        guard let metadata = CarStation.metadata else { return }
        CarStation.allStations = CarStation.getCarStations(from: metadata)
        NetworkService.shared.reloadCarValues(for: CarStation.allStations as! [CarStation])
    }
}
