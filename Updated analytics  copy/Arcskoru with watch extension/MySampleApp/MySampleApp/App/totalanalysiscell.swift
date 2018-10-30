//
//  totalanalysiscell.swift
//  LEEDOn
//
//  Created by Group X on 06/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class totalanalysiscell: UITableViewCell {
    @IBOutlet weak var typeimg: UIImageView!

    @IBOutlet weak var outoflabal: UILabel!
    @IBOutlet weak var localavg: UILabel!
    
    
    
    @IBOutlet weak var globalavg: UILabel!
    @IBOutlet weak var typeplaque: UIImageView!
    @IBOutlet weak var typename: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
  /*  override internal var frame: CGRect {
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
