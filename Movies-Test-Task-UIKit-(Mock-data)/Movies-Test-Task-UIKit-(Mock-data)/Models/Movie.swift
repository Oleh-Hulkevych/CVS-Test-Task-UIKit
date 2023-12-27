//
//  MoviesFeed.swift
//  Movies-Test-Task-UIKit-(Mock-data)
//
//  Created by Oleh on 19.12.2023.
//

import Foundation

struct Movie: Decodable {
    let id: Int
    let title: String
    let image: String
    let description: String
    let rating: Double
    let duration: String
    let genre: [String]
    let releasedDate: String
    let trailerLink: String
}
