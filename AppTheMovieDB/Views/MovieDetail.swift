//
//  MovieDetail.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 07.09.2022.
//

import SwiftUI

struct MovieDetail: View {
    
    @EnvironmentObject var movieFetcher:MovieFetcher
    
    var body: some View {
        ScrollView{
            ZStack{
                HStack {
                    Spacer()
                    AsyncImage(url: URL(string: URLConstans().backdropPath + movieFetcher.currentMovie.backdrop_path)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                    } placeholder: {
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.red)
                            .frame(height: 200)
                    }
                    .mask(LinearGradient(colors: [.white,.white,.clear], startPoint: .trailing, endPoint: .leading))
                }
                
                HStack{
                    AsyncImage(url: URL(string: URLConstans().posterPath + movieFetcher.currentMovie.poster_path!)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 150 )
                            .cornerRadius(10)
                            .padding(.leading,30)
                                
                    } placeholder: {
                        Rectangle()
                            .frame(width: 100, height: 200)
                            .blur(radius: 10)
                            .background(Color.white)
                            .foregroundColor(.white)
                        Spacer()
                    }

                    Spacer()
                }
                
            }
        }
    }
}

struct MovieDetail_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetail()
    }
}
