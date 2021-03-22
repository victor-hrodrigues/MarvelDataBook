//
//  MarvelSeries.swift
//  MarvelDataBook
//
//  Created by Victor Rodrigues on 22/03/21.
//

import UIKit

struct MarvelSeries: Codable {
    let id: Int
    let title: String
    let thumbnail: String
}

extension MarvelSeries : Parseable {
    init?(json: [String: Any]){
        guard let id = json["id"] as? Int,
              let title = json["title"] as? String,
              let thumbnailJson = json["thumbnail"] as? [String: Any],
              let thumbnailPath = thumbnailJson["path"] as? String,
              let thumbnailExtension = thumbnailJson["extension"] as? String
        else {
            return nil
        }
        
        let thumbnail = [thumbnailPath, thumbnailExtension].joined(separator: ".")
        
        self.init(id: id, title: title, thumbnail: thumbnail)
    }
}
