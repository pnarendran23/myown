//
//  CustomHeaderCell.swift
//  AlertApp
//
//  Created by Group10 on 20/02/18.
//  Copyright © 2018 Group10. All rights reserved.
//

import UIKit

class CustomHeaderCell: UITableViewHeaderFooterView {
    
    @IBOutlet var ivBg: UIImageView!
    
    @IBOutlet weak var lblphone: UILabel!
    
    var section: Int = 1
    override func awakeFromNib() {
        super.awakeFromNib()
        print(Utility().getPhone())
//        lblphone.text = Utility().getPhone()
        // Initialization code
    }
    
}
