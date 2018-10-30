//
//  CreditCompactCollectionViewCell.swift
//  USGBC
//
//  Created by Vishal Raj on 19/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

class CreditCompactCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var creditPointLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initViews()
    }
    
    func initViews(){
        titleLabel.font = UIFont.gothamMedium(size: 14)
        categoryLabel.font = UIFont.gothamBook(size: 12)
        creditPointLabel.font = UIFont.gothamMedium(size: 12)
    }
    
    func updateViews(credit: Credit){
        let image = UIImage(named: "placeholder")
        imageView.kf.setImage(with: URL(string: credit.image), placeholder: image)
        imageView.clipsToBounds = true
        titleLabel.attributedText = Utility.linespacedString(string: credit.title, lineSpace: 2)
        categoryLabel.text = credit.category
        if Int(credit.points_from) != nil{
            creditPointLabel.text = "Credit | \(credit.points_from) point"
        }else{
            creditPointLabel.text = "Prerequisite | \(credit.required)"
        }
        if ( UI_USER_INTERFACE_IDIOM() == .pad ){
            separatorView.isHidden = true
        }
    }

}
