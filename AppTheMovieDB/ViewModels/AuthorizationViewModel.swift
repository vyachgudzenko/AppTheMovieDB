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
        let authStruct:AuthWithLogin = AuthWithLogin(username: username, password: password, requestToken: requestToken)
        return authStruct
    }
    
    func logIn() async throws{
        requestToken = try await createRequest(urlString: URLConstans.requestTokenLink, typeOfData: RequestToken.self).requestToken
        requestToken = try await createRequest(urlString: URLConstans.authWithLoginLink,params: authorizationInfo, typeOfData: RequestToken.self).requestToken
        sessionId = try await createRequest(urlString: URLConstans.sessionIdLink, params: RequestToken(requestToken: requestToken),typeOfData: ResponseSessionId.self).sessionId
    }
}
