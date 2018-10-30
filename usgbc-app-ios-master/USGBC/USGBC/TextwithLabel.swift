//
//  TextwithLabel.swift
//  USGBC
//
//  Created by Group X on 29/01/18.
//  Copyright © 2018 Group10 Technologies. All rights reserved.
//

import UIKit

class TextwithLabel: UITableViewCell {
    @IBOutlet weak var txtfield: UITextField!
    @IBOutlet weak var lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
