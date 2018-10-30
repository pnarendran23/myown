//
//  OrganizationCompactCollectionViewCell.swift
//  USGBC
//
//  Created by Vishal Raj on 20/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

class OrganizationCompactCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var levelImageView: UIImageView!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initViews()
    }
    
    func initViews(){
        titleLabel.font = UIFont.gothamMedium(size: 14)
        addressLabel.font = UIFont.gothamBook(size: 12)
    }
    
    func updateViews(organization: Organization){
        let image = UIImage(named: "placeholder")
        imageView.kf.setImage(with: URL(string: organization.image), placeholder: image)
        imageView.clipsToBounds = true
        titleLabel.attributedText = Utility.linespacedString(string: organization.title, lineSpace: 2)
        addressLabel.text = organization.address.replacingOccurrences(of: "\n", with: "")
        levelImageView.image = organization.getLevelImage()
        if ( UI_USER_INTERFACE_IDIOM() == .pad ){
            separatorView.isHidden = true
        }
    }

}
