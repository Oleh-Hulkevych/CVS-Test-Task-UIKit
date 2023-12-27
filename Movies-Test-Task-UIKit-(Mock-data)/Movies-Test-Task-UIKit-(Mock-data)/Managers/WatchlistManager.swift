//
//  WatchlistManager.swift
//  Movies-Test-Task-UIKit-(Mock-data)
//
//  Created by Oleh on 19.12.2023.
//

import Foundation

final class WatchlistManager {

    private var watchlistIDs: Set<Int> = []

    func isMovieInWatchlist(id: Int) -> Bool {
        watchlistIDs.contains(id)
    }
    
    func toggleWatchlistButton(id: Int) {
        if isMovieInWatchlist(id: id) {
            watchlistIDs.remove(id)
            print("📙: Movie removed from watchlist! / ID: \(id)")
        } else {
            watchlistIDs.insert(id)
            print("📗: Movie added to watchlist! / ID: \(id)")
        }
    }
}
