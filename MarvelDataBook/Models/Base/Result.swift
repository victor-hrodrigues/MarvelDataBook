//
//  Result.swift
//  MarvelDataBook
//
//  Created by Victor Rodrigues on 22/03/21.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(ErrorType)
}
