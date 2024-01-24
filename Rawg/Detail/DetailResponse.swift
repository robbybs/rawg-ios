//
//  DetailResponse.swift
//  Rawg
//
//  Created by Robby Bagus on 23/01/24.
//

import Foundation

struct DetailResponse: Codable {
    let id: Int
    let name: String
    let description_raw: String
    let background_image: URL
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name
        case description_raw
        case background_image = "background_image"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let image = try container.decode(String.self, forKey: .background_image)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description_raw = try container.decode(String.self, forKey: .description_raw)
        background_image = URL(string: "\(image)")!
    }
}
