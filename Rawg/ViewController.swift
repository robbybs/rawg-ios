//
//  ViewController.swift
//  Rawg
//
//  Created by Robby Bagus on 20/01/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var gameTableView: UITableView!
    private let pendingOperations = PendingOperations()
    
    private var games: [Games] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        gameTableView.dataSource = self
        gameTableView.delegate = self
        
        gameTableView.register(
            UINib(nibName: "GamesTableViewCell", bundle: nil),
            forCellReuseIdentifier: "gamesTableViewCell"
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task { await getData() }
      }
    
    func getData() async {
        let network = NetworkService()
        do {
            games = try await network.getData()
            gameTableView.reloadData()
        } catch {
            fatalError("Error: connection failed.")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "gamesTableViewCell", for: indexPath) as? GamesTableViewCell {
            let game = games[indexPath.row]
            cell.gamesTitle.text = game.name
            cell.gamesImage.image = game.image
            
            if game.state == .new {
                  cell.imageLoading.isHidden = false
                  cell.imageLoading.startAnimating()
                  startOperations(game: game, indexPath: indexPath)
                } else {
                  cell.imageLoading.stopAnimating()
                  cell.imageLoading.isHidden = true
                }
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    fileprivate func startOperations(game: Games, indexPath: IndexPath) {
        if game.state == .new {
            startDownload(game: game, indexPath: indexPath)
        }
    }
    
    fileprivate func startDownload(game: Games, indexPath: IndexPath) {
        guard pendingOperations.downloadInProgress[indexPath] == nil else { return }
        
        let downloader = ImageDownloader(games: game)
        
        downloader.completionBlock = {
            if downloader.isCancelled { return }
            DispatchQueue.main.async {
                  self.pendingOperations.downloadInProgress.removeValue(forKey: indexPath)
                  self.gameTableView.reloadRows(at: [indexPath], with: .automatic)
                }
        }
        
        pendingOperations.downloadInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    fileprivate func toggleSuspendOperations(isSuspended: Bool) {
      pendingOperations.downloadQueue.isSuspended = isSuspended
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        toggleSuspendOperations(isSuspended: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        toggleSuspendOperations(isSuspended: false)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        performSegue(withIdentifier: "moveToDetail", sender: games[indexPath.row].id)
    }
    
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
      ) {
          let indexPath = gameTableView.indexPathForSelectedRow
          let index = indexPath?.row
          let game = games[index!]
        if segue.identifier == "moveToDetail" {
          if let detaiViewController = segue.destination as? DetailViewController {
              //detaiViewController.games = sender as? Games
              detaiViewController.id = game.id
          }
        }
      }
}
