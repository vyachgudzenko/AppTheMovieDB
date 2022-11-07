//
//  APIStructurs.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 05.09.2022.
//

import Foundation

struct ResponseRequestToken:Decodable{
    var success:Bool
    var expiresAt:String
    var requestToken:String
    
    enum CodingKeys: String, CodingKey{
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
        
}

struct ResponseSessionId:Decodable{
    var success:Bool
    var sessionId:String
    
    enum CodingKeys: String, CodingKey{
        case success
        case sessionId = "session_id"
    }
}

struct RequestToken:Codable{
    var requestToken:String
    enum CodingKeys: String, CodingKey{
        case requestToken = "request_token"
    }
    
    
}

struct AuthWithLogin:Encodable{
    var username:String
    var password:String
    var requestToken:String
    
    enum CodingKeys: String, CodingKey{
        case username
        case password
        case requestToken = "request_token"
    }
    
    
}
