//
//  GetCharacterListUseCase.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 11/08/2022.
//

import Foundation

protocol GetCharacterListUseCase {
    func execute() async -> Result<[CharacterModel.Response], CharacterError>
}

class DefaultGetCharacterListUseCase: GetCharacterListUseCase {
    private let repo: CharacterRepository
    
    init() {
        self.repo = DefaultCharacterRepository()
    }

    init(repository: CharacterRepository) {
        self.repo = repository
    }

    func execute() async -> Result<[CharacterModel.Response], CharacterError> {
        return await repo.getCharacterList()
    }
}
