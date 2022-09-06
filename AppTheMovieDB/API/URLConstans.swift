//
//  URLConstans.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 06.09.2022.
//

import Foundation
//Cтруктура для зберігання посилань апі та ключа
struct URLConstans:Codable{
    var apiKey = "7ddd428c76f6f9fd931cd37916fcc80a"
    var requestTokenLink:String {
        "https://api.themoviedb.org/3/authentication/token/new?api_key=\(apiKey)"
    }
    var authWithLoginLink:String {
        "https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=\(apiKey)"
    }
    var sessionIdLink:String {
        "https://api.themoviedb.org/3/authentication/session/new?api_key=\(apiKey)"
    }
    
}
