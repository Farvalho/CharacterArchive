//
//  DeleteCharacterUseCase.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 11/08/2022.
//

import Foundation

protocol DeleteCharacterUseCase {
    func execute(id: UUID) async -> Result<Bool, Error>
}

class DefaultDeleteCharacterUseCase: DeleteCharacterUseCase {
    private let repo: CharacterRepository
    
    init() {
        self.repo = DefaultCharacterRepository()
    }

    init(repository: CharacterRepository) {
        self.repo = repository
    }

    func execute(id: UUID) async -> Result<Bool, Error> {
        return await repo.deleteCharacter(id: id)
    }
}
