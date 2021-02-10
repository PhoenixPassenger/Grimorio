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
        label.font = UIFont.boldSystemFont(ofSize: 20)
        self.addSubview(label)
        return label
    }()
    
    lazy var favButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        btn.tintColor = .lightGray
        self.addSubview(btn)
        return btn
    }()

    override func draw(_ rect: CGRect) {
        self.layer.backgroundColor = UIColor.mintCream.cgColor
    }
    func set( spell : SpellList, favorited: Bool) {
        titleLabel.text = spell.name
        isHearted = favorited
    }
    

}
extension FavoritesCell {
    private func setupUI() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            favButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            favButton.topAnchor.constraint(equalTo: self.topAnchor),
        ])
        //accessoryView = favButton
    }
}

