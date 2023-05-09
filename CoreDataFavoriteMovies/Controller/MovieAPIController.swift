//
//  MovieAPIController.swift
//  CoreDataFavoriteMovies
//
//  Created by Parker Rushton on 11/1/22.
//

import Foundation

enum APIError: Error, LocalizedError {
    case responseFailed
}

class MovieAPIController {
    
    let baseURL = URL(string: "http://www.omdbapi.com/")!
    let apiKey = "fill in your api key here"
    
    func fetchMovies(with searchTerm: String) async throws -> [APIMovie] {
        var components = URLComponents.init(string: "http://www.omdbapi.com/")!
        let queryDictionary: [String: String] = [
            "apikey": "e718dfd9",
            "s": searchTerm
        ]
        components.queryItems = queryDictionary.map( { URLQueryItem(name: $0.key, value: $0.value) } )
        
        let url = components.url!
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw APIError.responseFailed
        }
        
        let jsonDecoder = JSONDecoder()
        let movieResults = try jsonDecoder.decode(SearchResponse.self, from: data)
        
        return movieResults.movies
    }
    
}
