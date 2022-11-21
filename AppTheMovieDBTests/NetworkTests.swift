//
//  NetworkTests.swift
//  AppTheMovieDBTests
//
//  Created by Вячеслав Гудзенко on 13.11.2022.
//

import XCTest
@testable import AppTheMovieDB

final class NetworkTests: XCTestCase {
    var network:Network!

    override func setUpWithError() throws {
        try super.setUpWithError()
        network = Network()
    }

    override func tearDownWithError() throws {
       network = nil
        try super.tearDownWithError()
    }

    func testCreateRequestWithoutParams() async throws {
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(URLConstans.apiKey)&language=en-US&page=1"
        _ = try await network.createRequest(urlString: urlString, typeOfData: Page.self)
        
        
    }

    

}
