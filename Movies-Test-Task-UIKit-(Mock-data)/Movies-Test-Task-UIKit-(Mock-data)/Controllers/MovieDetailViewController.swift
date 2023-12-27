//
//  MovieDetailViewController.swift
//  Movies-Test-Task-UIKit-(Mock-data)
//
//  Created by Oleh on 21.12.2023.
//

import UIKit
import SafariServices

protocol MovieDetailViewControllerDelegate: AnyObject {
    func watchlistButtonDidTap(inMovie movieId: Int)
}

final class MovieDetailViewController: UIViewController {
    
    // MARK: UI Elements
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView = UIView()
    private lazy var topDividerView = DividerView(orientation: .horizontal)
    private lazy var headerInfoDividerView = DividerView(orientation: .horizontal)
    private lazy var movieDescriptionDividerView = DividerView(orientation: .horizontal)
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var headerButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 5
        imageView.layer.borderWidth = 0.8
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var imageShadowContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 2, height: 7)
        view.layer.shadowRadius = 5
        return view
    }()
    
    private lazy var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.textColor = .softBlack
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var movieRatingLabel = MovieRatingLabel()
    
    private lazy var shortDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .softBlack
        label.text = "Short description"
        return label
    }()
    
    private lazy var movieDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .softGray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var detailsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .softBlack
        label.text = "Details"
        return label
    }()
    
    private lazy var watchlistButton: WatchlistButton = {
        let button = WatchlistButton()
        button.addTarget(self, action: #selector(watchlistButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var watchTrailerButton: WatchTrailerButton = {
        let button = WatchTrailerButton()
        button.addTarget(self, action: #selector(watchTrailerButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var movieGenresLabel = MovieDetailLabel(title: "Genre")
    private lazy var movieReleasedDateLabel = MovieDetailLabel(title: "Released date")
    private lazy var scrollViewRefreshControl = UIRefreshControl()
    
    // MARK: Properties & initialization
    
    weak var delegate: MovieDetailViewControllerDelegate?
    private var movie: Movie?
    private let movieId: Int
    private let localJSONManager: LocalJSONManager
    private let watchlistManager: WatchlistManager
    private var movieImageViewHeightConstraint: NSLayoutConstraint?
    private var movieImageViewWidthConstraint: NSLayoutConstraint?
    
    init(movieId: Int, localJSONManager: LocalJSONManager, watchlistManager: WatchlistManager) {
        self.movieId = movieId
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
        setupUI()
        themeStyle()
        configureRefreshControl()
        fetchMovie(id: movieId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: Network methods
    
    private func fetchMovie(id movieId: Int) {
        localJSONManager.loadMovieFromJSON(byId: movieId) { result in
            switch result {
            case .success(let movie):
                self.movie = movie
                self.updateMovieDetails(with: movie)
            case .failure(let error):
                self.showAlert(
                    title: "Ups!",
                    message: error.localizedDescription,
                    cancelButtonTitle: "Ok",
                    actionButtonTitle: "Retry?"
                ) {
                    self.fetchMovie(id: movieId)
                }
            }
        }
    }
    
    // MARK: Configure UI
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func configureRefreshControl() {
        scrollViewRefreshControl.addTarget(self, action: #selector(refreshControlDidDrag), for: .valueChanged)
        scrollView.refreshControl = scrollViewRefreshControl
    }
    
    @objc
    private func refreshControlDidDrag() {
        fetchMovie(id: movieId)
        self.perform(#selector(refreshControlDidFinishRefreshing), with: nil, afterDelay: 1)
    }
    
    @objc
    private func refreshControlDidFinishRefreshing() {
        scrollViewRefreshControl.endRefreshing()
    }
    
    // MARK: Update UI methods
    
    private func updateMovieDetails(with movie: Movie) {
        movieImageView.image = UIImage(named: movie.image)
        setImageSize(with: movie.image)
        movieTitleLabel.text = movie.title
        movieRatingLabel.set(rating: movie.rating)
        movieDescriptionLabel.text = movie.description
        movieGenresLabel.set(details: movie.genre.combinedString())
        let releasedDate = movie.releasedDate.convertStringDate(
            fromFormat: "yyyy-MM-dd",
            toFormat: "yyyy, d MMMM"
        )
        movieReleasedDateLabel.set(details: releasedDate)
        updateWatchlistButton(inMovie: movie.id)
    }
    
    private func setImageSize(with imageName: String) {
        guard let screenWidth = UIScreen.current?.bounds.width else { return }
        if let image = UIImage(named: imageName) {
            let aspectRatio = image.size.width / image.size.height
            let imageViewWidth = screenWidth / 2.75
            let imageViewHeight = imageViewWidth / aspectRatio
            movieImageViewHeightConstraint?.constant = imageViewHeight
            movieImageViewWidthConstraint?.constant = imageViewWidth
        }
    }
    
    @objc
    private func watchlistButtonDidTap() {
        guard let movie else { return }
        delegate?.watchlistButtonDidTap(inMovie: movie.id)
        watchlistManager.toggleWatchlistButton(id: movie.id)
        updateWatchlistButton(inMovie: movie.id)
    }
    
    private func updateWatchlistButton(inMovie movieId: Int) {
        let isInWatchlist = watchlistManager.isMovieInWatchlist(id: movieId)
        let buttonTitle = isInWatchlist ? "REMOVE FROM WATCHLIST" : "+ ADD TO WATCHLIST"
        watchlistButton.set(title: buttonTitle)
    }
    
    @objc
    private func watchTrailerButtonDidTap() {
        guard let movie else { return }
        let trailerUrl = movie.trailerLink
        presentYouTubeAppOrSafariViewController(withUrl: trailerUrl)
    }
    
    private func presentYouTubeAppOrSafariViewController(withUrl stringUrl: String) {
        guard
            let url = URL(string: stringUrl),
            let youtubeUrl = extractYouTubeVideo(from: stringUrl),
            let appURL = URL(string: "youtube://watch?v=\(youtubeUrl)") 
        else {
            return
        }
        // Here, we will open the video in the YouTube app if it is available on the iPhone.
        // YouTube added to Queried URL Schemes in plist...
        // Perfectly working on a real device...
        // } else {
        // We present - Safari View Controller...
        if UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else {
            let safariViewController = SFSafariViewController(url: url)
            safariViewController.modalPresentationStyle = .overFullScreen
            present(safariViewController, animated: true, completion: nil)
        }
    }

    private func extractYouTubeVideo(from url: String) -> String? {
        if let videoURL = URL(string: url),
           let queryItems = URLComponents(url: videoURL, resolvingAgainstBaseURL: true)?.queryItems {
            for queryItem in queryItems {
                if queryItem.name == "v" {
                    return queryItem.value
                }
            }
        }
        return nil
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
            navigationController?.navigationBar.tintColor = UIColor.softBlack
            movieTitleLabel.textColor = .softBlack
            movieRatingLabel.set(color: .softBlack)
            imageShadowContainerView.layer.shadowColor = UIColor.softBlack.cgColor
            shortDescriptionLabel.textColor = .softBlack
            detailsLabel.textColor = .softBlack
            movieGenresLabel.set(color: .softBlack)
            movieReleasedDateLabel.set(color: .softBlack)
            watchlistButton.set(
                titleColor: .softBlack,
                backgroundColor: .softGray.withAlphaComponent(0.5)
            )
            watchTrailerButton.set(color: .softBlack)
            scrollViewRefreshControl.tintColor = .softBlack
        } else {
            view.backgroundColor = .black
            navigationController?.navigationBar.tintColor = UIColor.softBlue
            movieTitleLabel.textColor = .softBlue
            movieRatingLabel.set(color: .softBlue)
            imageShadowContainerView.layer.shadowColor = UIColor.softBlue.withAlphaComponent(0.25).cgColor
            shortDescriptionLabel.textColor = .softBlue
            detailsLabel.textColor = .softBlue
            movieGenresLabel.set(color: .softBlue)
            movieReleasedDateLabel.set(color: .softBlue)
            watchlistButton.set(
                titleColor: .softBlack,
                backgroundColor: .softBlue
            )
            watchTrailerButton.set(color: .softBlue)
            scrollViewRefreshControl.tintColor = .softBlue
        }
    }
    
    // MARK: Auto Layout
    
    private func setupUI() {
        guard let screenWidth = UIScreen.current?.bounds.width else { return }
        let imageViewContainer = UIView()
        let headerInfoViewContainer = UIView()
        
        view.addSubview(scrollView)
        scrollView.pin(to: self.view)
        scrollView.addSubview(contentView)
        contentView.pin(to: scrollView)
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.addSubview(topDividerView)
        
        topDividerView.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            trailing: contentView.trailingAnchor
        )
        
        contentView.addSubview(mainStackView)
        mainStackView.anchor(
            top: topDividerView.bottomAnchor,
            leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor,
            padding: .init(top: 22.5, left: 20, bottom: 22.5, right: 20)
        )
        
        [headerStackView,
         headerInfoDividerView,
         shortDescriptionLabel,
         movieDescriptionLabel,
         movieDescriptionDividerView,
         detailsLabel,
         movieGenresLabel,
         movieReleasedDateLabel].forEach {
            mainStackView.addArrangedSubview($0)
        }
        
        mainStackView.setCustomSpacing(22.5, after: headerStackView)
        mainStackView.setCustomSpacing(15, after: headerInfoDividerView)
        mainStackView.setCustomSpacing(10, after: shortDescriptionLabel)
        mainStackView.setCustomSpacing(15, after: movieDescriptionLabel)
        mainStackView.setCustomSpacing(15, after: movieDescriptionDividerView)
        mainStackView.setCustomSpacing(10, after: detailsLabel)
        mainStackView.setCustomSpacing(5, after: movieGenresLabel)
        
        [imageViewContainer, headerInfoViewContainer].forEach {
            headerStackView.addArrangedSubview($0)
        }
        
        imageViewContainer.anchor(size: .init(width: 0, height: screenWidth / 1.85))
        imageViewContainer.addSubview(imageShadowContainerView)
        
        imageShadowContainerView.anchor(
            leading: imageViewContainer.leadingAnchor,
            trailing: imageViewContainer.trailingAnchor
        )
        
        imageShadowContainerView.centerYAnchor.constraint(equalTo: imageViewContainer.centerYAnchor).isActive = true
        imageShadowContainerView.addSubview(movieImageView)
        movieImageView.pin(to: imageShadowContainerView)
        movieImageViewHeightConstraint = movieImageView.heightAnchor.constraint(equalToConstant: imageShadowContainerView.bounds.height)
        movieImageViewWidthConstraint = movieImageView.widthAnchor.constraint(equalToConstant: imageShadowContainerView.bounds.width)
        movieImageViewHeightConstraint?.isActive = true
        movieImageViewWidthConstraint?.isActive = true
        
        headerInfoViewContainer.centerYAnchor.constraint(equalTo: headerStackView.centerYAnchor).isActive = true
        headerInfoViewContainer.addSubview(movieRatingLabel)
        headerInfoViewContainer.addSubview(movieTitleLabel)
        
        movieRatingLabel.anchor(
            top: headerInfoViewContainer.topAnchor,
            trailing: headerInfoViewContainer.trailingAnchor,
            padding: .init(top: 10, left: 0, bottom: 0, right: 0),
            size: .init(width: 55, height: 0)
        )
        
        movieTitleLabel.anchor(
            top: headerInfoViewContainer.topAnchor,
            leading: headerInfoViewContainer.leadingAnchor,
            trailing: movieRatingLabel.leadingAnchor,
            padding: .init(top: 10, left: 20, bottom: 0, right: 0)
        )
        
        headerInfoViewContainer.addSubview(headerButtonsStackView)
        headerButtonsStackView.anchor(
            top: movieTitleLabel.bottomAnchor,
            leading: headerInfoViewContainer.leadingAnchor,
            trailing: headerInfoViewContainer.trailingAnchor,
            padding: .init(top: 20, left: 20, bottom: 0, right: 0)
        )
        
        [watchlistButton, watchTrailerButton].forEach {
            headerButtonsStackView.addArrangedSubview($0)
        }
        
        headerButtonsStackView.setCustomSpacing(20, after: watchlistButton)
    }
}
