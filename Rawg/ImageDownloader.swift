//
//  ImageDownloader.swift
//  Rawg
//
//  Created by Robby Bagus on 20/01/24.
//

import Foundation
import UIKit

class ImageDownloader: Operation {
    private let games: Games
    
    init(games: Games) {
        self.games = games
    }
    
    override func main() {
        if isCancelled {
          return
        }
     
        guard let imageData = try? Data(contentsOf:  self.games.background_image) else { return }
     
        if isCancelled {
          return
        }
     
        if !imageData.isEmpty {
          self.games.image = UIImage(data: imageData)
          self.games.state = .downloaded
        } else {
          self.games.image = nil
          self.games.state = .failed
        }
    }
}

class PendingOperations {
  lazy var downloadInProgress: [IndexPath: Operation] = [:]
 
 
  lazy var downloadQueue: OperationQueue = {
    var queue = OperationQueue()
    queue.name = "rbs.download"
    queue.maxConcurrentOperationCount = 2
    return queue
  }()
}
