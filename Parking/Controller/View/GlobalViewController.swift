//
//  GlobalViewController.swift
//  Parking
//
//  Created by Genapi on 20/01/2022.
//

import UIKit

class GlobalViewController: UIViewController {

    private var requestCount: Int = 0
    var isRequesting: Bool {
        get {
            return requestCount > 0
        }
        set(newValue) {
            requestCount += (newValue ? 1 : -1)
            if requestCount < 0 { requestCount = 0 }

            requestCount > 0 ? self.navigationController?.startSpinning() : self.navigationController?.stopSpinning()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
