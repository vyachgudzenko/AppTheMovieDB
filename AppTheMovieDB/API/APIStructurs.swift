//
//  APIStructurs.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 05.09.2022.
//

import Foundation

struct ResponseRequestToken:Codable{
    var success:Bool
    var expires_at:String
    var request_token:String
}

struct ResponseSessionId:Codable{
    var success:Bool
    var session_id:String
}

struct RequestToken:Codable{
    var request_token:String
}

struct AuthWithLogin:Codable{
    var username:String
    var password:String
    var request_token:String
}
