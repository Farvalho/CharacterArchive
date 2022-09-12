//
//  NetworkConfigs.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 12/09/2022.
//

import Foundation

struct NetworkConfigs {
    let baseURL: String
    var headers: [String: String] = [:]
    var cachePolicy: URLRequest.CachePolicy

    init(baseURL: String) {
        self.baseURL = baseURL
        self.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    }
    
    init(baseURL: String, cachePolicy: URLRequest.CachePolicy) {
        self.baseURL = baseURL
        self.cachePolicy = cachePolicy
    }
}
