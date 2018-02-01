//
//  row1.swift
//  Arcskoru
//
//  Created by Group X on 09/05/17.
//
//

import UIKit

class row1: UITableViewCell {

    @IBOutlet weak var maxlbl: UILabel!
    @IBOutlet weak var yaxis: UILabel!
    @IBOutlet weak var minlbl: UILabel!
    @IBOutlet weak var scoreslbl: UILabel!
    @IBOutlet weak var reportingperiod: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 7
        // Initialization code
    }
    
    
    @IBOutlet weak var vv: actualgraph!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    

}
