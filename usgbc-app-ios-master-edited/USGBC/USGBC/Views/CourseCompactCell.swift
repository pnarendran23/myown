//
//  CourseCompactCollectionViewCell.swift
//  USGBC
//
//  Created by Vishal Raj on 19/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import SwiftyStarRatingView

class CourseCompactCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var providerLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ratingView: SwiftyStarRatingView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var imageViewWidthConstaint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initViews()
    }

    func initViews(){
        titleLabel.font = UIFont.gothamMedium(size: 14)
        providerLabel.font = UIFont.gothamMedium(size: 12)
    }
    
    func updateViews(course: Course){
        let image = UIImage(named: "logo-usgbc-gray")
        imageView.kf.setImage(with: URL(string: course.imageSmall), placeholder: image)
        imageView.clipsToBounds = true
        titleLabel.attributedText = Utility.linespacedString(string: course.title, lineSpace: 2)
        providerLabel.text = course.provider_name
        ratingView.value = CGFloat(NumberFormatter().number(from: course.star_rating)!)
    }
}
