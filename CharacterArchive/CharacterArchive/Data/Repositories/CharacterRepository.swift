//
//  CharacterRepository.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 11/08/2022.
//

import Foundation

protocol CharacterRepository {
    func getCharacter(id: UUID) async -> Result<Character?, Error>
    func getCharacterList() async -> Result<[Character], Error>
    func createCharacter(character: Character) async -> Result<Bool, Error>
    func editCharacter(id: UUID, character: Character) async -> Result<Bool, Error>
    func deleteCharacter(id: UUID) async -> Result<Bool, Error>
}

class DefaultCharacterRepository: CharacterRepository {
    private let dataSource: CharacterDataSource
        
    init() {
        self.dataSource = DefaultCharacterDataSource()
    }
    
    init(dataSource: CharacterDataSource){
        self.dataSource = dataSource
    }
    
    func getCharacter(id: UUID) async -> Result<Character?, Error> {
        return await dataSource.getSingle(id: id)
    }
    
    func getCharacterList() async -> Result<[Character], Error> {
        return await dataSource.getMultiple()
    }
    
    func createCharacter(character: Character) async -> Result<Bool, Error> {
        return await dataSource.create(character: character)
    }
    
    func editCharacter(id: UUID, character: Character) async -> Result<Bool, Error> {
        return await dataSource.edit(id: id, character: character)
    }
    
    func deleteCharacter(id: UUID) async -> Result<Bool, Error> {
        return await dataSource.delete(id: id)
    }
}
