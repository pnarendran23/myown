//
//  USGBCHelper.swift
//  USGBC
//
//  Created by Group10 on 10/05/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import SVProgressHUD
import UserNotifications

class Utility{
    
    static let shared = Utility()
    
    //to save token detail
    func saveUniqueToken(token: String) {
        print("SaveToken: \(token)")
        let preferences = UserDefaults.standard
        
        let tokenKey = "token"
        
        preferences.setValue(token, forKey: tokenKey)
        
        //  Save to disk
        let didSave = preferences.synchronize()
        
        if !didSave {
            print("Unable to save token!")
        }
    }
    //to get token detail
    func getTokenUniqueDetail() -> String{
        let preferences = UserDefaults.standard
        var token:String = ""
        let tokenKey = "token"
        if preferences.object(forKey: tokenKey) == nil {
            //  Doesn't exist
        } else {
            token = preferences.value(forKey: tokenKey) as! String
            //print("GetToken: \(token)")
        }
        return token
    }
    
    
    func savePhoneNumberAndotpToken(mob:String,optValue:String) {
        let preferences = UserDefaults.standard
        let mobKey = "mob"
        let otp = "otpToken"
        preferences.setValue(mob, forKey: mobKey)
        preferences.setValue(optValue, forKey:otp)
        preferences.synchronize()
    }
    func getOtpToken() -> String {
        let preferences = UserDefaults.standard
        var otpToken:String = ""
        let mobKey = "otpToken"
        if preferences.object(forKey: mobKey) == nil {
            //  Doesn't exist
        } else {
            otpToken = preferences.value(forKey: mobKey) as! String
            print(otpToken)
        }
        return otpToken
    }
    func getPhone() -> String {
        let preferences = UserDefaults.standard
        var mob:String = ""
        let mobKey = "mob"
        if preferences.object(forKey: mobKey) == nil {
            //  Doesn't exist
        } else {
            mob = preferences.value(forKey: mobKey) as! String
            print(mob)
        }
        return mob
    }
    
    func getSignInStatus() -> Bool {
        let preferences = UserDefaults.standard
        var status:Bool = false
        let mobKey = "signinstatus"
        if preferences.object(forKey: mobKey) == nil {
            //  Doesn't exist
        } else {
            status = preferences.value(forKey: mobKey) as! Bool
            print("status of singin is  \(status)")
        }
        return status
    }
    //to save token detail
    func setSignInStatus(status: Bool) {
//        print("Savecount: \(fcm)")
        let preferences = UserDefaults.standard
        let signInStatus = "signinstatus"
        preferences.setValue(status, forKey: signInStatus)
        //  Save to disk
        let didSave = preferences.synchronize()
        
        if !didSave {
            print("Unable to save status!")
        }
    }
    //to save login details
    func saveLoginDetails(user:String, password:String){
        let preferences = UserDefaults.standard
        
        let userKey = "user"
        let passwordKey = "password"
        
        preferences.setValue(user, forKey: userKey)
        preferences.setValue(password, forKey: passwordKey)
        
        //  Save to disk
        let didSave = preferences.synchronize()
        
        if !didSave {
            print("Unable to save member details!")
        }
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
            print(user)
        }
        return user
    }
    
    //to get user detail
    func getFCMDetail() -> String{
        let preferences = UserDefaults.standard
        var fcm:String = ""
        let fcmKey = "fcm"
        if preferences.object(forKey: fcmKey) == nil {
            //  Doesn't exist
        } else {
            fcm = preferences.value(forKey: fcmKey) as! String
            print(fcm)
        }
        return fcm
    }
    
    //to save token detail
    func saveFCMDetails(fcm: String) {
        print("SaveFCM: \(fcm)")
        let preferences = UserDefaults.standard
        let fcmKey = "fcm"
        preferences.setValue(fcm, forKey: fcmKey)
        
        //  Save to disk
        let didSave = preferences.synchronize()
        
        if !didSave {
            print("Unable to save fcm!")
        }
    }
    
    func getAlertsFCMCount() -> Int{
        let preferences = UserDefaults.standard
        var fcm:Int = 0
        let fcmKey = "fcmcount"
        if preferences.object(forKey: fcmKey) == nil {
            //  Doesn't exist
        } else {
            fcm = preferences.value(forKey: fcmKey) as! Int
            print(fcm)
        }
        return fcm
    }
    func getMsgFCMCount() -> Int{
        let preferences = UserDefaults.standard
        var fcm:Int = 0
        let fcmKey = "msgfcmcount"
        if preferences.object(forKey: fcmKey) == nil {
            //  Doesn't exist
        } else {
            fcm = preferences.value(forKey: fcmKey) as! Int
            print(fcm)
        }
        return fcm
    }
    
    //to save token detail
    func saveAlertsFCMCount(fcm: Int) {
        print("Savecount: \(fcm)")
        let preferences = UserDefaults.standard
        let fcmKey = "fcmcount"
        preferences.setValue(fcm, forKey: fcmKey)
        //  Save to disk
        let didSave = preferences.synchronize()
        
        if !didSave {
            print("Unable to save fcmcount!")
        }
    }
    
    func saveMsgFCMCount(fcm: Int) {
        print("msgfcmcount: \(fcm)")
        let preferences = UserDefaults.standard
        let fcmKey = "msgfcmcount"
        preferences.setValue(fcm, forKey: fcmKey)
        
        //  Save to disk
        let didSave = preferences.synchronize()
        
        if !didSave {
            print("Unable to save fcmcount!")
        }
    }
    func saveFCMType(fcm: String) {
//        print("msgfcmcount: \(fcm)")
        let preferences = UserDefaults.standard
        let fcmKey = "fcmtype"
        preferences.setValue(fcm, forKey: fcmKey)
        
        //  Save to disk
        let didSave = preferences.synchronize()
        
        if !didSave {
            print("Unable to save fcm type!")
        }
    }
    func getFCMType() -> String{
        let preferences = UserDefaults.standard
        var fcm:String = ""
        let fcmKey = "fcmtype"
        if preferences.object(forKey: fcmKey) == nil {
            //  Doesn't exist
        } else {
            fcm = preferences.value(forKey: fcmKey) as! String
            print(fcm)
        }
        return fcm
    }
    //to get user detail
    func getNotifcationStatus() -> String{
        let preferences = UserDefaults.standard
        var status:String = ""
        let statusKey = "notification"
        if preferences.object(forKey: statusKey) == nil {
            //  Doesn't exist
        } else {
            status = preferences.value(forKey: statusKey) as! String
            print(status)
        }
        return status
    }
    
    //to save token detail
    func saveNotifcationStatus(status: String) {
        print("SaveNotification Status: \(status)")
        let preferences = UserDefaults.standard
        let statusKey = "notification"
        preferences.setValue(status, forKey: statusKey)
        
        //  Save to disk
        let didSave = preferences.synchronize()
        
        if !didSave {
            print("Unable to save notification status!")
        }
    }
    
    //to get user detail
    func getAppID() -> String{
        let preferences = UserDefaults.standard
        var appId:String = ""
        let appIdKey = "app_id"
        if preferences.object(forKey: appIdKey) == nil {
            //  Doesn't exist
        } else {
            appId = preferences.value(forKey: appIdKey) as! String
            print(appId)
        }
        return appId
    }
    
    //to save token detail
    func saveAppID(appId: String) {
        print("App Id: \(appId)")
        let preferences = UserDefaults.standard
        let appIdKey = "app_id"
        preferences.setValue(appId, forKey: appIdKey)
        
        //  Save to disk
        let didSave = preferences.synchronize()
        
        if !didSave {
            print("Unable to save app id!")
        }
    }
    
    //to get password detail
    func getPasswordDetail() -> String{
        let preferences = UserDefaults.standard
        var password:String = ""
        let passwordKey = "password"
        if preferences.object(forKey: passwordKey) == nil {
            //  Doesn't exist
        } else {
            password = preferences.value(forKey: passwordKey) as! String
            print(password)
        }
        return password
    }
    
    
    
    //Helper function to convert date format
    static func stringToDate(dateString: String) -> String{
        var datestr = String()
        datestr = dateString
        if(dateString == ""){
            datestr = "2014-06-03 10:33"
        }
        let tempDate = datestr.components(separatedBy: " ")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        let myDate = dateFormatter.date(from: tempDate[0])!
        dateFormatter.dateFormat = "mm.dd.yyyy"
        return dateFormatter.string(from: myDate)
    }
    
    static func isValidEmail(email: String?) -> Bool {
        if let email = email {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: email)
        }
        return false
    }
    
   
    
    static func showLoading(){
        DispatchQueue.main.async {
            SVProgressHUD.setDefaultStyle(.custom)
            SVProgressHUD.setBackgroundColor(UIColor.clear)
//            SVProgressHUD.setForegroundColor(<#T##color: UIColor##UIColor#>)
            SVProgressHUD.setForegroundColor(UIColor.darkGray)
           
            SVProgressHUD.setDefaultAnimationType(.native)
            
            SVProgressHUD.show()
        }
    }
