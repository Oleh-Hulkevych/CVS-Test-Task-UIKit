//
//  MoviesCoordinator.swift
//  Movies-Test-Task-UIKit-(Mock-data)
//
//  Created by Oleh on 24.12.2023.
//

import UIKit

final class MoviesCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private let localJSONManager: LocalJSONManager
    private let watchlistManager: WatchlistManager
    private var moviesTableViewController: MoviesTableViewController?

    init(
        navigationController: UINavigationController,
        localJSONManager: LocalJSONManager,
        watchlistManager: WatchlistManager
    ){
        self.navigationController = navigationController
        self.localJSONManager = localJSONManager
        self.watchlistManager = watchlistManager
    }

    func start() {
        let moviesTableViewController = MoviesTableViewController(
            localJSONManager: localJSONManager,
            watchlistManager: watchlistManager
        )
        moviesTableViewController.moviesCoordinator = self
        navigationController.setViewControllers([moviesTableViewController], animated: false)
        self.moviesTableViewController = moviesTableViewController
    }

    func showMovieDetails(movieId: Int) {
        let movieDetailViewController = MovieDetailViewController(
            movieId: movieId,
            localJSONManager: localJSONManager,
            watchlistManager: watchlistManager
        )
        movieDetailViewController.delegate = self
        navigationController.pushViewController(movieDetailViewController, animated: true)
    }
}

// MARK: - Movie detail view controller delegates

extension MoviesCoordinator: MovieDetailViewControllerDelegate {
    func watchlistButtonDidTap(inMovie movieId: Int) {
        self.moviesTableViewController?.tableView.reloadData()
    }
}
