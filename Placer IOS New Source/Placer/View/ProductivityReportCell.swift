//
//  ProductivityReportCell.swift
//  Placer
//
//  Created by Vishal on 08/09/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit

class ProductivityReportCell: UITableViewCell {
    
    var serialNumberLabel = UILabel()
    var dateTimeLabel = UILabel()
    var distTravelledLabel = UILabel()
    var moveDurationLabel = UILabel()
    var haltDurationLabel = UILabel()
    var maxSpeedLabel = UILabel()
    var avgSpeedLabel = UILabel()
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
        let screenUnit = self.backView.frame.width/12
        
        self.serialNumberLabel.frame = CGRect(x: 0, y: 0, width: screenUnit*1, height: 40)
        self.serialNumberLabel.text = "##"
        self.serialNumberLabel.font = UIFont(name: "Roboto-Regular", size: 10.0)
        self.serialNumberLabel.textAlignment = .center
        self.serialNumberLabel.numberOfLines = 1
        self.serialNumberLabel.adjustsFontSizeToFitWidth = true
        self.serialNumberLabel.minimumScaleFactor=0.5
        
        self.dateTimeLabel.frame = CGRect(x: self.serialNumberLabel.frame.width, y: 0, width: screenUnit*2, height: 40)
        self.dateTimeLabel.text = "Date"
        self.dateTimeLabel.font = UIFont(name: "Roboto-Regular", size: 10.0)
        self.dateTimeLabel.textAlignment = .center
        self.dateTimeLabel.numberOfLines = 1
        self.dateTimeLabel.adjustsFontSizeToFitWidth = true
        self.dateTimeLabel.minimumScaleFactor=0.5
        
        self.distTravelledLabel.frame = CGRect(x: self.serialNumberLabel.frame.width+self.dateTimeLabel.frame.width, y: 0, width: screenUnit*2, height: 40)
        self.distTravelledLabel.text = "Dist.Travelled"
        self.distTravelledLabel.font = UIFont(name: "Roboto-Regular", size: 10.0)
        self.distTravelledLabel.textAlignment = .center
        self.distTravelledLabel.numberOfLines = 1
        self.distTravelledLabel.adjustsFontSizeToFitWidth = true
        self.distTravelledLabel.minimumScaleFactor=0.5
        
        self.moveDurationLabel.frame = CGRect(x: self.serialNumberLabel.frame.width+self.dateTimeLabel.frame.width+self.distTravelledLabel.frame.width, y: 0, width: screenUnit*2, height: 40)
        self.moveDurationLabel.text = "Move.Duration"
        self.moveDurationLabel.font = UIFont(name: "Roboto-Regular", size: 10.0)
        self.moveDurationLabel.textAlignment = .center
        self.moveDurationLabel.numberOfLines = 1
        self.moveDurationLabel.adjustsFontSizeToFitWidth = true
        self.moveDurationLabel.minimumScaleFactor=0.5
        
        self.haltDurationLabel.frame = CGRect(x: self.serialNumberLabel.frame.width+self.dateTimeLabel.frame.width+self.distTravelledLabel.frame.width+self.moveDurationLabel.frame.width, y: 0, width: screenUnit*2, height: 40)
        self.haltDurationLabel.text = "Halt.Duration"
        self.haltDurationLabel.font = UIFont(name: "Roboto-Regular", size: 10.0)
        self.haltDurationLabel.textAlignment = .center
        self.haltDurationLabel.numberOfLines = 1
        self.haltDurationLabel.adjustsFontSizeToFitWidth = true
        self.haltDurationLabel.minimumScaleFactor=0.5
        
        self.maxSpeedLabel.frame = CGRect(x: self.serialNumberLabel.frame.width+self.dateTimeLabel.frame.width+self.distTravelledLabel.frame.width+self.moveDurationLabel.frame.width+self.haltDurationLabel.frame.width, y: 0, width: screenUnit*1.5, height: 40)
        self.maxSpeedLabel.text = "Max.Speed"
        self.maxSpeedLabel.font = UIFont(name: "Roboto-Regular", size: 10.0)
        self.maxSpeedLabel.textAlignment = .center
        self.maxSpeedLabel.numberOfLines = 1
        self.maxSpeedLabel.adjustsFontSizeToFitWidth = true
        self.maxSpeedLabel.minimumScaleFactor=0.5
        
        self.avgSpeedLabel.frame = CGRect(x: self.serialNumberLabel.frame.width+self.dateTimeLabel.frame.width+self.distTravelledLabel.frame.width+self.moveDurationLabel.frame.width+self.haltDurationLabel.frame.width+self.maxSpeedLabel.frame.width, y: 0, width: screenUnit*1.5, height: 40)
        self.avgSpeedLabel.text = "Avg.Speed"
        self.avgSpeedLabel.font = UIFont(name: "Roboto-Regular", size: 10.0)
        self.avgSpeedLabel.textAlignment = .center
        self.avgSpeedLabel.numberOfLines = 1
        self.avgSpeedLabel.adjustsFontSizeToFitWidth = true
        self.avgSpeedLabel.minimumScaleFactor=0.5
        
        backView.addSubview(self.serialNumberLabel)
        backView.addSubview(self.dateTimeLabel)
        backView.addSubview(self.distTravelledLabel)
        backView.addSubview(self.maxSpeedLabel)
        backView.addSubview(self.moveDurationLabel)
        backView.addSubview(self.haltDurationLabel)
        backView.addSubview(self.avgSpeedLabel)
        
        contentView.addSubview(backView)
        
    }

}
