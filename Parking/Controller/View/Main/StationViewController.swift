import UIKit

// MARK: - StationViewController

class StationViewController: NetworkViewController {

    // MARK: - Outlets

    @IBOutlet weak var statusBarView: UIView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerTopImageView: UIImageView!
    @IBOutlet weak var requestingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var headerTopLabel: UILabel!
    @IBOutlet weak var headerSubReloader: UIImageView!
    @IBOutlet weak var headerSubImageView: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties

    private var requestCount: Int = 0
    var isRequesting: Bool {
        get {
            return requestCount > 0
        }
        set(newValue) {
            requestCount += (newValue ? 1 : -1)
            if requestCount < 0 { requestCount = 0 }
            if requestCount > 0 {
                requestingIndicator.startAnimating()
            } else {
                requestingIndicator.stopAnimating()
                defineNewHeaderTitle()
            }
        }
    }

    var isSearching = false
    var searchingKey: String?
    private var dataSource: [StationCellItem]?

    // MARK: - Loading

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()

        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self

        setObservers()
        paintHeader()
        paintSearchBar()
        paintTableView()

        let gesture = UITapGestureRecognizer(target: self, action: #selector(forceReload))
        headerSubReloader.isUserInteractionEnabled = true
        headerSubReloader.addGestureRecognizer(gesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    @objc func forceReload(tapGestureRecognizer: UITapGestureRecognizer)
    {
        fatalError("Must override") // Handle in subclasses
    }


    // MARK: - Notification functions

    func setObservers() {
        NotificationCenter.default.addObserver(self,
            selector: #selector(bikeIsRequesting),
            name: Notification.Name.bikeIsRequesting,
            object: nil)

        NotificationCenter.default.addObserver(self,
            selector: #selector(bikeIsDone),
            name: Notification.Name.bikeIsDone,
            object: nil)

        NotificationCenter.default.addObserver(self,
            selector: #selector(bikeHasNewData),
            name: Notification.Name.bikeHasNewData,
            object: nil)

        NotificationCenter.default.addObserver(self,
            selector: #selector(carIsRequesting),
            name: Notification.Name.carIsRequesting,
            object: nil)

        NotificationCenter.default.addObserver(self,
            selector: #selector(carIsDone),
            name: Notification.Name.carIsDone,
            object: nil)

        NotificationCenter.default.addObserver(self,
            selector: #selector(carHasNewData),
            name: Notification.Name.carHasNewData,
            object: nil)
    }

    @objc func bikeIsRequesting() {
        self.isRequesting = true
    }

    @objc func carIsRequesting() {
        self.isRequesting = true
    }

    @objc func bikeIsDone() {
        self.isRequesting = false
    }

    @objc func carIsDone() {
        self.isRequesting = false
    }

    @objc func bikeHasNewData() {
        NetworkViewController.lastBikeUpdate = Date()
    }

    @objc func carHasNewData() {
        NetworkViewController.lastCarUpdate = Date()
    }

    // MARK: - Paint functions

    func paintHeader() {
        statusBarView.backgroundColor = Paint.defViewColor
        requestingIndicator.hidesWhenStopped = true
        headerView.backgroundColor = Paint.defViewColor
        headerView.layer.cornerRadius = Paint.defRadius
        headerTopImageView.image = Shared.headerDefaultIcon
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

    /// Define a new header title according to operation and datasource.
    func defineNewHeaderTitle() {
        let count = countCurrentData()
        var newHeader:(image: UIImage?, label: String)
        if isSearching {
            switch count.stations {
            case 0:
                newHeader = (Shared.paintedSystemImage(named: "magnifyingglass.circle.fill", .black, .systemRed, .systemRed), "Aucun résultat")
            case 1:
                newHeader = (Shared.paintedSystemImage(named: "magnifyingglass.circle.fill", .black, .systemGreen, .systemGreen), "1 seul résultat")
            default:
                newHeader = (Shared.paintedSystemImage(named: "magnifyingglass.circle.fill", .black, .systemGreen, .systemGreen), "\(count.stations) résultats : \(count.freePlaces) places libres")
            }
        } else {
            switch count.stations {
            case 0:
                newHeader = (Shared.headerDefaultIcon, "Aucune station")
            case 1:
                newHeader = (Shared.headerDefaultIcon, "1 seule station")
            default:
                newHeader = (Shared.headerDefaultIcon, "\(count.stations) stations : \(count.freePlaces) places libres")
            }
        }
        (headerTopImageView.image, headerTopLabel.text) = newHeader
    }

    // MARK: - Data functions

    func assignNewData(_ data: [StationCellItem]) {
        dataSource = data
        tableView.reloadData()
    }

    func clearOldData() {
        dataSource = [StationCellItem]()
        tableView.reloadData()
    }

    func defineNewData() {
        fatalError("Must override") // Handle in subclasses
    }

    func countCurrentData() -> (stations: Int, freePlaces: Int) {
        let stations = dataSource?.count ?? 0
        let freePlaces: Int = { () -> Int in
            guard let dataSource = self.dataSource else {
                return 0
            }
            return dataSource
                .map({ $0.cellFreePlaces() })
                .reduce(0, +)
        }()
        return (stations, freePlaces)
    }

}

// MARK: UISearchBarDelegate

extension StationViewController: UISearchBarDelegate {
    /// See subclasses for right use.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            isSearching = true
            searchingKey = searchText
        } else {
            isSearching = false
            searchingKey = nil
        }
    }
}

// MARK: - UITableViewDelegate

extension StationViewController: UITableViewDelegate {}

// MARK: - UITableViewDataSource

extension StationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource?.count ?? 0
    }

    /// func : all cell data are accessed via its protocole.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stationCell", for: indexPath) as! StationTableViewCell

        let station = dataSource![indexPath.row]
        cell.station = station
        cell.isFavorite = station.cellIsFavorite()
        cell.nameLabel.text = station.cellName()

        switch station.cellType {
        case .Bike:

            cell.freeLabel.text = station.cellLabelForFreePlace()
            cell.updateLabel.text = station.cellLabelForUpdatedTime()
            cell.typeImageView.image = Shared.cellBikeIcon

        case .Car:

            if station.cellIsLoaded {
                cell.freeLabel.text = station.cellLabelForFreePlace()
                cell.updateLabel.text = station.cellLabelForUpdatedTime()
                cell.typeImageView.image = Shared.cellCarIcon
                return cell
            } else {
                cell.isRequesting = true
                NetworkService.shared.reloadCarValues(for: station as! CarStation) { result in
                    cell.isRequesting = false
                    switch result {
                    case .failure:
                        cell.freeLabel.text = "-"
                        cell.updateLabel.text = "-"
                        cell.typeImageView.image = Shared.cellDefaultIcon
                    case .success:
                        cell.freeLabel.text = station.cellLabelForFreePlace()
                        cell.updateLabel.text = station.cellLabelForUpdatedTime()
                        cell.typeImageView.image = Shared.cellCarIcon
                    }
                }
            }
        }
        return cell
    }

    // Mainly prepare cell design.
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let clearView = UIView()
        clearView.backgroundColor = .clear
        cell.selectedBackgroundView = clearView
        cell.contentView.layer.masksToBounds = true
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
    }
}
