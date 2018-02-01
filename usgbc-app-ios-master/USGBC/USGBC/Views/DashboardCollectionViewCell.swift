//
//  DashboardArticleCell.swift
//  USGBC
//
//  Created by Vishal Raj on 22/06/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

class DashboardCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = UIColor.gray
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Gotham-Medium", size: 13.0)
        label.textColor = UIColor.hex(hex: "#444444")
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(imageView)
        addSubview(titleLabel)
        
        let viewsDict = [
            "imageView" : imageView,
            "titleLabel" : titleLabel,
        ]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[imageView(108)]-6-[titleLabel]", options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[imageView]-0-|", options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[titleLabel]-4-|", options: [], metrics: nil, views: viewsDict))
    }
}
