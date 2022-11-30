//
//  PopularMovies.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 06.09.2022.
//

import SwiftUI
import Combine

struct PopularMovies: View {
    @EnvironmentObject var movieFetcher:MovieFetcher
    @State private var index:Int = 0
    @State private var showDetailMovie:Bool = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment:.center) {
                
                VStack{
                    
                    CustomCarousel(index: $index,currentId: $movieFetcher.currentId, showDetail: $showDetailMovie, items: movieFetcher.movies,cardPadding: geo.size.height * 0.2, content: { movie, cardSize in
                        MovieCard(preview: movie)
                            .onTapGesture {
                                movieFetcher.currentId = movie.id
                                movieFetcher.fetchMovie()
                                print(movieFetcher.currentMovie.title)
                                showDetailMovie = true
                            }
                        
                    },swipeLastElement: {
                        movieFetcher.addNextPage()
                            
                    })
                    .frame(height: geo.size.height * 0.58)
                    .padding(.vertical)
                    
                }
                MovieDetail(showDetail: $showDetailMovie)
                    .offset( x: showDetailMovie ? 0 :geo.size.width)
                    .rotationEffect(.degrees(showDetailMovie ? 0 : 45), anchor: .bottom)
                    .opacity(showDetailMovie ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5), value: showDetailMovie)
                    .gesture(
                        DragGesture(minimumDistance: 5)
                            .onChanged({ value in
                                let offsetX = value.translation.width
                                if offsetX > 5{
                                    showDetailMovie.toggle()
                                }
                            })
                    )
                    
            }
            .task {
                movieFetcher.fetchPage()
                print(movieFetcher.movies.count)
                    
        }
        }
    }
}

struct PopularMovies_Previews: PreviewProvider {
    static var previews: some View {
        PopularMovies()
            .environmentObject(MovieFetcher())
    }
}
