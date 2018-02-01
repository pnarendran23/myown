//
//  AppDelegate.swift
//  MySampleApp
//
//
// Copyright 2016 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.5
//

import UIKit
import AWSMobileHubHelper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var vc = UIViewController()
    var token = ""
    var launched = 0
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let pushManager: AWSPushManager = AWSPushManager.defaultPushManager()
        pushManager.delegate = self
        pushManager.registerForPushNotifications()
        if(NSUserDefaults.standardUserDefaults().objectForKey("token") != nil){
            token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        }
        launched = 1
        if let topicARNs = pushManager.topicARNs {
            pushManager.registerTopicARNs(topicARNs)
        }
        
        /*UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
         UIViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"login"];
         self.window.rootViewController = vc;*/
        var subViewArray = self.window!.subviews
        if(NSUserDefaults.standardUserDefaults().objectForKey("token") != nil && NSUserDefaults.standardUserDefaults().objectForKey("username") != nil && NSUserDefaults.standardUserDefaults().objectForKey("password") != nil && NSUserDefaults.standardUserDefaults().objectForKey("assetdata") != nil){
            for obj in subViewArray {
                
                obj.removeFromSuperview()
            }
            
            var mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            var v = mainstoryboard.instantiateViewControllerWithIdentifier("mediate")
            self.window?.rootViewController = v
            getstates(credentials().subscription_key)
        }        
 
        return AWSMobileClient.sharedInstance.didFinishLaunching(application, withOptions: launchOptions)
    }
    
    
    func getstates(subscription_key:String){
        let url = NSURL.init(string:String(format: "%@country/states/",credentials().domain_url))
        print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                NSNotificationCenter.defaultCenter().postNotificationName("notifyclose", object: nil)
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.signin()
                })
            }else{
                print(data)
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                    dispatch_async(dispatch_get_main_queue(), {
                        var data = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "countries")
                        var subv = self.window!.subviews
                        for obj in subv {
                            obj.removeFromSuperview()
                        }
                        
                        if(self.launched == 1){
                            var mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                            var v = mainstoryboard.instantiateViewControllerWithIdentifier("listofassets")
                            self.window?.rootViewController = v
                        }else{
                        var mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                            var v = mainstoryboard.instantiateViewControllerWithIdentifier(self.vc.title!)
                            self.window?.rootViewController = v
                        }
                    })
                    
                    //self.tableview.reloadData()
                    // self.buildingactions(subscription_key, leedid: leedid)
                } catch {
                    print(error)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.signin()
                    })
                }
            }
            
        }
        task.resume()
        
    }

    
    
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        // print("application application: \(application.description), openURL: \(url.absoluteURL), sourceApplication: \(sourceApplication)")
        return AWSMobileClient.sharedInstance.withApplication(application, withURL: url, withSourceApplication: sourceApplication, withAnnotation: annotation)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        AWSMobileClient.sharedInstance.applicationDidBecomeActive(application)
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        // Clear the badge icon when you open the app.
        vc  = UIApplication.topViewController()!
        print("Opened view is", vc.title)
        /*UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"login"];
        self.window.rootViewController = vc;*/
        var subViewArray = self.window!.subviews        
        if(NSUserDefaults.standardUserDefaults().objectForKey("token") != nil && NSUserDefaults.standardUserDefaults().objectForKey("username") != nil && NSUserDefaults.standardUserDefaults().objectForKey("password") != nil){
            for obj in subViewArray {
                
                obj.removeFromSuperview()
            }
            
            var mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            var v = mainstoryboard.instantiateViewControllerWithIdentifier("mediate")
            self.window?.rootViewController = v
            
        getstates(credentials().subscription_key)
        }else{
            
        }
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    }
    
    func signin() {
        if(NSUserDefaults.standardUserDefaults().objectForKey("username") != nil && NSUserDefaults.standardUserDefaults().objectForKey("password") != nil){
        var username = NSUserDefaults.standardUserDefaults().objectForKey("username") as! String
        var password = NSUserDefaults.standardUserDefaults().objectForKey("password") as! String
        username = "testuser@gmail.com"
        password = "initpass"
        var credential = credentials()
        var domain_url=credential.domain_url
        print("subscription key of LEEDOn ",credential.subscription_key)
        var url = NSURL.init(string: String(format: "%@auth/login/",domain_url))
        var request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue(credential.subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        var httpbody = String(format: "{\"username\":\"%@\",\"password\":\"%@\"}",username,password)
        request.HTTPBody = httpbody.dataUsingEncoding(NSUTF8StringEncoding)
        print("HEadre is ",httpbody)
        print(request.allHTTPHeaderFields)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                NSNotificationCenter.defaultCenter().postNotificationName("notifyclose", object: nil)
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                NSNotificationCenter.defaultCenter().postNotificationName("notifyclose", object: nil)
                
            }else{
                print(data)
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print("JSON data is",jsonDictionary)
                    if(jsonDictionary.valueForKey("token_type") as! String == "Bearer"){
                        NSUserDefaults.standardUserDefaults().setObject(username, forKey: "username")
                        NSUserDefaults.standardUserDefaults().setObject(password, forKey: "password")
                        NSUserDefaults.standardUserDefaults().setObject(jsonDictionary.valueForKey("authorization_token") as! String, forKey: "token")
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        var subv = self.window!.subviews
                        for obj in subv {
                            obj.removeFromSuperview()
                        }
                        
                        if(self.launched == 1){
                            var mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                            var v = mainstoryboard.instantiateViewControllerWithIdentifier("listofassets")
                            self.window?.rootViewController = v
                        }else{
                        var mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                        var v = mainstoryboard.instantiateViewControllerWithIdentifier(self.vc.title!)
                        self.window?.rootViewController = v
                        }
                    })
                    
                } catch {
                    print(error)
                    NSNotificationCenter.defaultCenter().postNotificationName("notifyclose", object: nil)
                                        
                    
                }
            }
            
        }
        task.resume()
        }
    }
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        AWSMobileClient.sharedInstance.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        AWSMobileClient.sharedInstance.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        AWSMobileClient.sharedInstance.application(application, didReceiveRemoteNotification: userInfo)
    }
    
}

