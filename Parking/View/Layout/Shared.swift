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
}
