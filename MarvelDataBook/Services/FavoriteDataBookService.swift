//
//  FavoriteDataBookService.swift
//  MarvelDataBook
//
//  Created by Victor Rodrigues on 22/03/21.
//

import UIKit
import CoreData

class FavoriteDataBookService {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let context = appDelegate.persistentContainer.viewContext
    
    class func fetchFavoriteCharacters() -> [MarvelCharacter] {
        var marvelCharacters: [MarvelCharacter] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MarvelCharacterEntity")
        
        do {
            let favoriteCharacters = try context.fetch(fetchRequest)
            for favChar in favoriteCharacters {
                let id = favChar.value(forKey: "id") as! Int
                let name = favChar.value(forKey: "name") as! String
                let thumbnail = favChar.value(forKey: "thumbnail") as! String
                let favorite = favChar.value(forKey: "favorite") as! Bool
                
                let marvelChar = MarvelCharacter(id: id, name: name, thumbnail: thumbnail, favorite: favorite)
                marvelCharacters.append(marvelChar)
            }
        } catch let error {
            print("CoreData - erro buscando MarvelCharacter - Erro:\(error)")
        }
        
        return marvelCharacters
    }
    
    class func saveFavoriteCharacters(marvelCharacter: MarvelCharacter) {
        let entity = NSEntityDescription.entity(forEntityName: "MarvelCharacterEntity", in: context)!
        let favoriteMarvelChar = NSManagedObject(entity: entity, insertInto: context)
        
        favoriteMarvelChar.setValue(marvelCharacter.id, forKeyPath: "id")
        favoriteMarvelChar.setValue(marvelCharacter.name, forKeyPath: "name")
        favoriteMarvelChar.setValue(marvelCharacter.thumbnail, forKeyPath: "thumbnail")
        favoriteMarvelChar.setValue(marvelCharacter.favorite, forKeyPath: "favorite")
        
        do {
            try context.save()
        } catch let error {
            print("CoreData - erro salvando MarvelCharacter - Erro:\(error)")
        }
    }
}
