//
//  collcell.swift
//  Arcskoru
//
//  Created by Group X on 07/04/17.
//
//

import UIKit

class collcell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!

    @IBOutlet weak var lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 7
        self.layer.masksToBounds = true
        // Initialization code
    }

}
