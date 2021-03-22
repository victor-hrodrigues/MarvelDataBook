//
//  CharacterViewCell.swift
//  MarvelDataBook
//
//  Created by Victor Rodrigues on 22/03/21.
//

import UIKit

class CharacterViewCell: UICollectionViewCell {
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var characterImageView: UIImageView!
    
    var character: MarvelCharacter? {
        didSet {
            guard let character = character else { return }
            
            characterNameLabel.text = character.name
            loadImage(thumbnail: character.thumbnail)
        }
    }
    
    func loadImage(thumbnail: String) {
        guard let url = URL(string: thumbnail) else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let imageData = try? Data(contentsOf: url)
            
            DispatchQueue.main.async {
                let image = UIImage(data: imageData!)
                
                self.characterImageView.frame = CGRect(x: 15, y: 8, width: (self.frame.size.width - 30), height: (self.frame.size.height - 20))
                self.characterImageView.contentMode = UIView.ContentMode.scaleAspectFit
                self.characterImageView.image = image
            }
        }
    }
}

extension CharacterViewCell {
    override func prepareForReuse() {
        self.contentView.layer.contents = nil
        self.characterImageView.image = nil
        self.characterNameLabel.text = nil
        
        super.prepareForReuse()
    }
}
