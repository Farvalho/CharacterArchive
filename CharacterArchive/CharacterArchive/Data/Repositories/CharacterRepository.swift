//
//  CharacterRepository.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 11/08/2022.
//

import Foundation

protocol CharacterRepository {
    func getCharacter(id: UUID) async -> Result<CharacterModel.Response?, CharacterError>
    func getCharacterList() async -> Result<[CharacterModel.Response], CharacterError>
    func createCharacter(character: CharacterModel.Request) async -> Result<Bool, CharacterError>
    func editCharacter(id: UUID, character: CharacterModel.Request) async -> Result<Bool, CharacterError>
    func deleteCharacter(id: UUID) async -> Result<Bool, CharacterError>
}

class DefaultCharacterRepository: CharacterRepository {
    private let dataSource: CharacterDataSource
        
    init() {
        self.dataSource = DefaultCharacterDataSource()
    }
    
    init(dataSource: CharacterDataSource){
        self.dataSource = dataSource
    }
    
    func getCharacter(id: UUID) async -> Result<CharacterModel.Response?, CharacterError> {
        return await dataSource.getSingle(id: id)
    }
    
    func getCharacterList() async -> Result<[CharacterModel.Response], CharacterError> {
        return await dataSource.getMultiple()
    }
    
    func createCharacter(character: CharacterModel.Request) async -> Result<Bool, CharacterError> {
        return await dataSource.create(character: character)
    }
    
    func editCharacter(id: UUID, character: CharacterModel.Request) async -> Result<Bool, CharacterError> {
        return await dataSource.edit(id: id, character: character)
    }
    
    func deleteCharacter(id: UUID) async -> Result<Bool, CharacterError> {
        return await dataSource.delete(id: id)
    }
}
