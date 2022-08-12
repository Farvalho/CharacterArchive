//
//  CharacterListPresenter.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 11/08/2022.
//

import Foundation

class CharacterListPresenter: ObservableObject {
    
    @Published var characters: [CharacterModel.Response] = []
    private let getCharacterList: GetCharacterListUseCase
    
    init(getCharacterList: GetCharacterListUseCase) {
        self.getCharacterList = getCharacterList
    }
    
}
