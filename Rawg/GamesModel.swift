//
//  GamesModel.swift
//  Rawg
//
//  Created by Robby Bagus on 20/01/24.
//

import Foundation
import UIKit

enum DownloadState {
  case new, downloaded, failed
}

class Games {
    let id: Int
    let name: String
    let background_image: URL
    
    var image: UIImage?
    var state: DownloadState = .new
    
    init(id: Int, name: String, background_image: URL) {
        self.id = id
        self.name = name
        self.background_image = background_image
    }
}
