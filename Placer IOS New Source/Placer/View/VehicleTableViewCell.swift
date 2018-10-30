//
//  VehicleTableViewCell.swift
//  Placer
//
//  Created by Vishal on 09/08/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit

class VehicleTableViewCell: UITableViewCell {
    
    var vehNameLabel = UILabel()
    var vehModelImageView = UIImageView()
    var vehModelLabel = UILabel()
    var vehSpeedImageView = UIImageView()
    var vehSpeedLabel = UILabel()
    var vehUpdateTimeImageView = UIImageView()
    var vehUpdateTimeLabel = UILabel()
    var vehLocationImageView = UIImageView()
    var vehLocationLabel = UILabel()
    var pwrImageView = UIImageView()
    var gpsImageView = UIImageView()
    var acImageView = UIImageView()
    var ingImageView = UIImageView()
    var locationImageView = UIImageView()
    var locationLabelVIew = UILabel()
    var viewOnMapView = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews(){
        self.vehNameLabel.font = UIFont(name: "Roboto-Bold", size: 14.0)
        self.vehNameLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        
        
        let veh = UIImage(named: "vehicle")!.withRenderingMode(.alwaysTemplate)
        self.vehModelImageView.image = veh
        self.vehModelImageView.tintColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        
        self.vehModelLabel.font = UIFont(name: "Roboto-Regular", size: 11.0)
        self.vehModelLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        
        let speed = UIImage(named: "speed")!.withRenderingMode(.alwaysTemplate)
        self.vehSpeedImageView.image = speed
        self.vehSpeedImageView.tintColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        
        self.vehSpeedLabel.font = UIFont(name: "Roboto-Regular", size: 11.0)
        self.vehSpeedLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
    
        let time = UIImage(named: "time")!.withRenderingMode(.alwaysTemplate)
        self.vehUpdateTimeImageView.image = time
        self.vehUpdateTimeImageView.tintColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        
        self.vehUpdateTimeLabel.font = UIFont(name: "Roboto-Regular", size: 11.0)
        self.vehUpdateTimeLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        
        let location = UIImage(named: "location")!.withRenderingMode(.alwaysTemplate)
        self.vehLocationImageView.image = location
        self.vehLocationImageView.tintColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        
        self.vehLocationLabel.font = UIFont(name: "Roboto-Regular", size: 11.0)
        self.vehLocationLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        
        let pwr = UIImage(named: "pwr_gray")!.withRenderingMode(.alwaysTemplate)
        self.pwrImageView.image = pwr
        self.pwrImageView.tintColor = UIColor.gray
        
        let gps = UIImage(named: "gps_gray")!.withRenderingMode(.alwaysTemplate)
        self.gpsImageView.image = gps
        self.gpsImageView.tintColor = UIColor.gray
        
        let ac = UIImage(named: "ac_gray")!.withRenderingMode(.alwaysTemplate)
        self.acImageView.image = ac
        self.acImageView.tintColor = UIColor.gray
        
        let ing = UIImage(named: "ing_gray")!.withRenderingMode(.alwaysTemplate)
        self.ingImageView.image = ing
        self.ingImageView.tintColor = UIColor.gray
        
        let locationImg = UIImage(named: "location")!.withRenderingMode(.alwaysTemplate)
        self.locationImageView.image = locationImg
        self.locationImageView.tintColor = UIColor.hexStringToUIColor(Colors.view_on_map)
        
        self.locationLabelVIew.text = "VIEW ON MAP"
        self.locationLabelVIew.font = UIFont(name: "Roboto-Regular", size: 12.0)
        self.locationLabelVIew.textColor = UIColor.hexStringToUIColor(Colors.view_on_map)
        
        self.locationImageView.translatesAutoresizingMaskIntoConstraints = false
        self.locationLabelVIew.translatesAutoresizingMaskIntoConstraints = false
        
        self.viewOnMapView.layoutMargins = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        
        self.viewOnMapView.layer.cornerRadius = 4
        self.viewOnMapView.layer.borderWidth = 1
        self.viewOnMapView.layer.borderColor = UIColor.hexStringToUIColor(Colors.row_green).cgColor
        
        self.viewOnMapView.addSubview(self.locationImageView)
        self.viewOnMapView.addSubview(self.locationLabelVIew)
        
        let subViewDict = [
            "locationImageView":locationImageView,
            "locationLabelVIew":locationLabelVIew
        ] as [String : Any]
        
        self.viewOnMapView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[locationImageView(15)]-4-[locationLabelVIew]", options: [], metrics: nil, views: subViewDict))
        self.viewOnMapView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[locationImageView(15)]", options: [], metrics: nil, views: subViewDict))
        self.viewOnMapView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[locationLabelVIew(15)]", options: [], metrics: nil, views: subViewDict))
        
        
        self.vehNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.vehModelImageView.translatesAutoresizingMaskIntoConstraints = false
        self.vehModelLabel.translatesAutoresizingMaskIntoConstraints = false
        self.vehSpeedImageView.translatesAutoresizingMaskIntoConstraints = false
        self.vehSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        self.vehUpdateTimeImageView.translatesAutoresizingMaskIntoConstraints = false
        self.vehUpdateTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.vehLocationImageView.translatesAutoresizingMaskIntoConstraints = false
        self.vehLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.pwrImageView.translatesAutoresizingMaskIntoConstraints = false
        self.gpsImageView.translatesAutoresizingMaskIntoConstraints = false
        self.acImageView.translatesAutoresizingMaskIntoConstraints = false
        self.ingImageView.translatesAutoresizingMaskIntoConstraints = false
        self.viewOnMapView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(self.vehNameLabel)
        contentView.addSubview(self.vehModelImageView)
        contentView.addSubview(self.vehModelLabel)
        contentView.addSubview(self.vehSpeedImageView)
        contentView.addSubview(self.vehSpeedLabel)
        contentView.addSubview(self.vehUpdateTimeImageView)
        contentView.addSubview(self.vehUpdateTimeLabel)
        contentView.addSubview(self.vehLocationImageView)
        contentView.addSubview(self.vehLocationLabel)
        contentView.addSubview(self.pwrImageView)
        contentView.addSubview(self.gpsImageView)
        contentView.addSubview(self.acImageView)
        contentView.addSubview(self.ingImageView)
        contentView.addSubview(self.viewOnMapView)
        
        let viewsDict = [
            "vehNameLabel" : vehNameLabel,
            "vehModelImageView" : vehModelImageView,
            "vehModelLabel" : vehModelLabel,
            "vehSpeedImageView" : vehSpeedImageView,
            "vehSpeedLabel" : vehSpeedLabel,
            "vehUpdateTimeImageView" : vehUpdateTimeImageView,
            "vehUpdateTimeLabel" : vehUpdateTimeLabel,
            "vehLocationImageView" : vehLocationImageView,
            "vehLocationLabel" : vehLocationLabel,
            "pwrImageView" : pwrImageView,
            "gpsImageView" : gpsImageView,
            "acImageView" : acImageView,
            "ingImageView" : ingImageView,
            "viewOnMapView": viewOnMapView
            ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[vehNameLabel]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[vehModelImageView(15)]-8-[vehModelLabel]|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[vehSpeedImageView(15)]-8-[vehSpeedLabel(50)]-78-[vehUpdateTimeImageView(15)]-8-[vehUpdateTimeLabel]|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[vehLocationImageView(15)]-8-[vehLocationLabel]-16-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[vehNameLabel(15)]-[vehModelImageView(15)]-[vehSpeedImageView(15)]-[vehLocationImageView(15)]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[vehNameLabel]-10-[vehModelLabel]-10-[vehSpeedLabel]-10-[vehLocationLabel]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[vehModelLabel]-[vehUpdateTimeImageView(15)]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[vehModelLabel]-10-[vehUpdateTimeLabel]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[pwrImageView(15)]-4-[gpsImageView(15)]-4-[acImageView(15)]-4-[ingImageView(15)]-16-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[pwrImageView(15)]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[gpsImageView(15)]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[acImageView(15)]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[ingImageView(15)]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[ingImageView]-[viewOnMapView(18)]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[viewOnMapView(104)]-16-|", options: [], metrics: nil, views: viewsDict))

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
