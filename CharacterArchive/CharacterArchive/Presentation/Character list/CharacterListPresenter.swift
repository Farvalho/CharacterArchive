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
    @Published var errorMessage: String = ""
    private let getCharacterList: GetCharacterListUseCase
    
    init(getCharacterList: GetCharacterListUseCase) {
        self.getCharacterList = getCharacterList
    }
    
    func getList() async {
        let result = await getCharacterList.execute()
        
        switch result {
        case .success(let characters):
            if characters.count == 0 {
                self.errorMessage = "There are no characters yet"
                self.hasError = true
                
            } else {
                self.characters = characters
                self.errorMessage = ""
                self.hasError = false
            }
            
        case .failure(_):
            self.errorMessage = "Could not obtain character list"
            self.hasError = true
        }
    }
}
