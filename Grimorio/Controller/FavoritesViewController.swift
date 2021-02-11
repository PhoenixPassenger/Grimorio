import UIKit

class FavoritesViewController: UIViewController, UISearchBarDelegate {
    let favoritesPresenter = FavoriteSpellCDPresenter()
    override func viewDidLoad() {
        self.title = "Favorites"
        super.viewDidLoad()
        setupUI()
        getDownloadedSpell()
        setupSearchBar()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    var filteredSpells: [FavoriteSpellCD] = []
    var list: [FavoriteSpellCD] = [] {
        didSet {
        filteredSpells = list
        self.tableView.reloadData()
        }
    }
    var url: [String] = []

    lazy var searchBar: UISearchBar = UISearchBar()

    private func setupSearchBar() {
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = " Search spell"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        navigationController?.navigationBar.isTranslucent = false
    }

    override func viewWillAppear(_ animated: Bool) {
        searchBar.text = ""
        getDownloadedSpell()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        if textSearched == "" {
            filteredSpells = list
        } else {
            filteredSpells = list.filter { item in
                return item.name!.lowercased().contains(textSearched.lowercased())
            }
        }
        tableView.reloadData()
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoritesCell.self, forCellReuseIdentifier: "FavoritesCell")
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()

}

extension FavoritesViewController {
    func getDownloadedSpell() {
        self.list = []
        var temp: [FavoriteSpellCD] = []
        temp = favoritesPresenter.fetchSpells()
        self.list = temp
    }

}

extension FavoritesViewController {
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.view.addSubview(tableView)
        tableView.rowHeight = 113
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalTo: self.view.heightAnchor)
        ])
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredSpells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellWrap = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell") as? FavoritesCell
        guard let cell = cellWrap else { fatalError() }
        cell.set(spell: filteredSpells[indexPath.section])
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let spellToGo = SpellList(filteredSpells[indexPath.section].name!, index: filteredSpells[indexPath.section].index!)
        let dest = SpellDetailsViewController(spellToGo)
        self.navigationController?.pushViewController(dest, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            do {
                let fileURL = try FileManager.default
                    .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    .appendingPathComponent("\(self.filteredSpells[indexPath.section].name!).json")

                try FileManager.default.removeItem(at: fileURL)
            } catch {
                print(error)
            }
            UserDefaults.standard.set(false, forKey: self.filteredSpells[indexPath.section].name!)
            self.favoritesPresenter.deleteSkill(self.filteredSpells[indexPath.section])
             self.filteredSpells.remove(at: indexPath.section)
            self.tableView.reloadData()
        }
        deleteAction.backgroundColor = .redSalsa
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}
