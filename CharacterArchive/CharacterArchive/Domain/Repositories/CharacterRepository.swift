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
    func createCharacter(characterRequest: CharacterModel.Request) async -> Result<Bool, CharacterError>
    func editCharacter(id: UUID, data: CharacterModel.Request) async -> Result<Bool, CharacterError>
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
    
    func createCharacter(characterRequest: CharacterModel.Request) async -> Result<Bool, CharacterError> {
        return await dataSource.create(characterRequest: characterRequest)
    }
    
    func editCharacter(id: UUID, data: CharacterModel.Request) async -> Result<Bool, CharacterError> {
        return await dataSource.edit(id: id, data: data)
    }
    
    func deleteCharacter(id: UUID) async -> Result<Bool, CharacterError> {
        return await dataSource.delete(id: id)
    }
}
