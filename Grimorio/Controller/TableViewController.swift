import UIKit

class TableViewController: UIViewController, UISearchBarDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getSpells()
        setupSearchBar()
        //self.navigationItem.largeTitleDisplayMode = .never
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
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()
}

extension TableViewController {
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.view.addSubview(tableView)
        tableView.rowHeight = 80

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            tableView.heightAnchor.constraint(equalTo: self.view.heightAnchor)
        ])
    }

    private func getSpells() {
        presenter.getSpells { response in
            self.list = response
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSpells.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellWrap = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as? TableViewCell
        guard let cell = cellWrap else { fatalError() }
        cell.set(spell: filteredSpells[indexPath.row], favorited: false)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let dest = SpellDetailsViewController(filteredSpells[indexPath.row])
        self.navigationController?.pushViewController(dest, animated: true)
    }

}
