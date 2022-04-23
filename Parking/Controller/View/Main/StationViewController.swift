import UIKit

// MARK: - StationViewController

class StationViewController: UIViewController {

    // MARK: - Outlets

    var statusBarView: UIView!
    var requestingIndicator: UIActivityIndicatorView?
    var headerView: UIView!

    var topRowImageView: UIImageView!
    var topRowLabel: UILabel!
    var bottomRowLeftImageView: UIImageView!
    var bottomRowRightImageView: UIImageView!
    var bottomRowSearchBar: UISearchBar!
    
    private var tableView: UITableView!
    
    lazy var mainView: UIView! = {
        self.view
    }()
    
    let headerViewImageSize: CGFloat = 40
    let headerViewTableSpacing: CGFloat = 10
    
    // MARK: - Properties

    var isRequesting: Bool = false {
        didSet {
            if isRequesting {
                requestingIndicator?.startAnimating()
            } else {
                requestingIndicator?.stopAnimating()
                defineNewHeaderTitle()
            }
        }
    }

    var isSearching = false
    var searchingKey: String?
    private var dataSource: [StationCellItem]?

    // MARK: - Loading
    
    func initViews() {
        initBackgroundView()
        initStatusBarView()
        initHeaderView()
        initTableView()
        initActivityIndicator()
    }
    
    func initBackgroundView() {
        let backgroundView = UIImageView(frame: UIScreen.main.bounds)
            backgroundView.image = UIImage(named: "AppBackground")
            backgroundView.contentMode = .scaleToFill
            mainView.insertSubview(backgroundView, at: 0)
    }
    
    func initStatusBarView() {
        let statusBarView = UIView()
        statusBarView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(statusBarView)
        statusBarView.leftAnchor.constraint(equalTo: mainView.leftAnchor).isActive = true
        statusBarView.bottomAnchor.constraint(equalTo: mainView.safeAreaLayoutGuide.topAnchor).isActive = true
        statusBarView.rightAnchor.constraint(equalTo: mainView.rightAnchor).isActive = true
        statusBarView.heightAnchor.constraint(equalToConstant: mainView.frame.height).isActive = true
        self.statusBarView = statusBarView
    }
    
    func initHeaderView() {
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(headerView)
        headerView.topAnchor.constraint(equalTo: mainView.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        headerView.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 20).isActive = true
        headerView.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -20).isActive = true
        headerView.backgroundColor = .green
        self.headerView = headerView
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = headerViewTableSpacing
        stackView.contentMode = .scaleToFill
        headerView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20).isActive = true
        stackView.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -20).isActive = true
        stackView.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -20).isActive = true
        
        let stackViewTopRow = UIStackView()
        let stackViewBottomRow = UIStackView()
        for stackViewRow in [stackViewTopRow, stackViewBottomRow] {
            stackViewRow.translatesAutoresizingMaskIntoConstraints = false
            stackViewRow.axis = .horizontal
            stackViewRow.alignment = .fill
            stackViewRow.distribution = .fill
            stackViewRow.spacing = headerViewTableSpacing
            stackViewRow.contentMode = .scaleToFill
            stackView.addArrangedSubview(stackViewRow)
        }
        
        initHeaderViewTopRow(in: stackViewTopRow)
        initHeaderViewBottomRow(in: stackViewBottomRow)
    }
    
    func initHeaderViewTopRow(in stackView: UIStackView) {
        let topRowImageView = UIImageView()
        topRowImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(topRowImageView)
        topRowImageView.widthAnchor.constraint(equalToConstant: headerViewImageSize).isActive = true
        topRowImageView.heightAnchor.constraint(equalTo: topRowImageView.widthAnchor).isActive = true
        self.topRowImageView = topRowImageView
        
        let topRowLabel = UILabel()
        topRowLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(topRowLabel)
        self.topRowLabel = topRowLabel
    }
    
    func initHeaderViewBottomRow(in stackView: UIStackView) {
        let bottomRowLeftImageView = UIImageView()
        bottomRowLeftImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(bottomRowLeftImageView)
        bottomRowLeftImageView.widthAnchor.constraint(equalToConstant: headerViewImageSize).isActive = true
        bottomRowLeftImageView.heightAnchor.constraint(equalTo: bottomRowLeftImageView.widthAnchor).isActive = true
        self.bottomRowLeftImageView = bottomRowLeftImageView
        
        let bottomRowRightImageView = UIImageView()
        bottomRowRightImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(bottomRowRightImageView)
        bottomRowRightImageView.widthAnchor.constraint(equalToConstant: headerViewImageSize).isActive = true
        bottomRowRightImageView.heightAnchor.constraint(equalTo: bottomRowRightImageView.widthAnchor).isActive = true
        self.bottomRowRightImageView = bottomRowRightImageView
        
        let bottomRowSearchBar = UISearchBar()
        bottomRowSearchBar.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(bottomRowSearchBar)
        self.bottomRowSearchBar = bottomRowSearchBar
    }
    
    func initTableView() {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20).isActive = true
        tableView.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: mainView.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        tableView.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -20).isActive = true
        tableView.backgroundColor = .red
        self.tableView = tableView
    }
    
    func initActivityIndicator() {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        headerView.addSubview(activityIndicatorView)
        activityIndicatorView.topAnchor.constraint(equalTo: headerView.topAnchor, constant:  10).isActive = true
        activityIndicatorView.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -10).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalTo: activityIndicatorView.heightAnchor).isActive = true
        self.requestingIndicator = activityIndicatorView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
        hideKeyboardWhenTappedAround()
        bottomRowSearchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        paintHeader()
        paintSearchBar()
        paintTableView()

        let gesture = UITapGestureRecognizer(target: self, action: #selector(forceReload))
        bottomRowLeftImageView.isUserInteractionEnabled = true
        bottomRowLeftImageView.addGestureRecognizer(gesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    @objc func forceReload(tapGestureRecognizer: UITapGestureRecognizer)
    {
        fatalError("Must override") // Handle in subclasses
    }

    // MARK: - Paint functions

    func paintHeader() {
        statusBarView.backgroundColor = Paint.defViewColor
        requestingIndicator?.hidesWhenStopped = true
        headerView.backgroundColor = Paint.defViewColor
        headerView.layer.cornerRadius = Paint.defRadius
        topRowImageView.image = Shared.headerDefaultIcon
        topRowLabel.text = "Décompte parkings"
        bottomRowRightImageView.image = Shared.paintedSystemImage(named: "magnifyingglass.circle.fill")
        bottomRowLeftImageView.image = Shared.paintedSystemImage(named: "arrow.triangle.2.circlepath.circle.fill")
    }

    func paintSearchBar() {
        bottomRowSearchBar.placeholder = "Filtrer"
        bottomRowSearchBar.setImage(UIImage(), for: .search, state: .normal)
        bottomRowSearchBar.backgroundImage = UIImage()
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
        (topRowImageView.image, topRowLabel.text) = newHeader
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

// MARK: - UISearchBarDelegate

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
