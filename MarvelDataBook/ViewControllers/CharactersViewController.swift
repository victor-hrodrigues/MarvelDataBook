//
//  CharactersViewController.swift
//  MarvelDataBook
//
//  Created by Victor Rodrigues on 22/03/21.
//

import UIKit

class CharactersViewController: UICollectionViewController {
    @IBOutlet weak var characterCollectionView: UICollectionView!
    
    var offset = 0
    var marvelCharacters = [MarvelCharacter]()
    var isFavoriteScreen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabTitle = parent?.restorationIdentifier
        self.title = tabTitle
        
        isFavoriteScreen = tabTitle == "Favorites" ? true : false
        
        registerCollectionView()
        fetchMarvelCharacters()
    }
    
    func registerCollectionView(){
        characterCollectionView.delegate = self
        characterCollectionView.dataSource = self
    }
    
    func fetchMarvelCharacters(name: String? = nil) {
        if (!isFavoriteScreen){
            MarvelDataBookService.fetchMarvelCharacters(offset, name: name) { result in
                switch result {
                case .success(let marvelCharacter):
                    self.marvelCharacters.append(contentsOf: marvelCharacter)
                    DispatchQueue.main.async {
                        self.characterCollectionView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                    return
                //ErrorHandler.handle(error: error, inViewController: self)
                }
            }
        } else {
            //FavoriteDataBookService.fetchMarvelCharacters() {
            
        }
    }
}

extension CharactersViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return marvelCharacters.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCard", for: indexPath) as! CharacterViewCell
        let marvelCharacter = marvelCharacters[indexPath.row]
        cell.character = marvelCharacter
        return cell
    }
}
