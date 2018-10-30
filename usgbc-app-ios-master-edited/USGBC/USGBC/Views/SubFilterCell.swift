//
//  SubFilterViewCell.swift
//  USGBC
//
//  Created by Vishal Raj on 21/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import DLRadioButton

class SubFilterCell: UITableViewCell {

    
    @IBOutlet weak var subFilterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initViews()
    }
    
    func initViews(){
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
