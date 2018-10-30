//
//  progresscell.swift
//  Arcskoru
//
//  Created by Group X on 03/04/17.
//
//

import UIKit

class progresscell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        percentagelbl.frame.origin.y =  0.3 * self.bounds.height
        // Initialization code
    }
    @IBOutlet weak var contextlbl: UILabel!

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var vv: progressbar!
    @IBOutlet weak var percentagelbl: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
