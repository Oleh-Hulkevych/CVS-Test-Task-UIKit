//
//  AppCoordinator.swift
//  Movies-Test-Task-UIKit-(Mock-data)
//
//  Created by Oleh on 24.12.2023.
//

import UIKit

protocol Coordinator: AnyObject {
    func start()
}

final class AppCoordinator: Coordinator {
    
    private let window: UIWindow
    private var navigationController: UINavigationController?
    private var moviesCoordinator: MoviesCoordinator?
    private let localJSONManager = LocalJSONManager()
    private let watchlistManager = WatchlistManager()

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.navigationController = navigationController
        showMovies()
    }

    private func showMovies() {
        guard let navigationController else { return }
        let moviesCoordinator = MoviesCoordinator(
            navigationController: navigationController,
            localJSONManager: localJSONManager,
            watchlistManager: watchlistManager
        )
        moviesCoordinator.start()
        self.moviesCoordinator = moviesCoordinator
    }
}
