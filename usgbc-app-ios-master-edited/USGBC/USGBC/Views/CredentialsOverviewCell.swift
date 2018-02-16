//
//  CredentialsOverviewCell.swift
//  USGBC
//
//  Created by Vishal Raj on 21/09/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

class CredentialsOverviewCell: UITableViewCell {
    
    @IBOutlet weak var reportedHours: UILabel!
    @IBOutlet weak var bdcSpecificHours: UILabel!
    @IBOutlet weak var reportEndDate: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var reportedMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
