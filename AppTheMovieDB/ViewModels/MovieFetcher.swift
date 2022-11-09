//
//  MovieFetcher.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 05.09.2022.
//

import SwiftUI



@MainActor
class MovieFetcher:Network,ObservableObject{
    @Published var numberOfPage:Int = 1{
        didSet{
            Task{
                try await addNextPage()
            }
        }
    }
    @Published var movies: [Page.Preview] = []
    @Published var currentMovie:Movie = Movie.defaultMovie
    @Published var currentId:Int = 0 {
        didSet{
            if !movies.isEmpty{
                Task{
                    try await self.fetchMovie(id:currentId)
                }
            }
        }
    }
    
    func fetchPage() async throws -> [Page.Preview]{
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(URLConstans.apiKey)&language=en-US&page=\(numberOfPage)"
         let previews = try await createRequest(urlString: urlString, typeOfData: Page.self).results
        return previews
    }
    
    func fetchMovie(id:Int) async throws{
        let urlString = "https://api.themoviedb.org/3/movie/\(id)?api_key=\(URLConstans.apiKey)&language=en-US"
        currentMovie = try await createRequest(urlString: urlString, typeOfData: Movie.self)
    }
    
    func addNextPage() async throws {
        let nextPageMovies = try await fetchPage()
        movies += nextPageMovies
    }
}
