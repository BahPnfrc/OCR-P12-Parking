//
//  FavoriteStationViewController.swift
//  Parking
//
//  Created by Genapi on 23/01/2022.
//

import UIKit

class FavoriteStationViewController: StationViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        reloadBikeStations()
        reloadCarStations()
        super.viewWillAppear(animated)
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
        tableView.reloadData()
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
            super.reloadBikeMetaData()
            super.reloadCarMetaData()
            self.defineNewData()
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, animations: {
                tappedImage.transform = CGAffineTransform.identity
            })
        })
    }
}
