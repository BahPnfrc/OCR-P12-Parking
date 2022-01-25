//
//  FavoriteStationViewController.swift
//  Parking
//
//  Created by Genapi on 23/01/2022.
//

import UIKit

// MARK: - FavoriteStationViewController

class FavoriteStationViewController: StationViewController {

    // MARK: - Loading

    override func viewDidLoad() {
        super.viewDidLoad()
        super.reloadBikeMetaData(forced: false)
        super.reloadCarMetaData(forced: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.reloadBikeMetaData(forced: false)
        super.reloadCarMetaData(forced: false)
        defineNewData()
    }

    // MARK: - Data functions

    override func bikeHasNewData() {
        super.bikeHasNewData()
        defineNewData()
    }

    override func carHasNewData() {
        super.carHasNewData()
        defineNewData()
    }

    override func defineNewData() {
        let favorites = {() -> [StationCellItem] in
            do {
                return try CoreDataService.shared.getAllFavorites()
            } catch {
                let alert = UIAlertController(
                    title: "Parking",
                    message: "Les favoris n'ont pû être chargés !",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(
                    title: "OK",
                    style: .default,
                    handler: nil))
                self.present(alert, animated: true, completion: nil)
                return [StationCellItem]()
            }
        }()

        if isSearching {
            super.clearOldData()
            guard let searchingKey = searchingKey?.lowercased() else { return }

            super.assignNewData(
                favorites
                    .filter({ $0.cellName()
                    .lowercased()
                    .contains(searchingKey) })
                    .sorted(by: { $0.cellName() < $1.cellName()})
            )
        } else {
            super.assignNewData(favorites)
        }
        super.defineNewHeaderTitle()
    }

    // MARK: - Delegate functions

    override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        super.searchBar(searchBar, textDidChange: searchText)
        self.defineNewData()
    }

    // MARK: - Gesture functions

    override func forceReload(tapGestureRecognizer: UITapGestureRecognizer) {
        guard !isSearching else { return }
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        UIView.animate(withDuration: 0.5, animations: {
            tappedImage.transform = CGAffineTransform.init(rotationAngle: .pi)
            super.clearOldData()
            super.reloadBikeMetaData(forced: true)
            super.reloadCarMetaData(forced: true)
            self.defineNewData()
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, animations: {
                tappedImage.transform = CGAffineTransform.identity
            })
        })
    }
}
