//
//  row3.swift
//  Arcskoru
//
//  Created by Group X on 10/05/17.
//
//

import UIKit

class row3: UITableViewCell {

    @IBOutlet weak var vv: UIView!
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
    @IBOutlet weak var valuee4: UILabel!
    @IBOutlet weak var valuee3: UILabel!
    @IBOutlet weak var valuee2: UILabel!
    @IBOutlet weak var valuee1: UILabel!
    @IBOutlet weak var lbll2: UILabel!
    @IBOutlet weak var lbll1: UILabel!
    @IBOutlet weak var segctrll: UISegmentedControl!
    @IBOutlet weak var titlee: UILabel!
}

