//
//  DetailImageDownloader.swift
//  Rawg
//
//  Created by Robby Bagus on 24/01/24.
//

import Foundation
import UIKit

class DetailImageDownloader: Operation {
    private let detail: Detail
    
    init(detail: Detail) {
        self.detail = detail
    }
    
    override func main() {
        if isCancelled {
          return
        }
     
        guard let imageData = try? Data(contentsOf:  self.detail.background_image) else { return }
     
        if isCancelled {
          return
        }
     
        if !imageData.isEmpty {
          self.detail.image = UIImage(data: imageData)
          self.detail.state = .downloaded
        } else {
          self.detail.image = nil
          self.detail.state = .failed
        }
    }
}
