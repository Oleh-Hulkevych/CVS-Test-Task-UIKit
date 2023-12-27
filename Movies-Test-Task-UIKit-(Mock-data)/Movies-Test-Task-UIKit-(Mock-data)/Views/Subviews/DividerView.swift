//
//  DividerView.swift
//  Movies-Test-Task-UIKit-(Mock-data)
//
//  Created by Oleh on 23.12.2023.
//

import UIKit

enum DividerOrientation {
    case horizontal
    case vertical
}

final class DividerView: UIView {

    private let orientation: DividerOrientation
    
    init(orientation: DividerOrientation) {
        self.orientation = orientation
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .softGray.withAlphaComponent(0.5)
        
        switch orientation {
        case .vertical:
            let widthConstraint = NSLayoutConstraint(
                item: self,
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: 1.0
            )
            addConstraint(widthConstraint)
        case .horizontal:
            let heightConstraint = NSLayoutConstraint(
                item: self,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: 1.0 
            )
            addConstraint(heightConstraint)
        }
    }
}
