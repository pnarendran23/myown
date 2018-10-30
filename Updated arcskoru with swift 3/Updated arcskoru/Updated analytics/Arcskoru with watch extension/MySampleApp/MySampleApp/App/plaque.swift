//
//  instructions.swift
//  LEEDOn
//
//  Created by Group X on 29/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//
import WatchConnectivity
import UIKit

class plaque: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UITabBarDelegate, WCSessionDelegate {
    var indicator = UIPageControl()
    var currentindex = 0
    var watchsession = WCSession.default()
    var emptydict = ["count": 1,"created_at_max": "2016-12-30T14:02:41.260478Z","created_at_min": "2016-12-30T14:02:41.260478Z","energy_avg": 0,"water_avg": 0,"waste_avg": 0,"transport_avg": 0,"base_avg": 0,"human_experience_avg": 0] as [String : Any]
    var localavgdict = NSMutableDictionary()
    var globalavgdict = NSMutableDictionary()
    var performance_data = NSMutableDictionary()
    var pageTitles = ["Explore buildings","Analysing projects","Astonishing performance scores animation","Calculating scores", "Organize submission data","Activity feed"]
    @IBOutlet weak var nav: UINavigationBar!
    
    var contentarray = ["Access and get information about any of your building in a finger tip from anywhere","Get the LEED performance score of the building which you want","Analyse your building performance score to get a better score and also to know, what's really affecting your score.","Calculate your emissions and their scores relfection in a single move.","Check who does that and who needs to do what for your building","Check for the status of the submitted data", "Get instant notifications about your building about its data and certification."]
    var imgarray = [UIImage(named: ("list of buildings")),UIImage(named: ("plaque")),UIImage(named: ("analytics")),UIImage(named: ("calculate")),UIImage(named: ("organize")), UIImage(named: ("notifications"))]
    var innerdict = NSMutableDictionary()
    var middledict = NSMutableDictionary()
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        indicator = self.view.viewWithTag(90) as! UIPageControl
        pgctrl.numberOfPages = 6
        pgctrl.isUserInteractionEnabled = false
        wedid()
        return [.portrait ,.portraitUpsideDown]
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backItem?.title = "Projects"
        buildingdetails = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.navigationItem.title = buildingdetails["name"] as? String
    }
    var buildingdetails = NSMutableDictionary()
    override func viewWillDisappear(_ animated: Bool) {
        DispatchQueue.main.async(execute: {
        let t = NSArray.init(array: self.download_requests)
        for r in 0 ..< t.count
        {
            let request = t[r] as! URLSession
            request.invalidateAndCancel()            
        }
         self.buildingdetails = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.navigationItem.title = self.buildingdetails["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = self.buildingdetails["name"] as? String
            //stop all download requests
            for request in self.download_requests
            {
                request.invalidateAndCancel()
            }
            if (WCSession.isSupported()) {
                self.watchsession.delegate = nil;
            }
        })
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    @available(iOS 9.3, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.title == "Score"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"plaque"])
            NotificationCenter.default.post(name: Notification.Name(rawValue: "performrootsegue"), object: nil, userInfo: ["seguename":"plaque"])
        }else if(item.title == "Analytics"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"beforeanalytics"])
            NotificationCenter.default.post(name: Notification.Name(rawValue: "performrootsegue"), object: nil, userInfo: ["seguename":"totalanalysis"])
        }else if(item.title == "Manage"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"manage"])
            NotificationCenter.default.post(name: Notification.Name(rawValue: "performrootsegue"), object: nil, userInfo: ["seguename":"manage"])
                
        }else if(item.title == "More"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"more"])
            NotificationCenter.default.post(name: Notification.Name(rawValue: "performrootsegue"), object: nil, userInfo: ["seguename":"more"])
        }else if(item.title == "Credits/Actions"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"listofactions"])
            NotificationCenter.default.post(name: Notification.Name(rawValue: "performrootsegue"), object: nil, userInfo: ["seguename":"listofactions"])
        }
    }

    
    
    var pageviewcontroller = UIPageViewController()
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if(pageViewController.viewControllers?.first is overallplaque){
            let p = pageViewController.viewControllers?.first as! overallplaque
            currentindex = p.pageIndex
            //print("Presented index",p.pageIndex)
            pgctrl.currentPage = p.pageIndex
        }else if(pageViewController.viewControllers?.first is individualplaque){
            let p = pageViewController.viewControllers?.first as! individualplaque
            //print("Presented index",p.pageIndex)
            currentindex = p.pageIndex
            pgctrl.currentPage = p.pageIndex
        }else{
            pgctrl.currentPage = 0
        }
        
        if(currentindex == 0){
            pgctrl.currentPageIndicatorTintColor = UIColor.blue
        }else if(currentindex == 1){
             pgctrl.currentPageIndicatorTintColor = UIColor(red:0.776, green: 0.858, blue:0.124, alpha:1)
        }else if(currentindex == 2){
            pgctrl.currentPageIndicatorTintColor = UIColor(red:0.323, green: 0.755, blue:0.93, alpha:1)
        }else if(currentindex == 3){
            pgctrl.currentPageIndicatorTintColor = UIColor(red:0.465, green: 0.756, blue:0.629, alpha:1)
        }else if(currentindex == 4){
            pgctrl.currentPageIndicatorTintColor = UIColor(red:0.573, green: 0.557, blue:0.498, alpha:1)
        }else if(currentindex == 5){
            pgctrl.currentPageIndicatorTintColor =  UIColor(red:0.909, green: 0.602, blue:0.268, alpha:1)
        }
        
    }
    
    @IBOutlet weak var pgctrl: UIPageControl!
    var task = URLSessionTask()
    var download_requests = [URLSession]()
    
    func showalert(_ message:String, title:String, action:String){
        
        //let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        //let callActionHandler = { (action:UIAlertAction!) -> Void in
        DispatchQueue.main.async(execute: {
            //self.view.userInteractionEnabled = true
            //self.spinner.hidden = true
            self.view.isUserInteractionEnabled = true
            self.maketoast(message, type: "error")
            //self.navigationController?.popViewControllerAnimated(true)
        })
        
        //        }
        //      let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        //    alertController.addAction(defaultAction)
        
        //presentViewController(alertController, animated: true, completion: nil)
        
        
    }

    func getperformancedata(_ subscription_key:String, leedid: Int, date : String){
        let url = URL.init(string: String(format: "%@assets/LEED:%d/scores/",credentials().domain_url,leedid))
        ////print(url?.absoluteURL)
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        var token = UserDefaults.standard.object(forKey: "token") as! String
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(session)
        self.task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                //print("error=\(error)")
                if (error?._code == -999){
                    
                }else{
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                }
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401{
                DispatchQueue.main.async(execute: {
                    //self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    //self.spinner.hidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
                return
            } else
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                    DispatchQueue.main.async(execute: {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    })
                }else{
                    
                    let jsonDictionary : NSMutableDictionary
                    do {
                        jsonDictionary = try (JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        //print(jsonDictionary)
                        let datakeyed = NSKeyedArchiver.archivedData(withRootObject: jsonDictionary)
                        if(jsonDictionary["scores"] != nil){
                        UserDefaults.standard.set(datakeyed, forKey: "performance_data")
                        UserDefaults.standard.synchronize()
                        }else{
                            let temp = NSMutableDictionary()
                            temp["energy"] = 33
                            temp["base"] = 10
                            temp["water"] = 15
                            temp["waste"] = 8
                            temp["transport"] = 14
                            temp["human_experience"] = 20
                            jsonDictionary["maxima"] = temp
                            let datakeyed = NSKeyedArchiver.archivedData(withRootObject: jsonDictionary)
                                UserDefaults.standard.set(datakeyed, forKey: "performance_data")
                                UserDefaults.standard.synchronize()
                        }
                        DispatchQueue.main.async(execute: {() -> Void in
                            if WCSession.isSupported() {
                                var dict = NSMutableDictionary()
                                if(jsonDictionary["scores"] == nil){
                                    dict["energy"] = 0 
                                    dict["base"] = 0 
                                    dict["water"] = 0 
                                    dict["waste"] = 0 
                                    dict["transport"] = 0 
                                    dict["human_experience"] = 0 
                                }else{
                                    var scores = (jsonDictionary["scores"]  as! NSDictionary).mutableCopy() as! NSMutableDictionary
                                    if(scores["energy"] == nil || scores["energy"] is NSNull){
                                        dict["energy"] = 0 
                                    }else{
                                        dict["energy"] = scores["energy"]
                                    }
                                    
                                    if(scores["water"] == nil || scores["water"] is NSNull){
                                        dict["water"] = 0 
                                    }else{
                                        dict["water"] = scores["water"]
                                    }
                                    
                                    if(scores["waste"] == nil || scores["waste"] is NSNull){
                                        dict["waste"] = 0 
                                    }else{
                                        dict["waste"] = scores["waste"]
                                    }
                                    
                                    if(scores["transport"] == nil || scores["transport"] is NSNull){
                                        dict["transport"] = 0 
                                    }else{
                                        dict["transport"] = scores["transport"]
                                    }
                                    
                                    if(scores["base"] == nil || scores["base"] is NSNull){
                                        dict["base"] = 0 
                                    }else{
                                        dict["base"] = scores["base"]
                                    }
                                    
                                    if(scores["human_experience"] == nil || scores["human_experience"] is NSNull){
                                        dict["human_experience"] = 0 
                                    }else{
                                        dict["human_experience"] = scores["human_experience"]
                                    }
                                }
                                DispatchQueue.main.async(execute: {
                                    self.watchsession.sendMessage(dict as! [String : Any], replyHandler: nil, errorHandler: { (error) -> Void in
                                        
                                    })
                                    do{
                                        try self.watchsession.updateApplicationContext(dict as! [String : Any])
                                    }catch{
                                        
                                    }
                                    
                                    
                                })
                            }
                            self.getmiddledata(subscription_key, leedid: leedid, date: date)
                        })
                        
                        
                    } catch {
                        //print(error)
                        DispatchQueue.main.async(execute: {
                            self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                            
                        })
                    }
            }
            
        }) 
        task.resume()
        
    }
    
    
    func getmiddledata(_ subscription_key:String, leedid: Int, date : String){
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.long
        formatter.dateFormat = "yyyy-MM-01"
        let dateString = formatter.string(from: Date())
        //print(dateString)
        let url = URL.init(string: String(format: "%@assets/LEED:%d/scores/?at=%@&within=1",credentials().domain_url,leedid,dateString))
        ////print(url?.absoluteURL)
        var token = UserDefaults.standard.object(forKey: "token") as! String
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(session)
        self.task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    if (error?._code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                    
                })
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401{
                DispatchQueue.main.async(execute: {
                    //self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    //self.spinner.hidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
                return
            } else
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                    DispatchQueue.main.async(execute: {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    })
                }else{
                    
                    let jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        //print(jsonDictionary)
                        let datakeyed = NSKeyedArchiver.archivedData(withRootObject: jsonDictionary)
                        UserDefaults.standard.set(datakeyed, forKey: "middle_data")
                        UserDefaults.standard.synchronize()
                        self.getinnerdata(subscription_key, leedid: leedid, date: date)
                    } catch {
                        //print(error)
                        DispatchQueue.main.async(execute: {
                            self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                            
                        })
                    }
            }
            
        }) 
        task.resume()
        
    }
    
    
    func getinnerdata(_ subscription_key:String, leedid: Int, date : String){
        let date = Date()
        let formatter = DateFormatter()
        let unitFlags: NSCalendar.Unit = [.hour, .day, .month, .year]
        var components = (Calendar.current as NSCalendar).components(unitFlags, from: date)
        components.year = components.year! - 1
        components.month = components.month! + 1
        let d = Calendar.current.date(from: components)
        formatter.dateFormat = "yyyy-MM-01"
        let datestring = formatter.string(from: d!)
        
        
        
        let url = URL.init(string: String(format: "%@assets/LEED:%d/scores/?at=%@&within=1",credentials().domain_url,leedid,datestring))
        ////print(url?.absoluteURL)
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        var token = UserDefaults.standard.object(forKey: "token") as! String
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(session)
        self.task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    if (error?._code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                    
                })
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401{
                DispatchQueue.main.async(execute: {
                    //self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    //self.spinner.hidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
                return
            } else
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                    DispatchQueue.main.async(execute: {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    })
                }else{
                    
                    let jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        //print(jsonDictionary)
                        let datakeyed = NSKeyedArchiver.archivedData(withRootObject: jsonDictionary)
                        UserDefaults.standard.set(datakeyed, forKey: "inner_data")
                        UserDefaults.standard.synchronize()
                        //self.buildingdetails(subscription_key, leedid: leedid)
                        self.getcomparablesdata(subscription_key, leedid: leedid)
                    } catch {
                        //print(error)
                        DispatchQueue.main.async(execute: {
                            self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                            
                        })
                    }
            }
            
        }) 
        task.resume()
        
    }
    
    
    func getcomparablesdata(_ subscription_key:String, leedid: Int){
        let url = URL.init(string: String(format: "%@comparables/",credentials().domain_url))
        ////print(url?.absoluteURL)
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        var token = UserDefaults.standard.object(forKey: "token") as! String
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(session)
        self.task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    if (error?._code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                })
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401{
                DispatchQueue.main.async(execute: {
                    //self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    //self.spinner.hidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
                return
            } else
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                    DispatchQueue.main.async(execute: {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }else{
                    
                    let jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        //print(jsonDictionary)
                        let datakeyed = NSKeyedArchiver.archivedData(withRootObject: jsonDictionary)
                        UserDefaults.standard.set(datakeyed, forKey: "comparable_data")
                        UserDefaults.standard.synchronize()
                        DispatchQueue.main.async(execute: {
                            //self.getnotifications(subscription_key,leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"))
                            //print("State = ",self.buildingdetails["state"])
                            if let s = self.buildingdetails["state"] as? String{
                                DispatchQueue.main.async(execute: {
                                    //print(s)
                                    if(s != ""){
                                        //print(String(format: "%@%@",self.buildingdetails["country"] as! String,s))
                                        let str = self.buildingdetails["country"] as! String
                                        let decimalCharacters = CharacterSet.decimalDigits
                                        
                                        let decimalRange = str.rangeOfCharacter(from: decimalCharacters, options: NSString.CompareOptions() , range: nil)
                                        
                                        if (decimalRange != nil){
                                            let datakeyed = NSKeyedArchiver.archivedData(withRootObject: self.emptydict)
                                            UserDefaults.standard.set(datakeyed, forKey: "local_comparable_data")
                                            UserDefaults.standard.synchronize()
                                            //self.getcomparablesdata(subscription_key, leedid: leedid)
                                            
                                            //Existing ARM APIs
                                            
                                        }else{
                                            //Existing ARM APIsself.getlocalcomparablesdata(subscription_key, leedid: leedid, state: String(format: "%@%@",jsonDictionary["country"] as! String,s))
                                            //self.performSegueWithIdentifier("gotodashboard", sender: nil)
                                         //self.getlocalcomparablesdata(subscription_key, leedid: leedid, state: String(format: "%@%@",self.buildingdetails["country"] as! String,s))
                                        }
                                    }else{
                                        let datakeyed = NSKeyedArchiver.archivedData(withRootObject: self.emptydict)
                                        UserDefaults.standard.set(datakeyed, forKey: "local_comparable_data")
                                        UserDefaults.standard.synchronize()
                                        //self.getcomparablesdata(subscription_key, leedid: leedid)
                                        //Existing ARM APIs
                                        //self.getlocalcomparablesdata(subscription_key, leedid: leedid, state: String(format: "%@%@",self.buildingdetails["country"] as! String,s))
                                    }
                                self.getlocalcomparablesdata(subscription_key, leedid: leedid, state: String(format: "%@%@",self.buildingdetails["country"] as! String,s))    
                                })
                                
                                
                            }else if let ss = self.buildingdetails["state"] as? Int{
                                DispatchQueue.main.async(execute: {
                                    var s = "\(ss as! Int)"
                                    //print(s)
                                    if(s != ""){
                                        //print(String(format: "%@%@",self.buildingdetails["country"] as! String,s))
                                        let str = self.buildingdetails["country"] as! String
                                        let decimalCharacters = CharacterSet.decimalDigits
                                        
                                        let decimalRange = str.rangeOfCharacter(from: decimalCharacters, options: NSString.CompareOptions() , range: nil)
                                        
                                        if (decimalRange != nil){
                                            let datakeyed = NSKeyedArchiver.archivedData(withRootObject: self.emptydict)
                                            UserDefaults.standard.set(datakeyed, forKey: "local_comparable_data")
                                            UserDefaults.standard.synchronize()
                                            //self.getcomparablesdata(subscription_key, leedid: leedid)
                                            
                                            //Existing ARM APIs
                                            
                                        }else{
                                            //Existing ARM APIsself.getlocalcomparablesdata(subscription_key, leedid: leedid, state: String(format: "%@%@",jsonDictionary["country"] as! String,s))
                                            //self.performSegueWithIdentifier("gotodashboard", sender: nil)
                                            //self.getlocalcomparablesdata(subscription_key, leedid: leedid, state: String(format: "%@%@",self.buildingdetails["country"] as! String,s))
                                        }
                                    }else{
                                        let datakeyed = NSKeyedArchiver.archivedData(withRootObject: self.emptydict)
                                        UserDefaults.standard.set(datakeyed, forKey: "local_comparable_data")
                                        UserDefaults.standard.synchronize()
                                        //self.getcomparablesdata(subscription_key, leedid: leedid)
                                        //Existing ARM APIs
                                        //self.getlocalcomparablesdata(subscription_key, leedid: leedid, state: String(format: "%@%@",self.buildingdetails["country"] as! String,s))
                                    }
                                    self.getlocalcomparablesdata(subscription_key, leedid: leedid, state: String(format: "%@%@",self.buildingdetails["country"] as! String,s))
                                })
                                
                                
                            }else{
                                let datakeyed = NSKeyedArchiver.archivedData(withRootObject: self.emptydict)
                                UserDefaults.standard.set(datakeyed, forKey: "local_comparable_data")
                                UserDefaults.standard.synchronize()
                                //self.getcomparablesdata(subscription_key, leedid: leedid)
                                //Existing ARM APIs
                            }
                            
                        })
                        
                    } catch {
                        //print(error)
                        DispatchQueue.main.async(execute: {
                            self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                            
                        })
                    }
            }
            
        }) 
        task.resume()
    }

    @IBOutlet weak var spinner: UIView!
    override func viewDidDisappear(_ animated: Bool) {
        DispatchQueue.main.async(execute: {
            for request in self.download_requests
            {
                request.invalidateAndCancel()
            }
        })
        
    }
    func getlocalcomparablesdata(_ subscription_key:String, leedid: Int, state: String){
        //print(state)
        let url = URL.init(string:"\(credentials().domain_url as String)comparables/?state=\(state)")
        ////print(url?.absoluteURL)
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        var token = UserDefaults.standard.object(forKey: "token") as! String
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(session)
        self.task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    if (error?._code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                })
                
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401{
                DispatchQueue.main.async(execute: {
                    //self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    //self.spinner.hidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
                return
            } else
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                    DispatchQueue.main.async(execute: {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }else{
                    
                    let jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        //print(jsonDictionary)
                        let datakeyed = NSKeyedArchiver.archivedData(withRootObject: jsonDictionary)
                        UserDefaults.standard.set(datakeyed, forKey: "local_comparable_data")
                        UserDefaults.standard.synchronize()
                        DispatchQueue.main.async(execute: {
                            self.spinner.isHidden = true
                            self.pageviewcontroller.view.isUserInteractionEnabled = true
                            //self.view.userInteractionEnabled = true
                            //make navigation bar unresponsive
                            if(self.navigationController != nil){
                            //self.navigationController!.view.userInteractionEnabled = true
                            }
                            //self.tabbar.userInteractionEnabled = true
                            if(self.download_requests.count > 0){
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "performrootsegue"), object: nil, userInfo: ["seguename":"plaque"])
                            }
                        })
                        
                    } catch {
                        //print(error)
                        DispatchQueue.main.async(execute: {
                            self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                            
                        })
                    }
            }
            
        }) 
        task.resume()
    }


    
    
    func wedid(){
        pgctrl.currentPage = 0
        buildingdetails = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        
        var dict = NSMutableDictionary()
        dict = buildingdetails
        
        if(UserDefaults.standard.object(forKey: "local_comparable_data") != nil && UserDefaults.standard.object(forKey: "comparable_data") != nil && UserDefaults.standard.object(forKey: "performance_data") != nil && UserDefaults.standard.object(forKey: "inner_data") != nil && UserDefaults.standard.object(forKey: "middle_data") != nil){
        
        if(UserDefaults.standard.object(forKey: "local_comparable_data") != nil){
        localavgdict = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "local_comparable_data") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        }
        
        if(UserDefaults.standard.object(forKey: "comparable_data") != nil){
        globalavgdict = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "comparable_data") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        }
        if(UserDefaults.standard.object(forKey: "performance_data") != nil){
        performance_data = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "performance_data") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        }else{
            let dte = Date()
            let dateformat = DateFormatter()
            dateformat.dateFormat = "yyyy-MM-dd"
            let datee = dateformat.string(from: dte)
            self.getperformancedata(credentials().subscription_key, leedid: dict["leed_id"] as! Int, date: datee)
        }
        
        if(UserDefaults.standard.object(forKey: "inner_data") != nil){
        if(UserDefaults.standard.object(forKey: "inner_data") != nil){
                innerdict = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "inner_data") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        }
        }
        
        if(UserDefaults.standard.object(forKey: "middle_data") != nil){
                middledict = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "middle_data") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        }
        }else{
            DispatchQueue.main.async(execute: {
            let dte = Date()
            let dateformat = DateFormatter()
            dateformat.dateFormat = "yyyy-MM-dd"
            let datee = dateformat.string(from: dte)
            self.spinner.isHidden = false
            self.pageviewcontroller.view.isUserInteractionEnabled = false
            //self.view.userInteractionEnabled = false
                //make navigation bar unresponsive
            if(self.navigationController != nil){
            //self.navigationController!.view.userInteractionEnabled = false
            }
            //self.tabbar.userInteractionEnabled = false
            self.getperformancedata(credentials().subscription_key, leedid: dict["leed_id"] as! Int, date: datee)
            })
        }
        
        //print("global local",globalavgdict,localavgdict)
        
        //assetname.text = dict["name"] as? String
        pageviewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "plaquepagevc") as! UIPageViewController
        pageviewcontroller.delegate = self
        pageviewcontroller.dataSource = self
        let startviewcontroller = self.viewcontrolleratIndex(currentindex)
        let viewcontrollers = [startviewcontroller]
        pageviewcontroller.setViewControllers(viewcontrollers, direction: .forward , animated: false, completion: nil)
        pageviewcontroller.view.frame.origin.x = 0
        pageviewcontroller.view.frame.origin.y = self.nav.frame.origin.y + self.nav.frame.size.height
        pageviewcontroller.view.frame.size.width = self.view.frame.size.width
        pageviewcontroller.view.frame.size.height = pgctrl.frame.origin.y
            //pageviewcontroller.view.frame.size.height - (pgctrl.frame.size.height +
        //self.view.frame.size.height - (0.13*self.view.frame.size.width)
        self.addChildViewController(pageviewcontroller)
        self.view.addSubview(pageviewcontroller.view)
        self.view.bringSubview(toFront: pgctrl)
        //self.view.bringSubviewToFront(topview)
        self.view.bringSubview(toFront: nav)
        self.view.bringSubview(toFront: self.tabbar)
        self.view.bringSubview(toFront: self.spinner)
        let navItem = UINavigationItem(title: (dict["name"] as? String)!);
        tabbar.delegate = self
        self.navigationItem.title = dict["name"] as? String
        self.nav.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!]
        let doneItem = UIBarButtonItem(title: "< Projects", style: .bordered, target: self, action: #selector(sayHello(_:)))
        navItem.leftBarButtonItem = doneItem;
        nav.setItems([navItem], animated: false);
        pageviewcontroller.didMove(toParentViewController: self)
        let notificationsarr = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "notifications") as! Data) as! NSArray
        let plaque = UIImage.init(named: "score")
        let credits = UIImage.init(named: "Menu_icon")
        let analytics = UIImage.init(named: "chart")
        let more = UIImage.init(named: "more")
        self.tabbar.setItems([UITabBarItem.init(title: "Score", image: plaque, tag: 0),UITabBarItem.init(title: "Credits/Actions", image: credits, tag: 1),UITabBarItem.init(title: "Analytics", image: analytics, tag: 2),UITabBarItem.init(title: "More", image: more, tag: 3)], animated: false)
        if(notificationsarr.count > 0 ){
        self.tabbar.items![3].badgeValue = "\(notificationsarr.count)"
        }else{
            self.tabbar.items![3].badgeValue = nil
        }
        self.tabbar.selectedItem = self.tabbar.items![0]
    }
    @IBOutlet weak var assetname: UILabel!
    
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var tabbar: UITabBar!
    
    func sayHello(_ sender: UIBarButtonItem) {
        //print("Projects clicked")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "performsegue"), object: nil, userInfo: ["seguename":"listofassets"])   
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pgctrl.pageIndicatorTintColor = UIColor.black
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.shouldRotate = false
        
        // 2. Force the device in landscape mode when the view controller gets loaded
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        watchsession.delegate = self
        self.spinner.isHidden = true
        self.pageviewcontroller.view.isUserInteractionEnabled = true
        self.spinner.layer.cornerRadius = 5
        self.titlefont()        
        wedid()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goback(_ sender: AnyObject) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "performsegue"), object: nil, userInfo: ["seguename":"listofassets"])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = 0
        if(viewController is overallplaque){
         index = (viewController as! overallplaque).pageIndex
        }else{
         index = (viewController as! individualplaque).pageIndex
        }
        if(index == NSNotFound){
            return nil
        }
        index = index + 1
        if(index == pageTitles.count){
            index = 0
        }
        if(index > 0){
            return individualviewcontrolleratIndex(index)
        }
        return viewcontrolleratIndex(index)
        
        
    }
    
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = 0
        if(viewController is overallplaque){
            index = (viewController as! overallplaque).pageIndex
        }else{
            index = (viewController as! individualplaque).pageIndex
        }
        
        if(index == NSNotFound){
            return nil
        }
        index = index - 1
        if(index < 0){
            index = pageTitles.count-1
        }
        if(index == 0){
            return viewcontrolleratIndex(index)
        }
        return individualviewcontrolleratIndex(index)
        
    }
    
    func viewcontrolleratIndex(_ index:Int) -> overallplaque {
        
        let overvall = self.storyboard?.instantiateViewController(withIdentifier: "overallplaque") as! overallplaque
        overvall.pageIndex = index
        ////print(imgarray[index])
        overvall.energyscorevalue = 14
        overvall.energymaxscorevalue = 20
        overvall.waterscorevalue = 12
        overvall.watermaxscorevalue = 20
        overvall.wastescorevalue = 1
        overvall.wastemaxscorevalue = 20
        overvall.transportscorevalue = 0
        overvall.transportmaxscorevalue = 20
        overvall.humanscorevalue = 17
        overvall.humanmaxscorevalue = 20
        var dict = performance_data
        var scores = NSDictionary()
        if(dict["scores"] != nil){
            scores = dict["scores"] as! NSDictionary
        }
        var maxima = NSDictionary()
        if(dict["maxima"] != nil){
            maxima = dict["maxima"] as! NSDictionary
        }
        if(dict["scores"] != nil){
            if(scores["energy"] != nil){
                if(scores["energy"] is NSNull){
                    overvall.energyscorevalue = 0
                }else{
                    overvall.energyscorevalue = scores["energy"] as! Int
                }
                
            }else{
                overvall.energyscorevalue = 0
            }
        }else{
            overvall.energyscorevalue = 0
        }
        
        if(dict["scores"] != nil){
            if(scores["water"] != nil){
                if(scores["water"] is NSNull){
                    overvall.waterscorevalue = 0
                }else{
                    overvall.waterscorevalue = scores["water"] as! Int
                }
            }else{
                overvall.waterscorevalue = 0
            }
        }else{
            overvall.waterscorevalue = 0
        }
        
        if(dict["scores"] != nil){
            if(scores["waste"] != nil){
                if(scores["waste"] is NSNull){
                    overvall.wastescorevalue = 0
                }else{
                    overvall.wastescorevalue = scores["waste"] as! Int
                }
            }else{
                overvall.wastescorevalue = 0
            }
        }else{
            overvall.wastescorevalue = 0
        }
        
        if(dict["scores"] != nil){
            if(scores["transport"] != nil){
                if(scores["transport"] is NSNull){
                    overvall.transportscorevalue = 0
                }else{
                    overvall.transportscorevalue = scores["transport"] as! Int
                }
            }else{
                overvall.transportscorevalue = 0
            }
        }else{
            overvall.transportscorevalue = 0
        }
      
        if(dict["scores"] != nil){
            if(scores["base"] != nil){
                if(scores["base"] is NSNull){
                    overvall.basescorevalue = 0
                }else{
                    overvall.basescorevalue = scores["base"] as! Int
                }
            }else{
                overvall.basescorevalue = 0
            }
        }else{
            overvall.basescorevalue = 0
        }
        
        
        if(dict["scores"] != nil){
            if(scores["human_experience"] != nil){
                if(scores["human_experience"] is NSNull){
                    overvall.humanscorevalue = 0
                }else{
                    overvall.humanscorevalue = scores["human_experience"] as! Int
                }
            }else{
                overvall.humanscorevalue = 0
            }
        }else{
            overvall.humanscorevalue = 0
        }
        
        var d = NSDictionary()
        if(dict["maxima"] != nil){
            d = dict["maxima"] as! NSDictionary
        }
        
            if(d["energy"] != nil){
                if(d["energy"] is NSNull){
                    overvall.energymaxscorevalue = 33
                }else{
                    overvall.energymaxscorevalue = d["energy"] as! Int
                }
            }else{
                overvall.energymaxscorevalue = 33
            }
        
        
        
        
        
        
            if(d["water"] != nil){
                if(d["water"] is NSNull){
                    overvall.watermaxscorevalue = 15
                }else{
                    overvall.watermaxscorevalue = d["water"] as! Int
                }
            }else{
                overvall.watermaxscorevalue = 15
            }
        
        if(dict["maxima"] != nil){
            if(d["waste"] != nil){
                if(d["waste"] is NSNull){
                    overvall.wastemaxscorevalue = 8
                }else{
                    overvall.wastemaxscorevalue = d["waste"] as! Int
                }
            }else{
                overvall.wastemaxscorevalue = 8
            }
        }else{
            overvall.wastemaxscorevalue = 8
        }
        
        if(dict["maxima"] != nil){
            if(d["transport"] != nil){
                if(d["transport"] is NSNull){
                    overvall.transportmaxscorevalue = 14
                }else{
                    overvall.transportmaxscorevalue = d["transport"] as! Int
                }
            }else{
                overvall.transportmaxscorevalue = 14
            }
        }else{
            overvall.transportmaxscorevalue = 14
        }
        
        
        if(dict["maxima"] != nil){
            if(d["human_experience"] != nil){
                if(d["human_experience"] is NSNull){
                    overvall.humanmaxscorevalue = 20
                }else{
                    overvall.humanmaxscorevalue = d["human_experience"] as! Int
                }
            }else{
                overvall.humanmaxscorevalue = 20
            }
        }else{
            overvall.humanmaxscorevalue = 20
        }
        
        
        //pgctrl.currentPage = presentationIndexForPageViewController(self.pageviewcontroller)
        return overvall
        
    }
    
    func individualviewcontrolleratIndex(_ index:Int) -> individualplaque {
        
        let overvall = self.storyboard?.instantiateViewController(withIdentifier: "individualplaque") as! individualplaque
        overvall.pageIndex = index
        overvall.localavgscorevalue = 20
        overvall.globalavgscorevalue = 20
        overvall.outerscorevalue = 10
        overvall.outermaxscorevalue = 30
        overvall.middlescorevalue = 15
        overvall.middlemaxscorevalue = 20
        overvall.innerscorevalue = 0
        overvall.innermaxscorevalue = 20
        var dict = performance_data
        var middlescores = NSDictionary()
        if(middledict["scores"] != nil){
            middlescores = middledict["scores"] as! NSDictionary
        }
        var innerscores = NSDictionary()
        if(middledict["scores"] != nil){
            middlescores = middledict["scores"] as! NSDictionary
        }
        
        var middlemaxima = NSDictionary()
        if(middlemaxima["scores"] != nil){
            middlemaxima = middledict["scores"] as! NSDictionary
        }
        
        var innermaxima = NSDictionary()
        if(innermaxima["maxima"] != nil){
            innermaxima = innerdict["maxima"] as! NSDictionary
        }
        
        if(index == 1){
            overvall.innerstroke = UIColor(red:0.898, green: 0.931, blue:0.56, alpha:1)
            overvall.context1value = "CURRENT"
            overvall.context2value = " Electricity \n Gas \n Smart meters \n Load schedule"
            overvall.plaqueimg = UIImage.init(named: "edited_energy")!
            overvall.strokecolor =  UIColor(red:0.776, green: 0.858, blue:0.124, alpha:1)
            overvall.titlevalue = "\nCURRENT ENERGY"
            var scores = NSDictionary()
            if(performance_data["scores"] != nil){
                scores = performance_data["scores"] as! NSDictionary
            }
            if(dict["scores"] != nil){
                if(scores["energy"] != nil){
                    if(scores["energy"] is NSNull){
                        overvall.outerscorevalue = 0
                    }else{
                        overvall.outerscorevalue = scores["energy"] as! Int
                    }
                    
                }else{
                    overvall.outerscorevalue = 0
                }
            }else{
                overvall.outerscorevalue = 0
            }
            //print(middledict)
            if(middledict["scores"] != nil){
                if(middlescores["energy"] != nil){
                    if(middlescores["energy"] is NSNull){
                        overvall.middlescorevalue = 0
                    }else{
                        overvall.middlescorevalue = middlescores["energy"] as! Int
                    }
                    
                }else{
                    overvall.middlescorevalue = 0
                }
            }else{
                overvall.middlescorevalue = 0
            }
            
            if(innerdict["scores"] != nil){
                if(innerscores["energy"] != nil){
                    if(innerscores["energy"] is NSNull){
                        overvall.innerscorevalue = 0
                    }else{
                        overvall.innerscorevalue = innerscores["energy"] as! Int
                    }
                    
                }else{
                    overvall.innerscorevalue = 0
                }
            }else{
                overvall.innerscorevalue = 0
            }
            
            overvall.localavgscorevalue = 0
            overvall.globalavgscorevalue = 0
            if(globalavgdict["energy_avg"] == nil || globalavgdict["energy_avg"] is NSNull){
                overvall.globalavgscorevalue = 0
            }else{
                overvall.globalavgscorevalue = globalavgdict["energy_avg"] as! Int
            }
            if(localavgdict["energy_avg"] == nil || localavgdict["energy_avg"] is NSNull){
                overvall.localavgscorevalue = 0
            }else{
                overvall.localavgscorevalue = localavgdict["energy_avg"] as! Int
            }
            scores = dict["maxima"] as! NSDictionary
                if(scores["energy"] != nil){
                    if(scores["energy"] is NSNull){
                        overvall.outermaxscorevalue = 33
                    }else{
                        overvall.outermaxscorevalue = scores["energy"] as! Int
                    }
                }else{
                    overvall.outermaxscorevalue = 33
                }
            
            
            if(middledict["maxima"] != nil){
                if(middlemaxima["energy"] != nil){
                    if(middlemaxima["energy"] is NSNull){
                        overvall.middlemaxscorevalue = 33
                    }else{
                        overvall.middlemaxscorevalue = middlemaxima["energy"] as! Int
                    }
                }else{
                    overvall.middlemaxscorevalue = 33
                }
            }else{
                overvall.middlemaxscorevalue = 33
            }
            
            if(innerdict["maxima"] != nil){
                if(innermaxima["energy"] != nil){
                    if(innermaxima["energy"] is NSNull){
                        overvall.innermaxscorevalue = 33
                    }else{
                        overvall.innermaxscorevalue = innermaxima["energy"] as! Int
                    }
                }else{
                    overvall.innermaxscorevalue = 33
                }
            }else{
                overvall.innermaxscorevalue = 33
            }
        }else if(index == 2){
            overvall.innerstroke =  UIColor(red:0.703, green: 0.909, blue:0.989, alpha:1)
            overvall.context1value = "CURRENT"
            overvall.context2value = " Water consumption"
            overvall.plaqueimg = UIImage.init(named: "edited_water")!
            overvall.strokecolor = UIColor(red:0.323, green: 0.755, blue:0.93, alpha:1)
            overvall.titlevalue = "\nCURRENT WATER"
            if(middledict["scores"] != nil){
                if(middlescores["water"] != nil){
                    if(middlescores["water"] is NSNull){
                        overvall.middlescorevalue = 0
                    }else{
                        overvall.middlescorevalue = middlescores["water"] as! Int
                    }
                    
                }else{
                    overvall.middlescorevalue = 0
                }
            }else{
                overvall.middlescorevalue = 0
            }
            
            if(innerdict["scores"] != nil){
                if(innerscores["water"] != nil){
                    if(innerscores["water"] is NSNull){
                        overvall.innerscorevalue = 0
                    }else{
                        overvall.innerscorevalue = innerscores["water"] as! Int
                    }
                    
                }else{
                    overvall.innerscorevalue = 0
                }
            }else{
                overvall.innerscorevalue = 0
            }
            var d = NSDictionary()
            if(dict ["scores"] != nil){
                d = dict ["scores"] as! NSDictionary
            }
            if(dict["scores"] != nil){
                if(d["water"] != nil){
                    if(d["water"] is NSNull){
                        overvall.outerscorevalue = 0
                    }else{
                        overvall.outerscorevalue = d["water"] as! Int
                    }
                }else{
                    overvall.outerscorevalue = 0
                }
            }else{
                overvall.outerscorevalue = 0
            }

            overvall.localavgscorevalue = 0
            if(localavgdict["water_avg"] == nil || localavgdict["water_avg"] is NSNull){
                overvall.localavgscorevalue = 0
            }else{
                overvall.localavgscorevalue = localavgdict["water_avg"] as! Int
            }
            overvall.globalavgscorevalue = 0
            if(globalavgdict["water_avg"] == nil || globalavgdict["water_avg"] is NSNull){
                overvall.globalavgscorevalue = 0
            }else{
                overvall.globalavgscorevalue = globalavgdict["water_avg"] as! Int
            }
            d = dict ["maxima"] as! NSDictionary
            if(dict["maxima"] != nil){
                if(d["water"] != nil){
                    if(d["water"] is NSNull){
                        overvall.outermaxscorevalue = 15
                    }else{
                        overvall.outermaxscorevalue = d["water"] as! Int
                    }
                }else{
                    overvall.outermaxscorevalue = 15
                }
            }else{
                overvall.outermaxscorevalue = 15
            }
            
            if(middledict["maxima"] != nil){
                if(middlemaxima["water"] != nil){
                    if(middlemaxima["water"] is NSNull){
                        overvall.middlemaxscorevalue = 15
                    }else{
                        overvall.middlemaxscorevalue = middlemaxima["water"] as! Int
                    }
                }else{
                    overvall.middlemaxscorevalue = 15
                }
            }else{
                overvall.middlemaxscorevalue = 15
            }
            
            if(innerdict["maxima"] != nil){
                if(innermaxima["water"] != nil){
                    if(innermaxima["water"] is NSNull){
                        overvall.innermaxscorevalue = 15
                    }else{
                        overvall.innermaxscorevalue = innermaxima["water"] as! Int
                    }
                }else{
                    overvall.innermaxscorevalue = 15
                }
            }else{
                overvall.innermaxscorevalue = 15
            }
            
        }else if(index == 3){
            
            overvall.innerstroke = UIColor(red:0.797, green: 0.919, blue:0.87, alpha:1)
            overvall.context1value = "CURRENT"
            overvall.context2value = " Waste generated \n Waste diverted"
            overvall.plaqueimg = UIImage.init(named: "edited_waste")!
            overvall.strokecolor =  UIColor(red:0.465, green: 0.756, blue:0.629, alpha:1)
            overvall.titlevalue = "\nCURRENT WASTE"
            if(middledict["scores"] != nil){
                if(middlescores["waste"] != nil){
                    if(middlescores["waste"] is NSNull){
                        overvall.middlescorevalue = 0
                    }else{
                        overvall.middlescorevalue = middlescores["waste"] as! Int
                    }
                    
                }else{
                    overvall.middlescorevalue = 0
                }
            }else{
                overvall.middlescorevalue = 0
            }
            
            if(innerdict["scores"] != nil){
                if(innerscores["waste"] != nil){
                    if(innerscores["waste"] is NSNull){
                        overvall.innerscorevalue = 0
                    }else{
                        overvall.innerscorevalue = innerscores["waste"] as! Int
                    }
                    
                }else{
                    overvall.innerscorevalue = 0
                }
            }else{
                overvall.innerscorevalue = 0
            }
            

            var d = NSDictionary()
            if(dict ["scores"] != nil){
                d = dict ["scores"] as! NSDictionary
            }
            if(dict["scores"] != nil){
                if(d["waste"] != nil){
                    if(d["waste"] is NSNull){
                        overvall.outerscorevalue = 0
                    }else{
                        overvall.outerscorevalue = d["waste"] as! Int
                    }
                }else{
                    overvall.outerscorevalue = 0
                }
            }else{
                overvall.outerscorevalue = 0
            }

            overvall.localavgscorevalue = 0
            if(localavgdict["waste_avg"] == nil || localavgdict["waste_avg"] is NSNull){
                overvall.localavgscorevalue = 0
            }else{
                overvall.localavgscorevalue = localavgdict["waste_avg"] as! Int
            }
            overvall.globalavgscorevalue = 0
            if(globalavgdict["waste_avg"] == nil || globalavgdict["waste_avg"] is NSNull){
                overvall.globalavgscorevalue = 0
            }else{
                overvall.globalavgscorevalue = globalavgdict["waste_avg"] as! Int
            }
             d = dict ["maxima"] as! NSDictionary
            if(dict["maxima"] != nil){
                if(d["waste"] != nil){
                    if(d["waste"] is NSNull){
                        overvall.outermaxscorevalue = 8
                    }else{
                        overvall.outermaxscorevalue = d["waste"] as! Int
                    }
                }else{
                    overvall.outermaxscorevalue = 8
                }
            }else{
                overvall.outermaxscorevalue = 8
            }
            
            if(middledict["maxima"] != nil){
                if(middlemaxima["waste"] != nil){
                    if(middlemaxima["waste"] is NSNull){
                        overvall.middlemaxscorevalue = 8
                    }else{
                        overvall.middlemaxscorevalue = middlemaxima["waste"] as! Int
                    }
                }else{
                    overvall.middlemaxscorevalue = 8
                }
            }else{
                overvall.middlemaxscorevalue = 8
            }
            
            if(innerdict["maxima"] != nil){
                if(innermaxima["waste"] != nil){
                    if(innermaxima["waste"] is NSNull){
                        overvall.innermaxscorevalue = 8
                    }else{
                        overvall.innermaxscorevalue = innermaxima["waste"] as! Int
                    }
                }else{
                    overvall.innermaxscorevalue = 8
                }
            }else{
                overvall.innermaxscorevalue = 8
            }
            
        }else if(index == 4){
            overvall.innerstroke = UIColor(red:0.716, green: 0.7, blue:0.629, alpha:1)
            overvall.context1value = "CURRENT"
            overvall.context2value = " Occupant travel"
            overvall.plaqueimg = UIImage.init(named: "edited_transport")!
            overvall.strokecolor = UIColor(red:0.573, green: 0.557, blue:0.498, alpha:1)
            overvall.titlevalue = "\nCURRENT TRANSPORTATION"
            if(middledict["scores"] != nil){
                if(middlescores["transport"] != nil){
                    if(middlescores["transport"] is NSNull){
                        overvall.middlescorevalue = 0
                    }else{
                        overvall.middlescorevalue = middlescores["transport"] as! Int
                    }
                    
                }else{
                    overvall.middlescorevalue = 0
                }
            }else{
                overvall.middlescorevalue = 0
            }
            
            if(innerdict["scores"] != nil){
                if(innerscores["transport"] != nil){
                    if(innerscores["transport"] is NSNull){
                        overvall.innerscorevalue = 0
                    }else{
                        overvall.innerscorevalue = innerscores["transport"] as! Int
                    }
                    
                }else{
                    overvall.innerscorevalue = 0
                }
            }else{
                overvall.innerscorevalue = 0
            }
            

            var d = NSDictionary()
            if(dict ["scores"] != nil){
                d = dict ["scores"] as! NSDictionary
            }
            if(dict["scores"] != nil){
                if(d["transport"] != nil){
                    if(d["transport"] is NSNull){
                        overvall.outerscorevalue = 0
                    }else{
                        overvall.outerscorevalue = d["transport"] as! Int
                    }
                }else{
                    overvall.outerscorevalue = 0
                }
            }else{
                overvall.outerscorevalue = 0
            }
            overvall.localavgscorevalue = 0
            if(localavgdict["transport_avg"] == nil || localavgdict["transport_avg"] is NSNull){
                overvall.localavgscorevalue = 0
            }else{
                overvall.localavgscorevalue = localavgdict["water_avg"] as! Int
            }
            overvall.globalavgscorevalue = 0
            if(globalavgdict["transport_avg"] == nil || globalavgdict["transport_avg"] is NSNull){
                overvall.globalavgscorevalue = 0
            }else{
                overvall.globalavgscorevalue = globalavgdict["transport_avg"] as! Int
            }
            d = dict ["maxima"] as! NSDictionary
            if(dict["maxima"] != nil){
                if(d["transport"] != nil){
                    if(d["transport"] is NSNull){
                        overvall.outermaxscorevalue = 14
                    }else{
                        overvall.outermaxscorevalue = d["transport"] as! Int
                    }
                }else{
                    overvall.outermaxscorevalue = 14
                }
            }else{
                overvall.outermaxscorevalue = 14
            }
            
            if(middledict["maxima"] != nil){
                if(middlemaxima["transport"] != nil){
                    if(middlemaxima["transport"] is NSNull){
                        overvall.middlemaxscorevalue = 14
                    }else{
                        overvall.middlemaxscorevalue = middlemaxima["transport"] as! Int
                    }
                }else{
                    overvall.middlemaxscorevalue = 14
                }
            }else{
                overvall.middlemaxscorevalue = 14
            }
            
            if(innerdict["maxima"] != nil){
                if(innermaxima["transport"] != nil){
                    if(innermaxima["transport"] is NSNull){
                        overvall.innermaxscorevalue = 14
                    }else{
                        overvall.innermaxscorevalue = innermaxima["transport"] as! Int
                    }
                }else{
                    overvall.innermaxscorevalue = 14
                }
            }else{
                overvall.innermaxscorevalue = 14
            }
            
        }else if(index == 5){
            
            overvall.innerstroke = UIColor(red:0.98, green: 0.842, blue:0.614, alpha:1)
            overvall.context1value = "CURRENT"
            overvall.context2value = " CO2 levels \n VOC levels \n Occupant satisfaction"
            overvall.plaqueimg = UIImage.init(named: "edited_human")!
            overvall.strokecolor = UIColor(red:0.909, green: 0.602, blue:0.268, alpha:1)
            overvall.titlevalue = "\nCURRENT HUMAN\n EXPERIENCE"
            if(middledict["scores"] != nil){
                if(middlescores["human_experience"] != nil){
                    if(middlescores["human_experience"] is NSNull){
                        overvall.middlescorevalue = 0
                    }else{
                        overvall.middlescorevalue = middlescores["human_experience"] as! Int
                    }
                    
                }else{
                    overvall.middlescorevalue = 0
                }
            }else{
                overvall.middlescorevalue = 0
            }
            
            if(innerdict["scores"] != nil){
                if(innerscores["human_experience"] != nil){
                    if(innerscores["human_experience"] is NSNull){
                        overvall.innerscorevalue = 0
                    }else{
                        overvall.innerscorevalue = innerscores["human_experience"] as! Int
                    }
                    
                }else{
                    overvall.innerscorevalue = 0
                }
            }else{
                overvall.innerscorevalue = 0
            }
            

            var d = NSDictionary()
            if(dict ["scores"] != nil){
                d = dict ["scores"] as! NSDictionary
            }
            
            if(dict["scores"] != nil){
                if(d["human_experience"] != nil){
                    if(d["human_experience"] is NSNull){
                        overvall.outerscorevalue = 0
                    }else{
                        overvall.outerscorevalue = d["human_experience"] as! Int
                    }
                }else{
                    overvall.outerscorevalue = 0
                }
            }else{
                overvall.outerscorevalue = 0
            }
            overvall.localavgscorevalue = 0
            if(localavgdict["human_experience_avg"] == nil || localavgdict["human_experience_avg"] is NSNull){
                overvall.localavgscorevalue = 0
            }else{
                overvall.localavgscorevalue = localavgdict["human_experience_avg"] as! Int
            }
            overvall.globalavgscorevalue = 0
            if(globalavgdict["human_experience_avg"] == nil || globalavgdict["human_experience_avg"] is NSNull){
                overvall.globalavgscorevalue = 0
            }else{
                overvall.globalavgscorevalue = globalavgdict["human_experience_avg"] as! Int
            }
            if(dict ["scores"] != nil){
            d = dict ["scores"] as! NSDictionary
            }
            if(dict["maxima"] != nil){
                if(d["human_experience"] != nil){
                    if(d["human_experience"] is NSNull){
                        overvall.outermaxscorevalue = 20
                    }else{
                        overvall.outermaxscorevalue = d["human_experience"] as! Int
                    }
                }else{
                    overvall.outermaxscorevalue = 20
                }
            }else{
                overvall.outermaxscorevalue = 20
            }
            
            if(middledict["maxima"] != nil){
                if(middlemaxima["human_experience"] != nil){
                    if(middlemaxima["human_experience"] is NSNull){
                        overvall.middlemaxscorevalue = 20
                    }else{
                        overvall.middlemaxscorevalue = middlemaxima["human_experience"] as! Int
                    }
                }else{
                    overvall.middlemaxscorevalue = 20
                }
            }else{
                overvall.middlemaxscorevalue = 20
            }
            
            if(innerdict["maxima"] != nil){
                if(innermaxima["human_experience"] != nil){
                    if(innermaxima["human_experience"] is NSNull){
                        overvall.innermaxscorevalue = 20
                    }else{
                        overvall.innermaxscorevalue = innermaxima["human_experience"] as! Int
                    }
                }else{
                    overvall.innermaxscorevalue = 20
                }
            }else{
                overvall.innermaxscorevalue = 20
            }
        }
        
        //pgctrl.currentPage = presentationIndexForPageViewController(self.pageviewcontroller)
        return overvall
        
    }
    
    @IBOutlet weak var skipbtn: UIButton!
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}
