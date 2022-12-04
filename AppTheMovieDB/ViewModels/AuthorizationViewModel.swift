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
    @Published var verifiedToken:String = ""
    @Published var sessionId:String = ""
    private var anyCancellables = Set<AnyCancellable>()
    let userInitiatedQueue = DispatchQueue.global(qos: .userInitiated)
    
    var requestTokenVersion = CurrentValueSubject<String,Never>("empty request token")
    var verifiedTokenVersion = CurrentValueSubject<String,Never>("empty verified token")
    var sessionIdVersion = CurrentValueSubject<String,Never>("empty session id")
    
    var authorizationInfo:AuthWithLogin {
        let authStruct:AuthWithLogin = AuthWithLogin(username: username, password: password, requestToken: self.requestToken)
        return authStruct
    }
    
    override init(){
        super.init()
        //сверяем введенные данные с сохраненными паролями
        //тут pipeline работает и сохраняются свойства
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
        createRequest(urlString: URLConstans.requestTokenLink, typeOfData: RequestToken.self)
            .map { $0.requestToken}
            .sink { completion in
                if case let .failure(error) = completion {
                    self.errorMessage = "ошибка при попытке получить request token"
                    self.isError = true  }
                else if case .finished = completion {
                    print("finished")
                }
            } receiveValue: { value in
                self.requestToken = value
            }
        $requestToken
            .flatMap { token -> AnyPublisher<String,Never> in
                let authInfo = AuthWithLogin(username: self.username, password: self.password, requestToken: token)
                return self.createRequest(urlString: URLConstans.authWithLoginLink,params: authInfo ,typeOfData: RequestToken.self)
                    .map{ $0.requestToken }
                    .replaceError(with: "bad verified token")
                    .eraseToAnyPublisher()
            }
            .assign(to: \.verifiedToken, on: self)
            .store(in: &anyCancellables)


        // и вопрос - как можно построить пайплайн для функции logIn()
        // потому что оно как то не очень напоминает комбайн за сутью тогда
    }
    
    
     //тут начинается самое интересное - нихрена не работает, хотя должно
    // я так понимаю какая то проблема с асинхроностью действий
    //возможно назначить очередноть действий
    // хотя изначально у меня все сделано по аналогичному принципу, но не через комбайн
    // и все работает без проблем на ветке dev
    func logIn(){
            //используется для получения токена
            createRequest(urlString: URLConstans.requestTokenLink, typeOfData: RequestToken.self)
                .map({ requestToken in
                    return requestToken.requestToken
                })
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        self.errorMessage = "ошибка при попытке получить request token"
                        self.isError = true  }
                    else if case .finished = completion {
                        
                    }
                }, receiveValue: { value in
                    //передаем данные в свойство класса
                    self.requestToken = value
                })
            // а вот это по идее выводить данные за пределы области видимости закрытия
            // и это нормально работает для фетчинга фильмов в MovieFetcher
                .store(in: &anyCancellables)
            
            //подтверждаем токен с помощью логина и пароля
            //но здесь уже authWithLogin передает пустой токен и соответственно дальше все идет наперекосяк
            createRequest(urlString: URLConstans.authWithLoginLink, params: authorizationInfo,typeOfData: RequestToken.self)
                .map { $0.requestToken }
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        self.errorMessage = "ошибка при попытке получить подтвержденный request token"
                        self.isError = true  }
                    else if case .finished = completion {
                        //print("Request token after Auth successfully")
                    }
                }, receiveValue: { value in
                    self.verifiedToken = value
                    
                })
                .store(in: &anyCancellables)
            
            //получаем session id  с помощью подтвержденного токена
            createRequest(urlString: URLConstans.sessionIdLink, params: RequestToken(requestToken: verifiedToken),typeOfData: ResponseSessionId.self)
                .map{ $0.sessionId }
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        self.errorMessage = "ошибка при попытке получить session id"
                        self.isError = true        }
                    else if case .finished = completion {
                        //print("SessionId successfully")
                    }
                }, receiveValue: { value in
                    self.sessionId = value
                })
                .store(in: &anyCancellables)
    }
    
    func pipelineLogin(){
        $requestToken
            .flatMap { token -> AnyPublisher<String,Never> in
                return self.createRequest(urlString: URLConstans.authWithLoginLink,params: self.authorizationInfo ,typeOfData: RequestToken.self)
                    .map { $0.requestToken }
                    .replaceError(with: "bad verified token")
                    .eraseToAnyPublisher()
            }
            .assign(to: \.verifiedToken, on: self)
            .store(in: &anyCancellables)

    }
    
    func segmentedLogin(){
        getRequestToken()
    }
    
    private func getRequestToken(){
        createRequest(urlString: URLConstans.requestTokenLink, typeOfData: RequestToken.self)
            .map{ $0.requestToken}
            .sink { completion in
                if case let .failure(error) = completion {
                    self.errorMessage = "ошибка при попытке получить session id"
                    self.isError = true        }
                else if case .finished = completion {
                    //print("SessionId successfully")
                }
            } receiveValue: { value in
                self.requestToken = value
            }
            .store(in: &anyCancellables)

    }
    
    private func getVerifiedToken(){
        createRequest(urlString: URLConstans.authWithLoginLink, params: authorizationInfo,typeOfData: RequestToken.self)
            .map { $0.requestToken }
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    self.errorMessage = "ошибка при попытке получить подтвержденный request token"
                    self.isError = true  }
                else if case .finished = completion {
                    //print("Request token after Auth successfully")
                }
            }, receiveValue: { value in
                self.verifiedToken = value
                
            })
            .store(in: &anyCancellables)
    }
    
    
}
