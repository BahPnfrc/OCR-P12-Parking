//
//  CarStationViewController.swift
//  Parking
//
//  Created by Genapi on 21/01/2022.
//

import UIKit

class CarStationViewController: StationViewController {

    private func reloadCarMetaData() {
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
        isRequesting = true
        NetworkService.shared.getCarStations(from: metadata) { [weak self] result in
            guard let self = self else { return }
            self.isRequesting = false
            switch result {
            case .failure(let error):
                print(error)
            case .success(let allStations):
                CarStation.allStations = allStations
            }
            self.reloadDataSource()
        }
    }

    override func viewDidLoad() {
        self.dataType = .Car
        super.viewDidLoad()
        reloadCarMetaData()
    }

    override func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        guard !isSearching else { return }
        isLocalRequesting = true
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        UIView.animate(withDuration: 0.5, animations: {
            tappedImage.transform = CGAffineTransform.init(rotationAngle: .pi)
            self.reloadCarMetaData()
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, animations: {
                tappedImage.transform = CGAffineTransform.identity
                self.isLocalRequesting = false
            })
        })
    }
}
