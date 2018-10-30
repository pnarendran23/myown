//
//  LoginViewController.swift
//  LGSideMenuControllerDemo
//
//  Created by Group10 on 29/01/18.
//  Copyright © 2018 Cole Dunsby. All rights reserved.
//

import Foundation
import RealmSwift
import Realm
import SwiftyJSON
import MessageUI



class LoginViewController: UIViewController,MFMailComposeViewControllerDelegate {
    
    @IBAction func sendMail(_ sender: Any) {
        let mailComposeViewController = self.configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    
    @IBOutlet var navbar: UINavigationBar!
    
    
    @IBOutlet var btnEmailUs: UIButton!
    @IBOutlet var btnLoginnew: UIButton!
    @IBOutlet var txtPhone: UITextField!
    
    @IBOutlet var lbError: UILabel!
    
    @IBAction func barFaqsAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let otpController = self.storyboard?.instantiateViewController(withIdentifier: "FAQsVC") as! FAQsVC
        self.navigationController?.pushViewController(otpController, animated: true)
        
    }
    
    
    @IBAction func btnAction(_ sender: Any) {
        
        print("login action")
        
        if(validations()){
            
            DispatchQueue.main.async {
                
                self.lbError.isHidden = true
                self.btnEmailUs.isHidden = true
                
                self.getOtp()
                
            }
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnLoginnew.backgroundColor = UIColor( red: 12/255, green: 133/255, blue: 145/255, alpha: 1)
        self.btnLoginnew.layer.cornerRadius = 14
        lbError.isHidden = true
        btnEmailUs.isHidden = true
        
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x:0, y: 0,  width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        
        let done : UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "setting5-2x"), style: .done, target: self, action: #selector(barFaqsAction(_:)))
        self.navigationItem.rightBarButtonItem = done
        toolbar.setItems([flexSpace, done], animated: false)
        toolbar.sizeToFit()
//        let doneTextField : UIBarButtonItem = UIBarButtonItem.init(image:nil, style: .done, target: self, action: #selector(doneButtonAction(_:)))
        let toolbar2 : UIToolbar = UIToolbar(frame: CGRect(x:0, y: 0,  width: self.view.frame.size.width, height: 30))
        let doneAction : UIBarButtonItem =  UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        self.navigationItem.leftBarButtonItem = doneAction
        toolbar2.setItems([flexSpace, doneAction], animated: false)
        toolbar.sizeToFit()
        toolbar2.sizeToFit()
        //setting toolbar as inputAccessoryView
        self.txtPhone.inputAccessoryView = toolbar2
        
        
        hideKeyboardWhenTappedAround()
        
    }
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    func getOtp() {
        
        if NetworkReachability.isConnectedToNetwork()
        {
            Utility.showLoading()
            let valueTxtPhone = self.txtPhone.text!
            let jsonObject: [String : [String : [String:Any]]] = [
                "data":[
                    "form": [
                        "mobileno": valueTxtPhone,
                        "macid": Utility.getMacAddress(),
                        "appversion": Utility.getAppVersion(),
                        "versionnum": Utility.getModel(),
                        "devicetoken": Utility().getFCMDetail(),
                        "ostype":"iOS"
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
            let api = GlobalConstants.API.baseUrl + GlobalConstants.API.appLogin
            
            APIHandler().loginApiDetails(parameters: dictonary, api: api, requestType: requestType, completionHandler: { (sucess,response, error) in
              
                
                if sucess {
                    DispatchQueue.main.async {
                        Utility.hideLoading()
                    }
                    if(response != nil){
                    let status = response!["status"] as! String
//                    print("login response is \(response!) ")
                    if(status == "failure"){
                        
                        let message = response!["message"] as! String
                        
                        DispatchQueue.main.async {
                            if(message == "You are exceed the maximum limit of OTP"){
                                self.lbError.text = message
                                self.lbError.isHidden = false
                                self.btnEmailUs.isHidden = false
                                Utility().savePhoneNumberAndotpToken(mob: valueTxtPhone,optValue: "")
                            }else{
                                self.lbError.text = message
                                self.lbError.isHidden = false
                            }
                            
                        }
                        
                    }else{
                        
                        DispatchQueue.main.async {
                            print("login sucess response \(response!["otptoken"] as! String) \(response!["status"] as! String) ")
                            
                            Utility().savePhoneNumberAndotpToken(mob:valueTxtPhone,optValue: response!["otptoken"] as! String)
                            
//                            print("otp token is == \(Utility().getOtpToken())")
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let otpController = storyboard.instantiateViewController(withIdentifier: "OtpController") as! OtpController
                            self.navigationController?.pushViewController(otpController, animated: true)
                        }
                    }
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
                //            appDelegate().showEmailAlert(message: GlobalConstants.Errors.internetConnectionError)
            }
        }
        
    }
    func getMemberInfo() {
        
        
        if appDelegate().isInternetAvailable()
        {
            Utility.showLoading()
            
            self.view.isUserInteractionEnabled = false
            
            var temp = [String: Any]()
            var data = [String : Any]()
            temp["key"] = Utility().getTokenUniqueDetail()
            data["data"] = temp
            print("Dcit is ", temp)
            
            var convertString:String?=nil
            if let dataString  = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted),
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
                Utility.hideLoading()
                
                if sucess {
                    
                    DispatchQueue.main.async {
                        self.view.isUserInteractionEnabled = true
                        //                        appDelegate().showEmailAlert(message: "Sucess")
                        //                        let  realm = try! Realm()
                        //                        try! realm.write {
                        //                            realm.deleteAll()
                        //                        }
                        let json = JSON(response ?? nil )
                        let arrayNames =  json["response"]
                        for (_,val) in arrayNames {
                            
                            print("items == \(val["memberUID"])")
                            let valueOf = val["memberInfo"]
                            let valuOfJson = JSON(valueOf)
                            for (_,valueOfNew) in valuOfJson{
                                //                                print("pickup \(valueOfNew["pickuppointLocation"]) \(valueOfNew["routeType"])")
                                let p = valueOfNew["pickuppointLocation"]
                                print("lat == \(p["lat"])")
                                
                            }
                            //                            print("loc val \(valuOfJson)")
                        }
                        
                    }
                }else{
                    DispatchQueue.main.async {
                        self.view.isUserInteractionEnabled = true
                        appDelegate().showEmailAlert(message: "Error ")
                    }
                }
            })
        }else{
            showPopup(msg: GlobalConstants.Errors.internetConnectionError)
            //            appDelegate().showEmailAlert(message: GlobalConstants.Errors.internetConnectionError)
        }
        
    }
    func validations() -> Bool {
        
        if ((txtPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines).count)! <= 0) {
            DispatchQueue.main.async {
                //            appDelegate().showEmailAlert(message: "Please enter mobile number")
                self.showPopup(msg: "Please enter mobile number")
            }
            print("phone num empty")
            return false
        }
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Login"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.topItem?.title = "Login"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.topItem?.title = "Login"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.topItem?.title = "Login"
        self.navigationController?.navigationBar.topItem?.hidesBackButton = true
        self.navigationItem.hidesBackButton = true
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.leftBarButtonItem = nil
        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationController?.navigationBar.backgroundColor = UIColor( red: 12/255, green: 133/255, blue: 145/255, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = UIColor( red: 12/255, green: 133/255, blue: 145/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 65)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
    }
    //    @IBAction func sendEmailButtonTapped(sender: AnyObject) {
    //        let mailComposeViewController = configuredMailComposeViewController()
    //        if MFMailComposeViewController.canSendMail() {
    //            self.present(mailComposeViewController, animated: true, completion: nil)
    //        } else {
    //            self.showSendMailErrorAlert()
    //        }
    //    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        //"mobileno": valueTxtPhone,
        //        "macid": Utility.getMacAddress(),
        //        "appversion": Utility.getAppVersion(),
        //        "versionnum": Utility.getModel(),
        //        "devicetoken": Utility().getFCMDetail(),
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["school@groupten.com"])
        mailComposerVC.setSubject("AlertApp")
        mailComposerVC.setMessageBody("Dear Group10,          \n 1.Phone : \(Utility().getPhone()) \n 2.Macid : \(Utility.getMacAddress()) \n 3.AppVersion : \(Utility.getAppVersion()) \n 4.OsType : \(Utility.getModel())", isHTML: false)
        
        return mailComposerVC
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func showPopup(msg:String)  {
        let alertController = UIAlertController(title: "Alert App", message: msg, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okButton)
        self.present(alertController, animated: true, completion: nil)
    }
}
