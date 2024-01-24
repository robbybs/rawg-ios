//
//  GameResponse.swift
//  Rawg
//
//  Created by Robby Bagus on 20/01/24.
//

import Foundation

struct GameResponse: Codable {
    let results: [GameResults]
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
}

struct GameResults: Codable {
    let id: Int
    let name: String
    let background_image: URL
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name
        case background_image = "background_image"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let image = try container.decode(String.self, forKey: .background_image)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        background_image = URL(string: "\(image)")!
    }
}
