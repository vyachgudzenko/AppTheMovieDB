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
            Color.backgoundColor.ignoresSafeArea(.all)
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
                    Task{
                        do{
                            try await movieFetcher.logIn()
                        } catch FetchError.badRequest{
                            movieFetcher.isError = true
                        } catch {
                            movieFetcher.isError = true
                        }
                    }
                } label: {
                    Text("Go")
                        .frame(width: 180, height: 70)
                        .background(LinearGradient(colors: [Color.startColor,Color.endColor], startPoint: .leading, endPoint: .trailing))
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
