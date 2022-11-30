//
//  AuthorizationViewModel.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 05.11.2022.
//

import SwiftUI
import Combine

//@MainActor
class AuthoraizationViewModel:CombineNetwork, ObservableObject{
    private var username:String = "vyachProfileForTest"
    private var password:String = "swift2022"
    @Published var usernameField:String = "vyachProfileForTest"
    @Published var passwordField:String = "swift2022"
    @Published var usernameIsCorrect:Bool = false
    @Published var passwordIsCorrect:Bool  = false 
    @Published var isLogin:Bool = false
    @Published var isError:Bool = false
    @Published var errorMessage:String = ""
    @Published var requestToken:String = "empty request token"
    @Published var logining:Bool = false
    @Published var verifiedToken:String = ""
    @Published var sessionId:String = ""
    private var anyCancellables = Set<AnyCancellable>()
    
    var authorizationInfo:AuthWithLogin {
        let authStruct:AuthWithLogin = AuthWithLogin(username: username, password: password, requestToken: self.requestToken)
        return authStruct
    }
    
    override init(){
        super.init()
        $usernameField
            .map { usernameForVerified -> Bool in
                if usernameForVerified == self.username{
                    return true
                }
                return false
            }
            .assign(to: \.usernameIsCorrect, on: self)
            .store(in: &anyCancellables)
        $passwordField
            .map { passForVerified -> Bool in
                if passForVerified == self.password{
                    return true
                }
                return false
            }
            .assign(to: \.passwordIsCorrect, on: self)
            .store(in: &anyCancellables)
        $logining
            .flatMap { logining -> AnyPublisher<String,Never> in
                    return self.createRequest(urlString: URLConstans.requestTokenLink, typeOfData: RequestToken.self)
                        .map { requestToken in
                            //print("request token in pipeline, after logining \(requestToken.requestToken)")
                            return requestToken.requestToken
                        }
                        .replaceError(with: "Bad request token")
                        .eraseToAnyPublisher()
            }
            .assign(to: \.requestToken, on: self)
            .store(in: &anyCancellables)
        $requestToken
            .flatMap { token -> AnyPublisher<String,Never> in
                return self.createRequest(urlString: URLConstans.authWithLoginLink, params: self.authorizationInfo,typeOfData: RequestToken.self)
                    .map { requestToken  in
                        //print("request token in pipeline, after auth \(requestToken.requestToken)")
                        return requestToken.requestToken
                    }
                    .replaceError(with: "Bad auth token")
                    .eraseToAnyPublisher()
            }
            .assign(to: \.verifiedToken, on: self)
            .store(in: &anyCancellables)
        $verifiedToken
            .flatMap { verifiedT -> AnyPublisher<String,Never> in
                return self.createRequest(urlString: URLConstans.authWithLoginLink, params: RequestToken(requestToken: self.verifiedToken),typeOfData: ResponseSessionId.self)
                    .map({ responseSessionID in
                        //print("sessionID in pipeline \(responseSessionID.sessionId)")
                        return responseSessionID.sessionId
                    })
                    .replaceError(with: "")
                    .eraseToAnyPublisher()
            }
            .assign(to: \.sessionId, on: self)
            .store(in: &anyCancellables)
        $sessionId
            .map { session -> Bool in
                return session.count < 5 ? false : true
            }
            .assign(to: \.isLogin, on: self)
            .store(in: &anyCancellables)
    }
    
    func login(){
        
    }
    /*
     //тут не зберігаються дані в властивостях і іх неможливо використати далі
    func logIn(){
       
        createRequest(urlString: URLConstans.requestTokenLink, typeOfData: RequestToken.self)
            .map({ requestToken in
                return requestToken.requestToken
            })
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                    self.isError = true  }
                else if case .finished = completion {
                    print("Request token after Auth successfully")
                }
            }, receiveValue: { value in
                self.requestToken = value
            })
            .store(in: &anyCancellables)
            print(requestToken)
        createRequest(urlString: URLConstans.authWithLoginLink, params: authorizationInfo,typeOfData: RequestToken.self)
            .map { $0.requestToken }
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                    self.isError = true  }
                else if case .finished = completion {
                    print("Request token after Auth successfully")
                }
            }, receiveValue: { value in
                self.requestToken = value
            })
            .store(in: &anyCancellables)
        createRequest(urlString: URLConstans.sessionIdLink, params: RequestToken(requestToken: requestToken),typeOfData: ResponseSessionId.self)
            .map{ $0.sessionId }
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                    self.isError = true        }
                else if case .finished = completion {
                    print("SessionId successfully")
                }
            }, receiveValue: { value in
                self.sessionId = value
            })
            .store(in: &anyCancellables)

    }
    */
}
