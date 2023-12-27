//
//  HighlightedButton.swift
//  Movies-Test-Task-UIKit-(Mock-data)
//
//  Created by Oleh on 19.12.2023.
//

import UIKit

final class HighlightedButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isHighlighted: Bool {
        didSet {
            self.alpha = isHighlighted ? 0.4 : 1
        }
    }
}
