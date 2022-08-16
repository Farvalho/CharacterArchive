//
//  Character.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 11/08/2022.
//

import Foundation

enum CharacterModel {
    struct Request: Equatable {
        var name: String
        var race: String
        var str: Int16
        var dex: Int16
        var con: Int16
        var int: Int16
        var wis: Int16
        var cha: Int16
        
        init() {
            name = ""
            race = ""
            str = 10
            dex = 10
            con = 10
            int = 10
            wis = 10
            cha = 10
        }
        
        init(name: String, race: String, str: Int16, dex: Int16, con: Int16, int: Int16, wis: Int16, cha: Int16) {
            self.name = name
            self.race = race
            self.str = str
            self.dex = dex
            self.con = con
            self.int = int
            self.wis = wis
            self.cha = cha
        }
        
    }
    
    struct Response: Identifiable, Equatable, Hashable {
        let id: UUID
        var name: String
        
        init() {
            id = UUID()
            name = ""
        }
        
        init(id: UUID, name: String) {
            self.id = id
            self.name = name
        }
    }
}
