//
//  StringArrayToString+.swift
//  Movies-Test-Task-UIKit-(Mock-data)
//
//  Created by Oleh on 20.12.2023.
//

import Foundation

extension Array where Element == String {
    func combinedString() -> String {
        return self.joined(separator: ", ")
    }
}
