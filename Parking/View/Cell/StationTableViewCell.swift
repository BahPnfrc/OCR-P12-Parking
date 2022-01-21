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


    var isRequesting: Bool = false {
        didSet {
            if isRequesting {
                typeImageView.isHidden = true
                activityIndicator.startAnimating()
            } else {
                typeImageView.isHidden = false
                activityIndicator.stopAnimating()
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        isRequesting = false
        paint()
    }

    private func paint() {
        activityIndicator.hidesWhenStopped = true
        background.layer.cornerRadius = Paint.defRadius
        background.backgroundColor = Paint.defViewColor

        freeImageView.image = Shared.paintedSystemImage(named: "checkmark.circle.fill", .white, .black, .black)
        updatedImageView.image = Shared.paintedSystemImage(named: "clock.badge.checkmark.fill", .black, .black, .black)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }



}
