//
//  AppDelegate.swift
//  USGBC
//
//  Created by Vishal Raj on 15/02/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import UserNotifications
import GoogleMaps
import PSPDFKit
import Firebase
import QuartzCore
import FirebaseFirestore
import AlamofireNetworkActivityIndicator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CAAnimationDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    let mapKey = "AIzaSyD8mR1hQ-c4XqGyMDl0wX5yAisM3jvsFdI"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        orientationLock = .portrait
        FirebaseApp.configure()
        NetworkActivityIndicatorManager.shared.isEnabled = true
        Fabric.sharedSDK().debug = false
        Fabric.with([Crashlytics.self])
        Crashlytics.sharedInstance().debugMode = true
        GMSServices.provideAPIKey(mapKey)
        
        let onboardingDone = UserDefaults.standard.bool(forKey: "onboardingComplete")
        if (!onboardingDone) {
            let sb = UIStoryboard(name: "Dashboard", bundle: nil)
            let initialViewController = sb.instantiateViewController(withIdentifier: "WalkThroughViewController")
            window?.rootViewController = initialViewController
        }
        
        //NavigationBar styling
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().barTintColor = UIColor.hex(hex: Colors.primaryColor)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName: UIFont(name: "Gotham-Medium", size: 17)!]
        UINavigationBar.appearance().isTranslucent = false
        
        //TabBar styling
        UITabBar.appearance().tintColor = UIColor.hex(hex: Colors.primaryDarkColor)
        UITabBar.appearance().isTranslucent = false
    
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        //application.applicationIconBadgeNumber = 2
        
        let memoryCapacity = 0 * 1024 * 1024
        let diskCapacity = 500 * 1024 * 1024
        let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "usgbcCache")
        URLCache.shared = cache
        
        //Animation
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.backgroundColor = UIColor.hex(hex: Colors.primaryColor)//(red: 241/255, green: 196/255, blue: 15/255, alpha: 1)
        self.window!.makeKeyAndVisible()
        
        // rootViewController from StoryBoard
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let navigationController = mainStoryboard.instantiateViewController(withIdentifier: "navigationController")
        self.window!.rootViewController = navigationController
        
        // logo mask
        navigationController.view.layer.mask = CALayer()
        navigationController.view.layer.mask?.contents = UIImage(named: "cc")!.cgImage
        navigationController.view.layer.mask?.backgroundColor = UIColor.clear.cgColor
        navigationController.view.layer.mask?.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
        navigationController.view.layer.mask?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        navigationController.view.layer.mask?.position = CGPoint(x: navigationController.view.frame.width / 2, y: navigationController.view.frame.height / 2)
        
        // logo mask background view
        let maskBgView = UIView(frame: navigationController.view.frame)
        maskBgView.backgroundColor = UIColor.hex(hex: Colors.primaryColor)
        var lbl = UILabel.init(frame: CGRect(x: 0, y: 0, width: 0.48 * UIScreen.main.bounds.size.width, height:  0.48 * UIScreen.main.bounds.size.width))
        lbl.text = ":asdasdasdasdsad"
        maskBgView.addSubview(lbl)
        navigationController.view.addSubview(maskBgView)
        navigationController.view.bringSubview(toFront: maskBgView)
        
        maskBgView.alpha = 1.0
        // logo mask animation
        let transformAnimation = CAKeyframeAnimation(keyPath: "bounds")
        transformAnimation.delegate = self
        transformAnimation.duration = 3        
        transformAnimation.beginTime = CACurrentMediaTime() + 1 //add delay of 1 second
        let initalBounds = NSValue(cgRect: (navigationController.view.layer.mask?.bounds)!)
        let secondBounds = NSValue(cgRect: CGRect(x: 0, y: 0, width:  0.48 * UIScreen.main.bounds.size.width, height:  0.48 * UIScreen.main.bounds.size.width))
        let finalBounds = NSValue(cgRect: CGRect(x: 0, y: 0, width:  36.23 * UIScreen.main.bounds.size.width, height:  36.23 * UIScreen.main.bounds.size.width))
        transformAnimation.values = [initalBounds, secondBounds, finalBounds]
        transformAnimation.keyTimes = [0, 0.5, 1]
        transformAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)]
        transformAnimation.isRemovedOnCompletion = false
        transformAnimation.fillMode = kCAFillModeForwards
        navigationController.view.layer.mask?.add(transformAnimation, forKey: "maskAnimation")
        
        
        // logo mask background view animation
        UIView.animate(withDuration: 0.1,
                       delay: 1.35,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: {
                        maskBgView.alpha = 0.0
        },
                       completion: { finished in
                        maskBgView.removeFromSuperview()
        })
        
        // root view animation
        UIView.animate(withDuration: 0.25,
                       delay: 1.3,
                       options: [],
                       animations: {
                        self.window!.rootViewController!.view.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        },
                       completion: { finished in
                        UIView.animate(withDuration: 0.3,
                                       delay: 0.0,
                                       options: UIViewAnimationOptions.curveEaseInOut,
                                       animations: {
                                        self.window!.rootViewController!.view.transform = .identity
                        },
                                       completion: nil)
        })
        
        
        
        
        return true
    }
    
    var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Activate PSPDFKit for com.usgbc.USGBC
        PSPDFKit.setLicenseKey("WNhkZmuzbWuAfifoKwGq8DJOL4q8tjnbOFnlV/J+gMGoMtxIGu0texP4qED4"
            + "ar4OrVKAQoldIRtj3gppbZrmekO6qJ54HQHJqLR1ktuOIbZtpFiWU8zmWiXh"
            + "es3B2MKl3ghsdqt+LIcDCiRl/ZpuBXWzBOZJPNl74RxO2Fg/8cjiMhUiXKBi"
            + "zDMibnQ53rnu6eSR+WgZUV0StV8Fw1+iktU5CsaL5/kDdc2vcggFhhf0GXvn"
            + "hleBaA1YLoNKOC9OK4YM56k8PxYUAFle2c5mNoaiObx3O/Mn2wlVjxx5hm+Q"
            + "tm52z2J6NzUEgn25AKEDuGKTYR9oSWrHLJ/qe7GlI8uNuUDEpBZcFoFSqTJ1"
            + "TPq2JS/DlRO/TR2Q3A8PQ/sj/F+FHvFu/WD8zAmjiotEQQ6GK7QJqgFpyuKL"
            + "P8oKDdvAqO/oEXmd2BmEu0IhHIge+uM4znNkT3NLN9fKk73AO1/aIKCXgDNa"
            + "5e+6ExGaNfNpIO6Hm6YVKhvVYaWUG7hbyIUj2ms3q+Wxiu1KFVn5Ww==")
        
        // ViewController based status bar NO : info.plist
        PSPDFKit.sharedInstance().setValue(true, forKey: "com.pspdfkit.development.suppress-warning-alerts")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        // Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        completionHandler(handleShortcutItem(withShortcutItem: shortcutItem))
    }
    
    func handleShortcutItem(withShortcutItem item: UIApplicationShortcutItem) -> Bool {
        
        let vc = self.window?.rootViewController as! UINavigationController
        let sb = UIStoryboard(name: "Dashboard", bundle: nil)
        
        enum ShortcutType: String {
            case articles = "Articles"
            case courses = "Courses"
            case publications = "Publications"
            case favorites = "Favorites"
        }
        
        guard let shortcutType = item.type.components(separatedBy: ".").last else { return false }
        
        if let type = ShortcutType(rawValue: shortcutType) {
            
            switch type {
                case .articles:
                    vc.pushViewController(sb.instantiateViewController(withIdentifier: "ArticleListViewController"), animated: true)
                    return true
                case .courses:
                    vc.pushViewController(sb.instantiateViewController(withIdentifier: "CourseListViewController"), animated: true)
                    return true
                case .publications:
                    vc.pushViewController(PublicationTabViewController(), animated: true)
                case .favorites:
                    vc.pushViewController(sb.instantiateViewController(withIdentifier: "FavoriteListViewController"), animated: true)
            }
        }
        return false
    }
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        //completionHandler([])
        completionHandler(UNNotificationPresentationOptions.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
    
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        Utility().saveFCMDetails(fcm: fcmToken)
        let notificationStatus = 1
//        Utility.checkNotificationStatus { status in
//            notificationStatus = status ? 1 : 0
            Utility().saveNotifcationStatus(status: "\(notificationStatus)")
            let parameters: [String: AnyObject] = [
                "device_id" : UIDevice.current.identifierForVendor!.uuidString as AnyObject,
                "device_name" : "\(UIDevice.current.model) iOS \(UIDevice.current.systemVersion)" as AnyObject,
                "fcm_id" : Utility().getFCMDetail() as AnyObject,
                "user_email" : Utility().getUserDetail() as AnyObject,
                "active_status": "0" as AnyObject,
                "install_status": "1" as AnyObject,
                "created_on": Utility.getCurrentDate() as AnyObject,
                "updated_on": Utility.getCurrentDate() as AnyObject,
                "partneralias": "usgbcmobile" as AnyObject,
                "partnerpwd": "usgbcmobilepwd" as AnyObject,
                "notification_status": notificationStatus as AnyObject
            ]
            ApiManager.shared.registerFCMDevice(params: parameters){ (message, error) in
                if(error == nil && message != nil){
                    Utility().saveAppID(appId: message!)
                }else{
                    print(error ?? "Error")
                }
            }
//        }
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]


}

