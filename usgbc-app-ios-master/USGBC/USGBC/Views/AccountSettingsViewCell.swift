//
//  AccountSettingsViewCell.swift
//  USGBC
//
//  Created by Vishal Raj on 07/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

class AccountSettingsViewCell: UITableViewCell {

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
    
    let titleLabel: CustomUiLabel = {
        let label = CustomUiLabel()
        label.font = UIFont(name: "Gotham-Bold", size: 14.0)
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        label.text = ""
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Gotham-Medium", size: 14.0)
        label.textColor = UIColor.hex(hex: Colors.textColorSecondaryTwo)
        label.textAlignment = .left
        label.text = ""
        label.numberOfLines = 0
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
        addSubview(titleLabel)
        addSubview(separatorView)
        addSubview(infoLabel)
        
        let viewsDict = [
            "editImage" : editImage,
            "titleLabel" : titleLabel,
            "separatorView" : separatorView,
            "infoLabel" : infoLabel
        ]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[titleLabel]-[separatorView(1)]-8-[infoLabel]-8-|", options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[editImage(15)]-[separatorView(1)]-8-[infoLabel]-8-|", options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[titleLabel][editImage(15)]-16-|", options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[separatorView]-8-|", options: [], metrics: nil, views: viewsDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[infoLabel]-16-|", options: [], metrics: nil, views: viewsDict))
        
    }

}
