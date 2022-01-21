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

    var dataType: CellType?
    var dataSource: [StationCellItem] {
        switch dataType {
        case .Bike:
            return BikeStation.allStations
        case .Car:
            return CarStation.allStations
        default:
            return [StationCellItem]()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()

        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self

        let nib = UINib(nibName: "StationCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "stationCell")
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

        let data = dataSource[indexPath.row]

        cell.nameLabel.text = data.cellName()
        cell.freeLabel.text = data.cellPlacesLabel()
        cell.updateLabel.text = data.cellUpdatedLabel()

        cell.typeImageView.image = data.cellType == .Bike ? Shared.cellBikeIcon : Shared.cellCarIcon

        return cell
    }
}
