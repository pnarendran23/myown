//
//  PublicationCompactCollectionViewCell.swift
//  USGBC
//
//  Created by Vishal Raj on 19/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

class PublicationCompactCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initViews()
    }
    
    func initViews(){
        titleLabel.font = UIFont.gothamMedium(size: 14)
        categoryLabel.font = UIFont.gothamMedium(size: 12)
        progressView.isHidden = true
    }
    
    func updateViews(publication: Publication){
        let image = UIImage(named: "placeholder")
        imageView.kf.setImage(with: URL(string: "https://usgbc.org/\(publication.image)"), placeholder: image)
        imageView.clipsToBounds = true
        titleLabel.attributedText = Utility.linespacedString(string: publication.fileDescription, lineSpace: 2)
        categoryLabel.text = publication.type
        if ( UI_USER_INTERFACE_IDIOM() == .pad ){
            separatorView.isHidden = true
        }
    }

}
