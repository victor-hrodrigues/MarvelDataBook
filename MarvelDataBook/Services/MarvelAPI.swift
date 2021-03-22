//
//  MarvelAPI.swift
//  MarvelDataBook
//
//  Created by Victor Rodrigues on 22/03/21.
//

import Foundation

enum MarvelAPI {
    static let baseUrl = "gateway.marvel.com:443/v1/public/"
    static let publicKey = "04f8cf58cf42aed9ff14ed4e91cfc2a0"
    static let privateKey = "6f506cf26cb4896d3695ef589c299d753da6da9f"
    
    case characters(offset: Int, name: String?, orderBy: String?)
    case comics(characterId: String)
    case series(charactersId: String)
    
    var method: String {
        switch self {
        case .characters, .comics, .series:
            return "GET"
        }
    }
    
    var path: String {
        switch self {
        case .characters:
            return "characters"
        case .comics(let characterId):
            return "characters/\(characterId)/comics"
        case .series(let characterId):
            return "characters/\(characterId)/series"
        }
    }
    
    var parameters: [String: Any]{
        var reqParameters = requiredParameters()
        switch self {
        case .characters(let offset, let name, let orderBy):
            if name != nil {
                reqParameters["name"] = name
            } else {
                reqParameters["offset"] = offset
                reqParameters["orderBy"] = orderBy
            }
            return reqParameters
        case .comics, .series:
            return reqParameters
        }
    }
    
    func asUrlRequest() -> URLRequest {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "gateway.marvel.com"
        components.path = "/v1/public/\(path)"
        components.queryItems = parameters.map{
            URLQueryItem(name: $0.key, value: $0.value is String ? $0.value as! String : String($0.value as! Int))
        }
        
        var urlRequest = URLRequest(url: components.url ?? URL(string: MarvelAPI.baseUrl)!)
        urlRequest.httpMethod = method
        
        return urlRequest
    }
    
    func requiredParameters() -> [String: Any]{
        let ts = NSUUID().uuidString
        let hash = (ts + MarvelAPI.privateKey + MarvelAPI.publicKey).md5()!
        var parameters = [String: Any]()
        parameters["apikey"] = MarvelAPI.publicKey
        parameters["hash"] = hash
        parameters["ts"] = ts
        parameters["limit"] = 20
        return parameters
    }
}
