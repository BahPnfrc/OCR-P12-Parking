//
//  BikeStationViewController.swift
//  Parking
//
//  Created by Genapi on 21/01/2022.
//

import UIKit

class BikeStationViewController: StationViewController {

    override func viewDidLoad() {
        reloadBikeMetaData(forced: true)
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadBikeMetaData(forced: false)
        defineNewData()
    }

    override func bikeHasData() {
        defineNewData()
    }

    override func carHasData() {
        return
    }

    override func defineNewData() {
        if isSearching {
            clearOldData()
            guard let searchingKey = searchingKey?.lowercased() else { return }
            super.assignNewData(
                BikeStation.allStations
                    .filter({$0.cellName().lowercased()
                    .contains(searchingKey)
                    }).sorted(by: { $0.cellName() < $1.cellName()}))
        } else {
            super.assignNewData(BikeStation.allStations)
        }
        super.defineNewHeaderTitle()
    }

    override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        super.searchBar(searchBar, textDidChange: searchText)
        self.defineNewData()
    }

    override func forceReload(tapGestureRecognizer: UITapGestureRecognizer) {
        guard !isSearching else { return }
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        UIView.animate(withDuration: 0.5, animations: {
            tappedImage.transform = CGAffineTransform.init(rotationAngle: .pi)
            super.clearOldData()
            super.reloadBikeMetaData(forced: true)
            self.defineNewData()
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, animations: {
                tappedImage.transform = CGAffineTransform.identity
            })
        })
    }
}
