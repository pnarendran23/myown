//
//  MovementReportCell.swift
//  Placer
//
//  Created by Vishal on 07/09/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit

class MovementReportCell: UITableViewCell {
    var serialNumberLabel = UILabel()
    var dateTimeLabel = UILabel()
    var locationLabel = UILabel()
    var ignitionImageView = UIImageView()
    var acImageView = UIImageView()
    var speedLabel = UILabel()
    var distanceLabel = UILabel()
    var rowStackView = UIStackView()
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
        self.backView.frame = CGRect(x: 0, y: 0, width: width, height: 40)
        //print(contentView.frame.width)
        let screenUnit = self.backView.frame.width/12
        self.serialNumberLabel.frame = CGRect(x: 0, y: 5, width: screenUnit*1, height: 30)
        self.serialNumberLabel.text = ""
        self.serialNumberLabel.font = UIFont(name: "Roboto-Regular", size: 10.0)
        self.serialNumberLabel.textAlignment = .center
        self.serialNumberLabel.adjustsFontSizeToFitWidth = true
        self.serialNumberLabel.minimumScaleFactor=0.5
        //self.serialNumberLabel.layer.borderWidth = 1
        //self.serialNumberLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.dateTimeLabel.frame = CGRect(x: self.serialNumberLabel.frame.width, y: 5, width: screenUnit*2.5, height: 30)
        self.dateTimeLabel.text = ""
        self.dateTimeLabel.font = UIFont(name: "Roboto-Regular", size: 10.0)
        self.dateTimeLabel.textAlignment = .center
        self.dateTimeLabel.adjustsFontSizeToFitWidth = true
        self.dateTimeLabel.minimumScaleFactor=0.5
        //self.dateTimeLabel.layer.borderWidth = 1
        //self.dateTimeLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.locationLabel.frame = CGRect(x: self.serialNumberLabel.frame.width+self.dateTimeLabel.frame.width, y: 5, width: screenUnit*4, height: 30)
        self.locationLabel.text = ""
        self.locationLabel.font = UIFont(name: "Roboto-Regular", size: 10.0)
        self.locationLabel.textAlignment = .center
        self.locationLabel.adjustsFontSizeToFitWidth = true
        self.locationLabel.minimumScaleFactor=0.5
        self.locationLabel.numberOfLines = 2
        //self.locationLabel.layer.borderWidth = 1
        //self.locationLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.speedLabel.frame = CGRect(x: self.serialNumberLabel.frame.width+self.dateTimeLabel.frame.width+self.locationLabel.frame.width, y: 5, width: screenUnit*1.25, height: 30)
        self.speedLabel.text = ""
        self.speedLabel.font = UIFont(name: "Roboto-Regular", size: 10.0)
        self.speedLabel.textAlignment = .center
        self.speedLabel.adjustsFontSizeToFitWidth = true
        self.speedLabel.minimumScaleFactor=0.5
        //self.speedLabel.layer.borderWidth = 1
        //self.speedLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.ignitionImageView.frame = CGRect(x: self.serialNumberLabel.frame.width+self.dateTimeLabel.frame.width+self.locationLabel.frame.width+self.speedLabel.frame.width, y: 12, width: screenUnit*1, height: 15)
        let ing = UIImage(named: "ing_gray")!.withRenderingMode(.alwaysTemplate)
        self.ignitionImageView.image = ing
        self.ignitionImageView.tintColor = UIColor.gray
        self.ignitionImageView.contentMode = .scaleAspectFit
        //self.ignitionImageView.layer.borderWidth = 1
        //self.ignitionImageView.layer.borderColor = UIColor.greenColor().CGColor
        
        self.acImageView.frame = CGRect(x: self.serialNumberLabel.frame.width+self.dateTimeLabel.frame.width+self.locationLabel.frame.width+self.speedLabel.frame.width+self.ignitionImageView.frame.width, y: 12, width: screenUnit*1, height: 15)
        let ac = UIImage(named: "ac_gray")!.withRenderingMode(.alwaysTemplate)
        self.acImageView.image = ac
        self.acImageView.tintColor = UIColor.gray
        self.acImageView.contentMode = .scaleAspectFit
        //self.acImageView.layer.borderWidth = 1
        //self.acImageView.layer.borderColor = UIColor.greenColor().CGColor
        
        self.distanceLabel.frame = CGRect(x: self.serialNumberLabel.frame.width+self.dateTimeLabel.frame.width+self.locationLabel.frame.width+self.speedLabel.frame.width+self.ignitionImageView.frame.width+self.acImageView.frame.width, y: 5, width: screenUnit*1.25, height: 30)
        self.distanceLabel.text = ""
        self.distanceLabel.font = UIFont(name: "Roboto-Regular", size: 10.0)
        self.distanceLabel.textAlignment = .center
        self.distanceLabel.adjustsFontSizeToFitWidth = true
        self.distanceLabel.minimumScaleFactor=0.5
        //self.distanceLabel.layer.borderWidth = 1
        //self.distanceLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.backView.addSubview(self.serialNumberLabel)
        self.backView.addSubview(self.dateTimeLabel)
        self.backView.addSubview(self.locationLabel)
        self.backView.addSubview(self.speedLabel)
        self.backView.addSubview(self.ignitionImageView)
        self.backView.addSubview(self.acImageView)
        self.backView.addSubview(self.distanceLabel)

        contentView.addSubview(backView)
    }
}
