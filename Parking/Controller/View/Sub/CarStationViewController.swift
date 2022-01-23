//
//  CarStationViewController.swift
//  Parking
//
//  Created by Genapi on 21/01/2022.
//

import UIKit

class CarStationViewController: StationViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.reloadCarStations()
        super.viewWillAppear(animated)
    }

    override func defineNewData() {
        if isSearching {
            super.clearOldData()
            guard let searchingKey = searchingKey?.lowercased() else { return }
            super.assignNewData(
                CarStation.allStations
                    .filter({ $0.cellName().lowercased()
                    .contains(searchingKey)
                    }).sorted(by: { $0.cellName() < $1.cellName()}))
        } else {
            super.assignNewData(CarStation.allStations)
        }
    }

    override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        super.searchBar(searchBar, textDidChange: searchText)
        self.defineNewData()
    }

    override func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        guard !isSearching else { return }
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        UIView.animate(withDuration: 0.5, animations: {
            tappedImage.transform = CGAffineTransform.init(rotationAngle: .pi)
            super.clearOldData()
            super.reloadCarMetaData()
            self.defineNewData()
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, animations: {
                tappedImage.transform = CGAffineTransform.identity
            })
        })
    }
}
