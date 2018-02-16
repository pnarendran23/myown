//
//  accountcell.swift
//  USGBC
//
//  Created by Group X on 23/01/18.
//  Copyright © 2018 Group10 Technologies. All rights reserved.
//

import UIKit

class accountcell: UITableViewCell {
    @IBOutlet weak var vieww: UIView!
    
    @IBOutlet weak var switchh: UISwitch!
    @IBOutlet weak var directory: UILabel!
    @IBOutlet weak var backgrnd: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imgview: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.contentView.backgroundColor = .clear
            
            let blurEffect = UIBlurEffect(style: .light)
            blurEffect
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.contentView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.contentView.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        } else {
            self.contentView.backgroundColor = .black
        }
        self.contentView.bringSubview(toFront: imgview)
        self.contentView.bringSubview(toFront: label)
        self.contentView.bringSubview(toFront: directory)
        self.contentView.bringSubview(toFront: switchh)
        imgview.layer.cornerRadius = imgview.layer.bounds.size.width/4
        imgview.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
