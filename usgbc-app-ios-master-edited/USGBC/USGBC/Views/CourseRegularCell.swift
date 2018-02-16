//
//  CourseRegularCollectionViewCell.swift
//  USGBC
//
//  Created by Vishal Raj on 19/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import SwiftyStarRatingView

class CourseRegularCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var providerLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ratingView: SwiftyStarRatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initViews()
    }
    
    func initViews(){
        //titleLabel.font = UIFont.gothamBold(size: 15)
        //providerLabel.font = UIFont.gothamMedium(size: 13)
    }
    
    func updateViews(course: Course){
        let image = UIImage(named: "logo-usgbc-gray")
        imageView.kf.setImage(with: URL(string: course.image), placeholder: image)
        imageView.layer.cornerRadius = 2
        imageView.clipsToBounds = true
        titleLabel.attributedText = Utility.linespacedString(string: course.title, lineSpace: 2)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .left
        titleLabel.attributedText = NSAttributedString(string: (titleLabel.attributedText?.string)!,attributes: [NSParagraphStyleAttributeName : paragraph])
        providerLabel.text = course.provider_name
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        ratingView.value = CGFloat(NumberFormatter().number(from: course.star_rating)!)
    }
}
