import UIKit
import MapKit

class StationTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet private weak var background: UIImageView!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var freeLabel: UILabel!
    @IBOutlet weak var updateLabel: UILabel!

    @IBOutlet weak var freeImageView: UIImageView!
    @IBOutlet weak var updatedImageView: UIImageView!

    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!

    // MARK: - Properties

    var station: StationCellItem?
    var isFavorite = false {
        didSet {
            if isFavorite {
                favoriteImageView.image = Shared.favoriteCheckedIcon
            } else {
                favoriteImageView.image = Shared.favoriteUncheckedIcon
            }
        }
    }
    var isRequesting = false {
        didSet {
            if isRequesting {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }

    // MARK: - Loading

    override func awakeFromNib() {
        super.awakeFromNib()
        paint()
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    private func paint() {
        activityIndicator.hidesWhenStopped = true
        background.layer.cornerRadius = Paint.defRadius
        background.backgroundColor = Paint.defViewColor

        freeImageView.image = Shared.paintedSystemImage(named: "arrow.left.arrow.right.circle", .black, .black, .black)
        updatedImageView.image = Shared.paintedSystemImage(named: "clock.badge.checkmark", .black, .black, .black)
    }

    // MARK: - Other functions

    @IBAction func didTapFavoriteButton(_ sender: Any) {
        guard let station = station else { return }
        if isFavorite {
            try? station.cellFavoriteDelete()
            print("🟪 CORE DATA Deleted : \(station.cellName())")
        } else {
            station.cellFavoriteAdd()
            print("🟪 CORE DATA Saved : \(station.cellName())")
        }
        isFavorite = station.cellIsFavorite()
    }




}
