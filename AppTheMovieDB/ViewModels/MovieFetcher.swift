//
//  MovieFetcher.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 05.09.2022.
//

import SwiftUI



@MainActor
class MovieFetcher:ObservableObject{
    @Published var numberOfPage:Int = 1{
        didSet{
            Task{
                try? await fetchPage()
            }
        }
    }
    @Published var movies: [Page.Preview] = []
    @Published var currentMovie:Movie = Movie.defaultMovie
    
    
    /*
    func logIn() async throws{
        guard let urlToken = URL(string: URLConstans.requestTokenLink) else { return }
        let request = URLRequest(url: urlToken)
        let (dataToken,responseToken) = try await URLSession.shared.data(for: request)
        guard (responseToken as? HTTPURLResponse)?.statusCode == 200 else {
            throw FetchError.badRequest
        }
        
        requestToken = try? JSONDecoder().decode(ResponseRequestToken.self, from: dataToken).request_token
        if requestToken == nil{
            throw FetchError.badJSON
        }
        guard let urlAuth = URL(string: URLConstans.authWithLoginLink) else { return }
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
        guard let urlSessionId = URL(string: URLConstans.sessionIdLink) else { return }
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
    }*/
    
    //отримуємо список фільмів
    func fetchPage() async throws{
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(URLConstans.apiKey)&language=en-US&page=\(numberOfPage)"
        guard let url = URL(string: urlString) else {return}
        let (data,response) = try await URLSession.shared.data(for: URLRequest(url: url))
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw FetchError.badRequest
            
        }
        movies = try JSONDecoder().decode(Page.self, from: data).results
    }
    
    func fetchMovie(id:Int) async throws{
        let urlString = "https://api.themoviedb.org/3/movie/\(id)?api_key=\(URLConstans.apiKey)&language=en-US"
        guard let url = URL(string: urlString) else {return}
        let (data,response) = try await URLSession.shared.data(for: URLRequest(url: url))
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {throw FetchError.badRequest}
        currentMovie = try JSONDecoder().decode(Movie.self, from: data)
    }
}
