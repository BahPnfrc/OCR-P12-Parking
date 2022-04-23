import Foundation
import UIKit

// MARK: - Paint

class Paint {
    static let colorWhite = UIColor(rgb: 0xFFFDFC)
    static let colorHalfWhite = colorWhite.withAlphaComponent(0.5)
    static let colorGrey = UIColor(rgb: 0x949494)
    static let container = UIColor(rgb: 0xF4F3EF).withAlphaComponent(0.80)
    /// Default "def" values used for the interface.
    static let defViewColor: UIColor = container
    static let defRadius: CGFloat = 15
}
