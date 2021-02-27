//
//  CollectionViewCell.swift
//  MobilliumiOSChallenge
//
//  Created by Hakan UNAL on 27.02.2021.
//

import UIKit
import Kingfisher

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //let url = URL(string: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080")
        //img.kf.setImage(with: url)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        img.layer.cornerRadius = 8
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "CollectionViewCell", bundle: nil)
    }
    
    var moviesViewModel: SearchMoviesResult? {
        didSet {
            titleLabel.text = moviesViewModel?.title
            let url = URL(string: "https://image.tmdb.org/t/p/original/\(moviesViewModel?.posterPath ?? "")")
            img.kf.setImage(with: url)
        }
    }
}
