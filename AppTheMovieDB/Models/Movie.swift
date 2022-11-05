//
//  Movie.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 05.09.2022.
//

import Foundation


struct Movie:Decodable{
    var backdropPath:String
    var budget:Int
    var genres:[Genre]
    let id:Int
    var overview:String
    var posterPath:String?
    var releaseDate:String
    var revenue:Int
    var runtime:Int
    var status:String
    var tagline:String
    var title:String
    var voteAverage:Double
    
    static let defaultMovie = Movie(
        backdropPath: "/bvpI11RJbE6lHSWCrhvNC1S1MtO.jpg",
        budget: 94000000, genres: [Genre(id: 16, name: "Animation"), Genre(id: 10751, name: "Family")],
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
    
    enum CodingKeys: String, CodingKey{
        case backdropPath = "backdrop_path"
        case budget
        case genres
        case id
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case revenue
        case runtime
        case status
        case tagline
        case title
        case voteAverage = "vote_average"
    }
}

extension Movie{
    struct Genre:Codable,Hashable{
        var id:Int
        var name:String
    }

}
