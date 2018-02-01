//
//  customcellTableViewCell.swift
//  LEEDOn
//
//  Created by Group X on 24/08/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class customcellTableViewCell: UITableViewCell {    
    @IBOutlet weak var namelbl: UILabel!

    @IBOutlet weak var creditstatusimg: UIImageView!
    @IBOutlet weak var shortcredit: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
           var frame = CGRect()
                frame.origin.y += 4;
                frame.origin.x += 5;
                frame.size.height -= 2 * 2;
                frame.size.width -= 5 * 2;
                self.frame = frame
        
        // Initialization code
    }
        
    @IBOutlet weak var creditstatus: UILabel!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            let inset: CGFloat = 10
            var frame = newFrame
            frame.origin.x += inset
            frame.size.width -= 2 * inset
            super.frame = frame
        }
    }
    
    
}
