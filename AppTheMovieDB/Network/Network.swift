//
//  Network.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 04.11.2022.
//

import Foundation
import Combine

enum FetchError:Error{
    case badURL
    case badRequest(Int)
    case badJSON
    case genericError(String)
    
    var errorMessage:String{
        switch self {
        case .badURL:
            return "Invalid URL encountered. Can't proceed with the request"
        case .badRequest(let responseCode):
            return "Invalid response code encountered from the server. Expected 200, received \(responseCode)"
        case .badJSON:
            return "Encountered an error while decoding incoming server response. The data couldn’t be read because it isn’t in the correct format."
        case .genericError(let message):
            return message
        }
    }
}


class CombineNetwork:NetworkCombineProtocol{
    
    struct EmptyParams:Encodable {}
    
    func createRequest<T:Decodable,P:Encodable>(
        urlString:String,
        params:P = EmptyParams(),
        typeOfData: T.Type) -> AnyPublisher<T,FetchError> {
        guard let url = URL(string: urlString) else {
            return Fail(error: FetchError.badURL).eraseToAnyPublisher() }
        var urlRequest = URLRequest(url: url)
        if !(params is EmptyParams){
            let httpBody = try? JSONEncoder().encode(params)
            urlRequest.httpBody = httpBody
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
            return URLSession.shared.dataTaskPublisher(for: urlRequest)
                .tryMap { (data, response) -> Data in
                    if let httpResponse = response as? HTTPURLResponse{
                        guard (200..<300) ~= httpResponse.statusCode else {
                            throw FetchError.badRequest(httpResponse.statusCode)
                        }
                    }
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .mapError { error -> FetchError in
                    if error is DecodingError{
                        return FetchError.badJSON
                    }
                    return FetchError.genericError(error.localizedDescription)
                }
                .eraseToAnyPublisher()
    }
    
}

class Network:NetworkProtocol{
    
    struct EmptyParams:Encodable {}
    
    func createRequest<T:Decodable,P:Encodable>(urlString:String, params:P = EmptyParams(), typeOfData: T.Type) async throws -> T {
        guard let url = URL(string: urlString) else { throw FetchError.badURL }
        var urlRequest = URLRequest(url: url)
        
        if !(params is EmptyParams){
            let httpBody = try? JSONEncoder().encode(params)
            urlRequest.httpBody = httpBody
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let (data,response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw FetchError.badRequest((response as? HTTPURLResponse)!.statusCode)
        }
        guard let dataFromJSON = try? JSONDecoder().decode(T.self, from: data) else { throw FetchError.badJSON}
        return dataFromJSON
    }
    
}
