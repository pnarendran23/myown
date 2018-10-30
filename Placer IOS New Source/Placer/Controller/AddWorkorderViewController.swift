//
//  AddWorkOrderController.swift
//  Placer
//
//  Created by Vishal on 29/08/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit
import DropDown
import CoreLocation

class AddWorkorderViewController: UIViewController, CLLocationManagerDelegate{
    
    //var workorderLog: WorkorderLog!
    var workOrderContainer = UIView()
    var sTypeLabel = UILabel()
    var sTypeDD = DropDownLabel()
    var vehLabel = UILabel()
    var vehAC = DropDownLabel()
    //var selectVehicleInfolabel = UILabel()
    var regNumLabel = UILabel()
    var regNumTF = DropDownTextField()
    var vehModelLabel = UILabel()
    var vehModelAC = UILabel()
    var contNameLabel = UILabel()
    var contNameTF = DropDownTextField()
    var contNumLabel = UILabel()
    var contNumTF = DropDownTextField()
    var schDateLabel = UILabel()
    var schDateTextLabel = UILabel()
    var priorityLabel = UILabel()
    var priorityDD = DropDownLabel()
    var orderDesLabel = UILabel()
    var orderDesTF = DropDownTextField()
    var addressLabel = UILabel()
    var addressTF = DropDownTextField()
    var containerView = UIView()
    var addWorkOrderButton = UIButton()
    let locationManager = CLLocationManager()
    var serviceDropDown = DropDown()
    var vehDropDown = DropDown()
    var vehNames: [String] = []

    let scrollView = UIScrollView(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.scrollView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.initViews()
        self.initWorkorderView()
    }
    
    override func loadView() {
        // calling self.view later on will return a UIView!, but we can simply call
        // self.scrollView to adjust properties of the scroll view:
        self.view = self.scrollView
        
        // setup the scroll view
        self.scrollView.contentSize = CGSize(width:UIScreen.main.bounds.width, height: 1400)
        // etc...
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0] 
                self.displayLocationInfo(pm)
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    
    func displayLocationInfo(_ placemark: CLPlacemark!) {
        if (placemark != nil) {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            
            let name = (placemark.name != nil) ? placemark.name : ""
            //let description = (placemark.description != "") ? placemark.description : ""
            let subLocality = (placemark.subLocality != nil) ? placemark.subLocality : ""
            let locality = (placemark.locality != nil) ? placemark.locality : ""
            let postalCode = (placemark.postalCode != nil) ? placemark.postalCode : ""
            let administrativeArea = (placemark.administrativeArea != nil) ? placemark.administrativeArea : ""
            let country = (placemark.country != nil) ? placemark.country : ""
            
            //print("Description \(description)")
            print("Name \(name), Sub Locality \(subLocality), locality \(locality), Postal Code \(postalCode), Administrative Area \(administrativeArea), Country \(country)")
            var completeAddress = ""
            if(!(name?.isEmpty)!){
                completeAddress = name!
            }
            
            if(!(subLocality?.isEmpty)!){
                completeAddress += ", \(subLocality!)"
            }
            
            if(!(locality?.isEmpty)!){
                completeAddress += ", \(locality!)"
            }
            
            if(!(postalCode?.isEmpty)!){
                completeAddress += ", \(postalCode!)"
            }
            
            if(!(administrativeArea?.isEmpty)!){
                completeAddress += ", \(administrativeArea!)"
            }
            
            if(!(country?.isEmpty)!){
                completeAddress += ", \(country!)"
            }
            
            if(completeAddress.isEmpty){
                self.addressTF.text = "Unable to find location, enter manually!"
            }else{
                self.addressTF.text = completeAddress
            }
            
//            localityTxtField.text = locality
//            postalCodeTxtField.text = postalCode
//            aAreaTxtField.text = administrativeArea
//            countryTxtField.text = country
        }
    }
    
