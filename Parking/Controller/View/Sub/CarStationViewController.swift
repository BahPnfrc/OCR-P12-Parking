import UIKit

// MARK: - CarStationViewController

class CarStationViewController: StationViewController {

    // MARK: - Loading

    private func makeMainView() {
        NetworkCaller.shared.delegate = self
        NetworkCaller.shared.reloadCarMetaData(forced: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeMainView()
    }

    override func viewWillAppear(_ animated: Bool) {
        makeMainView()
        super.viewWillAppear(animated)
        defineNewData()
    }

    // MARK: - Data functions

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
            NetworkCaller.shared.reloadCarMetaData(forced: true)
            self.defineNewData()
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, animations: {
                tappedImage.transform = CGAffineTransform.identity
            })
        })
    }
}

// MARK: - NetworkDataDelegate

extension CarStationViewController: NetworkCallerDelegate {
    func didUpdateRequestState(_ state: Bool) { super.isRequesting = state }
    func didUpdateBikeData() { return }
    func didUpdateCarData() { defineNewData() }
}
