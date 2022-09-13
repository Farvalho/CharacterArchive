//
//  GeneratedNameDataSource.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 12/09/2022.
//

import Foundation

protocol GeneratedNameDataSource {
    func getGeneratedName(gender: NameGender, race: NameRace) async -> Result<GeneratedName, Error>
}

class DefaultGeneratedNameDataSource: GeneratedNameDataSource {
    
    let networkEngine = NetworkEngine(networkConfig: NetworkConfigs(baseURL: "https://api.fungenerators.com/name"))
    
    func getGeneratedName(gender: NameGender, race: NameRace) async -> Result<GeneratedName, Error> {
        let request = NetworkRequest(
            method: .get,
            endpoint: "generate",
            parameters: .url(["variation" : gender.rawValue, "category" : race.rawValue,  "limit" : "1"])
        )
        
        let result = try! await networkEngine.execute(request: request) as Result<GeneratedNameEntity, Error>
        switch result {
        case .success(let response):
            if response.contents.names == nil ||
                response.contents.variation == nil ||
                response.contents.category == nil {
                
                return .failure(NetworkError.badOutput)
            }
            
            let result = GeneratedName(name: response.contents.names![0], gender: response.contents.variation!, race: response.contents.category!)
            return .success(result)
            
        case .failure(let error):
            return .failure(error)
        }
    }
}
