//
//  LoginViewController.swift
//  Placer
//
//  Created by Vishal on 10/08/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase
import FirebaseInstanceID
import TTGSnackbar

class LoginViewController: UIViewController {
    
    var inputContainerView:UIView!
    var orgNameSepView:UIView!
    var userNameSepView:UIView!
    var signInLabel: UILabel!
    var logoIV:UIImageView!
    var signInButton:UIButton!
    var orgNameTextField:UITextField!
    var userNameTextField:UITextField!
    var passwordTextField:UITextField!
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViews()
//        let token = FIRInstanceID.instanceID().token()
//        print("InstanceID token: \(token!)")
    }
    
    func initViews(){
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        let height = bounds.size.height
        print("Screen Width bound: \(width)")
        print("Screen Height bound: \(height)")
        
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.hexStringToUIColor("#323754")
        
        self.inputContainerView = UIView()
        self.inputContainerView.frame = CGRect(x: 0, y: 0, width: 260, height: 130)
        self.inputContainerView.backgroundColor = UIColor.hexStringToUIColor("#323754")
        self.inputContainerView.layer.cornerRadius = 10
        self.inputContainerView.layer.borderWidth = 1
        self.inputContainerView.layer.borderColor = UIColor.hexStringToUIColor("#8C93BA").cgColor
        self.inputContainerView.center = self.view.center
        
        self.orgNameTextField = UITextField()
        self.orgNameTextField.frame = CGRect(x: 0, y: 0, width: inputContainerView.frame.width, height: 40)
        let orgImage = UIImageView(image: UIImage(named: "org"))
        orgImage.contentMode = UIViewContentMode.center
        orgImage.frame = CGRect(x: 0.0, y: 0.0, width: orgImage.image!.size.width + 15.0, height: orgImage.image!.size.height)
        self.orgNameTextField.leftViewMode = UITextFieldViewMode.always
        self.orgNameTextField.leftView = orgImage
        self.orgNameTextField.textColor = UIColor.white
        self.orgNameTextField.attributedPlaceholder = NSAttributedString(string:" Org Name",
                                                                attributes:[NSForegroundColorAttributeName: UIColor.hexStringToUIColor("#8C93BA")])
        self.orgNameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.inputContainerView.addSubview(self.orgNameTextField)
        
        self.orgNameSepView = UIView()
        self.orgNameSepView.frame = CGRect(x: 0, y: self.orgNameTextField.frame.origin.y+self.orgNameTextField.frame.height+1, width: inputContainerView.frame.width, height: 1)
        self.orgNameSepView.backgroundColor = UIColor.hexStringToUIColor("#8C93BA")
        self.orgNameSepView.translatesAutoresizingMaskIntoConstraints = false
        self.inputContainerView.addSubview(self.orgNameSepView)
        
        self.userNameTextField = UITextField()
        self.userNameTextField.frame = CGRect(x: 0, y: self.orgNameSepView.frame.origin.y+self.orgNameSepView.frame.height+1, width: self.inputContainerView.frame.width, height: 40)
        let userImage = UIImageView(image: UIImage(named: "user"))
        userImage.contentMode = UIViewContentMode.center
        userImage.frame = CGRect(x: 0.0, y: 0.0, width: userImage.image!.size.width + 15.0, height: userImage.image!.size.height)
        self.userNameTextField.leftViewMode = UITextFieldViewMode.always
        self.userNameTextField.leftView = userImage
        self.userNameTextField.textColor = UIColor.white
        self.userNameTextField.attributedPlaceholder = NSAttributedString(string:" User Name",
                                                                         attributes:[NSForegroundColorAttributeName: UIColor.hexStringToUIColor("#8C93BA")])

        self.userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.inputContainerView.addSubview(self.userNameTextField)
    

        self.userNameSepView = UIView()
        self.userNameSepView.frame = CGRect(x: 0, y: self.userNameTextField.frame.origin.y+self.userNameTextField.frame.height+1, width: inputContainerView.frame.width, height: 1)
        self.userNameSepView.backgroundColor = UIColor.hexStringToUIColor("#8C93BA")
        self.inputContainerView.addSubview(self.userNameSepView)
        
        self.passwordTextField = UITextField()
        self.passwordTextField.frame = CGRect(x: 0, y: self.userNameSepView.frame.origin.y+self.userNameSepView.frame.height+1, width: self.inputContainerView.frame.width, height: 40)
        let passImage = UIImageView(image: UIImage(named: "password"))
        passImage.contentMode = UIViewContentMode.center
        passImage.frame = CGRect(x: 0.0, y: 0.0, width: passImage.image!.size.width + 15.0, height: passImage.image!.size.height)
        self.passwordTextField.leftViewMode = UITextFieldViewMode.always
        self.passwordTextField.leftView = passImage
        self.passwordTextField.textColor = UIColor.white
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string:" Password",
                                                                          attributes:[NSForegroundColorAttributeName: UIColor.hexStringToUIColor("#8C93BA")])
        
        self.passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.inputContainerView.addSubview(self.passwordTextField)
        self.passwordTextField.isSecureTextEntry = true
        UITextField.connectFields([orgNameTextField, userNameTextField, passwordTextField])
        self.view.addSubview(self.inputContainerView)
        
        self.signInButton = UIButton()
        self.signInButton.frame = CGRect(x: 0, y: 0, width: 230, height: 50)
        self.signInButton.setTitle("Sign In", for: UIControlState())
        self.signInButton.setTitleColor(UIColor.hexStringToUIColor("#323754"), for: UIControlState())
        self.signInButton.layer.cornerRadius = 25
        self.signInButton.layer.borderWidth = 1
        self.signInButton.backgroundColor = UIColor.hexStringToUIColor("#8C93BA")
        self.signInButton.layer.borderColor = UIColor.hexStringToUIColor("#8C93BA").cgColor
        self.signInButton.center = CGPoint(x: self.view.center.x, y: self.view.center.y+self.inputContainerView.frame.height-10)
        self.signInButton.addTarget(self, action: #selector(LoginViewController.doLogin(_:)), for: .touchUpInside)
        self.view.addSubview(self.signInButton)
        
        self.signInLabel = UILabel()
        self.signInLabel.text = "Sign in to your Placer account"
        self.signInLabel.frame = CGRect(x: 0, y: CGFloat(inputContainerView.frame.origin.y-60), width: width, height: 40)
        self.signInLabel.font = UIFont(name: "Roboto-Light", size: 14.0)
        self.signInLabel.font = self.signInLabel.font.withSize(14.0)
        self.signInLabel.textColor = UIColor.white
        self.signInLabel.textAlignment = .center
        self.view.addSubview(self.signInLabel)
        
        self.logoIV = UIImageView()
        let image = UIImage(named: "logo")!.withRenderingMode(.alwaysTemplate)
        self.logoIV.image = image
        self.logoIV.tintColor = UIColor.white
        self.logoIV.frame = CGRect(x: CGFloat((width/2)-40), y: CGFloat(signInLabel.frame.origin.y-80), width: 80, height: 80)
        self.logoIV.contentMode = .scaleAspectFit
        self.view.addSubview(self.logoIV)
        
        self.orgNameTextField.text = getOrgDetail()
        self.userNameTextField.text = getUserDetail()
        self.passwordTextField.text = getPasswordDetail()
        
    }
    
    func doLogin(_ sender: AnyObject?){
        let org:String = self.orgNameTextField.text!
        let user:String = self.userNameTextField.text!
        let password:String = self.passwordTextField.text!
        if(!(self.orgNameTextField.text?.isEmpty)! || !(self.userNameTextField.text?.isEmpty)! || !(self.passwordTextField.text?.isEmpty)!){
             if(NetworkReachability.isConnectedToNetwork()){
              self.authenticateUser(org, user: user, password: password)
             }else{
                let snackbar = TTGSnackbar.init(message: "No Internet Connectivity!", duration: .short)
                snackbar.show()
            }
        }else{
            print("All fields are mandatory!")
        }
    }
    
    //to authenticate user
    func authenticateUser(_ org:String, user:String, password:String){
        print("inside authenticate user")
        self.showLoading()
        let loginParams = ["org": org, "username": user, "password": password]
        Alamofire.request(Api.baseUrl + Api.authenticate, method: .post, parameters: loginParams)
            .validate()
            .responseJSON { response in
                //print(response.request)  // original URL request
                //print(response.response) // URL response
                //print(response.data)     // server data
                //print(response.result)   // result of response serialization
                switch response.result {
                case .success( _):
                    self.hideLoading()
                    if let jsonString = response.result.value {
                        self.saveToken(JSON(jsonString)["token"].stringValue)
                        self.saveLoginDetails(org, userId: user, password: password)
                        self.getLoggedMemberInfo()
                    }
                case .failure(let error):
                    self.hideLoading()
                    print("message: Error 4xx / 5xx: \(error)")
                }
        }
    }
    
    //to save token detail
    func saveToken(_ token: String) {
        let preferences = UserDefaults.standard
        
        let tokenKey = "token"
        
        preferences.setValue(token, forKey: tokenKey)
        
        //  Save to disk
        let didSave = preferences.synchronize()
        
        if !didSave {
            print("Unable to save token!")
        }
    }
    
    //to get logged member info
    func getLoggedMemberInfo(){
        print("inside getLoggedMemberInfo")
        let headers = [
            "Authorization": "Basic "+getTokenDetail(),
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        Alamofire.request(Api.baseUrl + Api.loggedMemberInfo, method: .get, headers: headers)
            .validate()
            .responseJSON { response in
//                print(response.request)  // original URL request
                print("login response:\(String(describing: response.response))") // URL response
//                print(response.data)     // server data
//                print(response.result)   // result of response serialization
                switch response.result {
                case .success( _):
                    if let jsonString = response.result.value {
                        //print("JSON: \(jsonString)")
                        let jsonObj = JSON(jsonString)
                        let orgId = jsonObj["orgId"]
                        let memberId = jsonObj["memberId"]
                        let orgName = jsonObj["orgName"]
                        let accessGroupFlag = jsonObj["accessGroupFlag"]
                        let name = jsonObj["name"]
                        print("OrgId: \(orgId), MemberId: \(memberId), OrgName: \(orgName), AccessGroupFlag: \(name)")
                        self.saveMemberDetails(orgId.stringValue, memberId: memberId.stringValue, orgName: orgName.stringValue, accessGroupFlag: accessGroupFlag.stringValue,name: name.string!)
                        self.registerFcm()
                        
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                }
                
        }
    }

    
    //to register FCM token
    func registerFcm(){
        print("inside getLoggedMemberInfo")
        let headers = [
            "Authorization": "Basic "+getTokenDetail(),
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let parameters: [String: AnyObject] = [
            "deviceId" : UIDevice.current.identifierForVendor!.uuidString as AnyObject,
            "deviceName" : UIDevice.current.name as AnyObject,
            "gcmId" : self.getFcmTokenDetail() as AnyObject,
            "memberId" : self.getMemberIdDetail() as AnyObject,
            "appName": "PLACER" as AnyObject
        ]
        
        print(parameters)
        
        Alamofire.request(Api.baseUrl + Api.registerFcm, method: .post, parameters: parameters,   encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                //print(response.request)  // original URL request
                //print(response.response) // URL response
                //print(response.data)     // server data
                //print(response.result)   // result of response serialization
                switch response.result {
                case .success( _):
                    if let jsonString = response.result.value {
                        print("JSON: \(jsonString)")
                        self.navigateToDashBoardView()
                    }
                case .failure(let error):
                    print("message: Error 4xx / 5xx: \(error)")
                }
                
        }
    }
    
    //to navigate loginviewcontroller
    func navigateToDashBoardView(){
        print("inside navTodashboard")
        self.navigationController?.present(UINavigationController(rootViewController: DashboardViewController()), animated: true, completion: nil)
    }
    
    
    
    //to get token detail
    func getTokenDetail() -> String{
        let preferences = UserDefaults.standard
        var token:String = ""
        let tokenKey = "token"
        if preferences.object(forKey: tokenKey) == nil {
            //  Doesn't exist
        } else {
            token = preferences.value(forKey: tokenKey) as! String
            print(token)
        }
        return token
    }
    
    //to get fcm token detail
    func getFcmTokenDetail() -> String{
        let preferences = UserDefaults.standard
        var token:String = ""
        let fcmKey = "fcm"
        if preferences.object(forKey: fcmKey) == nil {
            //  Doesn't exist
        } else {
            token = preferences.value(forKey: fcmKey) as! String
            print(token)
        }
        return token
    }
    
    //to get fcm token detail
    func getMemberIdDetail() -> String{
        let preferences = UserDefaults.standard
        var memberId:String = ""
        let memberIdKey = "memberId"
        if preferences.object(forKey: memberIdKey) == nil {
            //  Doesn't exist
        } else {
            memberId = preferences.value(forKey: memberIdKey) as! String
            print(memberId)
        }
        return memberId
    }
    
    //to get org detail
    func getOrgDetail() -> String{
        let preferences = UserDefaults.standard
        var org:String = ""
        let orgKey = "org"
        if preferences.object(forKey: orgKey) == nil {
            //  Doesn't exist
        } else {
            org = preferences.value(forKey: orgKey) as! String
        }
        return org
    }
    func getOrgNameDetail() -> String{
        let preferences = UserDefaults.standard
        var org:String = ""
        let orgKey = "orgName"
        if preferences.object(forKey: orgKey) == nil {
            //  Doesn't exist
        } else {
            org = preferences.value(forKey: orgKey) as! String
        }
        return org
    }
    //to get user detail
    func getUserDetail() -> String{
        let preferences = UserDefaults.standard
        var user:String = ""
        let userKey = "user"
        if preferences.object(forKey: userKey) == nil {
            //  Doesn't exist
        } else {
            user = preferences.value(forKey: userKey) as! String
        }
        return user
    }
    //to get user detail
    func getName() -> String{
        let preferences = UserDefaults.standard
        var user:String = ""
        let userKey = "name"
        if preferences.object(forKey: userKey) == nil {
            //  Doesn't exist
        } else {
            user = preferences.value(forKey: userKey) as! String
        }
        return user
    }
    //to get user detail
    func getPasswordDetail() -> String{
        let preferences = UserDefaults.standard
        var pass:String = ""
        let passKey = "pass"
        if preferences.object(forKey: passKey) == nil {
            //  Doesn't exist
        } else {
            pass = preferences.value(forKey: passKey) as! String
        }
        return pass
    }
    
    //to save member details
    func saveMemberDetails(_ orgId:String, memberId:String, orgName:String, accessGroupFlag:String,name:String){
        let preferences = UserDefaults.standard
        
        let orgIdKey = "orgId"
        let memberIdKey = "memberId"
        let orgNameKey = "orgName"
        let accessGroupFlagKey = "accessGroupFlag"
        let name = "name"
        print("org name is \(name)")
        preferences.setValue(orgId, forKey: orgIdKey)
        preferences.setValue(memberId, forKey: memberIdKey)
        preferences.setValue(orgName, forKey: orgNameKey)
        preferences.setValue(accessGroupFlag, forKey: accessGroupFlagKey)
        preferences.setValue(name, forKey: name)
        
        //  Save to disk
        let didSave = preferences.synchronize()
        
        if !didSave {
            print("Unable to save member details!")
        }
    }
    
    //to save login details
    func saveLoginDetails(_ orgId:String, userId:String, password:String){
        let preferences = UserDefaults.standard
        
        let loginOrgKey = "org"
        let loginUserKey = "user"
        let loginPassKey = "pass"
        
        preferences.setValue(orgId, forKey:loginOrgKey)
        preferences.setValue(userId, forKey: loginUserKey)
        preferences.setValue(password, forKey: loginPassKey)
        
        //  Save to disk
        let didSave = preferences.synchronize()
        
        if !didSave {
            print("Unable to save login details!")
        }
    }
    
    //to show loading
    func showLoading(){
        self.activityView.center = self.view.center
        self.activityView.startAnimating()
        self.view.addSubview(activityView)
    }
    
    //to hide loading
    func hideLoading(){
        self.activityView.stopAnimating()
        self.view.willRemoveSubview(activityView)
    }
    
    //for light statusbar
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}
