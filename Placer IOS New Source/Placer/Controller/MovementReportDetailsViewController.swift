//
//  ReportDetailsViewController.swift
//  Placer
//
//  Created by Vishal on 04/09/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit
import TTGSnackbar
import Alamofire
import SwiftyJSON

class MovementReportDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var titleLabel: UILabel!
    var startDateLabel = UILabel()
    var startDateLabelText = UILabel()
    var deviceLabel = UILabel()
    var deviceLabelText = UILabel()
    var endDateLabel = UILabel()
    var endDateLabelText = UILabel()
    var serialNumberLabel = UILabel()
    var dateTimeLabel = UILabel()
    var locationLabel = UILabel()
    var ignitionLabel = UILabel()
    var acLabel = UILabel()
    var speedLabel = UILabel()
    var distanceLabel = UILabel()
    var rowOneStackView = UIStackView()
    var rowTwoStackView = UIStackView()
    var backView = UIView()
    var separaterView = UIView()
    var movementList = UITableView()
    var movementStartDate: String!
    var movementEndDate: String!
    var vehicleLocation: VehicleLocationResponse!
    var npk: String!
    var deviceLogs: [MovementLog] = []
    var isNewDataLoading: Bool = false
    var counter: Int = 0
    var lastGpsDate: String!
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViews()
        self.initRowOne()
        self.initRowTwo()
        self.initRowThree()
        self.initMovementList()
        print(self.movementStartDate)
        print(self.movementEndDate)
        print(self.vehicleLocation.name)
        if(NetworkReachability.isConnectedToNetwork()){
        getDeviceLog("",gpsdate: "")
        }else{
            let snackbar = TTGSnackbar.init(message: "No Internet Connectivity!", duration: .short)
            snackbar.show()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.deviceLogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.movementList.dequeueReusableCell(withIdentifier: "cell", for:indexPath) as! MovementReportCell
        if(indexPath.row % 2 == 0){
            if(Int(self.deviceLogs[indexPath.row].speed) == 0){
                cell.backView.backgroundColor = UIColor.hexStringToUIColor(Colors.row_pink)
            }else {
                cell.backView.backgroundColor = UIColor.hexStringToUIColor(Colors.row_green)
            }
        }else{
            cell.backView.backgroundColor = UIColor.hexStringToUIColor(Colors.row_grey)
        }
        cell.serialNumberLabel.text = "\(indexPath.row + 1)"
        cell.speedLabel.text = self.deviceLogs[indexPath.row].speed
        //let myMilliseconds: UnixTime = Int(self.deviceLogs[indexPath.row].gpsDateTime)!
        cell.dateTimeLabel.text = self.convertDate(self.deviceLogs[indexPath.row].gpsDateTime)//"\(myMilliseconds.toDay) \(myMilliseconds.toHour)"
        cell.locationLabel.text = self.deviceLogs[indexPath.row].nearLocationShort
        if(self.deviceLogs[indexPath.row].powerSensor1 == "1") {
            cell.ignitionImageView.tintColor = UIColor.hexStringToUIColor(Colors.green_800)
        }else{
            cell.ignitionImageView.tintColor = UIColor.hexStringToUIColor(Colors.red_800)
        }
        if(self.deviceLogs[indexPath.row].powerSensor2 == "1"){
            cell.acImageView.tintColor = UIColor.hexStringToUIColor(Colors.green_800)
        }else{
            cell.acImageView.tintColor = UIColor.hexStringToUIColor(Colors.red_800)
        }
        cell.distanceLabel.text = self.deviceLogs[indexPath.row].distance
        
        return cell
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //Load more
        
        if scrollView == self.movementList{
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                if !isNewDataLoading{
                    
                    if (self.counter == 30){
                        isNewDataLoading = true
                        getDeviceLog(self.npk, gpsdate: (self.deviceLogs.last?.gpsDateTime)!)
                    }/*else{
                        let snackbar = TTGSnackbar.init(message: "No Internet Connectivity!", duration: .short)
                        snackbar.backgroundColor = UIColor.hexStringToUIColor(Colors.colorPrimary)
                        snackbar.show()
                    }*/
                }
            }
        }
    }
    
    func getCurrentDate() -> String {
        let todaysDate:Date = Date()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: todaysDate)
    }
    
    func convertDate(_ milliSeconds: String) -> String{
        let todaysDate:Date = Date(timeIntervalSince1970: Double(milliSeconds)!)
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, HH:mm a"
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
    
    func getDeviceLog(_ npk:String, gpsdate: String){
        
        print("inside getDeviceLog")
        print("npk \(npk)")
        print("gpsDate \(gpsdate)")
        
        let headers = [
            "Authorization": "Basic "+getTokenDetail(),
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        var getDeviceLogParams = ["vehId" : self.vehicleLocation.vehId, "limit" : "30", "startTime" : "\(self.movementStartDate!)","endTime" : "\(self.movementEndDate!)"]
        if(npk != ""){
            getDeviceLogParams["npk"] = npk
        }
        if(gpsdate != ""){
            getDeviceLogParams.updateValue(gpsdate, forKey: "startTime")
        }
        
        print(getDeviceLogParams)
        //self.showLoading()
        Alamofire.request(Api.baseUrl + Api.getDeviceLog, method: .get, parameters: getDeviceLogParams, headers: headers)
            .responseJSON { response in
                print(response.request!)  // original URL request
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
                        self.counter = 0
                        for (_,subJson):(String, JSON) in deviceLogArray {
                            self.counter += 1
                            let deviceLog = MovementLog()
                            deviceLog.distance = subJson["distance"].stringValue
                            deviceLog.gpsDateTime = subJson["gpsDateTime"].stringValue
                            deviceLog.speed = subJson["speed"].stringValue
                            deviceLog.powerSensor1 = subJson["powerSensor1"].stringValue
                            deviceLog.powerSensor2 = subJson["powerSensor2"].stringValue
                            deviceLog.speed = subJson["speed"].stringValue
                            deviceLog.nearLocationShort = subJson["nearLocationShort"].stringValue
                            deviceLog.lat = subJson["location"]["lat"].stringValue
                            deviceLog.lng = subJson["location"]["lng"].stringValue
                            deviceLog.totalDistance = subJson["totalDistance"].stringValue
                            deviceLog.serverDateTime = subJson["serverDateTime"].stringValue
                            deviceLog.nearLocationFull = subJson["nearLocationFull"].stringValue
                            deviceLog.fuelSensor = subJson["fuelSensor"].stringValue
                            deviceLog.maxSpeed = subJson["maxSpeed"].stringValue
                            deviceLog.avgSpeed = subJson["avgSpeed"].stringValue
                            deviceLog.totalHaltHours = subJson["totalHaltHours"].stringValue
                            deviceLog.totalMovementHours = subJson["totalMovementHours"].stringValue
                            self.deviceLogs.append(deviceLog)
                        }

                        self.hideLoading()
                        self.movementList.reloadData()
                        self.isNewDataLoading = false
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                    self.hideLoading()
                }
        }
    }
    
    func initViews(){
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        //nav title
        self.title = ""
        self.titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: (self.navigationController?.navigationBar.frame.height)!))
        self.titleLabel.center = (navigationController?.navigationBar.center)!
        self.titleLabel.text = "Movement Report"
        self.titleLabel.font = UIFont(name: "Roboto-Light", size: 18.0)
        self.titleLabel.textColor = UIColor.white
        self.titleLabel.textAlignment = .center
        navigationItem.titleView = self.titleLabel
    }
    
    func initRowOne(){
        self.startDateLabel.text = "Start Date"
        self.startDateLabel.font = UIFont(name: "Roboto-Regular", size: 11.0)
        self.startDateLabel.textAlignment = .center
        
        self.deviceLabel.text = "Device"
        self.deviceLabel.font = UIFont(name: "Roboto-Regular", size: 11.0)
        self.deviceLabel.textAlignment = .center
        
        self.endDateLabel.text = "End Date"
        self.endDateLabel.font = UIFont(name: "Roboto-Regular", size: 11.0)
        self.endDateLabel.textAlignment = .center
        
        self.rowOneStackView.addArrangedSubview(self.startDateLabel)
        self.rowOneStackView.addArrangedSubview(self.deviceLabel)
        self.rowOneStackView.addArrangedSubview(self.endDateLabel)
        
        self.rowOneStackView.axis = .horizontal
        self.rowOneStackView.distribution = .fillEqually
        self.rowOneStackView.alignment = .fill
        self.rowOneStackView.spacing = 5
        self.rowOneStackView.isBaselineRelativeArrangement = true
        self.rowOneStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.rowOneStackView)
        
        let viewsDict = [
            "rowOneStackView" : rowOneStackView
        ]
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[rowOneStackView]", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[rowOneStackView]-8-|", options: [], metrics: nil, views: viewsDict))
        
    }
    
    func initRowTwo(){
        self.startDateLabelText.text = self.movementStartDate//"Sep 04, 2016 12:00 AM"
        self.startDateLabelText.font = UIFont(name: "Roboto-Regular", size: 9.0)
        self.startDateLabelText.textAlignment = .center
        
        self.deviceLabelText.text = self.vehicleLocation.vehNumber//"#SEA-DL-1-VC-0511"
        self.deviceLabelText.font = UIFont(name: "Roboto-Bold", size: 10.0)
        self.deviceLabelText.textAlignment = .center
        self.deviceLabelText.textColor = UIColor.hexStringToUIColor(Colors.green_800)
        
        self.endDateLabelText.text = self.movementEndDate//"Sep 04, 2016 11:59 PM"
        self.endDateLabelText.font = UIFont(name: "Roboto-Regular", size: 9.0)
        self.endDateLabelText.textAlignment = .center
        
        self.rowTwoStackView.addArrangedSubview(self.startDateLabelText)
        self.rowTwoStackView.addArrangedSubview(self.deviceLabelText)
        self.rowTwoStackView.addArrangedSubview(self.endDateLabelText)
        
        self.rowTwoStackView.axis = .horizontal
        self.rowTwoStackView.distribution = .fillEqually
        self.rowTwoStackView.alignment = .fill
        self.rowTwoStackView.spacing = 5
        self.rowTwoStackView.isBaselineRelativeArrangement = true
        self.rowTwoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.rowTwoStackView)
        
        let viewsDict = [
            "rowOneStackView" : rowOneStackView,
            "rowTwoStackView" : rowTwoStackView
        ]
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[rowOneStackView]-4-[rowTwoStackView]", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[rowTwoStackView]-8-|", options: [], metrics: nil, views: viewsDict))
        
    }
    
    func initRowThree(){
        
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        let screenUnit = width/12
        
        backView.backgroundColor = UIColor.hexStringToUIColor(Colors.reportHeader)
        
        self.serialNumberLabel.frame = CGRect(x: 0, y: 0, width: screenUnit*1, height: 18)
        self.serialNumberLabel.text = "##"
        self.serialNumberLabel.font = UIFont(name: "Roboto-Bold", size: 8.0)
        self.serialNumberLabel.textAlignment = .center
        
        self.dateTimeLabel.frame = CGRect(x: self.serialNumberLabel.frame.width, y: 0, width: screenUnit*2.5, height: 18)
        self.dateTimeLabel.text = "Date/Time"
        self.dateTimeLabel.font = UIFont(name: "Roboto-Bold", size: 8.0)
        self.dateTimeLabel.textAlignment = .center
        
        self.locationLabel.frame = CGRect(x: self.serialNumberLabel.frame.width+self.dateTimeLabel.frame.width, y: 0, width: screenUnit*4, height: 18)
        self.locationLabel.text = "Location"
        self.locationLabel.font = UIFont(name: "Roboto-Bold", size: 8.0)
        self.locationLabel.textAlignment = .center
        
        self.speedLabel.frame = CGRect(x: self.serialNumberLabel.frame.width+self.dateTimeLabel.frame.width+self.locationLabel.frame.width, y: 0, width: screenUnit*1.25, height: 18)
        self.speedLabel.text = "Speed"
        self.speedLabel.font = UIFont(name: "Roboto-Bold", size: 8.0)
        self.speedLabel.textAlignment = .center
        
        self.ignitionLabel.frame = CGRect(x: self.serialNumberLabel.frame.width+self.dateTimeLabel.frame.width+self.locationLabel.frame.width+self.speedLabel.frame.width, y: 0, width: screenUnit*1, height: 18)
        self.ignitionLabel.text = "IGN"
        self.ignitionLabel.font = UIFont(name: "Roboto-Bold", size: 8.0)
        self.ignitionLabel.textAlignment = .center
        
        self.acLabel.frame = CGRect(x: self.serialNumberLabel.frame.width+self.dateTimeLabel.frame.width+self.locationLabel.frame.width+self.speedLabel.frame.width+self.ignitionLabel.frame.width, y: 0, width: screenUnit*1, height: 18)
        self.acLabel.text = "AC"
        self.acLabel.font = UIFont(name: "Roboto-Bold", size: 8.0)
        self.acLabel.textAlignment = .center
        
        self.distanceLabel.frame = CGRect(x: self.serialNumberLabel.frame.width+self.dateTimeLabel.frame.width+self.locationLabel.frame.width+self.speedLabel.frame.width+self.ignitionLabel.frame.width+self.acLabel.frame.width, y: 0, width: screenUnit*1.25, height: 18)
        self.distanceLabel.text = "Distance"
        self.distanceLabel.font = UIFont(name: "Roboto-Bold", size: 8.0)
        self.distanceLabel.textAlignment = .center
        
        backView.addSubview(self.serialNumberLabel)
        backView.addSubview(self.dateTimeLabel)
        backView.addSubview(self.locationLabel)
        backView.addSubview(self.speedLabel)
        backView.addSubview(self.ignitionLabel)
        backView.addSubview(self.acLabel)
        backView.addSubview(self.distanceLabel)
        
        self.separaterView.backgroundColor = UIColor.hexStringToUIColor(Colors.colorDivider)
        
        backView.translatesAutoresizingMaskIntoConstraints = false
        self.separaterView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(backView)
        self.view.addSubview(self.separaterView)
        
        let viewsDict = [
            "rowOneStackView" : rowOneStackView,
            "rowTwoStackView" : rowTwoStackView,
            "backView" : backView,
            "separaterView" : separaterView
        ]
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[rowTwoStackView]-6-[backView(18)]", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[backView]-0-|", options: [], metrics: nil, views: viewsDict))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[backView]-0-[separaterView(1)]", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[separaterView]-0-|", options: [], metrics: nil, views: viewsDict))
    }
    
    func initMovementList(){
        
        self.movementList.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.movementList)
        self.movementList.separatorStyle = .none
        self.movementList.delegate = self
        self.movementList.dataSource = self
        self.movementList.register(MovementReportCell.self, forCellReuseIdentifier: "cell")
        
        let viewsDict = [
            "separaterView" : separaterView,
            "movementList" : movementList
        ]
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[separaterView]-0-[movementList]-0-|", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[movementList]-0-|", options: [], metrics: nil, views: viewsDict))
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
