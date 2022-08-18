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
    @Published var str = ""
    @Published var dex = ""
    @Published var con = ""
    @Published var int = ""
    @Published var wis = ""
    @Published var cha = ""
    @Published var error = PresentationError()
    @Published var hasSaved: Bool = false
    private let createCharacter: CreateCharacterUseCase
    
    init(createCharacter: CreateCharacterUseCase) {
        self.createCharacter = createCharacter
    }
    
    func createCharacter() async {
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
            
            let result = await createCharacter.execute(character: character)
            
            switch result {
            case .success(_):
                self.hasSaved = true
                
            case.failure(_):
                self.error = PresentationError("Unable to save the character", style: .Alert)
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
