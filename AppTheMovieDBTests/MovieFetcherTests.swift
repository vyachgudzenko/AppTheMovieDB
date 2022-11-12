//
//  MovieFetcherTests.swift
//  AppTheMovieDBTests
//
//  Created by Вячеслав Гудзенко on 12.11.2022.
//

import XCTest
@testable import AppTheMovieDB

final class MovieFetcherTests: XCTestCase {
    var authorizationVM:AuthoraizationViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        authorizationVM = AuthoraizationViewModel()
    }

    override func tearDownWithError() throws {
        authorizationVM = AuthoraizationViewModel()
        try super.tearDownWithError()
    }

    func testExample() async throws {
        try await authorizationVM.logIn()
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            
        }
    }

}
