//
//  MovieCard.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 07.09.2022.
//

import SwiftUI

struct MovieCard: View {
    var preview:Page.Preview
    
    var body: some View {
        ZStack {
            let urlString = "https://image.tmdb.org/t/p/w500\(preview.posterPath)"
            AsyncImage(url: URL(string: urlString)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .background(Color.gray)
                    .foregroundColor(.gray)
            } placeholder: {
                Image("duna")
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
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

struct MovieCard_Previews: PreviewProvider {
    static var previews: some View {
        MovieCard(preview: Page.Preview(id: 616037, posterPath: "/pIkRyD18kl4FhoCNQuWxWu5cBLM.jpg",  title: "Thor: Love and Thunder"))
    }
}
