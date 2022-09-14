//
//  CharacterDataSource.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 12/08/2022.
//

import Foundation

protocol CharacterDataSource {
    func getSingle(id: UUID) async -> Result<Character?, Error>
    func getMultiple() async -> Result<[Character], Error>
    func create(character: Character) async -> Result<Bool, Error>
    func edit(id: UUID, character: Character) async -> Result<Bool, Error>
    func delete(id: UUID) async -> Result<Bool, Error>
}

class DefaultCharacterDataSource: CharacterDataSource {
    
    let wrapper: CoreDataWrapper
    
    init() {
        self.wrapper = PersistenceController()
    }
    
    init(wrapper: CoreDataWrapper){
        self.wrapper = wrapper
    }
    
    private func mapToCharacter(characterEntity: CharacterEntity) -> Character {
        return Character(id: characterEntity.id!, name: characterEntity.name ?? "", race: characterEntity.race ?? "", charClass: characterEntity.charClass ?? "", str: characterEntity.str, dex: characterEntity.dex, con: characterEntity.con, int: characterEntity.int, wis: characterEntity.wis, cha: characterEntity.cha)
    }
    
    private func getMultipleCharacters() throws -> [CharacterEntity] {
        let result: [CharacterEntity] = try wrapper.getData(entityName: "Character") as! [CharacterEntity]
        return result
    }
    
    private func getSingleCharacter(id: UUID) throws -> CharacterEntity {
        let result: [CharacterEntity] = try wrapper.getData(entityName: "Character", predicate: NSPredicate(format: "id = %@", id.uuidString)) as! [CharacterEntity]
        return result[0]
    }
    
    func getSingle(id: UUID) async -> Result<Character?, Error> {
        do {
            let data = try getSingleCharacter(id: id)
            return .success(Character(id: data.id!, name: data.name ?? "", race: data.race ?? "", charClass: data.charClass ?? "", str: data.str, dex: data.dex, con: data.con, int: data.int, wis: data.wis, cha: data.cha))
            
        } catch {
            return .failure(error)
        }
    }
    
    func getMultiple() async -> Result<[Character], Error> {
        do {
            let data = try getMultipleCharacters()
            
            return .success(data.map({ CharacterEntity in
                mapToCharacter(characterEntity: CharacterEntity)
            }))
            
        } catch {
            return .failure(error)
        }
    }
    
    func create(character: Character) async -> Result<Bool, Error> {
        do {
            let newCharacter = CharacterEntity(context: wrapper.getContext())
            newCharacter.id = UUID()
            newCharacter.name = character.name
            newCharacter.race = character.race
            newCharacter.charClass = character.charClass
            newCharacter.str = character.str
            newCharacter.dex = character.dex
            newCharacter.con = character.con
            newCharacter.int = character.int
            newCharacter.wis = character.wis
            newCharacter.cha = character.cha
            try wrapper.saveEntity(entity: newCharacter)
            return .success(true)
            
        } catch {
            return .failure(error)
        }
    }
    
    func edit(id: UUID, character: Character) async -> Result<Bool, Error> {
        do {
            let oldData = try getSingleCharacter(id: id)
            oldData.name = character.name
            oldData.race = character.race
            oldData.charClass = character.charClass
            oldData.str = character.str
            oldData.dex = character.dex
            oldData.con = character.con
            oldData.int = character.int
            oldData.wis = character.wis
            oldData.cha = character.cha
            try wrapper.saveEntity(entity: oldData)
            return .success(true)
            
        } catch {
            return .failure(error)
        }
    }
    
    func delete(id: UUID) async -> Result<Bool, Error> {
        do {
            let data = try getSingleCharacter(id: id)
            try wrapper.deleteEntity(entity: data)
            return .success(true)
            
        } catch {
            return .failure(error)
        }
    }
}
