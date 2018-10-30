//
//  InterfaceController.swift
//  LEEDOn watch app Extension
//
//  Created by Group X on 21/09/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {
    @IBOutlet var spinnergroup: WKInterfaceGroup!

    @IBOutlet var namelbl: WKInterfaceLabel!
    @IBOutlet var scorelbl: WKInterfaceLabel!
    @IBOutlet var certgroup: WKInterfaceGroup!
    @IBOutlet var humangroup: WKInterfaceGroup!
    @IBOutlet var transportgroup: WKInterfaceGroup!
    @IBOutlet var wastegroup: WKInterfaceGroup!
    @IBOutlet var watergroup: WKInterfaceGroup!
    @IBOutlet var energygroup: WKInterfaceGroup!
    var leedid = 0
    var certification = ""
    var key = ""
    var base_url = ""
    var email = ""
    var defaultname = ""
    var secret_pwd = ""
    var defaultleedid = ""
    var subscription_key = ""
    var authtoken = ""
    var prefs = UserDefaults.standard
    var energyscore = 0, waterscore = 0, wastescore = 0, transportscore = 0, basescore = 0, humanscore = 0, totalscore = 0
    //int forceupdate = [[[dataJSON objectForKey:@"iOS"] objectForKey:@"forceToUpdate"] intValue];
    //NSString *str = [[dataJSON objectForKey:@"iOS"] objectForKey:@"version"];
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.spinnergroup.setHidden(false)
        self.spinnergroup.setBackgroundImageNamed("spinner")
        self.spinnergroup.startAnimatingWithImages(in: NSMakeRange(0, 46), duration: 2, repeatCount: 100)        
        proceedwithapp()

        // Configure interface objects here.
    }
    
    func proceedwithapp(){
        let urlPath = String(format: "https://api.usgbc.org/dev/leed/version")
        let endpoint = NSURL(string:urlPath)
        let request = NSMutableURLRequest.init(url: endpoint! as URL)
        request.httpMethod = "GET"
        request.setValue("f94b34f0576f4a85b3c0c22eefb625b3", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 50.0
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) -> Void in
            if(response != nil){
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                if (statusCode == 200) {
                    do {
                        if var jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]{
                            
                            var infoDict = Bundle.main.infoDictionary as! NSDictionary
                            var currentversion = infoDict["CFBundleShortVersionString"];
                            print("Current ver ",currentversion)
                            var dict = jsonResult["iOS"] as! [String:AnyObject]
                            
                            var str = dict["forceToUpdate"] as! Bool
                            var currentVersion = dict["version"] as! String
                            if (currentVersion.compare(currentversion as! String, options: NSString.CompareOptions.numeric) == ComparisonResult.orderedDescending && str==true ) {
                                let okAction = WKAlertAction.init(title: "OK", style: WKAlertActionStyle.default , handler: {
                                    // submit survey
                                    exit(0)
                                })
                                
                                let actions = NSArray.init(objects: okAction)
                                self.presentAlert(withTitle: "New version available", message: "Please open the LEEDOn app on your iPhone to continue", preferredStyle: WKAlertControllerStyle.alert , actions: actions as! [WKAlertAction])
                            }else{
                                self.initloading()
                            }
                        }
                    }catch{
                        
                    }
                }
            }
        })
        task.resume()
    }
    
    func initloading(){
        self.base_url = "https://api.usgbc.org/stg/leed/"
        self.email = "pkamal@usgbc.org";
        self.defaultleedid = "1000121360";
        self.defaultname = "Test";
        self.secret_pwd = "initpass";
        
        self.subscription_key = "e6aecd40e07c40718a0b3ed9a0cc609d"
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification), name: NSNotification.Name(rawValue: "NotificationIdentifier"), object: nil)
        if(self.prefs.object(forKey: "name") != nil){
            //plaqueload()
            self.leedid = self.prefs.integer(forKey: "leed_id")
            self.getauth()
        }else{
            self.leedid = 1000121360
            self.key = ""
            //getbuildingname(leedid: leedid)
            self.prefs.set(self.defaultname, forKey: "name")
            self.prefs.set(self.leedid, forKey: "leed_id")
            self.prefs.set(self.key, forKey: "key")
            //  getperformancedata(leedid: leedid)
            self.getauth()
        }
    }
    
    
    func methodOfReceivedNotification(){
            plaqueload()
    }
    
    func getbuildingdetails(){
        let urlPath = String(format: "%@assets/LEED:%d/",base_url,leedid)
        let endpoint = NSURL(string:urlPath)
        let request = NSMutableURLRequest.init(url: endpoint! as URL)
        request.httpMethod = "GET"
        request.setValue(subscription_key, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(String(format:"Bearer %@",authtoken), forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 50.0
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) -> Void in
            if(response != nil){
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                if (statusCode == 200) {
                    do {
                        if var jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary{
                            print("COunt is ",jsonResult)
                            self.namelbl.setText(jsonResult["name"] as! String)
                            self.prefs.set(jsonResult["name"] as! String, forKey: "name")
                            self.key = jsonResult["key"] as! String
                            self.leedid = jsonResult["leed_id"] as! Int
                            self.certification = jsonResult["certification"] as! String
                            DispatchQueue.main.sync {
                                self.getperformancedata(leedid: self.leedid)
                            }
                            /*    jsonResult = jsonResult["scores"] as! [String:AnyObject] as NSDictionary
                             if(jsonResult["energy"] is NSNull){
                             UserDefaults.standard.set(0, forKey: "energyscore")
                             }else{
                             let energy = jsonResult["energy"] as! Int
                             UserDefaults.standard.set(energy, forKey: "energyscore")
                             }
                             
                             if(jsonResult["water"] is NSNull){
                             UserDefaults.standard.set(0, forKey: "waterscore")
                             }else{
                             let water = jsonResult["water"] as! Int
                             UserDefaults.standard.set(water, forKey: "waterscore")
                             }
                             
                             
                             if(jsonResult["waste"] is NSNull){
                             UserDefaults.standard.set(0, forKey: "wastescore")
                             }else{
                             let energy = jsonResult["waste"] as! Int
                             UserDefaults.standard.set(energy, forKey: "wastescore")
                             }
                             
                             
                             if(jsonResult["transport"] is NSNull){
                             UserDefaults.standard.set(0, forKey: "transportscore")
                             }else{
                             let energy = jsonResult["transport"] as! Int
                             UserDefaults.standard.set(energy, forKey: "transportscore")
                             }
                             
                             if(jsonResult["base"] != nil){
                             if(jsonResult["base"] is NSNull){
                             UserDefaults.standard.set(0, forKey: "basescore")
                             }else{
                             let energy = jsonResult["base"] as! Int
                             UserDefaults.standard.set(energy, forKey: "basescore")
                             }
                             }else{
                             UserDefaults.standard.set(0, forKey: "basescore")
                             }
                             
                             if(jsonResult["human_experience"] is NSNull){
                             UserDefaults.standard.set(0, forKey: "humanscore")
                             }else{
                             let energy = jsonResult["human_experience"] as! Int
                             UserDefaults.standard.set(energy, forKey: "humanscore")
                             }
                             UserDefaults.standard.set(NSDate(), forKey: "lastupdated")
                             UserDefaults.standard.synchronize()
                             DispatchQueue.main.sync {
                             print("Async1")
                             if(WCSession.isSupported()){
                             var dict = [String:AnyObject]()
                             dict["energyscore"] = self.prefs.integer(forKey: "energyscore")as AnyObject?
                             dict["waterscore"] = self.prefs.integer(forKey: "waterscore")as AnyObject?
                             dict["wastescore"] = self.prefs.integer(forKey: "wastescore")  as AnyObject?
                             dict["transportscore"] = self.prefs.integer(forKey:"transportscore") as AnyObject?
                             dict["humanscore"] = self.prefs.integer(forKey: "humanscore")as AnyObject?
                             dict["basescore"] = self.prefs.integer(forKey: "basescore")as AnyObject?
                             dict["name"] = self.prefs.object(forKey: "name") as! String as AnyObject?
                             dict["key"] = self.prefs.object(forKey: "key") as! String as AnyObject?
                             dict["leed_id"] = self.leedid as AnyObject?
                             WCSession.default().sendMessage(dict, replyHandler: ({
                             (reply) -> Void in
                             
                             }), errorHandler: nil
                             )
                             
                             do{
                             try WCSession.default().updateApplicationContext(dict)
                             }catch{
                             
                             }
                             }
                             //self.plaqueload()
                             }
                             
                             
                             */
                        }
                        
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                    print("Everyone is fine, file downloaded successfully.")
                    
                    
                }else{
                    print("Offline")
                    self.connecterror()
                }
            }else{
                print("Offline")
                self.connecterror()
            }
            
        })
        
        task.resume()

    }
    
    func getauth(){
        let urlPath = String(format: "%@auth/login/",base_url)
        let endpoint = NSURL(string:urlPath)
        let request = NSMutableURLRequest.init(url: endpoint! as URL)
        request.httpMethod = "POST"
        request.setValue(subscription_key, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let authStr = String(format:"{\"username\":\"%@\",\"password\":\"%@\"}",email,secret_pwd)
        let authData = authStr.data(using: String.Encoding.utf8)
        request.httpBody = authData
        request.timeoutInterval = 50.0
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) -> Void in
            if(response != nil){
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                if (statusCode == 200) {
                    do {
                        if var jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary{
                            print("COunt is ",jsonResult)
                            self.authtoken = jsonResult["authorization_token"] as! String
                            
                            DispatchQueue.main.sync {
                            self.getbuildingdetails()
                            }
                        /*    jsonResult = jsonResult["scores"] as! [String:AnyObject] as NSDictionary
                            if(jsonResult["energy"] is NSNull){
                                UserDefaults.standard.set(0, forKey: "energyscore")
                            }else{
                                let energy = jsonResult["energy"] as! Int
                                UserDefaults.standard.set(energy, forKey: "energyscore")
                            }
                            
                            if(jsonResult["water"] is NSNull){
                                UserDefaults.standard.set(0, forKey: "waterscore")
                            }else{
                                let water = jsonResult["water"] as! Int
                                UserDefaults.standard.set(water, forKey: "waterscore")
                            }
                            
                            
                            if(jsonResult["waste"] is NSNull){
                                UserDefaults.standard.set(0, forKey: "wastescore")
                            }else{
                                let energy = jsonResult["waste"] as! Int
                                UserDefaults.standard.set(energy, forKey: "wastescore")
                            }
                            
                            
                            if(jsonResult["transport"] is NSNull){
                                UserDefaults.standard.set(0, forKey: "transportscore")
                            }else{
                                let energy = jsonResult["transport"] as! Int
                                UserDefaults.standard.set(energy, forKey: "transportscore")
                            }
                            
                            if(jsonResult["base"] != nil){
                                if(jsonResult["base"] is NSNull){
                                    UserDefaults.standard.set(0, forKey: "basescore")
                                }else{
                                    let energy = jsonResult["base"] as! Int
                                    UserDefaults.standard.set(energy, forKey: "basescore")
                                }
                            }else{
                                UserDefaults.standard.set(0, forKey: "basescore")
                            }
                            
                            if(jsonResult["human_experience"] is NSNull){
                                UserDefaults.standard.set(0, forKey: "humanscore")
                            }else{
                                let energy = jsonResult["human_experience"] as! Int
                                UserDefaults.standard.set(energy, forKey: "humanscore")
                            }
                            UserDefaults.standard.set(NSDate(), forKey: "lastupdated")
                            UserDefaults.standard.synchronize()
                            DispatchQueue.main.sync {
                                print("Async1")
                                if(WCSession.isSupported()){
                                    var dict = [String:AnyObject]()
                                    dict["energyscore"] = self.prefs.integer(forKey: "energyscore")as AnyObject?
                                    dict["waterscore"] = self.prefs.integer(forKey: "waterscore")as AnyObject?
                                    dict["wastescore"] = self.prefs.integer(forKey: "wastescore")  as AnyObject?
                                    dict["transportscore"] = self.prefs.integer(forKey:"transportscore") as AnyObject?
                                    dict["humanscore"] = self.prefs.integer(forKey: "humanscore")as AnyObject?
                                    dict["basescore"] = self.prefs.integer(forKey: "basescore")as AnyObject?
                                    dict["name"] = self.prefs.object(forKey: "name") as! String as AnyObject?
                                    dict["key"] = self.prefs.object(forKey: "key") as! String as AnyObject?
                                    dict["leed_id"] = self.leedid as AnyObject?
                                    WCSession.default().sendMessage(dict, replyHandler: ({
                                        (reply) -> Void in
                                        
                                    }), errorHandler: nil
                                    )
                                    
                                    do{
                                        try WCSession.default().updateApplicationContext(dict)
                                    }catch{
                                        
                                    }
                                }
                                //self.plaqueload()
                            }
                            
                            
                            */
                        }
                        
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                    print("Everyone is fine, file downloaded successfully.")
                    
                    
                }else{
                    print("Offline")
                    self.connecterror()
                }
            }else{
                print("Offline")
                self.connecterror()
            }
            
        })
        
        task.resume()
        

    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func plaqueload(){
        energyscore = prefs.integer(forKey: "energyscore")
        waterscore = prefs.integer(forKey: "waterscore")
        wastescore = prefs.integer(forKey: "wastescore")
        transportscore = prefs.integer(forKey: "transportscore")
        humanscore = prefs.integer(forKey: "humanscore")
        basescore = prefs.integer(forKey: "basescore")
        print(energyscore,waterscore, wastescore, transportscore, humanscore, basescore)
        let totalscore = energyscore+waterscore+wastescore+transportscore+humanscore+basescore
        UserDefaults.standard.set(totalscore, forKey: "totalscore")
        energygroup.setBackgroundImageNamed(String(format: "energy%d",energyscore))
        watergroup.setBackgroundImageNamed(String(format: "water%d",waterscore))
        wastegroup.setBackgroundImageNamed(String(format: "waste%d",wastescore))
        transportgroup.setBackgroundImageNamed(String(format: "transport%d",transportscore))
        humangroup.setBackgroundImageNamed(String(format: "human%d",humanscore))
        namelbl.setText(prefs.object(forKey: "name") as! String?)
        scorelbl.setText(String(format: "%d",totalscore))
        if(certification == "Platinum"){
            certgroup.setBackgroundImageNamed("platinum")
        }else if(certification == "Gold"){
        certgroup.setBackgroundImageNamed("gold")
        }else if(certification == "Silver"){
            certgroup.setBackgroundImageNamed("silver")
        }else if(certification == "Certified"){
            certgroup.setBackgroundImageNamed("certified")
        }else if (certification == "" || certification == "Denied" || certification == "None"){
            certgroup.setBackgroundImageNamed("nonleed")
        }else{
            certgroup.setBackgroundImageNamed("blank")
        }
        /*if(totalscore > 75){
            certgroup.setBackgroundImageNamed("platinum")
        }else if(totalscore >= 60 && totalscore <= 75){
            certgroup.setBackgroundImageNamed("gold")
        }else if(totalscore >= 50 && totalscore <= 59){
            certgroup.setBackgroundImageNamed("silver")
        }else if(totalscore >= 40 && totalscore <= 49){
            certgroup.setBackgroundImageNamed("certified")
        }else{
            certgroup.setBackgroundImageNamed("blank")
        }*/
        
        
        
        spinnergroup.setHidden(true)
        //namelbl.setText(String(format:"%@",prefs.objectForKey("name") as! String))
    }
   
    
    
    func invalidleedid(){
        let okAction = WKAlertAction.init(title: "OK", style: WKAlertActionStyle.default , handler: {
            // submit survey
            
        })
        
        
        let actions = NSArray.init(objects: okAction)
        self.presentAlert(withTitle: "Invalid LEED ID", message: "Please check the LEED ID you've entered", preferredStyle: WKAlertControllerStyle.alert , actions: actions as! [WKAlertAction])
    }
    
    func connecterror(){
        self.prefs.removeObject(forKey: "name")
        let cancelAction = WKAlertAction.init(title: "Exit the app", style: WKAlertActionStyle.default , handler: {
            // submit survey
            exit(0)
            
        })
        let okAction = WKAlertAction.init(title: "Retry", style: WKAlertActionStyle.default , handler: {
            // submit survey            
            self.spinnergroup.setHidden(false)
            self.prefs.synchronize()
            let l = 0
           // WKInterfaceController.reloadRootControllers(withNames: ["homeview"], contexts: [l])
            self.initloading()
            
        })
        
        
        let actions = NSArray.init(objects: okAction,cancelAction)
        self.presentAlert(withTitle: "Error", message: "Please check your internet connection or the LEED ID you've entered", preferredStyle: WKAlertControllerStyle.alert , actions: actions as! [WKAlertAction])
    }
    
    func getperformancedata(leedid:Int){
        let urlPath = String(format: "%@assets/LEED:%d/scores/?subscription-key=%@&key=%@",base_url,leedid,subscription_key,key)
        
        let endpoint = NSURL(string:urlPath)
        let request = NSMutableURLRequest.init(url: endpoint! as URL)
        request.httpMethod = "GET"
        request.setValue(subscription_key, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(String(format:"Bearer %@",authtoken), forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 50.0
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
        (data, response, error) -> Void in
            if(response != nil){
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                if (statusCode == 200) {
                    do {
                        if var jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary{
                            print("COunt is ",jsonResult)
                            jsonResult = jsonResult["scores"] as! [String:AnyObject] as NSDictionary
                            if(jsonResult["energy"] is NSNull){
                                UserDefaults.standard.set(0, forKey: "energyscore")
                            }else{
                                let energy = jsonResult["energy"] as! Int
                                UserDefaults.standard.set(energy, forKey: "energyscore")
                            }
                            
                            if(jsonResult["water"] is NSNull){
                                UserDefaults.standard.set(0, forKey: "waterscore")
                            }else{
                                let water = jsonResult["water"] as! Int
                                UserDefaults.standard.set(water, forKey: "waterscore")
                            }
                            
                            
                            if(jsonResult["waste"] is NSNull){
                                UserDefaults.standard.set(0, forKey: "wastescore")
                            }else{
                                let energy = jsonResult["waste"] as! Int
                                UserDefaults.standard.set(energy, forKey: "wastescore")
                            }
                            
                            
                            if(jsonResult["transport"] is NSNull){
                                UserDefaults.standard.set(0, forKey: "transportscore")
                            }else{
                                let energy = jsonResult["transport"] as! Int
                                UserDefaults.standard.set(energy, forKey: "transportscore")
                            }
                            
                            if(jsonResult["base"] != nil){
                                if(jsonResult["base"] is NSNull){
                                    UserDefaults.standard.set(0, forKey: "basescore")
                                }else{
                                    let energy = jsonResult["base"] as! Int
                                    UserDefaults.standard.set(energy, forKey: "basescore")
                                }
                            }else{
                                UserDefaults.standard.set(0, forKey: "basescore")
                            }
                            
                            if(jsonResult["human_experience"] is NSNull){
                                UserDefaults.standard.set(0, forKey: "humanscore")
                            }else{
                                let energy = jsonResult["human_experience"] as! Int
                                UserDefaults.standard.set(energy, forKey: "humanscore")
                            }
                            UserDefaults.standard.set(NSDate(), forKey: "lastupdated")
                            UserDefaults.standard.synchronize()
                            DispatchQueue.main.sync {
                                print("Async1")
                                if(WCSession.isSupported()){
                                    var dict = [String:AnyObject]()
                                    dict["energyscore"] = self.prefs.integer(forKey: "energyscore")as AnyObject?
                                    dict["waterscore"] = self.prefs.integer(forKey: "waterscore")as AnyObject?
                                    dict["wastescore"] = self.prefs.integer(forKey: "wastescore")  as AnyObject?
                                    dict["transportscore"] = self.prefs.integer(forKey:"transportscore") as AnyObject?
                                    dict["humanscore"] = self.prefs.integer(forKey: "humanscore")as AnyObject?
                                    dict["basescore"] = self.prefs.integer(forKey: "basescore")as AnyObject?
                                    dict["name"] = self.prefs.object(forKey: "name") as! String as AnyObject?
                                    dict["key"] = self.prefs.object(forKey: "key") as! String as AnyObject?
                                    dict["leed_id"] = self.leedid as AnyObject?
                                    self.prefs.set(self.leedid, forKey: "leed_id")
                                    self.prefs.set(self.key, forKey: "key")
                                    WCSession.default().sendMessage(dict, replyHandler: ({
                                    (reply) -> Void in
                                    
                                    }), errorHandler: nil
                                    )
                                    
                                    do{
                                        try WCSession.default().updateApplicationContext(dict)
                                    }catch{
                                        
                                    }
                                }
                                self.plaqueload()
                            }
                        
                            
                            //
                        }
                        
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                    print("Everyone is fine, file downloaded successfully.")
                    
                    
                }else{
                    print("Offline")
                    self.connecterror()
                }
            }else{
                print("Offline")
                self.connecterror()
            }
 
        })

        task.resume()
        
        
    }
    
    


    
}
