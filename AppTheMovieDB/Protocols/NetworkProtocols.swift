//
//  NetworkProtocols.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 05.11.2022.
//

import Foundation

protocol NetworkProtocol{
    func createRequest<T:Decodable,P:Encodable>(urlString:String, params:P, typeOfData: T.Type) async throws -> T
}


