//
//  MovieDetailLabel.swift
//  Movies-Test-Task-UIKit-(Mock-data)
//
//  Created by Oleh on 23.12.2023.
//

import UIKit

final class MovieDetailLabel: UILabel {
    
    private var title: String
    private var titleColor: UIColor = .softBlack
    private var details: String?
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        configureLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(details: String) {
        self.details = details
        updateText()
    }
    
    func set(color: UIColor) {
        self.titleColor = color
        configureLabel()
    }
    
    private func configureLabel() {
        textColor = titleColor
        font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        numberOfLines = 0
        updateText()
    }
    
    private func updateText() {
        guard let details else { return }
        let formattedTitle = "\(title): "
        let attributedString = NSMutableAttributedString(string: "\(formattedTitle)\(details)")
        let titleRange = NSRange(location: 0, length: formattedTitle.count)
        attributedString.addAttribute(.foregroundColor, value: titleColor, range: titleRange)
        let detailsRange = NSRange(location: formattedTitle.count, length: details.count)
        attributedString.addAttribute(.foregroundColor, value: UIColor.softGray, range: detailsRange)
        attributedText = attributedString
    }
}
