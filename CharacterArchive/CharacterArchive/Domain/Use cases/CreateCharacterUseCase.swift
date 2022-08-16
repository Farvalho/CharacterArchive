//
//  CreateCharacterUseCase.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 11/08/2022.
//

import Foundation

protocol CreateCharacterUseCase {
    func execute(characterRequest: CharacterModel.Request) async -> Result<Bool, CharacterError>
}

class DefaultCreateCharacterUseCase: CreateCharacterUseCase {
    private let repo: CharacterRepository
    
    init() {
        self.repo = DefaultCharacterRepository()
    }

    init(repository: CharacterRepository) {
        self.repo = repository
    }

    func execute(characterRequest: CharacterModel.Request) async -> Result<Bool, CharacterError> {
        return await repo.createCharacter(characterRequest: characterRequest)
    }
}
