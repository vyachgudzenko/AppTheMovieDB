//
//  AppTheMovieDBApp.swift
//  AppTheMovieDB
//
//  Created by Вячеслав Гудзенко on 05.09.2022.
//

import SwiftUI

@main
struct AppTheMovieDBApp: App {
    @StateObject private var movieFetcher = MovieFetcher()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(movieFetcher)
        }
    }
}
