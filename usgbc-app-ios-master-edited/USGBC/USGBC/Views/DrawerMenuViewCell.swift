//
//  DrawerMenuViewCell.swift
//  USGBC
//
//  Created by Vishal Raj on 15/02/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

class DrawerMenuViewCell: UITableViewCell {
    
    let cellImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "temp")!.withRenderingMode(.alwaysTemplate)
        image.tintColor = UIColor.white
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
//        image.layer.cornerRadius = 1
//        image.layer.borderWidth = 1
//        image.layer.borderColor = UIColor.hexStringToUIColor(hex: "#8C93BA").cgColor

        return image
    }()
    
    let cellLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.text = "Test Text"
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
        
        addSubview(cellImage)
        addSubview(cellLabel)
        
        let viewsDict = [
            "cellImage" : cellImage,
            "cellLabel" : cellLabel
        ]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cellLabel(44)]", options: [], metrics: nil, views: viewsDict))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[cellImage(24)]", options: [], metrics: nil, views: viewsDict))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[cellImage(24)]-4-[cellLabel]-8-|", options: [], metrics: nil, views: viewsDict))
        
    }
}
