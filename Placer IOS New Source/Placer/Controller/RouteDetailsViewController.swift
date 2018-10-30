//
//  RouteDetailsViewController.swift
//  Placer
//
//  Created by Vishal on 02/09/16.
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
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
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


class RouteDetailsController : UIViewController{
    
    var mapView: GMSMapView!
    var fromDateImageView = UIImageView()
    var toDateImageView = UIImageView()
    var speedSlider = UISlider()
    var sliderSpeedLabel = UILabel()
    var playImageView = UIImageView()
    var containerView = UIView()
    var bottomView = UIView()
    
    var vehicleLocation: VehicleLocationResponse!
    var startDate:String!
    var npk:String = ""
    var bounds = GMSCoordinateBounds()
    var deviceLogs: [DeviceLog] = []
    var count = 0
    var mLocationMarker: GMSMarker!
    var timer = Timer()
    let path = GMSMutablePath()
    var playStatus: Bool = false
    var gotDeviceLogs:Bool = false
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(vehicleLocation.name)
        print(startDate)
        self.initViews()
    }
    
    func getCurrentDate() -> String {
        let todaysDate:Date = Date()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: todaysDate)
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
    
    func getDeviceLog(_ npk:String){
        print("inside getDeviceLog")
        let headers = [
            "Authorization": "Basic "+getTokenDetail(),
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        print("Start Date: \(convertDate())")
        print("End Date: \(getCurrentDate())")
        
        var getDeviceLogParams = ["vehId" : self.vehicleLocation.vehId, "limit" : "1000", "startTime" : "\(self.convertDate())","endTime" : "\(self.getCurrentDate())"]
        if(!npk.isEmpty){
            getDeviceLogParams["npk"] = npk
        }
        self.showLoading()
        Alamofire.request(Api.baseUrl + Api.getDeviceLog, method: .get, parameters: getDeviceLogParams,  headers: headers)
            .responseJSON { response in
                //print(response.request)  // original URL request
                //print(response.response) // URL response
                //print(response.data)     // server data
                //print(response.result)   // result of response serialization
                switch response.result {
                case .success( _):
                    if let jsonString = response.result.value {
                        print("JSON: \(jsonString)")
                        let jObj = JSON(jsonString)
                        let innerJobj = jObj["vehicle-\(self.vehicleLocation.vehId)"]
                        self.npk = innerJobj["nextPageContinueKey"].stringValue
                        let deviceLogArray = innerJobj["records"]
                        for (_,subJson):(String, JSON) in deviceLogArray {
                            let deviceLog = DeviceLog()
                            deviceLog.gpsDateTime = subJson["gpsDateTime"].stringValue
                            deviceLog.speed = subJson["speed"].stringValue
                            deviceLog.lat = subJson["location"]["lat"].stringValue
                            deviceLog.lng = subJson["location"]["lng"].stringValue
                            self.deviceLogs.append(deviceLog)
                        }
                        self.gotDeviceLogs = true
                        self.hideLoading()
                        self.showRoute()
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    //self.hideLoading()
                }
        }
    }
    
    func showRoute(){
        if(count < self.deviceLogs.count){
            timer.invalidate() // just in case this button is tapped multiple times
            
            // start the timer
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(animateRoute), userInfo: nil, repeats: true)
        }
    }
    
    func convertDate(_ milliSeconds: String) -> String{
        let todaysDate:Date = Date(timeIntervalSince1970: Double(milliSeconds)!)
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, HH:mm a"
        return dateFormatter.string(from: todaysDate)
    }
    
    func animateRoute(){
        let deviceLog = self.deviceLogs[count]
        let lt = CLLocationCoordinate2D(latitude: Double(deviceLog.lat)!, longitude: Double(deviceLog.lng)!)
        //let snnipet = "Updated On: \(deviceLog.gpsDateTime) $ Speed: \(deviceLog.speed)"
        let speed = Int(deviceLog.speed)
        if(count == 0){
            let marker = GMSMarker()
            marker.position = lt
            marker.title = "Updated On: \(self.convertDate(deviceLog.gpsDateTime))"
            marker.snippet = "Speed: \(deviceLog.speed)"
            marker.icon = UIImage(named: "route_start")
            //marker.groundAnchor = CGPointMake(0.5,0.5)
            //marker.userData = vehicleLocation.trackerId
            marker.map = mapView
            //                    bounds = bounds.includingCoordinate(marker.position)
            //                    mapView.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(bounds))
            
            self.mLocationMarker = GMSMarker()
            self.mLocationMarker.position = lt
            self.mLocationMarker.title = "Updated On: \(self.convertDate(deviceLog.gpsDateTime))"
            self.mLocationMarker.snippet = "Speed: \(deviceLog.speed)"
            self.mLocationMarker.icon = UIImage(named: "route_start")
            //self.mLocationMarker.groundAnchor = CGPointMake(0.5,0.5)
            //self.mLocationMarker.userData = vehicleLocation.trackerId
            self.mLocationMarker.map = mapView
            count += 1
        }else{
            if(self.mLocationMarker != nil){
                self.mLocationMarker.icon = UIImage(named: "route_moving")
                CATransaction.begin()
                CATransaction.setAnimationDuration(1.0)
                mLocationMarker.position = lt
                CATransaction.commit()
                if(speed == 0){
                    let marker = GMSMarker()
                    marker.position = lt
                    marker.title = "Updated On: \(self.convertDate(deviceLog.gpsDateTime))"
                    marker.snippet = "Speed: \(deviceLog.speed)"
                    marker.icon = UIImage(named: "halt_dot")
                    marker.groundAnchor = CGPoint(x: 0.5,y: 0.5)
                    //marker.userData = vehicleLocation.trackerId
                    marker.map = mapView
                }else if(speed > 0 && speed <= 60){
                    let marker = GMSMarker()
                    marker.position = lt
                    marker.title = "Updated On: \(self.convertDate(deviceLog.gpsDateTime))"
                    marker.snippet = "Speed: \(deviceLog.speed)"
                    marker.icon = UIImage(named: "moving_dot")
                    marker.groundAnchor = CGPoint(x: 0.5,y: 0.5)
                    //marker.userData = vehicleLocation.trackerId
                    marker.map = mapView
                }else {
                    let marker = GMSMarker()
                    marker.position = lt
                    marker.title = "Updated On: \(self.convertDate(deviceLog.gpsDateTime))"
                    marker.snippet = "Speed: \(deviceLog.speed)"
                    marker.icon = UIImage(named: "over_speed_dot")
                    marker.groundAnchor = CGPoint(x: 0.5,y: 0.5)
                    //marker.userData = vehicleLocation.trackerId
                    marker.map = mapView
                }
                
                path.add(lt)
                let polyline = GMSPolyline(path: path)
                polyline.strokeColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
                polyline.strokeWidth = 1.0
                polyline.geodesic = true
                polyline.map = mapView
                bounds = bounds.includingCoordinate(self.mLocationMarker.position)
                mapView.animate(with: GMSCameraUpdate.fit(bounds))
            }
            
            count += 1
        }
        if(count == self.deviceLogs.count){
            timer.invalidate()
            mLocationMarker.icon = UIImage(named: "route_finish")
        }

    }
    
    func convertDate() -> String{
        let todaysDate:Date = Date(timeIntervalSince1970: Double(self.startDate)!)
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: todaysDate)
    }
    
    func handlePlayPause(_ sender: AnyObject?){
        if(!playStatus){
            let pause = UIImage(named: "pause")!.withRenderingMode(.alwaysTemplate)
            self.playImageView.image = pause
            self.playImageView.tintColor = UIColor.white
            if(NetworkReachability.isConnectedToNetwork()){
            if(self.gotDeviceLogs == false){
                self.getDeviceLog("")
            }else{
                self.showRoute()
            }
            }else{
                let snackbar = TTGSnackbar.init(message: "No Internet Connectivity!", duration: .short)
                snackbar.show()
            }
            playStatus = true
        }else{
            let play = UIImage(named: "play")!.withRenderingMode(.alwaysTemplate)
            self.playImageView.image = play
            self.playImageView.tintColor = UIColor.white
            timer.invalidate()
            playStatus = false
        }
    }

    
    func initViews(){
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        //nav title
        self.title = ""
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: (self.navigationController?.navigationBar.frame.height)!))
        titleLabel.center = (navigationController?.navigationBar.center)!
        titleLabel.text = "Route Details"
        titleLabel.font = UIFont(name: "Roboto-Light", size: 18.0)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        navigationItem.titleView = titleLabel
        
        let camera = GMSCameraPosition.camera(withLatitude: 28.613939, longitude: 77.209021, zoom: 6.0)
        self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera:camera)
        
        self.containerView.frame = CGRect(x: (self.view.frame.width/2)-150, y: self.view.frame.height-130, width: 300, height: 60)
        
        self.speedSlider.frame = CGRect(x: 10, y: 5, width: 200, height: 30)
        self.speedSlider.minimumValue = 0
        self.speedSlider.maximumValue = 5
        self.speedSlider.isContinuous = true
        self.speedSlider.tintColor = UIColor.hexStringToUIColor(Colors.colorAccent)
        self.speedSlider.value = 1
        self.speedSlider.addTarget(self, action: #selector(RouteDetailsController.speedSliderValueDidChange(_:)), for: .valueChanged)
        
//        let fromDate = UIImage(named: "from_date")!.imageWithRenderingMode(.AlwaysTemplate)
//        self.fromDateImageView.image = fromDate
//        self.fromDateImageView.tintColor = UIColor.whiteColor()
//        
//        let toDate = UIImage(named: "to_date")!.imageWithRenderingMode(.AlwaysTemplate)
//        self.toDateImageView.image = toDate
//        self.toDateImageView.tintColor = UIColor.whiteColor()
        
        self.sliderSpeedLabel.frame = CGRect(x: 10, y: 35, width: 200, height: 20)
        self.sliderSpeedLabel.text = "1x"
        self.sliderSpeedLabel.font = UIFont(name: "Roboto-Light", size: 14.0)
        self.sliderSpeedLabel.textColor = UIColor.white
        self.sliderSpeedLabel.textAlignment = .center
        
        self.playImageView.frame = CGRect(x: 240, y: 5, width: 50, height: 50)
        let play = UIImage(named: "play")!.withRenderingMode(.alwaysTemplate)
        self.playImageView.image = play
        self.playImageView.tintColor = UIColor.white
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(RouteDetailsController.handlePlayPause(_:)))
        self.playImageView.isUserInteractionEnabled = true
        self.playImageView.addGestureRecognizer(tapGestureRecognizer)
        
        self.containerView.addSubview(speedSlider)
        self.containerView.addSubview(sliderSpeedLabel)
        self.containerView.addSubview(playImageView)
        
        self.bottomView.backgroundColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
        
        self.bottomView.translatesAutoresizingMaskIntoConstraints = false
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.mapView)
        self.view.addSubview(self.bottomView)
        self.view.addSubview(self.containerView)
        
        
        let viewsDict = [
            "mapView" : mapView,
            "bottomView" : bottomView
            ]
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[mapView][bottomView(70)]-|", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[mapView]-0-|", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[bottomView]-0-|", options: [], metrics: nil, views: viewsDict))
        
    }
    
    func speedSliderValueDidChange(_ sender:UISlider!){
        print("value--\((sender.value*2)*1)")
        let value = Int(roundf(sender.value * 2.0) * 1)
        if(value == 0){
            sender.value = 1.0
            self.sliderSpeedLabel.text = "1x"
        }else{
            sender.value = Float(value)
            self.sliderSpeedLabel.text = "\(Int(sender.value))x"
        }
        
    }
    
    //to show loading
    func showLoading(){
        self.activityView.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray
        self.activityView.center = self.view.center
        self.activityView.startAnimating()
        self.view.addSubview(activityView)
    }
    
    //to hide loading
    func hideLoading(){
        self.activityView.stopAnimating()
        self.view.willRemoveSubview(activityView)
    }
}
