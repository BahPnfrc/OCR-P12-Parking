import Foundation
import UIKit

// MARK: - Shared

class Shared {
    /// Create a painted image from iOS stock icons.
    static func paintedSystemImage(
        named systemName: String,
        _ firstColor: UIColor = .white,
        _ secondColor: UIColor = .black,
        _ thirdColor: UIColor = .black) -> UIImage? {
        let config = UIImage.SymbolConfiguration(paletteColors: [firstColor, secondColor, thirdColor])
        let image = UIImage(systemName: systemName)
        return image?.applyingSymbolConfiguration(config)
    }

    static let tabBikeIcon = paintedSystemImage(named: "bicycle", .black, .black, .black)
    static let tabCarIcon = paintedSystemImage(named: "car.fill", .black, .black, .black)
    static let tabFavoriteIcon = paintedSystemImage(named: "star.fill", .black, .black, .black)

    static let cellBikeIcon = paintedSystemImage(named: "bicycle.circle.fill", .white, .black, .black)
    static let cellCarIcon = paintedSystemImage(named: "car.circle.fill", .white, .black, .black)
    static let cellDefaultIcon = paintedSystemImage(named: "xmark.circle.fill")
    
    static let headerDefaultIcon = paintedSystemImage(named: "info.circle.fill")

    static let favoriteCheckedIcon = Shared.paintedSystemImage(named: "star.fill", .black)
    static let favoriteUncheckedIcon = Shared.paintedSystemImage(named: "star.slash", .black)
}
