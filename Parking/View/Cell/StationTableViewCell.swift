//
//  GlobalTableViewCell.swift
//  Parking
//
//  Created by Genapi on 20/01/2022.
//

import UIKit
import MapKit

class StationTableViewCell: UITableViewCell {

    @IBOutlet private weak var background: UIView!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var freeLabel: UILabel!
    @IBOutlet weak var updateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    private func paint() {
        activityIndicator.hidesWhenStopped = true
        background.layer.cornerRadius = Paint.defRadius
        background.backgroundColor = Paint.defViewColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
