//
//  totalanalysis4.swift
//  Arcskoru
//
//  Created by Group X on 17/04/17.
//
//

import UIKit

class totalanalysis4: UITableViewCell {

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
    
    @IBOutlet weak var outoflbl: UILabel!
    @IBOutlet weak var l2: UILabel!
    @IBOutlet weak var slider1: UISlider!
    @IBOutlet weak var l1: UILabel!
    @IBOutlet weak var vv: UIView!
    @IBOutlet weak var graphbtn: UIButton!
    @IBOutlet weak var typename: UILabel!
    @IBOutlet weak var globalavg: UILabel!
    @IBOutlet weak var localavg: UILabel!
}
