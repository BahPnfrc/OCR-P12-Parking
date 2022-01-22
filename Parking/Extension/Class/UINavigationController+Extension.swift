//
//  UINavigationController+Extension.swift
//  Parking
//
//  Created by Genapi on 20/01/2022.
//

import UIKit

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle { topViewController?.preferredStatusBarStyle ?? .default }

    public func startSpinning() {
        var spinnerView: UIActivityIndicatorView?
        visibleViewController?.navigationItem.rightBarButtonItems?.forEach({ (barButton) in
            if let spinner = barButton.customView as? UIActivityIndicatorView {
                spinnerView = spinner
            }
        })
        if let sv = spinnerView {
            sv.startAnimating()
        } else {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.color = UIColor.white
            spinner.startAnimating()
            spinner.hidesWhenStopped = true
            if visibleViewController?.navigationItem.rightBarButtonItems != nil {
                visibleViewController?.navigationItem.rightBarButtonItems?.append(UIBarButtonItem(customView: spinner))
            } else {
                visibleViewController?.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: spinner)]
            }
        }
    }

    public func stopSpinning() {
        var rightBarButtonItems: [UIBarButtonItem] = []
        visibleViewController?.navigationItem.rightBarButtonItems?.forEach({ (barButton) in
            if let spinner = barButton.customView as? UIActivityIndicatorView {
                spinner.stopAnimating()
                spinner.removeFromSuperview()
                self.visibleViewController?.navigationItem.rightBarButtonItems = nil
            } else {
                rightBarButtonItems.append(barButton)
            }
        })
        visibleViewController?.navigationItem.rightBarButtonItems = rightBarButtonItems
    }

}
