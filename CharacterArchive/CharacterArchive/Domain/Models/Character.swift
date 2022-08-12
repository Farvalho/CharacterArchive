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
        
        init() {
            name = ""
        }
        
        init(name: String) {
            self.name = name
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
