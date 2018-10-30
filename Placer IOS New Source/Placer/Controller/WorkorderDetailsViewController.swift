//
//  WorkorderDetailsViewController.swift
//  Placer
//
//  Created by Vishal on 24/10/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit
import GoogleMaps

class WorkorderDetailsViewController: UIViewController{
    
    var workorderLog: WorkorderLog!
    var workOrderContainer = UIView()
    var mapContainer = UIView()
    var userActionContainer = UIView()
    var workorderImageView = UIImageView()
    var workIdLabel = UILabel()
    var serviceTypeLabel = UILabel()
    var serviceTypeTextLabel = UILabel()
    var schDateLabel = UILabel()
    var schDateTextLabel = UILabel()
    var vehNameLabel = UILabel()
    var vehNameTextLabel = UILabel()
    var vehNumberLabel = UILabel()
    var vehNumberTextLabel = UILabel()
    var vehModelLabel = UILabel()
    var vehModelTextLabel = UILabel()
    var createdDateLabel = UILabel()
    var createdDateTextLabel = UILabel()
    var priorityLabel = UILabel()
    var priorityTextLabel = UILabel()
    var statusLabel = UILabel()
    var statusTextLabel = UILabel()
    var assNameLabel = UILabel()
    var assNameTextLabel = UILabel()
    var resolvedByLabel = UILabel()
    var resolvedByTextLabel = UILabel()
    var contNameLabel = UILabel()
    var contNameTextLabel = UILabel()
    var contNumLabel = UILabel()
    var contNumTextLabel = UILabel()
    var separaterOneView = UIView()
    var separaterTwoView = UIView()
    var separaterThreeView = UIView()
    var separaterFourView = UIView()
    var mapView: GMSMapView!
    var locationLabel = UILabel()
    var locationTextLabel = UILabel()
    var desLabel = UILabel()
    var userActionLabel = UILabel()
    var userActionTextLabel = UILabel()
    var desTextLabel = UILabel()
    var containerView = UIView()
    //var scrollView = UIScrollView()
    let scrollView = UIScrollView(frame: UIScreen.main.bounds)
    var bounds = GMSCoordinateBounds()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.scrollView.delegate = self
        self.initViews()
        self.initWorkorderView()
        self.initMapView()
        self.initActionLogs()
    }
    
    override func loadView() {
        // calling self.view later on will return a UIView!, but we can simply call
        // self.scrollView to adjust properties of the scroll view:
        self.view = self.scrollView
        
        // setup the scroll view
        self.scrollView.contentSize = CGSize(width:UIScreen.main.bounds.width, height: 1000)
        // etc...
    }
    
    func initViews(){
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        //nav title
        self.title = ""
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: (self.navigationController?.navigationBar.frame.height)!))
        titleLabel.center = (navigationController?.navigationBar.center)!
        titleLabel.text = "Workorder Details"
        titleLabel.font = UIFont(name: "Roboto-Light", size: 18.0)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        navigationItem.titleView = titleLabel
        print(self.workorderLog.vehName)
        let camera = GMSCameraPosition.camera(withLatitude: 28.613939, longitude: 77.209021, zoom: 6.0)
        self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera:camera)
