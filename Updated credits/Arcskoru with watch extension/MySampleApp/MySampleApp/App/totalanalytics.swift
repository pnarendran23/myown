//
//  totalanalytics.swift
//  LEEDOn
//
//  Created by Group X on 20/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit
import  AVFoundation
import WatchConnectivity

class totalanalytics: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate,WCSessionDelegate {
    @IBOutlet weak var tableview: UITableView!
    var buildingdetails = [String:AnyObject]()
    var highduringreport = 0
    var watchsession = WCSession.defaultSession()
    var task = NSURLSessionTask()
    var download_requests = [NSURLSession]()
    var globalavgarr = NSMutableArray()
    var performancescoresarr = NSMutableArray()
    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var spinner: UIView!
    
    @IBAction func gotoscore(sender: AnyObject) {
                    NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"listofassets"])
    }
    
    func sessionDidDeactivate(session: WCSession) {
        
    }
    
    func sessionDidBecomeInactive(session: WCSession) {
        
    }
    
    @available(iOS 9.3, *)
    func session(session: WCSession, activationDidCompleteWithState activationState: WCSessionActivationState, error: NSError?) {
        
    }
    
    var localavgarr = NSMutableArray()
    var lessduringreport = 0
    var energypercentagedata = NSMutableArray()
    var energyscoreedata = NSMutableArray()
    var energyscoretexts = NSMutableArray()
    var energyperformanceetexts = NSMutableArray()
    var energy1sel = 0, water1sel = 0,waste1sel = 0, transit1sel = 0,human1sel = 0
    var energy2sel = 0, water2sel = 0,waste2sel = 0, transit2sel = 0,human2sel = 0
    var waterpercentagedata = NSMutableArray()
    var waterscoreedata = NSMutableArray()
    var waterscoretexts = NSMutableArray()
    var waterperformanceetexts = NSMutableArray()
    
    var wastepercentagedata = NSMutableArray()
    var wastescoreedata = NSMutableArray()
    var wastescoretexts = NSMutableArray()
    var wasteperformanceetexts = NSMutableArray()
    
    var transitpercentagedata = NSMutableArray()
    var transitscoreedata = NSMutableArray()
    var transitscoretexts = NSMutableArray()
    var transitperformanceetexts = NSMutableArray()
    
    var humanpercentagedata = NSMutableArray()
    var humanscoreedata = NSMutableArray()
    var humanscoretexts = NSMutableArray()
    var humanperformanceetexts = NSMutableArray()
    
    var energyemissions = [Int]()
    var energyvalues = [Int]()
    var wateremissions = [Int]()
    var watervalues = [Int]()
    var wasteemissions = [Int]()
    var wastevalues = [Int]()
    var transitemissions = [Int]()
    var transitvalues = [Int]()
    var humanemissions = [Int]()
    var humanvalues = [Int]()
    var analysisdict = NSDictionary()
    var reportedscores = NSMutableArray()
    var countries = [String:AnyObject]()
    var datearr = NSMutableArray()
    var globaldata = [String:AnyObject]()
    var performancedata = [String:AnyObject]()
    var localdata = [String:AnyObject]()
    var fullcountryname = ""
    var step = Float(1)
    var step1 = Float(1)
    var currentscore = 0
    var isloaded = false
    var maxscore = 0
    var sel = 0
    var energymax = 0
    var energyscore = 0
    var waterscore = 0
    var wastescore = 0
    var transportscore = 0
    var humanscore = 0
    var energymaxscore = 0
    var watermaxscore = 0
    var wastemaxscore = 0
    var transportmaxscore = 0
    var humanmaxscore = 0
    var duration = ""
    var watermax = 0
    var wastemax = 0
    var transportmax = 0
    var humanmax = 0
    var energymin = 0
    var watermin = 0
    var wastemin = 0
    var transportmin = 0
    var humanmin = 0
    var fullstatename = ""
    var toload = true
    var scoresarr = NSMutableArray()
    var callrequest = 1
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(section == 8){
            return 15
        }
        return 1
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {        
        return 5
    }
    
   /* override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [.Portrait]
    }*/
    var certificationsdict = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()        
        //[tableView setAutoresizingMask:UIViewAutoresizingMaskFelxibleHeight | UIViewAutoResizingMaskFlexibleWidth];
        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.automaticallyAdjustsScrollViewInsets = false
        self.parentViewController?.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.automaticallyAdjustsScrollViewInsets = false
        tableview.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        watchsession.delegate = self
        buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        self.navigationItem.title = buildingdetails["name"] as? String
        tableview.registerNib(UINib.init(nibName: "totalanalysis1", bundle: nil), forCellReuseIdentifier: "totalcell1")
        tableview.registerNib(UINib.init(nibName: "certcell", bundle: nil), forCellReuseIdentifier: "certcell")
        tableview.registerNib(UINib.init(nibName: "totalanalysis2", bundle: nil), forCellReuseIdentifier: "totalcell2")
        tableview.registerNib(UINib.init(nibName: "totalanalysis3", bundle: nil), forCellReuseIdentifier: "totalcell3")
        tableview.registerNib(UINib.init(nibName: "totalanalysis4", bundle: nil), forCellReuseIdentifier: "totalcell4")
        tableview.registerNib(UINib.init(nibName: "totalanalysis5", bundle: nil), forCellReuseIdentifier: "totalcell5")
        tableview.registerNib(UINib.init(nibName: "typecategory", bundle: nil), forCellReuseIdentifier: "typecell")
        tableview.registerNib(UINib.init(nibName: "extradetails", bundle: nil), forCellReuseIdentifier: "extradetails")
        
        self.titlefont()
        self.automaticallyAdjustsScrollViewInsets = false;
        self.navigationController!.navigationBar.translucent = false
        self.spinner.layer.cornerRadius = 5
NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.adjustwidth), name: UIDeviceOrientationDidChangeNotification, object: nil)
        self.tableview.hidden = true
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
        self.tabbar.selectedItem = self.tabbar.items![2]
        var temparr = [
            "count": 831,
            "created_at_max": "2017-04-06T22:35:56.591910Z",
            "created_at_min": "2014-11-26T23:11:05.499598Z",
            "energy_avg": 0,
            "water_avg": 0,
            "waste_avg": 0,
            "transport_avg": 0,
            "base_avg": 0,
            "human_experience_avg": 0
        ]
        
        
        if(self.toload == true){
            if(NSUserDefaults.standardUserDefaults().objectForKey("comparable_data") != nil){
            globaldata  = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("comparable_data") as! NSData) as! [String : AnyObject]
            }else{
             globaldata = temparr
            }
            
            if(NSUserDefaults.standardUserDefaults().objectForKey("local_comparable_data") != nil){
            localdata  = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("local_comparable_data") as! NSData) as! [String : AnyObject]
            }else{
                localdata = temparr
            }
            
            
            
            if(NSUserDefaults.standardUserDefaults().objectForKey("performance_data") != nil){
            performancedata  = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("performance_data") as! NSData) as! [String : AnyObject]
        }else{
            performancedata = [
                "id": 156140,
                "maxima": [
                    "energy": 33,
                    "water": 15,
                    "human_experience": 20,
                    "waste": 8,
                    "transport": 14,
                    "base": 10
                ],
                "building": [
                    "id": 64081,
                    "leed_id": 0,
                    "name": "US project",
                    "city": "Apex",
                    "country": "US",
                    "state": "NC",
                    "zip_code": "27523",
                    "gross_area": 2000,
                    "updated_at": "2017-03-23T11:20:22.184477Z",
                    "occupancy": 15,
                    "certification": "",
                    "building_status": "activated_payment_done",
                    "rating_system": "LEED V4 O+M: TR",
                    "owner_email": "owner@gmail.com",
                    "energy": 27,
                    "water": 14,
                    "waste": 8,
                    "transport": 13,
                    "human_experience": 15
                ],
                "scores": [
                    "energy": 0,
                    "water": 0,
                    "base": 0,
                    "human_experience": 0,
                    "waste": 0,
                    "transport": 0
                ],
                "version": "version3",
                "created_at": "2017-03-15T10:03:19.361107Z",
                "effective_at": "2017-03-15T00:00:00Z",
                "certification_level": "gold",
                "energy": 80.5794924746553,
                "water": 94.4917762993125,
                "waste": 100,
                "transport": 91.5493961985178,
                "human_experience": 76.1540976377764,
                "base": 100
            ]
        }
        
            //print(globaldata,localdata)
            globalavgarr.addObject(0)
            globalavgarr.addObject(0)
            globalavgarr.addObject(0)
            globalavgarr.addObject(0)
            globalavgarr.addObject(0)
            
            for (key,value) in globaldata{
                if(value is NSNull){
                    
                }else{
                    if(key == "energy_avg"){
                        globalavgarr.replaceObjectAtIndex(0, withObject: value as! Int)
                    }else if(key == "water_avg"){
                        globalavgarr.replaceObjectAtIndex(1, withObject: value as! Int)
                    }else if(key == "waste_avg"){
                        globalavgarr.replaceObjectAtIndex(2, withObject: value as! Int)
                    }else if(key == "transport_avg"){
                        globalavgarr.replaceObjectAtIndex(3, withObject: value as! Int)
                    }else if(key == "human_experience_avg"){
                        globalavgarr.replaceObjectAtIndex(4, withObject: value as! Int)
                    }
                }
            }
            
            localavgarr.addObject(0)
            localavgarr.addObject(0)
            localavgarr.addObject(0)
            localavgarr.addObject(0)
            localavgarr.addObject(0)
            
            //print("avg arrays",globaldata,localdata)
            
            for (key,value) in localdata{
                if(value is NSNull){
                }else{
                    if(key == "energy_avg"){
                        localavgarr.replaceObjectAtIndex(0, withObject: value as! Int)
                    }else if(key == "water_avg"){
                        localavgarr.replaceObjectAtIndex(1, withObject: value as! Int)
                    }else if(key == "waste_avg"){
                        localavgarr.replaceObjectAtIndex(2, withObject: value as! Int)
                    }else if(key == "transport_avg"){
                        localavgarr.replaceObjectAtIndex(3, withObject: value as! Int)
                    }else if(key == "human_experience_avg"){
                        localavgarr.replaceObjectAtIndex(4, withObject: value as! Int)
                    }
                }
            }
            
            
            //print("compara",localavgarr,globalavgarr)
            
            
            countries = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("countries") as! NSData) as! [String : AnyObject]
            
            var tempdict = countries["countries"] as! [String:AnyObject]
            var present = 0
            
            tempdict = countries["countries"] as! [String:AnyObject]
            for (key,value) in tempdict{
                if(key as! String == buildingdetails["country"]! as! String){
                    fullcountryname = value as! String
                    present = 1
                    break
                }
            }
            tempdict = countries["countries"] as! [String:AnyObject]
            if(present == 1){
            
            tempdict = countries["divisions"]![buildingdetails["country"] as! String]! as! [String:AnyObject]
            for (key,value) in tempdict{
                if(key == buildingdetails["state"] as! String){
                    fullstatename = value as! String
                    break
                }
            }
            }else{
                fullcountryname = ""
            }
            if(performancedata["scores"] != nil){
                var temparr = performancedata["scores"] as! [String:AnyObject]
                if(temparr["energy"] is NSNull){
                    currentscore += 0
                    energyscore = 0
                }else{
                    currentscore += temparr["energy"] as! Int
                    energyscore = temparr["energy"] as! Int
                }
                if(temparr["water"] is NSNull){
                    currentscore += 0
                    waterscore = 0
                }else{
                    currentscore += temparr["water"] as! Int
                    waterscore = temparr["water"] as! Int
                }
                if(temparr["waste"] is NSNull){
                    currentscore += 0
                    wastescore = 0
                }else{
                    currentscore += temparr["waste"] as! Int
                    wastescore = temparr["waste"] as! Int
                }
                if(temparr["transport"] is NSNull){
                    currentscore += 0
                    transportscore = 0
                }else{
                    currentscore += temparr["transport"] as! Int
                    transportscore = temparr["transport"] as! Int
                }
                if(temparr["human_experience"] is NSNull){
                    currentscore += 0
                    humanscore = 0
                }else{
                    currentscore += temparr["human_experience"] as! Int
                    humanscore = temparr["human_experience"] as! Int
                }
                if(temparr["base"] is NSNull){
                    currentscore += 0
                }else{
                    currentscore += temparr["base"] as! Int
                }
            }
            
            if(performancedata["maxima"] != nil){
                var temparr = performancedata["maxima"] as! [String:AnyObject]
                if(temparr["energy"] is NSNull){
                    maxscore += 0
                    energymaxscore = 0
                }else{
                    maxscore += temparr["energy"] as! Int
                    energymaxscore = temparr["energy"] as! Int
                }
                if(temparr["water"] is NSNull){
                    maxscore += 0
                    watermaxscore = 0
                }else{
                    watermaxscore = temparr["water"] as! Int
                    maxscore += temparr["water"] as! Int
                }
                if(temparr["waste"] is NSNull){
                    maxscore += 0
                    wastemaxscore = 0
                }else{
                    maxscore += temparr["waste"] as! Int
                    wastemaxscore = temparr["waste"] as! Int
                }
                if(temparr["transport"] is NSNull){
                    maxscore += 0
                    transportmaxscore = 0
                }else{
                    maxscore += temparr["transport"] as! Int
                    transportmaxscore = temparr["transport"] as! Int
                }
                if(temparr["human_experience"] is NSNull){
                    maxscore += 0
                    humanmaxscore = 0
                }else{
                    maxscore += temparr["human_experience"] as! Int
                    humanmaxscore = temparr["human_experience"] as! Int
                }
                if(temparr["base"] is NSNull){
                    maxscore += 0
                }else{
                    maxscore += temparr["base"] as! Int
                }
            }
            
            
            
            //print("Min score",currentscore,maxscore )
            
            
            tableview.reloadData()
            
            
            
            let datearray : NSMutableArray = []
            let formatter = NSDateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            var date = NSDate()
            let unitFlags: NSCalendarUnit = [.Hour, .Day, .Month, .Year]
            var components = NSCalendar.currentCalendar().components(unitFlags, fromDate: date)
            
            for _ in (1...12).reverse() {
                //print(components.year, components.month)
                components = NSCalendar.currentCalendar().components(unitFlags, fromDate: date)
                datearray.addObject(String(format:"%d-%02d-01",components.year,components.month))
                let monthAgo = NSCalendar.currentCalendar().dateByAddingUnit(.Month, value: -1, toDate: date, options: [])
                date = monthAgo!
            }
            
            
            //print(datearray)
            var date1 = NSDate()
            var date2 = NSDate()
            formatter.dateFormat = "yyyy-MM-dd"
            date1 = formatter.dateFromString(datearray.firstObject as! String)!
            date2 = formatter.dateFromString(datearray.lastObject as! String)!
            formatter.dateFormat = "MMM yyyy"
            duration = String(format: "%@ to %@",formatter.stringFromDate(date2),formatter.stringFromDate(date1))
            datearr = datearray
            
            
            
            
            if(isloaded == false){
                if(callrequest == 1){
                    dispatch_async(dispatch_get_main_queue(), {
                        self.view.userInteractionEnabled = false
                        self.spinner.hidden = false
                        self.tableview.alpha = 0.4
                    })
                    getscores(NSUserDefaults.standardUserDefaults().integerForKey("leed_id"),token: NSUserDefaults.standardUserDefaults().objectForKey("token") as! String)
                }else{
                    scoresarr = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("scoresarr") as! NSData) as! NSMutableArray
                    reportedscores = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("reportedscoresarr") as! NSData) as! NSMutableArray
                    analysisdict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("analysisdict") as! NSData) as! NSDictionary
                    assignanalysisvalue()
                }
            }
        }
        if(NSUserDefaults.standardUserDefaults().objectForKey("local_comparable_data") != nil && NSUserDefaults.standardUserDefaults().objectForKey("comparable_data") != nil && NSUserDefaults.standardUserDefaults().objectForKey("performance_data") != nil){
         }else{
            dispatch_async(dispatch_get_main_queue(), {
                self.spinner.hidden = false
                let dte = NSDate()
                var dateformat = NSDateFormatter()
                dateformat.dateFormat = "yyyy-MM-dd"
                let datee = dateformat.stringFromDate(dte)
                self.getperformancedata(credentials().subscription_key, leedid: self.buildingdetails["leed_id"] as! Int, date: datee)
            })
        }
        //comparable_data -> global
        
        
        // Do any additional setup after loading the view.
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
                    self.spinner.hidden = true
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
    
    var emptydict = ["count": 1,"created_at_max": "2016-12-30T14:02:41.260478Z","created_at_min": "2016-12-30T14:02:41.260478Z","energy_avg": 0,"water_avg": 0,"waste_avg": 0,"transport_avg": 0,"base_avg": 0,"human_experience_avg": 0]
    
    
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
                    self.spinner.hidden = true
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
                            NSNotificationCenter.defaultCenter().postNotificationName("performrootsegue", object: nil, userInfo: ["seguename":"totalanalysis"])
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

    
    func getscores(leedid:Int, token:String){
        performancescoresarr.removeAllObjects()
        for index in 0...11 {
            //print("Loop index: \(index)")
            
            let url = NSURL(string: "\(credentials().domain_url)assets/LEED:\(leedid)/scores/?at=\(datearr.objectAtIndex(index))&within=1")
            print(url)
            let request = NSMutableURLRequest.init(URL: url!)
            request.HTTPMethod = "GET"
            request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
            request.addValue("application/json", forHTTPHeaderField:"Content-type" )
            request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
            
            
            let tasky = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                var taskerror = false
                let httpStatus = response as? NSHTTPURLResponse
                if(error == nil){
                    if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401 {           // check for http errors
                        dispatch_async(dispatch_get_main_queue(), {
                            self.spinner.hidden = true
                            self.view.userInteractionEnabled = true
                            NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                        })
                    } else
                        if (httpStatus!.statusCode != 200 && httpStatus!.statusCode != 201) {
                            taskerror = true
                        }else{
                            let jsonDictionary : NSDictionary
                            do {
                                jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                                //print("Data \(index)",jsonDictionary)
                                if(jsonDictionary["result"] == nil){
                                    self.scoresarr.addObject(jsonDictionary["scores"] as! [String:AnyObject])
                                }
                                self.reportedscores.addObject(jsonDictionary)
                            } catch {
                                //print(error)
                            }
                            
                    }
                    
                    dispatch_sync(dispatch_get_main_queue()) {
                        if (taskerror == true){
                            //print(taskerror)
                            dispatch_async(dispatch_get_main_queue(), {
                                self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                                return
                            })
                        } else {
                            
                            if(index == 11){
                                //print("Scores arr",self.scoresarr)
                                self.getanalysis(leedid, token: token)
                            }
                        }
                    }
                }else{
                    return
                }
                
            })
            
            
            
            
            tasky.resume()
        }
    }
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        self.navigationItem.title = buildingdetails["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = "Projects"
        self.navigationController?.navigationBar.barTintColor = UIColor.darkGrayColor()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "OpenSans", size: 17)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.tableview.hidden = false
        if(NSUserDefaults.standardUserDefaults().objectForKey("certification_details") == nil){
            var dict = NSMutableDictionary()
            var arr = NSArray()
            dict["certificates"] = arr
            dict["performance_periods"] = arr
            certificationsdict = dict
            let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(dict)                        
        }
        self.tableview.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        for request in download_requests
        {
            request.invalidateAndCancel()
        }
        buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        self.navigationItem.title = buildingdetails["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as? String
    }
    
    func certdetails(subscription_key:String, leedid: Int){
        let url = NSURL.init(string: String(format: "%@assets/LEED:%d/certifications/",credentials().domain_url,leedid))
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-Type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        print(url?.absoluteURL,token)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401{
                dispatch_async(dispatch_get_main_queue(), {
                    //self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                })
                return
            } else
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for httCALayer * individualforiphone = [CALayer layer];
                    //[self.layer addSublayer:individualforiphone];
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    dispatch_async(dispatch_get_main_queue(), {
                        let jsonDictionary : NSDictionary
                        do {
                            jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                            if(jsonDictionary["error"] != nil){
                                if(jsonDictionary["error"]![0]!["message"] != nil){
                                    self.showalert(jsonDictionary["error"]![0]!["message"]!! as! String, title: "Error", action: "OK")
                                }else{
                                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                                }
                            }else{
                                self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                            }
                        }catch{
                            
                        }
                        
                    })
                }else{
                    print(data)
                    let jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        print(jsonDictionary)
                        let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                        self.certificationsdict = jsonDictionary
                        dispatch_async(dispatch_get_main_queue(), {
                            let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                            NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "certification_details")
                            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "grid")
                           self.getcomparablesdata(subscription_key, leedid: leedid)
                        })
                        
                    } catch {
                        dispatch_async(dispatch_get_main_queue(), {
                            let jsonDictionary : NSDictionary
                            do {
                                jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                                if(jsonDictionary["error"] != nil){
                                    if(jsonDictionary["error"]![0]!["message"] != nil){
                                        self.showalert(jsonDictionary["error"]![0]!["message"]!! as! String, title: "Error", action: "OK")
                                    }else{
                                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                                    }
                                }else{
                                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                                }
                            }catch{
                                
                            }
                            
                        })
                        
                    }
            }
            
        }
        task.resume()
    }

    
    
    func getanalysis(leedid:Int,token:String){
        let url = NSURL(string: "\(credentials().domain_url)assets/LEED:\(leedid)/analysis/")
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        
        
        let tasky = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
            var taskerror = false
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401 {           // check for http errors
                dispatch_async(dispatch_get_main_queue(), {
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                })
            }else{
            
            
            if error == nil {
                
                
                
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    //print("Data",jsonDictionary)
                    self.spinner.hidden = true
                    self.tableview.alpha = 1
                    self.view.userInteractionEnabled = true
                    self.analysisdict = jsonDictionary
                    self.analysisdict = jsonDictionary                                        
                    var dict = self.analysisdict
                    if(dict["energy"] is NSNull || dict["energy"] == nil){
                        
                    }else{
                        if(dict["energy"]!["info_json"] is NSNull){
                            let emissions = [Int]()
                            let values = [Int]()
                            self.energyemissions = emissions
                            self.energyvalues = values
                        }else{
                            var str = dict["energy"]!["info_json"] as! String
                            let str1 = NSMutableString()
                            str1.appendString(str)
                            //print(str1)
                            str = str1.mutableCopy() as! String
                            str = str.stringByReplacingOccurrencesOfString("'", withString: "\"")
                            str = str.stringByReplacingOccurrencesOfString("None", withString: "\"None\"")
                            let jsonData = (str).dataUsingEncoding(NSUTF8StringEncoding)
                            do {
                                if(self.convertStringToDictionary(str) != nil){
                                dict = self.convertStringToDictionary(str)!
                                
                                let sortedKeys = (dict.allKeys as! [String]).sort(<)
                                var ans = sortedKeys.sort {
                                    (first, second) in
                                    first.compare(second, options: .NumericSearch) == NSComparisonResult.OrderedAscending
                                }
                                var temparr = NSMutableArray()
                                for item in 0 ..< ans.count{
                                    temparr.addObject(ans[item] as! String)
                                }
                                
                                self.energyperformanceetexts = temparr
                                self.energyscoretexts = temparr
                                var tempdict = NSMutableDictionary()
                                var emissions = [Int]()
                                var values = [Int]()
                                for item in 0 ..< ans.count{
                                    var key = ans[item] as! String
                                    if(key.containsString("Percent emissions reduction for a plaque score of")){
                                        var value = dict[ans[item] as! String] as! Int
                                        tempdict.setValue(value, forKey: key as! String)
                                        let str = NSMutableString()
                                        str.appendString(key as! String)
                                        str.replaceOccurrencesOfString("Percent emissions reduction for a plaque score of ", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.length))
                                        emissions.append(Int(str as String)!)
                                        values.append(value as! Int)
                                        var temp = NSDictionary.init(dictionary: [key as! String:value])
                                        self.energyscoreedata.addObject(temp)
                                    }else{
                                        //self.energyscoretexts.removeObjectAtIndex(self.energyscoretexts.indexOfObject(key as! String))
                                    }
                                    if(key.containsString("Energy Plaque Score with") && key.containsString("Lower Emissions") && !key.containsString("More Density and")){
                                        var value = dict[ans[item] as! String] as! Float
                                        var temp = NSDictionary.init(dictionary: [key as! String:value])
                                        self.energypercentagedata.addObject(temp)
                                    }else{
                                        //self.energyperformanceetexts.removeObjectAtIndex(self.energyperformanceetexts.indexOfObject(key as! String))
                                    }
                                    
                                }
                                //print("Tempdict",tempdict,values,emissions)
                                self.energyemissions = emissions
                                self.energyvalues = values
                                }
                            }catch{
                                
                            }
                            
                        }
                    }
                    
                    dict = self.analysisdict
                    if(dict["water"] is NSNull || dict["water"] == nil){
                        let emissions = [Int]()
                        let values = [Int]()
                        
                        self.wateremissions = emissions
                        self.watervalues = values
                    }else{
                        if(dict["water"]!["info_json"] is NSNull){
                            let emissions = [Int]()
                            let values = [Int]()
                            
                            self.wateremissions = emissions
                            self.watervalues = values
                        }else{
                            var str = dict["water"]!["info_json"] as! String
                            let str1 = NSMutableString()
                            str1.appendString(str)
                            str = str.stringByReplacingOccurrencesOfString("'", withString: "\"")
                            str = str.stringByReplacingOccurrencesOfString("None", withString: "\"None\"")
                            do {
                                if(self.convertStringToDictionary(str) != nil){
                                dict = self.convertStringToDictionary(str)!
                                let sortedKeys = (dict.allKeys as! [String]).sort(<)
                                let ans = sortedKeys.sort {
                                    (first, second) in
                                    first.compare(second, options: .NumericSearch) == NSComparisonResult.OrderedAscending
                                }
                                
                                var temparr = NSMutableArray()
                                for item in 0 ..< ans.count{
                                    temparr.addObject(ans[item] as! String)
                                }
                                
                                self.waterperformanceetexts = temparr
                                self.waterscoretexts = temparr
                                
                                let tempdict = NSMutableDictionary()
                                var emissions = [Int]()
                                var values = [Int]()
                                for item in 0 ..< ans.count{
                                    var key = ans[item] as! String
                                    
                                    if(key.containsString("Percent emissions reduction for a plaque score of")){
                                        var value = dict[ans[item] as! String] as! Int
                                        tempdict.setValue(value, forKey: key as! String)
                                        let str = NSMutableString()
                                        str.appendString(key as! String)
                                        str.replaceOccurrencesOfString("Percent emissions reduction for a plaque score of ", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.length))
                                        emissions.append(Int(str as String)!)
                                        values.append(value as! Int)
                                        var temp = NSDictionary.init(dictionary: [key as! String:value])
                                        self.waterscoreedata.addObject(temp)
                                    }else{
                                        //self.waterscoretexts.removeObjectAtIndex(self.waterscoretexts.indexOfObject(key as! String))
                                    }
                                    if(key.containsString("Water Plaque Score with") && key.containsString("Lower Emissions") && !key.containsString("More Density and")){
                                        var value = dict[ans[item] as! String] as! Float
                                        var temp = NSDictionary.init(dictionary: [key:value])
                                        self.waterpercentagedata.addObject(temp)
                                    }else{
                                        //self.waterperformanceetexts.removeObjectAtIndex(self.waterperformanceetexts.indexOfObject(key as! String))
                                    }
                                    
                                }
                                //print("Tempdict",tempdict,values,emissions)
                                self.wateremissions = emissions
                                self.watervalues = values
                                }
                            }catch{
                                
                            }
                        }
                    }
                    
                    dict = self.analysisdict
                    if(dict["waste"] is NSNull || dict["waste"] == nil){
                        
                    }else{
                        if(dict["waste"]!["info_json"] is NSNull){
                            
                        }else{
                            var str = dict["waste"]!["info_json"] as! String
                            let str1 = NSMutableString()
                            str1.appendString(str)
                            str = str.stringByReplacingOccurrencesOfString("'", withString: "\"")
                            str = str.stringByReplacingOccurrencesOfString("None", withString: "\"None\"")
                            let jsonData = (str).dataUsingEncoding(NSUTF8StringEncoding)
                            do {
                                if(self.convertStringToDictionary(str) != nil){
                                dict = self.convertStringToDictionary(str)!
                                let sortedKeys = (dict.allKeys as! [String]).sort(<)
                                let ans = sortedKeys.sort {
                                    (first, second) in
                                    first.compare(second, options: .NumericSearch) == NSComparisonResult.OrderedAscending
                                }
                                
                                var temparr = NSMutableArray()
                                for item in 0 ..< ans.count{
                                    temparr.addObject(ans[item] as! String)
                                }
                                
                                self.wasteperformanceetexts = temparr
                                self.wastescoretexts = temparr
                                
                                let tempdict = NSMutableDictionary()
                                var emissions = [Int]()
                                var values = [Int]()
                                for item in 0 ..< ans.count{
                                    var key = ans[item] as! String
                                    if(key.containsString("Percent emissions reduction for a plaque score of")){
                                        var value = dict[ans[item] as! String] as! Int
                                        tempdict.setValue(value, forKey: key as! String)
                                        let str = NSMutableString()
                                        str.appendString(key as! String)
                                        str.replaceOccurrencesOfString("Percent emissions reduction for a plaque score of ", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.length))
                                        emissions.append(Int(str as String)!)
                                        values.append(value as! Int)
                                        var temp = NSDictionary.init(dictionary: [key as! String:value])
                                        self.wastescoreedata.addObject(temp)
                                    }else{
                                        //self.wastescoretexts.removeObjectAtIndex(self.wastescoretexts.indexOfObject(key as! String))
                                    }
                                    if(key.containsString("Waste Plaque Score with") && key.containsString("Lower Emissions") && !key.containsString("More Density and")){
                                        var value = dict[ans[item] as! String] as! Float
                                        var temp = NSDictionary.init(dictionary: [key as! String:value])
                                        self.wastepercentagedata.addObject(temp)
                                    }else{
                                        //self.wasteperformanceetexts.removeObjectAtIndex(self.wasteperformanceetexts.indexOfObject(key as! String))
                                    }
                                }
                                //print("Tempdict",tempdict,values,emissions)
                                self.wasteemissions = emissions
                                self.wastevalues = values
                                }
                            }catch{
                                
                            }
                        }
                    }
                    
                    
                    dict = self.analysisdict
                    if(dict["transit"] is NSNull || dict["transit"] == nil){
                        
                    }else{
                        if(dict["transit"]!["info_json"] is NSNull){
                            
                        }else{
                            var str = dict["transit"]!["info_json"] as! String
                            let str1 = NSMutableString()
                            str1.appendString(str)
                            str = str.stringByReplacingOccurrencesOfString("'", withString: "\"")
                            str = str.stringByReplacingOccurrencesOfString("None", withString: "\"None\"")
                            let jsonData = (str).dataUsingEncoding(NSUTF8StringEncoding)
                            do {
                                if(self.convertStringToDictionary(str) != nil){
                                dict = self.convertStringToDictionary(str)!
                                let sortedKeys = (dict.allKeys as! [String]).sort(<)
                                let ans = sortedKeys.sort {
                                    (first, second) in
                                    first.compare(second, options: .NumericSearch) == NSComparisonResult.OrderedAscending
                                }
                                
                                var temparr = NSMutableArray()
                                for item in 0 ..< ans.count{
                                    temparr.addObject(ans[item] as! String)
                                }
                                
                                self.transitperformanceetexts = temparr
                                self.transitscoretexts = temparr
                                
                                let tempdict = NSMutableDictionary()
                                var emissions = [Int]()
                                var values = [Int]()
                                for item in 0 ..< ans.count{
                                    var key = ans[item] as! String
                                    if(key.containsString("Percent emissions reduction for a plaque score of")){
                                        var value = dict[ans[item] as! String] as! Int
                                        tempdict.setValue(value, forKey: key as! String)
                                        let str = NSMutableString()
                                        str.appendString(key as! String)
                                        str.replaceOccurrencesOfString("Percent emissions reduction for a plaque score of ", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.length))
                                        emissions.append(Int(str as String)!)
                                        values.append(value as! Int)
                                        var temp = NSDictionary.init(dictionary: [key as! String:value])
                                        self.transitscoreedata.addObject(temp)
                                    }else{
                                        //self.transitscoretexts.removeObjectAtIndex(self.transitscoretexts.indexOfObject(key as! String))
                                    }
                                    if(key.containsString("Transportation Plaque Score with") && key.containsString("Lower Emissions") && !key.containsString("More Density and")){
                                        var value = dict[ans[item] as! String] as! Float
                                        var temp = NSDictionary.init(dictionary: [key as! String:value])
                                        self.transitpercentagedata.addObject(temp)
                                    }else{
                                        //self.transitperformanceetexts.removeObjectAtIndex(self.transitperformanceetexts.indexOfObject(key as! String))
                                    }
                                }
                                //print("Tempdict",tempdict,values,emissions)
                                self.transitemissions = emissions
                                self.transitvalues = values
                                }
                            }catch{
                                
                            }
                        }
                    }
                    
                    dict = self.analysisdict
                    if(dict["human"] is NSNull || dict["human"] == nil){
                        
                    }else{
                        if(dict["human"]!["info_json"] is NSNull){
                            
                        }else{
                            var str = dict["human"]!["info_json"] as! String
                            let str1 = NSMutableString()
                            str1.appendString(str)
                            str = str.stringByReplacingOccurrencesOfString("'", withString: "\"")
                            str = str.stringByReplacingOccurrencesOfString("None", withString: "\"None\"")
                            let jsonData = (str).dataUsingEncoding(NSUTF8StringEncoding)
                            do {
                                if(self.convertStringToDictionary(str) != nil){
                                dict = self.convertStringToDictionary(str)!
                                let sortedKeys = (dict.allKeys as! [String]).sort(<)
                                let ans = sortedKeys.sort {
                                    (first, second) in
                                    first.compare(second, options: .NumericSearch) == NSComparisonResult.OrderedAscending
                                }
                                
                                var temparr = NSMutableArray()
                                for item in 0 ..< ans.count{
                                    temparr.addObject(ans[item] as! String)
                                }
                                
                                self.humanperformanceetexts = temparr
                                self.humanscoretexts = temparr
                                let tempdict = NSMutableDictionary()
                                var emissions = [Int]()
                                var values = [Int]()
                                for item in 0 ..< ans.count{
                                    var key = ans[item] as! String
                                    if(key.containsString("Percent emissions reduction for a plaque score of")){
                                        var value = dict[ans[item] as! String] as! Int
                                        tempdict.setValue(value, forKey: key as! String)
                                        let str = NSMutableString()
                                        str.appendString(key as! String)
                                        str.replaceOccurrencesOfString("Percent emissions reduction for a plaque score of ", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.length))
                                        emissions.append(Int(str as String)!)
                                        values.append(value as! Int)
                                        var temp = NSDictionary.init(dictionary: [key:value])
                                        self.humanscoreedata.addObject(temp)
                                    }else{
                                        //self.humanscoretexts.removeObjectAtIndex(self.humanscoretexts.indexOfObject(key as! String))
                                        
                                    }
                                    
                                    if(key.containsString("Human Experience Plaque Score with") && key.containsString("Lower Emissions") && !key.containsString("More Density and")){
                                        var value = dict[ans[item] as! String] as! Float
                                        var temp = NSDictionary.init(dictionary: [key:value])
                                        self.humanpercentagedata.addObject(temp)
                                    }else{
                                        //self.humanperformanceetexts.removeObjectAtIndex(self.humanperformanceetexts.indexOfObject(key as! String))
                                    }
                                    
                                }
                                //print("Tempdict",tempdict,values,emissions)
                                self.humanemissions = emissions
                                self.humanvalues = values
                                }
                            }catch{
                                
                            }
                        }
                    }
                    
                    self.getmax("energy", arr: self.scoresarr)
                    self.getmax("water", arr: self.scoresarr)
                    self.getmax("waste", arr: self.scoresarr)
                    self.getmax("transport", arr: self.scoresarr)
                    self.getmax("human_experience", arr: self.scoresarr)
                    self.getmin("energy", arr: self.scoresarr)
                    self.getmin("water", arr: self.scoresarr)
                    self.getmin("waste", arr: self.scoresarr)
                    self.getmin("transport", arr: self.scoresarr)
                    self.getmin("human_experience", arr: self.scoresarr)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.view.userInteractionEnabled = true
                        self.spinner.hidden = true
                        self.tableview.alpha = 1.0
                        self.getmax("energy", arr: self.scoresarr)
                        self.tableview.reloadData()
                    })
                } catch {
                    //print(error)
                }
                
                
            } else {
                taskerror = true
            }
            }
            self.spinner.hidden = true
            self.tableview.alpha = 1
            self.view.userInteractionEnabled = true
            })
            
        })
        
        
        
        
        tasky.resume()
    }
    
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    func assignanalysisvalue(){
                var dict = self.analysisdict
                if(dict["energy"] is NSNull || dict["energy"] == nil){
                    
                }else{
                    if(dict["energy"]!["info_json"] is NSNull){
                        let emissions = [Int]()
                        let values = [Int]()
                        self.energyemissions = emissions
                        self.energyvalues = values
                    }else{
                        var str = dict["energy"]!["info_json"] as! String
                        let str1 = NSMutableString()
                        str1.appendString(str)
                        str1.replaceOccurrencesOfString("'", withString: "\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
                        //print(str1)
                        str = str1.mutableCopy() as! String
                        let jsonData = (str).dataUsingEncoding(NSUTF8StringEncoding)
                        do {
                            dict = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions()) as! NSDictionary
                            let tempdict = NSMutableDictionary()
                            var emissions = [Int]()
                            var values = [Int]()
                            for (key, value) in dict{
                                if(key.containsString("Percent emissions reduction for a plaque score of")){
                                    tempdict.setValue(value, forKey: key as! String)
                                    let str = NSMutableString()
                                    str.appendString(key as! String)
                                    str.replaceOccurrencesOfString("Percent emissions reduction for a plaque score of ", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.length))
                                    emissions.append(Int(str as String)!)
                                    values.append(value as! Int)
                                }
                            }
                            //print("Tempdict",tempdict,values,emissions)
                            self.energyemissions = emissions
                            self.energyvalues = values
                        }catch{
                            
                        }
                    }
                }
                
                
                if(dict["water"] is NSNull || dict["water"] == nil){
                    let emissions = [Int]()
                    let values = [Int]()
                    
                    self.wateremissions = emissions
                    self.watervalues = values
                }else{
                    if(dict["water"]!["info_json"] is NSNull){
                        let emissions = [Int]()
                        let values = [Int]()
                        
                        self.wateremissions = emissions
                        self.watervalues = values
                    }else{
                        var str = dict["water"]!["info_json"] as! String
                        let str1 = NSMutableString()
                        str1.appendString(str)
                        str1.replaceOccurrencesOfString("'", withString: "\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
                        //print(str1)
                        str = str1.mutableCopy() as! String
                        let jsonData = (str).dataUsingEncoding(NSUTF8StringEncoding)
                        do {
                            dict = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions()) as! NSDictionary
                            let tempdict = NSMutableDictionary()
                            var emissions = [Int]()
                            var values = [Int]()
                            for (key, value) in dict{
                                if(key.containsString("Percent emissions reduction for a plaque score of")){
                                    tempdict.setValue(value, forKey: key as! String)
                                    let str = NSMutableString()
                                    str.appendString(key as! String)
                                    str.replaceOccurrencesOfString("Percent emissions reduction for a plaque score of ", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.length))
                                    emissions.append(Int(str as String)!)
                                    values.append(value as! Int)
                                }
                            }
                            //print("Tempdict",tempdict,values,emissions)
                            self.wateremissions = emissions
                            self.watervalues = values
                        }catch{
                            
                        }
                    }
                }
                
                if(dict["waste"] is NSNull || dict["waste"] == nil){
                    
                }else{
                    if(dict["waste"]!["info_json"] is NSNull){
                        
                    }else{
                        var str = dict["waste"]!["info_json"] as! String
                        let str1 = NSMutableString()
                        str1.appendString(str)
                        str1.replaceOccurrencesOfString("'", withString: "\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
                        //print(str1)
                        str = str1.mutableCopy() as! String
                        let jsonData = (str).dataUsingEncoding(NSUTF8StringEncoding)
                        do {
                            dict = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions()) as! NSDictionary
                            let tempdict = NSMutableDictionary()
                            var emissions = [Int]()
                            var values = [Int]()
                            for (key, value) in dict{
                                if(key.containsString("Percent emissions reduction for a plaque score of")){
                                    tempdict.setValue(value, forKey: key as! String)
                                    let str = NSMutableString()
                                    str.appendString(key as! String)
                                    str.replaceOccurrencesOfString("Percent emissions reduction for a plaque score of ", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.length))
                                    emissions.append(Int(str as String)!)
                                    values.append(value as! Int)
                                }
                            }
                            //print("Tempdict",tempdict,values,emissions)
                            self.wasteemissions = emissions
                            self.wastevalues = values
                        }catch{
                            
                        }
                    }
                }
                
                
                
                if(dict["transit"] is NSNull || dict["transit"] == nil){
                    
                }else{
                    if(dict["transit"]!["info_json"] is NSNull){
                        
                    }else{
                        var str = dict["transit"]!["info_json"] as! String
                        let str1 = NSMutableString()
                        str1.appendString(str)
                        str1.replaceOccurrencesOfString("'", withString: "\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
                        //print(str1)
                        str = str1.mutableCopy() as! String
                        let jsonData = (str).dataUsingEncoding(NSUTF8StringEncoding)
                        do {
                            dict = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions()) as! NSDictionary
                            let tempdict = NSMutableDictionary()
                            var emissions = [Int]()
                            var values = [Int]()
                            for (key, value) in dict{
                                if(key.containsString("Percent emissions reduction for a plaque score of")){
                                    tempdict.setValue(value, forKey: key as! String)
                                    let str = NSMutableString()
                                    str.appendString(key as! String)
                                    str.replaceOccurrencesOfString("Percent emissions reduction for a plaque score of ", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.length))
                                    emissions.append(Int(str as String)!)
                                    values.append(value as! Int)
                                }
                            }
                            //print("Tempdict",tempdict,values,emissions)
                            self.transitemissions = emissions
                            self.transitvalues = values
                        }catch{
                            
                        }
                    }
                }
                
                
                if(dict["human"] is NSNull || dict["human"] == nil){
                    
                }else{
                    if(dict["human"]!["info_json"] is NSNull){
                        
                    }else{
                        var str = dict["human"]!["info_json"] as! String
                        let str1 = NSMutableString()
                        str1.appendString(str)
                        str1.replaceOccurrencesOfString("'", withString: "\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
                        //print(str1)
                        str = str1.mutableCopy() as! String
                        let jsonData = (str).dataUsingEncoding(NSUTF8StringEncoding)
                        do {
                            dict = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions()) as! NSDictionary
                            let tempdict = NSMutableDictionary()
                            var emissions = [Int]()
                            var values = [Int]()
                            for (key, value) in dict{
                                if(key.containsString("Percent emissions reduction for a plaque score of")){
                                    tempdict.setValue(value, forKey: key as! String)
                                    let str = NSMutableString()
                                    str.appendString(key as! String)
                                    str.replaceOccurrencesOfString("Percent emissions reduction for a plaque score of ", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.length))
                                    emissions.append(Int(str as String)!)
                                    values.append(value as! Int)
                                }
                            }
                            //print("Tempdict",tempdict,values,emissions)
                            self.humanemissions = emissions
                            self.humanvalues = values
                        }catch{
                            
                        }
                    }
                }
                self.getmax("energy", arr: self.scoresarr)
                self.getmax("water", arr: self.scoresarr)
                self.getmax("waste", arr: self.scoresarr)
                self.getmax("transport", arr: self.scoresarr)
                self.getmax("human_experience", arr: self.scoresarr)
                self.getmin("energy", arr: self.scoresarr)
                self.getmin("water", arr: self.scoresarr)
                self.getmin("waste", arr: self.scoresarr)
                self.getmin("transport", arr: self.scoresarr)
                self.getmin("human_experience", arr: self.scoresarr)
                dispatch_async(dispatch_get_main_queue(), {
                    self.view.userInteractionEnabled = true
                    self.tableview.alpha = 1.0
                    self.spinner.hidden = true
                    self.getmax("energy", arr: self.scoresarr)
                })
    }
    
    
    func getmax(type:String,arr:NSMutableArray){
        var temparr = [Int]()
        
        for dict in arr{
            if(dict[type] is NSNull){
                temparr.append(0)
            }else{
                temparr.append(dict[type] as! Int)
            }
        }
        
        if(temparr.count > 0){
            if(type == "energy"){
                energymax = temparr.maxElement()!
                self.getmax("water", arr: self.scoresarr)
            }else if(type == "water"){
                watermax = temparr.maxElement()!
                self.getmax("waste", arr: self.scoresarr)
            }else if(type == "waste"){
                wastemax = temparr.maxElement()!
                self.getmax("transport", arr: self.scoresarr)
            }else if(type == "transport"){
                transportmax = temparr.maxElement()!
                self.getmax("human_experience", arr: self.scoresarr)
            }else if(type == "human_experience"){
                humanmax = temparr.maxElement()!
                self.getmin("energy", arr: self.scoresarr)
            }
        }
    }
    
    
    func getmin(type:String,arr:NSMutableArray){
        var temparr = [Int]()
        if(arr.count > 0){
            for dict in arr{
                //print(dict)
                if(dict[type] is NSNull){
                    temparr.append(0)
                }else{
                    temparr.append(dict[type] as! Int)
                }
            }
            if(temparr.count > 0){
                if(type == "energy"){
                    energymin = temparr.minElement()!
                    self.getmin("water", arr: self.scoresarr)
                }else if(type == "water"){
                    watermin = temparr.minElement()!
                    self.getmin("waste", arr: self.scoresarr)
                }else if(type == "waste"){
                    wastemin = temparr.minElement()!
                    self.getmin("transport", arr: self.scoresarr)
                }else if(type == "transport"){
                    transportmin = temparr.minElement()!
                    self.getmin("human_experience", arr: self.scoresarr)
                }else if(type == "human_experience"){
                    humanmin = temparr.minElement()!
                    self.gethighlowscores(self.scoresarr)
                    isloaded = true
                    self.tableview.reloadData()
                }
            }
        }
    }
    
    func gethighlowscores(arr:NSMutableArray){
        var tempp = 0 
        var fullarr = [Int]()
        for dict in arr{
            //print(dict)
            let temp = dict as! [String:AnyObject]
            for (_,value) in temp{
                if(value is NSNull){
                    tempp = tempp + 0
                }else{
                    tempp = tempp + (value as! Int)
                }
            }
            if(tempp > 0){
                fullarr.append(tempp)
            }
            tempp = 0
        }
        
        //print(fullarr)
        if(fullarr.count > 0){
            highduringreport = fullarr.maxElement()!
            lessduringreport = fullarr.minElement()!
        }
        
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
                    self.spinner.hidden = true
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
                            self.certdetails(credentials().subscription_key, leedid: self.buildingdetails["leed_id"] as! Int)
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 9
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 1){
            return 5
        }
        return 1
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tableview.reloadData()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height = UIScreen.mainScreen().bounds.size.height
        if(indexPath.section == 0){
            return 0.135 * height//0.095 * height
        }else if(indexPath.section == 2){
            return 0.39 * height
        }else if(indexPath.section == 1){
            return 0.069 * height
        }
        if(indexPath.section >= 3 && indexPath.section <= 7){
            
            if(indexPath.section == 3){
                if(energypercentagedata.count > 0 && energyscoreedata.count > 0){
                    return 0.50 * height
                }else if((energypercentagedata.count > 0 && energyscoreedata.count == 0) || energypercentagedata.count == 0 && energyscoreedata.count > 0){
                    return 0.34 * height
                }else{
                    return 0.18 * height
                }
            }else if(indexPath.section == 4){
                if(waterpercentagedata.count > 0 && waterscoreedata.count > 0){
                    return 0.50 * height
                }else if((waterpercentagedata.count > 0 && waterscoreedata.count == 0) || waterpercentagedata.count == 0 && waterscoreedata.count > 0){
                    return 0.34 * height
                }else{
                    return 0.18 * height
                }
            }else if(indexPath.section == 5){
                if(wastepercentagedata.count > 0 && wastescoreedata.count > 0){
                    return 0.50 * height
                }else if((wastepercentagedata.count > 0 && wastescoreedata.count == 0) || wastepercentagedata.count == 0 && wastescoreedata.count > 0){
                    return 0.34 * height
                }else{
                    return 0.18 * height
                }
            }else if(indexPath.section == 6){
                if(transitpercentagedata.count > 0 && transitscoreedata.count > 0){
                    return 0.50 * height
                }else if((transitpercentagedata.count > 0 && transitscoreedata.count == 0) || transitpercentagedata.count == 0 && transitscoreedata.count > 0){
                    return 0.34 * height
                }else{
                    return 0.18 * height
                }
            }else if(indexPath.section == 7){
                if(humanpercentagedata.count > 0 && humanscoreedata.count > 0){
                    return 0.50 * height
                }else if((humanpercentagedata.count > 0 && humanscoreedata.count == 0) || humanpercentagedata.count == 0 && humanscoreedata.count > 0){
                    return 0.34 * height
                }else{
                    return 0.18 * height
                }
            }
        }
        return 0.21 * height
    }
    
    func getnumberofdata(tag:Int) -> Int{
        let dict = self.analysisdict.mutableCopy() as! NSMutableDictionary
        var key = ""
        if(tag == 2){
            key = "energy"
        }else if(tag == 3){
            key = "water"
        }else if(tag == 4){
            key = "waste"
        }else if(tag == 5){
            key = "transit"
        }else if(tag == 6){
            key = "human"
        }
        
        var count = 0
        if(dict[key] is NSNull){
            
        }else{
            if(dict[key] != nil){
                if(dict[key]!["info_json"] is NSNull){
                    
                }else{
                    var str = dict[key]!["info_json"] as! String
                    let str1 = NSMutableString()
                    str1.appendString(str)
                    str1.replaceOccurrencesOfString("'", withString: "\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
                    //print(str1)
                    str = str1.mutableCopy() as! String
                    let jsonData = (str).dataUsingEncoding(NSUTF8StringEncoding)
                    do {
                        //print("dictsss ",dict)
                        var temp = dict[key] as! [NSString:AnyObject]
                        temp["info_json"] = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions()) as! NSDictionary
                        dict.setValue(temp, forKey: key)
                        //print(dict[key])
                        var getkey = "\(dict[key]!["category"]!! as! String) Plaque Score with 10% Lower Emissions"
                        if (dict[key]!["info_json"]!![getkey] != nil) {
                            // action is not nil, is a String type, and is now stored in actionString
                            count = count + 1
                        }else{
                            
                        }
                        
                        getkey = "\(dict[key]!["category"]!! as! String) Plaque Score with 20% Lower Emissions"
                        if (dict[key]!["info_json"]!![getkey] != nil) {
                            // action is not nil, is a String type, and is now stored in actionString
                            count = count + 1
                        }else{
                            
                        }
                        
                        getkey = "\(dict[key]!["category"]!! as! String) Plaque Score with 50% Lower Emissions"
                        if (dict[key]!["info_json"]!![getkey] != nil) {
                            // action is not nil, is a String type, and is now stored in actionString
                            count = count + 1
                        }else{
                            
                        }
                    }catch{
                        
                    }
                }
            }
        }
        return count
    }
    
    
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        /*if(indexPath.section == 1){
            self.tableview.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        }else{
            self.tableview.separatorStyle = UITableViewCellSeparatorStyle.None
        }*/
        if(indexPath.section == 0){
            let cell = tableview.dequeueReusableCellWithIdentifier("totalcell1")! as! totalanalysis1            
            var tempstring = NSMutableString()
            tempstring = ""
            let actualstring = NSMutableAttributedString()
            var tempostring = NSMutableAttributedString()
            cell.details.textColor = UIColor.darkGrayColor()
            tempostring = NSMutableAttributedString(string:(buildingdetails["name"] as? String)!)
            tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 13)! , range: NSMakeRange(0, tempostring.length))
            tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, tempostring.length))
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            tempostring = NSMutableAttributedString(string:"\n")
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:buildingdetails["street"] as! String)
                        actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            tempostring = NSMutableAttributedString(string:"\n")
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:buildingdetails["city"] as! String)
      
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            tempostring = NSMutableAttributedString(string:", ")
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:fullstatename)
            
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            tempostring = NSMutableAttributedString(string:" ")
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:buildingdetails["zip_code"] as! String)
               actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            tempostring = NSMutableAttributedString(string:"\n")
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            
            tempostring = NSMutableAttributedString(string:"\n")
            tempostring = NSMutableAttributedString(string:fullcountryname)
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            tempostring = NSMutableAttributedString(string:".")
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            print(actualstring)
            cell.details.attributedText = actualstring
            cell.leedid.numberOfLines = 3
            cell.details.numberOfLines = 4
            tempstring.deleteCharactersInRange(NSMakeRange(0, tempstring.length))
            tempstring.appendString(String(format: "%d",NSUserDefaults.standardUserDefaults().integerForKey("leed_id")))
            tempstring.appendString("\n")
            if let gross = buildingdetails["gross_area"] as? Int{
                tempstring.appendString(String(format: "%d Sq.Ft",gross))
            }else{
                tempstring.appendString(String(format: "0 Sq.Ft"))
            }
            
            //cell.leedid.text = tempstring as String
           // cell.gross.text = String(format: "%d Sq.Ft",buildingdetails["gross_area"] as! Int)
            
            //cell.duration.text = duration
            
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            //cell.backgroundColor = UIColor.clearColor()
            return cell
        }else if(indexPath.section == 1){
            let cell = tableview.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            if(indexPath.row == 0){
                cell.textLabel?.text = "Project ID"
                cell.detailTextLabel?.text = String(format: "%d",NSUserDefaults.standardUserDefaults().integerForKey("leed_id"))
            }else if(indexPath.row == 1){
                if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                cell.detailTextLabel?.text = ""
                }else{
                cell.detailTextLabel?.text = String(format: "%d Sq.Ft",buildingdetails["gross_area"] as! Int)
                }
                cell.textLabel?.text = "Gross Floor Area"
            }else if(indexPath.row == 2){
                cell.textLabel?.text = "Hours"
                if(buildingdetails["operating_hours"] == nil || buildingdetails["operating_hours"] is NSNull){
                    cell.detailTextLabel?.text = ""
                }else{
                    cell.detailTextLabel?.text = String(format: "%d",buildingdetails["operating_hours"] as! Int)
                }
            }else if(indexPath.row == 3){
                cell.textLabel?.text = "Occupants"
                if(buildingdetails["occupancy"] == nil || buildingdetails["occupancy"] is NSNull){
                    cell.detailTextLabel?.text = ""
                }else{
                    cell.detailTextLabel?.text = String(format: "%d",buildingdetails["occupancy"] as! Int)
                }
            }else if(indexPath.row == 4){
                cell.detailTextLabel?.text = duration
                cell.textLabel?.text = "Reporting Period"
            }
            return cell
        }else if(indexPath.section == 2){
            let cell = tableview.dequeueReusableCellWithIdentifier("totalcell2")! as! totalanalysis2
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.cview.current = Double(currentscore)
            cell.cview.max = Double(maxscore)
            if(cell.cview.max == 0.0){
                cell.cview.max = 100.0
            }            
            cell.cview.addUntitled1Animation()
           /* let view = circularprogress()
            view.frame = cell.cview.frame
            if(self.view.viewWithTag(26) != nil){
                self.view.viewWithTag(26)?.removeFromSuperview()
            }
            
            view.tag = 26
            
            view.current = Double(currentscore)
            view.max = Double(maxscore)
            if(isloaded == true){
                view.hidden = false
                view.addUntitled1Animation()
            }else{
                view.hidden = false
                view.current = 0
                view.max = 100
                cell.contentView.addSubview(view)
            }*/
            //print("Max score",view.current, view.max)
            
            let tempstring = NSMutableString()
              tempstring.appendString(String(format: "Highest score during reporting period:  %d", highduringreport))
            tempstring.appendString("\n")
            tempstring.appendString(String(format: "Lowest score during reporting period: 0"))// %d", lessduringreport))
            cell.highscore.adjustsFontSizeToFitWidth = true
            cell.highscore.text = tempstring as String
            cell.highscore.frame.origin.x = cell.textLabel!.frame.origin.x
            cell.layoutSubviews()
            //view.center = CGPointMake(cell.contentView.bounds.size.width/2,cell.contentView.bounds.size.height/2.5);
            return cell
        }
        else {
            if(indexPath.section == 3){
                if(energypercentagedata.count > 0 && energyscoreedata.count > 0){
                    let cell = tableview.dequeueReusableCellWithIdentifier("totalcell3")! as! totalanalysis3
                    let total: Float = 5
                    cell.slider1.minimumValue = 0.0
                    cell.slider1.tag = 10
                    var temparr = NSMutableArray()
                    var temparr1 = NSMutableArray()
                    if(energyscoreedata.count > 0 && energypercentagedata.count > 0){
                        temparr = energypercentagedata
                        temparr1 = energyscoreedata
                    }else if(energyscoreedata.count > 0 && energypercentagedata.count == 0){
                        temparr = energyscoreedata
                    }else if(energyscoreedata.count == 0 && energypercentagedata.count > 0){
                        temparr = energypercentagedata
                    }
                    cell.slider1.maximumValue = Float(temparr.count-1)
                    cell.slider2.maximumValue = Float(temparr1.count-1)
                    cell.slider2.minimumValue = 0.0
                    cell.slider2.tag = 20
                    
                    cell.slider1.value = 0.0
                    cell.slider1.setValue(0.0, animated: true)
                    var tempstr = temparr.objectAtIndex(energy1sel).allKeys.first as! String
                    var tempvalue = temparr.objectAtIndex(energy1sel).allValues.first
                    tempstr = tempstr.stringByReplacingOccurrencesOfString("Energy Plaque Score with", withString: "")
                    tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                    tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                    cell.l1.text = "If I reduce my emissions by \(tempstr as! String)"
                    cell.l2.text = "My new energy score will be \(Int(tempvalue as! NSNumber))"
                    tempstr = temparr1.objectAtIndex(energy2sel).allKeys.first as! String
                    tempvalue = temparr1.objectAtIndex(energy2sel).allValues.first
                    tempstr = tempstr.stringByReplacingOccurrencesOfString("Percent emissions reduction for a plaque score of", withString: "")
                    tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                    cell.l3.text = "If I want to increase my score to \(tempstr as! String)"
                    cell.l4.text = "I need to reduce my emission by \(Int(tempvalue as! NSNumber))%"
                    cell.slider2.addTarget(self, action: #selector(self.slider2Changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                    cell.slider1.addTarget(self, action: #selector(self.slider1Changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                    cell.slider1.value = Float(energy1sel)
                    cell.slider1.setValue(Float(energy1sel), animated: true)
                    cell.slider2.value = Float(energy2sel)
                    cell.slider2.setValue(Float(energy2sel), animated: true)
                    cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_energy")
                    cell.typename.text = "ENERGY"
                    cell.globalavg.text = String(format: "Global avg : %d", globalavgarr.objectAtIndex(0) as! Int)
                    cell.localavg.text = String(format: "Local avg : %d", localavgarr.objectAtIndex(0) as! Int)
                    cell.outoflbl.text = "\(energyscore) out of \(energymaxscore)"
                    cell.outoflbl.textColor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
                    cell.typename.textColor = cell.outoflbl.textColor
                    
                    return cell
                }else if((energypercentagedata.count > 0 && energyscoreedata.count == 0) || energypercentagedata.count == 0 && energyscoreedata.count > 0){
                    let cell = tableview.dequeueReusableCellWithIdentifier("totalcell4")! as! totalanalysis4
                    let total: Float = 5
                    cell.slider1.minimumValue = 0.0
                    cell.slider1.tag = 10
                    var temparr = NSMutableArray()
                    if(energyscoreedata.count > 0 && energypercentagedata.count > 0){
                        temparr = energypercentagedata
                    }else if(energyscoreedata.count > 0 && energypercentagedata.count == 0){
                        temparr = energyscoreedata
                    }else if(energyscoreedata.count == 0 && energypercentagedata.count > 0){
                        temparr = energypercentagedata
                    }
                    cell.slider1.maximumValue = Float(temparr.count-1)
                    cell.slider1.value = Float(energy1sel)
                    cell.slider1.setValue(Float(energy1sel), animated: true)
                    cell.slider1.addTarget(self, action: #selector(self.slider1Changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                    var tempstr = temparr.objectAtIndex(energy1sel).allKeys.first as! String
                    var tempvalue = temparr.objectAtIndex(energy1sel).allValues.first
                    tempstr = tempstr.stringByReplacingOccurrencesOfString("Energy Plaque Score with", withString: "")
                    tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                    tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                    cell.l1.text = "If I reduce my emissions by \(tempstr as! String)"
                    cell.l2.text = "My new energy score will be \(Int(tempvalue as! NSNumber))"
                    cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_energy")
                    cell.typename.text = "ENERGY"
                    cell.globalavg.numberOfLines = 3
                    cell.localavg.numberOfLines = 3
                    cell.globalavg.text = String(format: "Global avg : %d \nLocal avg : %d", globalavgarr.objectAtIndex(0) as! Int,localavgarr.objectAtIndex(0) as! Int)
                    cell.globalavg.frame.origin.x = cell.typeimg.frame.origin.x
                    
                    
                    var energyavg = 0
                    var t = 0, u = 0
                    for i in 0 ..< self.scoresarr.count{
                        var ar = self.scoresarr[i] as! NSDictionary
                        if(ar["energy"] != nil){
                            if(ar["energy"] is NSNull){
                                
                            }else{
                                t = t + (ar["energy"] as! Int/12)
                                energyavg = energyavg + (ar["energy"] as! Int)
                            }
                        }
                        u = u + 1
                    }
                    
                    print("Energy avg score", Float(energyavg/12))
                    print(round(Double(energyavg/12)))
                    print("Energy avg score", energyavg, t, u)
                    cell.localavg.text = String(format: "Highest score : %d \nLowest score : 0", energymax)
                    //cell.localavg.text = String(format: "Local avg : %d", localavgarr.objectAtIndex(0) as! Int)
                    cell.outoflbl.text = "\(energyscore) out of \(energymaxscore)"
                    cell.outoflbl.textColor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
                    cell.typename.textColor = cell.outoflbl.textColor
                    return cell
                }else{
                    let cell = tableview.dequeueReusableCellWithIdentifier("totalcell5")! as! totalanalysis5
                    cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_energy")
                    cell.typename.text = "ENERGY"
                    cell.globalavg.numberOfLines = 3
                    cell.localavg.numberOfLines = 3
                    cell.globalavg.text = String(format: "Global avg : %d \nLocal avg : %d", globalavgarr.objectAtIndex(0) as! Int,localavgarr.objectAtIndex(0) as! Int)
                    
                    var energyavg = 0
                    var t = 0, u = 0
                    for i in 0 ..< self.scoresarr.count{
                        var ar = self.scoresarr[i] as! NSDictionary
                        if(ar["energy"] != nil){
                            if(ar["energy"] is NSNull){
                                
                            }else{
                                t = t + (ar["energy"] as! Int/12)
                                energyavg = energyavg + (ar["energy"] as! Int)
                            }
                        }
                        u = u + 1
                    }
                    
                    print("Energy avg score", Float(energyavg/12))
                    print(round(Double(energyavg/12)))
                    print("Energy avg score", energyavg, t, u)
                    cell.localavg.text = String(format: "Highest score : %d \nLowest score : 0", energymax)
                    cell.outoflbl.text = "\(energyscore) out of \(energymaxscore)"
                    cell.outoflbl.textColor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
                    cell.typename.textColor = cell.outoflbl.textColor
                    cell.globalavg.frame.origin.x = cell.typeimg.frame.origin.x
                    return cell
                }
            }else if(indexPath.section == 4){
                if(waterpercentagedata.count > 0 && waterscoreedata.count > 0){
                    let cell = tableview.dequeueReusableCellWithIdentifier("totalcell3")! as! totalanalysis3
                    let total: Float = 5
                    cell.slider1.minimumValue = 0.0
                    cell.slider1.tag = 11
                    var temparr = NSMutableArray()
                    var temparr1 = NSMutableArray()
                    if(waterscoreedata.count > 0 && waterpercentagedata.count > 0){
                        temparr = waterpercentagedata
                        temparr1 = waterscoreedata
                    }else if(waterscoreedata.count > 0 && waterpercentagedata.count == 0){
                        temparr = waterscoreedata
                    }else if(waterscoreedata.count == 0 && waterpercentagedata.count > 0){
                        temparr = waterpercentagedata
                    }
                    cell.slider1.maximumValue = Float(temparr.count-1)
                    cell.slider2.maximumValue = Float(temparr1.count-1)
                    cell.slider2.minimumValue = 0.0
                    cell.slider2.tag = 21
                    cell.slider2.addTarget(self, action: #selector(self.slider2Changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                    cell.slider1.addTarget(self, action: #selector(self.slider1Changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                    var tempstr = temparr.objectAtIndex(water1sel).allKeys.first as! String
                    var tempvalue = temparr.objectAtIndex(water1sel).allValues.first
                    tempstr = tempstr.stringByReplacingOccurrencesOfString("Water Plaque Score with", withString: "")
                    tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                    tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                    cell.l1.text = "If I reduce my emissions by \(tempstr as! String)"
                    cell.l2.text = "My new water score will be \(Int(tempvalue as! NSNumber))"
                    tempstr = temparr1.objectAtIndex(water2sel).allKeys.first as! String
                    tempvalue = temparr1.objectAtIndex(water2sel).allValues.first
                    tempstr = tempstr.stringByReplacingOccurrencesOfString("Percent emissions reduction for a plaque score of", withString: "")
                    tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                    cell.l3.text = "If I want to increase my score to \(tempstr as! String)"
                    cell.l4.text = "I need to reduce my emission by \(Int(tempvalue as! NSNumber))%"
                    cell.slider1.value = Float(water1sel)
                    cell.slider1.setValue(Float(water1sel), animated: true)
                    cell.slider2.value = Float(water2sel)
                    cell.slider2.setValue(Float(water2sel), animated: true)
                    cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_water")
                    cell.typename.text = "WATER"
                    cell.globalavg.numberOfLines = 3
                    cell.localavg.numberOfLines = 3
                    cell.globalavg.text = String(format: "Global avg : %d \nLocal avg : %d", globalavgarr.objectAtIndex(1) as! Int,localavgarr.objectAtIndex(1) as! Int)
                    cell.localavg.text = String(format: "Highest score : %d \nLowest score : 0", watermax)
                    cell.outoflbl.textColor = UIColor.init(red: 0.303, green: 0.751, blue: 0.94, alpha: 1)
                    cell.outoflbl.text = "\(waterscore) out of \(watermaxscore)"
                    cell.typename.textColor = cell.outoflbl.textColor
                    cell.globalavg.frame.origin.x = cell.typeimg.frame.origin.x
                    
                    
                    return cell
                }else if((waterpercentagedata.count > 0 && waterscoreedata.count == 0) || waterpercentagedata.count == 0 && waterscoreedata.count > 0){
                    let cell = tableview.dequeueReusableCellWithIdentifier("totalcell4")! as! totalanalysis4
                    cell.slider1.minimumValue = 0.0
                    cell.slider1.tag = 11
                    var temparr = NSMutableArray()
                    if(waterscoreedata.count > 0 && waterpercentagedata.count > 0){
                        temparr = waterpercentagedata
                    }else if(waterscoreedata.count > 0 && waterpercentagedata.count == 0){
                        temparr = waterscoreedata
                    }else if(waterscoreedata.count == 0 && waterpercentagedata.count > 0){
                        temparr = waterpercentagedata
                    }
                    cell.slider1.maximumValue = Float(temparr.count-1)
                    var tempstr = temparr.objectAtIndex(water1sel).allKeys.first as! String
                    var tempvalue = temparr.objectAtIndex(water1sel).allValues.first
                    tempstr = tempstr.stringByReplacingOccurrencesOfString("Water Plaque Score with", withString: "")
                    tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                    tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                    cell.l1.text = "If I reduce my emissions by \(tempstr as! String)"
                    cell.l2.text = "My new water score will be \(Int(tempvalue as! NSNumber))"
                    cell.slider1.addTarget(self, action: #selector(self.slider1Changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                    cell.slider1.value = Float(water1sel)
                    cell.slider1.setValue(Float(water1sel), animated: true)
                    cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_water")
                    cell.typename.text = "WATER"
                    cell.globalavg.numberOfLines = 3
                    cell.localavg.numberOfLines = 3
                    cell.globalavg.text = String(format: "Global avg : %d \nLocal avg : %d", globalavgarr.objectAtIndex(1) as! Int,localavgarr.objectAtIndex(1) as! Int)
                    cell.localavg.text = String(format: "Highest score : %d \nLowest score : 0", watermax)
                    cell.outoflbl.textColor = UIColor.init(red: 0.303, green: 0.751, blue: 0.94, alpha: 1)
                    cell.outoflbl.text = "\(waterscore) out of \(watermaxscore)"
                    cell.typename.textColor = cell.outoflbl.textColor
                    cell.globalavg.frame.origin.x = cell.typeimg.frame.origin.x
                    
                    
                    return cell
                }else{
                    let cell = tableview.dequeueReusableCellWithIdentifier("totalcell5")! as! totalanalysis5
                    cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_water")
                    cell.typename.text = "WATER"
                    cell.globalavg.numberOfLines = 3
                    cell.localavg.numberOfLines = 3
                    cell.globalavg.text = String(format: "Global avg : %d \nLocal avg : %d", globalavgarr.objectAtIndex(1) as! Int,localavgarr.objectAtIndex(1) as! Int)
                    cell.localavg.text = String(format: "Highest score : %d \nLowest score : 0", watermax)
                    cell.outoflbl.textColor = UIColor.init(red: 0.303, green: 0.751, blue: 0.94, alpha: 1)
                    cell.outoflbl.text = "\(waterscore) out of \(watermaxscore)"
                    cell.typename.textColor = cell.outoflbl.textColor
                    cell.globalavg.frame.origin.x = cell.typeimg.frame.origin.x
                    return cell
                }
            }else if(indexPath.section == 5){
                if(wastepercentagedata.count > 0 && wastescoreedata.count > 0){
                    let cell = tableview.dequeueReusableCellWithIdentifier("totalcell3")! as! totalanalysis3
                    let total: Float = 5
                    cell.slider1.minimumValue = 0.0
                    cell.slider1.tag = 12
                    var temparr = NSMutableArray()
                    var temparr1 = NSMutableArray()
                    if(wastescoreedata.count > 0 && wastepercentagedata.count > 0){
                        temparr = wastepercentagedata
                        temparr1 = wastescoreedata
                    }else if(wastescoreedata.count > 0 && wastepercentagedata.count == 0){
                        temparr = wastescoreedata
                    }else if(wastescoreedata.count == 0 && wastepercentagedata.count > 0){
                        temparr = wastepercentagedata
                    }
                    cell.slider1.maximumValue = Float(temparr.count-1)
                    cell.slider2.maximumValue = Float(temparr1.count-1)
                    cell.slider2.minimumValue = 0.0
                    cell.slider2.tag = 22
                    cell.slider2.addTarget(self, action: #selector(self.slider2Changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                    cell.slider1.addTarget(self, action: #selector(self.slider1Changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                    var tempstr = temparr.objectAtIndex(waste1sel).allKeys.first as! String
                    var tempvalue = temparr.objectAtIndex(waste1sel).allValues.first
                    tempstr = tempstr.stringByReplacingOccurrencesOfString("Waste Plaque Score with", withString: "")
                    tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                    tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                    cell.l1.text = "If I reduce my emissions by \(tempstr as! String)"
                    cell.l2.text = "My new waste score will be \(Int(tempvalue as! NSNumber))"
                    tempstr = temparr1.objectAtIndex(waste2sel).allKeys.first as! String
                    tempvalue = temparr1.objectAtIndex(waste2sel).allValues.first
                    tempstr = tempstr.stringByReplacingOccurrencesOfString("Percent emissions reduction for a plaque score of", withString: "")
                    tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                    cell.l3.text = "If I want to increase my score to \(tempstr as! String)"
                    cell.l4.text = "I need to reduce my emission by \(Int(tempvalue as! NSNumber))%"
                    cell.slider1.value = Float(waste1sel)
                    cell.slider1.setValue(Float(waste1sel), animated: true)
                    cell.slider2.value = Float(waste2sel)
                    cell.slider2.setValue(Float(waste2sel), animated: true)
                    cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_waste")
                    cell.typename.text = "WASTE"
                    cell.globalavg.numberOfLines = 3
                    cell.localavg.numberOfLines = 3
                    cell.globalavg.text = String(format: "Global avg : %d \nLocal avg : %d", globalavgarr.objectAtIndex(2) as! Int,localavgarr.objectAtIndex(2) as! Int)
                    cell.localavg.text = String(format: "Highest score : %d \nLowest score : 0", wastemax)
                    cell.slider2.setValue(0.0, animated: true)
                    cell.outoflbl.text = "\(wastescore) out of \(wastemaxscore)"
                    cell.outoflbl.textColor = UIColor.init(red: 0.461, green: 0.76, blue: 0.629, alpha: 1)
                    cell.typename.textColor = cell.outoflbl.textColor
                    cell.globalavg.frame.origin.x = cell.typeimg.frame.origin.x
                    
                    
                    
                    
                    return cell
                }else if((wastepercentagedata.count > 0 && wastescoreedata.count == 0) || wastepercentagedata.count == 0 && wastescoreedata.count > 0){
                    let cell = tableview.dequeueReusableCellWithIdentifier("totalcell4")! as! totalanalysis4
                    cell.slider1.minimumValue = 0.0
                    cell.slider1.tag = 12
                    var temparr = NSMutableArray()
                    if(wastescoreedata.count > 0 && wastepercentagedata.count > 0){
                        temparr = wastepercentagedata
                    }else if(wastescoreedata.count > 0 && wastepercentagedata.count == 0){
                        temparr = wastescoreedata
                    }else if(wastescoreedata.count == 0 && wastepercentagedata.count > 0){
                        temparr = wastepercentagedata
                    }
                    var tempstr = temparr.objectAtIndex(waste1sel).allKeys.first as! String
                    var tempvalue = temparr.objectAtIndex(waste1sel).allValues.first
                    tempstr = tempstr.stringByReplacingOccurrencesOfString("Waste Plaque Score with", withString: "")
                    tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                    tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                    cell.l1.text = "If I reduce my emissions by \(tempstr as! String)"
                    cell.l2.text = "My new waste score will be \(Int(tempvalue as! NSNumber))"
                    cell.slider1.maximumValue = Float(temparr.count-1)
                    cell.slider1.addTarget(self, action: #selector(self.slider1Changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                    cell.slider1.value = Float(waste1sel)
                    cell.slider1.setValue(Float(waste1sel), animated: true)
                    cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_waste")
                    cell.typename.text = "WASTE"
                    cell.globalavg.numberOfLines = 3
                    cell.localavg.numberOfLines = 3
                    cell.globalavg.text = String(format: "Global avg : %d \nLocal avg : %d", globalavgarr.objectAtIndex(2) as! Int,localavgarr.objectAtIndex(2) as! Int)
                    cell.localavg.text = String(format: "Highest score : %d \nLowest score : 0", wastemax)
                    cell.outoflbl.text = "\(wastescore) out of \(wastemaxscore)"
                    cell.outoflbl.textColor = UIColor.init(red: 0.461, green: 0.76, blue: 0.629, alpha: 1)
                    cell.typename.textColor = cell.outoflbl.textColor
                    cell.globalavg.frame.origin.x = cell.typeimg.frame.origin.x
                    
                    
                    return cell
                }else{
                    let cell = tableview.dequeueReusableCellWithIdentifier("totalcell5")! as! totalanalysis5
                    cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_waste")
                    cell.typename.text = "WASTE"
                    cell.globalavg.numberOfLines = 3
                    cell.localavg.numberOfLines = 3
                    cell.globalavg.text = String(format: "Global avg : %d \nLocal avg : %d", globalavgarr.objectAtIndex(2) as! Int,localavgarr.objectAtIndex(2) as! Int)
                    cell.localavg.text = String(format: "Highest score : %d \nLowest score : 0", wastemax)
                    cell.outoflbl.text = "\(wastescore) out of \(wastemaxscore)"
                    cell.outoflbl.textColor = UIColor.init(red: 0.461, green: 0.76, blue: 0.629, alpha: 1)
                    cell.typename.textColor = cell.outoflbl.textColor
                    cell.globalavg.frame.origin.x = cell.typeimg.frame.origin.x
                    return cell
                }
            }else if(indexPath.section == 6){
                if(transitpercentagedata.count > 0 && transitscoreedata.count > 0){
                    let cell = tableview.dequeueReusableCellWithIdentifier("totalcell3")! as! totalanalysis3
                    let total: Float = 5
                    cell.slider1.minimumValue = 0.0
                    cell.slider1.tag = 13
                    var temparr = NSMutableArray()
                    var temparr1 = NSMutableArray()
                    if(transitscoreedata.count > 0 && transitpercentagedata.count > 0){
                        temparr = transitpercentagedata
                        temparr1 = transitscoreedata
                    }else if(transitscoreedata.count > 0 && transitpercentagedata.count == 0){
                        temparr = transitscoreedata
                    }else if(transitscoreedata.count == 0 && transitpercentagedata.count > 0){
                        temparr = transitpercentagedata
                    }
                    cell.slider1.maximumValue = Float(temparr.count-1)
                    cell.slider2.maximumValue = Float(temparr1.count-1)
                    cell.slider2.minimumValue = 0.0
                    cell.slider2.tag = 23
                    var tempstr = temparr.objectAtIndex(transit1sel).allKeys.first as! String
                    var tempvalue = temparr.objectAtIndex(transit1sel).allValues.first
                    tempstr = tempstr.stringByReplacingOccurrencesOfString("Transportation Plaque Score with", withString: "")
                    tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                    tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                    cell.l1.text = "If I reduce my emissions by \(tempstr as! String)"
                    cell.l2.text = "My new transit score will be \(Int(tempvalue as! NSNumber))"
                    tempstr = temparr1.objectAtIndex(transit2sel).allKeys.first as! String
                    tempvalue = temparr1.objectAtIndex(transit2sel).allValues.first
                    tempstr = tempstr.stringByReplacingOccurrencesOfString("Percent emissions reduction for a plaque score of", withString: "")
                    tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                    cell.l3.text = "If I want to increase my score to \(tempstr as! String)"
                    cell.l4.text = "I need to reduce my emission by \(Int(tempvalue as! NSNumber))%"
                    cell.slider2.addTarget(self, action: #selector(self.slider2Changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                    cell.slider1.addTarget(self, action: #selector(self.slider1Changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                    cell.slider1.value = Float(transit1sel)
                    cell.slider1.setValue(Float(transit1sel), animated: true)
                    cell.slider2.value = Float(transit2sel)
                    cell.slider2.setValue(Float(transit2sel), animated: true)
                    cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_transport")
                    cell.typename.text = "TRANSPORTATION"
                    cell.globalavg.numberOfLines = 3
                    cell.localavg.numberOfLines = 3
                    cell.globalavg.text = String(format: "Global avg : %d \nLocal avg : %d", globalavgarr.objectAtIndex(3) as! Int,localavgarr.objectAtIndex(3) as! Int)
                    cell.localavg.text = String(format: "Highest score : %d \nLowest score : 0", transportmax)
                    cell.outoflbl.text = "\(transportscore) out of \(transportmaxscore)"
                    cell.outoflbl.textColor = UIColor.init(red: 0.572, green: 0.556, blue: 0.505, alpha: 1)
                    cell.typename.textColor = cell.outoflbl.textColor
                    cell.globalavg.frame.origin.x = cell.typeimg.frame.origin.x
                    
                    
                    
                    
                    return cell
                }else if((transitpercentagedata.count > 0 && transitscoreedata.count == 0) || transitpercentagedata.count == 0 && transitscoreedata.count > 0){
                    let cell = tableview.dequeueReusableCellWithIdentifier("totalcell4")! as! totalanalysis4
                    cell.slider1.minimumValue = 0.0
                    cell.slider1.tag = 13
                    var temparr = NSMutableArray()
                    if(transitscoreedata.count > 0 && transitpercentagedata.count > 0){
                        temparr = transitpercentagedata
                    }else if(transitscoreedata.count > 0 && transitpercentagedata.count == 0){
                        temparr = transitscoreedata
                    }else if(transitscoreedata.count == 0 && transitpercentagedata.count > 0){
                        temparr = transitpercentagedata
                    }
                    cell.slider1.maximumValue = Float(temparr.count-1)
                    var tempstr = temparr.objectAtIndex(transit1sel).allKeys.first as! String
                    var tempvalue = temparr.objectAtIndex(transit1sel).allValues.first
                    tempstr = tempstr.stringByReplacingOccurrencesOfString("Transportation Plaque Score with", withString: "")
                    tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                    tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                    cell.l1.text = "If I reduce my emissions by \(tempstr as! String)"
                    cell.l2.text = "My new transit score will be \(Int(tempvalue as! NSNumber))"
                    cell.slider1.addTarget(self, action: #selector(self.slider1Changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                    cell.slider1.value = Float(transit1sel)
                    cell.slider1.setValue(Float(transit1sel), animated: true)
                    cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_transport")
                    cell.typename.text = "TRANSPORTATION"
                    cell.globalavg.numberOfLines = 3
                    cell.localavg.numberOfLines = 3
                    cell.globalavg.text = String(format: "Global avg : %d \nLocal avg : %d", globalavgarr.objectAtIndex(3) as! Int,localavgarr.objectAtIndex(3) as! Int)
                    cell.localavg.text = String(format: "Highest score : %d \nLowest score : 0", transportmax)
                    cell.outoflbl.text = "\(transportscore) out of \(transportmaxscore)"
                    cell.outoflbl.textColor = UIColor.init(red: 0.572, green: 0.556, blue: 0.505, alpha: 1)
                    cell.typename.textColor = cell.outoflbl.textColor
                    cell.globalavg.frame.origin.x = cell.typeimg.frame.origin.x
                    
                    
                    return cell
                }else{
                    let cell = tableview.dequeueReusableCellWithIdentifier("totalcell5")! as! totalanalysis5
                    cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_transport")
                    cell.typename.text = "TRANSPORTATION"
                    cell.globalavg.numberOfLines = 3
                    cell.localavg.numberOfLines = 3
                    cell.globalavg.text = String(format: "Global avg : %d \nLocal avg : %d", globalavgarr.objectAtIndex(3) as! Int,localavgarr.objectAtIndex(3) as! Int)
                    cell.localavg.text = String(format: "Highest score : %d \nLowest score : 0", transportmax)
                    cell.outoflbl.text = "\(transportscore) out of \(transportmaxscore)"
                    cell.outoflbl.textColor = UIColor.init(red: 0.572, green: 0.556, blue: 0.505, alpha: 1)
                    cell.typename.textColor = cell.outoflbl.textColor
                    cell.globalavg.frame.origin.x = cell.typeimg.frame.origin.x
                    return cell
                }
            }else if(indexPath.section == 7){
                if(humanpercentagedata.count > 0 && humanscoreedata.count > 0){
                    let cell = tableview.dequeueReusableCellWithIdentifier("totalcell3")! as! totalanalysis3
                    let total: Float = 5
                    cell.slider1.minimumValue = 0.0
                    cell.slider1.tag = 14
                    var temparr = NSMutableArray()
                    var temparr1 = NSMutableArray()
                    if(humanscoreedata.count > 0 && humanpercentagedata.count > 0){
                        temparr = humanpercentagedata
                        temparr1 = humanscoreedata
                    }else if(humanscoreedata.count > 0 && humanpercentagedata.count == 0){
                        temparr = humanscoreedata
                    }else if(humanscoreedata.count == 0 && humanpercentagedata.count > 0){
                        temparr = humanpercentagedata
                    }
                    cell.slider1.maximumValue = Float(temparr.count-1)
                    cell.slider2.maximumValue = Float(temparr1.count-1)
                    cell.slider2.minimumValue = 0.0
                    cell.slider2.tag = 24
                    var tempstr = temparr.objectAtIndex(human1sel).allKeys.first as! String
                    var tempvalue = temparr.objectAtIndex(human1sel).allValues.first
                    tempstr = tempstr.stringByReplacingOccurrencesOfString("Human Experience Plaque Score with", withString: "")
                    tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                    tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                    cell.l1.text = "If I reduce my emissions by \(tempstr as! String)"
                    cell.l2.text = "My new human experience score will be \(Int(tempvalue as! NSNumber))"
                    tempstr = temparr1.objectAtIndex(human2sel).allKeys.first as! String
                    tempvalue = temparr1.objectAtIndex(human2sel).allValues.first
                    tempstr = tempstr.stringByReplacingOccurrencesOfString("Percent emissions reduction for a plaque score of", withString: "")
                    tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                    cell.l3.text = "If I want to increase my score to \(tempstr as! String)"
                    cell.l4.text = "I need to reduce my emission by \(Int(tempvalue as! NSNumber))%"
                    self.slider1Changed(cell.slider1)
                    self.slider2Changed(cell.slider2)
                    cell.slider2.addTarget(self, action: #selector(self.slider2Changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                    cell.slider1.addTarget(self, action: #selector(self.slider1Changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                    cell.slider1.value = Float(human1sel)
                    cell.slider1.setValue(Float(human1sel), animated: true)
                    cell.slider2.value = Float(human2sel)
                    cell.slider2.setValue(Float(human2sel), animated: true)
                    cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_human")
                    cell.typename.text = "HUMAN EXPERIENCE"
                    cell.globalavg.numberOfLines = 3
                    cell.localavg.numberOfLines = 3
                    cell.globalavg.text = String(format: "Global avg : %d \nLocal avg : %d", globalavgarr.objectAtIndex(4) as! Int,localavgarr.objectAtIndex(4) as! Int)
                    cell.localavg.text = String(format: "Highest score : %d \nLowest score : 0", humanmax)
                    cell.outoflbl.text = "\(humanscore) out of \(humanmaxscore)"
                    cell.outoflbl.textColor = UIColor.init(red: 0.92, green: 0.609, blue: 0.236, alpha: 1)
                    cell.typename.textColor = cell.outoflbl.textColor
                    cell.globalavg.frame.origin.x = cell.typeimg.frame.origin.x
                    
                    
                    
                    
                    return cell
                }else if((humanpercentagedata.count > 0 && humanscoreedata.count == 0) || humanpercentagedata.count == 0 && humanscoreedata.count > 0){
                    let cell = tableview.dequeueReusableCellWithIdentifier("totalcell4")! as! totalanalysis4
                    cell.slider1.minimumValue = 0.0
                    cell.slider1.tag = 14
                    var temparr = NSMutableArray()
                    if(humanscoreedata.count > 0 && humanpercentagedata.count > 0){
                        temparr = humanpercentagedata
                    }else if(humanscoreedata.count > 0 && humanpercentagedata.count == 0){
                        temparr = humanscoreedata
                    }else if(humanscoreedata.count == 0 && humanpercentagedata.count > 0){
                        temparr = humanpercentagedata
                    }
                    var tempstr = temparr.objectAtIndex(human1sel).allKeys.first as! String
                    var tempvalue = temparr.objectAtIndex(human1sel).allValues.first
                    tempstr = tempstr.stringByReplacingOccurrencesOfString("Human Experience Plaque Score with", withString: "")
                    tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                    tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                    cell.l1.text = "If I reduce my emissions by \(tempstr as! String)"
                    cell.l2.text = "My new human experience score will be \(Int(tempvalue as! NSNumber))"
                    cell.slider1.maximumValue = Float(temparr.count-1)
                    cell.slider1.addTarget(self, action: #selector(self.slider1Changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                    cell.slider1.value = Float(human1sel)
                    cell.slider1.setValue(Float(human1sel), animated: true)
                    cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_human")
                    cell.typename.text = "HUMAN EXPERIENCE"
                    cell.globalavg.numberOfLines = 3
                    cell.localavg.numberOfLines = 3
                    cell.globalavg.text = String(format: "Global avg : %d \nLocal avg : %d", globalavgarr.objectAtIndex(4) as! Int,localavgarr.objectAtIndex(4) as! Int)
                    cell.localavg.text = String(format: "Highest score : %d \nLowest score : 0", humanmax)
                    cell.outoflbl.text = "\(humanscore) out of \(humanmaxscore)"
                    cell.outoflbl.textColor = UIColor.init(red: 0.92, green: 0.609, blue: 0.236, alpha: 1)
                    cell.typename.textColor = cell.outoflbl.textColor
                    cell.globalavg.frame.origin.x = cell.typeimg.frame.origin.x
                    
                    
                    return cell
                }else{
                    let cell = tableview.dequeueReusableCellWithIdentifier("totalcell5")! as! totalanalysis5
                    cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_human")
                    cell.typename.text = "HUMAN EXPERIENCE"
                    cell.globalavg.numberOfLines = 3
                    cell.localavg.numberOfLines = 3
                    cell.globalavg.text = String(format: "Global avg : %d \nLocal avg : %d", globalavgarr.objectAtIndex(4) as! Int,localavgarr.objectAtIndex(4) as! Int)
                    cell.localavg.text = String(format: "Highest score : %d \nLowest score : 0", humanmax)
                    cell.outoflbl.text = "\(humanscore) out of \(humanmaxscore)"
                    cell.outoflbl.textColor = UIColor.init(red: 0.92, green: 0.609, blue: 0.236, alpha: 1)
                    cell.typename.textColor = cell.outoflbl.textColor
                    cell.globalavg.frame.origin.x = cell.typeimg.frame.origin.x
                    return cell
                }
            }
            
            /*let cell = tableview.dequeueReusableCellWithIdentifier("totalcell3")! as! totalanalysis3
             if(indexPath.section == 2){
             cell.typename.text = "ENERGY"
             cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_energy")
             cell.typeimg2.image = UIImage.init(named: "energy_small")
             cell.typename.textColor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
             }else if(indexPath.section == 3){
             cell.typename.text = "WATER"
             cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_water")
             cell.typeimg2.image = UIImage.init(named: "water_small")
             cell.typename.textColor = UIColor.init(red: 0.303, green: 0.751, blue: 0.94, alpha: 1)
             }
             else if(indexPath.section == 4){
             cell.typename.text = "WASTE"
             cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_waste")
             cell.typeimg2.image = UIImage.init(named: "waste_small")
             cell.typename.textColor = UIColor.init(red: 0.468, green: 0.755, blue: 0.629, alpha: 1)
             }else if(indexPath.section == 5){
             cell.typename.text = "TRANSPORTATION"
             cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_transport")
             cell.typeimg2.image = UIImage.init(named: "transport_small")
             cell.typename.textColor = UIColor.init(red: 0.572, green: 0.556, blue: 0.509, alpha: 1)
             }else if(indexPath.section == 6){
             cell.typename.text = "HUMAN EXPERIENCE"
             cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_human")
             cell.typeimg2.image = UIImage.init(named: "human_small")
             cell.typename.textColor = UIColor.init(red: 0.91, green: 0.604, blue: 0.267, alpha: 1)
             }*/
            let cell = tableview.dequeueReusableCellWithIdentifier("certcell")! as! certcell
            let dict = certificationsdict
            var titles = NSMutableAttributedString()
            
            if let rating = dict["ERatingSys"] as? String{
                if(rating == ""){
                    cell.certname.text = ""//"Not available"
                }else{
                    cell.certname.text = "\(dict["ERatingSys"] as! String)"
                }
            }else{
                cell.certname.text = ""//"Not available"
            }
            
            titles = NSMutableAttributedString(string: "CURRENT LEVEL : ")
            titles.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: NSMakeRange(0, titles.length))
            titles.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 12)! , range: NSMakeRange(0, titles.length))
            if let level = dict["EPrecertLevel"] as? String{
                if(level == ""){
                    titles.appendAttributedString(NSAttributedString.init(string: ""))
                    cell.certlevel.attributedText = titles
                }else{
                    titles.appendAttributedString(NSAttributedString.init(string: dict["EPrecertLevel"] as! String))
                    cell.certlevel.attributedText = titles
                    //"\(titles.s):\(dict["EPrecertLevel"] as! String)"
                }
            }else{
                titles.appendAttributedString(NSAttributedString.init(string: ""))
                cell.certlevel.attributedText = titles
            }
            titles.deleteCharactersInRange(NSMakeRange(0, titles.length))
            titles = NSMutableAttributedString(string: "DATE AWARDED: ")
            titles.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: NSMakeRange(0, titles.length))
            titles.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 12)! , range: NSMakeRange(0, titles.length))
            
            if let level = dict["EPrecertAcptdate"] as? String{
                if(level == "" || level == "0000-00-00"){
                    titles.appendAttributedString(NSAttributedString.init(string: ""))
                    cell.certdate.attributedText = titles
                }else{
                    titles.appendAttributedString(NSAttributedString.init(string: dict["EPrecertAcptdate"] as! String))
                    cell.certdate.attributedText = titles
                }
            }else{
                titles.appendAttributedString(NSAttributedString.init(string: ""))
                cell.certdate.attributedText = titles
            }
            titles.deleteCharactersInRange(NSMakeRange(0, titles.length))
            titles = NSMutableAttributedString(string: "OTHER CERTIFICATION DATES : ")
            titles.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: NSMakeRange(0, titles.length))
            titles.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 12)! , range: NSMakeRange(0, titles.length))
            titles.appendAttributedString(NSAttributedString.init(string: ""))
            cell.othercert.attributedText = titles
            
            
            return cell
        }
        
        
        
        
    }
    
    func slider1Changed(sender: UISlider) {
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        print(sender.value)
        if(sender.tag == 10){
            //1st energy slider1
            var temparr = NSMutableArray()
            if(energyscoreedata.count > 0 && energypercentagedata.count > 0){
                temparr = energypercentagedata
            }else if(energyscoreedata.count > 0 && energypercentagedata.count == 0){
                temparr = energyscoreedata
            }else if(energyscoreedata.count == 0 && energypercentagedata.count > 0){
                temparr = energypercentagedata
            }
            var cell = tableview.cellForRowAtIndexPath(NSIndexPath.init(forRow: 0, inSection: 3))
            if(cell is totalanalysis3){
                var c = cell as! totalanalysis3
                var tempstr = temparr.objectAtIndex(Int(sender.value)).allKeys.first as! String
                var tempvalue = temparr.objectAtIndex(Int(sender.value)).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Energy Plaque Score with", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                c.l1.text = "If I reduce my emissions by \(tempstr as! String)"
                c.l2.text = "My new energy score will be \(Int(tempvalue as! NSNumber))"
                
                print(Int(sender.value))
                print(temparr.count)
            }else if(cell is totalanalysis4){
                var c = cell as! totalanalysis4
                var tempstr = temparr.objectAtIndex(Int(sender.value)).allKeys.first as! String
                var tempvalue = temparr.objectAtIndex(Int(sender.value)).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Energy Plaque Score with", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                c.l1.text = "If I reduce my emissions by \(tempstr as! String)"
                c.l2.text = "My new energy score will be \(Int(tempvalue as! NSNumber))"
            }
            energy1sel = Int(sender.value)
        }else if(sender.tag == 11){
            //1st energy slider1
            var temparr = NSMutableArray()
            if(waterscoreedata.count > 0 && waterpercentagedata.count > 0){
                temparr = waterpercentagedata
            }else if(waterscoreedata.count > 0 && waterpercentagedata.count == 0){
                temparr = waterscoreedata
            }else if(waterscoreedata.count == 0 && waterpercentagedata.count > 0){
                temparr = waterpercentagedata
            }
            var cell = tableview.cellForRowAtIndexPath(NSIndexPath.init(forRow: 0, inSection: 4))
            if(cell is totalanalysis3){
                var c = cell as! totalanalysis3
                var tempstr = temparr.objectAtIndex(Int(sender.value)).allKeys.first as! String
                var tempvalue = temparr.objectAtIndex(Int(sender.value)).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Water Plaque Score with", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                c.l1.text = "If I reduce my emissions by \(tempstr as! String)"
                c.l2.text = "My new water score will be \(Int(tempvalue as! NSNumber))"
            }else if(cell is totalanalysis4){
                var c = cell as! totalanalysis4
                var tempstr = temparr.objectAtIndex(Int(sender.value)).allKeys.first as! String
                var tempvalue = temparr.objectAtIndex(Int(sender.value)).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Water Plaque Score with", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                c.l1.text = "If I reduce my emissions by \(tempstr as! String)"
                c.l2.text = "My new water score will be \(Int(tempvalue as! NSNumber))"
            }
            water1sel = Int(sender.value)
        }else if(sender.tag == 12){
            //1st waste slider1
            var temparr = NSMutableArray()
            if(wastescoreedata.count > 0){
                temparr = wastescoreedata
            }else{
                temparr = wastepercentagedata
            }
            var cell = tableview.cellForRowAtIndexPath(NSIndexPath.init(forRow: 0, inSection: 5))
            if(cell is totalanalysis3){
                var c = cell as! totalanalysis3
                var tempstr = temparr.objectAtIndex(Int(sender.value)).allKeys.first as! String
                var tempvalue = temparr.objectAtIndex(Int(sender.value)).allValues.first
                c.l1.text = tempstr as! String
                c.l2.text = "\(Int(tempvalue as! NSNumber))"
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Waste Plaque Score with", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Waste Emissions", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                c.l1.text = "If I reduce my emissions by \(tempstr as! String)"
                c.l2.text = "My new waste score will be \(Int(tempvalue as! NSNumber))"
            }else if(cell is totalanalysis4){
                var c = cell as! totalanalysis4
                var tempstr = temparr.objectAtIndex(Int(sender.value)).allKeys.first as! String
                var tempvalue = temparr.objectAtIndex(Int(sender.value)).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Waste Plaque Score with", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                c.l1.text = "If I reduce my emissions by \(tempstr as! String)"
                c.l2.text = "My new waste score will be \(Int(tempvalue as! NSNumber))"
            }
            waste1sel = Int(sender.value)
        }else if(sender.tag == 13){
            //1st transit slider1
            var temparr = NSMutableArray()
            if(transitscoreedata.count > 0){
                temparr = transitscoreedata
            }else{
                temparr = transitpercentagedata
            }
            var cell = tableview.cellForRowAtIndexPath(NSIndexPath.init(forRow: 0, inSection: 6))
            if(cell is totalanalysis3){
                var c = cell as! totalanalysis3
                var tempstr = temparr.objectAtIndex(Int(sender.value)).allKeys.first as! String
                var tempvalue = temparr.objectAtIndex(Int(sender.value)).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Transportation Plaque Score with", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                c.l1.text = "If I reduce my emissions by \(tempstr as! String)"
                c.l2.text = "My new transit score will be \(Int(tempvalue as! NSNumber))"
            }else if(cell is totalanalysis4){
                var c = cell as! totalanalysis4
                var tempstr = temparr.objectAtIndex(Int(sender.value)).allKeys.first as! String
                var tempvalue = temparr.objectAtIndex(Int(sender.value)).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Transportation Plaque Score with", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                c.l1.text = "If I reduce my emissions by \(tempstr as! String)"
                c.l2.text = "My new transit score will be \(Int(tempvalue as! NSNumber))"
            }else if(cell is totalanalysis5){
                var c = cell as! totalanalysis5
            }
            transit1sel = Int(sender.value)
        }else if(sender.tag == 14){
            //1st human slider1
            var temparr = NSMutableArray()
            if(humanscoreedata.count > 0){
                temparr = humanscoreedata
            }else{
                temparr = humanpercentagedata
            }
            var cell = tableview.cellForRowAtIndexPath(NSIndexPath.init(forRow: 0, inSection: 7))
            if(cell is totalanalysis3){
                var c = cell as! totalanalysis3
                var tempstr = temparr.objectAtIndex(Int(sender.value)).allKeys.first as! String
                var tempvalue = temparr.objectAtIndex(Int(sender.value)).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Human Experience Plaque Score with", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                c.l1.text = "If I reduce my emissions by \(tempstr as! String)"
                c.l2.text = "My new human experience score will be \(Int(tempvalue as! NSNumber))"
            }else if(cell is totalanalysis4){
                var c = cell as! totalanalysis4
                var tempstr = temparr.objectAtIndex(Int(sender.value)).allKeys.first as! String
                var tempvalue = temparr.objectAtIndex(Int(sender.value)).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Human Experience Plaque Score with", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                c.l1.text = "If I reduce my emissions by \(tempstr as! String)"
                c.l2.text = "My new human experience score will be \(Int(tempvalue as! NSNumber))"
            }else if(cell is totalanalysis5){
                var c = cell as! totalanalysis5
            }
            human1sel = Int(sender.value)
        }
    }
    
    func slider2Changed(sender: UISlider) {
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        if(sender.tag == 20){
            var temparr = NSMutableArray()
            if(energyscoreedata.count > 0 && energypercentagedata.count > 0){
                temparr = energypercentagedata
            }else if(energyscoreedata.count > 0 && energypercentagedata.count == 0){
                temparr = energyscoreedata
            }else if(energyscoreedata.count == 0 && energypercentagedata.count > 0){
                temparr = energypercentagedata
            }
            var cell = tableview.cellForRowAtIndexPath(NSIndexPath.init(forRow: 0, inSection: 3))
            if(cell is totalanalysis3){
                var c = cell as! totalanalysis3
                var tempstr = temparr.objectAtIndex(Int(sender.value)).allKeys.first as! String
                var tempvalue = temparr.objectAtIndex(Int(sender.value)).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Percent emissions reduction for a plaque score of", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                c.l3.text = "If I want to increase my score to \(tempstr as! String)"
                c.l4.text = "I need to reduce my emission by \(Int(tempvalue as! NSNumber))%"
            }else if(cell is totalanalysis4){
                var c = cell as! totalanalysis4
            }else if(cell is totalanalysis5){
                var c = cell as! totalanalysis5
            }
            energy2sel = Int(sender.value)
        }else if(sender.tag == 21){
            var temparr = NSMutableArray()
            if(waterscoreedata.count > 0 && waterpercentagedata.count > 0){
                temparr = waterpercentagedata
            }else if(waterscoreedata.count > 0 && waterpercentagedata.count == 0){
                temparr = waterscoreedata
            }else if(waterscoreedata.count == 0 && waterpercentagedata.count > 0){
                temparr = waterpercentagedata
            }
            var cell = tableview.cellForRowAtIndexPath(NSIndexPath.init(forRow: 0, inSection: 4))
            if(cell is totalanalysis3){
                var c = cell as! totalanalysis3
                var tempstr = temparr.objectAtIndex(Int(sender.value)).allKeys.first as! String
                var tempvalue = temparr.objectAtIndex(Int(sender.value)).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Percent emissions reduction for a plaque score of", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                c.l3.text = "If I want to increase my score to \(tempstr as! String)"
                c.l4.text = "I need to reduce my emission by \(Int(tempvalue as! NSNumber))%"
            }else if(cell is totalanalysis4){
                var c = cell as! totalanalysis4
            }else if(cell is totalanalysis5){
                var c = cell as! totalanalysis5
            }
            water2sel = Int(sender.value)
        }else if(sender.tag == 22){
            var temparr = NSMutableArray()
            if(wastescoreedata.count > 0 && wastepercentagedata.count > 0){
                temparr = wastepercentagedata
            }else if(wastescoreedata.count > 0 && wastepercentagedata.count == 0){
                temparr = wastescoreedata
            }else if(wastescoreedata.count == 0 && wastepercentagedata.count > 0){
                temparr = wastepercentagedata
            }
            var cell = tableview.cellForRowAtIndexPath(NSIndexPath.init(forRow: 0, inSection: 5))
            if(cell is totalanalysis3){
                var c = cell as! totalanalysis3
                var tempstr = temparr.objectAtIndex(Int(sender.value)).allKeys.first as! String
                var tempvalue = temparr.objectAtIndex(Int(sender.value)).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Percent emissions reduction for a plaque score of", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                c.l3.text = "If I want to increase my score to \(tempstr as! String)"
                c.l4.text = "I need to reduce my emission by \(Int(tempvalue as! NSNumber))%"
            }else if(cell is totalanalysis4){
                var c = cell as! totalanalysis4
            }else if(cell is totalanalysis5){
                var c = cell as! totalanalysis5
            }
            waste2sel = Int(sender.value)
        }else if(sender.tag == 23){
            var temparr = NSMutableArray()
            if(transitscoreedata.count > 0 && transitpercentagedata.count > 0){
                temparr = transitpercentagedata
            }else if(transitscoreedata.count > 0 && transitpercentagedata.count == 0){
                temparr = transitscoreedata
            }else if(transitscoreedata.count == 0 && transitpercentagedata.count > 0){
                temparr = transitpercentagedata
            }
            var cell = tableview.cellForRowAtIndexPath(NSIndexPath.init(forRow: 0, inSection: 6))
            if(cell is totalanalysis3){
                var c = cell as! totalanalysis3
                var tempstr = temparr.objectAtIndex(Int(sender.value)).allKeys.first as! String
                var tempvalue = temparr.objectAtIndex(Int(sender.value)).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Percent emissions reduction for a plaque score of", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                c.l3.text = "If I want to increase my score to \(tempstr as! String)"
                c.l4.text = "I need to reduce my emission by \(Int(tempvalue as! NSNumber))%"
            }else if(cell is totalanalysis4){
                var c = cell as! totalanalysis4
            }else if(cell is totalanalysis5){
                var c = cell as! totalanalysis5
            }
            transit2sel = Int(sender.value)
        }else if(sender.tag == 24){
            var temparr = NSMutableArray()
            if(humanscoreedata.count > 0 && humanpercentagedata.count > 0){
                temparr = humanpercentagedata
            }else if(humanscoreedata.count > 0 && humanpercentagedata.count == 0){
                temparr = humanscoreedata
            }else if(humanscoreedata.count == 0 && humanpercentagedata.count > 0){
                temparr = humanpercentagedata
            }
            var cell = tableview.cellForRowAtIndexPath(NSIndexPath.init(forRow: 0, inSection: 7))
            if(cell is totalanalysis3){
                var c = cell as! totalanalysis3
                var tempstr = temparr.objectAtIndex(Int(sender.value)).allKeys.first as! String
                var tempvalue = temparr.objectAtIndex(Int(sender.value)).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Percent emissions reduction for a plaque score of", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                c.l3.text = "If I want to increase my score to \(tempstr as! String)"
                c.l4.text = "I need to reduce my emission by \(Int(tempvalue as! NSNumber))%"
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Human Experience Plaque Score with", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                c.l1.text = "If I reduce my emissions by \(tempstr as! String)"
                c.l2.text = "My new human experience score will be \(Int(tempvalue as! NSNumber))"
                
            }else if(cell is totalanalysis4){
                var c = cell as! totalanalysis4
                
            }else if(cell is totalanalysis5){
                var c = cell as! totalanalysis5
            }
            human2sel = Int(sender.value)
        }
    }
    
    
    func click(sender:UIButton){
        sel = sender.tag
        self.performSegueWithIdentifier("gotograph", sender: nil)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if(indexPath.section == 0){
            print("Anslysis dict",analysisdict)
            if(analysisdict.count > 0){
            self.performSegueWithIdentifier("overalldetails", sender: nil)
            }
        }
        else{
            if(indexPath.section > 2 && indexPath.section != 8){
            let button = UIButton()
            button.tag = 48 + (indexPath.section - 1)
            self.click(button)
            }
        }
        //tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func energyselect(sender:UITapGestureRecognizer){
        
    }
    
    func waterselect(sender:UITapGestureRecognizer){
        
    }
    func wasteselect(sender:UITapGestureRecognizer){
        
    }
    func transportselect(sender:UITapGestureRecognizer){
        
    }
    func humanselect(sender:UITapGestureRecognizer){
        
    }
    
    func certselect(sender:UITapGestureRecognizer){
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "gotographs"){
            let split = segue.destinationViewController as! UISplitViewController
            let nav = split.viewControllers[0] as! UINavigationController
            let vc = nav.viewControllers[0] as! listofgraphs
            vc.performancescoresarr = reportedscores
        }
        else if(segue.identifier == "overalldetails"){
            let vc = segue.destinationViewController as! overalldetails
            vc.datearr = datearr
            vc.analysisdict = analysisdict
            
            vc.buildingdetails = buildingdetails
            vc.highduringreport = highduringreport
            vc.globalavgarr = globalavgarr
            vc.localavgarr = localavgarr
            vc.lessduringreport = lessduringreport
            vc.energyemissions = energyemissions
            vc.energyvalues = energyvalues
            vc.wateremissions = wateremissions
            vc.watervalues = watervalues
            vc.wasteemissions = wasteemissions
            vc.wastevalues = wastevalues
            vc.transitemissions = transitemissions
            vc.transitvalues = transitvalues
            vc.humanemissions = humanemissions
            vc.humanvalues = humanvalues
            vc.analysisdict = analysisdict
            vc.reportedscores = reportedscores
            vc.countries = countries
            vc.datearr = datearr
            vc.globaldata = globaldata
            vc.performancedata = performancedata
            vc.localdata = localdata
            vc.fullcountryname = fullcountryname
            vc.currentscore = currentscore
            vc.isloaded = isloaded
            vc.maxscore = maxscore
            vc.sel = sel
            vc.energymax = energymax
            vc.energyscore = energyscore
            vc.waterscore = waterscore
            vc.wastescore = wastescore
            vc.transportscore = transportscore
            vc.humanscore = humanscore
            vc.duration = duration
            vc.watermax = watermax
            vc.wastemax = wastemax
            vc.transportmax = transportmax
            vc.humanmax = humanmax
            vc.energymin = energymin
            vc.watermin = watermin
            vc.wastemin = wastemin
            vc.transportmin = transportmin
            vc.humanmin = humanmin
            vc.fullstatename = fullstatename
            vc.toload = false
            vc.scoresarr = scoresarr
            NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(scoresarr), forKey: "scoresarr")
            NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(reportedscores), forKey: "reportedscoresarr")
            NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(analysisdict), forKey: "analysisdict")
            
        }else if(segue.identifier == "gotograph"){
            NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(scoresarr), forKey: "scoresarr")
            NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(reportedscores), forKey: "reportedscoresarr")
            NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(analysisdict), forKey: "analysisdict")
            let vc = segue.destinationViewController as! analysisgraph
            vc.analysisdict = analysisdict
            if(sel == 50){
                vc.type = "energy"
                var dict = self.analysisdict
                if(dict["energy"] is NSNull){
                    vc.str1 = "0.000"
                    vc.str2 = "0.000"
                }else{
                    if(dict["energy"] == nil){
                        vc.str1 = "0.000"
                        vc.str2 = "0.000"
                    }else{
                    if(dict["energy"]!["info_json"] is NSNull){
                        vc.str1 = "0.000"
                        vc.str2 = "0.000"
                    }else{
                        var str = dict["energy"]!["info_json"] as! String
                        let str1 = NSMutableString()
                        str1.appendString(str)
                        str1.replaceOccurrencesOfString("'", withString: "\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
                        //print(str1)
                        str = str1.mutableCopy() as! String
                        let jsonData = (str).dataUsingEncoding(NSUTF8StringEncoding)
                        do {
                            dict = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions()) as! NSDictionary
                            if(dict["Raw GHG (mtCO2e/day)"] is NSNull){
                                
                            }else{
                                var gross = Float(0)
                                if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                                }else{
                                    gross = Float( buildingdetails["gross_area"] as! Int)
                                }
                                vc.str1 =  String(format:"%.5f",(dict["Raw GHG (mtCO2e/day)"] as! Float  * 365) / gross)
                                var occupant = Float(0)
                                if(buildingdetails["occupancy"] == nil || buildingdetails["occupancy"] is NSNull){
                                }else{
                                    occupant = Float( buildingdetails["occupancy"] as! Int)
                                }
                                vc.str2 =  String(format:"%.5f",(dict["Raw GHG (mtCO2e/day)"] as! Float  * 365) / occupant )
                            }
                        }catch{
                            vc.str1 = "0.000"
                            vc.str2 = "0.000"
                        }
                    }
                }
                }
                vc.mttitlearr = ["mtCO2e/occupant", "mtCO2e/square foot"]
                vc.startcolor = UIColor.init(red: 0.860, green: 0.871, blue: 0.734, alpha: 1)
                vc.endcolor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
                vc.startcolor = vc.endcolor
            }else if(sel == 51){
                vc.type = "water"
                vc.mttitlearr = ["Gallons/occupant", "Gallons/square foot"]
                vc.startcolor = UIColor.init(red: 0.801, green: 0.948, blue: 0.952, alpha: 1)
                vc.endcolor = UIColor.init(red: 0.303, green: 0.751, blue: 0.94, alpha: 1)
                vc.startcolor = vc.endcolor
                var dict = self.analysisdict
                if(dict["water"] is NSNull){
                    
                }else{
                    if(dict["water"] == nil){
                        vc.str1 = "0.000"
                        vc.str2 = "0.000"
                    }else{
                    if(dict["water"]!["info_json"] is NSNull){
                        vc.str1 = "0.000"
                        vc.str2 = "0.000"
                    }else{
                        var str = dict["water"]!["info_json"] as? String
                        let str1 = NSMutableString()
                        str1.appendString(str!)
                        str1.replaceOccurrencesOfString("'", withString: "\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str!.characters.count))
                        //print(str1)
                        str = str1.mutableCopy() as? String
                        let jsonData = (str!).dataUsingEncoding(NSUTF8StringEncoding)
                        do {
                            dict = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions()) as! NSDictionary
                            if(dict["Raw Water Use (gallons/day)"] is NSNull){
                                
                            }else{
                                var gross = Float(0)
                                if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                                }else{
                                    gross = Float( buildingdetails["gross_area"] as! Int)
                                }
                                vc.str1 =  String(format:"%.5f",(dict["Raw Water Use (gallons/day)"] as! Float  * 365) / gross )
                                var occupant = Float(0)
                                if(buildingdetails["occupancy"] == nil || buildingdetails["occupancy"] is NSNull){
                                }else{
                                    occupant = Float( buildingdetails["occupancy"] as! Int)
                                }
                                vc.str2 =  String(format:"%.5f",(dict["Raw Water Use (gallons/day)"] as! Float  * 365) / occupant )
                            }
                        }catch{
                            vc.str1 = "0.000"
                            vc.str2 = "0.000"
                        }
                    }
                }
                }
                
            }else if(sel == 52){
                vc.type = "waste"
                vc.mttitlearr = ["Generated waste", "Undiverted waste/lbsoccupant"]
                vc.startcolor = UIColor.init(red: 0.691, green: 0.789, blue: 0.762, alpha: 1)
                vc.endcolor = UIColor.init(red: 0.461, green: 0.76, blue: 0.629, alpha: 1)
                vc.startcolor = vc.endcolor
                var dict = self.analysisdict
                if(dict["waste"] is NSNull){
                    vc.str1 = "0.000"
                    vc.str2 = "0.000"
                }else{
                    if(dict["waste"] == nil){
                        vc.str1 = "0.000"
                        vc.str2 = "0.000"
                    }else{
                    if(dict["waste"]!["info_json"] is NSNull){
                        vc.str1 = "0.000"
                        vc.str2 = "0.000"
                    }else{
                        var str = dict["waste"]!["info_json"] as! String
                        let str1 = NSMutableString()
                        str1.appendString(str)
                        str1.replaceOccurrencesOfString("'", withString: "\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
                        //print(str1)
                        str = str1.mutableCopy() as! String
                        let jsonData = (str).dataUsingEncoding(NSUTF8StringEncoding)
                        do {
                            dict = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions()) as! NSDictionary
                            if(dict["Generated Waste (lbs per occupant per day)"] is NSNull){
                                
                            }else{
                                var gross = Float(0)
                                if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                                }else{
                                    gross = Float( buildingdetails["gross_area"] as! Int)
                                }
                                vc.str1 =  String(format:"%.5f",(dict["Generated Waste (lbs per occupant per day)"] as! Float  * 365) / gross )
                                var occupant = Float(0)
                                if(buildingdetails["occupancy"] == nil || buildingdetails["occupancy"] is NSNull){
                                }else{
                                    occupant = Float( buildingdetails["occupancy"] as! Int)
                                }
                                vc.str2 =  String(format:"%.5f",(dict["Generated Waste (lbs per occupant per day)"] as! Float  * 365) / occupant )
                            }
                        }catch{
                            vc.str1 = "0.000"
                            vc.str2 = "0.000"
                        }
                    }
                    }
                }
                
            }else if(sel == 53){
                vc.type = "transport"
                vc.startcolor = UIColor.init(red: 0.876, green: 0.858, blue: 0.803, alpha: 1)
                vc.endcolor = UIColor.init(red: 0.572, green: 0.556, blue: 0.505, alpha: 1)
                vc.startcolor = vc.endcolor
                vc.str1 = "0.000"
                vc.str2 = "0.000"
                
            }else if(sel == 54){
                vc.type = "human_experience"
                vc.startcolor = UIColor.init(red: 0.92, green: 0.609, blue: 0.236, alpha: 1)//UIColor.init(red: 0.901, green: 0.867, blue: 0.603, alpha: 1)
                vc.endcolor = UIColor.init(red: 0.92, green: 0.609, blue: 0.236, alpha: 1)
                vc.startcolor = vc.endcolor
                vc.str1 = "0.000"
                vc.str2 = "0.000"
            }
            vc.reportedscores = reportedscores
            
            
        }
    }
    
    
    /*func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if(section == 2){
        return 60
        }
        return 1
    }
    
    func tableView(tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    */
    
    
    
    func showalert(message:String, title:String, action:String){
        
        //let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        //let callActionHandler = { (action:UIAlertAction!) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                self.view.userInteractionEnabled = true
                self.spinner.hidden = true
                self.tableview.alpha = 1.0
                self.maketoast(message, type: "error")
               // self.navigationController?.popViewControllerAnimated(true)
            })
            
//        }
  //      let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
    //    alertController.addAction(defaultAction)
        
        //presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func viewDidLayoutSubviews() {
        var contentSize = self.tableview.contentSize
        contentSize.width  = self.tableview.bounds.size.width;
        self.tableview.contentSize   = contentSize;
    }
    override func viewWillLayoutSubviews() {
        var contentSize = self.tableview.contentSize
        contentSize.width  = self.tableview.bounds.size.width;
        self.tableview.contentSize   = contentSize;
    }
    
    func adjustwidth(){
        super.view.layoutSubviews()
        self.tableview.layoutSubviews()
        self.tableview.setNeedsLayout()
        self.tableview.setNeedsDisplay()
    //    self.tableview.reloadData()
    }
}


