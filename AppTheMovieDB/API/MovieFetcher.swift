//
//  MovieFetcher.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 05.09.2022.
//

import SwiftUI

enum FetchError:Error{
    case badRequest
    case badJSON
}

@MainActor
class MovieFetcher:ObservableObject{
    @Published var username:String = "vyachProfileForTest"
    @Published var password:String = "swift2022"
    @Published var numberOfPage:Int = 1{
        didSet{
            Task{
                try? await fetchPage()
            }
        }
    }
    @Published var movies: [Preview] = []
    @Published var currentMovie:Movie = Movie.defaultMovie
    @Published var isLogin:Bool = false
    @Published var isError:Bool = false
    private var requestToken:String?
    private var sessionId:String?
    
    
    
    //Загальна функція для отримання данних
    /*
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
                    self.isError = true
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    self.isError = true
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    self.isError = true
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    self.isError = true
                    print("error: ", error)
                }
            }
        }
        task.resume()
    }
    
    //коряво реалізована функція входу
    func logIn(){
        //отримуємо request token
        load(urlString: URLConstans().requestTokenLink, httpBody: nil, expectedType: ResponseRequestToken.self) { [self] tokenResponse in
            let authInfo = AuthWithLogin(username: username, password: password, request_token: tokenResponse.request_token)
            let authJSON = try? JSONEncoder().encode(authInfo)
            //отримуємо пермішн для користувача(логін та пароль)
            load(urlString: URLConstans().authWithLoginLink, httpBody: authJSON, expectedType: ResponseRequestToken.self) { [self] authResponse in
                let sessionInfo = RequestToken(request_token: authResponse.request_token)
                let sessionJSON = try? JSONEncoder().encode(sessionInfo)
                //отримуємо session ID
                load(urlString: URLConstans().sessionIdLink, httpBody: sessionJSON, expectedType: ResponseSessionId.self) { [self] sessionResponse in
                    isLogin = sessionResponse.success
                }
            }
        }
    }*/
    
    @available(iOS 15.0, *)
    func logIn() async throws{
        guard let urlToken = URL(string: URLConstans().requestTokenLink) else { return }
        let request = URLRequest(url: urlToken)
        let (dataToken,responseToken) = try await URLSession.shared.data(for: request)
        guard (responseToken as? HTTPURLResponse)?.statusCode == 200 else {
            throw FetchError.badRequest
        }
        
        requestToken = try? JSONDecoder().decode(ResponseRequestToken.self, from: dataToken).request_token
        if requestToken == nil{
            throw FetchError.badJSON
        }
        guard let urlAuth = URL(string: URLConstans().authWithLoginLink) else { return }
        let authInfo = AuthWithLogin(username: username, password: password, request_token: requestToken!)
        let authBody = try? JSONEncoder().encode(authInfo)
        var authRequest = URLRequest(url: urlAuth)
        authRequest.httpMethod = "POST"
        authRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        authRequest.httpBody = authBody
        let (dataAuth,responseAuth) = try await URLSession.shared.data(for: authRequest)
        guard (responseAuth as? HTTPURLResponse)?.statusCode == 200 else {
            throw FetchError.badRequest
        }
        guard let authJSON = try? JSONDecoder().decode(ResponseRequestToken.self, from: dataAuth) else { throw FetchError.badJSON}
        guard let urlSessionId = URL(string: URLConstans().sessionIdLink) else { return }
        let sessionInfo = RequestToken(request_token: requestToken!)
        let sessionBody = try? JSONEncoder().encode(sessionInfo)
        var sessionRequest = URLRequest(url: urlSessionId)
        sessionRequest.httpMethod = "POST"
        sessionRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        sessionRequest.httpBody = sessionBody
        let (dataSession,responseSession) = try await URLSession.shared.data(for: sessionRequest)
        guard (responseSession as? HTTPURLResponse)?.statusCode == 200 else {
            throw FetchError.badRequest
        }
        let sessionJSON = try JSONDecoder().decode(ResponseSessionId.self, from: dataSession)
        sessionId = sessionJSON.session_id
        isLogin = true
    }
    
    //отримуємо список фільмів
    @available(iOS 15.0, *)
    func fetchPage() async throws{
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(URLConstans().apiKey)&language=en-US&page=\(numberOfPage)"
        guard let url = URL(string: urlString) else {return}
        let (data,response) = try await URLSession.shared.data(for: URLRequest(url: url))
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw FetchError.badRequest
            
        }
        movies = try JSONDecoder().decode(Page.self, from: data).results
    }
    
    @available(iOS 15.0, *)
    func fetchMovie(id:Int) async throws{
        let urlString = "https://api.themoviedb.org/3/movie/\(id)?api_key=\(URLConstans().apiKey)&language=en-US"
        guard let url = URL(string: urlString) else {return}
        let (data,response) = try await URLSession.shared.data(for: URLRequest(url: url))
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {throw FetchError.badRequest}
        currentMovie = try JSONDecoder().decode(Movie.self, from: data)
    }
}
