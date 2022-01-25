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
            ("Voiture", Shared.tabCarIcon),
            ("Vélo", Shared.tabBikeIcon),
            ("Favoris", Shared.tabFavoriteIcon)
        ]

        guard items.count == data.count else {
            fatalError()
        }

        for index in 0...items.count - 1 {
            items[index].title = data[index].title
            items[index].image = data[index].image
            items[index].selectedImage = data[index].image
        }

        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
    }
}
