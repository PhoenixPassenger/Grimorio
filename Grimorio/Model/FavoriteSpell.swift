//
//  FavoriteSpell.swift
//  Grimorio
//
//  Created by Rodrigo Silva Ribeiro on 09/02/21.
//  Copyright © 2021 Rodrigo Silva Ribeiro. All rights reserved.
//

import Foundation
class FavoriteSpell : Codable {
    let index: String
    let name: String
    let level: Int
    let school: String
    
    init(name: String, level: Int, school: String, index: String) {
        self.name = name
        self.level = level
        self.school = school
        self.index = index
    }
}
