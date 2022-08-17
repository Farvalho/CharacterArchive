//
//  GetCharacterUseCase.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 11/08/2022.
//

import Foundation

protocol GetCharacterUseCase {
    func execute(id: UUID) async -> Result<CharacterModel.Response?, CharacterError>
}

class DefaultGetCharacterUseCase: GetCharacterUseCase {
    private let repo: CharacterRepository
    
    init() {
        self.repo = DefaultCharacterRepository()
    }

    init(repository: CharacterRepository) {
        self.repo = repository
    }

    func execute(id: UUID) async -> Result<CharacterModel.Response?, CharacterError> {
        return await repo.getCharacter(id: id)
    }
}
