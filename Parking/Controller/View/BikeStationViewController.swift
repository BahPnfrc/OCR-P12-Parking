//
//  BikeStationViewController.swift
//  Parking
//
//  Created by Genapi on 21/01/2022.
//

import UIKit

class BikeStationViewController: StationViewController {

    private func reloadBikeMetaData() {
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
            }
            self.reloadDataSource()
        }
    }

    override func viewDidLoad() {
        self.dataType = .Bike
        super.viewDidLoad()
        reloadBikeMetaData()
    }

    override func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        guard !isSearching else { return }
        isLocalRequesting = true
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        UIView.animate(withDuration: 0.5, animations: {
            tappedImage.transform = CGAffineTransform.init(rotationAngle: .pi)
            self.reloadBikeMetaData()
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, animations: {
                tappedImage.transform = CGAffineTransform.identity
                self.isLocalRequesting = false
            })
        })
    }
}
