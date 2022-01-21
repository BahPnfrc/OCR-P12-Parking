//
//  CarStationViewController.swift
//  Parking
//
//  Created by Genapi on 21/01/2022.
//

import UIKit

class CarStationViewController: StationViewController {

    private func reloadMetaData() {
        isRequesting = true
        NetworkService.shared.getCarMetaData { [weak self] result in
            guard let self = self else { return }
            self.isRequesting = false
            switch result {
            case .failure(let error):
                print(error)
            case .success(let metaData):
                CarStation.metadata = metaData
                self.reloadDataSource()
            }
        }
    }

    private func reloadDataSource() {
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
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        self.dataType = .Car
        super.viewDidLoad()
        reloadMetaData()
    }    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}