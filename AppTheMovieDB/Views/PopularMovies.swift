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
        ZStack {
            VStack{
                
                Text("Popular Movies")
                    .font(.system(size: 30))
                    .fontWeight(.semibold)
                    .offset(y:50)
                
                
                CustomCarousel(index: $index,currentId: $movieFetcher.currentId, showDetail: $showDetailMovie, items: movieFetcher.movies, destination: {
                    MovieDetail(showDetail: $showDetailMovie)
                }, content: { movie, cardSize in
                    MovieCard(preview: movie)
                        .frame(height: cardSize.height * 0.5)
                },swipeLastElement: {
                    movieFetcher.numberOfPage += 1
                })
                .padding(.vertical)
                    
            }
            MovieDetail(showDetail: $showDetailMovie)
                .offset( x: showDetailMovie ? 0 :size.width)
               .rotationEffect(.degrees(showDetailMovie ? 0 : 45), anchor: .bottom)
                .opacity(showDetailMovie ? 1 : 0)
                .animation(.easeInOut(duration: 0.5), value: showDetailMovie)
                .gesture(
                    DragGesture(minimumDistance: 5)
                        .onChanged({ value in
                            var offsetX = value.translation.width
                            if offsetX > 20{
                                showDetailMovie.toggle()
                            }
                        })
                )
            
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
