//
//  ScorecardCell.swift
//  USGBC
//
//  Created by Vishal Raj on 31/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

class ScorecardCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scoreImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        initViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initViews(){
        containerView.layer.cornerRadius = 4
    }
    
}
