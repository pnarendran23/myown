//
//  WorkorderCell.swift
//  Placer
//
//  Created by Vishal on 24/10/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit
import QuartzCore

class WorkorderCell: UITableViewCell {
    var workorderImageView = UIImageView()
    var vehNameLabel = UILabel()
    var serviceTypeLabel = UILabel()
    var priorityLabel = UILabel()
    var statusLabel = UILabel()
    var createdOnLabel = UILabel()
    var scheduledOnLabel = UILabel()
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
        
        self.workorderImageView.frame = CGRect(x: 12, y: 12, width: 60, height: 60)
        let workorder = UIImage(named: "workorder")!.withRenderingMode(.alwaysTemplate)
        self.workorderImageView.image = workorder
        self.workorderImageView.tintColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
        self.workorderImageView.contentMode = .scaleAspectFit
        //self.workorderImageView.layer.borderWidth = 1
        //self.workorderImageView.layer.borderColor = UIColor.greenColor().CGColor
        
        self.vehNameLabel.frame = CGRect(x: 82, y: 8, width: width - 82, height: 20)
        self.vehNameLabel.text = ""
        self.vehNameLabel.font = UIFont(name: "Roboto-Bold", size: 13.0)
        self.vehNameLabel.textAlignment = .left
        self.vehNameLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
        //self.vehNameLabel.layer.borderWidth = 1
        //self.vehNameLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.serviceTypeLabel.frame = CGRect(x: 82, y: 30, width: 74, height: 20)
        self.serviceTypeLabel.text = ""
        self.serviceTypeLabel.font = UIFont(name: "Roboto-Regular", size: 10.0)
        self.serviceTypeLabel.textAlignment = .center
        self.serviceTypeLabel.textColor = UIColor.white
        self.serviceTypeLabel.layer.backgroundColor = UIColor.hexStringToUIColor(Colors.work_red).cgColor
        self.serviceTypeLabel.layer.cornerRadius = 4
//        self.serviceTypeLabel.layer.borderWidth = 1
//        self.serviceTypeLabel.layer.borderColor = UIColor.hexStringToUIColor(Colors.work_red).CGColor
        
        self.priorityLabel.frame = CGRect(x: 158, y: 30, width: 74, height: 20)
        self.priorityLabel.text = ""
        self.priorityLabel.font = UIFont(name: "Roboto-Regular", size: 10.0)
        self.priorityLabel.textAlignment = .center
        self.priorityLabel.textColor = UIColor.white
        self.priorityLabel.layer.backgroundColor = UIColor.hexStringToUIColor(Colors.work_green).cgColor
        self.priorityLabel.layer.cornerRadius = 4
//        self.priorityLabel.layer.borderWidth = 1
//        self.priorityLabel.layer.borderColor = UIColor.hexStringToUIColor(Colors.work_green).CGColor
        
        self.statusLabel.frame = CGRect(x: 234, y: 30, width: 74, height: 20)
        self.statusLabel.text = ""
        self.statusLabel.font = UIFont(name: "Roboto-Regular", size: 10.0)
        self.statusLabel.textAlignment = .center
        self.statusLabel.textColor = UIColor.white
        self.statusLabel.layer.backgroundColor = UIColor.hexStringToUIColor(Colors.work_blue).cgColor
        self.statusLabel.layer.cornerRadius = 4
//        self.statusLabel.layer.borderWidth = 1
//        self.statusLabel.layer.borderColor = UIColor.hexStringToUIColor(Colors.work_blue).CGColor
        
        self.createdOnLabel.frame = CGRect(x: 82, y: 52, width: width - 82, height: 20)
        self.createdOnLabel.text = ""
        self.createdOnLabel.font = UIFont(name: "Roboto-Regular", size: 10.0)
        self.createdOnLabel.textAlignment = .left
        //self.createdOnLabel.layer.borderWidth = 1
        //self.createdOnLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.scheduledOnLabel.frame = CGRect(x: 82, y: 68, width: width - 82, height: 20)
        self.scheduledOnLabel.text = ""
        self.scheduledOnLabel.font = UIFont(name: "Roboto-Regular", size: 10.0)
        self.scheduledOnLabel.textAlignment = .left
        //self.scheduledOnLabel.layer.borderWidth = 1
        //self.scheduledOnLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.backView.addSubview(self.workorderImageView)
        self.backView.addSubview(self.vehNameLabel)
        self.backView.addSubview(self.serviceTypeLabel)
        self.backView.addSubview(self.priorityLabel)
        self.backView.addSubview(self.statusLabel)
        self.backView.addSubview(self.createdOnLabel)
        self.backView.addSubview(self.scheduledOnLabel)
        
        contentView.addSubview(backView)
    }
}

