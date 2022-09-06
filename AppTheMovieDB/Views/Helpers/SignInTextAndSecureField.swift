//
//  SignInTextAndSecureField.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 06.09.2022.
//

import SwiftUI

enum TypeTextField{
    case textField
    case secureField
}

struct SignInTextAndSecureField: View {
    
    @Binding var text:String
    let placeholderText:String
    let type:TypeTextField
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.init(ColorConstants().strokeColor),lineWidth: 2)
            if text.isEmpty{
                Text(placeholderText)
                    .foregroundColor(.gray)
                    .font(.title)
            }
            switch type {
            case .textField:
                TextField("", text: $text)
                    .padding()
                    .font(.title)
                    .foregroundColor(.white)
            case .secureField:
                SecureField("", text: $text)
                    .padding()
                    .font(.title)
                    .foregroundColor(.white)
            }
        }
    }
}
