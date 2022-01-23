//
//  StationViewController.swift
//  Parking
//
//  Created by Genapi on 20/01/2022.
//

import UIKit

class StationViewController: GlobalViewController {

    // MARK: - Outlets

    @IBOutlet weak var backImageView: UIImageView!

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerTopImageView: UIImageView!

    @IBOutlet weak var requestingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var headerTopLabel: UILabel!

    @IBOutlet weak var headerSubReloader: UIImageView!
    @IBOutlet weak var headerSubImageView: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties

    var isLocalRequesting = false {
        didSet {
            if isLocalRequesting {
                requestingIndicator.startAnimating()
            } else {
                requestingIndicator.stopAnimating()
            }
        }
    }

    var isSearching = false
    var searchingKey: String?

    var dataType: CellType = .Bike
    var dataSource: [StationCellItem]? {
        didSet {
            defineNewHeaderTitle()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()

        paintHeader()
        paintSearchBar()
        paintTableView()

        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self

        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        headerSubReloader.isUserInteractionEnabled = true
        headerSubReloader.addGestureRecognizer(gesture)
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        fatalError("Must override")
    }

    override func viewWillAppear(_ animated: Bool) {
        defineNewHeaderTitle()
    }
}

// MARK: - Paint functions

extension StationViewController {
    func paintHeader() {
        requestingIndicator.hidesWhenStopped = true
        headerView.backgroundColor = Paint.defViewColor
        headerView.layer.cornerRadius = Paint.defRadius
        headerTopImageView.image = Shared.paintedSystemImage(named: "parkingsign.circle.fill")
        headerTopLabel.text = "Décompte parkings"
        headerSubImageView.image = Shared.paintedSystemImage(named: "magnifyingglass.circle.fill")
        headerSubReloader.image = Shared.paintedSystemImage(named: "arrow.triangle.2.circlepath.circle.fill")
    }

    func paintSearchBar() {
        searchBar.placeholder = "Filtrer"
        searchBar.setImage(UIImage(), for: .search, state: .normal)
        searchBar.backgroundImage = UIImage()
    }

    func paintTableView() {
        let nib = UINib(nibName: "StationCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "stationCell")
        tableView.backgroundColor = .white.withAlphaComponent(0)
    }

    func defineNewHeaderTitle() {
        let count = countDataSource()
        var newHeader:(image: UIImage?, label: String)
        if isSearching {
            switch count.items {
            case 0:
                newHeader = (Shared.paintedSystemImage(named: "magnifyingglass.circle.fill", .black, .systemRed, .systemRed), "Aucun résultat")
            case 1:
                newHeader = (Shared.paintedSystemImage(named: "magnifyingglass.circle.fill", .black, .systemGreen, .systemGreen), "1 seul résultat")
            default:
                newHeader = (Shared.paintedSystemImage(named: "magnifyingglass.circle.fill", .black, .systemGreen, .systemGreen), "\(count.items) résultats")
            }
        } else {
            switch count.items {
            case 0:
                newHeader = (Shared.paintedSystemImage(named: "parkingsign.circle.fill"), "Aucune place libre")
            case 1:
                newHeader = (Shared.paintedSystemImage(named: "parkingsign.circle.fill"), "1 seule place libre")
            default:
                newHeader = (Shared.paintedSystemImage(named: "parkingsign.circle.fill"), "\(count.freePlaces) places libres")
            }
        }
        (headerTopImageView.image, headerTopLabel.text) = newHeader
    }
}

// MARK: - Datasource functions

extension StationViewController {
    func reloadDataSource() {
        if isSearching {
            dataSource = [StationCellItem]()
            tableView.reloadData()
            guard let searchingKey = searchingKey?.lowercased() else { return }
            switch dataType {
            case .Bike:
                dataSource = BikeStation.allStations
                    .filter({$0.cellName().lowercased()
                    .contains(searchingKey)
                }).sorted(by: { $0.cellName() < $1.cellName()})
            case .Car:
                dataSource = CarStation.allStations
                    .filter({ $0.cellName().lowercased()
                    .contains(searchingKey)
                }).sorted(by: { $0.cellName() < $1.cellName()})
            }
        } else {
            switch dataType {
            case .Bike:
                dataSource = BikeStation.allStations
            case .Car:
                dataSource = CarStation.allStations
            }
        }
        tableView.reloadData()
    }

    func countDataSource() -> (items: Int, freePlaces: Int) {
        let items = dataSource?.count ?? 0
        let freePlaces: Int = { () -> Int in
            guard let dataSource = self.dataSource else {
                return 0
            }
            return dataSource
                .map({ $0.cellFreePlaces() })
                .reduce(0, { $0 + $1 })
        }()
        return (items, freePlaces)
    }
}

// MARK: UISearchBarDelegate

extension StationViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            isSearching = true
            searchingKey = searchText
        } else {
            isSearching = false
            searchingKey = nil
        }
        reloadDataSource()
    }
}

// MARK: - UITableViewDelegate

extension StationViewController: UITableViewDelegate {}

// MARK: - UITableViewDataSource

extension StationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stationCell", for: indexPath) as! StationTableViewCell

        let station = dataSource![indexPath.row]
        cell.station = station
        cell.isFavorite = station.cellIsFavorite()
        cell.nameLabel.text = station.cellName()
        cell.isRequesting = true

        switch dataType {
        case .Bike:
            cell.freeLabel.text = station.cellDisplayableFreePlace()
            cell.updateLabel.text = station.cellDisplayableUpdatedTime()
            cell.typeImageView.image = Shared.cellBikeIcon
        case .Car:
            if !station.cellIsLoaded {
                NetworkService.shared.getCarValues(for: station as! CarStation) { result in
                    if case .success = result {
                        cell.freeLabel.text = station.cellDisplayableFreePlace()
                        cell.updateLabel.text = station.cellDisplayableUpdatedTime()
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
        let clearView = UIView()
        clearView.backgroundColor = .clear
        cell.selectedBackgroundView = clearView
        cell.contentView.layer.masksToBounds = true
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
    }
}
