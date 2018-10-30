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
        x = valuetxtfld.frame.size.width
        titlelbl.numberOfLines = 3
        valuetxtfld.adjustsFontSizeToFitWidth = true
        titlelbl.adjustsFontSizeToFitWidth = true
        // Initialization code
    }
    
    
    override internal var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            let inset: CGFloat = 10
            var frame = newFrame
            frame.origin.x += inset
            frame.size.width -= 2 * inset
            super.frame = frame
            self.layer.masksToBounds = true
        }
    }

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
        
}
