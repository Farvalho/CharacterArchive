//
//  GetGeneratedNameUseCase.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 12/09/2022.
//

import Foundation

protocol GetGeneratedNameUseCase {
    func getGeneratedName(gender: NameGender, race: NameRace) async -> Result<GeneratedName, Error>
}

class DefaultGetGeneratedNameUseCase: GetGeneratedNameUseCase {
    private let repo: GeneratedNameRepository
    
    init() {
        self.repo = DefaultGeneratedNameRepository()
    }

    init(repository: GeneratedNameRepository) {
        self.repo = repository
    }

    func getGeneratedName(gender: NameGender, race: NameRace) async -> Result<GeneratedName, Error> {
        return await repo.getGeneratedName(gender: gender, race: race)
    }
}
