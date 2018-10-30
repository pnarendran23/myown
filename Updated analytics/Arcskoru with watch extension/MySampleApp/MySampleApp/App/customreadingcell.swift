//
//  customreadingcell.swift
//  LEEDOn
//
//  Created by Group X on 25/11/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class customreadingcell: UITableViewCell {
    @IBOutlet weak var reading: UILabel!

    @IBOutlet weak var durationlbl: UILabel!
    @IBOutlet weak var editbtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5.0
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
       
}
