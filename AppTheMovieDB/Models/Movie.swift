//
//  Movie.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 05.09.2022.
//

import Foundation

struct Collection:Codable{
    var id:Int
    var name:String
    var poster_path:String?
    var backdrop_path:String?
}

struct ProductionCompany:Codable,Hashable{
    var id:Int
    var logo_path:String?
    var name:String
    var origin_country:String
}

struct Genre:Codable{
    var id:Int
    var name:String
}

struct ProductionCountry:Codable{
    var iso_3166_1:String
    var name:String
}

struct SpokenLanguage:Codable{
    var english_name:String
    var iso_639_1:String
    var name:String
}

struct Movie:Codable{
    var adult:Bool
    var backdrop_path:String
    var belongs_to_collection:Collection?
    var budget:Int
    var genres:[Genre]
    var homepage:String
    var id:Int
    var imdb_id:String
    var original_language:String
    var original_title:String
    var overview:String
    var popularity:Double
    var poster_path:String?
    var production_companies:[ProductionCompany]
    var production_countries:[ProductionCountry]
    var release_date:String
    var revenue:Int
    var runtime:Int
    var spoken_languages:[SpokenLanguage]
    var status:String
    var tagline:String
    var title:String
    var video:Bool
    var vote_average:Double
    var vote_count:Int
    
    static let defaultMovie = Movie(adult: false, backdrop_path: "/bvpI11RJbE6lHSWCrhvNC1S1MtO.jpg", belongs_to_collection: Optional(Collection(id: 137697, name: "Finding Nemo Collection", poster_path: Optional("/xwggrEugjcJDuabIWvK2CpmK91z.jpg"), backdrop_path: Optional("/2hC8HHRUvwRljYKIcQDMyMbLlxz.jpg"))), budget: 94000000, genres: [Genre(id: 16, name: "Animation"), Genre(id: 10751, name: "Family")], homepage: "http://movies.disney.com/finding-nemo", id: 12, imdb_id: "tt0266543", original_language: "en", original_title: "Finding Nemo", overview: "Nemo, an adventurous young clownfish, is unexpectedly taken from his Great Barrier Reef home to a dentist\'s office aquarium. It\'s up to his worrisome father Marlin and a friendly but forgetful fish Dory to bring Nemo home -- meeting vegetarian sharks, surfer dude turtles, hypnotic jellyfish, hungry seagulls, and more along the way.", popularity: 127.433, poster_path: Optional("/eHuGQ10FUzK1mdOY69wF5pGgEf5.jpg"), production_companies: [ProductionCompany(id: 3, logo_path: Optional("/1TjvGVDMYsj6JBxOAkUHpPEwLf7.png"), name: "Pixar", origin_country: "US")], production_countries: [ProductionCountry(iso_3166_1: "US", name: "United States of America")], release_date: "2003-05-30", revenue: 940335536, runtime: 100, spoken_languages: [SpokenLanguage(english_name: "English", iso_639_1: "en", name: "English")], status: "Released", tagline: "There are 3.7 trillion fish in the ocean. They\'re looking for one.", title: "Finding Nemo", video: false, vote_average: 7.825, vote_count: 16745)
}
