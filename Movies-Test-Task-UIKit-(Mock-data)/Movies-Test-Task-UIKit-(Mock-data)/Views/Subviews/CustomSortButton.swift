//
//  CustomSortButton.swift
//  Movies-Test-Task-UIKit-(Mock-data)
//
//  Created by Oleh on 26.12.2023.
//

import UIKit

final class CustomSortButton: UIButton {
    
    private var image: UIImage?
    private var color: UIColor = .softGray
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonSetup() {
        image = UIImage(systemName: "arrow.up.and.down.text.horizontal")?.withTintColor(color, renderingMode: .alwaysOriginal)
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17, weight: .medium),
            .foregroundColor: color
        ]
        let titleAttributedString = NSAttributedString(string: "Sort", attributes: titleAttributes)
        let titleString = NSMutableAttributedString(attributedString: titleAttributedString)
        titleString.append(NSAttributedString(string: " "))
        titleString.append(NSAttributedString(attachment: imageAttachment))
        setAttributedTitle(titleString, for: .normal)
        sizeToFit()
    }
    
    override var isHighlighted: Bool {
        didSet {
            self.alpha = isHighlighted ? 0.4 : 1
        }
    }
    
    func set(color: UIColor) {
        self.color = color
        let image = image?.withTintColor(color, renderingMode: .alwaysOriginal)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17, weight: .medium),
            .foregroundColor: color
        ]
        let titleAttributedString = NSAttributedString(string: "Sort", attributes: titleAttributes)
        let titleString = NSMutableAttributedString(attributedString: titleAttributedString)
        titleString.append(NSAttributedString(string: " "))
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        titleString.append(NSAttributedString(attachment: imageAttachment))
        setAttributedTitle(titleString, for: .normal)
        sizeToFit()
    }
}
