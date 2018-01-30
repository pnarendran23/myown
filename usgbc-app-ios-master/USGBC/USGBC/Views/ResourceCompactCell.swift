//
//  ResourceCompactCollectionViewCell.swift
//  USGBC
//
//  Created by Vishal Raj on 20/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

class ResourceCompactCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var formatLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initViews()
    }
    
    func initViews(){
        titleLabel.font = UIFont.gothamMedium(size: 14)
        categoryLabel.font = UIFont.gothamBook(size: 12)
        formatLabel.font = UIFont.gothamMedium(size: 12)
    }
    
    func updateViews(resource: Resource){
        let image = UIImage(named: "placeholder")
        imageView.kf.setImage(with: URL(string: resource.image), placeholder: image)
        imageView.clipsToBounds = true
        titleLabel.attributedText = Utility.linespacedString(string: resource.title, lineSpace: 2)
        categoryLabel.text = resource.res_type
        formatLabel.text = resource.format
        if ( UI_USER_INTERFACE_IDIOM() == .pad ){
            separatorView.isHidden = true
        }
    }
}
