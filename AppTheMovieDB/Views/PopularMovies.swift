//
//  PopularMovies.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 06.09.2022.
//

import SwiftUI

struct PopularMovies: View {
    @EnvironmentObject var movieFetcher:MovieFetcher
    
    let size = UIScreen.main.bounds.size
    
    let columnsGrid:[GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView{
            LazyVGrid(columns:columnsGrid,spacing: 10){
                ForEach(movieFetcher.movies ,id: \.self){
                    preview in
                    NavigationLink {
                        MovieDetail()
                            .task {
                                try? await movieFetcher.fetchMovie(id: preview.id)
                            }
                    } label: {
                        MovieCard(preview: preview)
                            .cornerRadius(20)
                            .padding(.all,5)
                            .shadow(color: .black.opacity(0.5), radius: 6, x: 5, y: 5)
                    }
                }
            }
            HStack {
                if movieFetcher.numberOfPage > 1{
                    Button {
                        movieFetcher.numberOfPage -= 1
                    } label: {
                        Text("Previus")
                            .modifier(PageButtonModifier())
                    }
                }
                Text("\(movieFetcher.numberOfPage)")
                    .font(.title)
                    .padding(.horizontal)
                Button {
                    movieFetcher.numberOfPage += 1
                } label: {
                    Text("Next")
                        .modifier(PageButtonModifier())
                }
            }
        }
        .task {
            try? await movieFetcher.fetchPage()
        }
        .navigationTitle("Popular Movies")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PopularMovies_Previews: PreviewProvider {
    static var previews: some View {
        PopularMovies()
    }
}
