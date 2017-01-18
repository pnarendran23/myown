//
//  monthlycell.swift
//  split
//
//  Created by Group X on 11/01/17.
//  Copyright © 2017 USGBC. All rights reserved.
//

import UIKit

class monthlycell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
        // Initialization code
    }

    @IBOutlet weak var vv: listgraph!
    
    override public var frame: CGRect {
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



