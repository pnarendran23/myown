//
//  CEHourViewCell.swift
//  USGBC
//
//  Created by Vishal Raj on 16/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

class CEHourViewCell: UITableViewCell {
    
    let editImage: UIImageView = {
        let image = UIImageView()
        //image.image = UIImage(named: "edit")!.withRenderingMode(.alwaysTemplate)
        //image.tintColor = UIColor.hexStringToUIColor(hex: Colors.primaryColor)
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let separatorView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor.lightGray
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Gotham-Book", size: 10.0)
        label.textColor = UIColor.hex(hex: Colors.primaryColor)
        label.textAlignment = .left
        label.text = "19 Nov 2015 : Education GB2015 - C06"
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Gotham-Medium", size: 12.0)
        label.textColor = UIColor.hex(hex: Colors.primaryColor)
        label.textAlignment = .left
        label.text = "Buildings & Beyond-Federal Role in Prevention and Resilience"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let earnedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Gotham-Medium", size: 12.0)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.text = "      2.0"
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews(){
        addSubview(editImage)
        addSubview(dateLabel)
        addSubview(titleLabel)
        addSubview(earnedLabel)
        
        let viewsDict = [
            "editImage" : editImage,
            "dateLabel" : dateLabel,
            "titleLabel" : titleLabel,
            "earnedLabel" : earnedLabel
        ]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[dateLabel]-4-[titleLabel]", options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[earnedLabel(50)]", options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[editImage(15)]", options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[titleLabel(200)]-8-[earnedLabel]-8-[editImage(15)]-16-|", options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[dateLabel(200)]", options: [], metrics: nil, views: viewsDict))
        
    }
    
}
