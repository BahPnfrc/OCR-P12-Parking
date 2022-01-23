//
//  GlobalViewController.swift
//  Parking
//
//  Created by Genapi on 20/01/2022.
//

import UIKit

class NetworkViewController: UIViewController {

    private var requestCount: Int = 0
    var isRequesting: Bool {
        get {
            return requestCount > 0
        }
        set(newValue) {
            requestCount += (newValue ? 1 : -1)
            if requestCount < 0 { requestCount = 0 }

            requestCount > 0 ? self.navigationController?.startSpinning() : self.navigationController?.stopSpinning()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadBikeMetaData()
        reloadCarMetaData()
    }

    // MARK: - Network Metadata

    func reloadBikeMetaData() {
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

    func reloadCarMetaData() {
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


    // MARK: - Network Stations

    func reloadCarStations() {
        guard let metadata = CarStation.metadata else { return }
        isRequesting = true
        NetworkService.shared.getCarStations(from: metadata) { [weak self] result in
            guard let self = self else { return }
            self.isRequesting = false
            switch result {
            case .failure(let error):
                print(error)
            case .success(let allStations):
                CarStation.allStations = allStations
                CarStation.allStations.forEach({
                    ($0 as! CarStation).reloadValues()
                })
            }
        }
    }

    func reloadBikeStations() {
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
            }
        }
    }

}
