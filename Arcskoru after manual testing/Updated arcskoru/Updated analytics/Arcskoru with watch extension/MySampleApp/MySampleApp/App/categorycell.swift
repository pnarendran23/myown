//
//  categorycell.swift
//  Analytics
//
//  Created by Group X on 31/05/17.
//  Copyright © 2017 USGBC. All rights reserved.
//

import UIKit

class categorycell: UITableViewCell {
    @IBOutlet weak var categoryimg: UIImageView!
    @IBOutlet weak var categoryname: UILabel!
    @IBOutlet weak var categoryright: UILabel!
    @IBOutlet weak var categorybottom: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 5
        let height = UIScreen.main.bounds.size.height
        let width = UIScreen.main.bounds.size.width
        self.contentView.layer.masksToBounds = false
        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 8)//Blur
        self.contentView.layer.shadowOpacity = 0.70
        self.contentView.layer.shadowRadius = 77.0
        self.categoryname.font = UIFont.init(name: "OpenSans", size: 0.53 * UIScreen.main.bounds.size.width )
        // Initialization code
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
            self.contentView.layer.masksToBounds = true
        }
    }
    
}
