//
//  SignIn.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 06.09.2022.
//

import SwiftUI

struct SignIn: View {
    @StateObject var authorizationVM = AuthoraizationViewModel()
    @State var isError:Bool = false
    @State var isLogin:Bool = false
    
    var body: some View {
        ZStack{
            Color.backgoundColor.ignoresSafeArea(.all)
            VStack{
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.top,100)
                
                SignInTextAndSecureField(text: $authorizationVM.usernameField, isCorrect: $authorizationVM.usernameIsCorrect, placeholderText: "Enter your name", type: .textField)
                    .frame(height:70)
                    .padding(.top,50)
                    
                SignInTextAndSecureField(text: $authorizationVM.passwordField, isCorrect: $authorizationVM.passwordIsCorrect, placeholderText: "Enter your password", type: .secureField)
                    .frame(height:70)
                    .padding(.top,50)
                    
                Button {
                    authorizationVM.logining = true
                    print(authorizationVM.logining)
                    print(authorizationVM.requestToken)
                } label: {
                    Text("Go")
                        .frame(width: 180, height: 70)
                        .background(LinearGradient(colors: [Color.startColor,Color.endColor], startPoint: .leading, endPoint: .trailing))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .foregroundColor(.white)
                        .padding(.top,50)
                }.fullScreenCover(isPresented: $authorizationVM.isLogin) {
                    NavigationView{
                        PopularMovies()
                    }
                }
                .alert(authorizationVM.errorMessage,isPresented: $authorizationVM.isError){
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
