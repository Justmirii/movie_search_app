//
//  MovieResult.swift
//  movie_search_app
//
//  Created by Mirmusa Feyziyev on 13.03.23.
//

import Foundation
import UIKit

struct MovieResult: Codable {
    let Search: [Movie]
}
struct Movie: Codable {
    let Title: String?
    let Year: String?
    let imdbID: String?
    let _Type: String?
    let Poster: String?
    
    private enum CodingKeys: String, CodingKey{
        case Title, Year, imdbID, _Type = "Type", Poster
    }
}
