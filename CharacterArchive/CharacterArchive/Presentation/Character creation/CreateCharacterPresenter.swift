//
//  CreateCharacterPresenter.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 16/08/2022.
//

import Foundation

class CreateCharacterPresenter: ObservableObject {
    @Published var name = ""
    @Published var race = ""
    @Published var charClass = ""
    @Published var str: Int16 = 10
    @Published var dex: Int16 = 10
    @Published var con: Int16 = 10
    @Published var int: Int16 = 10
    @Published var wis: Int16 = 10
    @Published var cha: Int16 = 10
    @Published var hasSaved: Bool = false
    @Published var hasError: Bool = false
    @Published var errorMessage: String = ""
    private let createCharacter: CreateCharacterUseCase
    
    init(createCharacter: CreateCharacterUseCase) {
        self.createCharacter = createCharacter
    }
    
    func createCharacter() async {
        if validate() {
            let character = CharacterModel.Request(name: name,
                                                   race: race,
                                                   charClass: charClass,
                                                   str: str,
                                                   dex: dex,
                                                   con: con,
                                                   int: int,
                                                   wis: wis,
                                                   cha: cha)
            
            let result = await createCharacter.execute(character: character)
            
            switch result {
            case .success(_):
                self.hasSaved = true
                
            case.failure(_):
                self.errorMessage = "Unable to save the character"
                self.hasError = true
            }
        }
    }
    
    func validate() -> Bool {
        if self.name.count == 0 || self.race.count == 0 || self.charClass.count == 0 {
            self.errorMessage = "Some information seems to be missing"
            self.hasError = true
            
        } else {
            self.errorMessage = ""
            self.hasError = false
        }
        
        return !self.hasError
    }
}