//    static func getMacAddress2() -> String{
//        return UIDevice.current.identifierForVendor!.uuid
//    }
    static func getMacAddress() -> String{
        return UIDevice.current.identifierForVendor!.uuidString
    }
    static func getModel() -> String{
        return UIDevice.current.name + " " + UIDevice.current.model
    }
    static func getAppVersion() -> String{
        let _nsObject : AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject
        return _nsObject as! String
    }
    static func hideLoading(){
        SVProgressHUD.dismiss()
    }
    
    static func linespacedString(string: String, lineSpace: Int) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = CGFloat(lineSpace)
//        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: (string.characters.count)))
        return attributedString
    }
    
    static func animateTabView(tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool{
        let fromView: UIView = tabBarController.selectedViewController!.view
        let toView  : UIView = viewController.view
        if fromView == toView {
            return false
        }
        
        UIView.transition(from: fromView, to: toView, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve) { (finished:Bool) in
        }
        return true
    }
    
    static func animateTabItem(tabBar: UITabBar, didSelect item: UITabBarItem){
        let itemView = tabBar.subviews[item.tag + 1]
        let imageView = itemView.subviews.first
        let expandTransform:CGAffineTransform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        imageView?.transform = expandTransform
        UIView.animate(withDuration: 0.4,
                       delay:0.0,
                       usingSpringWithDamping:0.40,
                       initialSpringVelocity:0.2,
                       options: .curveEaseOut,
                       animations: {
                        imageView?.transform = expandTransform.inverted()
        }, completion: nil)
    }
    
    static func checkNotificationStatus(callback: @escaping (Bool) -> ()){
        var status = false
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings: UNNotificationSettings) in
                status = (settings.authorizationStatus == .authorized) ? true : false
                callback(status)
            })
        } else {
            status = (UIApplication.shared.currentUserNotificationSettings?.types.contains(UIUserNotificationType.alert))! ? true : false
            callback(status)
        }
    }
    
    static func getCurrentDate() -> String {
        let todaysDate:Date = Date()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: todaysDate)
    }
    
    static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
