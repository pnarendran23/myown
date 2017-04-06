//
//  manageprojcell.swift
//  Arcskoru
//
//  Created by Group X on 08/02/17.
//
//

import UIKit

class manageprojcellwithswitch: UITableViewCell {    
    @IBOutlet weak var yesorno: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        // Initialization code
    }
    @IBOutlet weak var lbl: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
