//
//  LocalJSONManager.swift
//  Movies-Test-Task-UIKit-(Mock-data)
//
//  Created by Oleh on 19.12.2023.
//

import Foundation

final class LocalJSONManager {
    
    private let decoder = JSONDecoder()
    
    func wrapOnBackground<T, E: Error>(_ function: @escaping () -> Result<T, E>, completionOnMain completion: @escaping (Result<T, E>) -> Void) {
        DispatchQueue.global().async {
            let result = function()
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func loadMoviesFromJSON() -> Result<[Movie], Error> {
        guard let path = Bundle.main.path(forResource: "MoviesJSONData", ofType: "json") else {
            return .failure(NSError(domain: "File not found", code: 404, userInfo: nil))
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let movies = try decoder.decode([Movie].self, from: data)
            return .success(movies)
        } catch {
            return .failure(error)
        }
    }
    
    func loadMovieFromJSON(byId movieId: Int, completion: @escaping (Result<Movie, Error>) -> Void) {
        guard let path = Bundle.main.path(forResource: "MoviesJSONData", ofType: "json") else {
            completion(.failure(NSError(domain: "File not found", code: 404, userInfo: nil)))
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let movies = try decoder.decode([Movie].self, from: data)
            if let movie = movies.first(where: { $0.id == movieId }) {
                completion(.success(movie))
            } else {
                completion(.failure(NSError(domain: "Movie not found", code: 404, userInfo: nil)))
            }
        } catch {
            completion(.failure(error))
        }
    }
}
