//
//  NetworkEngine.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 12/09/2022.
//

import Foundation

final class NetworkEngine {
    fileprivate let networkConfig: NetworkConfigs
    fileprivate let session: URLSession
    fileprivate let group: DispatchGroup

    required init(networkConfig: NetworkConfigs) {
        self.networkConfig = networkConfig
        self.session = URLSession(configuration: URLSessionConfiguration.default)
        self.group = DispatchGroup()
    }

    func execute<T: Decodable>(request: NetworkRequest, completion: @escaping (Result<T, Error>) -> ()) throws {
        // Execute request process in an asynchronous background thread
        DispatchQueue.global(qos: .background).async {
            let request = try! self.prepareURLRequest(for: request)
            var result: Result<T, Error>?
            
            self.group.enter()
            self.session.dataTask(with: request) { [unowned self] (data, response, error) in
                // Guard any output error, else return it
                guard error == nil else {
                    result = .failure(error!)
                    
                    self.group.leave()
                    return
                }
                
                // Guard (by unwrapping) the existence of output data, catch service error
                guard let data = data else {
                    result = .failure(NetworkError.networkError)
                    
                    self.group.leave()
                    return
                }
                
                // Try to decode the output, catch decoding error
                do {
                    let decoder = JSONDecoder()
                    let object = try decoder.decode(T.self, from: data)
                    result = .success(object)
                    
                    self.group.leave()
                    return
                    
                } catch let jsonError {
                    print(jsonError)
                    result = .failure(NetworkError.decodingError)
                    
                    self.group.leave()
                    return
                
                }
            }.resume()
            
            // Notify the main thread that all tasks in the group have left
            self.group.notify(queue: .main) {
                completion(result!)
            }
        }
    }
    
    private func prepareURLRequest(for request: NetworkRequest) throws -> URLRequest {
        // Check URL validity
        let urlString = "\(networkConfig.baseURL)/\(request.endpoint)"
        guard let url = URL(string:  urlString) else {
            throw NetworkError.badUrl
        }
        
        var urlRequest = URLRequest(url: url)
        
        // Prepare parameters
        switch request.parameters {
        
            // in request body
        case .body(let params)?:
            if let params = params as? [String: String] {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: .init(rawValue: 0))

            } else {
                throw NetworkError.badInput
            }

            // as URL query parameters
        case .url(let params)?:
            if let params = params {
                let queryParams = params.map({ (element) -> URLQueryItem in
                    return URLQueryItem(name: element.key, value: element.value)
                })

                guard var components = URLComponents(string: urlString) else {
                    throw NetworkError.badInput
                }

                components.queryItems = queryParams
                urlRequest.url = components.url

            } else {
                throw NetworkError.badInput
            }
            
        case .none:
            break
        }
        
        // Set defined cache policy
        urlRequest.cachePolicy = networkConfig.cachePolicy
        
        // Add headers to request
        networkConfig.headers.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.key) }
        request.headers?.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        // Set defined HTTP method
        urlRequest.httpMethod = request.method.rawValue

        return urlRequest
    }
}
