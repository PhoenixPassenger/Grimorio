import UIKit

class TableViewController: UIViewController, UISearchBarDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getSpells()
        setupSearchBar()
        self.view.backgroundColor = .mintCream
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    let presenter = SpellItemPresenter()
    var filteredSpells: [SpellList] = []
    var list: [SpellList] = [] {
        didSet {
        filteredSpells = list
        self.tableView.reloadData()
        }

    }
    var url: [String] = []
    var spellTitles: [SpellList] = []

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

    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        if textSearched == "" {
            filteredSpells = list
        } else {
            filteredSpells = list.filter { item in
                return item.name.lowercased().contains(textSearched.lowercased())
            }
        }
        tableView.reloadData()
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.tintColor = .redSalsa
        return tableView
    }()
}

extension TableViewController {
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.view.addSubview(tableView)
        tableView.rowHeight = 66
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }

    private func getSpells() {
        self.tableView.setLoading(true)
        presenter.getSpells { response in
            self.list = response
            self.tableView.setLoading(false)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        let cellWrap = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as? TableViewCell
        guard let cell = cellWrap else { fatalError() }
        cell.set(spell: filteredSpells[indexPath.section])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let dest = SpellDetailsViewController(filteredSpells[indexPath.section])
        self.navigationController?.pushViewController(dest, animated: true)
    }

}
