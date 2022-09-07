//
//  TitleText.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 07.09.2022.
//

import SwiftUI

struct TitleText: View {
    var text:String
    var body: some View {
        Text(text)
            .bold()
            .font(.title2)
    }
}

struct TitleText_Previews: PreviewProvider {
    static var previews: some View {
        TitleText(text: "Test")
    }
}
