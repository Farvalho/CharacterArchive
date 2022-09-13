//
//  CharacterListPresenter.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 11/08/2022.
//

import Foundation

class CharacterListPresenter: ObservableObject {
    
    @Published var characters: [CharacterModel.Response] = []
    @Published var error = PresentationError()
    @Published var loadingState: LoadingState = .idle
    private let getCharacterList: GetCharacterListUseCase
    private let deleteCharacter: DeleteCharacterUseCase
    
    init(getCharacterList: GetCharacterListUseCase, deleteCharacter: DeleteCharacterUseCase) {
        self.getCharacterList = getCharacterList
        self.deleteCharacter = deleteCharacter
    }
    
    @MainActor
    func getList() async {
        loadingState = .loading
        let result = await getCharacterList.execute()
        loadingState = .idle
        
        switch result {
        case .success(let characters):
            if characters.count == 0 {
                self.error = PresentationError("There are no characters yet", style: .Inline)
                
            } else {
                self.characters = characters
                self.error.solve()
            }
            
        case .failure(_):
            self.error = PresentationError("Could not obtain character list", style: .Inline)
        }
    }
    
    @MainActor
    func deleteCharacter(id: UUID) async {
        loadingState = .loading
        let result = await deleteCharacter.execute(id: id)
        loadingState = .idle
        
        switch result {
        case .success(_):
            self.error.solve()
            
            await getList()
            
        case .failure(_):
            self.error = PresentationError("Could not delete character", style: .Alert)
        }
    }
}
