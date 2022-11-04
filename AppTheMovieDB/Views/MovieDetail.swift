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
            //Image
            ZStack{
                HStack {
                    Spacer()
                    AsyncImage(url: URL(string: URLConstans.backdropPath + movieFetcher.currentMovie.backdrop_path)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                    } placeholder: {
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.red)
                            .frame(height: 200)
                    }
                    .mask(LinearGradient(colors: [.white,.white,.clear], startPoint: .trailing, endPoint: .leading))
                }
                
                HStack{
                    AsyncImage(url: URL(string: URLConstans.posterPath + movieFetcher.currentMovie.poster_path!)) { image in
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
            VStack{
                //Title
                Text("\(movieFetcher.currentMovie.title)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                //Tagline
                Text("\(movieFetcher.currentMovie.tagline)")
                    .font(.body)
                    .italic()
                    .fontWeight(.light)
                //Review
                Text("Review")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                Text("\(movieFetcher.currentMovie.overview)")
                //Genres
                TitleText(text: "Genres")
                let hGrid:[GridItem] = [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    //GridItem(.flexible())
                ]
                LazyVGrid(columns: hGrid,spacing: 3){
                    ForEach(movieFetcher.currentMovie.genres, id: \.self){ genre in
                        Text(genre.name)
                            .padding(.horizontal)
                    }
                }
                //Year,Time,Status
                HStack{
                    VStack{
                        TitleText(text: "Year")
                        Text(getYearRelease())
                    }
                    Spacer()
                    VStack{
                        TitleText(text:"Time")
                        Text(getReadableTime(minute:movieFetcher.currentMovie.runtime))
                    }
                    Spacer()
                    VStack{
                        TitleText(text:"Status")
                            
                        Text("\(movieFetcher.currentMovie.status)")
                    }
                }.padding(.top)
                //Budget,Revenue
                HStack{
                    VStack(alignment:.leading){
                        TitleText(text: "Buget")
                        Text(movieFetcher.currentMovie.budget == 0 ? "Not specified" : "$\(movieFetcher.currentMovie.budget)")
                    }
                    Spacer()
                    VStack(alignment:.trailing){
                        TitleText(text: "Revenue")
                        Text(movieFetcher.currentMovie.revenue == 0 ? "Not specified" : "$\(movieFetcher.currentMovie.revenue)")
                    }
                }.padding(.top)
                //Vote
                HStack {
                    CircleProgressBar(vote: Float(movieFetcher.currentMovie.vote_average))
                        .frame(width: 80, height: 80)
                    Spacer()
                    Text("User rating")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                }.padding(.top)
                
            }.padding(.horizontal)
        }
        .navigationTitle("\(movieFetcher.currentMovie.title)")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func getYearRelease() -> String{
        let dateRelease = movieFetcher.currentMovie.release_date
        let firstSlash = dateRelease.firstIndex(of: "-")!
        let year = dateRelease[..<firstSlash]
        return String(year)
    }
    
    private func getReadableTime(minute:Int) -> String{
        let stringTime = "\(minute / 60)h \(minute % 60)m"
        return stringTime
    }
}

struct MovieDetail_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetail()
    }
}
