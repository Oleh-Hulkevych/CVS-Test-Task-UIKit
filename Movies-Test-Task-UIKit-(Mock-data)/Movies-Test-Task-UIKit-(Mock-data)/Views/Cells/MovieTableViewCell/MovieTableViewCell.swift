//
//  MovieTableViewCell.swift
//  Movies-Test-Task-UIKit-(Mock-data)
//
//  Created by Oleh on 19.12.2023.
//

import UIKit

protocol MovieTableViewCellDelegate: AnyObject {
    func watchlistMarkButtonTapped(inMovie movieId: Int)
}

final class MovieTableViewCell: UITableViewCell {

    // MARK: UI Elements
    
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
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .softBlack
        label.numberOfLines = 3
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var movieInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .softGray
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var watchlistMarkButton: HighlightedButton = {
        let button = HighlightedButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        button.setTitleColor(.softBlack, for: .normal)
        button.setTitle("ON MY WATCHLIST", for: .normal)
        button.contentHorizontalAlignment = .leading
        button.sizeToFit()
        button.addTarget(self, action: #selector(watchlistMarkButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var movieStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var movieInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()
    
    // MARK: Properties & initialization
    
    static let reusableID = "MovieTableViewCell"
    weak var delegate: MovieTableViewCellDelegate?
    private var movieId: Int?
    private var movieImageViewHeightConstraint: NSLayoutConstraint?
    private var movieImageViewWidthConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Cell state configurations
    
    func setPost(with movie: Movie, cellState: MovieCellStateModel) {
        movieId = movie.id
        movieImageView.image = UIImage(named: movie.image)
        setImageSize(with: movie.image)
        movieTitleLabel.text = movie.title
        movieInfoLabel.text = "\(movie.duration) - \(movie.genre.combinedString())"
        watchlistMarkButton.isHidden = !cellState.isAddedToWatchlist
    }
    
    private func setImageSize(with imageName: String) {
        guard let screenWidth = UIScreen.current?.bounds.width else { return }
        if let image = UIImage(named: imageName) {
            let aspectRatio = image.size.width / image.size.height
            let imageViewWidth = screenWidth / 3.5
            let imageViewHeight = imageViewWidth / aspectRatio
            movieImageViewHeightConstraint?.constant = imageViewHeight
            movieImageViewWidthConstraint?.constant = imageViewWidth
        }
    }
    
    // MARK: Action configurations
    
    @objc
    private func watchlistMarkButtonTapped() {
        guard let movieId else { return }
        delegate?.watchlistMarkButtonTapped(inMovie: movieId)
    }
        
    // MARK: Theme configurations
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        themeStyleDidChange()
    }
    
    private func themeStyleDidChange() {
        let interfaceStyle = traitCollection.userInterfaceStyle
        if interfaceStyle == .light {
            movieTitleLabel.textColor = .softBlack
            watchlistMarkButton.setTitleColor(.softBlack, for: .normal)
            imageShadowContainerView.layer.shadowColor = UIColor.softBlack.cgColor
        } else {
            movieTitleLabel.textColor = .softBlue
            watchlistMarkButton.setTitleColor(.softBlue, for: .normal)
            imageShadowContainerView.layer.shadowColor = UIColor.softBlue.withAlphaComponent(0.25).cgColor
        }
    }

    // MARK: Auto Layout
    
    private func setupUI() {
        
        guard let screenWidth = UIScreen.current?.bounds.width else { return }
        let imageViewContainer = UIView()
        let infoViewContainer = UIView()
        
        contentView.addSubview(movieStackView)
        movieStackView.pin(to: contentView)
        
        [imageViewContainer, infoViewContainer].forEach {
            movieStackView.addArrangedSubview($0)
        }
        
        imageViewContainer.anchor(size: .init(width: 0, height: screenWidth / 2 + 10))
        imageViewContainer.addSubview(imageShadowContainerView)
        imageShadowContainerView.anchor(
            leading: imageViewContainer.leadingAnchor,
            trailing: imageViewContainer.trailingAnchor,
            padding: .init(top: 0, left: 20, bottom: 0, right: 20)
        )
        imageShadowContainerView.centerYAnchor.constraint(equalTo: imageViewContainer.centerYAnchor).isActive = true
        imageShadowContainerView.addSubview(movieImageView)
        movieImageView.pin(to: imageShadowContainerView)
        movieImageViewHeightConstraint = movieImageView.heightAnchor.constraint(equalToConstant: bounds.height)
        movieImageViewWidthConstraint = movieImageView.widthAnchor.constraint(equalToConstant: bounds.width)
        movieImageViewHeightConstraint?.isActive = true
        movieImageViewWidthConstraint?.isActive = true
        
        infoViewContainer.centerYAnchor.constraint(equalTo: movieStackView.centerYAnchor).isActive = true
        infoViewContainer.addSubview(movieInfoStackView)
        movieInfoStackView.centerYAnchor.constraint(equalTo: infoViewContainer.centerYAnchor).isActive = true
        movieInfoStackView.anchor(
            leading: infoViewContainer.leadingAnchor,
            trailing: infoViewContainer.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: 10)
        )
        
        [movieTitleLabel, movieInfoLabel, watchlistMarkButton].forEach {
            movieInfoStackView.addArrangedSubview($0)
        }
        
        movieInfoStackView.setCustomSpacing(7, after: movieTitleLabel)
        movieInfoStackView.setCustomSpacing(20, after: movieInfoLabel)
    }
}
