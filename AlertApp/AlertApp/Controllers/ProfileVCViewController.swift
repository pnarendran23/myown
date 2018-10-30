//
//  ProfileVCViewController.swift
//  AlertApp
//
//  Created by Group10 on 16/02/18.
//  Copyright © 2018 Group10. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift
import Realm

class ProfileVCViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate,alertsDelegate {
    
    private var titlesArray:[String] = []
    private var alertsArray: NSMutableArray = []
    private let imgsArray = ["profile-2.png",
                             "profile-2.png",
                             "profile-1.png",
                             "profile-3.png",
                             "profile-3.png",
                             "profile-4.png",
                             "profile-4.png",
                             "profile-5.png",
                             "profile-6.png",
                             "profile-8.png"]
    
    var member:StudentDbInfo? = nil
    
    @IBOutlet var tblProfile: UITableView!
    var appLock : Bool = false
    //    dfsffsfdf
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //        if indexPath.row == titlesArray.count {
        //            return 200
        //        }else {
        //            return 60
        //        }
        
        return 70
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == (titlesArray.count - 1 ){
            let storyboard = UIStoryboard(name: "Profilenew", bundle: nil)
            let profileview:AlertPopupVCViewController = storyboard.instantiateViewController(withIdentifier: "AlertPopupVCViewController") as! AlertPopupVCViewController
            //            let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("nextView") as NextViewController
            profileview.modalPresentationStyle = .popover
            let popover = profileview.popoverPresentationController!
            profileview.alertsarray = alertsArray
            popover.delegate = self
            profileview.delegate = self
            popover.permittedArrowDirections = .up
//            _ = tableView.cellForRow(at: indexPath) as! UITableViewCell
            let cell1 = tableView.cellForRow(at: NSIndexPath.init(row: titlesArray.count - 4, section: 0) as IndexPath) as! UITableViewCell
            popover.sourceView = cell1 as? UITableViewCell
            profileview.preferredContentSize = CGSize(width:self.view.frame.size.width,height:0.64 * self.view.frame.size.height)
            self.present(profileview, animated:true, completion:nil)
            
        }else{
            //            let storyboard = UIStoryboard(name: "Profilenew", bundle: nil)
            //            let profileview:ChartController = storyboard.instantiateViewController(withIdentifier: "ChartController") as! ChartController
            //            let mainViewController = self.sideMenuController
            //            let navigationController = mainViewController?.rootViewController as! NavigationController
            //            navigationController.pushViewController(profileview, animated: true)
            
        }
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        if(titlesArray.count > 0){
        //            return titlesArray.count
        //        }
        return titlesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        if indexPath.row == titlesArray.count {
        //            let cell = tableView.dequeueReusableCell(withIdentifier: "Profile2TableViewCell", for: indexPath) as! Profile2TableViewCell
        //            cell.selectionStyle = UITableViewCellSelectionStyle.none
        //
        //            return cell
        //        }
        //        else
        print("index row is \(indexPath.row) total count \(titlesArray.count)")
        if(indexPath.row == (titlesArray.count-1)){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomAlertsTableViewCell", for: indexPath) as! CustomAlertsTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            let temp : NSMutableArray = []
            for item in alertsArray {
                if(item as! String != ""){
                    temp.add(item)
                }
            }
            cell.lblAlerts.text = temp.componentsJoined(by: ",")
            if(appLock){
                 cell.isHidden = false
            }else{
                 cell.isHidden = true
            }
           
            return cell
        }
        else  {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "profilecell", for: indexPath) as! Profile3TableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.lblTitle.text = titlesArray[indexPath.row]
            print("")
            cell.ivProfile.image = UIImage(named: imgsArray[indexPath.row])
            cell.lblTitle.sizeToFit()
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        
        self.tblProfile.register(UINib.init(nibName: "CustomAlertsTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomAlertsTableViewCell")
        
        self.tblProfile.register(UINib.init(nibName: "ProfileCellTableViewCell", bundle: nil), forCellReuseIdentifier: "Profile2TableViewCell")
        self.tblProfile.dataSource = self
        self.tblProfile.delegate = self
        self.navigationController?.navigationBar.topItem?.title = "Profile"
        
        //  print("member id is ===\(member?.memberId)")
        
        getProfileInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func getProfileInfo() {
        
        if appDelegate().isInternetAvailable()
        {
            DispatchQueue.main.async {
                Utility.showLoading()
            }
            
            let jsonObject: [String : Any] = [
                "data":[
                    "key" : Utility().getTokenUniqueDetail(),
                    "filter": ["memberId" : member?.memberId]
                    //                    "form": [
                    //                        "mobileno": txtPhone.text ?? "",
                    //                        "macid": Utility.getMacAddress(),
                    //                        "appversion": Utility.getAppVersion(),
                    //                        "versionnum": Utility.getModel(),
                    //                        "devicetoken": "testing ios",
                    //                        "ostype":"iOS"
                    //                    ]
                ]
            ]
            var convertString:String?=nil
            if let dataString  = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
                let str = String(data: dataString, encoding: .utf8) {
                convertString=str
                print(str)
            }
            
            var dictonary:NSDictionary? = nil
            if let data = convertString?.data(using: String.Encoding.utf8) {
                
                do {
                    dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as NSDictionary?
                    
                } catch let error as NSError {
                    print(error)
                }
            }
            let requestType = "POST"
            let api = GlobalConstants.API.baseUrl + GlobalConstants.API.appMemberInfo
            
            APIHandler().loginApiDetails(parameters: dictonary, api: api, requestType: requestType, completionHandler: { (sucess,response, error) in
                
                if sucess {
                    
                    DispatchQueue.main.async {
                        if(response != nil){
                            let json = JSON(response ?? nil)
                            let arrayNames =  json["response"]
                            var vehName = ""
                            var lock = ""
                            print("prifile response is \(response)")
                            
                            for (_,val) in arrayNames {
                                
                                print("items == \(val["memberUID"])")
                                
                                let user = StudentDbInfo()
                                user.memberName = "\(val["memberName"])"
                                user.memberUid = "\(val["memberUID"])"
                                user.memberSection = "\(val["memberSection"])"
                                user.memberParentName = "\(val["memberParentName"])"
                                user.memberPrimaryMobileNo = "\(val["memberPrimaryMobileNo"])"
                                user.memberSecondaryMobileNo = "\(val["memberSecondaryMobileNo"])"
                                user.memberClass = "\(val["memberClass"])"
                                user.memberId = "\(val["memberId"])"
                                
                                
                                
                                user.appAlert = ("\(val["appAlert"])")
                                user.smsAlert = ("\(val["smsAlert"])")
                                user.callAlert = ("\(val["callAlert"])")
                                user.emailAlert = ("\(val["emailAlert"])")
                                
                                if(user.appAlert == "0" || user.appAlert == "false")
                                {
                                    self.alertsArray.add("")
                                }else{
                                    self.alertsArray.add("Alert")
                                }
                                if(user.smsAlert == "0" || user.smsAlert == "false")
                                {
                                    self.alertsArray.add("")
                                }else{
                                    self.alertsArray.add("Sms")
                                }
                                if(user.callAlert == "0" || user.callAlert == "false")
                                {
                                    self.alertsArray.add("")
                                }else{
                                    self.alertsArray.add("Call")
                                }
                                if(user.emailAlert == "0" || user.emailAlert == "false")
                                {
                                    self.alertsArray.add("")
                                }else{
                                    self.alertsArray.add("Email")
                                }
                                lock = ("\(val["alertlock"])")
                                
                                if( lock == "1" ||  lock == "true"){
                                    self.appLock = true
                                }
                                self.titlesArray.append("School : \(val["orgName"])")
                                self.titlesArray.append("Class : \(user.memberClass)")
                                self.titlesArray.append("Student Id : \(user.memberUid)")
                                
                                
                                print("splash  \(user.memberName) section \(user.memberSection) id \(user.memberUid)")
                                
                                
                                let valueOf = val["memberInfo"]
                                let valuOfJson = JSON(valueOf)
                                var pickUpName = ""
                                var dropName = ""
                                
                                for (_,valueOfNew) in valuOfJson{
                                    //  print("pickup \(valueOfNew["pickuppointLocation"]) \(valueOfNew["routeType"])")
                                    
                                    let routetype = "\(valueOfNew["routeType"])"
                                    print("routetype   (\(routetype)")
                                    
                                    if routetype == "pickup" {
                                        user.expectedTime =  "\(valueOfNew["expectedTime"])"
                                        self.titlesArray.append("Pickup Time : \(user.expectedTime)")
                                        user.pickuppointLocation = "\(valueOfNew["pickuppoint"])"
                                        self.titlesArray.append("Pickup Location : \(user.pickuppointLocation)")
                                        user.pickupId = "\(valueOfNew["pickupId"])"
                                        user.pickupRadius = Int(Double("\(valueOfNew["pickupRadius"])")!)
                                        user.routeType = routetype
                                        vehName = "\(valueOfNew["vehicleName"])"
                                        pickUpName = "\(valueOfNew["routeName"])"
                                        let p = valueOfNew["pickuppointLocation"]
                                        print("lat == \(p["lat"])")
                                        user.p_lat = Double("\(p["lat"])")!
                                        user.p_lng = Double("\(p["lng"])")!
                                    }else{
                                        user.dropexpectedTime =  "\(valueOfNew["expectedTime"])"
                                        self.titlesArray.append("Drop Time : \(user.dropexpectedTime)")
                                        user.DroppointLocation = "\(valueOfNew["pickuppoint"])"
                                        self.titlesArray.append("Drop Location : \(user.DroppointLocation)")
                                        user.pickupDropId = "\(valueOfNew["pickupId"])"
                                        user.dropRadius = Int(Double("\(valueOfNew["pickupRadius"])")!)
                                        dropName = "\(valueOfNew["routeName"])"
                                        let p = valueOfNew["pickuppointLocation"]
                                        print("lat == \(p["lat"])")
                                        user.drop_lat = Double("\(p["lat"])")!
                                        user.drop_lng = Double("\(p["lng"])")!
                                        vehName = "\(valueOfNew["vehicleName"])"
                                    }
                                    
                                }
                                self.titlesArray.append("RouteName : \(pickUpName) - \(dropName)")
                                
                            }
                            if(vehName != "" || vehName != "null" ){
                                self.titlesArray.append("VehicleName : \(vehName)")
                            }else{
//                                self.titlesArray.append("VehicleName : ")
                            }
                            //                        self.titlesArray.append("DriverName")
                            //                        self.titlesArray.append("Alerts")
                            self.tblProfile.reloadData()
                            
                            print("array is \(self.alertsArray)")
                            DispatchQueue.main.async {
                                Utility.hideLoading()
                            }
                        }
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        appDelegate().showEmailAlert(message: "Error ")
                    }
                }
                //                }
            })
        }else{
            appDelegate().showEmailAlert(message: GlobalConstants.Errors.internetConnectionError)
        }
        
    }
    
    
    
    var alertStatus = "false"
    
    func onAlertsUpdated(alertsarray: NSMutableArray) {
        
        var dict : Dictionary = [String : String]()
        
        dict["memberId"] = member?.memberId
        var temp = NSMutableArray()
        temp = alertsarray
        print("Alert array is",temp)
        var appAlert = "false"
        var smsAlert = "false"
        var callAlert = "false"
        var emailAlert = "false"
        for item in temp {
            if item as! String != "" {
                if(item as! String == "Alert") {
                    appAlert = "true"
                }else if(item as! String == "Sms") {
                    smsAlert = "true"
                }else if(item as! String == "Email") {
                    emailAlert = "true"
                }else if(item as! String == "Call") {
                    callAlert = "true"
                }
            }
        }
        dict["appAlert"] = appAlert
        dict["smsAlert"] = smsAlert
        dict["emailAlert"] = emailAlert
        dict["callAlert"] = callAlert
        print("dict is == \(dict)")
        
        if(appDelegate().isInternetAvailable()){
            alertConfig(dic: dict)
        }else{
            appDelegate().showEmailAlert(message: GlobalConstants.Errors.internetConnectionError)
        }
    }
    
    func alertConfig(dic : Dictionary<String, String>) {
        DispatchQueue.main.async {
            Utility.showLoading()
        }
        
        let jsonObject: [String : Any] = [
            "data":[
                "key" : Utility().getTokenUniqueDetail(),
                "form": dic
                
            ]
        ]
        var convertString:String?=nil
        if let dataString  = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
            let str = String(data: dataString, encoding: .utf8) {
            convertString=str
            print(str)
        }
        
        var dictonary:NSDictionary? = nil
        if let data = convertString?.data(using: String.Encoding.utf8) {
            
            do {
                dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as NSDictionary?
                
            } catch let error as NSError {
                print(error)
            }
        }
        let requestType = "POST"
        let api = GlobalConstants.API.baseUrl + GlobalConstants.API.alertsConfig
        
        APIHandler().loginApiDetails(parameters: dictonary, api: api, requestType: requestType, completionHandler: { (sucess,response, error) in
            
            if sucess {
                print("sms config response\(response)")
                DispatchQueue.main.async {
                    DispatchQueue.main.async {
                        Utility.hideLoading()
                    }
                    
                    self.tblProfile.reloadData()
                    
                }
                
                //                    print("member info response \(String(describing: response)) ")
            }else{
                DispatchQueue.main.async {
                    appDelegate().showEmailAlert(message: "Error ")
                }
            }
        })
    }
    
}
