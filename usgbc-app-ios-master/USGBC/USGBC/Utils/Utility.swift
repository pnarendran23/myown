//
//  USGBCHelper.swift
//  USGBC
//
//  Created by Vishal on 10/05/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import SVProgressHUD
import UserNotifications

class Utility{
    
    static let shared = Utility()
    
    //to save token detail
    func saveToken(token: String) {
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
    
    //to get token detail
    func getTokenDetail() -> String{
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
    
    static func showToast(message:String){
        AWBanner.showWithDuration(4.5, delay: 0.0, message: NSLocalizedString(message, comment: ""), backgroundColor: UIColor.hex(hex: Colors.drawerBackground), textColor: UIColor.white, originY: 64)
    }
    
    static func showToastDontClose(message:String){
        AWBanner.showWithDuration(0, delay: 0.0, message: NSLocalizedString(message, comment: ""), backgroundColor: UIColor.hex(hex: Colors.drawerBackground), textColor: UIColor.white, originY: 64)
    }
    
    static func showLoading(){
        DispatchQueue.main.async {
            SVProgressHUD.setDefaultStyle(.custom)
            SVProgressHUD.setBackgroundColor(UIColor.clear)
            SVProgressHUD.setForegroundColor(UIColor.hex(hex: Colors.primaryColor))
            SVProgressHUD.setDefaultAnimationType(.native)
            SVProgressHUD.show()
        }
    }
    
    static func hideLoading(){
        SVProgressHUD.dismiss()
    }
    
    static func linespacedString(string: String, lineSpace: Int) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = CGFloat(lineSpace)
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: (string.characters.count)))
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
