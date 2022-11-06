//
//  Network.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 04.11.2022.
//

import Foundation

enum FetchError:Error{
    case badURL
    case badRequest
    case badJSON
}


class Network:NetworkProtocol{
    
    func createRequest<T:Decodable,P:Encodable>(urlString:String, params:P, typeOfData: T.Type) async throws -> T {
        guard let url = URL(string: urlString) else { throw FetchError.badURL }
        var urlRequest = URLRequest(url: url)
        
        let httpBody = try? JSONEncoder().encode(params)
        urlRequest.httpBody = httpBody
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let (data,response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw FetchError.badRequest
        }
        guard let dataFromJSON = try? JSONDecoder().decode(T.self, from: data) else { throw FetchError.badJSON}
        return dataFromJSON
    }

    func createRequest<T:Decodable>(urlStrng:String, typeOfData:T.Type) async throws -> T {
        guard let url = URL(string: urlStrng) else { throw FetchError.badURL }
        let urlRequest = URLRequest(url: url)
        let (data,response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw FetchError.badRequest
        }
        guard let dataFromJSON = try? JSONDecoder().decode(T.self, from: data) else { throw FetchError.badJSON}
        return dataFromJSON
    }
}
