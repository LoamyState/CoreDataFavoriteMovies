//
//  APIMovie.swift
//  CoreDataFavoriteMovies
//
//  Created by Parker Rushton on 11/5/22.
//

import Foundation

struct SearchResponse: Codable {
    let movies: [APIMovie]
    let totalResults: String
    let response: String
    
    enum CodingKeys: String, CodingKey {
        case movies = "Search"
        case totalResults
        case response = "Response"
    }
}

struct APIMovie: Codable, Identifiable, Hashable {
    let title: String
    let year: String
    let imdbID: String
    let posterURL: URL?
    
    var id: String { imdbID }

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case posterURL = "Poster"
    }

}

extension Movie {
    var posterURL: URL? {
        if let posterURLString = self.posterURLString, let url = URL(string: posterURLString) {
            return url
        } else {
            return nil
        }
    }
}
