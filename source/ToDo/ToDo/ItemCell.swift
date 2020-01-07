//
//  ItemCellTableViewCell.swift
//  ToDo
//
//  Created by Arthur Nsereko Kahwa on 12/29/19.
//  Copyright © 2019 Arthur Nsereko Kahwa. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    // let titleLabel = UILabel()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        return dateFormatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
     func configCell(with item: ToDoItem,
                    checked: Bool = false) {

      if checked {
        let attributedString = NSAttributedString(
          string: item.title,
          attributes: [NSAttributedString.Key.strikethroughStyle:
            NSUnderlineStyle.single.rawValue])


        titleLabel.attributedText = attributedString
        locationLabel.text = nil
        dateLabel.text = nil
      }
      else {
        titleLabel?.text = item.title
        locationLabel?.text = item.location?.name ?? ""

        if let timestamp = item.timeStamp {
          let date = Date(timeIntervalSince1970: timestamp)

          dateLabel?.text = dateFormatter.string(from: date)
        }
      }
    }

}
