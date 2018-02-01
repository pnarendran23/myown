//
//  wastecell.swift
//  LEEDOn
//
//  Created by Group X on 22/11/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class wastecell: UITableViewCell {

    
    @IBOutlet weak var chart: chartview!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chart.setNeedsDisplay()
        setNeedsLayout()
        /*var v = chartview()
        v.frame = CGRect(x:30,y:0,width:205,height:205)
        for views in self.contentView.subviews{
            views.removeFromSuperview()
        }
        self.contentView.addSubview(v)*/
        // Initialization code
    }
    
    

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
