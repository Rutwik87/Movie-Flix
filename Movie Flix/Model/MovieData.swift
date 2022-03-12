//
//  MovieData.swift
//  Movie Flix
//
//  Created by Rutwik Shinde on 10/03/22.
//

import Foundation

struct MovieDataResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let voteAverage: Double
    let backdropPath: String
    let title: String
    let overview: String
    let posterPath: String
    
    enum CodingKeys: String, CodingKey {
        case voteAverage = "vote_average"
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case overview, title
    }
}
