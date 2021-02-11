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
            self.descLbl.text = detailedSpell.desc[0]
            self.rangeLbl.text = detailedSpell.range
            self.levelLbl.text = String(detailedSpell.level!)
            if let material = detailedSpell.material {
                self.materialLbl.text = material            }
            if let higherLevel = detailedSpell.higherLevel {
                self.higherlevelLbl.text = higherLevel[0]
            }

        }
    }

    var isHearted = false

    let defaults = UserDefaults.standard

    lazy var heartButton = UIBarButtonItem(title: "heart", style: .done, target: self, action: #selector(heart(sender:)))

    var nameTitle = UILabel()
    var nameLbl = UILabel()

    var descTitle = UILabel()
    var descLbl = UILabel()

    var materialTitle = UILabel()
    var materialLbl = UILabel()

    var rangeTitle = UILabel()
    var rangeLbl = UILabel()

    var higherlevelTitle = UILabel()
    var higherlevelLbl = UILabel()

    var levelTitle = UILabel()
    var levelLbl = UILabel()

    let contentView: UIView = UIView()

    let scrollView: UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        scrollview.backgroundColor = .mintCream
        return scrollview
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        getSpells()
        super.viewDidLoad()
        nameTitle.text = spell.name
        self.title = nameTitle.text
        setupLayout()
        self.view.backgroundColor = .mintCream
        self.navigationItem.largeTitleDisplayMode = .always
    }

    private func getSpells() {
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
                    self.detailedSpell = spelldetails
                }
            } catch {
                print(error.localizedDescription)
            }
        } else {
            spellItemPresenter.getSpell(spell: spell, finished: { response in
                self.detailedSpell = response
            })
        }
       }

}

extension SpellDetailsViewController {
    func setupTitle(label: UILabel) -> UILabel {
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .systemRed
        return label
    }

    func setupBody(label: UILabel) -> UILabel {
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        label.numberOfLines = 16
        return label
    }

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

        self.view.addSubview(scrollView)

        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true

        descTitle = setupTitle(label: descTitle)
        descTitle.text = "Description : "
        descLbl = setupBody(label: descLbl)

        rangeTitle = setupTitle(label: rangeTitle)
        rangeTitle.text = "Range : "
        rangeLbl = setupBody(label: rangeLbl)

        higherlevelTitle = setupTitle(label: higherlevelTitle)
        higherlevelTitle.text = "Higher Level : "
        higherlevelLbl = setupBody(label: higherlevelLbl)

        levelTitle = setupTitle(label: levelTitle)
        levelTitle.text = "Level : "
        levelLbl = setupBody(label: levelLbl)

        materialTitle = setupTitle(label: materialTitle)
        materialTitle.text = "Material : "
        materialLbl = setupBody(label: materialLbl)

        view.addSubview(nameTitle)
        view.addSubview(descLbl)
        let stackview = UIStackView()

        stackview.axis = .vertical
        stackview.spacing = 10
        //Aqui
        stackview.distribution = .fill
        stackview.translatesAutoresizingMaskIntoConstraints = false

        stackview.addArrangedSubview(descTitle)
        descTitle.leadingAnchor.constraint(equalTo: stackview.leadingAnchor).isActive = true
        descTitle.trailingAnchor.constraint(equalTo: stackview.trailingAnchor).isActive = true

        stackview.addArrangedSubview(descLbl)
        descLbl.leadingAnchor.constraint(equalTo: stackview.leadingAnchor).isActive = true
        descLbl.trailingAnchor.constraint(equalTo: stackview.trailingAnchor).isActive = true

        stackview.addArrangedSubview(rangeTitle)
        rangeTitle.leadingAnchor.constraint(equalTo: stackview.leadingAnchor).isActive = true
        rangeTitle.trailingAnchor.constraint(equalTo: stackview.trailingAnchor).isActive = true

        stackview.addArrangedSubview(rangeLbl)
        rangeLbl.leadingAnchor.constraint(equalTo: stackview.leadingAnchor).isActive = true
        rangeLbl.trailingAnchor.constraint(equalTo: stackview.trailingAnchor).isActive = true

        stackview.addArrangedSubview(levelTitle)
        levelTitle.leadingAnchor.constraint(equalTo: stackview.leadingAnchor).isActive = true
        levelTitle.trailingAnchor.constraint(equalTo: stackview.trailingAnchor).isActive = true

        stackview.addArrangedSubview(levelLbl)
        levelLbl.leadingAnchor.constraint(equalTo: stackview.leadingAnchor).isActive = true
        levelLbl.trailingAnchor.constraint(equalTo: stackview.trailingAnchor).isActive = true

        stackview.addArrangedSubview(materialTitle)
        materialTitle.leadingAnchor.constraint(equalTo: stackview.leadingAnchor).isActive = true
        materialTitle.trailingAnchor.constraint(equalTo: stackview.trailingAnchor).isActive = true

        stackview.addArrangedSubview(materialLbl)
        materialLbl.leadingAnchor.constraint(equalTo: stackview.leadingAnchor).isActive = true
        materialLbl.trailingAnchor.constraint(equalTo: stackview.trailingAnchor).isActive = true

        stackview.addArrangedSubview(higherlevelTitle)
        higherlevelTitle.leadingAnchor.constraint(equalTo: stackview.leadingAnchor).isActive = true
        higherlevelTitle.trailingAnchor.constraint(equalTo: stackview.trailingAnchor).isActive = true

        stackview.addArrangedSubview(higherlevelLbl)
        higherlevelLbl.leadingAnchor.constraint(equalTo: stackview.leadingAnchor).isActive = true
        higherlevelLbl.trailingAnchor.constraint(equalTo: stackview.trailingAnchor).isActive = true

        contentView.addSubview(stackview)
        stackview.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        stackview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        stackview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        stackview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 0).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
        contentView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        let heightAnchor = contentView.heightAnchor.constraint(equalTo: view.heightAnchor)
        heightAnchor.priority = .defaultLow
        heightAnchor.isActive = true

       }

}

extension SpellDetailsViewController: UITableViewDelegate, UITableViewDataSource {
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
            tableView.heightAnchor.constraint(equalTo: self.view.heightAnchor)
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
