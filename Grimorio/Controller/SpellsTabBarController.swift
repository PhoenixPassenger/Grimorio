import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = .redSalsa
        self.tabBar.unselectedItemTintColor = .mintCream
        self.tabBar.barTintColor = .raisenBlack
        self.hideKeyboardWhenTappedAround()
        let tableVC = SpellsTableViewController()
        tableVC.title = ("Grimoire")
        let tableVCItem = UITabBarItem(title: "Grimoire", image: UIImage(systemName: "book.fill"),
                                       selectedImage: UIImage(systemName: "book.fill"))
        tableVCItem.title = "Grimoire"
        tableVC.tabBarItem = tableVCItem
        let favoriteVC = FavoritesViewController()
        favoriteVC.title = ("Favorites")
        favoriteVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)

        let favoriteNC = UINavigationController(rootViewController: favoriteVC)
        favoriteNC.navigationBar.tintColor = .redSalsa
        let tableNC = UINavigationController(rootViewController: tableVC)
        tableNC.navigationBar.tintColor = .redSalsa
        let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.mintCream]
            navBarAppearance.backgroundColor = .raisenBlack
        
        tableNC.navigationBar.standardAppearance = navBarAppearance
        tableNC.navigationBar.scrollEdgeAppearance = navBarAppearance
        favoriteNC.navigationBar.standardAppearance = navBarAppearance
        favoriteNC.navigationBar.scrollEdgeAppearance = navBarAppearance
        self.viewControllers = [tableNC, favoriteNC]

    }

}
