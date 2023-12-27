//
//  WatchlistButton.swift
//  Movies-Test-Task-UIKit-(Mock-data)
//
//  Created by Oleh on 25.12.2023.
//

import UIKit

final class WatchlistButton: UIButton {
    
    private let customTitleLabel = UILabel()
    private let contentPadding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(title: String) {
        customTitleLabel.text = title
    }
    
    func set(titleColor: UIColor, backgroundColor: UIColor) {
        customTitleLabel.textColor = titleColor
        self.backgroundColor = backgroundColor
    }

    private func commonSetup() {
        
        // I'm aware that UIButton has its own label, but 'contentEdgeInsets' was deprecated in iOS 15.0. For now - This property is ignored when using UIButtonConfiguration...
        // Looking into the future and considering that the API - 'contentEdgeInsets' might be entirely unavailable, I've decided to move away from it...
        // And here, we can utilize UIButtonConfiguration, but it lacks APIs such as 'adjustsFontSizeToFitWidth' and 'minimumScaleFactor'...
        // When we change the button title to a larger text, we'll end up with two lines in the button label on a smaller device... This doesn't align with our design and looks unattractive.
        // And here I decided to use a little trick with a custom UILabel and adjust the button's width according to the text width within it, with a minimum text scaling factor...
        
        setTitleColor(.softBlack, for: .normal)
        setTitle("", for: .normal)
        backgroundColor = .gray.withAlphaComponent(0.5)
        layer.cornerRadius = 20
        customTitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        customTitleLabel.textColor = .softBlack
        customTitleLabel.textAlignment = .center
        customTitleLabel.adjustsFontSizeToFitWidth = true
        customTitleLabel.minimumScaleFactor = 0.75
        addSubview(customTitleLabel)
        customTitleLabel.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: contentPadding
        )
        self.anchor(size: .init(width: 0, height: 40))
    }
    
    override var isHighlighted: Bool {
        didSet {
            self.alpha = isHighlighted ? 0.4 : 1
        }
    }
}
