//
//  Request.swift
//  MarvelDataBook
//
//  Created by Victor Rodrigues on 22/03/21.
//

import Foundation

class Request {
    static let shared = Request()
    private let session = URLSession(configuration: .default)
    typealias Response = ((Data?, Error?) -> ())
    
    func run(urlRequest: URLRequest, completion: @escaping Response) {
        session.dataTask(with: urlRequest) { data, _, error in
            completion(data, error)
        }.resume()
    }
}
