//
//  row1.swift
//  Analytics
//
//  Created by Group X on 01/06/17.
//  Copyright © 2017 USGBC. All rights reserved.
//

import UIKit

class row1: UITableViewCell {

    @IBOutlet weak var maxscore: UILabel!
    @IBOutlet weak var vv: actualgraphh!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
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
