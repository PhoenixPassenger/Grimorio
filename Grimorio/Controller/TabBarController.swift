import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = .systemBlue
        self.tabBar.unselectedItemTintColor = .darkText

        let tableVC = TableViewController()
        tableVC.title = ("Grimoire")
        let tableVCItem = UITabBarItem(title: "Grimoire", image: UIImage(systemName: "book.fill"),
                                       selectedImage: UIImage(systemName: "book.fill"))
        tableVCItem.title = "Grimoire"
        tableVC.tabBarItem = tableVCItem
        let favoriteVC = FavoritesViewController()
        favoriteVC.title = ("Favorites")
        favoriteVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)

        let favoriteNC = UINavigationController(rootViewController: favoriteVC)
        favoriteNC.overrideUserInterfaceStyle = .light
        let tableNC = UINavigationController(rootViewController: tableVC)
        tableNC.overrideUserInterfaceStyle = .light
        let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        navBarAppearance.backgroundColor = .white
        tableNC.navigationBar.standardAppearance = navBarAppearance
        tableNC.navigationBar.scrollEdgeAppearance = navBarAppearance
        self.viewControllers = [tableNC, favoriteNC]

    }

}
