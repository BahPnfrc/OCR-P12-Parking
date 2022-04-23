import UIKit

final class MainUITabBarController: UITabBarController {
    
    private let wrapInNavigationController = false
    let tabDataSource: [(view: UIViewController, title: String, image: UIImage?)] = [
        (CarStationViewController(), "Voiture", Shared.tabCarIcon),
        (BikeStationViewController(), "Vélo", Shared.tabBikeIcon),
        (FavoriteStationViewController(), "Favoris", Shared.tabFavoriteIcon)
    ]
    
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
        var views = [UIViewController]()
        for tab in tabDataSource {
            tab.view.title = tab.title
            tab.view.tabBarItem.image = tab.image
            tab.view.tabBarItem.title = tab.title
            views.append(tab.view)
        }
        
        self.viewControllers = !wrapInNavigationController ?
        views : views.map({
            let nc = UINavigationController(rootViewController: $0)
            nc.navigationBar.prefersLargeTitles = false
            nc.navigationBar.setBackgroundImage(UIImage(), for: .default)
            nc.navigationBar.isTranslucent = true
            return nc
        })
        
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
    }
}
