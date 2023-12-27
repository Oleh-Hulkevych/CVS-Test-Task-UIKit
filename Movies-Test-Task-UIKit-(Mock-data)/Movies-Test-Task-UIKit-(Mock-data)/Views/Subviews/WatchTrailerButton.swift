//
//  WatchTrailerButton.swift
//  Movies-Test-Task-UIKit-(Mock-data)
//
//  Created by Oleh on 25.12.2023.
//

import UIKit

final class WatchTrailerButton: UIButton {
    
    private let contentPadding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    private let customTitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    func set(color: UIColor) {
        customTitleLabel.textColor = color
        layer.borderColor = color.cgColor
    }

    private func commonSetup() {
        
        // The same simple way without using 'contentEdgeInsets' as in WatchlistButton...
        
        setTitleColor(.softBlack, for: .normal)
        setTitle("", for: .normal)
        backgroundColor = .clear
        layer.cornerRadius = 20
        layer.borderWidth = 2
        layer.borderColor = UIColor.softBlack.cgColor
        customTitleLabel.text = "WATCH TRAILER"
        customTitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .black)
        customTitleLabel.textColor = .softBlack
        customTitleLabel.textAlignment = .center
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
