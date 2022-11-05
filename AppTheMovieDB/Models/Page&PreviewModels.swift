//
//  Page&PreviewModels.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 05.09.2022.
//

import Foundation

struct Page:Decodable{
    var page:Int
    var results:[Preview]
    var totalPages:Int
    var totalResults:Int
    
    enum CodingKeys: String, CodingKey{
        case page = "page"
        case results = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

extension Page{
    struct Preview:Decodable,Hashable{
        let id:Int
        var posterPath:String
        var title:String
        
        enum CodingKeys: String, CodingKey{
            case id = "id"
            case posterPath = "poster_path"
            case title = "title"
        }
    }
}
