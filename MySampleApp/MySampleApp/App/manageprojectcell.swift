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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
        
}
