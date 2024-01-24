//
//  DetailViewController.swift
//  Rawg
//
//  Created by Robby Bagus on 20/01/24.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var detailDescription: UILabel!
    @IBOutlet weak var des: UITextView!
    
    var detail: Detail? = nil
    var id = Int()
    private let pendingOperations = PendingOperations()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task { await getData() }
    }
    
    func getData() async {
        let network = NetworkService()
        do {
            detail = try await network.getDetailData(id: id)
            if let results = detail {
                detailImage.image = results.image
                detailTitle.text = results.name
                des.attributedText = results.description_raw.htmlToAttributedString
            }
        } catch {
            fatalError("Error: connection failed.")
        }
    }
    
    fileprivate func startOperations(detail: Detail, indexPath: IndexPath) {
        if detail.state == .new {
            startDownload(detail: detail, indexPath: indexPath)
        }
    }
    
    fileprivate func startDownload(detail: Detail, indexPath: IndexPath) {
        guard pendingOperations.downloadInProgress[indexPath] == nil else { return }
        
        let downloader = DetailImageDownloader(detail: detail)
        
        downloader.completionBlock = {
            if downloader.isCancelled { return }
            DispatchQueue.main.async {
                self.pendingOperations.downloadInProgress.removeValue(forKey: indexPath)
            }
        }
        
        pendingOperations.downloadInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    fileprivate func toggleSuspendOperations(isSuspended: Bool) {
      pendingOperations.downloadQueue.isSuspended = isSuspended
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
