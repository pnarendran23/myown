//
//  EndorsementCell.swift
//  USGBC
//
//  Created by Vishal Raj on 12/10/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

class EndorsementCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont.gothamMedium(size: 14)
        dateLabel.font = UIFont.gothamBook(size: 12)
        categoryLabel.font = UIFont.gothamMedium(size: 12)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
