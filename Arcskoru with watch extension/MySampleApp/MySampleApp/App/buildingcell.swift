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
    

    
    /*override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = CGRectGetWidth(frame)
        
        let someFrame = CGRect(x: 4, y: 0, width: width-10, height: self.frame.height)
        self.frame = someFrame
    }*/
   
    
}
