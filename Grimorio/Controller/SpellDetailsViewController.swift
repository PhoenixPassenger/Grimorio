//
//  SpellDetailsViewController.swift
//  Grimorio
//
//  Created by Rodrigo Silva Ribeiro on 17/08/20.
//  Copyright © 2020 Rodrigo Silva Ribeiro. All rights reserved.
//

import UIKit

class SpellDetailsViewController: UIViewController {
    let spellItemPresenter  = SpellItemPresenter()
    let favoriteSpellPresenter = FavoriteSpellCDPresenter()
    var spellCD: FavoriteSpellCD?
    var spell: SpellList
    var infoArray: [(String, String)] = []
    init( _ spell: SpellList ) {
        self.spell = spell
        self.spellCD = favoriteSpellPresenter.getSpellByName(spell.name)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var detailedSpell = Spell().self {
        didSet {
            if let lvl = detailedSpell.level {
                self.infoArray.append(("Level", String(lvl)))
            }
            if let school = detailedSpell.school?.name {
                self.infoArray.append(("School", school))
            }

            if let range = detailedSpell.range {
                self.infoArray.append(("Range", range))
            }

            if let components = detailedSpell.components {
                let fullComponentes: String = components.joined(separator: ",")
                self.infoArray.append(("Components", fullComponentes))
            }

            if let ritual = detailedSpell.ritual {
                self.infoArray.append(("Ritual", String(ritual)))
            }

            if let concentrarion = detailedSpell.concentration {
                self.infoArray.append(("Concentrarion", String(concentrarion)))
            }

            if let castingTime = detailedSpell.castingTime {
                self.infoArray.append(("Casting Time", castingTime))
            }

            if let duration = detailedSpell.duration {
                self.infoArray.append(("Duration", duration))
            }
            
            let desc: String = detailedSpell.desc.joined(separator: "\n")
            self.infoArray.append(("Description", desc))
            
            if let atHigherLevel = detailedSpell.higherLevel {
                let fullAtHigherLevel: String = atHigherLevel.joined(separator: "\n")
                self.infoArray.append(("At higher levels", fullAtHigherLevel))
            }
            tableView.reloadData()
        }
    }

    var isHearted = false

    let defaults = UserDefaults.standard

    lazy var heartButton = UIBarButtonItem(title: "heart", style: .done, target: self, action: #selector(heart(sender:)))

    let contentView: UIView = UIView()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SpellCell.self, forCellReuseIdentifier: "SpellCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.tintColor = .redSalsa
        return tableView
    }()
    
    override func viewDidLoad() {
        getSpells()
        super.viewDidLoad()
        self.title = self.spell.name
        setupLayout()
        self.view.backgroundColor = .mintCream
        self.navigationItem.largeTitleDisplayMode = .always
    }

    private func getSpells() {
        self.tableView.setLoading(true)
        if self.defaults.bool(forKey: self.spell.name) {
            do {
                let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("\(self.spell.name).json")

                let data = try Data(contentsOf: fileURL)
                let spellDetailed = try? JSONDecoder().decode(Spell.self, from: data)
                guard let spelldetails = spellDetailed else {
                    return
                }
                DispatchQueue.main.async {
                    self.tableView.setLoading(false)
                    self.detailedSpell = spelldetails
                }
            } catch {
                print(error.localizedDescription)
            }
        } else {
            spellItemPresenter.getSpell(spell: spell, finished: { response in
                self.tableView.setLoading(false)
                self.detailedSpell = response
            })
        }
       }

}

extension SpellDetailsViewController {
    func prepareHeartButton() {
        self.isHearted = self.defaults.bool(forKey: self.spell.name)
        if self.isHearted {
            self.heartButton.image = UIImage(systemName: "heart.fill")
        } else {
            self.heartButton.image = UIImage(systemName: "heart")
        }
        self.navigationItem.setRightBarButton(self.heartButton, animated: true)
    }

    @objc func heart(sender: UIBarButtonItem) {

        self.isHearted = !self.isHearted
        let detailedSpell = self.detailedSpell
        if self.isHearted {
            self.heartButton.image = UIImage(systemName: "heart.fill")
            favoriteSpellPresenter.saveOnFM(detailedSpell)
            let spellToFavorite = FavoriteSpell(name: detailedSpell.name, level: detailedSpell.level!, school: (detailedSpell.school?.name!)!, index: detailedSpell.index)
            self.spellCD = favoriteSpellPresenter.newSpell(spell: spellToFavorite)
            defaults.set(true, forKey: self.detailedSpell.name)
        } else {
           self.heartButton.image = UIImage(systemName: "heart")
            favoriteSpellPresenter.deleteFromFM(detailedSpell.name)
            self.favoriteSpellPresenter.deleteSkill(self.spellCD!)
            defaults.set(false, forKey: self.detailedSpell.name)
        }
        self.navigationItem.setRightBarButton(self.heartButton, animated: true)

    }

    private func setupLayout() {
        prepareHeartButton()
        setupUI()
        
       }

}

extension SpellDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    private func setupUI() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
    }
    
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
        return infoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellWrap = tableView.dequeueReusableCell(withIdentifier: "SpellCell") as? SpellCell
        guard let cell = cellWrap else { fatalError() }
        let info = infoArray[indexPath.section]
        if info.0 == "Description" || info.0 == "At higher levels" {
            self.tableView.rowHeight = 205
            cell.set(info, isMultiline: true)
        } else {
            self.tableView.rowHeight = 70
            cell.set(info)
        }
        return cell
    }
}

extension String {

    var numberOfLines: Int {
        print(self.components(separatedBy: ".").count)
        return self.components(separatedBy: ".").count
    }

}
