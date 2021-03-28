//
//  MarvelCharacter.swift
//  MarvelDataBook
//
//  Created by Victor Rodrigues on 22/03/21.
//

import UIKit

class MarvelCharacter: Parseable, Codable {
    let id: Int
    let name: String
    let thumbnail: String
    var favorite: Bool

    init() {
        self.id = 0
        self.name = "default name"
        self.thumbnail = "default thumbnail"
        self.favorite = false
    }
    
    init(id: Int, name: String, thumbnail: String, favorite: Bool) {
        self.id = id
        self.name = name
        self.thumbnail = thumbnail
        self.favorite = favorite
    }
    
    required convenience init(json: [String: Any]) {
        guard let id = json["id"] as? Int,
              let name = json["name"] as? String,
              let thumbnailJson = json["thumbnail"] as? [String: Any],
              let thumbnailPath = thumbnailJson["path"] as? String,
              let thumbnailExtension = thumbnailJson["extension"] as? String
        else {
            self.init()
            return
        }

        let thumbnail = [thumbnailPath, thumbnailExtension].joined(separator: ".")
        let favorite = false

        self.init(id: id, name: name, thumbnail: thumbnail, favorite: favorite)
    }
}
