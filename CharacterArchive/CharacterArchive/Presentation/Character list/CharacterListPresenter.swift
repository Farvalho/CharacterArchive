//
//  CharacterListPresenter.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 11/08/2022.
//

import Foundation

class CharacterListPresenter: ObservableObject {
    
    @Published var characters: [CharacterModel.Response] = []
    @Published var hasError: Bool = false
    @Published var hasInlineError: Bool = false
    @Published var errorMessage: String = ""
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
                self.errorMessage = "There are no characters yet"
                self.hasInlineError = true
                
            } else {
                self.characters = characters
                self.errorMessage = ""
                self.hasInlineError = false
            }
            
        case .failure(_):
            self.errorMessage = "Could not obtain character list"
            self.hasInlineError = true
        }
    }
    
    func deleteCharacter(id: UUID) async {
        let result = await deleteCharacter.execute(id: id)
        
        switch result {
        case .success(_):
            self.errorMessage = ""
            self.hasError = false
            
            await getList()
            
        case .failure(_):
            self.errorMessage = "Could not delete character"
            self.hasError = true
        }
    }
}
