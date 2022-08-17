//
//  EditCharacterUseCase.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 11/08/2022.
//

import Foundation

protocol EditCharacterUseCase {
    func execute(id: UUID, character: CharacterModel.Request) async -> Result<Bool, CharacterError>
}

class DefaultEditCharacterUseCase: EditCharacterUseCase {
    private let repo: CharacterRepository
    
    init() {
        self.repo = DefaultCharacterRepository()
    }

    init(repository: CharacterRepository) {
        self.repo = repository
    }

    func execute(id: UUID, character: CharacterModel.Request) async -> Result<Bool, CharacterError> {
        return await repo.editCharacter(id: id, character: character)
    }
}
