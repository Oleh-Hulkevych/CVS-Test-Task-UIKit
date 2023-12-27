//
//  MovieRatingLabel.swift
//  Movies-Test-Task-UIKit-(Mock-data)
//
//  Created by Oleh on 22.12.2023.
//

import UIKit

final class MovieRatingLabel: UILabel {
    
    private var ratingColor: UIColor = .softBlack
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLabel() {
        self.numberOfLines = 1
        self.textAlignment = .right
    }
    
    func set(rating: Double) {
        let fullRatingText = "\(rating)/10"
        let attributedText = NSMutableAttributedString(string: fullRatingText)
        let numberAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: ratingColor,
            .font: UIFont.systemFont(ofSize: 19, weight: .bold)
        ]
        if let numberRange = fullRatingText.range(of: "\(rating)") {
            attributedText.addAttributes(numberAttributes, range: NSRange(numberRange, in: fullRatingText))
        }
        let slashAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.softGray,
            .font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ]
        if let slashRange = fullRatingText.range(of: "/10") {
            attributedText.addAttributes(slashAttributes, range: NSRange(slashRange, in: fullRatingText))
        }
        self.attributedText = attributedText
    }
    
    func set(color: UIColor) {
        self.ratingColor = color
        set(rating: Double(self.attributedText?.string.components(separatedBy: "/").first ?? "0") ?? 0)
    }
}
