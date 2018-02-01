//
//  totalanalysis2.swift
//  LEEDOn
//
//  Created by Group X on 20/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit


class totalanalysis2: UITableViewCell {
        
    @IBOutlet weak var lowestscorelbl: UILabel!
    @IBOutlet weak var highestscorelbl: UILabel!
    @IBOutlet weak var highscore: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        overallscore.font = UIFont.init(name: "OpenSans-bold", size: 0.028 * UIScreen.mainScreen().bounds.size.height)        
        self.layer.cornerRadius = 7
        self.cview.frame.size.height = self.cview.frame.size.width
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
        
    @IBOutlet weak var cview: circularprogress!
   /* override internal var frame: CGRect {
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

    
    @IBOutlet weak var overallscore: UILabel!
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
 
    
}
