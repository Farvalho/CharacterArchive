//
//  CharacterDataSource.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 12/08/2022.
//

import Foundation

protocol CharacterDataSource {
    func getSingle(id: UUID) async -> Result<CharacterModel.Response?, CharacterError>
    func getMultiple() async -> Result<[CharacterModel.Response], CharacterError>
    func create(characterRequest: CharacterModel.Request) async -> Result<Bool, CharacterError>
    func edit(id: UUID, data: CharacterModel.Request) async -> Result<Bool, CharacterError>
    func delete(id: UUID) async -> Result<Bool, CharacterError>
}

class DefaultCharacterDataSource: CharacterDataSource {
    
    let wrapper: CoreDataWrapper
    
    init() {
        self.wrapper = PersistenceController()
    }
    
    init(wrapper: CoreDataWrapper){
        self.wrapper = wrapper
    }
    
    private func mapToCharacter(characterEntity: CharacterEntity) -> CharacterModel.Response {
        return CharacterModel.Response(id: characterEntity.id!, name: characterEntity.name!)
    }
    
    private func getMultipleCharacters() throws -> [CharacterEntity] {
        let result: [CharacterEntity] = try wrapper.getData(entityName: "Character") as! [CharacterEntity]
        return result
    }
    
    private func getSingleCharacter(id: UUID) throws -> CharacterEntity {
        let result: [CharacterEntity] = try wrapper.getData(entityName: "Character", predicate: NSPredicate(format: "id = %@", id.uuidString)) as! [CharacterEntity]
        return result[0]
    }
    
    func getSingle(id: UUID) async -> Result<CharacterModel.Response?, CharacterError> {
        do {
            let data = try getSingleCharacter(id: id)
            return .success(CharacterModel.Response(id: data.id!, name: data.name!))
            
        } catch {
            return .failure(.GetSingle)
        }
    }
    
    func getMultiple() async -> Result<[CharacterModel.Response], CharacterError> {
        do {
            let data = try getMultipleCharacters()
            
            return .success(data.map({ CharacterEntity in
                mapToCharacter(characterEntity: CharacterEntity)
            }))
            
        } catch {
            return .failure(.GetMultiple)
        }
    }
    
    func create(characterRequest: CharacterModel.Request) async -> Result<Bool, CharacterError> {
        do {
            let newContact = CharacterEntity(context: wrapper.getContext())
            newContact.id = UUID();
            newContact.name = characterRequest.name;
            try wrapper.saveEntity(entity: newContact)
            return .success(true)
            
        } catch {
            return .failure(.Create)
        }
    }
    
    func edit(id: UUID, data: CharacterModel.Request) async -> Result<Bool, CharacterError> {
        do {
            let oldData = try getSingleCharacter(id: id)
            oldData.name = data.name
            try wrapper.saveEntity(entity: oldData)
            return .success(true)
            
        } catch {
            return .failure(.Edit)
        }
    }
    
    func delete(id: UUID) async -> Result<Bool, CharacterError> {
        do{
            let data = try getSingleCharacter(id: id)
            try wrapper.deleteEntity(entity: data)
            return .success(true)
            
        } catch {
            return .failure(.Delete)
        }
    }
}
