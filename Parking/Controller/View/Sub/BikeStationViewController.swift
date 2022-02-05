import UIKit

// MARK: - BikeStationViewController

class BikeStationViewController: StationViewController {

    // MARK: - Loading

    private func makeMainView() {
        NetworkCaller.shared.delegate = self
        NetworkCaller.shared.reloadBikeMetaData(forced: false)
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
            NetworkCaller.shared.reloadBikeMetaData(forced: true)
            self.defineNewData()
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, animations: {
                tappedImage.transform = CGAffineTransform.identity
            })
        })
    }
}

// MARK: - NetworkDataDelegate

extension BikeStationViewController: NetworkCallerDelegate {
    func didUpdateRequestState(_ state: Bool) { super.isRequesting = state }
    func didUpdateBikeData() { defineNewData() }
    func didUpdateCarData() { return }
}
