//
//  NetworkRequest.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 12/09/2022.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum Parameters {
    case body(_ : [String: Any]?)
    case url(_ : [String: String]?)
}

struct NetworkRequest {
    var method: HTTPMethod
    var endpoint: String
    var parameters: Parameters?
    var headers: [String: String]?
}