    func initViews(){
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        //nav title
        self.title = ""
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: (self.navigationController?.navigationBar.frame.height)!))
        titleLabel.center = (navigationController?.navigationBar.center)!
        titleLabel.text = "Add Workorder"
        titleLabel.font = UIFont(name: "Roboto-Light", size: 18.0)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        navigationItem.titleView = titleLabel
        //print(self.workorderLog.vehName)
    }
    
    func handleServiceType(){
        self.serviceDropDown.show()
    }
    
    func handleVehType(){
        print("handleVeh tapped!")
        self.vehDropDown.show()
    }
    
    func initWorkorderView(){
        
        self.sTypeLabel.text = "Service Type "
        self.sTypeLabel.font = UIFont(name: "Roboto-Medium", size: 11.0)
        self.sTypeLabel.setupLabelDynamicSize(11)
        self.sTypeLabel.textAlignment = .left
        self.sTypeLabel.textColor = UIColor.hexStringToUIColor(Colors.colorTextSecondaryTwo)
        self.sTypeLabel.numberOfLines = 1
        
        self.sTypeDD.layer.cornerRadius = 8
        self.sTypeDD.layer.borderWidth = 1
        self.sTypeDD.layer.borderColor = UIColor.black.cgColor
        self.sTypeDD.text = "Select Service Type"
        self.sTypeDD.font = UIFont(name: "Roboto-Light", size: 11.0)
        self.sTypeDD.setupLabelDynamicSize(11)
        self.sTypeDD.textColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
        self.sTypeDD.isUserInteractionEnabled = true
        let reportTapRecogniser = UITapGestureRecognizer(target:self, action:#selector(AddWorkorderViewController.handleServiceType))
        reportTapRecogniser.numberOfTapsRequired = 1
        self.sTypeDD.addGestureRecognizer(reportTapRecogniser)
        
        self.serviceDropDown.anchorView = self.sTypeDD
        self.serviceDropDown.dataSource = ["INSTALL", "UNINSTALL",  "REPAIR", "COMPLAINT"]
        //, "Fuel Sensor Report", "Box Disconnect Report"]
        self.serviceDropDown.direction = .bottom
        
        serviceDropDown.selectionAction = { [unowned self] (index, item) in
            self.sTypeDD.text = item
        }
        
        self.vehLabel.text = "Select Vehicle"
        self.vehLabel.font = UIFont(name: "Roboto-Medium", size: 11.0)
        self.vehLabel.setupLabelDynamicSize(11)
        self.vehLabel.textAlignment = .left
        self.vehLabel.textColor = UIColor.hexStringToUIColor(Colors.colorTextSecondaryTwo)
        self.vehLabel.numberOfLines = 1
        
        self.vehAC.layer.cornerRadius = 8
        self.vehAC.layer.borderWidth = 1
        self.vehAC.layer.borderColor = UIColor.black.cgColor
        self.vehAC.text = "Select Vehicle"
        self.vehAC.font = UIFont(name: "Roboto-Light", size: 11.0)
        self.vehAC.setupLabelDynamicSize(11)
        self.vehAC.textAlignment = .left
        self.vehAC.textColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
        self.vehAC.isUserInteractionEnabled = true
        let vehTapRecogniser = UITapGestureRecognizer(target:self, action:#selector(AddWorkorderViewController.handleVehType))
        reportTapRecogniser.numberOfTapsRequired = 1
        self.vehAC.addGestureRecognizer(vehTapRecogniser)
        self.vehDropDown.anchorView = self.vehAC
        self.vehDropDown.dataSource = self.vehNames
        self.vehDropDown.direction = .any
        
        vehDropDown.selectionAction = { [unowned self] (index, item) in
            self.vehAC.text = item
        }
        //self.vehAC.numberOfLines = 1
        
        self.regNumLabel.text = "Vehicle Regn. Number"
        self.regNumLabel.font = UIFont(name: "Roboto-Medium", size: 11.0)
        self.regNumLabel.setupLabelDynamicSize(11)
        self.regNumLabel.textAlignment = .left
        self.regNumLabel.textColor = UIColor.hexStringToUIColor(Colors.colorTextSecondaryTwo)
        self.regNumLabel.numberOfLines = 1
        
        self.regNumTF.layer.cornerRadius = 8
        self.regNumTF.layer.borderWidth = 1
        self.regNumTF.layer.borderColor = UIColor.black.cgColor
        self.regNumTF.text = ""
        self.regNumTF.font = UIFont(name: "Roboto-Light", size: 11.0)
        //self.regNumTF.setupLabelDynamicSize(11)
        self.regNumTF.textAlignment = .left
        self.regNumTF.textColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
        //self.regNumTF.numberOfLines = 1
        
        self.vehModelLabel.text = "Vehicle Model"
        self.vehModelLabel.font = UIFont(name: "Roboto-Medium", size: 11.0)
        self.vehModelLabel.setupLabelDynamicSize(11)
        self.vehModelLabel.textAlignment = .left
        self.vehModelLabel.textColor = UIColor.hexStringToUIColor(Colors.colorTextSecondaryTwo)
        self.vehModelLabel.numberOfLines = 1
        
        self.vehModelAC.layer.cornerRadius = 8
        self.vehModelAC.layer.borderWidth = 1
        self.vehModelAC.layer.borderColor = UIColor.black.cgColor
        self.vehModelAC.text = ""
        self.vehModelAC.font = UIFont(name: "Roboto-Light", size: 11.0)
        //self.vehModelAC.setupLabelDynamicSize(11)
        self.vehModelAC.textAlignment = .left
        self.vehModelAC.textColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
        //self.vehModelAC.numberOfLines = 1
        
        self.contNameLabel.text = "Contact Person Name"
        self.contNameLabel.font = UIFont(name: "Roboto-Medium", size: 11.0)
        self.contNameLabel.setupLabelDynamicSize(11)
        self.contNameLabel.textAlignment = .left
        self.contNameLabel.textColor = UIColor.hexStringToUIColor(Colors.colorTextSecondaryTwo)
        self.contNameLabel.numberOfLines = 1
        
        self.contNameTF.layer.cornerRadius = 8
        self.contNameTF.layer.borderWidth = 1
        self.contNameTF.layer.borderColor = UIColor.black.cgColor
        self.contNameTF.text = ""
        self.contNameTF.font = UIFont(name: "Roboto-Light", size: 11.0)
        //self.contNameTF.setupLabelDynamicSize(11)
        self.contNameTF.textAlignment = .left
        self.contNameTF.textColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
        //self.contNameTF.numberOfLines = 1
        
        self.contNumLabel.text = "Contact Person Number"
        self.contNumLabel.font = UIFont(name: "Roboto-Medium", size: 11.0)
        self.contNumLabel.setupLabelDynamicSize(11)
        self.contNumLabel.textAlignment = .left
        self.contNumLabel.textColor = UIColor.hexStringToUIColor(Colors.colorTextSecondaryTwo)
        self.contNumLabel.numberOfLines = 1
        
        self.contNumTF.layer.cornerRadius = 8
        self.contNumTF.layer.borderWidth = 1
        self.contNumTF.layer.borderColor = UIColor.black.cgColor
        self.contNumTF.text = ""
        self.contNumTF.font = UIFont(name: "Roboto-Light", size: 11.0)
        //self.contNumTF.setupLabelDynamicSize(11)
        self.contNumTF.textAlignment = .left
        self.contNumTF.textColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
        //self.contNumTF.numberOfLines = 1
        
        self.schDateLabel.text = "Schedule Date"
        self.schDateLabel.font = UIFont(name: "Roboto-Medium", size: 11.0)
        self.schDateLabel.setupLabelDynamicSize(11)
        self.schDateLabel.textAlignment = .left
        self.schDateLabel.textColor = UIColor.hexStringToUIColor(Colors.colorTextSecondaryTwo)
        self.schDateLabel.numberOfLines = 1
        
        self.schDateTextLabel.layer.cornerRadius = 8
        self.schDateTextLabel.layer.borderWidth = 1
        self.schDateTextLabel.layer.borderColor = UIColor.black.cgColor
        self.schDateTextLabel.text = ""
        self.schDateTextLabel.font = UIFont(name: "Roboto-Light", size: 11.0)
        self.schDateTextLabel.setupLabelDynamicSize(11)
        self.schDateTextLabel.textAlignment = .left
        self.schDateTextLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
        self.schDateTextLabel.numberOfLines = 1
        
        self.priorityLabel.text = "Priority"
        self.priorityLabel.font = UIFont(name: "Roboto-Medium", size: 11.0)
        self.priorityLabel.setupLabelDynamicSize(11)
        self.priorityLabel.textAlignment = .left
        self.priorityLabel.textColor = UIColor.hexStringToUIColor(Colors.colorTextSecondaryTwo)
        self.priorityLabel.numberOfLines = 1
        
        self.priorityDD.layer.cornerRadius = 8
        self.priorityDD.layer.borderWidth = 1
        self.priorityDD.layer.borderColor = UIColor.black.cgColor
        self.priorityDD.text = "Select Priority"
        self.priorityDD.font = UIFont(name: "Roboto-Light", size: 11.0)
        self.priorityDD.setupLabelDynamicSize(11)
        self.priorityDD.textAlignment = .left
        self.priorityDD.textColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
        self.priorityDD.numberOfLines = 1
        
        self.orderDesLabel.text = "Order Description "
        self.orderDesLabel.font = UIFont(name: "Roboto-Medium", size: 11.0)
        self.orderDesLabel.setupLabelDynamicSize(11)
        self.orderDesLabel.textAlignment = .left
        self.orderDesLabel.textColor = UIColor.hexStringToUIColor(Colors.colorTextSecondaryTwo)
        self.orderDesLabel.numberOfLines = 1
        
        self.orderDesTF.layer.cornerRadius = 8
        self.orderDesTF.layer.borderWidth = 1
        self.orderDesTF.layer.borderColor = UIColor.black.cgColor
        self.orderDesTF.text = ""
        self.orderDesTF.font = UIFont(name: "Roboto-Light", size: 11.0)
        self.orderDesTF.setupLabelDynamicSize(11)
        self.orderDesTF.textAlignment = .center
        //self.orderDesTF.numberOfLines = 1
        
        self.addressLabel.text = "Address "
        self.addressLabel.font = UIFont(name: "Roboto-Medium", size: 11.0)
        self.addressLabel.setupLabelDynamicSize(11)
        self.addressLabel.textAlignment = .left
        self.addressLabel.textColor = UIColor.hexStringToUIColor(Colors.colorTextSecondaryTwo)
        self.addressLabel.numberOfLines = 1
        
        self.addressTF.layer.cornerRadius = 8
        self.addressTF.layer.borderWidth = 1
        self.addressTF.layer.borderColor = UIColor.black.cgColor
        self.addressTF.font = UIFont(name: "Roboto-Light", size: 11.0)
        self.addressTF.setupLabelDynamicSize(11)
        self.addressTF.textAlignment = .center
        self.addressTF.textColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
        //self.addressTF.numberOfLines = 1
        
        self.addWorkOrderButton.setTitle("Add Workorder", for: UIControlState())
        self.addWorkOrderButton.setTitleColor(UIColor.hexStringToUIColor("#323754"), for: UIControlState())
        self.addWorkOrderButton.layer.cornerRadius = 25
        self.addWorkOrderButton.layer.borderWidth = 1
        self.addWorkOrderButton.backgroundColor = UIColor.hexStringToUIColor("#8C93BA")
        self.addWorkOrderButton.layer.borderColor = UIColor.hexStringToUIColor("#8C93BA").cgColor
        //self.generateReportButton.center = CGPoint(x: self.view.center.x, y: self.view.frame.height-105)
        //self.addWorkOrderButton.addTarget(self, action: #selector(ReportsViewController.navigateToNavigateReportDetails(_:)), forControlEvents: .TouchUpInside)
        
        self.sTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.sTypeDD.translatesAutoresizingMaskIntoConstraints = false
        self.vehLabel.translatesAutoresizingMaskIntoConstraints = false
        self.vehAC.translatesAutoresizingMaskIntoConstraints = false
        self.regNumLabel.translatesAutoresizingMaskIntoConstraints = false
        self.regNumTF.translatesAutoresizingMaskIntoConstraints = false
        self.vehModelLabel.translatesAutoresizingMaskIntoConstraints = false
        self.vehModelAC.translatesAutoresizingMaskIntoConstraints = false
        self.contNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contNameTF.translatesAutoresizingMaskIntoConstraints = false
        self.contNumLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contNumTF.translatesAutoresizingMaskIntoConstraints = false
        self.schDateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.schDateTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.priorityLabel.translatesAutoresizingMaskIntoConstraints = false
        self.priorityDD.translatesAutoresizingMaskIntoConstraints = false
        self.orderDesLabel.translatesAutoresizingMaskIntoConstraints = false
        self.orderDesTF.translatesAutoresizingMaskIntoConstraints = false
        self.addressLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addressTF.translatesAutoresizingMaskIntoConstraints = false
        self.addWorkOrderButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.workOrderContainer.addSubview(self.sTypeLabel)
        self.workOrderContainer.addSubview(self.sTypeDD)
        self.workOrderContainer.addSubview(self.vehLabel)
        self.workOrderContainer.addSubview(self.vehAC)
        self.workOrderContainer.addSubview(self.regNumLabel)
        self.workOrderContainer.addSubview(self.regNumTF)
        self.workOrderContainer.addSubview(self.vehModelLabel)
        self.workOrderContainer.addSubview(self.vehModelAC)
        self.workOrderContainer.addSubview(self.contNameLabel)
        self.workOrderContainer.addSubview(self.contNameTF)
        self.workOrderContainer.addSubview(self.contNumLabel)
        self.workOrderContainer.addSubview(self.contNumTF)
        self.workOrderContainer.addSubview(self.schDateLabel)
        self.workOrderContainer.addSubview(self.schDateTextLabel)
        self.workOrderContainer.addSubview(self.priorityLabel)
        self.workOrderContainer.addSubview(self.priorityDD)
        self.workOrderContainer.addSubview(self.orderDesLabel)
        self.workOrderContainer.addSubview(self.orderDesTF)
        self.workOrderContainer.addSubview(self.addressLabel)
        self.workOrderContainer.addSubview(self.addressTF)
        self.workOrderContainer.addSubview(self.addWorkOrderButton)
        
        let subViewsDict = [
            "sTypeLabel" : sTypeLabel,
            "sTypeDD" : sTypeDD,
            "vehLabel" : vehLabel,
            "vehAC" : vehAC,
            "regNumLabel" : regNumLabel,
            "regNumTF" : regNumTF,
            "vehModelLabel" : vehModelLabel,
            "vehModelAC" : vehModelAC,
            "contNameLabel" : contNameLabel,
            "contNameTF" : contNameTF,
            "contNumLabel" : contNumLabel,
            "contNumTF" : contNumTF,
            "schDateLabel" : schDateLabel,
            "schDateTextLabel" : schDateTextLabel,
            "priorityLabel" : priorityLabel,
            "priorityDD" : priorityDD,
            "orderDesLabel" : orderDesLabel,
            "orderDesTF" : orderDesTF,
            "addressLabel" : addressLabel,
            "addressTF" : addressTF,
            "addWorkOrderButton" : addWorkOrderButton
        ] as [String : Any]
        
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[sTypeLabel(40)]-0-[sTypeDD(40)]-4-[vehLabel(40)]-0-[vehAC(40)]-4-[regNumLabel(40)]-0-[regNumTF(40)]-4-[vehModelLabel(40)]-0-[vehModelAC(40)]-4-[contNameLabel(40)]-0-[contNameTF(40)]-4-[contNumLabel(40)]-0-[contNumTF(40)]-4-[schDateLabel(40)]-0-[schDateTextLabel(40)]-4-[priorityLabel(40)]-0-[priorityDD(40)]-4-[orderDesLabel(40)]-0-[orderDesTF(150)]-4-[addressLabel(40)]-0-[addressTF(40)]-16-[addWorkOrderButton(50)]", options: [], metrics: nil, views: subViewsDict))
        
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[sTypeLabel(195)]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[sTypeDD(288)]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[vehLabel(195)]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[vehAC(288)]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[regNumLabel(195)]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[regNumTF(288)]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[vehModelLabel(195)]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[vehModelAC(288)]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[contNameLabel(195)]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[contNameTF(288)]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[contNumLabel(195)]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[contNumTF(288)]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[schDateLabel(195)]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[schDateTextLabel(288)]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[priorityLabel(195)]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[priorityDD(288)]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[orderDesLabel(195)]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[orderDesTF(288)]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[addressLabel(195)]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[addressTF(288)]", options: [], metrics: nil, views: subViewsDict))
        
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[addWorkOrderButton(257)]", options: [], metrics: nil, views: subViewsDict))
        
        
        
        self.workOrderContainer.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.addSubview(self.workOrderContainer)
        
        let viewsDict = [
            "workOrderContainer" : workOrderContainer,
        ]
        
        self.containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[workOrderContainer]-0-|", options: [], metrics: nil, views: viewsDict))
        
        self.containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[workOrderContainer]-0-|", options: [], metrics: nil, views: viewsDict))
        
        self.containerView.frame = CGRect(x: 0, y: 0, width: 320, height: self.view.frame.height)//self.view.frame
        
        self.view.addSubview(self.containerView)
        
        self.containerView.center.x = self.view.center.x
        self.containerView.center.y = self.view.center.y
        
    }
    
}
