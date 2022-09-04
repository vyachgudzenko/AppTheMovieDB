//
//  Page&PreviewModels.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 05.09.2022.
//

import Foundation
struct Preview:Codable,Hashable{
    var adult:Bool
    var backdrop_path:String
    var genre_ids:[Int]
    var id:Int
    var original_language:String
    var original_title:String
    var overview:String
    var popularity:Double
    var poster_path:String
    var release_date:String
    var title:String
    var video:Bool
    var vote_average:Double
    var vote_count:Int
}

struct Page:Codable{
    var page:Int
    var results:[Preview]
    var total_pages:Int
    var total_results:Int
}
