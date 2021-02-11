//
//  FavoriteSpellCDPresenter.swift
//  Grimorio
//
//  Created by Rodrigo Silva Ribeiro on 10/02/21.
//  Copyright © 2021 Rodrigo Silva Ribeiro. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FavoriteSpellCDPresenter {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var spells: [FavoriteSpellCD] = []
    func newSpell(spell: FavoriteSpell) -> FavoriteSpellCD {
        
        let newSpell = FavoriteSpellCD(context: self.context)
        newSpell.name = spell.name
        newSpell.index = spell.index
        newSpell.school = spell.school
        newSpell.level = Int64(spell.level)
        do {
            try context.save()
        } catch {
            fatalError("Unable to save data in coredata model")
        }
        return newSpell

    }
    
    func fetchSpells() -> [FavoriteSpellCD] {
        let fetch = FavoriteSpellCD.fetchRequest() as NSFetchRequest<FavoriteSpellCD>
        let sortName = NSSortDescriptor(key: "name", ascending: true)
        fetch.sortDescriptors = [sortName]
        do {
            self.spells  = try context.fetch(fetch)
        } catch {
            fatalError("Unable to fetch data from core data ")
        }
        return self.spells
    }
    
    func getSpellByName(_ name: String) -> FavoriteSpellCD? {
        let fetch = FavoriteSpellCD.fetchRequest() as NSFetchRequest<FavoriteSpellCD>
        let pred = NSPredicate(format: "name == %@", name)
        fetch.predicate = pred
        do {
            let spells  = try context.fetch(fetch)
            if spells.count != 1 {
                if spells.count < 1 {
                    return nil
            } else {
                    fatalError("There is more than one spell with this name.")
                }
            } else {
                return spells.first
            }
        } catch {
            fatalError("Unable to fetch data from core data ")
        }
    }
    
    func deleteSkill(_ spell: FavoriteSpellCD) {
        context.delete(spell)
        do {
            try context.save()
        } catch {
            fatalError("Unable to fetch data from core data ")
        }
    }
    
    func deleteFromFM(_ spellName: String) {
        do {
             let fileURL = try FileManager.default
                 .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                 .appendingPathComponent("\(spellName).json")

             try FileManager.default.removeItem(at: fileURL)
         } catch {
             print(error)
         }
    }
    
    func saveOnFM(_ spellFM: Spell) {
        do {
            let fileURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("\(spellFM.name).json")

            try JSONEncoder().encode(spellFM)
            .write(to: fileURL)
        } catch {
            print(error)
        }
    }
}
