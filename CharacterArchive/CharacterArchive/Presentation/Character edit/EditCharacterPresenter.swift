//
//  EditCharacterPresenter.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 17/08/2022.
//

import Foundation

class EditCharacterPresenter: ObservableObject {
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
    @Published var hasFatalError: Bool = false
    @Published var errorMessage: String = ""
    var characterID: UUID?
    private let getCharacter: GetCharacterUseCase
    private let editCharacter: EditCharacterUseCase
    
    init(getCharacter: GetCharacterUseCase, editCharacter: EditCharacterUseCase) {
        self.getCharacter = getCharacter
        self.editCharacter = editCharacter
    }

    func getCharacter() async {
        if characterID == nil {
            self.errorMessage = "Could not find character in server"
            self.hasFatalError = true
            return
        }
        
        let result = await getCharacter.execute(id: characterID!)
        switch result {
        case .success(let character):
            if character == nil {
                errorMessage = "Could not load character information"
                hasError = true
                
            } else {
                name = character!.name
                race = character!.race
                charClass = character!.charClass
                str = character!.str
                dex = character!.dex
                con = character!.con
                int = character!.int
                wis = character!.wis
                cha = character!.cha
                
                errorMessage = ""
                hasError = false
            }
            
        case .failure(_):
            errorMessage = "Could not load character information"
            hasError = true
        }
    }
    
    func editCharacter() async {
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
            
            let result = await editCharacter.execute(id: characterID!, character: character)
            switch result {
            case .success(_):
                hasSaved = true
                
            case .failure(_):
                errorMessage = "Could not save character information"
                hasError = true
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
