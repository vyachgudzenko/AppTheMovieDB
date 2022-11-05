//
//  APIStructurs.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 05.09.2022.
//

import Foundation

struct ResponseRequestToken:Decodable{
    var success:Bool
    var expires_at:String
    var request_token:String
}

struct ResponseSessionId:Decodable{
    var success:Bool
    var session_id:String
}

struct RequestToken:Encodable{
    var request_token:String
}

struct AuthWithLogin:Encodable{
    var username:String
    var password:String
    var request_token:String
}
