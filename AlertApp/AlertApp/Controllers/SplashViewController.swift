//
//  SplashViewController.swift
//  AlertApp
//
//  Created by Group10 on 14/02/18.
//  Copyright © 2018 Group10. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class SplashViewController: UIViewController {
    @IBOutlet var progressview: UIProgressView!
    var timer = Timer()
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = true
        
//        let delayInSeconds = 10000.0
        print("mac address  =    \(Utility.getMacAddress())")
        print("phone \(Utility().getPhone().count)")
        self.progressview.progress = 0
        self.progressview.isHidden = true
        compute()
//        DispatchQueue.main.async {
//            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.progress), userInfo: nil, repeats: true)
//        }
        
    }
    @objc func progress(){
        self.progressview.progress += 0.5
        if(self.progressview.progress == 1){
            timer.invalidate()
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.compute), userInfo: nil, repeats: false)
        }
    }
    
    @objc func compute(){
        if(Utility().getSignInStatus()){
            // navigateToHome()
            getMemberInfo()
        }else{
            DispatchQueue.main.async {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let otpController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController?.pushViewController(otpController, animated: true)
            }
        }
    }
    
    func navigateToHome(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        navigationController.setViewControllers([storyboard.instantiateViewController(withIdentifier: "TabbarMainController")], animated: false)
        
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        mainViewController.rootViewController = navigationController
        mainViewController.setup(type: UInt(2))
        
        let window = UIApplication.shared.delegate!.window!!
        window.rootViewController = mainViewController
        
        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }
    
    func getMemberInfo() {
        
        if NetworkReachability.isConnectedToNetwork()
        {
            DispatchQueue.main.async {
                Utility.showLoading()
            }
            

            let jsonObject: [String : Any] = [
                "data": [
                    "key" : Utility().getTokenUniqueDetail(),
                    "form": [
                        "devicetoken": Utility().getFCMDetail()
                    ]
                  
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
                    print("\(api)  \(dictonary)")
                    DispatchQueue.main.async {
                        Utility.hideLoading()
                    }
                    print("member response is in splash \(String(describing: response))")
                    DispatchQueue.main.async {
//                        appDelegate().showEmailAlert(message: "Sucess")
                        
                        let json = JSON(response ?? nil )
                        let arrayNames =  json["response"]
                        let  realm = try! Realm()
                        try! realm.write {
                            
//                            realm.delete(StudentDbInfo.init())
//                            realm.deleteAll()
                            let allNotifications = realm.objects(StudentDbInfo.self)
                            realm.delete(allNotifications)
//                            realm.delete(StudentDbInfo.self)
                        }
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
                            
//                             print("splash  \(user.memberClass) section \(user.memberSection) id \(user.memberUid)")
                             user.orgName = "\(val["orgName"])"
                            let p = val["orgLoc"]
                            if(p != nil || p != "null"){
                                user.orgloclatitude = Double("\(p["lattitude"])")!
                                user.orgloclangitude = Double("\(p["longitude"])")!
                                user.orglocAddress = "\(p["locationAddress"])"
                            }
                            print("org address \(user.orglocAddress) org lattitude \(user.orgloclatitude)")
                            let valueOf = val["memberInfo"]
                            let valuOfJson = JSON(valueOf)
                            for (_,valueOfNew) in valuOfJson{
                                //  print("pickup \(valueOfNew["pickuppointLocation"]) \(valueOfNew["routeType"])")
                                
                                let routetype = "\(valueOfNew["routeType"])"
                                 print("routetype   (\(routetype)")
                                if routetype == "pickup" {
                                    user.expectedTime =  "\(valueOfNew["expectedTime"])"
                                    user.pickuppointLocation = "\(valueOfNew["pickuppoint"])"
                                    user.pickupId = "\(valueOfNew["pickupId"])"
                                     user.routeId = "\(valueOfNew["routeId"])"
                                    user.pickupRadius = Int(Double("\(valueOfNew["pickupRadius"])")!)
                                    user.routeType = routetype
                                    let p = valueOfNew["pickuppointLocation"]
//                                    print("lat == \(p["lat"])")
                                    user.p_lat = Double("\(p["lat"])")!
                                    user.p_lng = Double("\(p["lng"])")!
                                }else{
                                    user.dropexpectedTime =  "\(valueOfNew["expectedTime"])"
                                    user.DroppointLocation = "\(valueOfNew["pickuppoint"])"
                                    user.pickupDropId = "\(valueOfNew["pickupId"])"
                                    user.dropRadius = Int(Double("\(valueOfNew["pickupRadius"])")!)
                                     user.routeId = "\(valueOfNew["routeId"])"
                                    let p = valueOfNew["pickuppointLocation"]
//                                    print("lat == \(p["lat"])")
                                    user.drop_lat = Double("\(p["lat"])")!
                                    user.drop_lng = Double("\(p["lng"])")!
                                }
                            }
                            try! realm.write {
                                realm.add(user)
                            }
                          
                        }
                    }
                     DispatchQueue.main.async {
                        self.navigateToHome()
                    }
//                    print("member info response \(String(describing: response)) ")
                }else{
                    DispatchQueue.main.async {
                        self.showPopup(msg: "Error ")
                    }
                }
            })
        }else{
            DispatchQueue.main.async {
                self.showPopup(msg: GlobalConstants.Errors.internetConnectionError)
            }
        }
    }
    func showPopup(msg:String)  {
        let alertController = UIAlertController(title: "Alert App", message: msg, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okButton)
        self.present(alertController, animated: true, completion: nil)
    }
}
