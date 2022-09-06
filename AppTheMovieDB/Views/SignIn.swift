//
//  SignIn.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 06.09.2022.
//

import SwiftUI

struct SignIn: View {
    
    @EnvironmentObject var movieFetcher:MovieFetcher
    
    var body: some View {
        ZStack{
            let backgoundColor:UIColor = UIColor(red: 14 / 255.0, green: 36 / 255.0, blue: 63 / 255.0, alpha: 1)
            Color.init(backgoundColor).ignoresSafeArea(.all)
            VStack{
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.top,100)
                
                SignInTextAndSecureField(text: $movieFetcher.username, placeholderText: "Enter your name", type: .textField)
                    .frame(height:70)
                    .padding(.top,50)
                    
                SignInTextAndSecureField(text: $movieFetcher.password, placeholderText: "Enter your password", type: .secureField)
                    .frame(height:70)
                    .padding(.top,50)
                    
                Button {
                    movieFetcher.logIn()
                } label: {
                    let startColor:UIColor = UIColor(red: 99 / 255, green: 200 / 255, blue: 166 / 255, alpha: 1)
                    let endColor:UIColor = UIColor(red: 82 / 255, green: 179 / 255, blue: 221 / 255, alpha: 1)
                    
                    Text("Go")
                        .frame(width: 180, height: 70)
                        .background(LinearGradient(colors: [.init(startColor),.init(endColor)], startPoint: .leading, endPoint: .trailing))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .foregroundColor(.white)
                        .padding(.top,50)
                }.fullScreenCover(isPresented: $movieFetcher.isLogin) {
                    NavigationView{
                        PopularMovies()
                    }
                }
                .alert("Something went wrong. Check login and password",isPresented: $movieFetcher.isError){
                    Button("OK", role: .cancel) {
                        movieFetcher.isError = false
                    }

                }

                Spacer()
                
            }.padding(.horizontal,30)
        }
    }
    
    
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn()
    }
}
