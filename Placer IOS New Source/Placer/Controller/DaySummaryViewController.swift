//
//  DaySummaryViewController.swift
//  Placer
//
//  Created by Vishal on 31/08/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON
import TTGSnackbar
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class DaySummaryViewController: UIViewController {
    
    var vehNameLabel = UILabel()
    var vehUpdatedTimeLabel = UILabel()
    var vehLocationLabel = UILabel()
    var vehUpdatedTimeImageView = UIImageView()
    var vehLocationImageView = UIImageView()
    var previousActionLabel = UILabel()
    var previousActionLabelText = UILabel()
    var trendsLabel = UILabel()
    var totalDistanceLabel = UILabel()
    var totalDistanceLabelText = UILabel()
    var maxSpeedLabel = UILabel()
    var maxSpeedLabelText = UILabel()
    var moveTimeLabel = UILabel()
    var moveTimeLabelText = UILabel()
    var haltTimeLabel = UILabel()
    var haltTimeLabelText = UILabel()
    var routeSummaryLabel = UILabel()
    var mapView: GMSMapView!
    var routeDetailsButton = UIButton()
    var pwrImageView = UIImageView()
    var gpsImageView = UIImageView()
    var acImageView = UIImageView()
    var ingImageView = UIImageView()
    
    var vehicleLocation: VehicleLocationResponse!
    var bounds = GMSCoordinateBounds()
    var startDate:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViews()
        if(NetworkReachability.isConnectedToNetwork()){
        self.getDaySummary()
        }else{
            let snackbar = TTGSnackbar.init(message: "No Internet Connectivity!", duration: .short)
            snackbar.show()
        }
    }
    
    //to get token detail
    func getTokenDetail() -> String{
        let preferences = UserDefaults.standard
        var token:String = ""
        let tokenKey = "token"
        if preferences.object(forKey: tokenKey) == nil {
            print("Unable to get token!")
        } else {
            token = preferences.value(forKey: tokenKey) as! String
            print(token)
        }
        return token
    }
    
    func getDaySummary(){
        print("inside getDaySummary veh id is ==    \(self.vehicleLocation.vehId)")
        let headers = [
            "Authorization": "Basic "+getTokenDetail(),
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let getDaySummaryParams = ["vehId": self.vehicleLocation.vehId]
        //self.showLoading()
        Alamofire.request(Api.baseUrl + Api.getDaySummary, method: .get, parameters: getDaySummaryParams, headers: headers)
            .responseJSON { response in
                //print(response.request)  // original URL request
                //print(response.response) // URL response
                //print(response.data)     // server data
                //print(response.result)   // result of response serialization
                switch response.result {
                case .success( _):
                    if let jsonString = response.result.value {
                        let jObj = JSON(jsonString)
                        self.showData(jObj)
                        self.getDeviceLog()
                        //self.hideLoading()
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    //self.hideLoading()
                }
        }
    }
    
    func getDeviceLog(){
        print("inside getDeviceLog")
        let headers = [
            "Authorization": "Basic "+getTokenDetail(),
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let getDaySummaryParams = ["vehId" : self.vehicleLocation.vehId, "limit" : "1", "startTime" : "\(self.getCurrentDate())  00:00:00"]
        //self.showLoading()
        Alamofire.request(Api.baseUrl + Api.getDeviceLog, method: .get, parameters: getDaySummaryParams, headers: headers)
            .responseJSON { response in
                //print(response.request)  // original URL request
                //print(response.response) // URL response
                //print(response.data)     // server data
                //print(response.result)   // result of response serialization
                switch response.result {
                case .success( _):
                    if let jsonString = response.result.value {
                        print("JSON:day summary \(jsonString)")
                        let jObj = JSON(jsonString)
                        self.showMarker(jObj)
                        //self.hideLoading()
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    //self.hideLoading()
                }
        }
    }
    
    func showMarker(_ jObj: JSON){
        let innerJobj = jObj["vehicle-\(self.vehicleLocation.vehId)"]
        let deviceLog = innerJobj["records"][0]
        self.startDate = deviceLog["gpsDateTime"].stringValue
        let startMarker = GMSMarker()
        startMarker.position = CLLocationCoordinate2D(latitude: Double(deviceLog["location"]["lat"].stringValue)!, longitude: Double(deviceLog["location"]["lng"].stringValue)!)
        startMarker.title = vehicleLocation.name
        startMarker.snippet = vehicleLocation.vehNumber
        startMarker.icon = UIImage(named: "location_off")
        startMarker.groundAnchor = CGPoint(x: 0.5,y: 0.5)
        startMarker.userData = vehicleLocation.trackerId
        startMarker.map = mapView
        bounds = bounds.includingCoordinate(startMarker.position)
        mapView.animate(with: GMSCameraUpdate.fit(bounds))

        
        let endMarker = GMSMarker()
        endMarker.position = CLLocationCoordinate2D(latitude: Double(vehicleLocation.lat)!, longitude: Double(vehicleLocation.lng)!)
        endMarker.title = vehicleLocation.name
        endMarker.snippet = vehicleLocation.vehNumber
        endMarker.icon = UIImage(named: "location_on")
        endMarker.groundAnchor = CGPoint(x: 0.5,y: 0.5)
        endMarker.userData = vehicleLocation.trackerId
        endMarker.map = mapView
        bounds = bounds.includingCoordinate(endMarker.position)
        mapView.animate(with: GMSCameraUpdate.fit(bounds))
    }
    
    func getCurrentDate() -> String {
        let todaysDate:Date = Date()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: todaysDate)
    }
    
    func currentTimeMillis() -> Int64{
        let nowDouble = Date().timeIntervalSince1970
        return Int64(nowDouble)
    }
    
    func showData(_ jObj: JSON){
        print("jObj day summary log  \(jObj)")
        self.vehNameLabel.text = self.vehicleLocation.name
        let myMilliseconds: UnixTime = Int(self.vehicleLocation.gpsDateTime)!
        self.vehUpdatedTimeLabel.text = "\(myMilliseconds.toDay) \(myMilliseconds.toHour)"
        self.vehLocationLabel.text = self.vehicleLocation.nearLocationShort
        let speed = Int(self.vehicleLocation.speed)
        let innerJobj = jObj["vehicle-\(self.vehicleLocation.vehId)"]
        let daySummary = innerJobj["\(self.getCurrentDate())"]
        self.totalDistanceLabelText.text = "\(daySummary["totalDistance"].stringValue) kms"
        self.maxSpeedLabelText.text = "\(daySummary["maxSpeed"].stringValue) kmph"
        self.routeSummaryLabel.text = "Route Summary ( \(self.getCurrentDate()) )"
        let mTime = daySummary["totalMovementHours"].stringValue.components(separatedBy: ":")
        if (mTime.count == 3) {
            self.moveTimeLabelText.text = "\(mTime.first!)h \(mTime[1])m"
        } else if (mTime.count == 2) {
            self.moveTimeLabelText.text = "00h \(mTime[0])m"
        }
        let hTime = daySummary["totalMovementHours"].stringValue.components(separatedBy: ":")
        if (hTime.count == 3) {
            self.haltTimeLabelText.text = "\(hTime.first!)h \(hTime[1])m"
        } else if (hTime.count == 2) {
            self.haltTimeLabelText.text = "00h \(hTime[0])m"
        }
        
        if (self.currentTimeMillis() - Int64(self.vehicleLocation.gpsDateTime)! > 28800) {
            self.vehNameLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
            self.gpsImageView.tintColor = UIColor.gray
            self.acImageView.tintColor = UIColor.gray
            self.ingImageView.tintColor = UIColor.gray
        } else{
            if (speed <= 3) {
                self.vehNameLabel.textColor = UIColor.hexStringToUIColor(Colors.red_800)
            }else if (speed > 3 && speed <= 60) {
                self.vehNameLabel.textColor = UIColor.hexStringToUIColor(Colors.green_800)
            }else if (speed > 60) {
                self.vehNameLabel.textColor = UIColor.hexStringToUIColor(Colors.blue_800)
            }
            
            self.gpsImageView.tintColor = UIColor.hexStringToUIColor(Colors.green_800)
            if(self.vehicleLocation.powerSensor1 != ""){
                if(self.vehicleLocation.powerSensor1 == "1"){
                    self.ingImageView.tintColor = UIColor.hexStringToUIColor(Colors.green_800)
                }else{
                    self.ingImageView.tintColor = UIColor.hexStringToUIColor(Colors.red_800)
                }
            }else{
                self.ingImageView.tintColor = UIColor.gray
            }
            
            if(self.vehicleLocation.powerSensor2 != ""){
                if(self.vehicleLocation.powerSensor2 == "1"){
                    self.acImageView.tintColor = UIColor.hexStringToUIColor(Colors.green_800)
                }else{
                    self.acImageView.tintColor = UIColor.hexStringToUIColor(Colors.red_800)
                }
            }else{
                self.acImageView.tintColor = UIColor.gray
            }
            
        }
        
    }
    
    func navigateToRouteDetails(_ sender: AnyObject?){
        print("Route Details Tapped!")
        let routeDetailsController = RouteDetailsController()
        routeDetailsController.vehicleLocation = self.vehicleLocation
        routeDetailsController.startDate = self.startDate
        self.navigationController?.pushViewController(routeDetailsController, animated: true)
    }
    
    func initViews(){
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        //nav title
        self.title = ""
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: (self.navigationController?.navigationBar.frame.height)!))
        titleLabel.center = (navigationController?.navigationBar.center)!
        titleLabel.text = "Day Summary"
        titleLabel.font = UIFont(name: "Roboto-Light", size: 18.0)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        navigationItem.titleView = titleLabel
        
        let camera = GMSCameraPosition.camera(withLatitude: 28.613939, longitude: 77.209021, zoom: 6.0)
        self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera:camera)
        self.mapView.layer.borderWidth = 2
        self.mapView.layer.borderColor = UIColor.hexStringToUIColor(Colors.row_green).cgColor
        let mapInsets = UIEdgeInsets(top: 50.0, left: 50.0, bottom: 50.0, right: 50.0)
        self.mapView.padding = mapInsets
        self.mapView.settings.rotateGestures = false
        self.mapView.settings.tiltGestures = false
        self.mapView.settings.scrollGestures = true
        self.mapView.settings.zoomGestures = false
        
        self.vehNameLabel.text = ""
        self.vehNameLabel.font = UIFont(name: "Roboto-Bold", size: 16.0)
        self.vehNameLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        
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
        
        let time = UIImage(named: "time")!.withRenderingMode(.alwaysTemplate)
        self.vehUpdatedTimeImageView.image = time
        self.vehUpdatedTimeImageView.tintColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        
        self.vehUpdatedTimeLabel.text = ""
        self.vehUpdatedTimeLabel.font = UIFont(name: "Roboto-Regular", size: 11.0)
        self.vehUpdatedTimeLabel.textColor = UIColor.darkGray
        
        let location = UIImage(named: "location")!.withRenderingMode(.alwaysTemplate)
        self.vehLocationImageView.image = location
        self.vehLocationImageView.tintColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        
        self.vehLocationLabel.text = ""
        self.vehLocationLabel.font = UIFont(name: "Roboto-Regular", size: 11.0)
        self.vehLocationLabel.textColor = UIColor.darkGray
        
        self.trendsLabel.text = "Trends"
        self.trendsLabel.font = UIFont(name: "Roboto-Bold", size: 14.0)
        self.trendsLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        
        self.totalDistanceLabel.text = "Total Distance: "
        self.totalDistanceLabel.font = UIFont(name: "Roboto-Regular", size: 11.0)
        self.totalDistanceLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        
        self.totalDistanceLabelText.text = "0 kms"
        self.totalDistanceLabelText.font = UIFont(name: "Roboto-Regular", size: 11.0)
        self.totalDistanceLabelText.textColor = UIColor.darkGray
        
        self.maxSpeedLabel.text = "Max Speed: "
        self.maxSpeedLabel.font = UIFont(name: "Roboto-Regular", size: 11.0)
        self.maxSpeedLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        
        self.maxSpeedLabelText.text = "0 kmps "
        self.maxSpeedLabelText.font = UIFont(name: "Roboto-Regular", size: 11.0)
        self.maxSpeedLabelText.textColor = UIColor.darkGray
        
        self.moveTimeLabel.text = "Movement Time: "
        self.moveTimeLabel.font = UIFont(name: "Roboto-Regular", size: 11.0)
        self.moveTimeLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        
        self.moveTimeLabelText.text = "0h 0m "
        self.moveTimeLabelText.font = UIFont(name: "Roboto-Regular", size: 11.0)
        self.moveTimeLabelText.textColor = UIColor.darkGray
        
        self.haltTimeLabel.text = "Halt Time: "
        self.haltTimeLabel.font = UIFont(name: "Roboto-Regular", size: 11.0)
        self.haltTimeLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        
        self.haltTimeLabelText.text = "0h 0m "
        self.haltTimeLabelText.font = UIFont(name: "Roboto-Regular", size: 11.0)
        self.haltTimeLabelText.textColor = UIColor.darkGray
        
        self.routeSummaryLabel.text = "Route Summary ( 2016-08-31)"
        self.routeSummaryLabel.font = UIFont(name: "Roboto-Bold", size: 14.0)
        self.routeSummaryLabel.textColor = UIColor.hexStringToUIColor(Colors.colorPrimaryDark)
        
        self.routeDetailsButton.frame = CGRect(x: 0, y: 0, width: 230, height: 50)
        self.routeDetailsButton.setTitle("Route Details", for: UIControlState())
        self.routeDetailsButton.setTitleColor(UIColor.hexStringToUIColor("#323754"), for: UIControlState())
        self.routeDetailsButton.layer.cornerRadius = 25
        self.routeDetailsButton.layer.borderWidth = 1
        self.routeDetailsButton.backgroundColor = UIColor.hexStringToUIColor("#8C93BA")
        self.routeDetailsButton.layer.borderColor = UIColor.hexStringToUIColor("#8C93BA").cgColor
        self.routeDetailsButton.center = CGPoint(x: self.view.center.x, y: self.view.frame.height-105)
        self.routeDetailsButton.addTarget(self, action: #selector(DaySummaryViewController.navigateToRouteDetails(_:)), for: .touchUpInside)
                
        self.vehNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.pwrImageView.translatesAutoresizingMaskIntoConstraints = false
        self.gpsImageView.translatesAutoresizingMaskIntoConstraints = false
        self.acImageView.translatesAutoresizingMaskIntoConstraints = false
        self.ingImageView.translatesAutoresizingMaskIntoConstraints = false
        self.vehUpdatedTimeImageView.translatesAutoresizingMaskIntoConstraints = false
        self.vehUpdatedTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.vehLocationImageView.translatesAutoresizingMaskIntoConstraints = false
        self.vehLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.trendsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.totalDistanceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.totalDistanceLabelText.translatesAutoresizingMaskIntoConstraints = false
        self.maxSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        self.maxSpeedLabelText.translatesAutoresizingMaskIntoConstraints = false
        self.moveTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.moveTimeLabelText.translatesAutoresizingMaskIntoConstraints = false
        self.haltTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.haltTimeLabelText.translatesAutoresizingMaskIntoConstraints = false
        self.routeSummaryLabel.translatesAutoresizingMaskIntoConstraints = false
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.vehNameLabel)
        self.view.addSubview(self.pwrImageView)
        self.view.addSubview(self.gpsImageView)
        self.view.addSubview(self.acImageView)
        self.view.addSubview(self.ingImageView)
        self.view.addSubview(self.vehUpdatedTimeImageView)
        self.view.addSubview(self.vehUpdatedTimeLabel)
        self.view.addSubview(self.vehLocationImageView)
        self.view.addSubview(self.vehLocationLabel)
        self.view.addSubview(self.trendsLabel)
        self.view.addSubview(self.totalDistanceLabel)
        self.view.addSubview(self.totalDistanceLabelText)
        self.view.addSubview(self.maxSpeedLabel)
        self.view.addSubview(self.maxSpeedLabelText)
        self.view.addSubview(self.moveTimeLabel)
        self.view.addSubview(self.moveTimeLabelText)
        self.view.addSubview(self.haltTimeLabel)
        self.view.addSubview(self.haltTimeLabelText)
        self.view.addSubview(self.routeSummaryLabel)
        self.view.addSubview(self.mapView)
        self.view.addSubview(self.routeDetailsButton)
        
        
        let viewsDict = [
            "vehNameLabel" : vehNameLabel,
            "pwrImageView" : pwrImageView,
            "gpsImageView" : gpsImageView,
            "acImageView" : acImageView,
            "ingImageView" : ingImageView,
            "vehUpdatedTimeImageView" : vehUpdatedTimeImageView,
            "vehUpdatedTimeLabel" : vehUpdatedTimeLabel,
            "vehLocationImageView" : vehLocationImageView,
            "vehLocationLabel" : vehLocationLabel,
            "trendsLabel" : trendsLabel,
            "totalDistanceLabel" : totalDistanceLabel,
            "totalDistanceLabelText" : totalDistanceLabelText,
            "maxSpeedLabel" : maxSpeedLabel,
            "maxSpeedLabelText" : maxSpeedLabelText,
            "moveTimeLabel" : moveTimeLabel,
            "moveTimeLabelText" : moveTimeLabelText,
            "haltTimeLabel" : haltTimeLabel,
            "haltTimeLabelText" : haltTimeLabelText,
            "routeSummaryLabel" : routeSummaryLabel,
            "mapView" : mapView
        ] as [String : Any]
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[vehNameLabel(15)]-8-[vehUpdatedTimeImageView(10)]-9-[vehLocationImageView(10)]-8-[trendsLabel(15)]", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[vehNameLabel(15)]-8-[vehUpdatedTimeLabel(11)]-8-[vehLocationLabel(11)]", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[trendsLabel(15)]-8-[totalDistanceLabel(11)]", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[trendsLabel(15)]-8-[totalDistanceLabelText(11)]", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[trendsLabel(15)]-8-[maxSpeedLabel(11)]", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[trendsLabel(15)]-8-[maxSpeedLabelText(11)]", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[totalDistanceLabel(11)]-8-[moveTimeLabel(11)]", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[totalDistanceLabel(11)]-8-[moveTimeLabelText(11)]", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[totalDistanceLabel(11)]-8-[haltTimeLabel(11)]", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[totalDistanceLabel(11)]-8-[haltTimeLabelText(11)]", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[trendsLabel]", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[totalDistanceLabel]-4-[totalDistanceLabelText]", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[maxSpeedLabel]-4-[maxSpeedLabelText]-8-|", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[haltTimeLabel]-4-[haltTimeLabelText]-8-|", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[moveTimeLabel]-4-[moveTimeLabelText]", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[vehNameLabel]", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[pwrImageView(15)]", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[gpsImageView(15)]", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[acImageView(15)]", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[ingImageView(15)]", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[pwrImageView(15)]-4-[gpsImageView(15)]-[acImageView(15)]-4-[ingImageView(15)]-8-|", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[vehUpdatedTimeImageView(10)]-4-[vehUpdatedTimeLabel]", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[vehLocationImageView(10)]-4-[vehLocationLabel]-8-|", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[moveTimeLabel(11)]-8-[routeSummaryLabel]", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[routeSummaryLabel]", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[routeSummaryLabel]-8-[mapView]-80-|", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[mapView]-16-|", options: [], metrics: nil, views: viewsDict))
    }
}
