//
//  MovieController.swift
//  CoreDataFavoriteMovies
//
//  Created by Parker Rushton on 11/1/22.
//

import Foundation
import CoreData

class MovieController {
    static let shared = MovieController()
    
    private let apiController = MovieAPIController()
    private var viewContext = PersistenceController.shared.viewContext
    
    func fetchMovies(with searchTerm: String) async throws -> [APIMovie] {
        return try await apiController.fetchMovies(with: searchTerm)
    }
    
    func favoriteMovie(_ movie: APIMovie) {
        let favoritedMovie = Movie(context: viewContext)
        favoritedMovie.title = movie.title
        favoritedMovie.id = movie.id
        favoritedMovie.imdbID = movie.imdbID
        favoritedMovie.year = movie.year
        favoritedMovie.posterURLString = movie.posterURL?.absoluteString ?? ""
        try? save()
    }
    
    func favoriteMovie(from movie: APIMovie) -> Movie? {
        let fetchRequest = Movie.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "imdbID == %@", movie.imdbID)
        if let results = try? viewContext.fetch(fetchRequest) {
            return results.first
        } else {
            return nil
        }
    }
    
    func unfavoriteMovie(_ movie: Movie) {
        viewContext.delete(movie)
        try? save()
    }
    
    func fetchFavorites(with searchTerm: String) throws -> [Movie]? {
        let fetchRequest = Movie.fetchRequest()
        
        if !searchTerm.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "title CONTAINS[c] %@", searchTerm)
        }
        
        let results = try viewContext.fetch(fetchRequest)
        
        return results
    }
    
    func save() throws {
        try viewContext.save()
    }
    
}
