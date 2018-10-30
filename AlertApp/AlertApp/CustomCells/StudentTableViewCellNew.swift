//
//  StudentTableViewCell.swift
//  AlertApp
//
//  Created by Group10 on 15/02/18.
//  Copyright © 2018 Group10. All rights reserved.
//

import UIKit

class StudentTableViewCellNew: UITableViewCell {

    @IBOutlet var btnName: UIButton!
    
    @IBOutlet var lb1: UILabel!
    
    @IBOutlet var lb3: UILabel!
    @IBOutlet var lb2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnName.backgroundColor = UIColor( red: 12/255, green: 133/255, blue: 145/255, alpha: 1)
        self.btnName.layer.cornerRadius = 35
//        btn.layer.cornerRadius = 10
        self.btnName.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
