//
//  NotificationCell.swift
//  Placer
//
//  Created by Vishal on 21/10/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    var notificationImageView = UIImageView()
    var notificationTypeLabel = UILabel()
    var notificationLabel = UILabel()
    var updatedLabel = UILabel()
    var backView = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews(){
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        self.backView.frame = CGRect(x: 0, y: 0, width: width, height: 130)
        
        //let screenUnit = self.backView.frame.width/12
        
        self.notificationImageView.frame = CGRect(x: 16, y: 10, width: 30, height: 30)
        let notification = UIImage(named: "notification_image")!.withRenderingMode(.alwaysTemplate)
        self.notificationImageView.image = notification
        self.notificationImageView.tintColor = UIColor.hexStringToUIColor(Colors.work_blue)
        self.notificationImageView.contentMode = .scaleAspectFit
        //self.notificationImageView.layer.borderWidth = 1
        //self.notificationImageView.layer.borderColor = UIColor.greenColor().CGColor
        
        self.notificationTypeLabel.frame = CGRect(x: 50, y: 8, width: width - 66, height: 20)
        self.notificationTypeLabel.text = ""
        self.notificationTypeLabel.font = UIFont(name: "Roboto-Bold", size: 14.0)
        self.notificationTypeLabel.textAlignment = .left
        self.notificationTypeLabel.textColor = UIColor.hexStringToUIColor(Colors.work_blue)
        //self.notificationTypeLabel.layer.borderWidth = 1
        //self.notificationTypeLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.notificationLabel.frame = CGRect(x: 50, y: 28, width: width - 66, height: 30)
        self.notificationLabel.text = ""
        self.notificationLabel.font = UIFont(name: "Roboto-Regular", size: 10.0)
        self.notificationLabel.textAlignment = .left
        self.notificationLabel.numberOfLines = 2
        //self.notificationLabel.layer.borderWidth = 1
        //self.notificationLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.updatedLabel.frame = CGRect(x: 50, y: 58, width: width - 66, height: 20)
        self.updatedLabel.text = ""
        self.updatedLabel.font = UIFont(name: "Roboto-Medium", size: 11.0)
        self.updatedLabel.textAlignment = .left
        //self.updatedLabel.layer.borderWidth = 1
        //self.updatedLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.backView.addSubview(self.notificationImageView)
        self.backView.addSubview(self.notificationTypeLabel)
        self.backView.addSubview(self.notificationLabel)
        self.backView.addSubview(self.updatedLabel)
        
        contentView.addSubview(backView)
    }
}
