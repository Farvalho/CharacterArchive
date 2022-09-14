//
//  CreateCharacterUseCase.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 11/08/2022.
//

import Foundation

protocol CreateCharacterUseCase {
    func execute(character: Character) async -> Result<Bool, Error>
}

class DefaultCreateCharacterUseCase: CreateCharacterUseCase {
    private let repo: CharacterRepository
    
    init() {
        self.repo = DefaultCharacterRepository()
    }

    init(repository: CharacterRepository) {
        self.repo = repository
    }

    func execute(character: Character) async -> Result<Bool, Error> {
        return await repo.createCharacter(character: character)
    }
}
