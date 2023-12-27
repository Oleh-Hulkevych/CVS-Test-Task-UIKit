//
//  StringDateFormatter+.swift
//  Movies-Test-Task-UIKit-(Mock-data)
//
//  Created by Oleh on 24.12.2023.
//

import Foundation

extension String {
    func convertStringDate(fromFormat inputDateFormat: String, toFormat outputDateFormat: String) -> String {
        let dateFormatterInput = DateFormatter()
        dateFormatterInput.dateFormat = inputDateFormat
        
        let dateFormatterOutput = DateFormatter()
        dateFormatterOutput.dateFormat = outputDateFormat
        
        if let date = dateFormatterInput.date(from: self) {
            return dateFormatterOutput.string(from: date)
        } else {
            return "Invalid date format"
        }
    }
}
