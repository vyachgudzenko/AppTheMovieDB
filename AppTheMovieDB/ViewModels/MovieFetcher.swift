//
//  MovieFetcher.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 05.09.2022.
//

import SwiftUI
import Combine



@MainActor
class MovieFetcher:CombineNetwork,ObservableObject{
    @Published var numberOfPage:Int = 1
    @Published var movies: [Page.Preview] = []
    @Published var currentMovie:Movie = Movie.defaultMovie
    @Published var currentId:Int = 0
    private var anyCancellables = Set<AnyCancellable>()
    
    var urlStringForPage:String{
        return "https://api.themoviedb.org/3/movie/popular?api_key=\(URLConstans.apiKey)&language=en-US&page=\(numberOfPage)"
    }
    
    var urlStringForMovie:String{
        return "https://api.themoviedb.org/3/movie/\(self.currentId)?api_key=\(URLConstans.apiKey)&language=en-US"
    }
    
    func fetchPage(){
        createRequest(urlString: urlStringForPage, typeOfData: Page.self)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.errorMessage)                }
                else if case .finished = completion {
                    print("Data successfully downloaded")
                }
            } receiveValue: { page in
                self.movies = page.results
            }
            .store(in: &anyCancellables)
            
    }
    
    func fetchMovie(){
        createRequest(urlString: urlStringForMovie, typeOfData: Movie.self)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.errorMessage)                }
                else if case .finished = completion {
                    print("Data successfully downloaded")
                }
            } receiveValue: { movie in
                print(movie)
                self.currentMovie = movie
            }
            .store(in: &anyCancellables)

    }
    
    func addNextPage(){
        numberOfPage += 1
        var nextPageMovies:[Page.Preview] = []
        createRequest(urlString: urlStringForPage, typeOfData: Page.self)
            .map({ page -> [Page.Preview] in
                return page.results
            })
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.errorMessage)                }
                else if case .finished = completion {
                    print("Data successfully downloaded")
                }
            } receiveValue: { previews in
                nextPageMovies = previews
            }
            .store(in: &anyCancellables)
        movies += nextPageMovies
    }
}
