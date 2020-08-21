//
//  SpellDetailsViewController.swift
//  Grimorio
//
//  Created by Rodrigo Silva Ribeiro on 17/08/20.
//  Copyright © 2020 Rodrigo Silva Ribeiro. All rights reserved.
//

import UIKit

class SpellDetailsViewController: UIViewController {

    var spell: SpellList
    init( _ spell: SpellList ) {
        self.spell = spell
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var detailedSpell = Spell().self {
        didSet {
            self.descLbl.text = detailedSpell.desc[0]
            self.rangeLbl.text = detailedSpell.range

        }
    }

    var isHearted = false

    let defaults = UserDefaults.standard

    lazy var heartButton = UIBarButtonItem(title: "heart", style: .done, target: self, action: #selector(heart(sender:)))

    var nameTitle = UILabel()
    var nameLbl = UILabel()

    var descTitle = UILabel()
    var descLbl = UILabel()

    var castingTimeTitle = UILabel()
    var castingTimeLbl = UILabel()

    var durationTitle = UILabel()
    var durationLbl = UILabel()

    var rangeTitle = UILabel()
    var rangeLbl = UILabel()

    var componentsTitle = UILabel()
    var componentsLbl = UILabel()

    var classesTitle = UILabel()
    var classesLbl = UILabel()

    let contentView: UIView = UIView()

    let scrollView: UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        scrollview.backgroundColor = .systemBackground
        return scrollview
    }()

    override func viewDidLoad() {
        getSpells()
        super.viewDidLoad()
        nameTitle.text = spell.name
        self.title = nameTitle.text
        setupLayout()

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
            ServiceLayer.request(router: .getSpell(spellIndex: spell.index)) { (result) in
                switch result {
                case .success(let data):
                     guard let data = data else { return }
                     let spellDetailed = try? JSONDecoder().decode(Spell.self, from: data)
                     guard let spelldetails = spellDetailed else {
                         return
                     }
                     DispatchQueue.main.async {
                         self.detailedSpell = spelldetails
                     }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

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
        label.textColor = .systemYellow
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

        if self.isHearted {
            self.heartButton.image = UIImage(systemName: "heart.fill")

            do {
                let fileURL = try FileManager.default
                    .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    .appendingPathComponent("\(self.detailedSpell.name).json")

                try JSONEncoder().encode(self.detailedSpell)
                .write(to: fileURL)
            } catch {
                print(error)
            }

            defaults.set(true, forKey: self.detailedSpell.name)
        } else {
           self.heartButton.image = UIImage(systemName: "heart")
           do {
                let fileURL = try FileManager.default
                    .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    .appendingPathComponent("\(self.detailedSpell.name).json")

                try FileManager.default.removeItem(at: fileURL)
            } catch {
                print(error)
            }

            defaults.set(false, forKey: self.detailedSpell.name)
        }
        self.navigationItem.setRightBarButton(self.heartButton, animated: true)

    }

    private func setupLayout() {
        prepareHeartButton()

        view.backgroundColor = .white
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
