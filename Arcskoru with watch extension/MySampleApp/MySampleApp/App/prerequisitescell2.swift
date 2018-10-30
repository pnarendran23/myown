//
//  prerequisitescell2.swift
//  LEEDOn
//
//  Created by Group X on 16/11/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class prerequisitescell2: UITableViewCell {
    @IBOutlet weak var assignedto: UILabel!

    @IBOutlet weak var uploadanewfile: UILabel!
    @IBOutlet weak var uploadbutton: UIButton!
    @IBOutlet weak var editbutton: UIButton!
    @IBOutlet weak var fileuploaded: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.layer.cornerRadius = 5
        
        // Configure the view for the selected state
    }

    

    
}
