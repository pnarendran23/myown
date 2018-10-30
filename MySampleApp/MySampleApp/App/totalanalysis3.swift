//
//  totalanalysis3.swift
//  LEEDOn
//
//  Created by Group X on 20/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class totalanalysis3: UITableViewCell {
    @IBOutlet weak var typename: UILabel!
    @IBOutlet weak var typeimg2: UIImageView!

    @IBOutlet weak var l4: UILabel!
    @IBOutlet weak var l3: UILabel!
    @IBOutlet weak var l2: UILabel!
    @IBOutlet weak var l1: UILabel!
    @IBOutlet weak var slider2: UISlider!
    @IBOutlet weak var slider1: UISlider!
    @IBOutlet weak var graphbtn: UIButton!
    @IBOutlet weak var vv: UIView!
    @IBOutlet weak var circularview: UIView!
    @IBOutlet weak var globalavg: UILabel!
    @IBOutlet weak var localavg: UILabel!
    @IBOutlet weak var typeimg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()        
        vv.layer.cornerRadius = 7
        vv.layer.masksToBounds = true
        self.layer.cornerRadius = 7
        self.graphbtn.frame.size.height = self.graphbtn.frame.size.height
        self.graphbtn.frame.size.width = self.graphbtn.frame.size.height
        self.selectionStyle = UITableViewCellSelectionStyle.None
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    

    
}
