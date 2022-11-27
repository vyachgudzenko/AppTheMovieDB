//
//  NetworkProtocols.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 05.11.2022.
//

import Foundation
import Combine

protocol NetworkCombineProtocol{
    func createRequest<T:Decodable,P:Encodable>(urlString:String, params:P, typeOfData: T.Type)  -> AnyPublisher<T,FetchError>
}
