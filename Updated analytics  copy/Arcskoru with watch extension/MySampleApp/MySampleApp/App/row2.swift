//
//  row2.swift
//  Arcskoru
//
//  Created by Group X on 10/05/17.
//
//

import UIKit

class row2: UITableViewCell {

    @IBOutlet weak var value2: UILabel!
    @IBOutlet weak var value1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var segctrl: UISegmentedControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vv.layer.cornerRadius = 7
        self.vv.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var vv: UIView!
}
