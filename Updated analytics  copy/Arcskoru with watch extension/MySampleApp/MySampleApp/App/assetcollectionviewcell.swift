//
//  assetcollectionviewcell.swift
//  Arcskoru
//
//  Created by Group X on 09/01/17.
//
//

import UIKit

class assetcollectionviewcell: UICollectionViewCell {

    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var leedid: UILabel!
    @IBOutlet weak var assetname: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
     status.adjustsFontSizeToFitWidth = true
     leedid.adjustsFontSizeToFitWidth = true
    assetname.adjustsFontSizeToFitWidth = true
    }

}
