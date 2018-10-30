//
//  ProductivityReportViewController.swift
//  Placer
//
//  Created by Vishal on 08/09/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit
import TTGSnackbar
import Alamofire
import SwiftyJSON
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


class ProductivityReportDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var titleLabel: UILabel!
    var startDateLabel = UILabel()
    var startDateLabelText = UILabel()
    var deviceLabel = UILabel()
    var deviceLabelText = UILabel()
    var endDateLabel = UILabel()
    var endDateLabelText = UILabel()
    var serialNumberLabel = UILabel()
    var dateTimeLabel = UILabel()
    var distTravelledLabel = UILabel()
    var moveDurationLabel = UILabel()
    var haltDurationLabel = UILabel()
    var maxSpeedLabel = UILabel()
    var avgSpeedLabel = UILabel()
    var rowOneStackView = UIStackView()
    var rowTwoStackView = UIStackView()
    var backView = UIView()
    var separaterView = UIView()
    var productivityList = UITableView()
    var productivityStartDate: String!
    var productivityEndDate: String!
    var vehicleLocation: VehicleLocationResponse!
    var npk: String!
    var productivityLogs: [DaySummaryLog] = []
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
        print(self.productivityStartDate)
        print(self.productivityEndDate)
        print(self.vehicleLocation.name)
        if(NetworkReachability.isConnectedToNetwork()){
        getProductivityLog()
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
        return self.productivityLogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.productivityList.dequeueReusableCell(withIdentifier: "cell", for:indexPath) as! ProductivityReportCell
        if(indexPath.row % 2 == 0){
            cell.backView.backgroundColor = UIColor.white
        }else{
            cell.backView.backgroundColor = UIColor.hexStringToUIColor(Colors.row_grey)
        }
        
        cell.serialNumberLabel.text = "\(indexPath.row + 1)"
        cell.dateTimeLabel.text = "\(self.productivityLogs[indexPath.row].reportDate)"
        cell.distTravelledLabel.text = "\(self.productivityLogs[indexPath.row].totalDistance) kms"
        cell.moveDurationLabel.text = "\(self.productivityLogs[indexPath.row].totalMovementHours)"
        cell.haltDurationLabel.text = "\(self.productivityLogs[indexPath.row].totalHaltHours)"
        cell.avgSpeedLabel.text = "\(self.productivityLogs[indexPath.row].avgSpeed) kmph"
        cell.maxSpeedLabel.text = "\(self.productivityLogs[indexPath.row].maxSpeed) kmph"
        let maxSpeed = Int(self.productivityLogs[indexPath.row].maxSpeed)
        let avgSpeed = Int(self.productivityLogs[indexPath.row].avgSpeed)
        
        if(maxSpeed == 0){
            cell.maxSpeedLabel.textColor = UIColor.hexStringToUIColor(Colors.red_800)
        }else if(maxSpeed > 0 && maxSpeed <= 60){
            cell.maxSpeedLabel.textColor = UIColor.hexStringToUIColor(Colors.green_800)
        }else{
            cell.maxSpeedLabel.textColor = UIColor.hexStringToUIColor(Colors.blue_800)
        }
        
        if(avgSpeed == 0){
            cell.avgSpeedLabel.textColor = UIColor.hexStringToUIColor(Colors.red_800)
        }else if(avgSpeed > 0 && avgSpeed <= 60){
            cell.avgSpeedLabel.textColor = UIColor.hexStringToUIColor(Colors.green_800)
        }else{
            cell.avgSpeedLabel.textColor = UIColor.hexStringToUIColor(Colors.blue_800)
        }
        
        return cell
    }
    
    func getCurrentDate() -> String {
        let todaysDate:Date = Date()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: todaysDate)
    }
    
    func convertDate(_ dateString: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)!
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
    
    func getProductivityLog(){
        
        print("inside getProductivityLog")
        
        let headers = [
            "Authorization": "Basic "+getTokenDetail(),
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let getProductivityLogParams = ["vehId" : self.vehicleLocation.vehId, "date" : "\(self.productivityStartDate!)#\(self.productivityEndDate!)"]
        
        print(getProductivityLogParams)
        self.showLoading()
        Alamofire.request(Api.baseUrl + Api.getDaySummary, method: .get, parameters: getProductivityLogParams, headers: headers)
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
                        
                        for (key,subJson):(String, JSON) in innerJobj {
                            print(key)
                            if(key != "totalDistance"){
                                //print(subJson)
                                let daySummaryLog = DaySummaryLog()
                                daySummaryLog.avgSpeed = subJson["avgSpeed"].stringValue
                                daySummaryLog.totalHaltHours = subJson["totalHaltHours"].stringValue
                                daySummaryLog.maxSpeed = subJson["maxSpeed"].stringValue
                                daySummaryLog.totalDistance = subJson["totalDistance"].stringValue
                                daySummaryLog.totalMovementHours = subJson["totalMovementHours"].stringValue
                                daySummaryLog.reportDate = key
                                self.productivityLogs.append(daySummaryLog)
                            }
                        }
                        
                        self.hideLoading()
                        self.productivityLogs.sort(by: { self.convertDate($0.reportDate).compare(self.convertDate($1.reportDate)) == ComparisonResult.orderedAscending })
                        self.productivityList.reloadData()
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
        self.titleLabel.text = "Productivity Report"
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
        self.startDateLabelText.text = "Sep 04, 2016 12:00 AM"
        self.startDateLabelText.font = UIFont(name: "Roboto-Regular", size: 9.0)
        self.startDateLabelText.textAlignment = .center
        
        self.deviceLabelText.text = "#SEA-DL-1-VC-0511"
        self.deviceLabelText.font = UIFont(name: "Roboto-Bold", size: 10.0)
        self.deviceLabelText.textAlignment = .center
        self.deviceLabelText.textColor = UIColor.hexStringToUIColor(Colors.green_800)
        
        self.endDateLabelText.text = "Sep 04, 2016 11:59 PM"
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
        self.serialNumberLabel.font = UIFont(name: "Roboto-Bold", size: 7.0)
        self.serialNumberLabel.textAlignment = .center
        self.serialNumberLabel.numberOfLines = 1
        self.serialNumberLabel.adjustsFontSizeToFitWidth = true
        self.serialNumberLabel.minimumScaleFactor=0.5
        
        self.dateTimeLabel.frame = CGRect(x: self.serialNumberLabel.frame.width, y: 0, width: screenUnit*2, height: 18)
        self.dateTimeLabel.text = "Date"
        self.dateTimeLabel.font = UIFont(name: "Roboto-Bold", size: 7.0)
        self.dateTimeLabel.textAlignment = .center
        self.dateTimeLabel.numberOfLines = 1
        self.dateTimeLabel.adjustsFontSizeToFitWidth = true
        self.dateTimeLabel.minimumScaleFactor=0.5
        
        self.distTravelledLabel.frame = CGRect(x: self.serialNumberLabel.frame.width+self.dateTimeLabel.frame.width, y: 0, width: screenUnit*2, height: 18)
        self.distTravelledLabel.text = "Dist.Travelled"
        self.distTravelledLabel.font = UIFont(name: "Roboto-Bold", size: 7.0)
        self.distTravelledLabel.textAlignment = .center
        self.distTravelledLabel.numberOfLines = 1
        self.distTravelledLabel.adjustsFontSizeToFitWidth = true
        self.distTravelledLabel.minimumScaleFactor=0.5
        
        self.maxSpeedLabel.frame = CGRect(x: self.serialNumberLabel.frame.width+self.dateTimeLabel.frame.width+self.distTravelledLabel.frame.width, y: 0, width: screenUnit*2, height: 18)
        self.maxSpeedLabel.text = "Move.Duration"
        self.maxSpeedLabel.font = UIFont(name: "Roboto-Bold", size: 7.0)
        self.maxSpeedLabel.textAlignment = .center
        self.maxSpeedLabel.numberOfLines = 1
        self.maxSpeedLabel.adjustsFontSizeToFitWidth = true
        self.maxSpeedLabel.minimumScaleFactor=0.5
        
        self.moveDurationLabel.frame = CGRect(x: self.serialNumberLabel.frame.width+self.dateTimeLabel.frame.width+self.distTravelledLabel.frame.width+self.maxSpeedLabel.frame.width, y: 0, width: screenUnit*2, height: 18)
        self.moveDurationLabel.text = "Halt.Duration"
        self.moveDurationLabel.font = UIFont(name: "Roboto-Bold", size: 7.0)
        self.moveDurationLabel.textAlignment = .center
        self.moveDurationLabel.numberOfLines = 1
        self.moveDurationLabel.adjustsFontSizeToFitWidth = true
        self.moveDurationLabel.minimumScaleFactor=0.5
        
        self.haltDurationLabel.frame = CGRect(x: self.serialNumberLabel.frame.width+self.dateTimeLabel.frame.width+self.distTravelledLabel.frame.width+self.maxSpeedLabel.frame.width+self.moveDurationLabel.frame.width, y: 0, width: screenUnit*1.5, height: 18)
        self.haltDurationLabel.text = "Max.Speed"
        self.haltDurationLabel.font = UIFont(name: "Roboto-Bold", size: 7.0)
        self.haltDurationLabel.textAlignment = .center
        self.haltDurationLabel.numberOfLines = 1
        self.haltDurationLabel.adjustsFontSizeToFitWidth = true
        self.haltDurationLabel.minimumScaleFactor=0.5
        
        self.avgSpeedLabel.frame = CGRect(x: self.serialNumberLabel.frame.width+self.dateTimeLabel.frame.width+self.distTravelledLabel.frame.width+self.maxSpeedLabel.frame.width+self.moveDurationLabel.frame.width+self.haltDurationLabel.frame.width, y: 0, width: screenUnit*1.5, height: 18)
        self.avgSpeedLabel.text = "Avg.Speed"
        self.avgSpeedLabel.font = UIFont(name: "Roboto-Bold", size: 7.0)
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
        
        self.productivityList.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.productivityList)
        self.productivityList.separatorStyle = .none
        self.productivityList.delegate = self
        self.productivityList.dataSource = self
        self.productivityList.register(ProductivityReportCell.self, forCellReuseIdentifier: "cell")
        
        let viewsDict = [
            "separaterView" : separaterView,
            "productivityList" : productivityList
        ]
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[separaterView]-0-[productivityList]-0-|", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[productivityList]-0-|", options: [], metrics: nil, views: viewsDict))
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

