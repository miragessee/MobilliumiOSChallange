//
//  ListViewTableViewCell.swift
//  MobilliumiOSChallenge
//
//  Created by Hakan UNAL on 25.02.2021.
//

import UIKit
import Kingfisher
import SwiftDate

class ListViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var movieDetailButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        
        accessoryType = .disclosureIndicator
        
        //let url = URL(string: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080")
        //img.kf.setImage(with: url)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        img.layer.cornerRadius = 8
    }
    
    var moviesViewModel: Result? {
        didSet {
            titleLabel.text = moviesViewModel?.title
            dateLabel.text = moviesViewModel?.releaseDate?.toDate()?.toFormat("dd.MM.yyyy")
            descriptionLabel.text = moviesViewModel?.overview
            
            let url = URL(string: "https://image.tmdb.org/t/p/original/\(moviesViewModel?.posterPath ?? "")")
            img.kf.setImage(with: url)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
