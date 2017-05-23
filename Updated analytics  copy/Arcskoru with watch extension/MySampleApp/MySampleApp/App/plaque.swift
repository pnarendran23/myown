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
    var watchsession = WCSession.defaultSession()
    var emptydict = ["count": 1,"created_at_max": "2016-12-30T14:02:41.260478Z","created_at_min": "2016-12-30T14:02:41.260478Z","energy_avg": 0,"water_avg": 0,"waste_avg": 0,"transport_avg": 0,"base_avg": 0,"human_experience_avg": 0]
    var localavgdict = [String:AnyObject]()
    var globalavgdict = [String:AnyObject]()
    var performance_data = [String:AnyObject]()
    var pageTitles = ["Explore buildings","Analysing projects","Astonishing performance scores animation","Calculating scores", "Organize submission data","Activity feed"]
    @IBOutlet weak var nav: UINavigationBar!
    
    var contentarray = ["Access and get information about any of your building in a finger tip from anywhere","Get the LEED performance score of the building which you want","Analyse your building performance score to get a better score and also to know, what's really affecting your score.","Calculate your emissions and their scores relfection in a single move.","Check who does that and who needs to do what for your building","Check for the status of the submitted data", "Get instant notifications about your building about its data and certification."]
    var imgarray = [UIImage(named: ("list of buildings")),UIImage(named: ("plaque")),UIImage(named: ("analytics")),UIImage(named: ("calculate")),UIImage(named: ("organize")), UIImage(named: ("notifications"))]
    var innerdict = [String:AnyObject]()
    var middledict = [String:AnyObject]()
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        indicator = self.view.viewWithTag(90) as! UIPageControl
        pgctrl.numberOfPages = 6
        pgctrl.userInteractionEnabled = false
        wedid()
        return [.Portrait ,.PortraitUpsideDown]
    }
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.backItem?.title = "Projects"
    }
    var buildingdetails = [String:AnyObject]()
    override func viewWillDisappear(animated: Bool) {
        for request in download_requests
        {
            request.invalidateAndCancel()
        }
         buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        self.navigationItem.title = buildingdetails["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as? String
            //stop all download requests
            for request in download_requests
            {
                request.invalidateAndCancel()
            }
            if (WCSession.isSupported()) {
                watchsession.delegate = nil;
            }
        
    }
    
    func sessionDidDeactivate(session: WCSession) {
    
    }
    
    func sessionDidBecomeInactive(session: WCSession) {
        
    }
    
    @available(iOS 9.3, *)
    func session(session: WCSession, activationDidCompleteWithState activationState: WCSessionActivationState, error: NSError?) {
        
    }
    
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if(item.title == "Score"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"plaque"])
            NSNotificationCenter.defaultCenter().postNotificationName("performrootsegue", object: nil, userInfo: ["seguename":"plaque"])
        }else if(item.title == "Analytics"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"beforeanalytics"])
            NSNotificationCenter.defaultCenter().postNotificationName("performrootsegue", object: nil, userInfo: ["seguename":"totalanalysis"])
        }else if(item.title == "Manage"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"manage"])
            NSNotificationCenter.defaultCenter().postNotificationName("performrootsegue", object: nil, userInfo: ["seguename":"manage"])
                
        }else if(item.title == "More"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"more"])
            NSNotificationCenter.defaultCenter().postNotificationName("performrootsegue", object: nil, userInfo: ["seguename":"more"])
        }else if(item.title == "Credits/Actions"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"listofactions"])
            NSNotificationCenter.defaultCenter().postNotificationName("performrootsegue", object: nil, userInfo: ["seguename":"listofactions"])
        }
    }

    
    
    var pageviewcontroller = UIPageViewController()
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if(pageViewController.viewControllers?.first is overallplaque){
            let p = pageViewController.viewControllers?.first as! overallplaque
            currentindex = p.pageIndex
            print("Presented index",p.pageIndex)
            pgctrl.currentPage = p.pageIndex
        }else if(pageViewController.viewControllers?.first is individualplaque){
            let p = pageViewController.viewControllers?.first as! individualplaque
            print("Presented index",p.pageIndex)
            currentindex = p.pageIndex
            pgctrl.currentPage = p.pageIndex
        }else{
            pgctrl.currentPage = 0
        }
        
        if(currentindex == 0){
            pgctrl.currentPageIndicatorTintColor = UIColor.blueColor()
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
    var task = NSURLSessionTask()
    var download_requests = [NSURLSession]()
    
    func showalert(message:String, title:String, action:String){
        
        //let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        //let callActionHandler = { (action:UIAlertAction!) -> Void in
        dispatch_async(dispatch_get_main_queue(), {
            //self.view.userInteractionEnabled = true
            //self.spinner.hidden = true
            self.view.userInteractionEnabled = true
            self.maketoast(message, type: "error")
            //self.navigationController?.popViewControllerAnimated(true)
        })
        
        //        }
        //      let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        //    alertController.addAction(defaultAction)
        
        //presentViewController(alertController, animated: true, completion: nil)
        
        
    }

    func getperformancedata(subscription_key:String, leedid: Int, date : String){
        let url = NSURL.init(string: String(format: "%@assets/LEED:%d/scores/",credentials().domain_url,leedid))
        print(url?.absoluteURL)
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                if (error?.code == -999){
                    
                }else{
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                }
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401{
                dispatch_async(dispatch_get_main_queue(), {
                    //self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    //self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                })
                return
            } else
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    })
                }else{
                    print(data)
                    let jsonDictionary : NSMutableDictionary
                    do {
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()).mutableCopy() as! NSMutableDictionary
                        print(jsonDictionary)
                        let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                        if(jsonDictionary["scores"] != nil){
                        NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "performance_data")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        }else{
                            let temp = NSMutableDictionary()
                            temp["energy"] = 33
                            temp["base"] = 10
                            temp["water"] = 15
                            temp["waste"] = 8
                            temp["transport"] = 14
                            temp["human_experience"] = 20
                            jsonDictionary["maxima"] = temp
                            let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                                NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "performance_data")
                                NSUserDefaults.standardUserDefaults().synchronize()
                        }
                        dispatch_async(dispatch_get_main_queue(), {() -> Void in
                            if WCSession.isSupported() {
                                var dict = [String:AnyObject]()
                                if(jsonDictionary["scores"] == nil){
                                    dict["energy"] = 0
                                    dict["base"] = 0
                                    dict["water"] = 0
                                    dict["waste"] = 0
                                    dict["transport"] = 0
                                    dict["human_experience"] = 0
                                }else{
                                    var scores = jsonDictionary["scores"] as! [String:AnyObject]
                                    if(scores["energy"] == nil || scores["energy"] is NSNull){
                                        dict["energy"] = 0
                                    }else{
                                        dict["energy"] = scores["energy"] as! Int
                                    }
                                    
                                    if(scores["water"] == nil || scores["water"] is NSNull){
                                        dict["water"] = 0
                                    }else{
                                        dict["water"] = scores["water"] as! Int
                                    }
                                    
                                    if(scores["waste"] == nil || scores["waste"] is NSNull){
                                        dict["waste"] = 0
                                    }else{
                                        dict["waste"] = scores["waste"] as! Int
                                    }
                                    
                                    if(scores["transport"] == nil || scores["transport"] is NSNull){
                                        dict["transport"] = 0
                                    }else{
                                        dict["transport"] = scores["transport"] as! Int
                                    }
                                    
                                    if(scores["base"] == nil || scores["base"] is NSNull){
                                        dict["base"] = 0
                                    }else{
                                        dict["base"] = scores["base"] as! Int
                                    }
                                    
                                    if(scores["human_experience"] == nil || scores["human_experience"] is NSNull){
                                        dict["human_experience"] = 0
                                    }else{
                                        dict["human_experience"] = scores["human_experience"] as! Int
                                    }
                                }
                                dispatch_async(dispatch_get_main_queue(),{
                                    self.watchsession.sendMessage(dict, replyHandler: nil, errorHandler: { (error) -> Void in
                                        
                                    })
                                    do{
                                        try self.watchsession.updateApplicationContext(dict)
                                    }catch{
                                        
                                    }
                                    
                                    
                                })
                            }
                            self.getmiddledata(subscription_key, leedid: leedid, date: date)
                        })
                        
                        
                    } catch {
                        print(error)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                            
                        })
                    }
            }
            
        }
        task.resume()
        
    }
    
    
    func getmiddledata(subscription_key:String, leedid: Int, date : String){
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.dateFormat = "yyyy-MM-01"
        let dateString = formatter.stringFromDate(NSDate())
        print(dateString)
        let url = NSURL.init(string: String(format: "%@assets/LEED:%d/scores/?at=%@&within=1",credentials().domain_url,leedid,dateString))
        print(url?.absoluteURL)
        var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    if (error?.code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                    
                })
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401{
                dispatch_async(dispatch_get_main_queue(), {
                    //self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    //self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                })
                return
            } else
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    })
                }else{
                    print(data)
                    let jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        print(jsonDictionary)
                        let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                        NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "middle_data")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        self.getinnerdata(subscription_key, leedid: leedid, date: date)
                    } catch {
                        print(error)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                            
                        })
                    }
            }
            
        }
        task.resume()
        
    }
    
    
    func getinnerdata(subscription_key:String, leedid: Int, date : String){
        let date = NSDate()
        let formatter = NSDateFormatter()
        let unitFlags: NSCalendarUnit = [.Hour, .Day, .Month, .Year]
        let components = NSCalendar.currentCalendar().components(unitFlags, fromDate: date)
        components.year = components.year - 1
        components.month = components.month + 1
        let d = NSCalendar.currentCalendar().dateFromComponents(components)
        formatter.dateFormat = "yyyy-MM-01"
        let datestring = formatter.stringFromDate(d!)
        
        
        
        let url = NSURL.init(string: String(format: "%@assets/LEED:%d/scores/?at=%@&within=1",credentials().domain_url,leedid,datestring))
        print(url?.absoluteURL)
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    if (error?.code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                    
                })
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401{
                dispatch_async(dispatch_get_main_queue(), {
                    //self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    //self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                })
                return
            } else
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    })
                }else{
                    print(data)
                    let jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        print(jsonDictionary)
                        let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                        NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "inner_data")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        //self.buildingdetails(subscription_key, leedid: leedid)
                        self.getcomparablesdata(subscription_key, leedid: leedid)
                    } catch {
                        print(error)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                            
                        })
                    }
            }
            
        }
        task.resume()
        
    }
    
    
    func getcomparablesdata(subscription_key:String, leedid: Int){
        let url = NSURL.init(string: String(format: "%@comparables/",credentials().domain_url))
        print(url?.absoluteURL)
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    if (error?.code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                })
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401{
                dispatch_async(dispatch_get_main_queue(), {
                    //self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    //self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                })
                return
            } else
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }else{
                    print(data)
                    let jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        print(jsonDictionary)
                        let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                        NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "comparable_data")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        dispatch_async(dispatch_get_main_queue(), {
                            //self.getnotifications(subscription_key,leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"))
                            print("State = ",self.buildingdetails["state"])
                            if let s = self.buildingdetails["state"] as? String{
                                dispatch_async(dispatch_get_main_queue(), {
                                    print(s)
                                    if(s != ""){
                                        print(String(format: "%@%@",self.buildingdetails["country"] as! String,s))
                                        let str = self.buildingdetails["country"] as! String
                                        let decimalCharacters = NSCharacterSet.decimalDigitCharacterSet()
                                        
                                        let decimalRange = str.rangeOfCharacterFromSet(decimalCharacters, options: NSStringCompareOptions() , range: nil)
                                        
                                        if (decimalRange != nil){
                                            let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(self.emptydict)
                                            NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "local_comparable_data")
                                            NSUserDefaults.standardUserDefaults().synchronize()
                                            //self.getcomparablesdata(subscription_key, leedid: leedid)
                                            
                                            //Existing ARM APIs
                                            
                                        }else{
                                            //Existing ARM APIsself.getlocalcomparablesdata(subscription_key, leedid: leedid, state: String(format: "%@%@",jsonDictionary["country"] as! String,s))
                                            //self.performSegueWithIdentifier("gotodashboard", sender: nil)
                                         //self.getlocalcomparablesdata(subscription_key, leedid: leedid, state: String(format: "%@%@",self.buildingdetails["country"] as! String,s))
                                        }
                                    }else{
                                        let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(self.emptydict)
                                        NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "local_comparable_data")
                                        NSUserDefaults.standardUserDefaults().synchronize()
                                        //self.getcomparablesdata(subscription_key, leedid: leedid)
                                        //Existing ARM APIs
                                        //self.getlocalcomparablesdata(subscription_key, leedid: leedid, state: String(format: "%@%@",self.buildingdetails["country"] as! String,s))
                                    }
                                self.getlocalcomparablesdata(subscription_key, leedid: leedid, state: String(format: "%@%@",self.buildingdetails["country"] as! String,s))    
                                })
                                
                                
                            }else if let ss = self.buildingdetails["state"] as? Int{
                                dispatch_async(dispatch_get_main_queue(), {
                                    var s = "\(ss as! Int)"
                                    print(s)
                                    if(s != ""){
                                        print(String(format: "%@%@",self.buildingdetails["country"] as! String,s))
                                        let str = self.buildingdetails["country"] as! String
                                        let decimalCharacters = NSCharacterSet.decimalDigitCharacterSet()
                                        
                                        let decimalRange = str.rangeOfCharacterFromSet(decimalCharacters, options: NSStringCompareOptions() , range: nil)
                                        
                                        if (decimalRange != nil){
                                            let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(self.emptydict)
                                            NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "local_comparable_data")
                                            NSUserDefaults.standardUserDefaults().synchronize()
                                            //self.getcomparablesdata(subscription_key, leedid: leedid)
                                            
                                            //Existing ARM APIs
                                            
                                        }else{
                                            //Existing ARM APIsself.getlocalcomparablesdata(subscription_key, leedid: leedid, state: String(format: "%@%@",jsonDictionary["country"] as! String,s))
                                            //self.performSegueWithIdentifier("gotodashboard", sender: nil)
                                            //self.getlocalcomparablesdata(subscription_key, leedid: leedid, state: String(format: "%@%@",self.buildingdetails["country"] as! String,s))
                                        }
                                    }else{
                                        let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(self.emptydict)
                                        NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "local_comparable_data")
                                        NSUserDefaults.standardUserDefaults().synchronize()
                                        //self.getcomparablesdata(subscription_key, leedid: leedid)
                                        //Existing ARM APIs
                                        //self.getlocalcomparablesdata(subscription_key, leedid: leedid, state: String(format: "%@%@",self.buildingdetails["country"] as! String,s))
                                    }
                                    self.getlocalcomparablesdata(subscription_key, leedid: leedid, state: String(format: "%@%@",self.buildingdetails["country"] as! String,s))
                                })
                                
                                
                            }else{
                                let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(self.emptydict)
                                NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "local_comparable_data")
                                NSUserDefaults.standardUserDefaults().synchronize()
                                //self.getcomparablesdata(subscription_key, leedid: leedid)
                                //Existing ARM APIs
                            }
                            
                        })
                        
                    } catch {
                        print(error)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                            
                        })
                    }
            }
            
        }
        task.resume()
    }

    @IBOutlet weak var spinner: UIView!
    override func viewDidDisappear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue(), {
            for request in self.download_requests
            {
                request.invalidateAndCancel()
            }
        })
        
    }
    func getlocalcomparablesdata(subscription_key:String, leedid: Int, state: String){
        print(state)
        let url = NSURL.init(string:"\(credentials().domain_url as String)comparables/?state=\(state)")
        print(url?.absoluteURL)
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    if (error?.code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                })
                
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401{
                dispatch_async(dispatch_get_main_queue(), {
                    //self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    //self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                })
                return
            } else
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }else{
                    print(data)
                    let jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        print(jsonDictionary)
                        let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                        NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "local_comparable_data")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        dispatch_async(dispatch_get_main_queue(), {
                            self.spinner.hidden = true
                            //self.view.userInteractionEnabled = true
                            //make navigation bar unresponsive
                            if(self.navigationController != nil){
                            //self.navigationController!.view.userInteractionEnabled = true
                            }
                            //self.tabbar.userInteractionEnabled = true
                            NSNotificationCenter.defaultCenter().postNotificationName("performrootsegue", object: nil, userInfo: ["seguename":"plaque"])
                        })
                        
                    } catch {
                        print(error)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                            
                        })
                    }
            }
            
        }
        task.resume()
    }


    
    
    func wedid(){
        pgctrl.currentPage = 0
        buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        
        var dict = [String:AnyObject]()
        dict = buildingdetails
        
        if(NSUserDefaults.standardUserDefaults().objectForKey("local_comparable_data") != nil && NSUserDefaults.standardUserDefaults().objectForKey("comparable_data") != nil && NSUserDefaults.standardUserDefaults().objectForKey("performance_data") != nil && NSUserDefaults.standardUserDefaults().objectForKey("inner_data") != nil && NSUserDefaults.standardUserDefaults().objectForKey("middle_data") != nil){
        
        if(NSUserDefaults.standardUserDefaults().objectForKey("local_comparable_data") != nil){
        localavgdict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("local_comparable_data") as! NSData) as! [String:AnyObject]
        }
        
        if(NSUserDefaults.standardUserDefaults().objectForKey("comparable_data") != nil){
        globalavgdict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("comparable_data") as! NSData) as! [String:AnyObject]
        }
        if(NSUserDefaults.standardUserDefaults().objectForKey("performance_data") != nil){
        performance_data = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("performance_data") as! NSData) as! [String:AnyObject]
        }else{
            let dte = NSDate()
            var dateformat = NSDateFormatter()
            dateformat.dateFormat = "yyyy-MM-dd"
            let datee = dateformat.stringFromDate(dte)
            self.getperformancedata(credentials().subscription_key, leedid: dict["leed_id"] as! Int, date: datee)
        }
        
        if(NSUserDefaults.standardUserDefaults().objectForKey("inner_data") != nil){
        if(NSUserDefaults.standardUserDefaults().objectForKey("inner_data") != nil){
                innerdict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("inner_data") as! NSData) as! [String:AnyObject]
        }
        }
        
        if(NSUserDefaults.standardUserDefaults().objectForKey("middle_data") != nil){
                middledict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("middle_data") as! NSData) as! [String:AnyObject]
        }
        }else{
            dispatch_async(dispatch_get_main_queue(), {
            let dte = NSDate()
            var dateformat = NSDateFormatter()
            dateformat.dateFormat = "yyyy-MM-dd"
            let datee = dateformat.stringFromDate(dte)
            self.spinner.hidden = false
            //self.view.userInteractionEnabled = false
                //make navigation bar unresponsive
            if(self.navigationController != nil){
            //self.navigationController!.view.userInteractionEnabled = false
            }
            //self.tabbar.userInteractionEnabled = false
            self.getperformancedata(credentials().subscription_key, leedid: dict["leed_id"] as! Int, date: datee)
            })
        }
        
        print("global local",globalavgdict,localavgdict)
        
        //assetname.text = dict["name"] as? String
        pageviewcontroller = self.storyboard?.instantiateViewControllerWithIdentifier("plaquepagevc") as! UIPageViewController
        pageviewcontroller.delegate = self
        pageviewcontroller.dataSource = self
        let startviewcontroller = self.viewcontrolleratIndex(currentindex)
        let viewcontrollers = [startviewcontroller]
        pageviewcontroller.setViewControllers(viewcontrollers, direction: .Forward , animated: false, completion: nil)
        pageviewcontroller.view.frame.origin.x = 0
        pageviewcontroller.view.frame.origin.y = self.nav.frame.origin.y + self.nav.frame.size.height
        pageviewcontroller.view.frame.size.width = self.view.frame.size.width
        pageviewcontroller.view.frame.size.height = pgctrl.frame.origin.y
            //pageviewcontroller.view.frame.size.height - (pgctrl.frame.size.height +
        //self.view.frame.size.height - (0.13*self.view.frame.size.width)
        self.addChildViewController(pageviewcontroller)
        self.view.addSubview(pageviewcontroller.view)
        self.view.bringSubviewToFront(pgctrl)
        //self.view.bringSubviewToFront(topview)
        self.view.bringSubviewToFront(nav)
        self.view.bringSubviewToFront(self.tabbar)
        self.view.bringSubviewToFront(self.spinner)
        let navItem = UINavigationItem(title: (dict["name"] as? String)!);
        tabbar.delegate = self
        self.navigationItem.title = dict["name"] as? String
        self.nav.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!]
        let doneItem = UIBarButtonItem(title: "< Projects", style: .Bordered, target: self, action: #selector(sayHello(_:)))
        navItem.leftBarButtonItem = doneItem;
        nav.setItems([navItem], animated: false);
        pageviewcontroller.didMoveToParentViewController(self)
        let notificationsarr = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("notifications") as! NSData) as! NSArray
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
    
    func sayHello(sender: UIBarButtonItem) {
        print("Projects clicked")
        NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"listofassets"])   
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pgctrl.pageIndicatorTintColor = UIColor.blackColor()
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.shouldRotate = false
        
        // 2. Force the device in landscape mode when the view controller gets loaded
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
        watchsession.delegate = self
        self.spinner.hidden = true
        self.spinner.layer.cornerRadius = 5
        self.titlefont()        
        wedid()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goback(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"listofassets"])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
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
    
    
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
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
    
    func viewcontrolleratIndex(index:Int) -> overallplaque {
        
        let overvall = self.storyboard?.instantiateViewControllerWithIdentifier("overallplaque") as! overallplaque
        overvall.pageIndex = index
        //print(imgarray[index])
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
        if(dict["scores"] != nil){
            if(dict["scores"]!["energy"] != nil){
                if(dict["scores"]!["energy"] is NSNull){
                    overvall.energyscorevalue = 0
                }else{
                    overvall.energyscorevalue = dict["scores"]!["energy"] as! Int
                }
                
            }else{
                overvall.energyscorevalue = 0
            }
        }else{
            overvall.energyscorevalue = 0
        }
        
        if(dict["scores"] != nil){
            if(dict["scores"]!["water"] != nil){
                if(dict["scores"]!["water"] is NSNull){
                    overvall.waterscorevalue = 0
                }else{
                    overvall.waterscorevalue = dict["scores"]!["water"] as! Int
                }
            }else{
                overvall.waterscorevalue = 0
            }
        }else{
            overvall.waterscorevalue = 0
        }
        
        if(dict["scores"] != nil){
            if(dict["scores"]!["waste"] != nil){
                if(dict["scores"]!["waste"] is NSNull){
                    overvall.wastescorevalue = 0
                }else{
                    overvall.wastescorevalue = dict["scores"]!["waste"] as! Int
                }
            }else{
                overvall.wastescorevalue = 0
            }
        }else{
            overvall.wastescorevalue = 0
        }
        
        if(dict["scores"] != nil){
            if(dict["scores"]!["transport"] != nil){
                if(dict["scores"]!["transport"] is NSNull){
                    overvall.transportscorevalue = 0
                }else{
                    overvall.transportscorevalue = dict["scores"]!["transport"] as! Int
                }
            }else{
                overvall.transportscorevalue = 0
            }
        }else{
            overvall.transportscorevalue = 0
        }
      
        if(dict["scores"] != nil){
            if(dict["scores"]!["base"] != nil){
                if(dict["scores"]!["base"] is NSNull){
                    overvall.basescorevalue = 0
                }else{
                    overvall.basescorevalue = dict["scores"]!["base"] as! Int
                }
            }else{
                overvall.basescorevalue = 0
            }
        }else{
            overvall.basescorevalue = 0
        }
        
        
        if(dict["scores"] != nil){
            if(dict["scores"]!["human_experience"] != nil){
                if(dict["scores"]!["human_experience"] is NSNull){
                    overvall.humanscorevalue = 0
                }else{
                    overvall.humanscorevalue = dict["scores"]!["human_experience"] as! Int
                }
            }else{
                overvall.humanscorevalue = 0
            }
        }else{
            overvall.humanscorevalue = 0
        }
        
        if(dict["maxima"] != nil){
            if(dict["maxima"]!["energy"] != nil){
                if(dict["maxima"]!["energy"] is NSNull){
                    overvall.energymaxscorevalue = 33
                }else{
                    overvall.energymaxscorevalue = dict["maxima"]!["energy"] as! Int
                }
            }else{
                overvall.energymaxscorevalue = 33
            }
        }else{
            overvall.energymaxscorevalue = 33
        }
        
        
        
        
        if(dict["maxima"] != nil){
            if(dict["maxima"]!["water"] != nil){
                if(dict["maxima"]!["water"] is NSNull){
                    overvall.watermaxscorevalue = 15
                }else{
                    overvall.watermaxscorevalue = dict["maxima"]!["water"] as! Int
                }
            }else{
                overvall.watermaxscorevalue = 15
            }
        }else{
            overvall.watermaxscorevalue = 15
        }
        
        if(dict["maxima"] != nil){
            if(dict["maxima"]!["waste"] != nil){
                if(dict["maxima"]!["waste"] is NSNull){
                    overvall.wastemaxscorevalue = 8
                }else{
                    overvall.wastemaxscorevalue = dict["maxima"]!["waste"] as! Int
                }
            }else{
                overvall.wastemaxscorevalue = 8
            }
        }else{
            overvall.wastemaxscorevalue = 8
        }
        
        if(dict["maxima"] != nil){
            if(dict["maxima"]!["transport"] != nil){
                if(dict["maxima"]!["transport"] is NSNull){
                    overvall.transportmaxscorevalue = 14
                }else{
                    overvall.transportmaxscorevalue = dict["maxima"]!["transport"] as! Int
                }
            }else{
                overvall.transportmaxscorevalue = 14
            }
        }else{
            overvall.transportmaxscorevalue = 14
        }
        
        
        if(dict["maxima"] != nil){
            if(dict["maxima"]!["human_experience"] != nil){
                if(dict["maxima"]!["human_experience"] is NSNull){
                    overvall.humanmaxscorevalue = 20
                }else{
                    overvall.humanmaxscorevalue = dict["maxima"]!["human_experience"] as! Int
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
    
    func individualviewcontrolleratIndex(index:Int) -> individualplaque {
        
        let overvall = self.storyboard?.instantiateViewControllerWithIdentifier("individualplaque") as! individualplaque
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
        if(index == 1){
            overvall.innerstroke = UIColor(red:0.898, green: 0.931, blue:0.56, alpha:1)
            overvall.context1value = "CURRENT"
            overvall.context2value = " Electricity \n Gas \n Smart meters \n Load schedule"
            overvall.plaqueimg = UIImage.init(named: "edited_energy")!
            overvall.strokecolor =  UIColor(red:0.776, green: 0.858, blue:0.124, alpha:1)
            overvall.titlevalue = "\nCURRENT ENERGY"
            if(dict["scores"] != nil){
                if(dict["scores"]!["energy"] != nil){
                    if(dict["scores"]!["energy"] is NSNull){
                        overvall.outerscorevalue = 0
                    }else{
                        overvall.outerscorevalue = dict["scores"]!["energy"] as! Int
                    }
                    
                }else{
                    overvall.outerscorevalue = 0
                }
            }else{
                overvall.outerscorevalue = 0
            }
            
            print(middledict)
            if(middledict["scores"] != nil){
                if(middledict["scores"]!["energy"] != nil){
                    if(middledict["scores"]!["energy"] is NSNull){
                        overvall.middlescorevalue = 0
                    }else{
                        overvall.middlescorevalue = middledict["scores"]!["energy"] as! Int
                    }
                    
                }else{
                    overvall.middlescorevalue = 0
                }
            }else{
                overvall.middlescorevalue = 0
            }
            
            if(innerdict["scores"] != nil){
                if(innerdict["scores"]!["energy"] != nil){
                    if(innerdict["scores"]!["energy"] is NSNull){
                        overvall.innerscorevalue = 0
                    }else{
                        overvall.innerscorevalue = innerdict["scores"]!["energy"] as! Int
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
            if(dict["maxima"] != nil){
                if(dict["maxima"]!["energy"] != nil){
                    if(dict["maxima"]!["energy"] is NSNull){
                        overvall.outermaxscorevalue = 33
                    }else{
                        overvall.outermaxscorevalue = dict["maxima"]!["energy"] as! Int
                    }
                }else{
                    overvall.outermaxscorevalue = 33
                }
            }else{
                overvall.outermaxscorevalue = 33
            }
            
            if(middledict["maxima"] != nil){
                if(middledict["maxima"]!["energy"] != nil){
                    if(middledict["maxima"]!["energy"] is NSNull){
                        overvall.middlemaxscorevalue = 33
                    }else{
                        overvall.middlemaxscorevalue = middledict["maxima"]!["energy"] as! Int
                    }
                }else{
                    overvall.middlemaxscorevalue = 33
                }
            }else{
                overvall.middlemaxscorevalue = 33
            }
            
            if(innerdict["maxima"] != nil){
                if(innerdict["maxima"]!["energy"] != nil){
                    if(innerdict["maxima"]!["energy"] is NSNull){
                        overvall.innermaxscorevalue = 33
                    }else{
                        overvall.innermaxscorevalue = innerdict["maxima"]!["energy"] as! Int
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
                if(middledict["scores"]!["water"] != nil){
                    if(middledict["scores"]!["water"] is NSNull){
                        overvall.middlescorevalue = 0
                    }else{
                        overvall.middlescorevalue = middledict["scores"]!["water"] as! Int
                    }
                    
                }else{
                    overvall.middlescorevalue = 0
                }
            }else{
                overvall.middlescorevalue = 0
            }
            
            if(innerdict["scores"] != nil){
                if(innerdict["scores"]!["water"] != nil){
                    if(innerdict["scores"]!["water"] is NSNull){
                        overvall.innerscorevalue = 0
                    }else{
                        overvall.innerscorevalue = innerdict["scores"]!["water"] as! Int
                    }
                    
                }else{
                    overvall.innerscorevalue = 0
                }
            }else{
                overvall.innerscorevalue = 0
            }
            
            if(dict["scores"] != nil){
                if(dict["scores"]!["water"] != nil){
                    if(dict["scores"]!["water"] is NSNull){
                        overvall.outerscorevalue = 0
                    }else{
                        overvall.outerscorevalue = dict["scores"]!["water"] as! Int
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
            if(dict["maxima"] != nil){
                if(dict["maxima"]!["water"] != nil){
                    if(dict["maxima"]!["water"] is NSNull){
                        overvall.outermaxscorevalue = 15
                    }else{
                        overvall.outermaxscorevalue = dict["maxima"]!["water"] as! Int
                    }
                }else{
                    overvall.outermaxscorevalue = 15
                }
            }else{
                overvall.outermaxscorevalue = 15
            }
            
            if(middledict["maxima"] != nil){
                if(middledict["maxima"]!["water"] != nil){
                    if(middledict["maxima"]!["water"] is NSNull){
                        overvall.middlemaxscorevalue = 15
                    }else{
                        overvall.middlemaxscorevalue = middledict["maxima"]!["water"] as! Int
                    }
                }else{
                    overvall.middlemaxscorevalue = 15
                }
            }else{
                overvall.middlemaxscorevalue = 15
            }
            
            if(innerdict["maxima"] != nil){
                if(innerdict["maxima"]!["water"] != nil){
                    if(innerdict["maxima"]!["water"] is NSNull){
                        overvall.innermaxscorevalue = 15
                    }else{
                        overvall.innermaxscorevalue = innerdict["maxima"]!["water"] as! Int
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
                if(middledict["scores"]!["waste"] != nil){
                    if(middledict["scores"]!["waste"] is NSNull){
                        overvall.middlescorevalue = 0
                    }else{
                        overvall.middlescorevalue = middledict["scores"]!["waste"] as! Int
                    }
                    
                }else{
                    overvall.middlescorevalue = 0
                }
            }else{
                overvall.middlescorevalue = 0
            }
            
            if(innerdict["scores"] != nil){
                if(innerdict["scores"]!["waste"] != nil){
                    if(innerdict["scores"]!["waste"] is NSNull){
                        overvall.innerscorevalue = 0
                    }else{
                        overvall.innerscorevalue = innerdict["scores"]!["waste"] as! Int
                    }
                    
                }else{
                    overvall.innerscorevalue = 0
                }
            }else{
                overvall.innerscorevalue = 0
            }
            

            
            if(dict["scores"] != nil){
                if(dict["scores"]!["waste"] != nil){
                    if(dict["scores"]!["waste"] is NSNull){
                        overvall.outerscorevalue = 0
                    }else{
                        overvall.outerscorevalue = dict["scores"]!["waste"] as! Int
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
            if(dict["maxima"] != nil){
                if(dict["maxima"]!["waste"] != nil){
                    if(dict["maxima"]!["waste"] is NSNull){
                        overvall.outermaxscorevalue = 8
                    }else{
                        overvall.outermaxscorevalue = dict["maxima"]!["waste"] as! Int
                    }
                }else{
                    overvall.outermaxscorevalue = 8
                }
            }else{
                overvall.outermaxscorevalue = 8
            }
            
            if(middledict["maxima"] != nil){
                if(middledict["maxima"]!["waste"] != nil){
                    if(middledict["maxima"]!["waste"] is NSNull){
                        overvall.middlemaxscorevalue = 8
                    }else{
                        overvall.middlemaxscorevalue = middledict["maxima"]!["waste"] as! Int
                    }
                }else{
                    overvall.middlemaxscorevalue = 8
                }
            }else{
                overvall.middlemaxscorevalue = 8
            }
            
            if(innerdict["maxima"] != nil){
                if(innerdict["maxima"]!["waste"] != nil){
                    if(innerdict["maxima"]!["waste"] is NSNull){
                        overvall.innermaxscorevalue = 8
                    }else{
                        overvall.innermaxscorevalue = innerdict["maxima"]!["waste"] as! Int
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
                if(middledict["scores"]!["transport"] != nil){
                    if(middledict["scores"]!["transport"] is NSNull){
                        overvall.middlescorevalue = 0
                    }else{
                        overvall.middlescorevalue = middledict["scores"]!["transport"] as! Int
                    }
                    
                }else{
                    overvall.middlescorevalue = 0
                }
            }else{
                overvall.middlescorevalue = 0
            }
            
            if(innerdict["scores"] != nil){
                if(innerdict["scores"]!["transport"] != nil){
                    if(innerdict["scores"]!["transport"] is NSNull){
                        overvall.innerscorevalue = 0
                    }else{
                        overvall.innerscorevalue = innerdict["scores"]!["transport"] as! Int
                    }
                    
                }else{
                    overvall.innerscorevalue = 0
                }
            }else{
                overvall.innerscorevalue = 0
            }
            

            
            if(dict["scores"] != nil){
                if(dict["scores"]!["transport"] != nil){
                    if(dict["scores"]!["transport"] is NSNull){
                        overvall.outerscorevalue = 0
                    }else{
                        overvall.outerscorevalue = dict["scores"]!["transport"] as! Int
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
            if(dict["maxima"] != nil){
                if(dict["maxima"]!["transport"] != nil){
                    if(dict["maxima"]!["transport"] is NSNull){
                        overvall.outermaxscorevalue = 14
                    }else{
                        overvall.outermaxscorevalue = dict["maxima"]!["transport"] as! Int
                    }
                }else{
                    overvall.outermaxscorevalue = 14
                }
            }else{
                overvall.outermaxscorevalue = 14
            }
            
            if(middledict["maxima"] != nil){
                if(middledict["maxima"]!["transport"] != nil){
                    if(middledict["maxima"]!["transport"] is NSNull){
                        overvall.middlemaxscorevalue = 14
                    }else{
                        overvall.middlemaxscorevalue = middledict["maxima"]!["transport"] as! Int
                    }
                }else{
                    overvall.middlemaxscorevalue = 14
                }
            }else{
                overvall.middlemaxscorevalue = 14
            }
            
            if(innerdict["maxima"] != nil){
                if(innerdict["maxima"]!["transport"] != nil){
                    if(innerdict["maxima"]!["transport"] is NSNull){
                        overvall.innermaxscorevalue = 14
                    }else{
                        overvall.innermaxscorevalue = innerdict["maxima"]!["transport"] as! Int
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
                if(middledict["scores"]!["human_experience"] != nil){
                    if(middledict["scores"]!["human_experience"] is NSNull){
                        overvall.middlescorevalue = 0
                    }else{
                        overvall.middlescorevalue = middledict["scores"]!["human_experience"] as! Int
                    }
                    
                }else{
                    overvall.middlescorevalue = 0
                }
            }else{
                overvall.middlescorevalue = 0
            }
            
            if(innerdict["scores"] != nil){
                if(innerdict["scores"]!["human_experience"] != nil){
                    if(innerdict["scores"]!["human_experience"] is NSNull){
                        overvall.innerscorevalue = 0
                    }else{
                        overvall.innerscorevalue = innerdict["scores"]!["human_experience"] as! Int
                    }
                    
                }else{
                    overvall.innerscorevalue = 0
                }
            }else{
                overvall.innerscorevalue = 0
            }
            

            
            if(dict["scores"] != nil){
                if(dict["scores"]!["human_experience"] != nil){
                    if(dict["scores"]!["human_experience"] is NSNull){
                        overvall.outerscorevalue = 0
                    }else{
                        overvall.outerscorevalue = dict["scores"]!["human_experience"] as! Int
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
            if(dict["maxima"] != nil){
                if(dict["maxima"]!["human_experience"] != nil){
                    if(dict["maxima"]!["human_experience"] is NSNull){
                        overvall.outermaxscorevalue = 20
                    }else{
                        overvall.outermaxscorevalue = dict["maxima"]!["human_experience"] as! Int
                    }
                }else{
                    overvall.outermaxscorevalue = 20
                }
            }else{
                overvall.outermaxscorevalue = 20
            }
            
            if(middledict["maxima"] != nil){
                if(middledict["maxima"]!["human_experience"] != nil){
                    if(middledict["maxima"]!["human_experience"] is NSNull){
                        overvall.middlemaxscorevalue = 20
                    }else{
                        overvall.middlemaxscorevalue = middledict["maxima"]!["human_experience"] as! Int
                    }
                }else{
                    overvall.middlemaxscorevalue = 20
                }
            }else{
                overvall.middlemaxscorevalue = 20
            }
            
            if(innerdict["maxima"] != nil){
                if(innerdict["maxima"]!["human_experience"] != nil){
                    if(innerdict["maxima"]!["human_experience"] is NSNull){
                        overvall.innermaxscorevalue = 20
                    }else{
                        overvall.innermaxscorevalue = innerdict["maxima"]!["human_experience"] as! Int
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
