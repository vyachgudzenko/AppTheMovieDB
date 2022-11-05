//
//  AuthorizationViewModel.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 05.11.2022.
//

import SwiftUI

class AuthoraizationViewModel:Network, ObservableObject{
    @Published var username:String = "vyachProfileForTest"
    @Published var password:String = "swift2022"
    @Published var isLogin:Bool = false
    private var requestToken:String = ""
     var sessionId:String? 
    
    
    
    var authorizationInfo:AuthWithLogin {
        let authInfo = AuthWithLogin(username: username, password: password, request_token: requestToken)
        return authInfo
    }
    
    func logIn() async throws{
        requestToken = try await createRequest(urlStrng: URLConstans.requestTokenLink, typeOfData: ResponseRequestToken.self).request_token
        requestToken = try await createRequest(urlString: URLConstans.authWithLoginLink, params: authorizationInfo, typeOfData: ResponseRequestToken.self).request_token
        sessionId = try await createRequest(urlString: URLConstans.sessionIdLink, params: RequestToken(request_token: requestToken), typeOfData: ResponseSessionId.self).session_id
    }
    
    
    
}
