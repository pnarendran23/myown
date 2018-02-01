//
//  ProjectCompactCollectionViewCell.swift
//  USGBC
//
//  Created by Vishal Raj on 20/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

class ProjectCompactCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leedVersionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var certificationImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initViews()
    }
    
    func initViews(){
        titleLabel.font = UIFont.gothamMedium(size: 14)
        leedVersionLabel.font = UIFont.gothamBook(size: 12)
        addressLabel.font = UIFont.gothamMedium(size: 12)
    }
    
    func updateViews(project: Project){
        let image = UIImage(named: "logo-usgbc-gray")
        imageView.kf.setImage(with: URL(string: project.image), placeholder: image)
        imageView.clipsToBounds = true
        titleLabel.attributedText = Utility.linespacedString(string: project.title, lineSpace: 2)
        leedVersionLabel.text = project.rating_system_version
        addressLabel.text = project.address.trimmingCharacters(in: .whitespacesAndNewlines)
        certificationImageView.image = project.getCertificationLevelImage()
        if ( UI_USER_INTERFACE_IDIOM() == .pad ){
            separatorView.isHidden = true
        }
    }
}
