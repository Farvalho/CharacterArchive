//
//  GeneratedNameDataSource.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 12/09/2022.
//

import Foundation

protocol GeneratedNameDataSource {
    func getGeneratedName(gender: NameGender, race: NameRace) async -> Result<GeneratedNameEntity, Error>
}

class DefaultGeneratedNameDataSource: GeneratedNameDataSource {
    
    let networkEngine = NetworkEngine(networkConfig: NetworkConfigs(baseURL: "https://api.fungenerators.com/name"))
    
    func getGeneratedName(gender: NameGender, race: NameRace) async -> Result<GeneratedNameEntity, Error> {
        let request = NetworkRequest(
            method: .get,
            endpoint: "generate",
            parameters: .url(["variation" : gender.rawValue, "category" : race.rawValue,  "limit" : "1"])
        )
        
        var finalResult: Result<GeneratedNameEntity, Error>?
        
        try! networkEngine.execute(request: request) { (result: Result<GeneratedNameEntity, Error>) in
            finalResult = result
        }
        
        switch finalResult {
        case .success(let response):
            return .success(response)
            
        case .failure(let error):
            return .failure(error)
            
        default:
            return .failure(NetworkError.networkError)
        }
    }
    
}
