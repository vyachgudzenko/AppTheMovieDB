//
//  MovieFetcher.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 05.09.2022.
//

import SwiftUI

@MainActor
class MovieFetcher:ObservableObject{
    @Published var username:String = "vyachProfileForTest"
    @Published var password:String = "swift2022"
    @Published var movies: [Preview] = []
    @Published var currentMovie:Movie = Movie.defaultMovie
    @Published var isLogin:Bool = false
    
    enum FetchError:Error{
        case badRequest
        case badJSON
    }
    
    func load< T: Codable>(urlString:String,httpBody:Data?,expectedType:T.Type, _ completion: @escaping (T) -> Void) {
        guard let url = URL(string: urlString) else {
            return
        }
        var request = URLRequest(url: url)
        if httpBody != nil{
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = httpBody
        } else {
            request.httpMethod = "GET"
        }
        
        let urlSession = URLSession(configuration: .default)
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let data = data {
                do{
                    let decoder = JSONDecoder()
                    let decodeData = try decoder.decode(T.self, from: data)
                    DispatchQueue.main.async {
                            completion(decodeData)
                        }
                } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            }
        }
        task.resume()
    }
    
    func logIn(){
        load(urlString: URLConstans().requestTokenLink, httpBody: nil, expectedType: ResponseRequestToken.self) { [self] tokenResponse in
            let authInfo = AuthWithLogin(username: username, password: password, request_token: tokenResponse.request_token)
            let authJSON = try? JSONEncoder().encode(authInfo)
            load(urlString: URLConstans().authWithLoginLink, httpBody: authJSON, expectedType: ResponseRequestToken.self) { [self] authResponse in
                let sessionInfo = RequestToken(request_token: authResponse.request_token)
                let sessionJSON = try? JSONEncoder().encode(sessionInfo)
                load(urlString: URLConstans().sessionIdLink, httpBody: sessionJSON, expectedType: ResponseSessionId.self) { [self] sessionResponse in
                    isLogin = sessionResponse.success
                }
            }
        }
    }
}
