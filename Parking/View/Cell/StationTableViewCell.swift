//
//  GlobalTableViewCell.swift
//  Parking
//
//  Created by Genapi on 20/01/2022.
//

import UIKit
import MapKit

class StationTableViewCell: UITableViewCell {

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

    var station: StationCellItem?

    var isFavorite = false {
        didSet {
            if isFavorite {
                favoriteImageView.image = Shared.paintedSystemImage(named: "star.fill", .black, .black, .black)
            } else {
                favoriteImageView.image = Shared.paintedSystemImage(named: "star.slash", .black, .black, .black)
            }
        }
    }
    var isRequesting: Bool = false {
        didSet {
            if isRequesting {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        isFavorite = false
        isRequesting = false
        paint()
    }

    private func paint() {
        activityIndicator.hidesWhenStopped = true
        background.layer.cornerRadius = Paint.defRadius
        background.backgroundColor = Paint.defViewColor

        freeImageView.image = Shared.paintedSystemImage(named: "arrow.left.arrow.right.circle", .black, .black, .black)
        updatedImageView.image = Shared.paintedSystemImage(named: "clock.badge.checkmark", .black, .black, .black)
    }


    @IBAction func didTapFavoriteButton(_ sender: Any) {
        guard let station = station else { return }
        if isFavorite {
            try? station.cellFavoriteDelete()
            print("DELETE OK")
        } else {
            station.cellFavoriteAdd()
            print("ADD OK")
        }
        isFavorite = station.cellIsFavorite()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }



}
