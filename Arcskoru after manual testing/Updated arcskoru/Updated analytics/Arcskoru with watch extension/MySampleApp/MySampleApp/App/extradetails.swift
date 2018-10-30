//
//  extradetails.swift
//  Analytics
//
//  Created by Group X on 12/06/17.
//  Copyright © 2017 USGBC. All rights reserved.
//

import UIKit

class extradetails: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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

    
}
