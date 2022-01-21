//
//  StationViewController.swift
//  Parking
//
//  Created by Genapi on 20/01/2022.
//

import UIKit

class StationViewController: GlobalViewController {

    @IBOutlet weak var backImageView: UIImageView!

    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerTopImageView: UIImageView!
    @IBOutlet weak var headerTopLabel: UILabel!
    @IBOutlet weak var headerSubImageView: UIImageView!
    @IBOutlet weak var headerSubLabel: UILabel!

    @IBOutlet weak var tableView: UITableView!

    var dataType: CellType = .Bike
    var dataSource: [StationCellItem] {
        switch dataType {
        case .Bike:
            return BikeStation.allStations
        case .Car:
            return CarStation.allStations
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()

        paintHeader()
        paintTableView()

        searchBar.placeholder = "Filtrer par nom"
        searchBar.backgroundImage = UIImage()

        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self


    }

    func paintHeader() {
        headerView.backgroundColor = Paint.defViewColor
        headerView.layer.cornerRadius = Paint.defRadius
        headerTopImageView.image = Shared.paintedSystemImage(named: "parkingsign.circle.fill")
        headerTopLabel.text = "Décompte parkings"
        headerSubImageView.image = Shared.paintedSystemImage(named: "checkmark.circle.fill")
        headerSubLabel.text = "Décompte places libres"
    }

    func paintTableView() {
        let nib = UINib(nibName: "StationCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "stationCell")
        tableView.backgroundColor = .white.withAlphaComponent(0)
    }
}

extension StationViewController: UISearchBarDelegate {

}

extension StationViewController: UITableViewDelegate {

}

extension StationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stationCell", for: indexPath) as! StationTableViewCell

        let item = dataSource[indexPath.row]
        cell.nameLabel.text = item.cellName()
        cell.isRequesting = true

        switch dataType {
        case .Bike:
            cell.freeLabel.text = item.cellPlacesLabel()
            cell.updateLabel.text = item.cellUpdatedLabel()
            cell.typeImageView.image = Shared.cellBikeIcon
        case .Car:
            if !item.isLoaded {
                NetworkService.shared.getCarValues(for: item as! CarStation) { result in
                    if case .success = result {
                        cell.freeLabel.text = item.cellPlacesLabel()
                        cell.updateLabel.text = item.cellUpdatedLabel()
                        cell.typeImageView.image = Shared.cellCarIcon
                    } else  {
                        cell.freeLabel.text = "--"
                        cell.updateLabel.text = "--"
                        cell.typeImageView.image = Shared.cellDefaultIcon
                    }
                }
            }
        }
        cell.isRequesting = false
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.contentView.layer.masksToBounds = true
    }
}
