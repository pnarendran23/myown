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
    @IBOutlet weak var lastupdatedlbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        var frame = CGRect()
        frame.origin.y += 4;
        frame.origin.x += 5;
        frame.size.height -= 2 * 2;
        frame.size.width -= 5 * 2;
        self.frame = frame
        // Initialization code
    }

    /*override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = CGRectGetWidth(frame)
        
        let someFrame = CGRect(x: 4, y: 0, width: width-10, height: self.frame.height)
        self.frame = someFrame
    }*/
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
