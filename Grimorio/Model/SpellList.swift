//
//  SpellList.swift
//  Grimorio
//
//  Created by Rodrigo Silva Ribeiro on 14/08/20.
//  Copyright © 2020 Rodrigo Silva Ribeiro. All rights reserved.
//

import Foundation
struct SpellList: Codable {
    let index: String
    let name: String
    let url: String
    init(_ name: String, index: String) {
        self.name = name
        self.index = index
        self.url = ""
    }
}

//dct = JSONSerialization
//innerdct = dct[results] as! [[string : any]]
//
//guard let array = innerdct
//
//foreach array(
//    valData = JSONSerialization.data(withJSONObject: inter, options: []) as Data
//    spellforList = JSONDecoder().decode(SpellList.self, from: valData)
//)
