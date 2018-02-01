//
//  totalanalysis5.swift
//  analytics
//
//  Created by Group X on 17/04/17.
//  Copyright © 2017 USGBC. All rights reserved.
//

import UIKit

class totalanalysis5: UITableViewCell {

    @IBOutlet weak var outoflbl: UILabel!
    @IBOutlet weak var graphbtn: UIButton!
    @IBOutlet weak var typename: UILabel!
    @IBOutlet weak var globalavg: UILabel!
    @IBOutlet weak var localavg: UILabel!
    @IBOutlet weak var typeimg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 7
        self.selectionStyle = UITableViewCellSelectionStyle.None
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /*override internal var frame: CGRect {
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