// MARK:- UITableViewDelegate

/*extension AppDelegate: UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AWSPushManager.defaultPushManager().topics.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let pushManager = AWSPushManager.defaultPushManager()
        if pushManager.enabled {
            let topic = pushManager.topics[indexPath.row]
            if topic.subscribed {
                // Unsubscribe
                let alertController = UIAlertController(title: "Please Confirm", message: "Do you want to unsubscribe from the topic?", preferredStyle: .Alert)
                let unsubscribeAction = UIAlertAction(title: "Unsubscribe", style: .Default, handler: {(action: UIAlertAction) -> Void in
                    let topic = AWSPushManager.defaultPushManager().topics[indexPath.row]
                    topic.unsubscribe()
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                alertController.addAction(unsubscribeAction)
                alertController.addAction(cancelAction)
                presentViewController(alertController, animated: true, completion: nil)
            } else {
                // Subscribe
                topic.subscribe()
            }
        }
    }
   
    
}*/

// MARK:- UITableViewDataSource



// MARK:- AWSPushManagerDelegate

extension AppDelegate: AWSPushManagerDelegate {
    func pushManagerDidRegister(pushManager: AWSPushManager) {
        print("Successfully enabled Push Notifications.")
       // pushNotificationSwitch.on = pushManager.enabled
        // Subscribe the first topic among the configured topics (all-device topic)
        if let defaultSubscribeTopic = pushManager.topicARNs?.first {
            let topic = pushManager.topicForTopicARN(defaultSubscribeTopic)
            topic.subscribe()
        }
        if let defaultSubscribeTopic = pushManager.topicARNs?.last {
            let topic = pushManager.topicForTopicARN(defaultSubscribeTopic)
            topic.subscribe()
        }
    }
    
    func pushManager(pushManager: AWSPushManager, didFailToRegisterWithError error: NSError) {
      //  pushNotificationSwitch.on = false
        //showAlertWithTitle("Error", message: "Failed to enable Push Notifications.")
    }
    
    func pushManager(pushManager: AWSPushManager, didReceivePushNotification userInfo: [NSObject : AnyObject]) {
        dispatch_async(dispatch_get_main_queue(), {
            print("Received a Push Notification: \(userInfo)")
         //   self.showAlertWithTitle("Received a Push Notification.", message: userInfo.description)
        })
    }
    
    func pushManagerDidDisable(pushManager: AWSPushManager) {
        print("Successfully disabled Push Notification.")
    }
    
    func pushManager(pushManager: AWSPushManager, didFailToDisableWithError error: NSError) {
        print("Failed to subscibe to a topic: \(error)")
      //  showAlertWithTitle("Error", message: "Failed to unsubscribe from all the topics.")
    }
}

// MARK:- AWSPushTopicDelegate

extension AppDelegate : AWSPushTopicDelegate {
    
    func topicDidSubscribe(topic: AWSPushTopic) {
        print("Successfully subscribed to a topic: \(topic.topicName)")
        //tableView.reloadData()
    }
    
    func topic(topic: AWSPushTopic, didFailToSubscribeWithError error: NSError) {
        print("Failed to subscribe to topic: \(topic.topicName)")
        //showAlertWithTitle("Error", message: "Failed to subscribe to \(topic.topicName)")
    }
    
    func topicDidUnsubscribe(topic: AWSPushTopic) {
        print("Successfully unsubscribed from a topic: \(topic)")
        //self.tableView.reloadData()
    }
    
    func topic(topic: AWSPushTopic, didFailToUnsubscribeWithError error: NSError) {
        print("Failed to subscribe to a topic: \(error)")
        //showAlertWithTitle("Error", message: "Failed to unsubscribe from : \(topic.topicName)")
    }
}
extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController
            
            if let top = moreNavigationController.topViewController where top.view.window != nil {
                return topViewController(top)
            } else if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}
// MARK:- Utility methods


