//
//  surveycategorytick.swift
//  Arcskoru
//
//  Created by Group X on 13/03/17.
//
//

import UIKit

class surveycategorytick: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
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
            self.layer.masksToBounds = true
        }
    }

    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var label: UILabel!
       
    @IBOutlet weak var tickimg: UIImageView!
    
}
