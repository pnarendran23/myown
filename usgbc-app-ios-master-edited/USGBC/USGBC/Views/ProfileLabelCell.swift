//
//  ProfileLabelCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 10/31/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit
import Former

class ProfileLabelCell: UITableViewCell, InlineDatePickerFormableRow, InlinePickerFormableRow {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var displayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //titleLabel.textColor = .formerColor()
        titleLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
        displayLabel.textColor = .formerSubColor()
        displayLabel.font = UIFont(name: "Gotham-Medium", size: 14.0)
    }
    
    func formTitleLabel() -> UILabel? {
        return titleLabel
    }
    
    func formDisplayLabel() -> UILabel? {
        return displayLabel
    }
    
    func updateWithRowFormer(_ rowFormer: RowFormer) {}
}
