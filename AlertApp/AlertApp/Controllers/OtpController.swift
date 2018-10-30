//
//  OtpController.swift
//  LGSideMenuControllerDemo
//
//  Created by Group10 on 29/01/18.
//  Copyright © 2018 Cole Dunsby. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class OtpController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet var lblWait: UILabel!
    
    @IBOutlet var btnResend: UIButton!
    
    
    
    @IBAction func btnResendAction(_ sender: Any) {
        resendOtp()
        
        
    }
    
    
    @IBOutlet var lblVerificationNumber: UILabel!
    @IBOutlet var txtOtp: UITextField!
    @IBOutlet var btnSubmit: UIButton!
    
    var smsWaitSecs = 120
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("otp controller")
        self.navigationController?.navigationBar.topItem?.title = "Otp"
        
        self.lblVerificationNumber.isHidden = false
        self.lblWait.isHidden = false
        self.btnResend.isHidden = true
        self.btnSubmit.backgroundColor = UIColor( red: 12/255, green: 133/255, blue: 145/255, alpha: 1)
        self.btnSubmit.layer.cornerRadius = 14
        
        self.txtOtp.resignFirstResponder()
        lblVerificationNumber.text = "Verification code has sent to \(Utility().getPhone()) "
//        let realm = try! Realm()
//        var lists : Results<StudentDbInfo>!
//        lists = realm.objects(StudentDbInfo.self)
//        for item in lists {
//            print("name is == \(item.memberName)")
//        }
//        DispatchQueue.main.async {
//            appDelegate().showRetryAlert()
//        }
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        hideKeyboardWhenTappedAround()
        
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func update()
    {
                if(smsWaitSecs == 0)
                {
                    timer.invalidate()
                   self.btnResend.isHidden = false
                    
                    self.lblWait.isHidden = true
                    
                    let underlineAttribute = [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue]
                    let underlineAttributedString = NSAttributedString(string: "RESEND OTP", attributes: underlineAttribute)
                    self.btnResend.setAttributedTitle(underlineAttributedString, for: .normal)
                }
                else
                {
                    smsWaitSecs = smsWaitSecs-1
                    self.lblWait.text = "\(smsWaitSecs) seconds"
                }
    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.topItem?.title = "Otp"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = "Otp"
        self.navigationController?.navigationBar.backgroundColor = UIColor( red: 12/255, green: 133/255, blue: 145/255, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = UIColor( red: 12/255, green: 133/255, blue: 145/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        //        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
    }
    
    
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        
        if validations() {
            getOtpValidations()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    func resendOtp() {
        
        if NetworkReachability.isConnectedToNetwork()
        {
            DispatchQueue.main.async {
                 Utility.showLoading()
            }
            let jsonObject: [String : Any] = [
                "data":[
                    "form": [
                        "otptoken": Utility.shared.getOtpToken()
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
            let api = GlobalConstants.API.baseUrl + GlobalConstants.API.resendOtp
            
            APIHandler().loginApiDetails(parameters: dictonary, api: api, requestType: requestType, completionHandler: { (sucess,response, error) in
                  DispatchQueue.main.async {
              
                if sucess {
                    DispatchQueue.main.async {
                          Utility.hideLoading()
                    }
                    if(response != nil){
                    print("response \(String(describing: response))")
                    
                    let status = response!["status"] as! String
                    if(status == "failure"){
                      
                        //message = "No OTP found"
                        DispatchQueue.main.async {
                            self.showPopup(msg: response!["message"] as! String)
                        }
                    }else{
                        
                        DispatchQueue.main.async {
                            self.smsWaitSecs = 120
                            self.btnResend.isHidden = true
                            self.lblWait.isHidden = false
                            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
                           
                        }
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        self.showPopup(msg: "Error ")
                    }
                }
                }
                }
            })
        }else{
            self.showPopup(msg: GlobalConstants.Errors.internetConnectionError)
        }
        
    }
    func getOtpValidations() {
        
        if NetworkReachability.isConnectedToNetwork()
        {
            DispatchQueue.main.async {
                Utility.showLoading()
            }
            
            
            let jsonObject: [String : Any] = [
                "data":[
                    "form": [
                        "otptoken": Utility.shared.getOtpToken(),
                        "otp": txtOtp.text ?? ""
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
            let api = GlobalConstants.API.baseUrl + GlobalConstants.API.otpVerification
            
            APIHandler().loginApiDetails(parameters: dictonary, api: api, requestType: requestType, completionHandler: { (sucess,response, error) in
                DispatchQueue.main.async {
                     Utility.hideLoading()
                }
               
                if sucess {
                    
                    print("response \(String(describing: response))")
                    
                    let status = response!["status"] as! String
                    if(status == "failure"){
                        DispatchQueue.main.async {
                            self.showPopup(msg: response!["message"] as! String)
                        }
                    }else{
                        DispatchQueue.main.async {
                            Utility().saveUniqueToken(token: response!["token"] as! String)
                            self.getMemberInfo()
                            print("unique token \(Utility().getTokenUniqueDetail())")
                        }
                    }
                    
                }else{
                    DispatchQueue.main.async {
                       self.showPopup(msg: "Error ")
                    }
                }
            })
        }else{
            self.showPopup(msg: GlobalConstants.Errors.internetConnectionError)
        }
        
    }
    func getMemberInfo() {
        
        if NetworkReachability.isConnectedToNetwork()
        {
            DispatchQueue.main.async {
                 Utility.showLoading()
            }
           
            
            let jsonObject: [String : Any] = [
                "data":[
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
                    DispatchQueue.main.async {
                        Utility.hideLoading()
                    }
                    if(response != nil){
                    print("response is \(String(describing: response))")
                    DispatchQueue.main.async {
                      
                        let json = JSON(response ?? nil )
                        let arrayNames =  json["response"]
                        let  realm = try! Realm()
                        try! realm.write {
                            realm.deleteAll()
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
                            user.orgName = "\(val["orgName"])"
                            
                            print("splash  \(user.memberClass) section \(user.memberSection) id \(user.memberUid)")
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
                                    user.pickupRadius = Int(Double("\(valueOfNew["pickupRadius"])")!)
                                    user.routeId = "\(valueOfNew["routeId"])"
                                    user.routeType = routetype
                                    let p = valueOfNew["pickuppointLocation"]
                                    print("lat == \(p["lat"])")
                                    user.p_lat = Double("\(p["lat"])")!
                                    user.p_lng = Double("\(p["lng"])")!
                                }else{
                                    user.dropexpectedTime =  "\(valueOfNew["expectedTime"])"
                                    user.DroppointLocation = "\(valueOfNew["pickuppoint"])"
                                    user.pickupDropId = "\(valueOfNew["pickupId"])"
                                    user.routeId = "\(valueOfNew["routeId"])"
                                    user.dropRadius = Int(Double("\(valueOfNew["pickupRadius"])")!)
                                    
                                    let p = valueOfNew["pickuppointLocation"]
                                    print("lat == \(p["lat"])")
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
                }
            })
        }else{
            DispatchQueue.main.async {
                 self.showPopup(msg: GlobalConstants.Errors.internetConnectionError)
            }
        }
    }
    
    func validations() -> Bool {
        
        if ((txtOtp.text?.trimmingCharacters(in: .whitespacesAndNewlines).count)! <= 0) {
            self.showPopup(msg: "Please enter otp")
            return false
        }
        return true
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
    
    func showPopup(msg:String)  {
        let alertController = UIAlertController(title: "Alert App", message: msg, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okButton)
        self.present(alertController, animated: true, completion: nil)
    }
}
