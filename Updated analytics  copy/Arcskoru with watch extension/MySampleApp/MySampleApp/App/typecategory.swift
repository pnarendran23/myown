//
//  typecategory.swift
//  LEEDOn
//
//  Created by Group X on 20/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class typecategory: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var second: UIView!
    
    @IBOutlet weak var secondlbl: UILabel!
    @IBOutlet weak var secondimg: UIImageView!
    @IBOutlet weak var firstlbl: UILabel!
    @IBOutlet weak var firstimg: UIImageView!
    @IBOutlet weak var first: UIView!
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.second.layer.cornerRadius = 10
        self.first.layer.cornerRadius = 10
        // Configure the view for the selected state
    }
    
   
    
}
