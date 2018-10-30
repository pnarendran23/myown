//
//  ViewWorkOrderController.swift
//  Placer
//
//  Created by Vishal on 29/08/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import TTGSnackbar

class WorkorderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var npk:String!
    var counter: Int = 0
    var isNewDataLoading: Bool = false
    var workorderLogs: [WorkorderLog] = []
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    var workorderList = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViews()
        if(NetworkReachability.isConnectedToNetwork()){
        self.getWorkorders("")
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
        titleLabel.text = "Workorders"
        titleLabel.font = UIFont(name: "Roboto-Light", size: 18.0)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        navigationItem.titleView = titleLabel
        
        self.workorderList.delegate = self
        self.workorderList.dataSource = self
        self.workorderList.register(WorkorderCell.self, forCellReuseIdentifier: "cell")
        //self.workorderList.allowsSelection = false
        self.view.addSubview(self.workorderList)
        
        self.workorderList.translatesAutoresizingMaskIntoConstraints = false
        
        let viewsDict = [
            "workorderList" : workorderList
        ]
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[workorderList]-0-|", options: [], metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[workorderList]-0-|", options: [], metrics: nil, views: viewsDict))
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.workorderLogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.workorderList.dequeueReusableCell(withIdentifier: "cell", for:indexPath) as! WorkorderCell
        
        cell.vehNameLabel.text = self.workorderLogs[indexPath.row].vehName
        cell.serviceTypeLabel.text = self.workorderLogs[indexPath.row].serviceType
        cell.priorityLabel.text = self.workorderLogs[indexPath.row].priority
        cell.statusLabel.text = self.workorderLogs[indexPath.row].status
        cell.createdOnLabel.text = "Created On: \(self.convertDate(self.workorderLogs[indexPath.row].createdOn))"
        cell.scheduledOnLabel.text = "Scheduled On: \(self.convertDate(self.workorderLogs[indexPath.row].scheduleDate))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let workorderDetailsViewController = WorkorderDetailsViewController()
        workorderDetailsViewController.workorderLog = self.workorderLogs[indexPath.row]
        self.navigationController?.pushViewController(workorderDetailsViewController, animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //Load more
        
        if scrollView == self.workorderList{
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                if !isNewDataLoading{
                    
//                    if (NetworkReachabilityManager.isConnectedToNetwork()){
                        if(self.counter == 25){
                            isNewDataLoading = true
                            self.getWorkorders(self.npk)
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
    
    func getWorkorders(_ npk:String){
        
        print("inside getNotificationLog")
        print("npk \(npk)")
        
        let headers = [
            "Authorization": "Basic "+getTokenDetail(),
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        var getDeviceLogParams = ["limit" : "25"]
        if(npk != ""){
            getDeviceLogParams["npk"] = npk
        }
        
        print(getDeviceLogParams)
        self.showLoading()
        Alamofire.request(Api.baseUrl + Api.getWorkorders, method: .get, parameters: getDeviceLogParams, headers: headers)
            .responseJSON { response in
                //print(response.request)  // original URL request
                //print(response.response) // URL response
                //print(response.data)     // server data
                //print(response.result)   // result of response serialization
                switch response.result {
                case .success( _):
                    if let jsonString = response.result.value {
                        //print("JSON: \(jsonString)")
                        let jObj = JSON(jsonString)
                        let innerJobj = jObj["results"]
                        self.npk = jObj["nextPageKey"].stringValue
                        self.counter = 0
                        for (_,subJson):(String, JSON) in innerJobj {
                            self.counter += 1
                            let workorderLog = WorkorderLog()
                            workorderLog.assignee = subJson["assignee"].stringValue
                            workorderLog.assigneeName = subJson["assigneeName"].stringValue
                            workorderLog.completedBy = subJson["completedBy"].stringValue
                            workorderLog.completedByName = subJson["completedByName"].stringValue
                            workorderLog.contactPersonName = subJson["contactPersonName"].stringValue
                            workorderLog.contactPersonNumber = subJson["contactPersonNumber"].stringValue
                            workorderLog.createdOn = subJson["createdOn"].stringValue
                            workorderLog.lat = subJson["lat"].stringValue
                            workorderLog.lng = subJson["lng"].stringValue
                            workorderLog.location = subJson["location"].stringValue
                            workorderLog.modelId = subJson["modelId"].stringValue
                            workorderLog.orgId = subJson["orgId"].stringValue
                            workorderLog.orgName = subJson["orgName"].stringValue
                            workorderLog.priority = subJson["priority"].stringValue
                            workorderLog.scheduleDate = subJson["scheduleDate"].stringValue
                            workorderLog.serviceType = subJson["serviceType"].stringValue
                            workorderLog.status = subJson["status"].stringValue
                            workorderLog.updatedOn = subJson["updatedOn"].stringValue
                            workorderLog.userActionId = subJson["userActionId"].stringValue
                            workorderLog.vehId = subJson["vehId"].stringValue
                            workorderLog.vehModel = subJson["vehModel"].stringValue
                            workorderLog.vehName = subJson["vehName"].stringValue
                            workorderLog.vehNumber = subJson["vehNumber"].stringValue
                            workorderLog.workOrderId = subJson["workOrderId"].stringValue
                            workorderLog.des = subJson["comments"].stringValue
                            
                            self.workorderLogs.append(workorderLog)
                        }
                        self.hideLoading()
                        self.workorderList.reloadData()
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
