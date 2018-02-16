//
//  CeHourTableViewCell.swift
//  USGBC
//
//  Created by Vishal Raj on 18/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

class CeHourTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var earnedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            var frame = newValue
            frame.origin.x += 5
            frame.size.width -= 2 * 5
            frame.origin.y += 2.5
            frame.size.height -= 2 * 2.5
            super.frame = frame
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
