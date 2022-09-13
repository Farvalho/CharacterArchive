//
//  GeneratedNameEntity.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 12/09/2022.
//

import Foundation

struct GeneratedNameEntity: Decodable {
    let success: GeneratedNameSuccess
    let contents: GeneratedNameContent
    let copyright: String?
}

struct GeneratedNameSuccess: Decodable {
    let total: Int?
    let start: Int?
    let limit: Int?
}

struct GeneratedNameContent: Decodable {
    let category: String?
    let variation: String?
    let names: [String]?
}