//        self.mapView.layer.borderWidth = 2
//        self.mapView.layer.borderColor = UIColor.hexStringToUIColor(Colors.row_green).CGColor
        let mapInsets = UIEdgeInsets(top: 50.0, left: 50.0, bottom: 50.0, right: 50.0)
        self.mapView.padding = mapInsets
        self.mapView.settings.rotateGestures = false
        self.mapView.settings.tiltGestures = false
        self.mapView.settings.scrollGestures = false
        self.mapView.settings.zoomGestures = false
    }
    
    func initWorkorderView(){
        
        self.workOrderContainer.layer.cornerRadius = 8
        self.workOrderContainer.layer.borderWidth = 1
        self.workOrderContainer.layer.borderColor = UIColor.hexStringToUIColor(Colors.colorTextSecondary).cgColor
        
        self.mapContainer.layer.cornerRadius = 8
        self.mapContainer.layer.borderWidth = 1
        self.mapContainer.layer.borderColor = UIColor.hexStringToUIColor(Colors.colorTextSecondary).cgColor
        
        self.userActionContainer.layer.cornerRadius = 8
        self.userActionContainer.layer.borderWidth = 1
        self.userActionContainer.layer.borderColor = UIColor.hexStringToUIColor(Colors.colorTextSecondary).cgColor

        let workorder = UIImage(named: "workorder")!.withRenderingMode(.alwaysTemplate)
        self.workorderImageView.image = workorder
        self.workorderImageView.tintColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
        self.workorderImageView.contentMode = .scaleAspectFit
//        self.workorderImageView.layer.borderWidth = 1
//        self.workorderImageView.layer.borderColor = UIColor.greenColor().CGColor
        
        self.workIdLabel.text = "Work Order Id: \(self.workorderLog.workOrderId)"
        self.workIdLabel.font = UIFont(name: "Roboto-Medium", size: 12.0)
        self.workIdLabel.setupLabelDynamicSize(12)
        self.workIdLabel.textAlignment = .left
        self.workIdLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
        self.workIdLabel.numberOfLines = 1
//        self.workIdLabel.layer.borderWidth = 1
//        self.workIdLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.separaterOneView.backgroundColor = UIColor.hexStringToUIColor(Colors.colorTextSecondary)
        self.separaterTwoView.backgroundColor = UIColor.hexStringToUIColor(Colors.colorTextSecondary)
        self.separaterThreeView.backgroundColor = UIColor.hexStringToUIColor(Colors.colorTextSecondary)
        self.separaterFourView.backgroundColor = UIColor.hexStringToUIColor(Colors.colorTextSecondary)
        
        self.serviceTypeLabel.text = "Service Type "
        self.serviceTypeLabel.font = UIFont(name: "Roboto-Medium", size: 11.0)
        self.serviceTypeLabel.setupLabelDynamicSize(11)
        self.serviceTypeLabel.textAlignment = .left
        self.serviceTypeLabel.textColor = UIColor.hexStringToUIColor(Colors.colorTextSecondaryTwo)
        self.serviceTypeLabel.numberOfLines = 1
//        self.serviceTypeLabel.layer.borderWidth = 1
//        self.serviceTypeLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.serviceTypeTextLabel.text = self.workorderLog.serviceType
        self.serviceTypeTextLabel.font = UIFont(name: "Roboto-Light", size: 11.0)
        self.serviceTypeTextLabel.setupLabelDynamicSize(11)
        self.serviceTypeTextLabel.textAlignment = .center
        self.serviceTypeTextLabel.textColor = UIColor.white
        self.serviceTypeTextLabel.numberOfLines = 1
        self.serviceTypeTextLabel.layer.backgroundColor = UIColor.hexStringToUIColor(Colors.work_red).cgColor
        self.serviceTypeTextLabel.layer.cornerRadius = 4
//        self.serviceTypeTextLabel.layer.borderWidth = 1
//        self.serviceTypeTextLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.schDateLabel.text = "Schedule Date "
        self.schDateLabel.font = UIFont(name: "Roboto-Medium", size: 11.0)
        self.schDateLabel.setupLabelDynamicSize(11)
        self.schDateLabel.textAlignment = .left
        self.schDateLabel.textColor = UIColor.hexStringToUIColor(Colors.colorTextSecondaryTwo)
        self.schDateLabel.numberOfLines = 1
//        self.schDateLabel.layer.borderWidth = 1
//        self.schDateLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.schDateTextLabel.text = self.convertDate(self.workorderLog.scheduleDate)
        self.schDateTextLabel.font = UIFont(name: "Roboto-Light", size: 11.0)
        self.schDateTextLabel.setupLabelDynamicSize(11)
        self.schDateTextLabel.textAlignment = .left
        self.schDateTextLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
        self.schDateTextLabel.numberOfLines = 1
//        self.schDateTextLabel.layer.borderWidth = 1
//        self.schDateTextLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.vehNameLabel.text = "Vehicle Name "
        self.vehNameLabel.font = UIFont(name: "Roboto-Medium", size: 11.0)
        self.vehNameLabel.setupLabelDynamicSize(11)
        self.vehNameLabel.textAlignment = .left
        self.vehNameLabel.textColor = UIColor.hexStringToUIColor(Colors.colorTextSecondaryTwo)
        self.vehNameLabel.numberOfLines = 1
//        self.vehNameLabel.layer.borderWidth = 1
//        self.vehNameLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.vehNameTextLabel.text = self.workorderLog.vehName
        self.vehNameTextLabel.font = UIFont(name: "Roboto-Light", size: 11.0)
        self.vehNameTextLabel.setupLabelDynamicSize(11)
        self.vehNameTextLabel.textAlignment = .left
        self.vehNameTextLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
        self.vehNameTextLabel.numberOfLines = 1
//        self.vehNameTextLabel.layer.borderWidth = 1
//        self.vehNameTextLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.vehNumberLabel.text = "Vehicle Number "
        self.vehNumberLabel.font = UIFont(name: "Roboto-Medium", size: 11.0)
        self.vehNumberLabel.setupLabelDynamicSize(11)
        self.vehNumberLabel.textAlignment = .left
        self.vehNumberLabel.textColor = UIColor.hexStringToUIColor(Colors.colorTextSecondaryTwo)
        self.vehNumberLabel.numberOfLines = 1
//        self.vehNumberLabel.layer.borderWidth = 1
//        self.vehNumberLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.vehNumberTextLabel.text = self.workorderLog.vehNumber
        self.vehNumberTextLabel.font = UIFont(name: "Roboto-Light", size: 11.0)
        self.vehNumberTextLabel.setupLabelDynamicSize(11)
        self.vehNumberTextLabel.textAlignment = .left
        self.vehNumberTextLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
        self.vehNumberTextLabel.numberOfLines = 1
//        self.vehNumberTextLabel.layer.borderWidth = 1
//        self.vehNumberTextLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.vehModelLabel.text = "Vehicle Model "
        self.vehModelLabel.font = UIFont(name: "Roboto-Medium", size: 11.0)
        self.vehModelLabel.setupLabelDynamicSize(11)
        self.vehModelLabel.textAlignment = .left
        self.vehModelLabel.textColor = UIColor.hexStringToUIColor(Colors.colorTextSecondaryTwo)
        self.vehModelLabel.numberOfLines = 1
//        self.vehModelLabel.layer.borderWidth = 1
//        self.vehModelLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.vehModelTextLabel.text = self.workorderLog.vehModel
        self.vehModelTextLabel.font = UIFont(name: "Roboto-Light", size: 11.0)
        self.vehModelTextLabel.setupLabelDynamicSize(11)
        self.vehModelTextLabel.textAlignment = .left
        self.vehModelTextLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
        self.vehModelTextLabel.numberOfLines = 1
//        self.vehModelTextLabel.layer.borderWidth = 1
//        self.vehModelTextLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.createdDateLabel.text = "Created Date "
        self.createdDateLabel.font = UIFont(name: "Roboto-Medium", size: 11.0)
        self.createdDateLabel.setupLabelDynamicSize(11)
        self.createdDateLabel.textAlignment = .left
        self.createdDateLabel.textColor = UIColor.hexStringToUIColor(Colors.colorTextSecondaryTwo)
        self.createdDateLabel.numberOfLines = 1
//        self.createdDateLabel.layer.borderWidth = 1
//        self.createdDateLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.createdDateTextLabel.text = self.convertDate(self.workorderLog.createdOn)
        self.createdDateTextLabel.font = UIFont(name: "Roboto-Light", size: 11.0)
        self.createdDateTextLabel.setupLabelDynamicSize(11)
        self.createdDateTextLabel.textAlignment = .left
        self.createdDateTextLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
        self.createdDateTextLabel.numberOfLines = 1
//        self.createdDateTextLabel.layer.borderWidth = 1
//        self.createdDateTextLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.priorityLabel.text = "Priority "
        self.priorityLabel.font = UIFont(name: "Roboto-Medium", size: 11.0)
        self.priorityLabel.setupLabelDynamicSize(11)
        self.priorityLabel.textAlignment = .left
        self.priorityLabel.textColor = UIColor.hexStringToUIColor(Colors.colorTextSecondaryTwo)
        self.priorityLabel.numberOfLines = 1
        //        self.createdDateLabel.layer.borderWidth = 1
        //        self.createdDateLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.priorityTextLabel.text = self.workorderLog.priority
        self.priorityTextLabel.font = UIFont(name: "Roboto-Light", size: 11.0)
        self.priorityTextLabel.setupLabelDynamicSize(11)
        self.priorityTextLabel.textAlignment = .center
        self.priorityTextLabel.textColor = UIColor.white
        self.priorityTextLabel.numberOfLines = 1
        self.priorityTextLabel.layer.backgroundColor = UIColor.hexStringToUIColor(Colors.work_blue).cgColor
        self.priorityTextLabel.layer.cornerRadius = 4
        //        self.createdDateTextLabel.layer.borderWidth = 1
        //        self.createdDateTextLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.statusLabel.text = "Status "
        self.statusLabel.font = UIFont(name: "Roboto-Medium", size: 11.0)
        self.statusLabel.setupLabelDynamicSize(11)
        self.statusLabel.textAlignment = .left
        self.statusLabel.textColor = UIColor.hexStringToUIColor(Colors.colorTextSecondaryTwo)
        self.statusLabel.numberOfLines = 1
        //        self.createdDateLabel.layer.borderWidth = 1
        //        self.createdDateLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.statusTextLabel.text = self.workorderLog.status
        self.statusTextLabel.font = UIFont(name: "Roboto-Light", size: 11.0)
        self.statusTextLabel.setupLabelDynamicSize(11)
        self.statusTextLabel.textAlignment = .center
        self.statusTextLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
        self.statusTextLabel.textColor = UIColor.white
        self.statusTextLabel.numberOfLines = 1
        self.statusTextLabel.layer.backgroundColor = UIColor.hexStringToUIColor(Colors.work_green).cgColor
        self.statusTextLabel.layer.cornerRadius = 4
        //        self.createdDateTextLabel.layer.borderWidth = 1
        //        self.createdDateTextLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.assNameLabel.text = "Assiginee Name "
        self.assNameLabel.font = UIFont(name: "Roboto-Medium", size: 11.0)
        self.assNameLabel.setupLabelDynamicSize(11)
        self.assNameLabel.textAlignment = .left
        self.assNameLabel.textColor = UIColor.hexStringToUIColor(Colors.colorTextSecondaryTwo)
        self.assNameLabel.numberOfLines = 1
        //        self.createdDateLabel.layer.borderWidth = 1
        //        self.createdDateLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.assNameTextLabel.text = self.workorderLog.assigneeName
        self.assNameTextLabel.font = UIFont(name: "Roboto-Light", size: 11.0)
        self.assNameTextLabel.setupLabelDynamicSize(11)
        self.assNameTextLabel.textAlignment = .left
        self.assNameTextLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
        self.assNameTextLabel.numberOfLines = 1
        //        self.createdDateTextLabel.layer.borderWidth = 1
        //        self.createdDateTextLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.resolvedByLabel.text = "Resolved By "
        self.resolvedByLabel.font = UIFont(name: "Roboto-Medium", size: 11.0)
        self.resolvedByLabel.setupLabelDynamicSize(11)
        self.resolvedByLabel.textAlignment = .left
        self.resolvedByLabel.textColor = UIColor.hexStringToUIColor(Colors.colorTextSecondaryTwo)
        self.resolvedByLabel.numberOfLines = 1
        //        self.createdDateLabel.layer.borderWidth = 1
        //        self.createdDateLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.resolvedByTextLabel.text = self.workorderLog.completedByName
        self.resolvedByTextLabel.font = UIFont(name: "Roboto-Light", size: 11.0)
        self.resolvedByTextLabel.setupLabelDynamicSize(11)
        self.resolvedByTextLabel.textAlignment = .left
        self.resolvedByTextLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
        self.resolvedByTextLabel.numberOfLines = 1
        //        self.createdDateTextLabel.layer.borderWidth = 1
        //        self.createdDateTextLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.contNameLabel.text = "Cont. Name "
        self.contNameLabel.font = UIFont(name: "Roboto-Medium", size: 11.0)
        self.contNameLabel.setupLabelDynamicSize(11)
        self.contNameLabel.textAlignment = .left
        self.contNameLabel.textColor = UIColor.hexStringToUIColor(Colors.colorTextSecondaryTwo)
        self.contNameLabel.numberOfLines = 1
        //        self.createdDateLabel.layer.borderWidth = 1
        //        self.createdDateLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.contNameTextLabel.text = self.workorderLog.contactPersonName
        self.contNameTextLabel.font = UIFont(name: "Roboto-Light", size: 11.0)
        self.contNameTextLabel.setupLabelDynamicSize(11)
        self.contNameTextLabel.textAlignment = .left
        self.contNameTextLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
        self.contNameTextLabel.numberOfLines = 1
        //        self.createdDateTextLabel.layer.borderWidth = 1
        //        self.createdDateTextLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.contNumLabel.text = "Cont. Number "
        self.contNumLabel.font = UIFont(name: "Roboto-Medium", size: 11.0)
        self.contNumLabel.setupLabelDynamicSize(11)
        self.contNumLabel.textAlignment = .left
        self.contNumLabel.textColor = UIColor.hexStringToUIColor(Colors.colorTextSecondaryTwo)
        self.contNumLabel.numberOfLines = 1
        //        self.createdDateLabel.layer.borderWidth = 1
        //        self.createdDateLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.contNumTextLabel.text = self.workorderLog.contactPersonNumber
        self.contNumTextLabel.font = UIFont(name: "Roboto-Light", size: 11.0)
        self.contNumTextLabel.setupLabelDynamicSize(11)
        self.contNumTextLabel.textAlignment = .left
        self.contNumTextLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
        self.contNumTextLabel.numberOfLines = 1
        //        self.createdDateTextLabel.layer.borderWidth = 1
        //        self.createdDateTextLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.desLabel.text = "Description "
        self.desLabel.font = UIFont(name: "Roboto-Medium", size: 11.0)
        self.desLabel.setupLabelDynamicSize(11)
        self.desLabel.textAlignment = .left
        self.desLabel.textColor = UIColor.hexStringToUIColor(Colors.colorTextSecondaryTwo)
        self.desLabel.numberOfLines = 1
        //        self.createdDateLabel.layer.borderWidth = 1
        //        self.createdDateLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.desTextLabel.text = self.workorderLog.des
        self.desTextLabel.font = UIFont(name: "Roboto-Light", size: 11.0)
        self.desTextLabel.setupLabelDynamicSize(11)
        self.desTextLabel.textAlignment = .left
        self.desTextLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
        self.desTextLabel.numberOfLines = 1
        //        self.createdDateTextLabel.layer.borderWidth = 1
        //        self.createdDateTextLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.workorderImageView.translatesAutoresizingMaskIntoConstraints = false
        self.workIdLabel.translatesAutoresizingMaskIntoConstraints = false
        self.separaterOneView.translatesAutoresizingMaskIntoConstraints = false
        self.serviceTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.serviceTypeTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.schDateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.schDateTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.vehNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.vehNameTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.vehNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        self.vehNumberTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.vehModelLabel.translatesAutoresizingMaskIntoConstraints = false
        self.vehModelTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.createdDateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.createdDateTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.priorityLabel.translatesAutoresizingMaskIntoConstraints = false
        self.priorityTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.statusLabel.translatesAutoresizingMaskIntoConstraints = false
        self.statusTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.assNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.assNameTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.resolvedByLabel.translatesAutoresizingMaskIntoConstraints = false
        self.resolvedByTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contNameTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contNumLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contNumTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.separaterTwoView.translatesAutoresizingMaskIntoConstraints = false
        self.desLabel.translatesAutoresizingMaskIntoConstraints = false
        self.desTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.workOrderContainer.addSubview(self.workorderImageView)
        self.workOrderContainer.addSubview(self.workIdLabel)
        self.workOrderContainer.addSubview(self.separaterOneView)
        self.workOrderContainer.addSubview(self.serviceTypeLabel)
        self.workOrderContainer.addSubview(self.serviceTypeTextLabel)
        self.workOrderContainer.addSubview(self.schDateLabel)
        self.workOrderContainer.addSubview(self.schDateTextLabel)
        self.workOrderContainer.addSubview(self.vehNameLabel)
        self.workOrderContainer.addSubview(self.vehNameTextLabel)
        self.workOrderContainer.addSubview(self.vehNumberLabel)
        self.workOrderContainer.addSubview(self.vehNumberTextLabel)
        self.workOrderContainer.addSubview(self.vehModelLabel)
        self.workOrderContainer.addSubview(self.vehModelTextLabel)
        self.workOrderContainer.addSubview(self.createdDateLabel)
        self.workOrderContainer.addSubview(self.createdDateTextLabel)
        self.workOrderContainer.addSubview(self.priorityLabel)
        self.workOrderContainer.addSubview(self.priorityTextLabel)
        self.workOrderContainer.addSubview(self.statusLabel)
        self.workOrderContainer.addSubview(self.statusTextLabel)
        self.workOrderContainer.addSubview(self.assNameLabel)
        self.workOrderContainer.addSubview(self.assNameTextLabel)
        self.workOrderContainer.addSubview(self.resolvedByLabel)
        self.workOrderContainer.addSubview(self.resolvedByTextLabel)
        self.workOrderContainer.addSubview(self.contNameLabel)
        self.workOrderContainer.addSubview(self.contNameTextLabel)
        self.workOrderContainer.addSubview(self.contNumLabel)
        self.workOrderContainer.addSubview(self.contNumTextLabel)
        self.workOrderContainer.addSubview(self.separaterTwoView)
        self.workOrderContainer.addSubview(self.desLabel)
        self.workOrderContainer.addSubview(self.desTextLabel)
        
        let subViewsDict = [
            "workorderImageView" : workorderImageView,
            "workIdLabel" : workIdLabel,
            "separaterOneView" : separaterOneView,
            "separaterTwoView" : separaterTwoView,
            "serviceTypeLabel" : serviceTypeLabel,
            "serviceTypeTextLabel" : serviceTypeTextLabel,
            "schDateLabel" : schDateLabel,
            "schDateTextLabel" : schDateTextLabel,
            "vehNameLabel" : vehNameLabel,
            "vehNameTextLabel" : vehNameTextLabel,
            "vehNumberLabel" : vehNumberLabel,
            "vehNumberTextLabel" : vehNumberTextLabel,
            "vehModelLabel" : vehModelLabel,
            "vehModelTextLabel" : vehModelTextLabel,
            "createdDateLabel" : createdDateLabel,
            "createdDateTextLabel" : createdDateTextLabel,
            "priorityLabel" : priorityLabel,
            "priorityTextLabel" : priorityTextLabel,
            "statusLabel" : statusLabel,
            "statusTextLabel" : statusTextLabel,
            "assNameLabel" : assNameLabel,
            "assNameTextLabel" : assNameTextLabel,
            "resolvedByLabel" : resolvedByLabel,
            "resolvedByTextLabel" : resolvedByTextLabel,
            "contNameLabel" : contNameLabel,
            "contNameTextLabel" : contNameTextLabel,
            "contNumLabel" : contNumLabel,
            "contNumTextLabel" : contNumTextLabel,
            "desLabel" : desLabel,
            "desTextLabel" : desTextLabel
        ]
        
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[workorderImageView(25)]-4-[workIdLabel]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[workorderImageView(25)]-4-[separaterOneView(1)]-6-[serviceTypeLabel(20)]-3-[schDateLabel(20)]-3-[vehNameLabel(20)]-3-[vehNumberLabel(20)]-3-[vehModelLabel(20)]-3-[createdDateLabel(20)]-3-[priorityLabel(20)]-3-[statusLabel(20)]-3-[assNameLabel(20)]-3-[resolvedByLabel(20)]-3-[contNameLabel(20)]-3-[contNumLabel(20)]-8-[separaterTwoView(1)]-4-[desLabel(20)]-3-[desTextLabel]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[workorderImageView(25)]-4-[separaterOneView(1)]-6-[serviceTypeTextLabel(20)]-3-[schDateTextLabel(20)]-3-[vehNameTextLabel(20)]-3-[vehNumberTextLabel(20)]-3-[vehModelTextLabel(20)]-3-[createdDateTextLabel(20)]-3-[priorityTextLabel(20)]-3-[statusTextLabel(20)]-3-[assNameTextLabel(20)]-3-[resolvedByTextLabel(20)]-3-[contNameTextLabel(20)]-3-[contNumTextLabel(20)]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[workIdLabel(25)]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[separaterOneView]-8-|", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[separaterTwoView]-8-|", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[serviceTypeLabel(120)]-4-[serviceTypeTextLabel(150)]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[schDateLabel(120)]-4-[schDateTextLabel]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[vehNameLabel(120)]-4-[vehNameTextLabel]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[vehNumberLabel(120)]-4-[vehNumberTextLabel]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[vehModelLabel(120)]-4-[vehModelTextLabel]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[createdDateLabel(120)]-4-[createdDateTextLabel]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[priorityLabel(120)]-4-[priorityTextLabel(150)]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[statusLabel(120)]-4-[statusTextLabel(150)]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[assNameLabel(120)]-4-[assNameTextLabel]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[resolvedByLabel(120)]-4-[resolvedByTextLabel]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[contNameLabel(120)]-4-[contNameTextLabel]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[contNumLabel(120)]-4-[contNumTextLabel]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[desLabel]", options: [], metrics: nil, views: subViewsDict))
        self.workOrderContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[desTextLabel]", options: [], metrics: nil, views: subViewsDict))

        
        self.workOrderContainer.translatesAutoresizingMaskIntoConstraints = false
        self.mapContainer.translatesAutoresizingMaskIntoConstraints = false
        self.userActionContainer.translatesAutoresizingMaskIntoConstraints = false
        
        self.containerView.addSubview(self.workOrderContainer)
        self.containerView.addSubview(self.mapContainer)
        self.containerView.addSubview(self.userActionContainer)
        
        let viewsDict = [
            "workOrderContainer" : workOrderContainer,
            "mapContainer" : mapContainer,
            "userActionContainer" : userActionContainer
        ]
        
        self.containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[workOrderContainer(400)]-8-[mapContainer(300)]-8-[userActionContainer(100)]", options: [], metrics: nil, views: viewsDict))
        
        self.containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[workOrderContainer]-8-|", options: [], metrics: nil, views: viewsDict))
        
        self.containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[mapContainer]-8-|", options: [], metrics: nil, views: viewsDict))
        self.containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[userActionContainer]-8-|", options: [], metrics: nil, views: viewsDict))
        
        //self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.frame = self.view.frame
        //self.containerView.userInteractionEnabled = true
        
        self.view.addSubview(self.containerView)
//        self.scrollView.contentOffset = CGPoint(x: 10, y: 20)
//        
////        self.scrollView.contentSize = CGSize(width:1000, height:1000)
//        
//        let dict = [
//            "containerView" : containerView
//        ]
//        
//        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-8-[containerView]", options: [], metrics: nil, views: dict))
//        
//        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[containerView]-8-|", options: [], metrics: nil, views: dict))
        
//        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
//        
//        self.view.addSubview(self.scrollView)
//        
//        let dicts = [
//            "scrollView" : scrollView
//        ]
//        
//        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[scrollView]-0-|", options: [], metrics: nil, views: dicts))
//        
//        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[scrollView]-0-|", options: [], metrics: nil, views: dicts))
        
    }
    
    func initMapView(){
        
        self.locationLabel.text = "Location Details "
        self.locationLabel.font = UIFont(name: "Roboto-Medium", size: 11.0)
        self.locationLabel.setupLabelDynamicSize(11)
        self.locationLabel.textAlignment = .left
        self.locationLabel.textColor = UIColor.hexStringToUIColor(Colors.colorTextSecondaryTwo)
        self.locationLabel.numberOfLines = 1
        //        self.schDateLabel.layer.borderWidth = 1
        //        self.schDateLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.locationTextLabel.text = "Inayatpur, Haryana 122001, India"
        self.locationTextLabel.font = UIFont(name: "Roboto-Light", size: 11.0)
        self.locationTextLabel.setupLabelDynamicSize(11)
        self.locationTextLabel.textAlignment = .left
        self.locationTextLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
        self.locationTextLabel.numberOfLines = 1
        //        self.schDateTextLabel.layer.borderWidth = 1
        //        self.schDateTextLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.locationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.locationTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        self.separaterThreeView.translatesAutoresizingMaskIntoConstraints = false
        
        self.mapContainer.addSubview(self.locationLabel)
        self.mapContainer.addSubview(self.separaterThreeView)
        self.mapContainer.addSubview(self.locationTextLabel)
        self.mapContainer.addSubview(self.mapView)

        
        let subViewsDict = [
            "locationLabel" : locationLabel,
            "separaterThreeView" : separaterThreeView,
            "locationTextLabel" : locationTextLabel,
            "mapView" : mapView
        ]
        
        self.mapContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[locationLabel]", options: [], metrics: nil, views: subViewsDict))
        self.mapContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[locationLabel(25)]-2-[separaterThreeView(1)]-2-[locationTextLabel(25)]-4-[mapView]-0-|", options: [], metrics: nil, views: subViewsDict))
        self.mapContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[locationTextLabel]", options: [], metrics: nil, views: subViewsDict))
        self.mapContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[mapView]-0-|", options: [], metrics: nil, views: subViewsDict))
        self.mapContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[separaterThreeView]-8-|", options: [], metrics: nil, views: subViewsDict))
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: Double(self.workorderLog.lat)!, longitude: Double(self.workorderLog.lng)!)
        marker.title = self.workorderLog.vehName
        marker.snippet = self.workorderLog.vehNumber
        marker.icon = UIImage(named: "workorder_veh")
        marker.groundAnchor = CGPoint(x: 0.5,y: 0.5)
        marker.userData = self.workorderLog.vehId
        marker.map = mapView
        bounds = bounds.includingCoordinate(marker.position)
        mapView.animate(with: GMSCameraUpdate.fit(bounds))
    }
    
    func initActionLogs(){
        self.userActionLabel.text = "User Action "
        self.userActionLabel.font = UIFont(name: "Roboto-Medium", size: 11.0)
        self.userActionLabel.setupLabelDynamicSize(11)
        self.userActionLabel.textAlignment = .left
        self.userActionLabel.textColor = UIColor.hexStringToUIColor(Colors.colorTextSecondaryTwo)
        self.userActionLabel.numberOfLines = 1
        //        self.createdDateLabel.layer.borderWidth = 1
        //        self.createdDateLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.userActionTextLabel.text = "No action logs recorded"
        self.userActionTextLabel.font = UIFont(name: "Roboto-Light", size: 11.0)
        self.userActionTextLabel.setupLabelDynamicSize(11)
        self.userActionTextLabel.textAlignment = .left
        self.userActionTextLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
        self.userActionTextLabel.numberOfLines = 1
        //        self.createdDateTextLabel.layer.borderWidth = 1
        //        self.createdDateTextLabel.layer.borderColor = UIColor.greenColor().CGColor
        
        self.userActionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.userActionTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.separaterFourView.translatesAutoresizingMaskIntoConstraints = false
        
        self.userActionContainer.addSubview(self.userActionLabel)
        self.userActionContainer.addSubview(self.separaterFourView)
        self.userActionContainer.addSubview(self.userActionTextLabel)
        
        
        let subViewsDict = [
            "userActionLabel" : userActionLabel,
            "separaterFourView" : separaterFourView,
            "userActionTextLabel" : userActionTextLabel
        ]
        
        self.userActionContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[userActionLabel]", options: [], metrics: nil, views: subViewsDict))
        self.userActionContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[userActionLabel(25)]-2-[separaterFourView(1)]-2-[userActionTextLabel(25)]", options: [], metrics: nil, views: subViewsDict))
        self.userActionContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[userActionTextLabel]", options: [], metrics: nil, views: subViewsDict))
        self.userActionContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[separaterFourView]-8-|", options: [], metrics: nil, views: subViewsDict))

    }
    
    func convertDate(_ milliSeconds: String) -> String{
        let todaysDate:Date = Date(timeIntervalSince1970: Double(milliSeconds)!)
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, HH:mm a"
        return dateFormatter.string(from: todaysDate)
    }
    
}
