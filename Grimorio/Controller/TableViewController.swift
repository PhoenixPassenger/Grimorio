import UIKit

class TableViewController: UIViewController, UISearchBarDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getSpells()
        setupSearchBar()
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
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
            filteredSpells = list.filter { ap in
                return ap.name.lowercased().contains(textSearched.lowercased())
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
        tableView.rowHeight = 50

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            tableView.heightAnchor.constraint(equalTo: self.view.heightAnchor)
        ])
    }

    private func getSpells() {

        ServiceLayer.request(router: .getAllSpells) { (result) in
            switch result {
            case .success(let data):
                guard let data = data else { return }

                if let dictionary: [String: Any] = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    let innerDictionary = dictionary["results"] as? [[String: Any]],
                   let spellsData = try? JSONSerialization.data(withJSONObject: innerDictionary, options: []) {
                    do {
                        let spells = try JSONDecoder().decode([SpellList].self, from: spellsData)
                        spells.forEach {
                            self.spellTitles.append($0)
                        }
                        DispatchQueue.main.sync {
                            self.list = self.spellTitles
                        }
                    } catch {
                        print(String(bytes: data, encoding: .utf8) ?? "nil")
                        print(error)
                    }
                }

            case .failure(let error):
                print(error.localizedDescription)
            }
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellWrap = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as? TableViewCell
        guard let cell = cellWrap else { fatalError() }
        cell.titleLabel.text = filteredSpells[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let dest = SpellDetailsViewController(filteredSpells[indexPath.row])
        self.navigationController?.pushViewController(dest, animated: true)
        //self.present(dest, animated: true, completion:{})
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            self.filteredSpells.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}
