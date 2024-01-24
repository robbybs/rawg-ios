//
//  DetailModel.swift
//  Rawg
//
//  Created by Robby Bagus on 23/01/24.
//

import Foundation
import UIKit

enum DetailDownloadState {
  case new, downloaded, failed
}

class Detail {
    let id: Int
    let name: String
    let description_raw: String
    let background_image: URL
    
    var image: UIImage?
    var state: DetailDownloadState = .new
    
    init(id: Int, name: String, description_raw: String, background_image: URL) {
        self.id = id
        self.name = name
        self.description_raw = description_raw
        self.background_image = background_image
    }
}
