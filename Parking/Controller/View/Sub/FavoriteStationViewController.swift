import UIKit

// MARK: - FavoriteStationViewController

class FavoriteStationViewController: StationViewController {

    // MARK: - Loading

    private func makeMainView() {
        NetworkCaller.shared.delegate = self
        NetworkCaller.shared.reloadBikeMetaData(forced: false)
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
        let favorites = {() -> [StationCellItem] in
            do {
                return try CoreDataService.shared.getAll()
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
            NetworkCaller.shared.reloadBikeMetaData(forced: true)
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

extension FavoriteStationViewController: NetworkCallerDelegate {
    func didUpdateRequestState(_ state: Bool) { super.isRequesting = state }
    func didUpdateBikeData() { defineNewData() }
    func didUpdateCarData() { defineNewData() }
}
