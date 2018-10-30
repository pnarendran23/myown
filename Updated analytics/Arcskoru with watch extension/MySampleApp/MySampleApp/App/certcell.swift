//
//  certcell.swift
//  LEEDOn
//
//  Created by Group X on 03/01/17.
//  Copyright © 2017 USGBC. All rights reserved.
//

import UIKit

class certcell: UITableViewCell {

    @IBOutlet weak var othercert: UILabel!
    @IBOutlet weak var certdate: UILabel!
    @IBOutlet weak var certlevel: UILabel!
    @IBOutlet weak var certname: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 7
        self.selectionStyle = UITableViewCellSelectionStyle.None
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /*override internal var frame: CGRect {
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
    }*/
    
}
