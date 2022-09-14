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
    @Published var loadingState: LoadingState = .idle
    private let createCharacter: CreateCharacterUseCase
    private let getGeneratedName: GetGeneratedNameUseCase
    
    init(createCharacter: CreateCharacterUseCase, getGeneratedName: GetGeneratedNameUseCase) {
        self.createCharacter = createCharacter
        self.getGeneratedName = getGeneratedName
    }
    
    @MainActor
    func getGeneratedName() async {
        loadingState = .loading
        let result = await getGeneratedName.getGeneratedName(gender: .male, race: .dwarf)
        loadingState = .idle
        
        switch result {
        case .success(let generated):
            name = generated.name
            
        case .failure(_):
            self.error = PresentationError("Unable to get generated name", style: .Alert)
        }
    }
    
    @MainActor
    func createCharacter() async {
        if validate() {
            let character = Character(name: name,
                                      race: race,
                                      charClass: charClass,
                                      str: Int16(str)!,
                                      dex: Int16(dex)!,
                                      con: Int16(con)!,
                                      int: Int16(int)!,
                                      wis: Int16(wis)!,
                                      cha: Int16(cha)!)
            
            loadingState = .loading
            let result = await createCharacter.execute(character: character)
            loadingState = .idle
            
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
    
}
