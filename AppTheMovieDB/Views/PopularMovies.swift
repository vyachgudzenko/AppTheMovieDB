//
//  PopularMovies.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 06.09.2022.
//

import SwiftUI

struct PopularMovies: View {
    @EnvironmentObject var movieFetcher:MovieFetcher
    @State private var index:Int = 0
    @State private var showDetailMovie:Bool = false
    let size = UIScreen.main.bounds.size
    
    let columnsGrid:[GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack{
            
            Text("Popular Movies")
                .font(.system(size: 30))
                .fontWeight(.semibold)
                .offset(y:50)
                
            
            CustomCarousel(index: $index,currentId: $movieFetcher.currentId, showDetail: $showDetailMovie, items: movieFetcher.movies, id: \.id, destination: {
                MovieDetail(showDetail: $showDetailMovie)
            }, content: { movie, cardSize in
                MovieCard(preview: movie)
                    .frame(height: cardSize.height * 0.5)
            },swipeLastElement: {
                movieFetcher.numberOfPage += 1
            })
            .padding(.vertical)
            
        }
        .task {
            movieFetcher.movies = try! await movieFetcher.fetchPage()
        }
    }
}

struct PopularMovies_Previews: PreviewProvider {
    static var previews: some View {
        PopularMovies()
            .environmentObject(MovieFetcher())
    }
}
