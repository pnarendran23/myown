//
//  manageprojectcell.swift
//  LEEDOn
//
//  Created by Group X on 07/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class manageprojectcell: UITableViewCell {
    @IBOutlet weak var yesnoswitch: UISwitch!

    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var valuetxtfld: UITextField!
    var x : CGFloat = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        x = 0             
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
        
}
