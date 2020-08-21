//
//  Spell.swift
//  Grimorio
//
//  Created by Rodrigo Silva Ribeiro on 14/08/20.
//  Copyright © 2020 Rodrigo Silva Ribeiro. All rights reserved.
//

import Foundation
struct Spell: Codable {
    let name: String
    let desc: [String]
    let higherLevel: [String]?
    let range: String?

    private enum CodingKeys: String, CodingKey {
        case higherLevel = "higher_level"
        case desc = "desc"
        case range = "range"
        case name = "name"
    }

    init() {
        self.name = ""
        self.desc = []
        self.higherLevel = nil
        self.range = nil
    }
}
//    "range": "90 feet",
//    "components": [
//        "V",
//        "S",
//        "M"
//    ],
//    "material": "Powdered rhubarb leaf and an adder's stomach.",
//    "ritual": false,
//    "duration": "Instantaneous",
//    "concentration": false,
//    "casting_time": "1 action",
//    "level": 2,
//    "attack_type": "ranged",
//    "damage": {
//        "damage_type": {
//            "name": "Acid",
//            "url": "/api/damage-types/acid"
//        },
//        "damage_at_slot_level": {
//            "2": "4d4",
//            "3": "5d4",
//            "4": "6d4",
//            "5": "7d4",
//            "6": "8d4",
//            "7": "9d4",
//            "8": "10d4",
//            "9": "11d4"
//        }
//    },
//    "school": {
//        "name": "Evocation",
//        "url": "/api/magic-schools/evocation"
//    },
//    "classes": [
//        {
//            "name": "Wizard",
//            "url": "/api/classes/wizard"
//        }
//    ],
//    "subclasses": [
//        {
//            "name": "Lore",
//            "url": "/api/subclasses/lore"
//        },
//        {
//            "name": "Land",
//            "url": "/api/subclasses/land"
//        }
//    ],
//    "url": "/api/spells/acid-arrow"
//}
