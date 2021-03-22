//
//  MarvelCharacter.swift
//  MarvelDataBook
//
//  Created by Victor Rodrigues on 22/03/21.
//

import UIKit

struct MarvelCharacter: Codable {
    let id: Int
    let name: String
    let thumbnail: String
    let favorite: Bool
}

extension MarvelCharacter : Parseable {
    init?(json: [String: Any]){
        guard let id = json["id"] as? Int,
              let name = json["name"] as? String,
              let thumbnailJson = json["thumbnail"] as? [String: Any],
              let thumbnailPath = thumbnailJson["path"] as? String,
              let thumbnailExtension = thumbnailJson["extension"] as? String
        else {
            return nil
        }
        
        let thumbnail = [thumbnailPath, thumbnailExtension].joined(separator: ".")
        let favorite = false
        
        self.init(id: id, name: name, thumbnail: thumbnail, favorite: favorite)
    }
}
