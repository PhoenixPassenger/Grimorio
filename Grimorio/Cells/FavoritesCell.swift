//
//  FavoritesCell.swift
//  Grimorio
//
//  Created by Rodrigo Silva Ribeiro on 09/02/21.
//  Copyright © 2021 Rodrigo Silva Ribeiro. All rights reserved.
//

import Foundation
import UIKit

class FavoritesCell: UITableViewCell {
    
    var isHearted: Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .raisenBlack
        self.selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        setupUI()
    }

    // MARK: - Properties
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .redSalsa
        label.font = UIFont.boldSystemFont(ofSize: 26)
        self.addSubview(label)
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .redSalsa
        label.font = UIFont.boldSystemFont(ofSize: 18)
        self.addSubview(label)
        return label
    }()

    func set(spell: FavoriteSpellCD) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        titleLabel.text = spell.name
        subtitleLabel.text = formatter.string(from: NSNumber(value: spell.level))! + " Level " + spell.school!
    }
    
}
extension FavoritesCell {
    private func setupUI() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 17)
        ])
        //accessoryView = favButton
    }
}
