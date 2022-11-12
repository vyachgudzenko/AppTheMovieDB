//
//  MovieFetcherTests.swift
//  AppTheMovieDBTests
//
//  Created by Вячеслав Гудзенко on 12.11.2022.
//

import XCTest
@testable import AppTheMovieDB

final class MovieFetcherTests: XCTestCase {
    var movieFetcher:MovieFetcher!
    var movie:Movie!
    

    override func setUpWithError() throws {
        try super.setUpWithError()
        movieFetcher = MovieFetcher()
        movie = Movie(
            backdropPath: "/bvpI11RJbE6lHSWCrhvNC1S1MtO.jpg",
            budget: 94000000, genres: [Movie.Genre(id: 16, name: "Animation"), Movie.Genre(id: 10751, name: "Family")],
            id: 12,
            overview: "Nemo, an adventurous young clownfish, is unexpectedly taken from his Great Barrier Reef home to a dentist\'s office aquarium. It\'s up to his worrisome father Marlin and a friendly but forgetful fish Dory to bring Nemo home -- meeting vegetarian sharks, surfer dude turtles, hypnotic jellyfish, hungry seagulls, and more along the way.",
            posterPath: Optional("/eHuGQ10FUzK1mdOY69wF5pGgEf5.jpg"),
            releaseDate: "2003-05-30",
            revenue: 940335536,
            runtime: 100,
            status: "Released",
            tagline: "There are 3.7 trillion fish in the ocean. They\'re looking for one.",
            title: "Finding Nemo",
            voteAverage: 7.825)
    }

    override func tearDownWithError() throws {
        movieFetcher = nil
        movie = nil
        try super.tearDownWithError()
    }

    func testFetchPage() async throws {
        let testMovies = try await movieFetcher.fetchPage()
        XCTAssertFalse(testMovies.isEmpty,"checking if an empty array has not arrived")
    }
    
    func testFetchMovie() async throws{
        let id = 12
        try await movieFetcher.fetchMovie(id: id)
        XCTAssertTrue(movieFetcher.currentMovie.id == movie.id,"checking if it works properly fetchMovie")
    }
    
    func testAddNextPage() async throws{
        movieFetcher.movies = try await movieFetcher.fetchPage()
        let countBeforePageRefresh = movieFetcher.movies.count
        movieFetcher.numberOfPage += 1
        try await movieFetcher.addNextPage()
        let countAfterPageRefresh = movieFetcher.movies.count
        XCTAssertGreaterThan(countAfterPageRefresh, countBeforePageRefresh,"does it add new elements func addNextPage")
    }

    

}
