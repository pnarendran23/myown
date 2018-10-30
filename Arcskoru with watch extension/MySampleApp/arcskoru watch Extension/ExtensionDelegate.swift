//
//  ExtensionDelegate.swift
//  LEEDOn watch app Extension
//
//  Created by Group X on 21/09/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import WatchKit
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate,WCSessionDelegate {
    var session:WCSession!
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        if(WCSession.isSupported()){
            session = WCSession.default()
            session.delegate = self
            session.activate()
        }
        
        
        
        
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print(applicationContext);
        var dict = applicationContext
        UserDefaults.standard.set(dict["energy"], forKey: "energyscore")
        UserDefaults.standard.set(dict["water"], forKey: "waterscore")
        UserDefaults.standard.set(dict["waste"], forKey: "wastescore")
        UserDefaults.standard.set(dict["transport"], forKey: "transportscore")
        UserDefaults.standard.set(dict["human_experience"], forKey: "humanscore")
        UserDefaults.standard.set(dict["base"], forKey: "basescore")
        UserDefaults.standard.set(dict["name"], forKey: "name")
        UserDefaults.standard.synchronize()
        print(applicationContext)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationIdentifier"), object: nil)
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        print(messageData)
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        print(messageData)
    }
    
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        var dict = message
        UserDefaults.standard.set(dict["energy"], forKey: "energyscore")
        UserDefaults.standard.set(dict["water"], forKey: "waterscore")
        UserDefaults.standard.set(dict["waste"], forKey: "wastescore")
        UserDefaults.standard.set(dict["transport"], forKey: "transportscore")
        UserDefaults.standard.set(dict["human_experience"], forKey: "humanscore")
        UserDefaults.standard.set(dict["base"], forKey: "basescore")
        UserDefaults.standard.set(dict["name"], forKey: "name")
        UserDefaults.standard.synchronize()
        print(message)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationIdentifier"), object: nil)
        
    }
    
    
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    
    
    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    @available(watchOSApplicationExtension 3.0, *)
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompleted()
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompleted()
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompleted()
            default:
                // make sure to complete unhandled task types
                task.setTaskCompleted()
            }
        }
    }

}
