//
//  totalanalysis1.swift
//  LEEDOn
//
//  Created by Group X on 20/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class totalanalysis1: UITableViewCell {
    @IBOutlet weak var details: UILabel!

    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var gross: UILabel!
    @IBOutlet weak var leedid: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 7
        self.selectionStyle = UITableViewCellSelectionStyle.None
        // Initialization code
    }
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

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    
    
}
