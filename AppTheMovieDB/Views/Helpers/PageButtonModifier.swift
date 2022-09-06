//
//  PageButtonModifier.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 07.09.2022.
//

import SwiftUI

struct PageButtonModifier: ViewModifier{
    func body(content: Content) -> some View {
        content
            .frame(width:100, height: 50)
            .foregroundColor(.black)
            .font(.body)
            .overlay {
                Capsule().stroke(Color.init(ColorConstants().strokeColor))
            }
    }
}
