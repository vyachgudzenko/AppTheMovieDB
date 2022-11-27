//
//  AuthorizationViewModel.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 05.11.2022.
//

import SwiftUI
import Combine

class AuthoraizationViewModel:CombineNetwork, ObservableObject{
    @Published var username:String = "vyachProfileForTest"
    @Published var password:String = "swift2022"
    @Published var isLogin:Bool = false
    private var requestToken:String = ""
    var sessionId:String?
    private var anyCancellables = Set<AnyCancellable>()
    
    var authorizationInfo:AuthWithLogin {
        let authStruct:AuthWithLogin = AuthWithLogin(username: username, password: password, requestToken: requestToken)
        return authStruct
    }
    
    func logIn(){
        createRequest(urlString: URLConstans.requestTokenLink, typeOfData: RequestToken.self)
            .map { newToken -> String in
                return newToken.requestToken
            }
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)                }
                else if case .finished = completion {
                    self.isLogin = true
                    print("token successfully")
                }
            } receiveValue: { token in
                print("new token \(token)")
                self.requestToken = token
                
            }
            .store(in: &anyCancellables)
        createRequest(urlString: URLConstans.authWithLoginLink,params: authorizationInfo ,typeOfData: RequestToken.self)
            .map { tokenAfterAuth -> String in
                return tokenAfterAuth.requestToken
            }
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)                }
                else if case .finished = completion {
                    self.isLogin = true
                    print("token successfully")
                }
            } receiveValue: { tokenAfterAuth in
                print("tokent after auth \(tokenAfterAuth)")
                self.requestToken = tokenAfterAuth
                
            }
            .store(in: &anyCancellables)

    }
    
    
    /*
    func logIn() async throws{
        requestToken = try await createRequest(urlString: URLConstans.requestTokenLink, typeOfData: RequestToken.self).requestToken
        requestToken = try await createRequest(urlString: URLConstans.authWithLoginLink,params: authorizationInfo, typeOfData: RequestToken.self).requestToken
        sessionId = try await createRequest(urlString: URLConstans.sessionIdLink, params: RequestToken(requestToken: requestToken),typeOfData: ResponseSessionId.self).sessionId
    }
     */
}
