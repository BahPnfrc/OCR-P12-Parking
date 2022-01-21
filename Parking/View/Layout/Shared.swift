//
//  Shared.swift
//  Parking
//
//  Created by Genapi on 20/01/2022.
//

import Foundation
import UIKit

class Shared {
    static func paintedSystemImage(
        named systemName: String,
        _ firstColor: UIColor = .black,
        _ secondColor: UIColor = .black,
        _ thirdColor: UIColor = .black) -> UIImage? {
        let config = UIImage.SymbolConfiguration(paletteColors: [firstColor, secondColor, thirdColor])
        let image = UIImage(systemName: systemName)
        return image?.applyingSymbolConfiguration(config)
    }

    static let tabBikeIcon = paintedSystemImage(named: "bicycle")
    static let tabCarIcon = paintedSystemImage(named: "car.fill")
    static let tabFavoriteIcon = paintedSystemImage(named: "star.fill")

    static let cellBikeIcon = paintedSystemImage(named: "bicycle.circle.fill", .white, .black, .black)
    static let cellCarIcon = paintedSystemImage(named: "car.circle.fill", .white, .black, .black)
    static let cellDefaultIcon = paintedSystemImage(named: "xmark.circle.fill")
}
