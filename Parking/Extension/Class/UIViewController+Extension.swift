//
//  UIViewController+Extension.swift
//  Parking
//
//  Created by Genapi on 20/01/2022.
//

import Foundation
import UIKit

// MARK: - UIViewController Extension

extension UIViewController {
    /// Func : use to hide keyboard when clicking somewhere else on the screen
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
