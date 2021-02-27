//
//  SearchTableViewCell.swift
//  MobilliumiOSChallenge
//
//  Created by Hakan UNAL on 25.02.2021.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        
        accessoryType = .disclosureIndicator
    }

    var moviesViewModel: SearchMoviesResult? {
        didSet {
            titleLabel.text = moviesViewModel?.title
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
