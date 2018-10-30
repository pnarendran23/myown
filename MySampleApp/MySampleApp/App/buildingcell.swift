//
//  buildingcell.swift
//  MySampleApp
//
//  Created by Group X on 03/11/16.
//
//

import UIKit

class buildingcell: UITableViewCell {
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var leedidlbl: UILabel!

    @IBOutlet weak var statuslbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
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

    /*override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = CGRectGetWidth(frame)
        
        let someFrame = CGRect(x: 4, y: 0, width: width-10, height: self.frame.height)
        self.frame = someFrame
    }*/
   
    
}
