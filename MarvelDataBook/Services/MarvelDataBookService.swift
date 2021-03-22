//
//  MarvelDataBookService.swift
//  MarvelDataBook
//
//  Created by Victor Rodrigues on 22/03/21.
//

import Foundation

class MarvelDataBookService {
    class func fetchMarvelCharacters(_ offset: Int, name: String? = nil, orderBy: String? = "name", completion: @escaping (Result<[MarvelCharacter]>) -> Void) {
        Request.shared.run(urlRequest: MarvelAPI.characters(offset: offset, name: name, orderBy: orderBy).asUrlRequest()) { data, error in
            completion(MarvelCharacter.parseResponse(data: data, error: error))
        }
    }
    
    class func fetchMarvelCharactersSeries(_ characterId: String, completion: @escaping (Result<[MarvelSeries]>) -> Void) {
        Request.shared.run(urlRequest: MarvelAPI.series(charactersId: characterId).asUrlRequest()) { data, error in
            completion(MarvelCharacter.parseResponse(data: data, error: error))
        }
    }
    
    class func fetchMarvelCharactersComics(_ characterId: String, completion: @escaping (Result<[MarvelComics]>) -> Void) {
        Request.shared.run(urlRequest: MarvelAPI.comics(characterId: characterId).asUrlRequest()) { data, error in
            completion(MarvelCharacter.parseResponse(data: data, error: error))
        }
    }
}
