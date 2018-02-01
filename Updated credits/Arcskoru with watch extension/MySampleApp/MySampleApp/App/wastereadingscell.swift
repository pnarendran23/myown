//
//  wastereadingscell.swift
//  Arcskoru
//
//  Created by Group X on 02/03/17.
//
//

import UIKit

class wastereadingscell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var units: UILabel!

    @IBOutlet weak var wastedata: UILabel!
    @IBOutlet weak var duration: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
