//
//  manageprojectdatacell.swift
//  Arcskoru
//
//  Created by Group X on 11/07/17.
//
//

import UIKit

class manageprojectdatacell: UITableViewCell {
    @IBOutlet weak var yesnoswitch: UISwitch!
    
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var valuetxtfld: UITextField!
    var x : CGFloat = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        x = 0
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
