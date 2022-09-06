//
//  MovieCard.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 07.09.2022.
//

import SwiftUI

struct MovieCard: View {
    var preview:Preview
    
    var body: some View {
        ZStack {
            let urlString = "https://image.tmdb.org/t/p/w500\(preview.poster_path)"
            AsyncImage(url: URL(string: urlString)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .background(Color.gray)
                    .foregroundColor(.gray)
            } placeholder: {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.red)
            }
                
            VStack{
                Spacer()
                ZStack{
                    Rectangle()
                        .frame(height: 50)
                        .foregroundColor(.black)
                        .opacity(0.5)
                    Text(preview.title)
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct MovieCard_Previews: PreviewProvider {
    static var previews: some View {
        MovieCard(preview: Preview(adult: false, backdrop_path: "/vvObT0eIWGlArLQx3K5wZ0uT812.jpg", genre_ids: [28, 12, 14], id: 616037, original_language: "en", original_title: "Thor: Love and Thunder", overview: "After his retirement is interrupted by Gorr the God Butcher, a galactic killer who seeks the extinction of the gods, Thor Odinson enlists the help of King Valkyrie, Korg, and ex-girlfriend Jane Foster, who now inexplicably wields Mjolnir as the Relatively Mighty Girl Thor. Together they embark upon a harrowing cosmic adventure to uncover the mystery of the God Butcher’s vengeance and stop him before it’s too late.", popularity: 8104.31, poster_path: "/pIkRyD18kl4FhoCNQuWxWu5cBLM.jpg", release_date: "2022-07-06", title: "Thor: Love and Thunder", video: false, vote_average: 6.8, vote_count: 2108))
    }
}
