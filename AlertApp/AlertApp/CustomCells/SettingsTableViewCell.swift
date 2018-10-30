//
//  SettingsTableViewCell.swift
//  AlertApp
//
//  Created by Group10 on 16/02/18.
//  Copyright © 2018 Group10. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet var lblTag: UILabel!
    @IBOutlet var lblSettings: UILabel!
    @IBOutlet var ivSettings: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
