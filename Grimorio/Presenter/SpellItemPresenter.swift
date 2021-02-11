//
//  SpellItemPresenter.swift
//  Grimorio
//
//  Created by Rodrigo Silva Ribeiro on 09/02/21.
//  Copyright © 2021 Rodrigo Silva Ribeiro. All rights reserved.
//

import Foundation
import UIKit
class SpellItemPresenter {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var spellTitles: [SpellList] = []
    func getSpells(finished:@escaping ([SpellList]) -> Void) {
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
                            finished(self.spellTitles)
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
    func getSpell(spell: SpellList, finished:@escaping (Spell) -> Void) {
        ServiceLayer.request(router: .getSpell(spellIndex: spell.index)) { (result) in
            switch result {
            case .success(let data):
                 guard let data = data else { return }
                 let spellDetailed = try? JSONDecoder().decode(Spell.self, from: data)
                 guard let spelldetails = spellDetailed else {
                     fatalError()
                 }
                 DispatchQueue.main.async {
                     finished(spelldetails)
                 }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func saveFromTableView(spell: SpellList) {
        var detailedSpell = Spell().self
        getSpell(spell: spell, finished: { response in
            detailedSpell = response
        })
        let favSpell = FavoriteSpell(name: detailedSpell.name, level: detailedSpell.level!, school: (detailedSpell.school?.name!)!, index: detailedSpell.index)
        do {
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("\(favSpell.name).json")

            try JSONEncoder().encode(favSpell)
            .write(to: fileURL)
        } catch {
            print(error)
        }
    }
}
