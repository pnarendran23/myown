//
//  AppDelegate.swift
//  Placer
//
//  Created by Vishal on 10/08/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit
import GoogleMaps
import DropDown

import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import BRYXBanner

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let googleMapsApiKey = "AIzaSyCXC10SormbnXjRFyhe0OnfCEpkCFNHx6U"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey(googleMapsApiKey)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: SplashViewController())
        application.statusBarStyle = .lightContent
        
        DropDown.startListeningToKeyboard()
        
        let ns = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(ns)
        
        let notificationType : UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
        let notificationSettings = UIUserNotificationSettings(types: notificationType, categories: nil)
        application.registerForRemoteNotifications()
        application.registerUserNotificationSettings(notificationSettings)
        
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(tokenRefreshNotification(_:)),
                                                         name: NSNotification.Name.InstanceIDTokenRefresh,
                                                         object: nil)
        FirebaseApp.configure()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        InstanceID.instanceID().setAPNSToken(deviceToken, type: InstanceIDAPNSTokenType.sandbox)
//        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
//        var tokenString = ""
//        
//        for i in 0..<deviceToken.length {
//            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
//        }
        
        //print("Device Token:", tokenString)
        //self.saveFcmToken(tokenString)
        //print("Device Token: \(deviceToken)")
    }
    
    //to save token detail
    func saveFcmToken(_ token: String) {
        let preferences = UserDefaults.standard
        
        let fcmKey = "fcm"
        
        preferences.setValue(token, forKey: fcmKey)
        
        //  Save to disk
        let didSave = preferences.synchronize()
        
        if !didSave {
            print("Unable to save fcm!")
        }
    }
    
    func tokenRefreshNotification(_ notification: Notification) {
        // NOTE: It can be nil here
        let refreshedToken = InstanceID.instanceID().token()
    
        if(refreshedToken != nil){
            print("InstanceID token: \(refreshedToken!)")
            connectToFcm(refreshedToken!)
        }
        
    }
    
    func connectToFcm(_ refreshToken:String) {
        Messaging.messaging().connect { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
                self.saveFcmToken(refreshToken)
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("Notification: \(userInfo)")
                if let message = userInfo["msg"] as? NSString {
                    //Do stuff
                    let msg = message.components(separatedBy: "$")
                    print("Notification: \(msg[0])")
                    let color = UIColor.hexStringToUIColor(Colors.colorPrimary)
                    let image = UIImage(named: "logo")
                    let title = "Placer"
                    let subtitle = msg[0]
                    let banner = Banner(title: title, subtitle: subtitle as String, image: image, backgroundColor: color)
                    banner.springiness = .slight
                    banner.position = .top
                    banner.show(duration: 3.0)
        }
    }
    
}

