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
    @Published var str = ""
    @Published var dex = ""
    @Published var con = ""
    @Published var int = ""
    @Published var wis = ""
    @Published var cha = ""
    @Published var error = PresentationError()
    @Published var loadingState: LoadingState = .idle
    @Published var hasSaved: Bool = false
    var characterID: UUID?
    private let getCharacter: GetCharacterUseCase
    private let editCharacter: EditCharacterUseCase
    
    init(getCharacter: GetCharacterUseCase, editCharacter: EditCharacterUseCase) {
        self.getCharacter = getCharacter
        self.editCharacter = editCharacter
    }
    
    @MainActor
    func getCharacter() async {
        if characterID == nil {
            error = PresentationError("Could not find character in server", style: .FatalAlert)
            return
        }
        
        loadingState = .loading
        sleep(3)
        let result = await getCharacter.execute(id: characterID!)
        loadingState = .idle
        
        switch result {
        case .success(let character):
            if character == nil {
                error = PresentationError("Could not load character information", style: .FatalAlert)
                
            } else {
                name = character!.name
                race = character!.race
                charClass = character!.charClass
                str = String(character!.str)
                dex = String(character!.dex)
                con = String(character!.con)
                int = String(character!.int)
                wis = String(character!.wis)
                cha = String(character!.cha)
                
                error.solve()
            }
            
        case .failure(_):
            error = PresentationError("Could not load character information", style: .FatalAlert)
        }
    }
    
    func editCharacter() async {
        if validate() {
            let character = CharacterModel.Request(name: name,
                                                   race: race,
                                                   charClass: charClass,
                                                   str: Int16(str)!,
                                                   dex: Int16(dex)!,
                                                   con: Int16(con)!,
                                                   int: Int16(int)!,
                                                   wis: Int16(wis)!,
                                                   cha: Int16(cha)!)
            
            loadingState = .loading
            let result = await editCharacter.execute(id: characterID!, character: character)
            loadingState = .idle
            
            switch result {
            case .success(_):
                hasSaved = true
                
            case .failure(_):
                error = PresentationError("Could not save character information", style: .Alert)
            }
        }
    }
    
    func validate() -> Bool {
        if !validateEmptyFields() {
            return false
        }
        
        if !validateValue(str) {
            return false
        }
        
        if !validateValue(dex) {
            return false
        }
        
        if !validateValue(con) {
            return false
        }
        
        if !validateValue(int) {
            return false
        }
        
        if !validateValue(wis) {
            return false
        }
        
        if !validateValue(cha) {
            return false
        }
            
        self.error.solve()
        return true
    }
    
    func validateEmptyFields() -> Bool {
        if self.name.count == 0 ||
            self.race.count == 0 ||
            self.charClass.count == 0 ||
            self.str.count == 0 ||
            self.dex.count == 0 ||
            self.con.count == 0 ||
            self.int.count == 0 ||
            self.wis.count == 0 ||
            self.cha.count == 0 {
            
            error = PresentationError("Some information seems to be missing", style: .Alert)
            return false
        }
        
        return true
    }
    
    func validateValue(_ valueString: String) -> Bool {
        if let value = Int(valueString) {
            if value > 0 && value <= 20 {
                return true
            }
        }
        
        error = PresentationError("Some ability values seem to be wrong", style: .Alert)
        return false
    }
    
    func sanitizeNumericText(_ newValue: String) -> String {
        let filtered = newValue.filter { "0123456789".contains($0) }
        return filtered
    }
    
}
