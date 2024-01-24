//
//  GamesTableViewCell.swift
//  Rawg
//
//  Created by Robby Bagus on 20/01/24.
//

import UIKit

class GamesTableViewCell: UITableViewCell {

    @IBOutlet weak var gamesImage: UIImageView!
    @IBOutlet weak var gamesTitle: UILabel!
    @IBOutlet weak var imageLoading: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
