//
//  extradetails.swift
//  Arcskoru
//
//  Created by Group X on 05/05/17.
//
//

import UIKit

class extradetails: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.layer.cornerRadius = 7
        var f = 1.1123459
        let height = UIScreen.mainScreen().bounds.size.height
        self.textLabel?.font = UIFont.init(name: "OpenSans-Semibold", size: 0.023 * height)
        self.detailTextLabel?.font = UIFont.init(name: "OpenSans-Semibold", size: 0.016 * height)
        print(String(format:"xxaasdd %.4f",f))
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
