//
//  GeneratedName.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 12/09/2022.
//

import Foundation

enum NameGender: String {
    case male
    case female
    case any
}

enum NameRace: String {
    case human = "shakespearean"
    case dwarf
    case elf
}

struct GeneratedName {
    var name: String
    var gender: String
    var race: String
}
