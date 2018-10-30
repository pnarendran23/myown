//
//  NotificationsController.swift
//  Placer
//
//  Created by Vishal on 29/08/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import TTGSnackbar

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var notificationList = UITableView()
    var npk:String!
    var counter: Int = 0
    var notificationLogs: [NotificationLog] = []
    var isNewDataLoading: Bool = false
    var vehicleLocations: [VehicleLocationResponse] = []
    var vehicleLocation: VehicleLocationResponse!
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViews()
        if(NetworkReachability.isConnectedToNetwork()){
        getNotificationLog("")
        }else{
            let snackbar = TTGSnackbar.init(message: "No Internet Connectivity!", duration: .short)
            snackbar.show()
        }
    }
    
    func initViews(){
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        //nav title
        self.title = ""
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: (self.navigationController?.navigationBar.frame.height)!))
        titleLabel.center = (navigationController?.navigationBar.center)!
        titleLabel.text = "Notifications"
        titleLabel.font = UIFont(name: "Roboto-Light", size: 18.0)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        navigationItem.titleView = titleLabel
        self.notificationList.delegate = self
        self.notificationList.dataSource = self
        self.notificationList.register(NotificationCell.self, forCellReuseIdentifier: "cell")
        self.notificationList.allowsSelection = false
        self.view.addSubview(self.notificationList)
        
        self.notificationList.translatesAutoresizingMaskIntoConstraints = false
        
        let viewsDict = [
            "notificationList" : notificationList
        ]
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[notificationList]-0-|", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[notificationList]-0-|", options: [], metrics: nil, views: viewsDict))
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationLogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.notificationList.dequeueReusableCell(withIdentifier: "cell", for:indexPath) as! NotificationCell
        for veh in vehicleLocations{
            if(veh.vehId == self.notificationLogs[indexPath.row].vehId){
                self.vehicleLocation = veh
            }
        }
        if(self.notificationLogs[indexPath.row].notificationType == "speed"){
            cell.notificationTypeLabel.text = "Overspeeding Alert!"
            cell.notificationTypeLabel.textColor = UIColor.hexStringToUIColor(Colors.work_blue)
            cell.notificationImageView.tintColor = UIColor.hexStringToUIColor(Colors.work_blue)
            let nMsg = self.notificationLogs[indexPath.row].msg
            var replaced = (nMsg as NSString).replacingOccurrences(of: "_SPEED_", with: self.notificationLogs[indexPath.row].speed)
            replaced = (replaced as NSString).replacingOccurrences(of: "_VEHICLE_", with: self.vehicleLocation.name)
            replaced = (replaced as NSString).replacingOccurrences(of: "_GPS_TIME_", with: self.notificationLogs[indexPath.row].location)
            cell.notificationLabel.text = replaced
            cell.updatedLabel.text = self.convertDate(self.notificationLogs[indexPath.row].gpsDateTime)
        }else if(self.notificationLogs[indexPath.row].notificationType == "ignition"){
            cell.notificationTypeLabel.text = "Engine ON Alert!"
            cell.notificationTypeLabel.textColor = UIColor.hexStringToUIColor(Colors.work_green)
            cell.notificationImageView.tintColor = UIColor.hexStringToUIColor(Colors.work_green)
            let nMsg = self.notificationLogs[indexPath.row].msg
            var replaced = (nMsg as NSString).replacingOccurrences(of: "_VEHICLE_", with: self.vehicleLocation.name)
            replaced = (replaced as NSString).replacingOccurrences(of: "_GPS_TIME_", with: self.notificationLogs[indexPath.row].location)
            cell.notificationLabel.text = replaced
            cell.updatedLabel.text = self.convertDate(self.notificationLogs[indexPath.row].gpsDateTime)
        }else if(self.notificationLogs[indexPath.row].notificationType == "geofence"){
            cell.notificationTypeLabel.text = "Geofence Alert!"
        }else if(self.notificationLogs[indexPath.row].notificationType == "sos"){
            cell.notificationTypeLabel.text = "SOS Alert!"
        }else if(self.notificationLogs[indexPath.row].notificationType == "disconnect"){
            cell.notificationTypeLabel.text = "Disconnect Alert!"
        }
        
        return cell
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //Load more
        
        if scrollView == self.notificationList{
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                if !isNewDataLoading{
                    
//                    if (NetworkReachability.isConnectedToNetwork()){
                        if(self.counter == 30){
                            isNewDataLoading = true
                            getNotificationLog(self.npk)
                        }
//                    }else{
//                        let snackbar = TTGSnackbar.init(message: "No Internet Connectivity!", duration: .short)
//                        snackbar.backgroundColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
//                        snackbar.show()
//                    }
                }
            }
        }
    }
    
    func convertDate(_ milliSeconds: String) -> String{
        let todaysDate:Date = Date(timeIntervalSince1970: Double(milliSeconds)!)
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, HH:mm a"
        return dateFormatter.string(from: todaysDate)
    }
    
    func getNotificationLog(_ npk:String){
        
        print("inside getNotificationLog")
        print("npk \(npk)")
        
        let headers = [
            "Authorization": "Basic "+getTokenDetail(),
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        var getDeviceLogParams = ["notificationType" : "PUSH", "limit" : "30"]
        if(npk != ""){
            getDeviceLogParams["npk"] = npk
        }
        self.showLoading()
        print(getDeviceLogParams)
        //self.showLoading()
        Alamofire.request(Api.baseUrl + Api.getNotification, method: .get, parameters: getDeviceLogParams, headers: headers)
            .responseJSON { response in
//                print(response.request ?? <#default value#>)  // original URL request
//                print(response.response!) // URL response
//                print(response.data)     // server data
                print(response.result)   // result of response serialization
                switch response.result {
                case .success( _):
                    if let jsonString = response.result.value {
                        //print("JSON: \(jsonString)")
                        let jObj = JSON(jsonString)
                        let innerJobj = jObj["records"]
                        self.npk = jObj["nextPageContinueKey"].stringValue
                        self.counter = 0
                        for (_,subJson):(String, JSON) in innerJobj {
                            self.counter += 1
                            let notificationLog = NotificationLog()
                            notificationLog.gpsDateTime = subJson["gpsDateTime"].stringValue
                            notificationLog.location = subJson["locationShort"].stringValue
                            notificationLog.vehId = subJson["vehId"].stringValue
                            notificationLog.speed = subJson["speed"].stringValue
                            for (_, nJson):(String, JSON) in subJson["notification"]{
                                
                                for (k, j):(String, JSON) in nJson{
                                    //print("Key : \(k)")
                                    //print("JSON : \(j)")
                                    notificationLog.notificationType = k
                                    notificationLog.msg = j["msg"].stringValue
                                    notificationLog.read = j["read"].stringValue
                                }
                            }
                            self.notificationLogs.append(notificationLog)
                        }
                        
                        self.hideLoading()
                        self.notificationList.reloadData()
                        self.isNewDataLoading = false
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    self.hideLoading()
                }
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
