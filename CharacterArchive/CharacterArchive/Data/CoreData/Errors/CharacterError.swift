//
//  CharacterError.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 11/08/2022.
//

import Foundation

enum CharacterError: Error {
    case GetSingle
    case GetMultiple
    case Create
    case Edit
    case Delete
}
