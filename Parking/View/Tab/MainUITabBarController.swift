//
//  MainUITabBarController.swift
//  Parking
//
//  Created by Genapi on 20/01/2022.
//

import UIKit

class MainUITabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
        setTabItems()
    }
    
    private func setTabBar() {
        UITabBar.appearance().backgroundColor = Paint.defViewColor
        UITabBar.appearance().layer.cornerRadius = Paint.defRadius
    }

    private func setTabItems() {
        let items = tabBar.items! as [UITabBarItem]
        let data: [(title: String, image: UIImage?)] = [
            ("Voiture", Shared.paintedSystemImage(named: "car.fill")),
            ("Vélo", Shared.paintedSystemImage(named: "bicycle")),
            ("Mes Parkings", Shared.paintedSystemImage(named: "star.fill"))
        ]

        guard items.count == data.count else {
            fatalError()
        }

        for index in 0...items.count - 1 {
            (items[index].title, items[index].image) = (data[index].title, data[index].image)
        }

        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
    }
}
