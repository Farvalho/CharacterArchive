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
        let response = await dataSource.getGeneratedName(gender: gender, race: race)
        switch response {
        case .success(let entity):
            let result = GeneratedName(name: entity.contents.names[0], gender: entity.contents.variation, race: entity.contents.category)
            return .success(result)
            
        case .failure(let error):
            return .failure(error)
        }
    }

}
