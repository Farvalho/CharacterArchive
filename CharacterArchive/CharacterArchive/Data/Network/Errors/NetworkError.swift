//
//  NetworkError.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 12/09/2022.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case badInput
    case decodingError
    case networkError
}
