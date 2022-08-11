//
//  GetCharacterUseCase.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 11/08/2022.
//

import Foundation

protocol GetCharacterUseCaseProtocol {
    func execute(_ id:UUID) async -> Result<CharacterModel.Response?, CharacterError>
}

//class GetCharacterUseCase: GetCharacterUseCaseProtocol {
//
//    private let repo: CharacterRepositoryProtocol
//
//    init(repo: CharacterRepositoryProtocol){
//        self.repo = repo
//    }
//
//    func execute(_ id: UUID) async -> Result<CharacterModel.Response?, CharacterError> {
//        return await repo.getCharacter(id)
//    }
//
//}
