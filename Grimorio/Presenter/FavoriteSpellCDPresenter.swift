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
    func newSpell(spell: FavoriteSpell) -> (Bool, Int) {
        
        let newSpell = FavoriteSpellCD(context: self.context)
        newSpell.name = spell.name
        newSpell.index = spell.index
        newSpell.school = spell.school
        do {
            try context.save()
        } catch {
            fatalError("Unable to save data in coredata model")
        }
        return (true, 0)

    }
    
    func fetchSpellss() -> [FavoriteSpellCD] {
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
    
    func deleteSkill(_ spell: FavoriteSpellCD) {
        context.delete(spell)
        do {
            try context.save()
        } catch {
            fatalError("Unable to fetch data from core data ")
        }
    }
}
