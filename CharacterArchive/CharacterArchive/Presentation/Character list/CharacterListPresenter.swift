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
    private let getCharacterList: GetCharacterListUseCase
    private let deleteCharacter: DeleteCharacterUseCase
    
    init(getCharacterList: GetCharacterListUseCase, deleteCharacter: DeleteCharacterUseCase) {
        self.getCharacterList = getCharacterList
        self.deleteCharacter = deleteCharacter
    }
    
    func getList() async {
        let result = await getCharacterList.execute()
        
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
    
    func deleteCharacter(id: UUID) async {
        let result = await deleteCharacter.execute(id: id)
        
        switch result {
        case .success(_):
            self.error.solve()
            
            await getList()
            
        case .failure(_):
            self.error = PresentationError("Could not delete character", style: .Alert)
        }
    }
}
