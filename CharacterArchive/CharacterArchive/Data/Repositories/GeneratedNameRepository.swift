//
//  GeneratedNameRepository.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 12/09/2022.
//

import Foundation

protocol GeneratedNameRepository {
    func getGeneratedName(gender: NameGender, race: NameRace) async -> Result<GeneratedName, Error>
}

class DefaultGeneratedNameRepository: GeneratedNameRepository {
    private let dataSource: GeneratedNameDataSource
        
    init() {
        self.dataSource = DefaultGeneratedNameDataSource()
    }
    
    init(dataSource: GeneratedNameDataSource){
        self.dataSource = dataSource
    }
    
    func getGeneratedName(gender: NameGender, race: NameRace) async -> Result<GeneratedName, Error> {
        return await dataSource.getGeneratedName(gender: gender, race: race)
    }

}
