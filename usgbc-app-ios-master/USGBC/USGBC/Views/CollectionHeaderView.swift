//
//  CollectionHeaderView.swift
//  USGBC
//
//  Created by Vishal Raj on 18/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

class CollectionHeaderView: UICollectionViewCell {
    
    @IBOutlet weak var constraintImgSize: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.clipsToBounds = true
    }
}
