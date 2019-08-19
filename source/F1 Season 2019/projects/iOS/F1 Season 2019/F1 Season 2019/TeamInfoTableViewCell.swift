//
//  TeamInfoTableViewCell.swift
//  F1 Season 2019
//
//  Created by Arthur Nsereko Kahwa on 8/19/19.
//  Copyright © 2019 Arthur Nsereko Kahwa. All rights reserved.
//

import UIKit

class TeamInfoTableViewCell: UITableViewCell {

    @IBOutlet var teamLabel: UILabel!
    @IBOutlet var teamLogo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
