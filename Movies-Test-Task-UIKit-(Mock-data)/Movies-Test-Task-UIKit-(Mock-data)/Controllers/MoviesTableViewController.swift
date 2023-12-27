//
//  ViewController.swift
//  Movies-Test-Task-UIKit-(Mock-data)
//
//  Created by Oleh on 19.12.2023.
//

import UIKit

final class MoviesTableViewController: UITableViewController {
    
    // MARK: UI Elements
    
    private lazy var customSortButton: CustomSortButton = {
        let button = CustomSortButton()
        button.addTarget(self, action: #selector(sortBarButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableFooterView = UIView()
    private lazy var tableViewRefreshControl = UIRefreshControl()
    
    private lazy var tableFooterTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .softGray
        label.textAlignment = .center
        label.numberOfLines = 3
        return label
    }()
    
    // MARK: Properties & initialization
    
    var moviesCoordinator: MoviesCoordinator?
    private let localJSONManager: LocalJSONManager
    private let watchlistManager: WatchlistManager
    private var movies = [Movie]()
    
    init(localJSONManager: LocalJSONManager, watchlistManager: WatchlistManager) {
        self.localJSONManager = localJSONManager
        self.watchlistManager = watchlistManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()
        configureTableViewFooter()
        configureRefreshControl()
        themeStyle()
        fetchMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    // MARK: Network methods
    
    private func fetchMovies() {
        localJSONManager.wrapOnBackground(localJSONManager.loadMoviesFromJSON) { result in
            switch result {
            case .success(let movies):
                self.movies = movies
                self.showTableFooterView(movies: movies)
                self.tableView.reloadData()
            case .failure(let error):
                self.showAlert(
                    title: "Ups!",
                    message: error.localizedDescription,
                    cancelButtonTitle: "Ok",
                    actionButtonTitle: "Retry?"
                ) {
                    self.fetchMovies()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: Table view data sources
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reusableID, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        let movie = movies[indexPath.row]
        let movieWatchlistState = watchlistManager.isMovieInWatchlist(id: movie.id)
        let cellState = MovieCellStateModel(isAddedToWatchlist: movieWatchlistState)
        cell.setPost(with: movie, cellState: cellState)
        return cell
    }
    
    // MARK: Table view delegates
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieId = movies[indexPath.row].id
        hideNavigationTitle()
        moviesCoordinator?.showMovieDetails(movieId: movieId)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Theme configurations
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        themeStyle()
    }
    
    private func themeStyle() {
        let interfaceStyle = traitCollection.userInterfaceStyle
        if interfaceStyle == .light {
            view.backgroundColor = .white
            tableViewRefreshControl.tintColor = .softBlack
            setNavigationBarColor(.softBlack)
            customSortButton.set(color: .softBlack)
            updateSortAlertControllerColors()
        } else {
            view.backgroundColor = .black
            tableViewRefreshControl.tintColor = .softBlue
            setNavigationBarColor(.softBlue)
            customSortButton.set(color: .softBlue)
            updateSortAlertControllerColors()
        }
    }
    
    private func setNavigationBarColor(_ color: UIColor) {
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: color,
            .font: UIFont.boldSystemFont(ofSize: 18)
        ]
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: color,
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
    }
    
    private func updateSortAlertControllerColors() {
        let interfaceStyle = traitCollection.userInterfaceStyle
        let actionColor = interfaceStyle == .light ? UIColor.softBlack : UIColor.softBlue
        if let sortAlertController = presentedViewController as? UIAlertController {
            for action in sortAlertController.actions {
                action.setValue(actionColor, forKey: "titleTextColor")
            }
        }
    }
    
    // MARK: Configure UI
    
    private func configureNavigationBar() {
        navigationItem.title = "Movies"
        navigationController?.navigationBar.prefersLargeTitles = true
        configureCustomNavigationBarSortButton()
        configureNavigationBarBackButton()
    }
    
    private func configureCustomNavigationBarSortButton() {
        let rightBarButton = UIBarButtonItem(customView: customSortButton)
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func configureNavigationBarBackButton() {
        let backButton = UIBarButtonItem()
        backButton.title = "Movies"
        navigationItem.backBarButtonItem = backButton
    }
    
    private func hideNavigationTitle() {
        if let navigationBar = navigationController?.navigationBar {
            UIView.transition(with: navigationBar, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.navigationItem.title = ""
            }, completion: nil)
        }
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.reusableID)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        tableView.separatorColor = UIColor.softGray
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        tableView.delaysContentTouches = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    private func configureTableViewFooter() {
        guard let screenWidth = UIScreen.current?.bounds.width else { return }
        tableFooterView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 70)
        tableFooterView.addSubview(tableFooterTextLabel)
        tableFooterTextLabel.frame = tableFooterView.bounds
    }
    
    private func showTableFooterView(movies: [Movie]) {
        if !movies.isEmpty {
            self.tableView.tableFooterView = tableFooterView
            tableFooterTextLabel.text = "No more movies\n available."
        }
    }
    
    @objc
    private func sortBarButtonTapped() {
        showSortAlertController()
    }
    
    private func showSortAlertController() {
        let sortAlertController = UIAlertController(title: "Sort movies by:", message: nil, preferredStyle: .actionSheet)
        let interfaceStyle = traitCollection.userInterfaceStyle
        let actionColor = interfaceStyle == .light ? UIColor.softBlack : UIColor.softBlue
        
        let titleAction = UIAlertAction(title: "Title", style: .default) {[weak self] _ in
            guard let self = self else { return }
            let sortedByTitle = self.movies.sorted { $0.title > $1.title }
            self.movies = sortedByTitle
            self.tableView.reloadData()
        }
        titleAction.setValue(actionColor, forKey: "titleTextColor")
        
        let releasedDateAction = UIAlertAction(title: "Released date", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let sortedByRating = self.movies.sorted { $0.releasedDate > $1.releasedDate }
            self.movies = sortedByRating
            self.tableView.reloadData()
        }
        releasedDateAction.setValue(actionColor, forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(actionColor, forKey: "titleTextColor")
        
        sortAlertController.addAction(titleAction)
        sortAlertController.addAction(releasedDateAction)
        sortAlertController.addAction(cancelAction)
        present(sortAlertController, animated: true, completion: nil)
    }
    
    private func configureRefreshControl() {
        tableViewRefreshControl.addTarget(self, action: #selector(refreshControlDidDrag), for: .valueChanged)
        tableView.refreshControl = tableViewRefreshControl
    }
    
    @objc
    private func refreshControlDidDrag(send: UIRefreshControl) {
        fetchMovies()
        self.perform(#selector(refreshControlDidFinishRefreshing), with: nil, afterDelay: 1)
    }
    
    @objc
    private func refreshControlDidFinishRefreshing() {
        tableViewRefreshControl.endRefreshing()
    }
}

// MARK: - Post Cell delegates

extension MoviesTableViewController: MovieTableViewCellDelegate {
    func watchlistMarkButtonTapped(inMovie movieId: Int) {
        showRemoveFromWatchlistAlertController(forMovie: movieId)
    }
    
    private func showRemoveFromWatchlistAlertController(forMovie movieId: Int) {
        let removeFromWatchlistController = UIAlertController(title: "Remove movie from watchlist?", message: nil, preferredStyle: .actionSheet)
        
        let removeMovieFromWatchlistAction = UIAlertAction(title: "Remove", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.watchlistButtonTapped(inMovie: movieId)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let interfaceStyle = traitCollection.userInterfaceStyle
        let actionColor = interfaceStyle == .light ? UIColor.softBlack : UIColor.softBlue
        
        removeMovieFromWatchlistAction.setValue(actionColor, forKey: "titleTextColor")
        cancelAction.setValue(actionColor, forKey: "titleTextColor")
        
        removeFromWatchlistController.addAction(removeMovieFromWatchlistAction)
        removeFromWatchlistController.addAction(cancelAction)
        present(removeFromWatchlistController, animated: true, completion: nil)
    }
    
    private func watchlistButtonTapped(inMovie movieId: Int) {
        watchlistManager.toggleWatchlistButton(id: movieId)
        updateWatchlistButton(forMovieId: movieId)
    }
    
    private func updateWatchlistButton(forMovieId movieId: Int) {
        if let index = movies.firstIndex(where: { $0.id == movieId }),
           let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? MovieTableViewCell {
            let movieWatchlistState = watchlistManager.isMovieInWatchlist(id: movieId)
            let cellState = MovieCellStateModel(isAddedToWatchlist: movieWatchlistState)
            cell.setPost(with: movies[index], cellState: cellState)
        }
    }
}
