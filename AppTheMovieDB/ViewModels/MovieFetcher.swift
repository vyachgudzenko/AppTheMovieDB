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
                try? await fetchPage()
            }
        }
    }
    @Published var movies: [Page.Preview] = []
    @Published var currentMovie:Movie = Movie.defaultMovie
    
    func fetchPage() async throws{
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(URLConstans.apiKey)&language=en-US&page=\(numberOfPage)"
        movies = try await createRequest(urlString: urlString, typeOfData: Page.self).results
    }
    
    func fetchMovie(id:Int) async throws{
        let urlString = "https://api.themoviedb.org/3/movie/\(id)?api_key=\(URLConstans.apiKey)&language=en-US"
        currentMovie = try await createRequest(urlString: urlString, typeOfData: Movie.self)
    }
}
