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

class totalanalytics: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate,WCSessionDelegate, UIGestureRecognizerDelegate {
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
    var boolarr = [Bool]()
    @IBOutlet weak var slider1: UISlider!
    @IBOutlet weak var slider2: UISlider!
    @IBOutlet weak var context4: UILabel!
    @IBOutlet weak var context3: UILabel!
    @IBOutlet weak var context2: UILabel!
    @IBOutlet weak var context1: UILabel!
    @IBOutlet weak var dualslidertitle: UILabel!
    @IBOutlet weak var dualsliderglobal: UILabel!
    @IBOutlet weak var lowestscorelbl: UILabel!
    @IBOutlet weak var lowestscoreimg: UIImageView!
    
    @IBOutlet weak var innertitle1: UILabel!
    @IBOutlet weak var innerimg1: UIImageView!
    @IBOutlet weak var innerarrow1: UIImageView!
    @IBOutlet weak var emissionsview: UIView!
    @IBOutlet weak var highestscoreimg: UIImageView!
    @IBOutlet weak var highestscorelbl: UILabel!
    @IBOutlet weak var highestscore: UILabel!
    @IBOutlet weak var lowestscore: UILabel!
    @IBOutlet weak var decorview: UIView!
    @IBOutlet weak var localimg: UIImageView!
    @IBOutlet weak var globalimg: UIImageView!
    @IBOutlet weak var avgvalue: UILabel!
    @IBOutlet weak var localvalue: UILabel!
    @IBOutlet weak var globalvalue: UILabel!
    @IBOutlet weak var avgimg: UIImageView!
    @IBOutlet weak var avglbl: UIButton!
    @IBOutlet weak var avgview: UIView!
    
    @IBOutlet weak var vv: circularprogress!
    @IBOutlet weak var dualsliderlowest: UILabel!
    @IBOutlet weak var dualsliderimage: UIImageView!
    @IBOutlet weak var dualsliderview: UIView!
    @IBAction func gotoscore(sender: AnyObject) {
                    NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"listofassets"])
    }
    
    @IBOutlet weak var innerimg: UIImageView!
    @IBOutlet weak var innerlbl: UILabel!
    @IBOutlet weak var innerview: UIView!
    @IBOutlet weak var dualslideroutof: UILabel!
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
            return 0.01 * UIScreen.mainScreen().bounds.size.height
        
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 3){
            if(energypercentagedata.count > 0 && energyscoreedata.count > 0){
                var j = CGFloat(0)
                j = context4.frame.origin.y + context4.frame.size.height + innerview.frame.size.height
                return j
            }else if((energypercentagedata.count > 0 && energyscoreedata.count == 0) || energypercentagedata.count == 0 && energyscoreedata.count > 0){
                var j = CGFloat(0)
                j = context2.frame.origin.y + context2.frame.size.height + innerview.frame.size.height
                return j
            }
            var j = CGFloat(0)
            j = decorview.frame.origin.y + decorview.frame.size.height + innerview.frame.size.height
            return j
        }else if(section == 4){
            if(waterpercentagedata.count > 0 && waterscoreedata.count > 0){
                var j = CGFloat(0)
                j = context4.frame.origin.y + context4.frame.size.height + innerview.frame.size.height
                return j
            }else if((waterpercentagedata.count > 0 && waterscoreedata.count == 0) || waterpercentagedata.count == 0 && waterscoreedata.count > 0){
                var j = CGFloat(0)
                j = context2.frame.origin.y + context2.frame.size.height + innerview.frame.size.height
                return j
            }
            var j = CGFloat(0)
            j = decorview.frame.origin.y + decorview.frame.size.height + innerview.frame.size.height
            return j
        }else if(section == 5){
            if(wastepercentagedata.count > 0 && wastescoreedata.count > 0){
                var j = CGFloat(0)
                j = context4.frame.origin.y + context4.frame.size.height + innerview.frame.size.height
                return j
            }else if((wastepercentagedata.count > 0 && wastescoreedata.count == 0) || wastepercentagedata.count == 0 && wastescoreedata.count > 0){
                var j = CGFloat(0)
               j = context2.frame.origin.y + context2.frame.size.height + innerview.frame.size.height
                return j
            }
            var j = CGFloat(0)
            j = decorview.frame.origin.y + decorview.frame.size.height + innerview.frame.size.height
            return j
        }else if(section == 6){
            if(transitpercentagedata.count > 0 && transitscoreedata.count > 0){
                var j = CGFloat(0)
                j = context4.frame.origin.y + context4.frame.size.height + innerview.frame.size.height
                return j
            }else if((transitpercentagedata.count > 0 && transitscoreedata.count == 0) || transitpercentagedata.count == 0 && transitscoreedata.count > 0){
                var j = CGFloat(0)
                j = context2.frame.origin.y + context2.frame.size.height + innerview.frame.size.height
                return j
            }
            var j = CGFloat(0)
            j = decorview.frame.origin.y + decorview.frame.size.height + innerview.frame.size.height
            return j
        }else if(section == 7){
            if(humanpercentagedata.count > 0 && humanscoreedata.count > 0){
                var j = CGFloat(0)
                j = context4.frame.origin.y + context4.frame.size.height + innerview.frame.size.height
                return j
            }else if((humanpercentagedata.count > 0 && humanscoreedata.count == 0) || humanpercentagedata.count == 0 && humanscoreedata.count > 0){
                var j = CGFloat(0)
                j = context2.frame.origin.y + context2.frame.size.height + innerview.frame.size.height
                return j
            }
            var j = CGFloat(0)
            j = decorview.frame.origin.y + decorview.frame.size.height + innerview.frame.size.height
            return j
        }else if(section == 8){
            var j = CGFloat(0)
            j = emissionsview.frame.size.height
            return j
        }
        return 1
    }
    
   /* override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [.Portrait]
    }*/
    var certificationsdict = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.rowHeight = UITableViewAutomaticDimension
        self.navigationController?.interactivePopGestureRecognizer?.enabled = false
        boolarr = [false,false,false,false,false,false,false,false,false,false]
        //[tableView setAutoresizingMask:UIViewAutoresizingMaskFelxibleHeight | UIViewAutoResizingMaskFlexibleWidth];
        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.automaticallyAdjustsScrollViewInsets = false
        self.parentViewController?.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.automaticallyAdjustsScrollViewInsets = false
        tableview.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        watchsession.delegate = self
        self.buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        self.navigationItem.title = self.buildingdetails["name"] as? String
        tableview.registerNib(UINib.init(nibName: "totalanalysis1", bundle: nil), forCellReuseIdentifier: "totalcell1")
        tableview.registerNib(UINib.init(nibName: "row1", bundle: nil), forCellReuseIdentifier: "row1")
        tableview.registerNib(UINib.init(nibName: "row2", bundle: nil), forCellReuseIdentifier: "row2")
        tableview.registerNib(UINib.init(nibName: "row3", bundle: nil), forCellReuseIdentifier: "row3")
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
            spinnerhide = 1
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
        
            ////print(globaldata,localdata)
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
            
            ////print("avg arrays",globaldata,localdata)
            
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
            
            
            ////print("compara",localavgarr,globalavgarr)
            
            
            countries = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("countries") as! NSData) as! [String : AnyObject]
            
            var tempdict = countries["countries"] as! [String:AnyObject]
            var present = 0
            
            tempdict = countries["countries"] as! [String:AnyObject]
            for (key,value) in tempdict{
                if(key as! String == self.buildingdetails["country"]! as! String){
                    fullcountryname = value as! String
                    present = 1
                    break
                }
            }
            tempdict = countries["countries"] as! [String:AnyObject]
            if(present == 1){
            
            tempdict = countries["divisions"]![buildingdetails["country"] as! String]! as! [String:AnyObject]
            for (key,value) in tempdict{
                if(key == self.buildingdetails["state"] as! String){
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
            
            
            
            ////print("Min score",currentscore,maxscore )
            
            
            //tableview.reloadData()
            
            
            
            let datearray : NSMutableArray = []
            let formatter = NSDateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            var date = NSDate()
            let unitFlags: NSCalendarUnit = [.Hour, .Day, .Month, .Year]
            var components = NSCalendar.currentCalendar().components(unitFlags, fromDate: date)
            
            for _ in (1...12).reverse() {
                ////print(components.year, components.month)
                components = NSCalendar.currentCalendar().components(unitFlags, fromDate: date)
                datearray.addObject(String(format:"%d-%02d-01",components.year,components.month))
                let monthAgo = NSCalendar.currentCalendar().dateByAddingUnit(.Month, value: -1, toDate: date, options: [])
                date = monthAgo!
            }
            
            
            ////print(datearray)
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
                        self.getscores(NSUserDefaults.standardUserDefaults().integerForKey("leed_id"),token: NSUserDefaults.standardUserDefaults().objectForKey("token") as! String)
                    })
                    
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
        //print(url?.absoluteURL)
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
                //print("error=\(error)")
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
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }else{
                    //print(data)
                    let jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        //print(jsonDictionary)
                        let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                        NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "comparable_data")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        dispatch_async(dispatch_get_main_queue(), {
                            //self.getnotifications(subscription_key,leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"))
                            //print("State = ",self.buildingdetails["state"])
                            if let s = self.buildingdetails["state"] as? String{
                                dispatch_async(dispatch_get_main_queue(), {
                                    //print(s)
                                    if(s != ""){
                                        //print(String(format: "%@%@",self.buildingdetails["country"] as! String,s))
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
                                    //print(s)
                                    if(s != ""){
                                        //print(String(format: "%@%@",self.buildingdetails["country"] as! String,s))
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
                        //print(error)
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
        //print(state)
        let url = NSURL.init(string:"\(credentials().domain_url as String)comparables/?state=\(state)")
        //print(url?.absoluteURL)
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
                //print("error=\(error)")
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
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }else{
                    //print(data)
                    let jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        //print(jsonDictionary)
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
                        //print(error)
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
            ////print("Loop index: \(index)")
            
            let url = NSURL(string: "\(credentials().domain_url)assets/LEED:\(leedid)/scores/?at=\(datearr.objectAtIndex(index))&within=1")
            //print(url)
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
                                ////print("Data \(index)",jsonDictionary)
                                if(jsonDictionary["result"] == nil){
                                    self.scoresarr.addObject(jsonDictionary["scores"] as! [String:AnyObject])
                                }
                                self.reportedscores.addObject(jsonDictionary)
                            } catch {
                                ////print(error)
                            }
                            
                    }
                    
                    dispatch_sync(dispatch_get_main_queue()) {
                        if (taskerror == true){
                            ////print(taskerror)
                            dispatch_async(dispatch_get_main_queue(), {
                                self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                                return
                            })
                        } else {
                            
                            if(index == 11){
                                ////print("Scores arr",self.scoresarr)
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
        self.buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        self.navigationItem.title = self.buildingdetails["name"] as? String
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
        dispatch_async(dispatch_get_main_queue(), {
        self.tableview.reloadData()
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        for request in download_requests
        {
            request.invalidateAndCancel()
        }
        self.buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        self.navigationItem.title = self.buildingdetails["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = self.buildingdetails["name"] as? String
    }
    
    func certdetails(subscription_key:String, leedid: Int){
        let url = NSURL.init(string: String(format: "%@assets/LEED:%d/certifications/",credentials().domain_url,leedid))
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-Type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        //print(url?.absoluteURL,token)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                //print("error=\(error)")
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
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
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
                    //print(data)
                    let jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        //print(jsonDictionary)
                        let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                        self.certificationsdict = jsonDictionary
                        dispatch_async(dispatch_get_main_queue(), {
                            let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                            NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "certification_details")
                            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "grid")
                            if(self.spinner.hidden == true){
                                self.spinner.hidden = false
                                self.view.userInteractionEnabled = false
                                self.tableview.alpha = 0.4
                                self.getcomparablesdata(subscription_key, leedid: leedid)
                            }
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

    var humanarr = NSArray()
    var transitarr = NSArray()
    var wastearr = NSArray()
    var waterarr = NSArray()
    var energyarrscope1 = NSArray()
    var energyarrscope2 = NSArray()

    var energyarr = NSArray()
    var waterarray = NSArray()
    var wastearray = NSArray()
    var scope1annumarr = NSMutableArray()
    var scope2annumarr = NSMutableArray()
    var scope1dailyarr = NSMutableArray()
    var scope2dailyarr = NSMutableArray()
    var transitannumarr = NSMutableArray()
    var transitdailyarr = NSMutableArray()
    var totalannumarr = NSMutableArray()
    var totaldailyarr = NSMutableArray()
    
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
                    ////print("Data",jsonDictionary)
                    self.tableview.alpha = 1
                    self.view.userInteractionEnabled = true
                    self.analysisdict = jsonDictionary
                    self.analysisdict = jsonDictionary                                        
                    var dict = self.analysisdict
                    
                        var arr = NSMutableArray()
                        var currentarr = NSMutableArray()
                    var occupancy = 0.0
                    
                    if(self.analysisdict["energy"] != nil ){
                        if(self.analysisdict["energy"]!["info_json"] != nil){
                            var str = self.analysisdict["energy"]!["info_json"] as! String
                            var str1 = NSMutableString()
                            str1.appendString(str)
                            str = str.stringByReplacingOccurrencesOfString("'", withString: "\"")
                            str = str.stringByReplacingOccurrencesOfString("None", withString: "\"None\"")
                            //print(str1)
                            //str = str1.mutableCopy() as! String
                            var dict = NSDictionary()
                            var jsonData = str
                            do {
                                if(self.convertStringToDictionary(str) != nil){
                                    dict = self.convertStringToDictionary(str)!
                                    
                                }
                            }catch{
                                
                            }
                            arr = []
                            if(dict.count > 0){
                                //print(dict["Scope1 Raw GHG (mtCO2e/day)"])
                                if(dict["Scope1 Raw GHG (mtCO2e/day)"] is NSNull || dict["Scope1 Raw GHG (mtCO2e/day)"] == nil){
                                    arr.addObject(0.00000)
                                }else if(dict["Scope1 Raw GHG (mtCO2e/day)"] as? String == "None"){
                                    arr.addObject(0.00000)
                                }else{
                                    arr.addObject(dict["Scope1 Raw GHG (mtCO2e/day)"] as! Float  * 365.0 )
                                }
                                if(dict["Scope1 Raw GHG (mtCO2e/day)"] is NSNull || dict["Scope1 Raw GHG (mtCO2e/day)"] == nil){
                                    arr.addObject(0.00000)
                                }else if(dict["Scope1 Raw GHG (mtCO2e/day)"] as? String == "None"){
                                    arr.addObject(0.00000)
                                }else{
                                    var gross = 0.0 as! Float
                                    if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                                    }else{
                                        gross = Float( self.buildingdetails["gross_area"] as! Int)
                                    }
                                    arr.addObject((dict["Scope1 Raw GHG (mtCO2e/day)"] as! Float  * 365.0) / gross )
                                }
                                
                                if(dict["Scope1 Raw GHG (mtCO2e/day)"] is NSNull || dict["Scope1 Raw GHG (mtCO2e/day)"] == nil){
                                    arr.addObject(0.00000)
                                }else if(dict["Scope1 Raw GHG (mtCO2e/day)"] as? String == "None"){
                                    arr.addObject(0.00000)
                                }else{
                                    var occupant = 0.0 as! Float
                                    if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["occupancy"] is NSNull){
                                    }else{
                                        occupant = Float( self.buildingdetails["occupancy"] as! Int)
                                    }
                                    arr.addObject((dict["Scope1 Raw GHG (mtCO2e/day)"] as! Float  * 365.0) / occupant )
                                }
                                self.scope1annumarr = arr
                                arr = NSMutableArray()
                                
                                if(dict["Scope1 Raw GHG (mtCO2e/day)"] is NSNull || dict["Scope1 Raw GHG (mtCO2e/day)"] == nil){
                                    arr.addObject(0.00000)
                                }else if(dict["Scope1 Raw GHG (mtCO2e/day)"] as? String == "None"){
                                    arr.addObject(0.00000)
                                }else{
                                    arr.addObject(dict["Scope1 Raw GHG (mtCO2e/day)"] as! Float)
                                }
                                if(dict["Scope1 Raw GHG (mtCO2e/day)"] is NSNull || dict["Scope1 Raw GHG (mtCO2e/day)"] == nil){
                                    arr.addObject(0.00000)
                                }else if(dict["Scope1 Raw GHG (mtCO2e/day)"] as? String == "None"){
                                    arr.addObject(0.00000)
                                }else{
                                    var gross = 0.0 as! Float
                                    if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                                    }else{
                                        gross = Float( self.buildingdetails["gross_area"] as! Int)
                                    }
                                    arr.addObject((dict["Scope1 Raw GHG (mtCO2e/day)"] as! Float) / gross )
                                }
                                
                                if(dict["Scope1 Raw GHG (mtCO2e/day)"] is NSNull || dict["Scope1 Raw GHG (mtCO2e/day)"] == nil){
                                    arr.addObject(0.00000)
                                }else if(dict["Scope1 Raw GHG (mtCO2e/day)"] as? String == "None"){
                                    arr.addObject(0.00000)
                                }else{
                                    var occupant = 0.0 as! Float
                                    if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["occupancy"] is NSNull){
                                    }else{
                                        occupant = Float( self.buildingdetails["occupancy"] as! Int)
                                    }
                                    arr.addObject((dict["Scope1 Raw GHG (mtCO2e/day)"] as! Float) / occupant )
                                }
                                self.scope1dailyarr = arr
                                arr = NSMutableArray()
                                
                                if(dict["Scope2 Raw GHG (mtCO2e/day)"] is NSNull || dict["Scope2 Raw GHG (mtCO2e/day)"] == nil){
                                    arr.addObject(0.00000)
                                }else if(dict["Scope2 Raw GHG (mtCO2e/day)"] as? String == "None"){
                                    arr.addObject(0.00000)
                                }else{
                                    arr.addObject(dict["Scope2 Raw GHG (mtCO2e/day)"] as! Float  * 365.0 )
                                }
                                if(dict["Scope2 Raw GHG (mtCO2e/day)"] is NSNull || dict["Scope2 Raw GHG (mtCO2e/day)"] == nil){
                                    arr.addObject(0.00000)
                                }else if(dict["Scope2 Raw GHG (mtCO2e/day)"] as? String == "None"){
                                    arr.addObject(0.00000)
                                }else{
                                    var gross = 0.0 as! Float
                                    if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                                    }else{
                                        gross = Float( self.buildingdetails["gross_area"] as! Int)
                                    }
                                    arr.addObject((dict["Scope2 Raw GHG (mtCO2e/day)"] as! Float  * 365.0) / gross )
                                }
                                
                                if(dict["Scope2 Raw GHG (mtCO2e/day"] is NSNull || dict["Scope2 Raw GHG (mtCO2e/day)"] == nil){
                                    arr.addObject(0.00000)
                                }else if(dict["Scope2 Raw GHG (mtCO2e/day)"] as? String == "None"){
                                    arr.addObject(0.00000)
                                }else{
                                    var occupant = 0.0 as! Float
                                    if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["occupancy"] is NSNull){
                                    }else{
                                        occupant = Float( self.buildingdetails["occupancy"] as! Int)
                                    }
                                    arr.addObject((dict["Scope2 Raw GHG (mtCO2e/day)"] as! Float  * 365.0) / occupant )
                                }
                                self.scope2annumarr = arr
                                arr = NSMutableArray()
                                
                                
                                if(dict["Scope2 Raw GHG (mtCO2e/day)"] is NSNull || dict["Scope2 Raw GHG (mtCO2e/day)"] == nil){
                                    arr.addObject(0.00000)
                                }else if(dict["Scope2 Raw GHG (mtCO2e/day)"] as? String == "None"){
                                    arr.addObject(0.00000)
                                }else{
                                    arr.addObject(dict["Scope2 Raw GHG (mtCO2e/day)"] as! Float )
                                }
                                if(dict["Scope2 Raw GHG (mtCO2e/day)"] is NSNull || dict["Scope2 Raw GHG (mtCO2e/day)"] == nil){
                                    arr.addObject(0.00000)
                                }else if(dict["Scope2 Raw GHG (mtCO2e/day)"] as? String == "None"){
                                    arr.addObject(0.00000)
                                }else{
                                    var gross = 0.0 as! Float
                                    if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                                    }else{
                                        gross = Float( self.buildingdetails["gross_area"] as! Int)
                                    }
                                    arr.addObject((dict["Scope2 Raw GHG (mtCO2e/day)"] as! Float) / gross )
                                }
                                
                                if(dict["Scope2 Raw GHG (mtCO2e/day"] is NSNull || dict["Scope2 Raw GHG (mtCO2e/day)"] == nil){
                                    arr.addObject(0.00000)
                                }else if(dict["Scope2 Raw GHG (mtCO2e/day)"] as? String == "None"){
                                    arr.addObject(0.00000)
                                }else{
                                    var occupant = 0.0 as! Float
                                    if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["occupancy"] is NSNull){
                                    }else{
                                        occupant = Float( self.buildingdetails["occupancy"] as! Int)
                                    }
                                    arr.addObject((dict["Scope2 Raw GHG (mtCO2e/day)"] as! Float ) / occupant )
                                }
                                self.scope2dailyarr = arr
                                arr = NSMutableArray()
                                //valuearr.addObject(arr)
                                
                                
                                /*if(dict["Raw GHG (mtCO2e/day)"] is NSNull){
                                 arr.addObject(0.00000)
                                 }else{
                                 arr.addObject(dict["Raw GHG (mtCO2e/day)"] as! Float  * 365.0 ))
                                 }
                                 if(dict["Raw GHG (mtCO2e/day)"] is NSNull){
                                 arr.addObject(0.00000)
                                 }else{
                                 var gross = 0.0 as! Float
                                 if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                                 }else{
                                 gross = Float( self.buildingdetails["gross_area"] as! Int)
                                 }
                                 arr.addObject((dict["Raw GHG (mtCO2e/day)"] as! Float  * 365.0) / gross ))
                                 }
                                 
                                 if(dict["Raw GHG (mtCO2e/day)"] is NSNull){
                                 arr.addObject(0.00000)
                                 }else{
                                 var occupant = 0.0 as! Float
                                 if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["occupancy"] is NSNull){
                                 }else{
                                 occupant = Float( self.buildingdetails["occupancy"] as! Int)
                                 }
                                 arr.addObject((dict["Raw GHG (mtCO2e/day)"] as! Float  * 365.0) / occupant ))
                                 }
                                 valuearr.addObject(arr) */
                                
                                
                                
                                
                                /*
                                 
                                 
                                 arr = NSMutableArray()
                                 if(dict["Raw GHG (mtCO2e/day)"] is NSNull){
                                 arr.addObject(0.00000)
                                 }else{
                                 arr.addObject(dict["Raw GHG (mtCO2e/day)"] as! Float))
                                 }
                                 if(dict["Raw GHG (mtCO2e/day)"] is NSNull){
                                 arr.addObject(0.00000)
                                 }else{
                                 var gross = 0.0 as! Float
                                 if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                                 }else{
                                 gross = Float( self.buildingdetails["gross_area"] as! Int)
                                 }
                                 arr.addObject((dict["Raw GHG (mtCO2e/day)"] as! Float) / gross ))
                                 }
                                 
                                 if(dict["Raw GHG (mtCO2e/day)"] is NSNull){
                                 arr.addObject(0.00000)
                                 }else{
                                 var occupant = 0.0 as! Float
                                 if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["occupancy"] is NSNull){
                                 }else{
                                 occupant = Float( self.buildingdetails["occupancy"] as! Int)
                                 }
                                 arr.addObject((dict["Raw GHG (mtCO2e/day)"] as! Float) / occupant ))
                                 }
                                 valuearr.addObject(arr)
                                 arr = NSMutableArray()
                                 if(dict["Adjusted Emissions per SF"] is NSNull){
                                 arr.addObject(0.00000)
                                 }else{
                                 arr.addObject(dict["Adjusted Emissions per SF"] as! Float * 365.0))
                                 }
                                 if(dict["Adjusted Emissions per SF"] is NSNull){
                                 arr.addObject(0.00000)
                                 }else{
                                 var gross = 0.0 as! Float
                                 if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                                 }else{
                                 gross = Float( self.buildingdetails["gross_area"] as! Int)
                                 }
                                 arr.addObject((dict["Adjusted Emissions per SF"] as! Float * 365.0) / gross ))
                                 }
                                 
                                 if(dict["Adjusted Emissions per SF"] is NSNull){
                                 arr.addObject(0.00000)
                                 }else{
                                 var occupant = 0.0 as! Float
                                 if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["occupancy"] is NSNull){
                                 }else{
                                 occupant = Float( self.buildingdetails["occupancy"] as! Int)
                                 }
                                 arr.addObject((dict["Adjusted Emissions per SF"] as! Float * 365.0) / occupant ))
                                 }
                                 valuearr.addObject(arr)
                                 arr = NSMutableArray()
                                 if(dict["Adjusted Emissions per SF"] is NSNull){
                                 arr.addObject(0.00000)
                                 }else{
                                 arr.addObject(dict["Adjusted Emissions per SF"] as! Float))
                                 }
                                 if(dict["Adjusted Emissions per SF"] is NSNull){
                                 arr.addObject(0.00000)
                                 }else{
                                 var gross = 0.0 as! Float
                                 if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                                 }else{
                                 gross = Float( self.buildingdetails["gross_area"] as! Int)
                                 }
                                 arr.addObject((dict["Adjusted Emissions per SF"] as! Float) / gross ))
                                 }
                                 
                                 if(dict["Adjusted Emissions per SF"] is NSNull){
                                 arr.addObject(0.00000)
                                 }else{
                                 var occupant = 0.0 as! Float
                                 if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["occupancy"] is NSNull){
                                 }else{
                                 occupant = Float( self.buildingdetails["occupancy"] as! Int)
                                 }
                                 arr.addObject((dict["Adjusted Emissions per SF"] as! Float) / occupant ))
                                 }
                                 valuearr.addObject(arr)*/
                            }
                        }
                        
                        if(self.analysisdict["transit"] != nil){
                            if(self.analysisdict["transit"]!["info_json"] != nil){
                                arr = NSMutableArray()
                                var str = self.analysisdict["transit"]!["info_json"] as! String
                                var str1 = NSMutableString()
                                str1.appendString(str)
                                str1.replaceOccurrencesOfString("'", withString: "\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
                                str = str.stringByReplacingOccurrencesOfString("'", withString: "\"")
                                str = str.stringByReplacingOccurrencesOfString("None", withString: "\"None\"")
                                //print(str1)
                                //str = str1.mutableCopy() as! String
                                var dict = NSDictionary()
                                var jsonData = str
                                do {
                                    if(self.convertStringToDictionary(str) != nil){
                                        dict = self.convertStringToDictionary(str)!
                                    }
                                }catch{
                                    
                                }
                                
                                arr = NSMutableArray()
                                if(dict["Average Transit CO2e"] is NSNull || dict["Average Transit CO2e"] == nil){
                                    arr.addObject(0.00000)
                                }else if(dict["Average Transit CO2e"] as? String == "None"){
                                    arr.addObject(0.00000)
                                }else{
                                    var occupant = 0.0 as! Float
                                    if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["occupancy"] is NSNull){
                                    }else{
                                        occupant = Float( self.buildingdetails["occupancy"] as! Int)
                                    }
                                    arr.addObject((dict["Average Transit CO2e"] as! Float) * occupant * 365)
                                }
                                
                                if(dict["Average Transit CO2e"] is NSNull || dict["Average Transit CO2e"] == nil){
                                    arr.addObject(0.00000)
                                }else if(dict["Average Transit CO2e"] as? String == "None"){
                                    arr.addObject(0.00000)
                                }else{
                                    var gross = 0.0 as! Float
                                    if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                                    }else{
                                        gross = Float( self.buildingdetails["gross_area"] as! Int)
                                    }
                                    arr.addObject(0.00000)
                                }
                                //print(arr)
                                
                                
                                if(dict["Average Transit CO2e"] is NSNull || dict["Average Transit CO2e"] == nil){
                                    arr.addObject(0.00000)
                                }else if(dict["Average Transit CO2e"] as? String == "None"){
                                    arr.addObject(0.00000)
                                }else{
                                    arr.addObject(dict["Average Transit CO2e"] as! Float * 365)
                                }
                                
                                //print(arr)
                                
                                
                                self.transitannumarr = arr
                                
                                //valuearr.addObject(arr)
                                arr = NSMutableArray()
                                if(dict["Average Transit CO2e"] is NSNull || dict["Average Transit CO2e"] == nil){
                                    arr.addObject(0.00000)
                                }else if(dict["Average Transit CO2e"] as? String == "None"){
                                    arr.addObject(0.00000)
                                }else{
                                    var occupant = 0.0 as! Float
                                    if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["occupancy"] is NSNull){
                                    }else{
                                        occupant = Float( self.buildingdetails["occupancy"] as! Int)
                                    }
                                    arr.addObject((dict["Average Transit CO2e"] as! Float) * occupant )
                                }
                                
                                if(dict["Average Transit CO2e"] is NSNull || dict["Average Transit CO2e"] == nil){
                                    arr.addObject(0.00000)
                                }else if(dict["Average Transit CO2e"] as? String == "None"){
                                    arr.addObject(0.00000)
                                }else{
                                    var gross = 0.0 as! Float
                                    if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                                    }else{
                                        gross = Float( self.buildingdetails["gross_area"] as! Int)
                                    }
                                    arr.addObject(0.00000)
                                }
                                //print(arr)
                                
                                
                                if(dict["Average Transit CO2e"] is NSNull || dict["Average Transit CO2e"] == nil){
                                    arr.addObject(0.00000)
                                }else if(dict["Average Transit CO2e"] as? String == "None"){
                                    arr.addObject(0.00000)
                                }else{
                                    arr.addObject(dict["Average Transit CO2e"] as! Float)
                                }
                                
                                //print(arr)
                                //valuearr.addObject(arr)
                                self.transitdailyarr = arr
                                arr = NSMutableArray()
                            }
                        }
                        //
                    }
                    
                    var num1 = 0.00000, num2 = 0.00000, num3 = 0.00000
                    var tmparr = NSMutableArray()
                    var tmp = 0.00000 as! Float
                    if(self.scope1dailyarr.count > 1 && self.transitdailyarr.count > 1){
                        tmp = (self.scope1dailyarr[0] as! Float) + (self.scope2dailyarr[0] as! Float) + (self.transitdailyarr[0] as! Float)
                        self.totaldailyarr.addObject(tmp as! Float)
                        var gross = 0.0 as! Float
                        if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                        }else{
                            gross = Float( self.buildingdetails["gross_area"] as! Int)
                        }
                        //tmp = (self.scope1dailyarr[1] as! Float) + (self.scope2dailyarr[1] as! Float) + (self.transitdailyarr[1] as! Float)
                        self.totaldailyarr.addObject(tmp/gross)
                        tmp = (self.scope1dailyarr[2] as! Float) + (self.scope2dailyarr[2] as! Float) + (self.transitdailyarr[2] as! Float)
                        self.totaldailyarr.addObject(tmp as! Float)
                    }else{
                        
                        self.totaldailyarr.addObject(num1)
                        self.totaldailyarr.addObject(num1)
                        self.totaldailyarr.addObject(num1)
                    }
                    
                    num1 = 0.00000
                    num2 = 0.00000
                    num3 = 0.00000
                    
                    tmparr = NSMutableArray()
                    tmp = 0.00000 as! Float
                    if(self.scope1annumarr.count > 1 && self.transitannumarr.count > 1){
                        tmp = (self.scope1annumarr[0] as! Float) + (self.scope2annumarr[0] as! Float) + (self.transitannumarr[0] as! Float)
                        self.totalannumarr.addObject(tmp as! Float)
                        var gross = 0.0 as! Float
                        if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                        }else{
                            gross = Float( self.buildingdetails["gross_area"] as! Int)
                        }
                        //tmp = (self.scope1dailyarr[1] as! Float) + (self.scope2dailyarr[1] as! Float) + (self.transitdailyarr[1] as! Float)
                        self.totalannumarr.addObject(tmp/gross)
                        self.totalannumarr.addObject(tmp as! Float)
                        tmp = (self.scope1annumarr[2] as! Float) + (self.scope2annumarr[2] as! Float) + (self.transitannumarr[2] as! Float)
                        self.totalannumarr.addObject(tmp as! Float)
                    }else{
                        self.totalannumarr.addObject(num1)
                        self.totalannumarr.addObject(num1)
                        self.totalannumarr.addObject(num1)
                    }
                    
                    
                    if(self.scope1annumarr.count == 0){
                        self.scope1annumarr.addObject(num1)
                        self.scope1annumarr.addObject(num1)
                        self.scope1annumarr.addObject(num1)
                    }
                    
                    if(self.scope2annumarr.count == 0){
                        self.scope2annumarr.addObject(num1)
                        self.scope2annumarr.addObject(num1)
                        self.scope2annumarr.addObject(num1)
                    }
                    
                    if(self.scope1dailyarr.count == 0){
                        self.scope1dailyarr.addObject(num1)
                        self.scope1dailyarr.addObject(num1)
                        self.scope1dailyarr.addObject(num1)
                    }
                    if(self.scope2dailyarr.count == 0){
                        self.scope2dailyarr.addObject(num1)
                        self.scope2dailyarr.addObject(num1)
                        self.scope2dailyarr.addObject(num1)
                    }
                    if(self.transitannumarr.count == 0){
                        self.transitdailyarr.addObject(num1)
                        self.transitdailyarr.addObject(num1)
                        self.transitdailyarr.addObject(num1)
                    }
                    if(self.transitdailyarr.count == 0){
                        self.transitdailyarr.addObject(num1)
                        self.transitdailyarr.addObject(num1)
                        self.transitdailyarr.addObject(num1)
                    }
                    
                    
                    arr = NSMutableArray()
                    currentarr = NSMutableArray()
                    if(self.analysisdict["waste"] != nil ){
                        if(self.analysisdict["waste"]!["info_json"] != nil){
                            var str = self.analysisdict["waste"]!["info_json"] as! String
                            var str1 = NSMutableString()
                            str1.appendString(str)
                            str = str.stringByReplacingOccurrencesOfString("'", withString: "\"")
                            str = str.stringByReplacingOccurrencesOfString("None", withString: "")
                            //print(str1)
                            //str = str1.mutableCopy() as! String
                            var dict = NSDictionary()
                            var jsonData = str
                            do {
                                if(self.convertStringToDictionary(str) != nil){
                                    dict = self.convertStringToDictionary(str)!
                                }
                                
                            }catch{
                                
                            }
                            arr = []
                            
                            arr = NSMutableArray()
                            
                            if(dict["Generated Waste (lbs per occupant per day)"] is NSNull || dict["Generated Waste (lbs per occupant per day)"] == nil){
                                arr.addObject(0.00000)
                            }else if(dict["Generated Waste (lbs per occupant per day)"] as? String == "None"){
                                arr.addObject(0.00000)
                            }else{
                                var occupancy = 0.0 as! Float
                                if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                                }else{
                                    occupancy = Float( self.buildingdetails["occupancy"] as! Int)
                                }
                                arr.addObject((dict["Generated Waste (lbs per occupant per day)"] as! Float  * 365.0) * occupancy )
                            }
                            
                            if(dict["Generated Waste (lbs per occupant per day)"] is NSNull || dict["Generated Waste (lbs per occupant per day)"] == nil){
                                arr.addObject(0.00000)
                            }else if(dict["Generated Waste (lbs per occupant per day)"] as? String == "None"){
                                arr.addObject(0.00000)
                            }else{
                                var occupancy = 0.0 as! Float
                                var gross = 0.0 as! Float
                                if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                                }else{
                                    occupancy = Float( self.buildingdetails["occupancy"] as! Int)
                                    gross = Float( self.buildingdetails["gross_area"] as! Int)
                                }
                                arr.addObject(((dict["Generated Waste (lbs per occupant per day)"] as! Float  * 365.0) * occupancy)/gross)
                            }
                            
                            if(dict["Generated Waste (lbs per occupant per day)"] is NSNull || dict["Generated Waste (lbs per occupant per day)"] == nil){
                                arr.addObject(0.00000)
                            }else if(dict["Generated Waste (lbs per occupant per day)"] as? String == "None"){
                                arr.addObject(0.00000)
                            }else{
                                var occupant = 0.0 as! Float
                                var gross = 0.0 as! Float
                                if(self.buildingdetails["occupancy"] == nil || self.buildingdetails["occupancy"] is NSNull){
                                }else{
                                    gross = Float( self.buildingdetails["gross_area"] as! Int)
                                    occupant = Float( self.buildingdetails["occupancy"] as! Int)
                                }
                                arr.addObject(dict["Generated Waste (lbs per occupant per day)"] as! Float  * 365.0)
                            }
                            
                            currentarr.addObject(arr)
                            arr = NSMutableArray()
                            
                            if(dict["Generated Waste (lbs per occupant per day)"] is NSNull || dict["Generated Waste (lbs per occupant per day)"] == nil){
                                arr.addObject(0.00000)
                            }else if(dict["Generated Waste (lbs per occupant per day)"] as? String == "None"){
                                arr.addObject(0.00000)
                            }else{
                                var occupancy = 0.0 as! Float
                                if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                                }else{
                                    occupancy = Float( self.buildingdetails["occupancy"] as! Int)
                                }
                                arr.addObject((dict["Generated Waste (lbs per occupant per day)"] as! Float) * occupancy )
                            }
                            
                            
                            if(dict["Generated Waste (lbs per occupant per day)"] is NSNull || dict["Generated Waste (lbs per occupant per day)"] == nil){
                                arr.addObject(0.00000)
                            }else if(dict["Generated Waste (lbs per occupant per day)"] as? String == "None"){
                                arr.addObject(0.00000)
                            }else{
                                var occupancy = 0.0 as! Float
                                var gross = 0.0 as! Float
                                if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                                }else{
                                    occupancy = Float( self.buildingdetails["occupancy"] as! Int)
                                    gross = Float( self.buildingdetails["gross_area"] as! Int)
                                }
                                arr.addObject(((dict["Generated Waste (lbs per occupant per day)"] as! Float) * occupancy)/gross)
                            }
                            
                            if(dict["Generated Waste (lbs per occupant per day)"] is NSNull || dict["Generated Waste (lbs per occupant per day)"] == nil){
                                arr.addObject(0.00000)
                            }else if(dict["Generated Waste (lbs per occupant per day)"] as? String == "None"){
                                arr.addObject(0.00000)
                            }else{
                                var occupant = 0.0 as! Float
                                var gross = 0.0 as! Float
                                if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["occupancy"] is NSNull){
                                }else{
                                    gross = Float( self.buildingdetails["gross_area"] as! Int)
                                    occupant = Float( self.buildingdetails["occupancy"] as! Int)
                                }
                                arr.addObject((dict["Generated Waste (lbs per occupant per day)"] as! Float))
                            }
                            currentarr.addObject(arr)
                            arr = NSMutableArray()
                            //print(currentarr)
                            self.tableview.reloadData()
                        }else{
                            arr = NSMutableArray()
                            arr.addObject(0.00000)
                            arr.addObject(0.00000)
                            currentarr.addObject(arr)
                        }
                    }else{
                        arr = NSMutableArray()
                        arr.addObject(0.00000)
                        arr.addObject(0.00000)
                        currentarr.addObject(arr)
                    }
                    self.wastearr = currentarr
                    arr = NSMutableArray()
                    currentarr = NSMutableArray()
                    dict = self.analysisdict
                    
                    if(self.analysisdict["energy"] != nil ){
                        if(self.analysisdict["energy"]!["info_json"] != nil){
                            var str = self.analysisdict["energy"]!["info_json"] as! String
                            var str1 = NSMutableString()
                            str1.appendString(str)
                            str = str.stringByReplacingOccurrencesOfString("'", withString: "\"")
                            str = str.stringByReplacingOccurrencesOfString("None", withString: "")
                            //print(str1)
                            //str = str1.mutableCopy() as! String
                            var dict = NSDictionary()
                            var jsonData = str
                            do {
                                if(self.convertStringToDictionary(str) != nil){
                                    dict = self.convertStringToDictionary(str)!
                                }
                                
                            }catch{
                                
                            }
                            arr = []
                            
                            arr = NSMutableArray()
                            if(dict["Adjusted Emissions per SF"] is NSNull || dict["Adjusted Emissions per SF"] == nil){
                                arr.addObject(0.00000)
                            }else if(dict["Adjusted Emissions per SF"] as? String == "None"){
                                arr.addObject(0.00000)
                            }else{
                                var gross = 0.0 as! Float
                                if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                                }else{
                                    gross = Float( self.buildingdetails["gross_area"] as! Int)
                                }
                                arr.addObject(dict["Adjusted Emissions per SF"] as! Float  * 365.0 * gross)
                            }
                            if(dict["Adjusted Emissions per SF"] is NSNull || dict["Adjusted Emissions per SF"] == nil){
                                arr.addObject(0.00000)
                            }else if(dict["Adjusted Emissions per SF"] as? String == "None"){
                                arr.addObject(0.00000)
                            }else{
                                arr.addObject(dict["Adjusted Emissions per SF"] as! Float  * 365.0)
                            }
                            
                            if(dict["Adjusted Emissions per Occupant"] is NSNull || dict["Adjusted Emissions per Occupant"] == nil){
                                arr.addObject(0.00000)
                            }else if(dict["Adjusted Emissions per Occupant"] as? String == "None"){
                                arr.addObject(0.00000)
                            }else{
                                arr.addObject((dict["Adjusted Emissions per Occupant"] as! Float  * 365.0))
                            }
                            
                            currentarr.addObject(arr)
                            arr = NSMutableArray()
                            
                            if(dict["Adjusted Emissions per SF"] is NSNull || dict["Adjusted Emissions per SF"] == nil){
                                arr.addObject(0.00000)
                            }else if(dict["Adjusted Emissions per SF"] as? String == "None"){
                                arr.addObject(0.00000)
                            }else{
                                var gross = 0.0 as! Float
                                if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                                }else{
                                    gross = Float( self.buildingdetails["gross_area"] as! Int)
                                }
                                arr.addObject(dict["Adjusted Emissions per SF"] as! Float * gross)
                            }
                            
                            
                            if(dict["Adjusted Emissions per SF"] is NSNull || dict["Adjusted Emissions per SF"] == nil){
                                arr.addObject(0.00000)
                            }else if(dict["Adjusted Emissions per SF"] as? String == "None"){
                                arr.addObject(0.00000)
                            }else{
                                arr.addObject(NSDecimalNumber(float: dict["Adjusted Emissions per SF"] as! Float))
                            }
                            
                            if(dict["Adjusted Emissions per Occupant"] is NSNull || dict["Adjusted Emissions per Occupant"] == nil){
                                arr.addObject(0.00000)
                            }else if(dict["Adjusted Emissions per Occupant"] as? String == "None"){
                                arr.addObject(0.00000)
                            }else{
                                arr.addObject((dict["Adjusted Emissions per Occupant"] as! Float))
                            }
                            
                            currentarr.addObject(arr)
                            arr = NSMutableArray()
                            
                            arr = NSMutableArray()
                            if(dict["Scope1 Raw GHG (mtCO2e/day)"] is NSNull || dict["Scope1 Raw GHG (mtCO2e/day)"] == nil){
                                arr.addObject(0.00000)
                            }else if(dict["Scope1 Raw GHG (mtCO2e/day)"] as? String == "None"){
                                arr.addObject(0.00000)
                            }else{
                                arr.addObject(dict["Raw GHG (mtCO2e/day)"] as! Float  * 365.0 )
                            }
                            if(dict["Scope1 Raw GHG (mtCO2e/day)"] is NSNull || dict["Scope1 Raw GHG (mtCO2e/day)"] == nil){
                                arr.addObject(0.00000)
                            }else if(dict["Scope1 Raw GHG (mtCO2e/day)"] as? String == "None"){
                                arr.addObject(0.00000)
                            }else{
                                var gross = 0.0 as! Float
                                if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                                }else{
                                    gross = Float( self.buildingdetails["gross_area"] as! Int)
                                }
                                arr.addObject((dict["Raw GHG (mtCO2e/day)"] as! Float  * 365.0) / gross )
                            }
                            
                            if(dict["Scope1 Raw GHG (mtCO2e/day)"] is NSNull || dict["Scope1 Raw GHG (mtCO2e/day)"] == nil){
                                arr.addObject(0.00000)
                            }else if(dict["Scope1 Raw GHG (mtCO2e/day)"] as? String == "None"){
                                arr.addObject(0.00000)
                            }else{
                                var occupant = 0.0 as! Float
                                if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["occupancy"] is NSNull){
                                }else{
                                    occupant = Float( self.buildingdetails["occupancy"] as! Int)
                                }
                                arr.addObject((dict["Scope1 Raw GHG (mtCO2e/day)"] as! Float  * 365.0) / occupant )
                            }
                            
                            currentarr.addObject(arr)
                            arr = NSMutableArray()
                            //print(currentarr)
                            self.tableview.reloadData()
                        }else{
                            arr = NSMutableArray()
                            arr.addObject(0.00000)
                            arr.addObject(0.00000)
                            arr.addObject(0.00000)
                            currentarr.addObject(arr)
                        }
                    }else{
                        arr = NSMutableArray()
                        arr.addObject(0.00000)
                        arr.addObject(0.00000)
                        arr.addObject(0.00000)
                        currentarr.addObject(arr)
                    }
                    
                    self.energyarr = currentarr
                    //print(currentarr)
                    currentarr = NSMutableArray()
                    dict = self.analysisdict
                    
                    arr = NSMutableArray()
                    if(dict["energy"] is NSNull){
                        let a = NSArray.init(objects: "0.000","0.000")
                        currentarr.addObject(a)
                    }else{
                        if(dict["energy"] == nil){
                            let a = NSArray.init(objects: "0.000","0.000")
                            currentarr.addObject(a)
                        }else{
                            if(dict["energy"]!["info_json"] is NSNull){
                                let a = NSArray.init(objects: "0.000","0.000")
                                currentarr.addObject(a)
                            }else{
                                var str = dict["energy"]!["info_json"] as! String
                                let str1 = NSMutableString()
                                str1.appendString(str)
                                str1.replaceOccurrencesOfString("'", withString: "\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
                                str1.replaceOccurrencesOfString("None", withString: "\"None\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
                                ////print(str1)
                                str = str1.mutableCopy() as! String
                                let jsonData = (str).dataUsingEncoding(NSUTF8StringEncoding)
                                do {
                                    dict = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions()) as! NSDictionary
                                    if(dict["Scope2 Raw GHG (mtCO2e/day)"] is NSNull){
                                        let a = NSArray.init(objects: "0.000","0.000")
                                        currentarr.addObject(a)
                                    }else if(dict["Scope2 Raw GHG (mtCO2e/day)"] as? String == "None"){
                                        let a = NSArray.init(objects: "0.000","0.000")
                                        currentarr.addObject(a)
                                    }else{
                                        let a = NSMutableArray()
                                        var gross = Float(0)
                                        if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                                        }else{
                                            gross = Float( self.buildingdetails["gross_area"] as! Int)
                                        }
                                        a.addObject(String(format:"%.5f",(dict["Scope2 Raw GHG (mtCO2e/day)"] as! Float  * 365) / gross))
                                        var occupant = Float(0)
                                        if(self.buildingdetails["occupancy"] == nil || self.buildingdetails["occupancy"] is NSNull){
                                        }else{
                                            occupant = Float( self.buildingdetails["occupancy"] as! Int)
                                        }
                                        a.addObject(String(format:"%.5f",(dict["Scope2 Raw GHG (mtCO2e/day)"] as! Float  * 365) / occupant ))
                                        currentarr.addObject(a)
                                    }
                                }catch{
                                    let a = NSArray.init(objects: "0.000","0.000")
                                    currentarr.addObject(a)
                                }
                            }
                        }
                    }
                    //print(currentarr)
                    var temp = NSMutableArray()
                    var f1 = Float(currentarr.objectAtIndex(0).objectAtIndex(0) as! String)!
                    var f2 = Float(currentarr.objectAtIndex(0).objectAtIndex(1) as! String)!
                    var a = NSMutableArray()
                    a.addObject(String(format:"%.5f",f1/30.0))
                    a.addObject(String(format:"%.5f",f2/30.0))
                    currentarr.addObject(a)
                    a = NSMutableArray()
                    a.addObject(String(format:"%.5f",f1/365.0))
                    a.addObject(String(format:"%.5f",f2/365.0))
                    currentarr.addObject(a)
                    self.energyarrscope2 = currentarr
                    //print(currentarr)
                    
                    
                    currentarr = NSMutableArray()
                    dict = self.analysisdict
                    
                    arr = NSMutableArray()
                    if(dict["energy"] is NSNull){
                        let a = NSArray.init(objects: "0.000","0.000")
                        currentarr.addObject(a)
                    }else{
                        if(dict["energy"] == nil){
                            let a = NSArray.init(objects: "0.000","0.000")
                            currentarr.addObject(a)
                        }else{
                            if(dict["energy"]!["info_json"] is NSNull){
                                let a = NSArray.init(objects: "0.000","0.000")
                                currentarr.addObject(a)
                            }else{
                                var str = dict["energy"]!["info_json"] as! String
                                let str1 = NSMutableString()
                                str1.appendString(str)
                                str1.replaceOccurrencesOfString("'", withString: "\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
                                str1.replaceOccurrencesOfString("None", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
                                ////print(str1)
                                str = str1.mutableCopy() as! String
                                let jsonData = (str).dataUsingEncoding(NSUTF8StringEncoding)
                                do {
                                    dict = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions()) as! NSDictionary
                                    if(dict["Scope1 Raw GHG (mtCO2e/day)"] is NSNull){
                                        let a = NSArray.init(objects: "0.000","0.000")
                                        currentarr.addObject(a)
                                    }else{
                                        let a = NSMutableArray()
                                        var gross = Float(0)
                                        if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                                            let a = NSArray.init(objects: "0.000","0.000")
                                            currentarr.addObject(a)
                                        }else{
                                            gross = Float( self.buildingdetails["gross_area"] as! Int)
                                        }
                                        a.addObject(String(format:"%.5f",(dict["Scope1 Raw GHG (mtCO2e/day)"] as! Float  * 365.0) / gross))
                                        var occupant = Float(0)
                                        if(self.buildingdetails["occupancy"] == nil || self.buildingdetails["occupancy"] is NSNull){
                                        }else{
                                            occupant = Float( self.buildingdetails["occupancy"] as! Int)
                                        }
                                        a.addObject(String(format:"%.5f",(dict["Scope1 Raw GHG (mtCO2e/day)"] as! Float  * 365) / occupant ))
                                        currentarr.addObject(a)
                                    }
                                }catch{
                                    let a = NSArray.init(objects: "0.000","0.000")
                                    currentarr.addObject(a)
                                }
                            }
                        }
                    }
                    
                    temp = NSMutableArray()
                    f1 = Float(currentarr.objectAtIndex(0).objectAtIndex(0) as! String)!
                    f2 = Float(currentarr.objectAtIndex(0).objectAtIndex(1) as! String)!
                    a = NSMutableArray()
                    a.addObject(String(format:"%.5f",f1/30.0))
                    a.addObject(String(format:"%.5f",f2/30.0))
                    currentarr.addObject(a)
                    a = NSMutableArray()
                    a.addObject(String(format:"%.5f",f1/365.0))
                    a.addObject(String(format:"%.5f",f2/365.0))
                    currentarr.addObject(a)
                    self.energyarrscope1 = currentarr
                    //print(currentarr)
                    
                    
                    currentarr = NSMutableArray()
                    dict = self.analysisdict
                    arr = NSMutableArray()
                    
                    if(dict["waste"] is NSNull){
                        let a = NSArray.init(objects: "0.000","0.000")
                        currentarr.addObject(a)
                    }else{
                        if(dict["waste"] == nil){
                            let a = NSArray.init(objects: "0.000","0.000")
                            currentarr.addObject(a)
                        }else{
                            if(dict["waste"]!["info_json"] is NSNull){
                                let a = NSArray.init(objects: "0.000","0.000")
                                currentarr.addObject(a)
                            }else{
                                var str = dict["waste"]!["info_json"] as! String
                                let str1 = NSMutableString()
                                str1.appendString(str)
                                str1.replaceOccurrencesOfString("'", withString: "\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
                                str1.replaceOccurrencesOfString("None", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
                                ////print(str1)
                                str = str1.mutableCopy() as! String
                                let jsonData = (str).dataUsingEncoding(NSUTF8StringEncoding)
                                do {
                                    dict = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions()) as! NSDictionary
                                    if(dict["Generated Waste (lbs per occupant per day)"] is NSNull){
                                        
                                    }else{
                                        var gross = Float(0)
                                        if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                                        }else{
                                            gross = Float( self.buildingdetails["gross_area"] as! Int)
                                        }
                                        let a = NSMutableArray()
                                        a.addObject(String(format:"%.5f",(dict["Generated Waste (lbs per occupant per day)"] as! Float  * 365) / gross ))
                                        var occupant = Float(0)
                                        if(self.buildingdetails["occupancy"] == nil || self.buildingdetails["occupancy"] is NSNull){
                                        }else{
                                            occupant = Float( self.buildingdetails["occupancy"] as! Int)
                                        }
                                        a.addObject(String(format:"%.5f",(dict["Generated Waste (lbs per occupant per day)"] as! Float  * 365) / occupant ))
                                        currentarr.addObject(a)
                                    }
                                }catch{
                                    let a = NSArray.init(objects: "0.000","0.000")
                                    currentarr.addObject(a)
                                }
                            }
                        }
                    }

                    temp = NSMutableArray()
                    f1 = Float(currentarr.objectAtIndex(0).objectAtIndex(0) as! String)!
                    f2 = Float(currentarr.objectAtIndex(0).objectAtIndex(1) as! String)!
                    a = NSMutableArray()
                    a.addObject(String(format:"%.5f",f1/30.0))
                    a.addObject(String(format:"%.5f",f2/30.0))
                    currentarr.addObject(a)
                    a = NSMutableArray()
                    a.addObject(String(format:"%.5f",f1/365.0))
                    a.addObject(String(format:"%.5f",f2/365.0))
                    currentarr.addObject(a)
                    self.wastearray = currentarr
                    //print(currentarr)
                    currentarr = NSMutableArray()
                    
                    dict = self.analysisdict
                    if(dict["water"] is NSNull){
                        let a = NSArray.init(objects: "0.000","0.000")
                        currentarr.addObject(a)
                    }else{
                        if(dict["water"] == nil){
                            let a = NSArray.init(objects: "0.000","0.000")
                            currentarr.addObject(a)
                        }else{
                            if(dict["water"]!["info_json"] is NSNull){
                                let a = NSArray.init(objects: "0.000","0.000")
                                currentarr.addObject(a)
                            }else{
                                var str = dict["water"]!["info_json"] as? String
                                let str1 = NSMutableString()
                                str1.appendString(str!)
                                str1.replaceOccurrencesOfString("'", withString: "\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str!.characters.count))
                                str1.replaceOccurrencesOfString("None", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str!.characters.count))
                                ////print(str1)
                                str = str1.mutableCopy() as? String
                                let jsonData = (str!).dataUsingEncoding(NSUTF8StringEncoding)
                                do {
                                    dict = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions()) as! NSDictionary
                                    if(dict["Raw Water Use (gallons/day)"] is NSNull){
                                        
                                    }else{
                                        let a = NSMutableArray()
                                        var gross = Float(0)
                                        if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                                        }else{
                                            gross = Float( self.buildingdetails["gross_area"] as! Int)
                                        }
                                        a.addObject(String(format:"%.5f",(dict["Raw Water Use (gallons/day)"] as! Float  * 365) / gross ))
                                        var occupant = Float(0)
                                        if(self.buildingdetails["occupancy"] == nil || self.buildingdetails["occupancy"] is NSNull){
                                        }else{
                                            occupant = Float( self.buildingdetails["occupancy"] as! Int)
                                        }
                                        a.addObject(String(format:"%.5f",(dict["Raw Water Use (gallons/day)"] as! Float  * 365) / occupant ))
                                        
                                        currentarr.addObject(a)
                                    }
                                }catch{
                                    let a = NSArray.init(objects: "0.000","0.000")
                                    currentarr.addObject(a)
                                }
                            }
                        }
                    }
                    
                    temp = NSMutableArray()
                    f1 = Float(currentarr.objectAtIndex(0).objectAtIndex(0) as! String)!
                    f2 = Float(currentarr.objectAtIndex(0).objectAtIndex(1) as! String)!
                    a = NSMutableArray()
                    a.addObject(String(format:"%.5f",(f1/365.0) * 30.0))
                    a.addObject(String(format:"%.5f",(f2/365.0) * 30.0))
                    currentarr.addObject(a)
                    a = NSMutableArray()
                    a.addObject(String(format:"%.5f",f1/365.0))
                    a.addObject(String(format:"%.5f",f2/365.0))
                    currentarr.addObject(a)
                    self.waterarray = currentarr
                    //print(currentarr)
                    currentarr = NSMutableArray()
                    arr = NSMutableArray()
                    
                    if(self.analysisdict["transit"] != nil ){
                        if(self.analysisdict["transit"]!["info_json"] != nil){
                            var str = self.analysisdict["transit"]!["info_json"] as! String
                            var str1 = NSMutableString()
                            str1.appendString(str)
                            str = str.stringByReplacingOccurrencesOfString("'", withString: "\"")
                            str = str.stringByReplacingOccurrencesOfString("None", withString: "")
                            //print(str1)
                            //str = str1.mutableCopy() as! String
                            var dict = NSDictionary()
                            var jsonData = str
                            do {
                                if(self.convertStringToDictionary(str) != nil){
                                    dict = self.convertStringToDictionary(str)!
                                }
                                
                            }catch{
                                
                            }
                            arr = []
                            
                            arr = NSMutableArray()
                            
                            if(dict["Average Transit CO2e"] is NSNull || dict["Average Transit CO2e"] == nil){
                                arr.addObject(0.00000)
                            }else if(dict["Average Transit CO2e"] as? String == "None"){
                                arr.addObject(0.00000)
                            }else{
                                var occupancy = 0.0 as! Float
                                if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                                }else{
                                    occupancy = Float( self.buildingdetails["occupancy"] as! Int)
                                }
                                arr.addObject((dict["Average Transit CO2e"] as! Float) * occupancy )
                            }
                            
                            if(dict["Average Transit CO2e"] is NSNull || dict["Average Transit CO2e"] == nil){
                                arr.addObject(0.00000)
                            }else if(dict["Average Transit CO2e"] as? String == "None"){
                                arr.addObject(0.00000)
                            }else{
                                var occupancy = 0.0 as! Float
                                var gross = 0.0 as! Float
                                if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                                }else{
                                    occupancy = Float( self.buildingdetails["occupancy"] as! Int)
                                    gross = Float( self.buildingdetails["gross_area"] as! Int)
                                }
                                arr.addObject((dict["Average Transit CO2e"] as! Float ))
                            }
                            
                            
                            currentarr.addObject(arr)
                            arr = NSMutableArray()
                            
                            if(dict["Transportation Participation Fraction"] is NSNull || dict["Transportation Participation Fraction"] == nil){
                                arr.addObject(0.00000)
                            }else if(dict["Transportation Participation Fraction"] as? String == "None"){
                                arr.addObject(0.00000)
                            }else{
                                var occupancy = 0.0 as! Float
                                if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                                }else{
                                    occupancy = Float( self.buildingdetails["occupancy"] as! Int)
                                }
                                arr.addObject((dict["Transportation Participation Fraction"] as! Float) * 100 )
                            }
                            
                            
                            arr.addObject(0.00000)
                            
                            
                            
                            currentarr.addObject(arr)
                            arr = NSMutableArray()
                            
                            //print(currentarr)
                            self.tableview.reloadData()
                        }else{
                            
                            arr = NSMutableArray()
                            arr.addObject(0.00000)
                            arr.addObject(0.00000)
                            currentarr.addObject(arr)
                        }
                    }else{
                        arr = NSMutableArray()
                        arr.addObject(0.00000)
                        arr.addObject(0.00000)
                        currentarr.addObject(arr)
                    }
                    self.transitarr = currentarr
                    //print(currentarr)
                    currentarr = NSMutableArray()
                        if(self.analysisdict["human"] != nil ){
                            if(self.analysisdict["human"]!["info_json"] != nil){
                                var str = self.analysisdict["human"]!["info_json"] as! String
                                var str1 = NSMutableString()
                                str1.appendString(str)
                                str = str.stringByReplacingOccurrencesOfString("'", withString: "\"")
                                str = str.stringByReplacingOccurrencesOfString("None", withString: "")
                                //print(str1)
                                //str = str1.mutableCopy() as! String
                                var dict = NSDictionary()
                                var jsonData = str
                                if(self.convertStringToDictionary(str) == nil){
                                    arr = NSMutableArray()
                                    arr.addObject(0.00000)
                                    currentarr.addObject(arr)
                                    arr = NSMutableArray()
                                    arr.addObject(0.00000)
                                    currentarr.addObject(arr)
                                    arr = NSMutableArray()
                                    arr.addObject(0.00000)
                                    currentarr.addObject(arr)
                                    arr = NSMutableArray()
                                    arr.addObject(0.00000)
                                    currentarr.addObject(arr)
                                }else{
                                    dict = self.convertStringToDictionary(str)!
                                    var insidedict = dict["Human Experience Inputs"] as! [String:AnyObject]
                                    //str = str1.mutableCopy() as! String
                                    //insidedict = convertStringToDictionary(str)!
                                    //print(insidedict)
                                    
                                    
                                    
                                    
                                    arr = []
                                    
                                    arr = NSMutableArray()
                                    
                                    if(insidedict["co2"] is NSNull || insidedict["co2"] == nil || insidedict["co2"] as? String == "None"){
                                        arr.addObject(0.00000)
                                    }else{
                                        var occupancy = 0.0 as! Float
                                        if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                                        }else{
                                            occupancy = Float( self.buildingdetails["occupancy"] as! Int)
                                        }
                                        arr.addObject((insidedict["co2"] as! Int))
                                    }
                                    
                                    currentarr.addObject(arr)
                                    arr = NSMutableArray()
                                    
                                    if(insidedict["voc"] is NSNull || insidedict["voc"] == nil || insidedict["voc"] as? String == "None"){
                                        arr.addObject(0.00000)
                                    }else{
                                        var occupancy = 0.0 as! Float
                                        if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                                        }else{
                                            occupancy = Float( self.buildingdetails["occupancy"] as! Int)
                                        }
                                        arr.addObject((insidedict["voc"] as! Int))
                                    }
                                    
                                    currentarr.addObject(arr)
                                    arr = NSMutableArray()
                                    
                                    if(insidedict["occupant_satisfaction_fraction"] is NSNull || insidedict["occupant_satisfaction_fraction"] == nil || insidedict["occupant_satisfaction_fraction"] as? String == "None"){
                                        arr.addObject(0.00000)
                                    }else{
                                        var occupancy = 0.0 as! Float
                                        if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                                        }else{
                                            occupancy = Float( self.buildingdetails["occupancy"] as! Int)
                                        }
                                        arr.addObject((insidedict["occupant_satisfaction_fraction"] as! Float * 100 ))
                                    }
                                    
                                    //scope2dailyarr = arr
                                    currentarr.addObject(arr)
                                    arr = NSMutableArray()
                                    
                                    if(self.analysisdict["transit"] != nil ){
                                        if(self.analysisdict["transit"]!["info_json"] != nil){
                                            var str = self.analysisdict["transit"]!["info_json"] as! String
                                            var str1 = NSMutableString()
                                            str1.appendString(str)
                                            str = str.stringByReplacingOccurrencesOfString("'", withString: "\"")
                                            str = str.stringByReplacingOccurrencesOfString("None", withString: "")
                                            //print(str1)
                                            //str = str1.mutableCopy() as! String
                                            var dict = NSDictionary()
                                            var jsonData = str
                                            do {
                                                if(self.convertStringToDictionary(str) != nil){
                                                    dict = self.convertStringToDictionary(str)!
                                                    if(dict["Transportation Participation Fraction"] is NSNull || dict["Transportation Participation Fraction"] == nil){
                                                        arr.addObject(0.00000)
                                                    }else if(dict["Transportation Participation Fraction"] as? String == "None"){
                                                        arr.addObject(0.00000)
                                                    }else{
                                                        var occupancy = 0.0 as! Float
                                                        if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                                                        }else{
                                                            occupancy = Float( self.buildingdetails["occupancy"] as! Int)
                                                        }
                                                        arr.addObject((dict["Transportation Participation Fraction"] as! Float) * 100 )
                                                    }
                                                }else{
                                                    arr.addObject(0.0000)
                                                }
                                            }catch{
                                                arr.addObject(0.0000)
                                            }
                                        }else{
                                            arr.addObject(0.0000)
                                        }
                                    }else{
                                        arr.addObject(0.0000)
                                    }
                                    //scope2dailyarr = arr
                                    currentarr.addObject(arr)
                                    arr = NSMutableArray()
                                    //print(currentarr)
                                    self.tableview.reloadData()
                                }
                            }else{
                                
                                arr = NSMutableArray()
                                arr.addObject(0.00000)
                                arr.addObject(0.00000)
                                arr.addObject(0.00000)
                                arr.addObject(0.00000)
                                currentarr.addObject(arr)
                            }
                        }else{
                            arr = NSMutableArray()
                            arr.addObject(0.00000)
                            arr.addObject(0.00000)
                            arr.addObject(0.00000)
                            arr.addObject(0.00000)
                            currentarr.addObject(arr)
                        }
                    //print(currentarr)
                    self.humanarr = currentarr
                    currentarr = NSMutableArray()
                    
                    arr = NSMutableArray()
                    if(self.analysisdict["water"] != nil ){
                        if(self.analysisdict["water"]!["info_json"] != nil){
                            var str = self.analysisdict["water"]!["info_json"] as! String
                            var str1 = NSMutableString()
                            str1.appendString(str)
                            str = str.stringByReplacingOccurrencesOfString("'", withString: "\"")
                            str = str.stringByReplacingOccurrencesOfString("None", withString: "")
                            //print(str1)
                            //str = str1.mutableCopy() as! String
                            var dict = NSDictionary()
                            var jsonData = str
                            do {
                                if(self.convertStringToDictionary(str) != nil){
                                    dict = self.convertStringToDictionary(str)!
                                }
                                
                            }catch{
                                
                            }
                            arr = []
                            
                            arr = NSMutableArray()
                            
                            if(dict["Adjusted Gallons per SF"] is NSNull || dict["Adjusted Gallons per SF"] == nil){
                                arr.addObject(0.00000)
                            }else if(dict["Adjusted Gallons per SF"] as? String == "None"){
                                arr.addObject(0.00000)
                            }else{
                                var gross = 0.0 as! Float
                                if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                                }else{
                                    gross = Float( self.buildingdetails["gross_area"] as! Int)
                                }
                                arr.addObject((dict["Adjusted Gallons per SF"] as! Float  * 365.0) * gross )
                            }
                            
                            if(dict["Adjusted Gallons per SF"] is NSNull || dict["Adjusted Gallons per SF"] == nil){
                                arr.addObject(0.00000)
                            }else if(dict["Adjusted Gallons per SF"] as? String == "None"){
                                arr.addObject(0.00000)
                            }else{
                                arr.addObject((dict["Adjusted Gallons per SF"] as! Float  * 365.0))
                            }
                            
                            if(dict["Adjusted Gallons per Occupant"] is NSNull || dict["Adjusted Gallons per Occupant"] == nil){
                                arr.addObject(0.00000)
                            }else if(dict["Adjusted Gallons per Occupant"] as? String == "None"){
                                arr.addObject(0.00000)
                            }else{
                                var occupant = 0.0 as! Float
                                var gross = 0.0 as! Float
                                if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["occupancy"] is NSNull){
                                }else{
                                    gross = Float( self.buildingdetails["gross_area"] as! Int)
                                    occupant = Float( self.buildingdetails["occupancy"] as! Int)
                                }
                                arr.addObject((dict["Adjusted Gallons per Occupant"] as! Float  * 365))
                            }
                            currentarr.addObject(arr)
                            arr = NSMutableArray()
                            
                            if(dict["Adjusted Gallons per SF"] is NSNull || dict["Adjusted Gallons per SF"] == nil){
                                arr.addObject(0.00000)
                            }else if(dict["Adjusted Gallons per SF"] as? String == "None"){
                                arr.addObject(0.00000)
                            }else{
                                var occupant = 0.0 as! Float
                                var gross = 0.0 as! Float
                                if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["occupancy"] is NSNull){
                                }else{
                                    gross = Float( self.buildingdetails["gross_area"] as! Int)
                                }
                                arr.addObject((dict["Adjusted Gallons per SF"] as! Float) * gross )
                            }
                            
                            
                            if(dict["Adjusted Gallons per SF"] is NSNull || dict["Adjusted Gallons per SF"] == nil){
                                arr.addObject(0.00000)
                            }else if(dict["Adjusted Gallons per SF"] as? String == "None"){
                                arr.addObject(0.00000)
                            }else{
                                var gross = 0.0 as! Float
                                if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                                }else{
                                    gross = Float( self.buildingdetails["gross_area"] as! Int)
                                }
                                arr.addObject(dict["Adjusted Gallons per SF"] as! Float)
                            }
                            
                            if(dict["Adjusted Gallons per Occupant"] is NSNull || dict["Adjusted Gallons per Occupant"] == nil){
                                arr.addObject(0.00000)
                            }else if(dict["Adjusted Gallons per Occupant"] as? String == "None"){
                                arr.addObject(0.00000)
                            }else{
                                var occupant = 0.0 as! Float
                                var gross = 0.0 as! Float
                                if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["occupancy"] is NSNull){
                                }else{
                                    gross = Float( self.buildingdetails["gross_area"] as! Int)
                                    occupant = Float( self.buildingdetails["occupancy"] as! Int)
                                }
                                arr.addObject(dict["Adjusted Gallons per Occupant"] as! Float)
                            }
                            currentarr.addObject(arr)
                            arr = NSMutableArray()
                            //print(currentarr)
                            self.tableview.reloadData()
                        }else{
                            arr = NSMutableArray()
                            arr.addObject(0.00000)
                            arr.addObject(0.00000)
                            currentarr.addObject(arr)
                        }
                    }else{
                        arr = NSMutableArray()
                        arr.addObject(0.00000)
                        arr.addObject(0.00000)
                        currentarr.addObject(arr)
                    }

                    self.waterarr = currentarr
                    //print(self.waterarr)
                    currentarr = NSMutableArray()
                    
                    arr = NSMutableArray()
                    dict = NSDictionary()
                    if(self.analysisdict["energy"] is NSNull || self.analysisdict["energy"] == nil){
                        
                    }else{
                        if(self.analysisdict["energy"]!["info_json"] is NSNull){
                            let emissions = [Int]()
                            let values = [Int]()
                            self.energyemissions = emissions
                            self.energyvalues = values
                        }else{
                            var str = self.analysisdict["energy"]!["info_json"] as! String
                            let str1 = NSMutableString()
                            str1.appendString(str)
                            str1.replaceOccurrencesOfString("'", withString: "\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
                            str1.replaceOccurrencesOfString("None", withString: "\"None\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
                            str = str1.mutableCopy() as! String
                            //print(str)
                            let jsonData = (str).dataUsingEncoding(NSUTF8StringEncoding)
                            do {
                                if(self.convertStringToDictionary(str) != nil){
                                dict = self.convertStringToDictionary(str)!
                                //print(self.convertStringToDictionary(str))
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
                                ////print("Tempdict",tempdict,values,emissions)
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
                            str1.replaceOccurrencesOfString("'", withString: "\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
                            str1.replaceOccurrencesOfString("None", withString: "\"None\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
                            str = str1.mutableCopy() as! String
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
                                ////print("Tempdict",tempdict,values,emissions)
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
                            str1.replaceOccurrencesOfString("'", withString: "\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
                            str1.replaceOccurrencesOfString("None", withString: "\"None\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
                            str = str1.mutableCopy() as! String
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
                                ////print("Tempdict",tempdict,values,emissions)
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
                            str1.replaceOccurrencesOfString("'", withString: "\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
                            str1.replaceOccurrencesOfString("None", withString: "\"None\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
                            str = str1.mutableCopy() as! String
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
                                ////print("Tempdict",tempdict,values,emissions)
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
                            str1.replaceOccurrencesOfString("'", withString: "\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
                            str1.replaceOccurrencesOfString("None", withString: "\"None\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
                            str = str1.mutableCopy() as! String
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
                                ////print("Tempdict",tempdict,values,emissions)
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
                        
                        if(self.spinnerhide == 0){
                        self.spinner.hidden = true
                        self.view.userInteractionEnabled = true
                        self.tableview.alpha = 1.0
                        }
                        
                        self.getmax("energy", arr: self.scoresarr)
                        self.tableview.reloadData()
                    })
                } catch {
                    ////print(error)
                }
                
                
            } else {
                taskerror = true
            }
            }
                if(self.spinnerhide == 0){
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    self.tableview.alpha = 1.0
                }
            })
            
        })
        
        
        
        
        tasky.resume()
    }
    
    var spinnerhide = 0
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:AnyObject]
                return json
            } catch {
                //print("Something went wrong")
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
                        str1.replaceOccurrencesOfString("None", withString: "\"None\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
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
                            ////print("Tempdict",tempdict,values,emissions)
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
                        str1.replaceOccurrencesOfString("None", withString: "\"None\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
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
                            ////print("Tempdict",tempdict,values,emissions)
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
                        str1.replaceOccurrencesOfString("None", withString: "\"None\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
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
                            ////print("Tempdict",tempdict,values,emissions)
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
                        str1.replaceOccurrencesOfString("None", withString: "\"None\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
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
                            ////print("Tempdict",tempdict,values,emissions)
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
                        str1.replaceOccurrencesOfString("None", withString: "\"None\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
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
                            ////print("Tempdict",tempdict,values,emissions)
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
                ////print(dict)
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
            ////print(dict)
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
        
        ////print(fullarr)
        if(fullarr.count > 0){
            highduringreport = fullarr.maxElement()!
            lessduringreport = fullarr.minElement()!
        }
        
    }
    
    func getperformancedata(subscription_key:String, leedid: Int, date : String){
        let url = NSURL.init(string: String(format: "%@assets/LEED:%d/scores/",credentials().domain_url,leedid))
        //print(url?.absoluteURL)
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
                //print("error=\(error)")
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
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    })
                }else{
                    //print(data)
                    let jsonDictionary : NSMutableDictionary
                    do {
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()).mutableCopy() as! NSMutableDictionary
                        //print(jsonDictionary)
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
                        //print(error)
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
        return 10
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 1){
            return 5
        }
        if(section == 7){
            return 5
        }
        if(section == 6){
            return 5
        }
        if(section == 5){
            return 8
        }
        if(section == 4){
            return 8
        }
        if(section == 3){
            return 11
        }
        if(section == 8){
            return 24
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
            return 0.228 * height
        }else if(indexPath.section == 1){
            return 0.069 * height
        }
        if(indexPath.section >= 3 && indexPath.section <= 8){
            if(boolarr[indexPath.section] == false){
                return 0
            }
            if(indexPath.section == 7){
                if(indexPath.row >= 1 && indexPath.row <= 4){
                    return 0.099 * height
                }
            }
            if(indexPath.section == 6){
                if(indexPath.row >= 1 && indexPath.row <= 4){
                    return 0.099 * height
                }
            }
            if(indexPath.section == 5){
                if(indexPath.row >= 2 && indexPath.row <= 7){
                    return 0.099 * height
                }
            }
            if(indexPath.section == 4){
                if(indexPath.row >= 2 && indexPath.row <= 7){
                    return 0.099 * height
                }
            }
            if(indexPath.section == 3){
                if(indexPath.row >= 2 && indexPath.row <= 10){
                    return 0.099 * height
                }
            }
            if(indexPath.section == 8){
                    return 0.099 * height
            }
            return 0.34 * height
            
            
            
            if(indexPath.section == 3){
                return 0.34 * height
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
                    str1.replaceOccurrencesOfString("None", withString: "\"None\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
                    str = str1.mutableCopy() as! String
                    let jsonData = (str).dataUsingEncoding(NSUTF8StringEncoding)
                    do {
                        ////print("dictsss ",dict)
                        var temp = dict[key] as! [NSString:AnyObject]
                        temp["info_json"] = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions()) as! NSDictionary
                        dict.setValue(temp, forKey: key)
                        ////print(dict[key])
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
            tempostring = NSMutableAttributedString(string:(self.buildingdetails["name"] as? String)!)
            tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 17)! , range: NSMakeRange(0, tempostring.length))
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
            //print(actualstring)
            cell.details.attributedText = actualstring
            cell.leedid.numberOfLines = 3
            cell.details.numberOfLines = 4
            tempstring.deleteCharactersInRange(NSMakeRange(0, tempstring.length))
            tempstring.appendString(String(format: "%d",NSUserDefaults.standardUserDefaults().integerForKey("leed_id")))
            tempstring.appendString("\n")
            if let gross = self.buildingdetails["gross_area"] as? Int{
                tempstring.appendString(String(format: "%d Sq.Ft",gross))
            }else{
                tempstring.appendString(String(format: "0 Sq.Ft"))
            }
            
            //cell.leedid.text = tempstring as String
           // cell.gross.text = String(format: "%d Sq.Ft",buildingdetails["gross_area"] as! Int)
            
            //cell.duration.text = duration
            
            cell.accessoryType = UITableViewCellAccessoryType.None
            //cell.backgroundColor = UIColor.clearColor()
            cell.clipsToBounds = true
                    return cell
        }else if(indexPath.section == 1){
            let cell = tableview.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            if(indexPath.row == 0){
                cell.textLabel?.text = "Project ID"
                cell.detailTextLabel?.text = String(format: "%d",NSUserDefaults.standardUserDefaults().integerForKey("leed_id"))
            }else if(indexPath.row == 1){
                if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                cell.detailTextLabel?.text = ""
                }else{
                cell.detailTextLabel?.text = String(format: "%d Sq.Ft",buildingdetails["gross_area"] as! Int)
                }
                cell.textLabel?.text = "Gross Floor Area"
            }else if(indexPath.row == 2){
                cell.textLabel?.text = "Hours"
                if(self.buildingdetails["operating_hours"] == nil || self.buildingdetails["operating_hours"] is NSNull){
                    cell.detailTextLabel?.text = ""
                }else{
                    cell.detailTextLabel?.text = String(format: "%d",buildingdetails["operating_hours"] as! Int)
                }
            }else if(indexPath.row == 3){
                cell.textLabel?.text = "Occupants"
                if(self.buildingdetails["occupancy"] == nil || self.buildingdetails["occupancy"] is NSNull){
                    cell.detailTextLabel?.text = ""
                }else{
                    cell.detailTextLabel?.text = String(format: "%d",buildingdetails["occupancy"] as! Int)
                }
            }else if(indexPath.row == 4){
                cell.detailTextLabel?.text = duration
                cell.textLabel?.text = "Reporting Period"
            }
            cell.clipsToBounds = true
                    return cell
        }else if(indexPath.section == 2){
            let cell = tableview.dequeueReusableCellWithIdentifier("totalcell2")! as! totalanalysis2
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.cview.current = Double(currentscore)
            cell.cview.max = Double(maxscore)
            if(cell.cview.frame.size.width > cell.cview.frame.size.height){
                cell.cview.frame.size.width = cell.cview.frame.size.height
            }else{
                cell.cview.frame.size.height = cell.cview.frame.size.width
            }
            if(cell.cview.max == 0.0){
                cell.cview.max = 100.0
            }
            cell.cview.center = CGPointMake(cell.contentView.frame.size.width/2, cell.contentView.frame.size.height/2)
            cell.cview.addUntitled1Animation()
            var actualstring = NSMutableAttributedString()
            var tempostring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString(string:"0")
            tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 17)! , range: NSMakeRange(0, tempostring.length))
            tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, tempostring.length))
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:"/100")
            tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans", size: 17)! , range: NSMakeRange(0, tempostring.length))
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            //print(actualstring)
            cell.lowestscorelbl.attributedText = actualstring
            
            
            actualstring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString(string:"\(highduringreport as! Int)")
            tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 17)! , range: NSMakeRange(0, tempostring.length))
            tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, tempostring.length))
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:"/100")
            tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans", size: 17)! , range: NSMakeRange(0, tempostring.length))
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            //print(actualstring)
            
            cell.highestscorelbl.attributedText = actualstring
            
            let tempstring = NSMutableString()
              tempstring.appendString(String(format: "Highest score during reporting period:  %d", highduringreport))
            tempstring.appendString("\n")
            tempstring.appendString(String(format: "Lowest score during reporting period: 0"))// %d", lessduringreport))
            cell.highscore.adjustsFontSizeToFitWidth = true
            cell.highscore.text = tempstring as String
            cell.highscore.frame.origin.x = cell.textLabel!.frame.origin.x
            
            //view.center = CGPointMake(cell.contentView.bounds.size.width/2,cell.contentView.bounds.size.height/2.5);
            cell.clipsToBounds = true
                    return cell
        }
        else {
            /*if(indexPath.row == 0){
                rightarr = totalannumarr
            }else if(indexPath.row == 1){
                rightarr = totaldailyarr
            }else if(indexPath.row == 2){
                rightarr = scope1annumarr
            }else if(indexPath.row == 3){
                rightarr = scope1dailyarr
            }else if(indexPath.row == 4){
                rightarr = scope2annumarr
            }else if(indexPath.row == 5){
                rightarr = scope2dailyarr
            }else if(indexPath.row == 6){
                rightarr = transitannumarr
            }else if(indexPath.row == 7){
                rightarr = transitdailyarr
            }*/
            if(indexPath.section == 8){
                if(indexPath.row == 0){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "TOTAL ANNUAL CARBON EMISSIONS (MTCO2e)"
                    cell.detailTextLabel!.text = String(format: "%.4f",totalannumarr.objectAtIndex(0) as! Double)
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                }else if(indexPath.row == 1){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "TOTAL DAILY CARBON EMISSIONS (MTCO2e)"
                    cell.detailTextLabel!.text = String(format: "%.4f",totaldailyarr.objectAtIndex(0) as! Double)
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                }else if(indexPath.row == 2){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "ENERGY ANNUAL SCOPE 1 CARBON EMISSIONS (MTCO2e)"
                    cell.detailTextLabel!.text = String(format: "%.4f",scope1annumarr.objectAtIndex(0) as! Double)
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                }else if(indexPath.row == 3){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "ENERGY DAILY SCOPE 1 CARBON EMISSIONS (MTCO2e)"
                    cell.detailTextLabel!.text = String(format: "%.4f",scope1dailyarr.objectAtIndex(0) as! Double)
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                }else if(indexPath.row == 4){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "ENERGY ANNUAL SCOPE 2 CARBON EMISSIONS (MTCO2e)"
                    cell.detailTextLabel!.text = String(format: "%.4f",scope2annumarr.objectAtIndex(0) as! Double)
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                }else if(indexPath.row == 5){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "ENERGY DAILY SCOPE 2 CARBON EMISSIONS (MTCO2e)"
                    cell.detailTextLabel!.text = String(format: "%.4f",scope2dailyarr.objectAtIndex(0) as! Double)
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                }else if(indexPath.row == 6){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "TRANSPORTATION ANNUAL CARBON EMISSIONS (MTCO2e)"
                    cell.detailTextLabel!.text = String(format: "%.4f",transitannumarr.objectAtIndex(0) as! Double)
                    cell.clipsToBounds = true
                    return cell
                }else if(indexPath.row == 7){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "TRANSPORTATION DAILY CARBON EMISSIONS (MTCO2e)"
                    cell.detailTextLabel!.text = String(format: "%.4f",transitdailyarr.objectAtIndex(0) as! Double)
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                }else if(indexPath.row == 8){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "TOTAL ANNUAL CARBON EMISSIONS (MTCO2e) - PER SQ FT"
                    cell.detailTextLabel!.text = String(format: "%.4f",totalannumarr.objectAtIndex(1) as! Double)
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                }else if(indexPath.row == 9){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "TOTAL DAILY CARBON EMISSIONS (MTCO2e) - PER SQ FT"
                    cell.detailTextLabel!.text = String(format: "%.4f",totaldailyarr.objectAtIndex(1) as! Double)
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                }else if(indexPath.row == 10){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "ENERGY ANNUAL SCOPE 1 CARBON EMISSIONS (MTCO2e) - PER SQ FT"
                    cell.detailTextLabel!.text = String(format: "%.4f",scope1annumarr.objectAtIndex(1) as! Double)
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                }else if(indexPath.row == 11){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "ENERGY DAILY SCOPE 1 CARBON EMISSIONS (MTCO2e) - PER SQ FT"
                    cell.detailTextLabel!.text = String(format: "%.4f",scope1dailyarr.objectAtIndex(1) as! Double)
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                }else if(indexPath.row == 12){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "ENERGY ANNUAL SCOPE 2 CARBON EMISSIONS (MTCO2e) - PER SQ FT"
                    cell.detailTextLabel!.text = String(format: "%.4f",scope2annumarr.objectAtIndex(1) as! Double)
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                }else if(indexPath.row == 13){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "ENERGY DAILY SCOPE 2 CARBON EMISSIONS (MTCO2e) - PER SQ FT"
                    cell.detailTextLabel!.text = String(format: "%.4f",scope2dailyarr.objectAtIndex(1) as! Double)
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                }else if(indexPath.row == 14){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "TRANSPORTATION ANNUAL CARBON EMISSIONS (MTCO2e) - PER SQ FT"
                    cell.detailTextLabel!.text = "-"//String(format: "%.4f",transitannumarr.objectAtIndex(1) as! Double)
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                }else if(indexPath.row == 15){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "TRANSPORTATION DAILY CARBON EMISSIONS (MTCO2e) - PER SQ FT"
                    cell.detailTextLabel!.text = "-"//String(format: "%.4f",transitdailyarr.objectAtIndex(1) as! Double)
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                }else if(indexPath.row == 16){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "TOTAL ANNUAL CARBON EMISSIONS (MTCO2e) - PER OCC"
                    cell.detailTextLabel!.text = String(format: "%.4f",totalannumarr.objectAtIndex(2) as! Double)
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                }else if(indexPath.row == 17){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "TOTAL DAILY CARBON EMISSIONS (MTCO2e) - PER OCC"
                    cell.detailTextLabel!.text = String(format: "%.4f",totaldailyarr.objectAtIndex(2) as! Double)
                    
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                }else if(indexPath.row == 18){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "ENERGY ANNUAL SCOPE 1 CARBON EMISSIONS (MTCO2e) - PER OCC"
                    cell.detailTextLabel!.text = String(format: "%.4f",scope1annumarr.objectAtIndex(2) as! Double)
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                }else if(indexPath.row == 19){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "ENERGY DAILY SCOPE 1 CARBON EMISSIONS (MTCO2e) PER OCC"
                    cell.detailTextLabel!.text = String(format: "%.4f",scope1dailyarr.objectAtIndex(2) as! Double)
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                }else if(indexPath.row == 20){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "ENERGY ANNUAL SCOPE 2 CARBON EMISSIONS (MTCO2e) - PER OCC"
                    cell.detailTextLabel!.text = String(format: "%.4f",scope2annumarr.objectAtIndex(2) as! Double)
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                }else if(indexPath.row == 21){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "ENERGY DAILY SCOPE 2 CARBON EMISSIONS (MTCO2e) - PER OCC"
                    cell.detailTextLabel!.text = String(format: "%.4f",scope2dailyarr.objectAtIndex(2) as! Double)
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                }else if(indexPath.row == 22){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "TRANSPORTATION ANNUAL CARBON EMISSIONS (MTCO2e) - PER OCC"
                    cell.detailTextLabel!.text = String(format: "%.4f",transitannumarr.objectAtIndex(2) as! Double)
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                }else if(indexPath.row == 23){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "TRANSPORTATION DAILY CARBON EMISSIONS (MTCO2e) - PER OCC"
                    cell.detailTextLabel!.text = String(format: "%.4f",transitdailyarr.objectAtIndex(2) as! Double)
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                }
            }
            else if(indexPath.section == 3){
                if(indexPath.row == 0){
                let cell = tableView.dequeueReusableCellWithIdentifier("row1", forIndexPath:  indexPath) as! row1
                var data = [Int]()
                //graphview.layer.cornerRadius = 10
                //graphview.layer.masksToBounds = true
                let type = "energy"
                
                let dateFormatter: NSDateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let tempArray: NSMutableArray = NSMutableArray()
                for i in 0..<reportedscores.count{
                    let dic: NSMutableDictionary = reportedscores[i].mutableCopy() as! NSMutableDictionary
                    //print(dic)
                    if(dic["effective_at"] is String){
                        //print("String",dic["effective_at"])
                    }else{
                        //print("date")
                    }
                    if(dic["effective_at"] != nil){
                        let dateConverted: NSDate = dateFormatter.dateFromString(dic["effective_at"] as! String)!
                        dic["effective_at"] = dateConverted
                        tempArray.addObject(dic)
                    }else{
                        dic["effective_at"] = NSDate()
                        tempArray.addObject(dic)
                    }
                }
                
                let descriptor: NSSortDescriptor = NSSortDescriptor(key: "effective_at", ascending: true)
                let descriptors: NSArray = [descriptor]
                var sortedArray = NSArray()
                sortedArray = tempArray.sortedArrayUsingDescriptors(descriptors as! [NSSortDescriptor])
                NSLog("%@", sortedArray)
                let tempreportedscores = sortedArray.mutableCopy() as! NSMutableArray

                
                for dict in tempreportedscores{
                    //print(dict["scores"])
                    if let scores = dict["scores"] as? [String:AnyObject] {
                        // action is not nil, is a String type, and is now stored in actionString
                        if(scores[type] is NSNull || scores[type] == nil){
                            data.append(0)
                        }else{
                            data.append(scores[type] as! Int)
                        }
                    } else {
                        data.append(0)
                        // action was either nil, or not a String type
                    }
                    
                }
                var num = 0
                if(data.count == 0){
                    data = [0,0,0]
                }
                    cell.vv.hidden = true
                    
                    cell.vv.graphPoints = data
                    if(data.count >= 0 && data.count <= 10){
                        num = 10
                    }else{
                        let mod = (data.maxElement()! % 10)
                        if(mod == 0){
                            num = data.maxElement()!
                        }else{
                            num = 10 * ((data.maxElement()!/10)+1)
                        }
                    }
                    cell.maxlbl.text = "\(num as! Int)"
                    //print(num)
                    cell.vv.startColor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
                    cell.vv.endColor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
                    cell.layoutSubviews()
                    cell.setNeedsDisplay()
                    cell.setNeedsLayout()
                    var x = actualgraph()
                    let l1 = UILabel.init(frame: cell.reportingperiod.frame)
                    let l2 = UILabel.init(frame: cell.scoreslbl.frame)
                    let l3 = UILabel.init(frame: cell.yaxis.frame)
                    let l4 = UILabel.init(frame: cell.minlbl.frame)
                    let l5 = UILabel.init(frame: cell.maxlbl.frame)
                    
                    l1.text = "Reporting period"
                    l2.text = "Scores"
                    l3.text = "Last 12 months"
                    l4.text = "0"
                    if(num > 0){
                            l5.text = "\(num as! Int)"
                            }else{
                                l5.text = "10"
                            }
                    
                    l1.font = cell.reportingperiod.font
                    l2.font = cell.scoreslbl.font
                    l3.font = cell.yaxis.font
                    l4.font = cell.minlbl.font
                    l5.font = cell.maxlbl.font
                    
                    l1.textColor = cell.reportingperiod.textColor
                    l2.textColor = cell.scoreslbl.textColor
                    l3.textColor = cell.yaxis.textColor
                    l4.textColor = cell.minlbl.textColor
                    l5.textColor = cell.maxlbl.textColor
                    
                    l1.textAlignment = cell.reportingperiod.textAlignment
                    l2.textAlignment = cell.scoreslbl.textAlignment
                    l3.textAlignment = cell.yaxis.textAlignment
                    l4.textAlignment = cell.minlbl.textAlignment
                    l5.textAlignment = cell.maxlbl.textAlignment
                    
                    x.frame = cell.vv.frame
                    x.layer.cornerRadius = 7
                    x.layer.masksToBounds = true
                    x.addSubview(l1)
                    x.addSubview(l2)
                    x.addSubview(l3)
                    x.addSubview(l4)
                    x.addSubview(l5)
                    
                    if(self.tableview.viewWithTag(50) != nil){
                        self.tableview.viewWithTag(50)?.removeFromSuperview()
                    }
                    x.tag = 50
                    x.graphPoints = data
                    x.startColor = cell.vv.startColor
                    x.endColor = cell.vv.startColor
                    cell.contentView.addSubview(x)
                    cell.clipsToBounds = true
                    cell.clipsToBounds = true
                    return cell
                }else if(indexPath.row == 1){
                    let cell = tableView.dequeueReusableCellWithIdentifier("row3", forIndexPath:  indexPath) as! row3
                    cell.titlee.text = "CARBON CONSUMPTION"
                    cell.lbll1.text = "MTCO2e/occupant"
                    cell.lbll2.text = "MTCO2e/square foot"
                    cell.segctrll.tag = indexPath.section
                    cell.valuee1.tag = 100 + indexPath.section
                    cell.valuee2.tag = 200 + indexPath.section
                    cell.segctrll.addTarget(self, action: #selector(self.segctrlselected(_:)), forControlEvents: UIControlEvents.ValueChanged)
                    cell.valuee1.textColor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
                    cell.valuee2.textColor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
                    cell.valuee3.textColor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
                    cell.valuee4.textColor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
                    cell.segctrll.tintColor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
                    cell.valuee1.text = energyarrscope1.objectAtIndex(0).objectAtIndex(1) as! String
                    cell.valuee2.text = energyarrscope1.objectAtIndex(0).objectAtIndex(0) as! String
                    cell.valuee3.text = energyarrscope2.objectAtIndex(0).objectAtIndex(1) as! String
                    cell.valuee4.text = energyarrscope2.objectAtIndex(0).objectAtIndex(0) as! String
                    cell.clipsToBounds = true
                    return cell
                    
                }else if(indexPath.row == 2){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "ANNUAL ENERGY CONSUMPTION (kBTU)"
                    var temp = energyarr[0] as! NSArray
                    if(temp[0] is Float){
                        cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[0] as! Float) as! Float)
                    }else{
                        cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[0] as! Int) as! Float)
                    }
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                    
                }else if(indexPath.row == 3){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "DAILY ENERGY CONSUMPTION (kBTU)"
                    var temp = energyarr[1] as! NSArray
                    if(temp[0] is Float){
                        cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[0] as! Float) as! Float)
                    }else{
                        cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[0] as! Int) as! Float)
                    }
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                    
                }else if(indexPath.row == 4){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "ANNUAL CARBON EMISSIONS (MTCO2e)"
                    var temp = energyarr[2] as! NSArray
                    if(temp[0] is Float){
                        cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[0] as! Float) as! Float)
                    }else{
                        cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[0] as! Int) as! Float)
                    }
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                    
                }else if(indexPath.row == 5){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "ANNUAL ENERGY CONSUMPTION (kBTU) - PER SQ FT"
                    var temp = energyarr[0] as! NSArray
                    if(temp[1] is Float){
                        cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[1] as! Float) as! Float)
                    }else{
                        cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[1] as! Int) as! Float)
                    }
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                    
                }else if(indexPath.row == 6){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    var temp = energyarr[1] as! NSArray
                    if(temp[1] is Float){
                        cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[1] as! Float) as! Float)
                    }else{
                        cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[1] as! Int) as! Float)
                    }
                    cell.textLabel?.text = "DAILY ENERGY CONSUMPTION (kBTU) - PER SQ FT"
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                    
                }else if(indexPath.row == 7){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "ANNUAL CARBON EMISSIONS (MTCO2e) - PER SQ FT"
                    var temp = energyarr[2] as! NSArray
                    if(temp[1] is Float){
                        cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[1] as! Float) as! Float)
                    }else{
                        cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[1] as! Int) as! Float)
                    }
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                    
                }else if(indexPath.row == 8){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "ANNUAL ENERGY CONSUMPTION (kBTU) - PER OCC"
                    var temp = energyarr[0] as! NSArray
                    if(temp[2] is Float){
                        cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[2] as! Float) as! Float)
                    }else{
                        cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[2] as! Int) as! Float)
                    }
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                    
                }else if(indexPath.row == 9){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "DAILY ENERGY CONSUMPTION (kBTU) - PER OCC"
                    var temp = energyarr[1] as! NSArray
                    if(temp[2] is Float){
                        cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[2] as! Float) as! Float)
                    }else{
                        cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[2] as! Int) as! Float)
                    }
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                    
                }else if(indexPath.row == 10){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "ANNUAL CARBON EMISSIONS (MTCO2e) - PER OCC"
                    var temp = energyarr[2] as! NSArray
                    if(temp[2] is Float){
                        cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[2] as! Float) as! Float)
                    }else{
                        cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[2] as! Int) as! Float)
                    }
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                    
                }

               
            }else if(indexPath.section == 4){
                          if(indexPath.row == 0){
                    let cell = tableView.dequeueReusableCellWithIdentifier("row1", forIndexPath:  indexPath) as! row1
                    var data = [Int]()
                    //graphview.layer.cornerRadius = 10
                    //graphview.layer.masksToBounds = true
                    let type = "water"
                    
                    let dateFormatter: NSDateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    let tempArray: NSMutableArray = NSMutableArray()
                    for i in 0..<reportedscores.count{
                        let dic: NSMutableDictionary = reportedscores[i].mutableCopy() as! NSMutableDictionary
                        //print(dic)
                        if(dic["effective_at"] is String){
                            //print("String",dic["effective_at"])
                        }else{
                            //print("date")
                        }
                        if(dic["effective_at"] != nil){
                            let dateConverted: NSDate = dateFormatter.dateFromString(dic["effective_at"] as! String)!
                            dic["effective_at"] = dateConverted
                            tempArray.addObject(dic)
                        }else{
                            dic["effective_at"] = NSDate()
                            tempArray.addObject(dic)
                        }
                    }
                    
                    let descriptor: NSSortDescriptor = NSSortDescriptor(key: "effective_at", ascending: true)
                    let descriptors: NSArray = [descriptor]
                    var sortedArray = NSArray()
                    sortedArray = tempArray.sortedArrayUsingDescriptors(descriptors as! [NSSortDescriptor])
                    NSLog("%@", sortedArray)
                    let tempreportedscores = sortedArray.mutableCopy() as! NSMutableArray
                    
                    
                    for dict in tempreportedscores{
                        //print(dict["scores"])
                        if let scores = dict["scores"] as? [String:AnyObject] {
                            // action is not nil, is a String type, and is now stored in actionString
                            if(scores[type] is NSNull || scores[type] == nil){
                                data.append(0)
                            }else{
                                data.append(scores[type] as! Int)
                            }
                        } else {
                            data.append(0)
                            // action was either nil, or not a String type
                        }
                        
                    }
                    var num = 0
                    if(data.count == 0){
                        data = [0,0,0]
                    }
                    cell.vv.hidden = true
                    
                    //cell.vv1.graphPoints = data
                    if(data.count >= 0 && data.count <= 10){
                        num = 10
                    }else{
                        let mod = (data.maxElement()! % 10)
                        if(mod == 0){
                            num = data.maxElement()!
                        }else{
                            num = 10 * ((data.maxElement()!/10)+1)
                        }
                    }
                    //cell.maxlbl1.text = "\(num as! Int)"
                    //print(num)
                    cell.vv.startColor = UIColor.init(red: 0.303, green: 0.751, blue: 0.94, alpha: 1)
                    cell.vv.endColor = UIColor.init(red: 0.303, green: 0.751, blue: 0.94, alpha: 1)
                    cell.layoutSubviews()
                    cell.setNeedsDisplay()
                    cell.setNeedsLayout()
                    var x = actualgraph()
                    x.frame = cell.vv.frame
                        x.layer.cornerRadius = 7
                        x.layer.masksToBounds = true
                            let l1 = UILabel.init(frame: cell.reportingperiod.frame)
                            let l2 = UILabel.init(frame: cell.scoreslbl.frame)
                            let l3 = UILabel.init(frame: cell.yaxis.frame)
                            let l4 = UILabel.init(frame: cell.minlbl.frame)
                            let l5 = UILabel.init(frame: cell.maxlbl.frame)
                            
                            l1.text = "Reporting period"
                            l2.text = "Scores"
                            l3.text = "Last 12 months"
                            l4.text = "0"
                            if(num > 0){
                            l5.text = "\(num as! Int)"
                            }else{
                                l5.text = "10"
                            }                            
                            l1.font = cell.reportingperiod.font
                            l2.font = cell.scoreslbl.font
                            l3.font = cell.yaxis.font
                            l4.font = cell.minlbl.font
                            l5.font = cell.maxlbl.font
                            
                            l1.textColor = cell.reportingperiod.textColor
                            l2.textColor = cell.scoreslbl.textColor
                            l3.textColor = cell.yaxis.textColor
                            l4.textColor = cell.minlbl.textColor
                            l5.textColor = cell.maxlbl.textColor
                            
                            l1.textAlignment = cell.reportingperiod.textAlignment
                            l2.textAlignment = cell.scoreslbl.textAlignment
                            l3.textAlignment = cell.yaxis.textAlignment
                            l4.textAlignment = cell.minlbl.textAlignment
                            l5.textAlignment = cell.maxlbl.textAlignment
                            
                            x.frame = cell.vv.frame
                            
                            x.addSubview(l1)
                            x.addSubview(l2)
                            x.addSubview(l3)
                            x.addSubview(l4)
                            x.addSubview(l5)
                    if(self.tableview.viewWithTag(51) != nil){
                        self.tableview.viewWithTag(51)?.removeFromSuperview()
                    }
                    x.tag = 51
                    x.graphPoints = data
                    x.startColor = cell.vv.startColor
                    x.endColor = cell.vv.startColor
                    cell.contentView.addSubview(x)
                    cell.clipsToBounds = true
                    return cell
                          }else if(indexPath.row == 1){
                            let cell = tableView.dequeueReusableCellWithIdentifier("row2", forIndexPath:  indexPath) as! row2
                            cell.title.text = "WATER CONSUMPTION"
                            cell.lbl1.text = "gallons/occupant"
                            cell.lbl2.text = "gallons/square foot"
                            cell.segctrl.tag = indexPath.section
                            cell.value1.tag = 100 + indexPath.section
                            cell.value2.tag = 200 + indexPath.section
                            cell.segctrl.addTarget(self, action: #selector(self.segctrlselected(_:)), forControlEvents: UIControlEvents.ValueChanged)
                            cell.value1.textColor = UIColor.init(red: 0.303, green: 0.751, blue: 0.94, alpha: 1)
                            cell.value2.textColor = UIColor.init(red: 0.303, green: 0.751, blue: 0.94, alpha: 1)
                            cell.segctrl.tintColor = UIColor.init(red: 0.303, green: 0.751, blue: 0.94, alpha: 1)
                            cell.value1.text = waterarray.objectAtIndex(0).objectAtIndex(1) as! String
                            cell.value2.text = waterarray.objectAtIndex(0).objectAtIndex(0) as! String
                            cell.clipsToBounds = true
                    return cell
                            
                          }else if(indexPath.row == 2){
                            let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                            cell.textLabel?.text = "ANNUAL WATER CONSUMPTION (gal)"
                            var temp = waterarr[0] as! NSArray
                            if(temp[0] is Float){
                                cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[0] as! Float) as! Float)
                            }else{
                                cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[0] as! Int) as! Float)
                            }
                            cell.textLabel?.numberOfLines = 2
                            cell.clipsToBounds = true
                    return cell
                            
                          }else if(indexPath.row == 3){
                            let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                            cell.textLabel?.text = "DAILY WATER CONSUMPTION (gal)"
                            var temp = waterarr[1] as! NSArray
                            if(temp[0] is Float){
                                cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[0] as! Float) as! Float)
                            }else{
                                cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[0] as! Int) as! Float)
                            }
                            cell.textLabel?.numberOfLines = 2
                            cell.clipsToBounds = true
                    return cell
                            
                          }else if(indexPath.row == 4){
                            let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                            cell.textLabel?.text = "ANNUAL WATER CONSUMPTION (gal) - PER SQ FT"
                            var temp = waterarr[0] as! NSArray
                            if(temp[1] is Float){
                                cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[1] as! Float) as! Float)
                            }else{
                                cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[1] as! Int) as! Float)
                            }
                            cell.textLabel?.numberOfLines = 2
                            cell.clipsToBounds = true
                    return cell
                            
                          }else if(indexPath.row == 5){
                            let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                            cell.textLabel?.text = "DAILY WATER CONSUMPTION (gal) - PER SQ FT"
                            var temp = waterarr[1] as! NSArray
                            if(temp[1] is Float){
                                cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[1] as! Float) as! Float)
                            }else{
                                cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[1] as! Int) as! Float)
                            }
                            cell.textLabel?.numberOfLines = 2
                            cell.clipsToBounds = true
                    return cell
                            
                          }else if(indexPath.row == 6){
                            let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                            var temp = waterarr[0] as! NSArray
                            if(temp[2] is Float){
                                cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[2] as! Float) as! Float)
                            }else{
                                cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[2] as! Int) as! Float)
                            }
                            cell.textLabel?.text = "ANNUAL WATER CONSUMPTION (gal) - PER OCC"
                            cell.textLabel?.numberOfLines = 2
                            cell.clipsToBounds = true
                    return cell
                            
                          }else if(indexPath.row == 7){
                            let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                            cell.textLabel?.text = "DAILY WATER CONSUMPTION (gal) - PER OCC"
                            var temp = waterarr[1] as! NSArray
                            if(temp[2] is Float){
                            cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[2] as! Float) as! Float)
                            }else{
                            cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[2] as! Int) as! Float)
                            }
                            cell.textLabel?.numberOfLines = 2
                            cell.clipsToBounds = true
                    return cell
                            
                }
                
            }else if(indexPath.section == 5){
                if(indexPath.row == 0){
                    let cell = tableView.dequeueReusableCellWithIdentifier("row1", forIndexPath:  indexPath) as! row1
                    var data = [Int]()
                    //graphview.layer.cornerRadius = 10
                    //graphview.layer.masksToBounds = true
                    let type = "waste"
                    
                    let dateFormatter: NSDateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    let tempArray: NSMutableArray = NSMutableArray()
                    for i in 0..<reportedscores.count{
                        let dic: NSMutableDictionary = reportedscores[i].mutableCopy() as! NSMutableDictionary
                        //print(dic)
                        if(dic["effective_at"] is String){
                            //print("String",dic["effective_at"])
                        }else{
                            //print("date")
                        }
                        if(dic["effective_at"] != nil){
                            let dateConverted: NSDate = dateFormatter.dateFromString(dic["effective_at"] as! String)!
                            dic["effective_at"] = dateConverted
                            tempArray.addObject(dic)
                        }else{
                            dic["effective_at"] = NSDate()
                            tempArray.addObject(dic)
                        }
                    }
                    
                    let descriptor: NSSortDescriptor = NSSortDescriptor(key: "effective_at", ascending: true)
                    let descriptors: NSArray = [descriptor]
                    var sortedArray = NSArray()
                    sortedArray = tempArray.sortedArrayUsingDescriptors(descriptors as! [NSSortDescriptor])
                    NSLog("%@", sortedArray)
                    let tempreportedscores = sortedArray.mutableCopy() as! NSMutableArray
                    
                    
                    for dict in tempreportedscores{
                        //print(dict["scores"])
                        if let scores = dict["scores"] as? [String:AnyObject] {
                            // action is not nil, is a String type, and is now stored in actionString
                            if(scores[type] is NSNull || scores[type] == nil){
                                data.append(0)
                            }else{
                                data.append(scores[type] as! Int)
                            }
                        } else {
                            data.append(0)
                            // action was either nil, or not a String type
                        }
                        
                    }
                    var num = 0
                    if(data.count == 0){
                        data = [0,0,0]
                    }
                    cell.vv.hidden = true
                    
                    //cell.vv2.graphPoints = data
                    if(data.count >= 0 && data.count <= 10){
                        num = 10
                    }else{
                        let mod = (data.maxElement()! % 10)
                        if(mod == 0){
                            num = data.maxElement()!
                        }else{
                            num = 10 * ((data.maxElement()!/10)+1)
                        }
                    }
                    //cell.maxlbl2.text = "\(num as! Int)"
                    //print(num)
                    cell.vv.startColor = UIColor.init(red: 0.461, green: 0.76, blue: 0.629, alpha: 1)
                    cell.vv.endColor = UIColor.init(red: 0.461, green: 0.76, blue: 0.629, alpha: 1)
                    cell.layoutSubviews()
                    var x = actualgraph()
                    let l1 = UILabel.init(frame: cell.reportingperiod.frame)
                    let l2 = UILabel.init(frame: cell.scoreslbl.frame)
                    let l3 = UILabel.init(frame: cell.yaxis.frame)
                    let l4 = UILabel.init(frame: cell.minlbl.frame)
                    let l5 = UILabel.init(frame: cell.maxlbl.frame)
                    
                    l1.text = "Reporting period"
                    l2.text = "Scores"
                    l3.text = "Last 12 months"
                    l4.text = "0"
                    if(num > 0){
                            l5.text = "\(num as! Int)"
                            }else{
                                l5.text = "10"
                            }
                    
                    l1.font = cell.reportingperiod.font
                    l2.font = cell.scoreslbl.font
                    l3.font = cell.yaxis.font
                    l4.font = cell.minlbl.font
                    l5.font = cell.maxlbl.font
                    
                    l1.textColor = cell.reportingperiod.textColor
                    l2.textColor = cell.scoreslbl.textColor
                    l3.textColor = cell.yaxis.textColor
                    l4.textColor = cell.minlbl.textColor
                    l5.textColor = cell.maxlbl.textColor
                    
                    l1.textAlignment = cell.reportingperiod.textAlignment
                    l2.textAlignment = cell.scoreslbl.textAlignment
                    l3.textAlignment = cell.yaxis.textAlignment
                    l4.textAlignment = cell.minlbl.textAlignment
                    l5.textAlignment = cell.maxlbl.textAlignment
                    
                    x.frame = cell.vv.frame
                    x.layer.cornerRadius = 7
                    x.layer.masksToBounds = true
                    x.addSubview(l1)
                    x.addSubview(l2)
                    x.addSubview(l3)
                    x.addSubview(l4)
                    x.addSubview(l5)
                    if(self.tableview.viewWithTag(52) != nil){
                        self.tableview.viewWithTag(52)?.removeFromSuperview()
                    }
                    x.tag = 52
                    x.graphPoints = data
                    x.startColor = cell.vv.startColor
                    x.endColor = cell.vv.startColor
                    cell.contentView.addSubview(x)
                    cell.setNeedsDisplay()
                    cell.setNeedsLayout()
                    cell.clipsToBounds = true
                    return cell
                }else if(indexPath.row == 1){
                    let cell = tableView.dequeueReusableCellWithIdentifier("row2", forIndexPath:  indexPath) as! row2
                    cell.title.text = "WASTE GENERATION/DIVERSION"
                    cell.lbl1.text = "Generated Waste/lbs/occupant"
                    cell.lbl2.text = "Undiverted Waste/lbs/occupant"
                    cell.segctrl.tag = indexPath.section
                    cell.value1.tag = 100 + indexPath.section
                    cell.value2.tag = 200 + indexPath.section
                    cell.value1.textColor = UIColor.init(red: 0.461, green: 0.76, blue: 0.629, alpha: 1)
                    cell.value2.textColor = UIColor.init(red: 0.461, green: 0.76, blue: 0.629, alpha: 1)
                    cell.segctrl.tintColor = UIColor.init(red: 0.461, green: 0.76, blue: 0.629, alpha: 1)
                    cell.segctrl.addTarget(self, action: #selector(self.segctrlselected(_:)), forControlEvents: UIControlEvents.ValueChanged)
                    cell.value1.text = wastearray.objectAtIndex(0).objectAtIndex(1) as! String
                    cell.value2.text = wastearray.objectAtIndex(0).objectAtIndex(0) as! String
                    cell.clipsToBounds = true
                    return cell
                    
                }else if(indexPath.row == 2){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "AVERAGE DAILY WASTE GENERATED (lbs)"
                    var temp = wastearr[0] as! NSArray
                    if(temp[0] is Float){
                        cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[0] as! Float) as! Float)
                    }else{
                        cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[0] as! Int) as! Float)
                    }
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                    
                }else if(indexPath.row == 3){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "AVERAGE DAILY WASTE DIVERTED (lbs)"
                    var temp = wastearr[1] as! NSArray
                    if(temp[0] is Float){
                        cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[0] as! Float) as! Float)
                    }else{
                        cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[0] as! Int) as! Float)
                    }
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                    
                }else if(indexPath.row == 4){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "AVERAGE DAILY WASTE GENERATED (lbs) - PER SQ FT"
                    var temp = wastearr[0] as! NSArray
                    if(temp[1] is Float){
                        cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[1] as! Float) as! Float)
                    }else{
                        cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[1] as! Int) as! Float)
                    }
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                    
                }else if(indexPath.row == 5){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "AVERAGE DAILY WASTE DIVERTED (lbs) - PER SQ FT"
                    var temp = wastearr[1] as! NSArray
                    if(temp[1] is Float){
                        cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[1] as! Float) as! Float)
                    }else{
                        cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[1] as! Int) as! Float)
                    }
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                    
                }else if(indexPath.row == 6){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    var temp = wastearr[0] as! NSArray
                    if(temp[2] is Float){
                        cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[2] as! Float) as! Float)
                    }else{
                        cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[2] as! Int) as! Float)
                    }
                    cell.textLabel?.text = "AVERAGE DAILY WASTE GENERATED (lbs) - PER OCC"
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                    
                }else if(indexPath.row == 7){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "AVERAGE DAILY WASTE DIVERTED (lbs) - PER OCC"
                    var temp = wastearr[1] as! NSArray
                    if(temp[2] is Float){
                        cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[2] as! Float) as! Float)
                    }else{
                        cell.detailTextLabel?.text = String(format:"%.5f",Float(temp[2] as! Int) as! Float)
                    }
                    cell.textLabel?.numberOfLines = 2
                    cell.clipsToBounds = true
                    return cell
                    
                }
                return UITableViewCell()
            }else if(indexPath.section == 6){
                if(indexPath.row == 0){
                    let cell = tableView.dequeueReusableCellWithIdentifier("row1", forIndexPath:  indexPath) as! row1
                    var data = [Int]()
                    //graphview.layer.cornerRadius = 10
                    //graphview.layer.masksToBounds = true
                    let type = "transport"
                    
                    let dateFormatter: NSDateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    let tempArray: NSMutableArray = NSMutableArray()
                    for i in 0..<reportedscores.count{
                        let dic: NSMutableDictionary = reportedscores[i].mutableCopy() as! NSMutableDictionary
                        //print(dic)
                        if(dic["effective_at"] is String){
                            //print("String",dic["effective_at"])
                        }else{
                            //print("date")
                        }
                        if(dic["effective_at"] != nil){
                            let dateConverted: NSDate = dateFormatter.dateFromString(dic["effective_at"] as! String)!
                            dic["effective_at"] = dateConverted
                            tempArray.addObject(dic)
                        }else{
                            dic["effective_at"] = NSDate()
                            tempArray.addObject(dic)
                        }
                    }
                    
                    let descriptor: NSSortDescriptor = NSSortDescriptor(key: "effective_at", ascending: true)
                    let descriptors: NSArray = [descriptor]
                    var sortedArray = NSArray()
                    sortedArray = tempArray.sortedArrayUsingDescriptors(descriptors as! [NSSortDescriptor])
                    NSLog("%@", sortedArray)
                    let tempreportedscores = sortedArray.mutableCopy() as! NSMutableArray
                    
                    
                    for dict in tempreportedscores{
                        //print(dict["scores"])
                        if let scores = dict["scores"] as? [String:AnyObject] {
                            // action is not nil, is a String type, and is now stored in actionString
                            if(scores[type] is NSNull || scores[type] == nil){
                                data.append(0)
                            }else{
                                data.append(scores[type] as! Int)
                            }
                        } else {
                            data.append(0)
                            // action was either nil, or not a String type
                        }
                        
                    }
                    var num = 0
                    if(data.count == 0){
                        data = [0,0,0]
                    }
                    cell.vv.hidden = true
                    //cell.vv3.graphPoints = data
                    if(data.count >= 0 && data.count <= 10){
                        num = 10
                    }else{
                        let mod = (data.maxElement()! % 10)
                        if(mod == 0){
                            num = data.maxElement()!
                        }else{
                            num = 10 * ((data.maxElement()!/10)+1)
                        }
                    }
                    //cell.maxlbl3.text = "\(num as! Int)"
                    //print(num)
                    cell.vv.startColor = UIColor.init(red: 0.572, green: 0.556, blue: 0.505, alpha: 1)
                    cell.vv.endColor = UIColor.init(red: 0.572, green: 0.556, blue: 0.505, alpha: 1)
                    cell.layoutSubviews()
                    cell.setNeedsDisplay()
                    cell.setNeedsLayout()
                    var x = actualgraph()
                    let l1 = UILabel.init(frame: cell.reportingperiod.frame)
                    let l2 = UILabel.init(frame: cell.scoreslbl.frame)
                    let l3 = UILabel.init(frame: cell.yaxis.frame)
                    let l4 = UILabel.init(frame: cell.minlbl.frame)
                    let l5 = UILabel.init(frame: cell.maxlbl.frame)
                    x.layer.cornerRadius = 7
                    x.layer.masksToBounds = true
                    l1.text = "Reporting period"
                    l2.text = "Scores"
                    l3.text = "Last 12 months"
                    l4.text = "0"
                    if(num > 0){
                            l5.text = "\(num as! Int)"
                            }else{
                                l5.text = "10"
                            }
                    
                    l1.font = cell.reportingperiod.font
                    l2.font = cell.scoreslbl.font
                    l3.font = cell.yaxis.font
                    l4.font = cell.minlbl.font
                    l5.font = cell.maxlbl.font
                    
                    l1.textColor = cell.reportingperiod.textColor
                    l2.textColor = cell.scoreslbl.textColor
                    l3.textColor = cell.yaxis.textColor
                    l4.textColor = cell.minlbl.textColor
                    l5.textColor = cell.maxlbl.textColor
                    
                    l1.textAlignment = cell.reportingperiod.textAlignment
                    l2.textAlignment = cell.scoreslbl.textAlignment
                    l3.textAlignment = cell.yaxis.textAlignment
                    l4.textAlignment = cell.minlbl.textAlignment
                    l5.textAlignment = cell.maxlbl.textAlignment
                    
                    x.frame = cell.vv.frame
                    
                    x.addSubview(l1)
                    x.addSubview(l2)
                    x.addSubview(l3)
                    x.addSubview(l4)
                    x.addSubview(l5)
                    if(self.tableview.viewWithTag(53) != nil){
                        self.tableview.viewWithTag(53)?.removeFromSuperview()
                    }
                    x.tag = 53
                    x.graphPoints = data
                    x.startColor = cell.vv.startColor
                    x.endColor = cell.vv.startColor
                    cell.contentView.addSubview(x)
                    cell.clipsToBounds = true
                    return cell
                }else if(indexPath.row == 1){
                    if(boolarr[indexPath.section] == true){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "DAILY CARBON EMISSIONS (MTCO2e)"
                    let arr = self.transitarr as! NSArray
                    cell.textLabel?.numberOfLines = 2
                    let f = Float(arr[0].objectAtIndex(0) as! Int)
                    cell.detailTextLabel?.text = String(format:"%.2f",f)
                    cell.clipsToBounds = true
                    return cell
                    }
                    return UITableViewCell()
                }else if(indexPath.row == 2){
                    if(boolarr[indexPath.section] == true){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "SURVEY RESPONSE RATE"
                    let arr = self.transitarr as! NSArray
                    cell.textLabel?.numberOfLines = 2
                    let f = Float(arr[0].objectAtIndex(1) as! Int)
                    cell.detailTextLabel?.text = String(format:"%.2f%%",f)
                    cell.clipsToBounds = true
                    return cell
                    }
                    return UITableViewCell()
                }else if(indexPath.row == 3){
                    if(boolarr[indexPath.section] == true){
                        let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                        cell.textLabel?.text = "DAILY CARBON EMISSIONS (MTCO2e) - PER OCC "
                        let arr = self.transitarr as! NSArray
                        cell.textLabel?.numberOfLines = 2
                        let f = Float(arr[1].objectAtIndex(0) as! Int)
                        cell.detailTextLabel?.text = String(format:"%.2f",f)
                        cell.clipsToBounds = true
                    return cell
                    }
                    return UITableViewCell()
                }else if(indexPath.row == 4){
                    if(boolarr[indexPath.section] == true){
                        let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                        cell.textLabel?.text = "SURVEY RESPONSE RATE - PER OCC"
                        let arr = self.transitarr as! NSArray
                        cell.textLabel?.numberOfLines = 2
                        cell.detailTextLabel?.text = "-"
                        cell.clipsToBounds = true
                    return cell
                    }
                    
                }
            }else if(indexPath.section == 7){
                if(boolarr[indexPath.section] == true){
                 if(indexPath.row == 0){
                    let cell = tableView.dequeueReusableCellWithIdentifier("row1", forIndexPath:  indexPath) as! row1
                    var data = [Int]()
                    //graphview.layer.cornerRadius = 10
                    //graphview.layer.masksToBounds = true
                    let type = "human_experience"
                    
                    let dateFormatter: NSDateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    let tempArray: NSMutableArray = NSMutableArray()
                    for i in 0..<reportedscores.count{
                        let dic: NSMutableDictionary = reportedscores[i].mutableCopy() as! NSMutableDictionary
                        //print(dic)
                        if(dic["effective_at"] is String){
                            //print("String",dic["effective_at"])
                        }else{
                            //print("date")
                        }
                        if(dic["effective_at"] != nil){
                            let dateConverted: NSDate = dateFormatter.dateFromString(dic["effective_at"] as! String)!
                            dic["effective_at"] = dateConverted
                            tempArray.addObject(dic)
                        }else{
                            dic["effective_at"] = NSDate()
                            tempArray.addObject(dic)
                        }
                    }
                    
                    let descriptor: NSSortDescriptor = NSSortDescriptor(key: "effective_at", ascending: true)
                    let descriptors: NSArray = [descriptor]
                    var sortedArray = NSArray()
                    sortedArray = tempArray.sortedArrayUsingDescriptors(descriptors as! [NSSortDescriptor])
                    NSLog("%@", sortedArray)
                    let tempreportedscores = sortedArray.mutableCopy() as! NSMutableArray
                    
                    
                    for dict in tempreportedscores{
                        //print(dict["scores"])
                        if let scores = dict["scores"] as? [String:AnyObject] {
                            // action is not nil, is a String type, and is now stored in actionString
                            if(scores[type] is NSNull || scores[type] == nil){
                                data.append(0)
                            }else{
                                data.append(scores[type] as! Int)
                            }
                        } else {
                            data.append(0)
                            // action was either nil, or not a String type
                        }
                        
                    }
                    var num = 0
                    if(data.count == 0){
                        data = [0,0,0]
                    }
                    
                    cell.vv.startColor = UIColor.init(red: 0.92, green: 0.609, blue: 0.236, alpha: 1)
                    cell.vv.endColor = UIColor.init(red: 0.92, green: 0.609, blue: 0.236, alpha: 1)
                    
                    //cell.vv4.graphPoints = data
                    if(data.count >= 0 && data.count <= 10){
                        num = 10
                    }else{
                        let mod = (data.maxElement()! % 10)
                        if(mod == 0){
                            num = data.maxElement()!
                        }else{
                            num = 10 * ((data.maxElement()!/10)+1)
                        }
                    }
                    //cell.maxlbl4.text = "\(num as! Int)"
                    //print(num)
                    cell.layoutSubviews()
                    cell.setNeedsDisplay()
                    cell.setNeedsLayout()
                    var x = actualgraph()
                    let l1 = UILabel.init(frame: cell.reportingperiod.frame)
                    let l2 = UILabel.init(frame: cell.scoreslbl.frame)
                    let l3 = UILabel.init(frame: cell.yaxis.frame)
                    let l4 = UILabel.init(frame: cell.minlbl.frame)
                    let l5 = UILabel.init(frame: cell.maxlbl.frame)
                    
                    l1.text = "Reporting period"
                    l2.text = "Scores"
                    l3.text = "Last 12 months"
                    l4.text = "0"
                    if(num > 0){
                            l5.text = "\(num as! Int)"
                            }else{
                                l5.text = "10"
                            }
                    
                    l1.font = cell.reportingperiod.font
                    l2.font = cell.scoreslbl.font
                    l3.font = cell.yaxis.font
                    l4.font = cell.minlbl.font
                    l5.font = cell.maxlbl.font
                    x.layer.cornerRadius = 7
                    x.layer.masksToBounds = true
                    l1.textColor = cell.reportingperiod.textColor
                    l2.textColor = cell.scoreslbl.textColor
                    l3.textColor = cell.yaxis.textColor
                    l4.textColor = cell.minlbl.textColor
                    l5.textColor = cell.maxlbl.textColor
                    
                    l1.textAlignment = cell.reportingperiod.textAlignment
                    l2.textAlignment = cell.scoreslbl.textAlignment
                    l3.textAlignment = cell.yaxis.textAlignment
                    l4.textAlignment = cell.minlbl.textAlignment
                    l5.textAlignment = cell.maxlbl.textAlignment
                    
                    x.frame = cell.vv.frame
                    
                    x.addSubview(l1)
                    x.addSubview(l2)
                    x.addSubview(l3)
                    x.addSubview(l4)
                    x.addSubview(l5)
                    if(self.tableview.viewWithTag(54) != nil){
                        self.tableview.viewWithTag(54)?.removeFromSuperview()
                    }
                    x.tag = 54
                    x.graphPoints = data
                    x.startColor = cell.vv.startColor
                    x.endColor = cell.vv.startColor
                    cell.contentView.addSubview(x)

                    cell.clipsToBounds = true
                    return cell
                 }else if(indexPath.row == 1){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "INTERIOR CARBON DIOXIDE LEVELS (ppm)"
                    let arr = self.humanarr as! NSArray
                    cell.textLabel?.numberOfLines = 2
                    let f = Float(arr[indexPath.row - 1 ].firstObject as! Int)
                    cell.detailTextLabel?.text = String(format:"%.2f",f)
                    cell.textLabel!.numberOfLines = 0;
                    cell.textLabel!.lineBreakMode = .ByWordWrapping
                    cell.clipsToBounds = true
                    return cell
                 }else if(indexPath.row == 2){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "INTERIOR TOTAL VOLATILE ORGANIC COMPOUND LEVELS (ug/m3)"
                    let arr = self.humanarr as! NSArray
                    cell.textLabel?.numberOfLines = 2
                    let f = Float(arr[indexPath.row - 1 ].firstObject as! Int)
                    cell.detailTextLabel?.text = String(format:"%.2f",f)
                    cell.clipsToBounds = true
                    cell.textLabel!.numberOfLines = 0;
                    cell.textLabel!.lineBreakMode = .ByWordWrapping
                    return cell
                 }else if(indexPath.row == 3){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "AVERAGE OCCUPANT SATISFACTION"
                    cell.textLabel?.numberOfLines = 2
                    let arr = self.humanarr as! NSArray
                    let f = Float(arr[indexPath.row - 1].firstObject as! Int)
                    cell.detailTextLabel?.text = String(format:"%.2f",f/100.0)
                    cell.clipsToBounds = true
                    return cell
                 }else if(indexPath.row == 4){
                    let cell = tableView.dequeueReusableCellWithIdentifier("extradetails")! as! extradetails
                    cell.textLabel?.text = "SURVEY RESPONSE RATE"
                    cell.textLabel?.numberOfLines = 2
                    let arr = self.humanarr as! NSArray
                    let f = Float(arr[indexPath.row - 1].firstObject as! Int)
                    cell.detailTextLabel?.text = String(format:"%.2f%%",f)
                    cell.clipsToBounds = true
                    return cell
                    }
                }
                return UITableViewCell()
                    
            }

            
        }
        
        
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
        
        
        cell.clipsToBounds = true
                    return cell

        
    }
    
    func segctrlselected(sender : UISegmentedControl){
        if(sender.tag == 5){
            var cell = tableview.cellForRowAtIndexPath(NSIndexPath.init(forRow: 1, inSection: 5)) as! row2
            cell.value1.text = wastearray.objectAtIndex(sender.selectedSegmentIndex).objectAtIndex(1) as! String
            cell.value2.text = wastearray.objectAtIndex(sender.selectedSegmentIndex).objectAtIndex(0) as! String
        }else if(sender.tag == 4){
            var cell = tableview.cellForRowAtIndexPath(NSIndexPath.init(forRow: 1, inSection: 4)) as! row2
            cell.value1.text = waterarray.objectAtIndex(sender.selectedSegmentIndex).objectAtIndex(1) as! String
            cell.value2.text = waterarray.objectAtIndex(sender.selectedSegmentIndex).objectAtIndex(0) as! String
        }else if(sender.tag == 3){
            var cell = tableview.cellForRowAtIndexPath(NSIndexPath.init(forRow: 1, inSection: 3)) as! row3
            cell.valuee1.text = energyarrscope1.objectAtIndex(sender.selectedSegmentIndex).objectAtIndex(1) as! String
            cell.valuee2.text = energyarrscope1.objectAtIndex(sender.selectedSegmentIndex).objectAtIndex(0) as! String
            cell.valuee3.text = energyarrscope2.objectAtIndex(sender.selectedSegmentIndex).objectAtIndex(1) as! String
            cell.valuee4.text = energyarrscope2.objectAtIndex(sender.selectedSegmentIndex).objectAtIndex(0) as! String
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(section == 3){
            //print("SCoresssss ",scoresarr)
            let vieww = UIView.init(frame: dualsliderview.frame)
            let inset: CGFloat = 10
            var frame = vieww.frame
            
            frame.origin.x += inset
            frame.size.width -= 2 * inset
            vieww.frame = frame
            if(energypercentagedata.count > 0 && energyscoreedata.count > 0){
                
                
                let total: Float = 5
                var typeimg = UIImageView.init(frame: dualsliderimage.frame)
                
                var s1 = UISlider.init(frame: slider1.frame)
                var s2 = UISlider.init(frame: slider2.frame)
                var l1 = UILabel.init(frame: context1.frame)
                var l2 = UILabel.init(frame: context2.frame)
                var l3 = UILabel.init(frame: context3.frame)
                var l4 = UILabel.init(frame: context4.frame)
                
                var global = UILabel.init(frame: dualsliderglobal.frame)
                var local = UILabel.init(frame: dualsliderlowest.frame)
                var outof = UILabel.init(frame: dualslideroutof.frame)
                var typename = UILabel.init(frame: dualslidertitle.frame)
                l1.font = context1.font
                l2.font = context2.font
                l3.font = context3.font
                l4.font = context4.font
                global.font = dualsliderglobal.font
                local.font = dualsliderlowest.font
                outof.font = dualslideroutof.font
                typename.font = dualslidertitle.font
                l1.textAlignment = context1.textAlignment
                l2.textAlignment = context2.textAlignment
                l3.textAlignment = context3.textAlignment
                l4.textAlignment = context4.textAlignment
                global.textAlignment = dualsliderglobal.textAlignment
                local.textAlignment = dualsliderlowest.textAlignment
                outof.textAlignment = dualslideroutof.textAlignment
                typename.textAlignment = dualslidertitle.textAlignment
                l1.tag = 1001
                l2.tag = 1002
                l3.tag = 1003
                l4.tag = 1004
                
                l1.numberOfLines = 3
                l2.numberOfLines = 3
                l3.numberOfLines = 3
                l4.numberOfLines = 3
                global.numberOfLines = dualsliderglobal.numberOfLines
                local.numberOfLines = dualsliderlowest.numberOfLines
                outof.numberOfLines = dualslideroutof.numberOfLines
                typename.numberOfLines = dualslidertitle.numberOfLines
                
                s1.minimumValue = 0.0
                s1.tag = 10
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
                s1.maximumValue = Float(temparr.count-1)
                s2.maximumValue = Float(temparr1.count-1)
                s2.minimumValue = 0.0
                s2.tag = 20
                s1.value = 0.0
                s1.setValue(0.0, animated: true)
                var tempstr = temparr.objectAtIndex(energy1sel).allKeys.first as! String
                var tempvalue = temparr.objectAtIndex(energy1sel).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Energy Plaque Score with", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                l1.text = "If I reduce my emissions by \(tempstr as! String)"
                l2.text = "My new energy score will be \(Int(tempvalue as! NSNumber))"
                tempstr = temparr1.objectAtIndex(energy2sel).allKeys.first as! String
                tempvalue = temparr1.objectAtIndex(energy2sel).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Percent emissions reduction for a plaque score of", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                l3.text = "If I want to increase my score to \(tempstr as! String)"
                l4.text = "I need to reduce my emission by \(Int(tempvalue as! NSNumber))%"
                s2.addTarget(self, action: #selector(self.slider2Changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                s1.addTarget(self, action: #selector(self.slider1Changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                s1.value = Float(energy1sel)
                s1.setValue(Float(energy1sel), animated: true)
                s2.value = Float(energy2sel)
                s2.setValue(Float(energy2sel), animated: true)
                typeimg.image = UIImage.init(named: "ic_lomobile_navitem_energy")
                typename.text = "ENERGY"
                global.text = String(format: "Global avg : %d \nLocal avg : %d", globalavgarr.objectAtIndex(0) as! Int,localavgarr.objectAtIndex(0) as! Int)
                local.text = String(format: "Local avg : %d", localavgarr.objectAtIndex(0) as! Int)
                local.text = String(format: "Highest score : %d \nLowest score : 0", energymax)
                outof.text = "\(energyscore) out of \(energymaxscore)"
                outof.textColor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
                typename.textColor = outof.textColor
                vieww.addSubview(typeimg)
                vieww.addSubview(s1)
                vieww.addSubview(s2)
                vieww.addSubview(l1)
                vieww.addSubview(l2)
                vieww.addSubview(l3)
                vieww.addSubview(l4)
                vieww.addSubview(global)
                vieww.addSubview(local)
                vieww.addSubview(outof)
                vieww.addSubview(typename)
                let innervv = UIView.init(frame: innerview.frame)
                innervv.frame.origin.y = l4.frame.size.height + l4.frame.origin.y
                let lbl = UILabel.init(frame: innerlbl.frame)
                lbl.text = innerlbl.text
                lbl.font = innerlbl.font
                lbl.textAlignment = NSTextAlignment.Right
                let img = UIImageView.init(frame: innerimg.frame)
                if(boolarr[section] == true){
                    img.image = UIImage.init(named: "less_data")
                    lbl.text = "Less details"
                }else{
                    img.image = UIImage.init(named: "more_data")
                    lbl.text = "More details"
                }
                innervv.addSubview(lbl)
                innervv.addSubview(img)
                vieww.addSubview(innervv)
                vieww.backgroundColor = UIColor.whiteColor()
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
                gestureRecognizer.delegate = self
                innervv.tag = section
                innervv.addGestureRecognizer(gestureRecognizer)
                
            }else if((energypercentagedata.count > 0 && energyscoreedata.count == 0) || energypercentagedata.count == 0 && energyscoreedata.count > 0){
                let total: Float = 5
                var typeimg = UIImageView.init(frame: dualsliderimage.frame)
                
                var s1 = UISlider.init(frame: slider1.frame)
                var l1 = UILabel.init(frame: context1.frame)
                var l2 = UILabel.init(frame: context2.frame)
                var global = UILabel.init(frame: dualsliderglobal.frame)
                var local = UILabel.init(frame: dualsliderlowest.frame)
                var outof = UILabel.init(frame: dualslideroutof.frame)
                var typename = UILabel.init(frame: dualslidertitle.frame)
                l1.font = context1.font
                l2.font = context2.font
                global.font = dualsliderglobal.font
                local.font = dualsliderlowest.font
                outof.font = dualslideroutof.font
                typename.font = dualslidertitle.font
                l1.textAlignment = context1.textAlignment
                l2.textAlignment = context2.textAlignment
                global.textAlignment = dualsliderglobal.textAlignment
                local.textAlignment = dualsliderlowest.textAlignment
                outof.textAlignment = dualslideroutof.textAlignment
                typename.textAlignment = dualslidertitle.textAlignment
                l1.numberOfLines = 3
                l2.numberOfLines = 3
                l1.tag = 1001
                l2.tag = 1002
                global.numberOfLines = 3
                local.numberOfLines = 3
                outof.numberOfLines = 3
                typename.numberOfLines = 3
                
                s1.minimumValue = 0.0
                s1.tag = 10
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
                s1.maximumValue = Float(temparr.count-1)
                s1.value = 0.0
                s1.setValue(0.0, animated: true)
                var tempstr = temparr.objectAtIndex(energy1sel).allKeys.first as! String
                var tempvalue = temparr.objectAtIndex(energy1sel).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Energy Plaque Score with", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                l1.text = "If I reduce my emissions by \(tempstr as! String)"
                l2.text = "My new energy score will be \(Int(tempvalue as! NSNumber))"
                s1.addTarget(self, action: #selector(self.slider1Changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                s1.value = Float(energy1sel)
                s1.setValue(Float(energy1sel), animated: true)
                typeimg.image = UIImage.init(named: "ic_lomobile_navitem_energy")
                typename.text = "ENERGY"
                global.text = String(format: "Global avg : %d \nLocal avg : %d", globalavgarr.objectAtIndex(0) as! Int,localavgarr.objectAtIndex(0) as! Int)
                local.text = String(format: "Local avg : %d", localavgarr.objectAtIndex(0) as! Int)
                local.text = String(format: "Highest score : %d \nLowest score : 0", energymax)
                outof.text = "\(energyscore) out of \(energymaxscore)"
                outof.textColor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
                typename.textColor = outof.textColor
                
                vieww.addSubview(typeimg)
                vieww.addSubview(s1)
                vieww.addSubview(l1)
                vieww.addSubview(l2)
                vieww.addSubview(global)
                vieww.addSubview(local)
                vieww.addSubview(outof)
                vieww.addSubview(typename)
                
                let innervv = UIView.init(frame: innerview.frame)
                innervv.frame.origin.y = l2.frame.size.height + l2.frame.origin.y
                let lbl = UILabel.init(frame: innerlbl.frame)
                lbl.text = innerlbl.text
                lbl.font = innerlbl.font
                lbl.textAlignment = NSTextAlignment.Right
                let img = UIImageView.init(frame: innerimg.frame)
                if(boolarr[section] == true){
                    img.image = UIImage.init(named: "less_data")
                    lbl.text = "Less details"
                }else{
                    img.image = UIImage.init(named: "more_data")
                    lbl.text = "More details"
                }
                innervv.addSubview(lbl)
                innervv.addSubview(img)
                vieww.addSubview(innervv)
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
                gestureRecognizer.delegate = self
                innervv.tag = section
                innervv.addGestureRecognizer(gestureRecognizer)
                
                
            }else{
                let total: Float = 5
                var typeimg = UIImageView.init(frame: dualsliderimage.frame)
                var global = UILabel.init(frame: dualsliderglobal.frame)
                var local = UILabel.init(frame: dualsliderlowest.frame)
                var outof = UILabel.init(frame: dualslideroutof.frame)
                var typename = UILabel.init(frame: dualslidertitle.frame)
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
                typeimg.image = UIImage.init(named: "ic_lomobile_navitem_energy")
                typename.text = "ENERGY"
                global.text = String(format: "Global avg : %d \nLocal avg : %d", globalavgarr.objectAtIndex(0) as! Int,localavgarr.objectAtIndex(0) as! Int)
                local.text = String(format: "Local avg : %d", localavgarr.objectAtIndex(0) as! Int)
                local.text = String(format: "Highest score : %d \nLowest score : 0", energymax)
                outof.text = "\(energyscore) out of \(energymaxscore)"
                outof.textColor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
                typename.textColor = outof.textColor
                global.font = dualsliderglobal.font
                local.font = dualsliderlowest.font
                outof.font = dualslideroutof.font
                typename.font = dualslidertitle.font
                global.textAlignment = dualsliderglobal.textAlignment
                local.textAlignment = dualsliderlowest.textAlignment
                outof.textAlignment = dualslideroutof.textAlignment
                typename.textAlignment = dualslidertitle.textAlignment
                global.numberOfLines = 3
                local.numberOfLines = 3
                outof.numberOfLines = 3
                typename.numberOfLines = 3
                
                vieww.addSubview(typeimg)
                vieww.addSubview(global)
                vieww.addSubview(local)
                vieww.addSubview(outof)
                vieww.addSubview(typename)
                
                let innervv = UIView.init(frame: innerview.frame)
                innervv.frame.origin.y = decorview.frame.size.height + decorview.frame.origin.y
                let lbl = UILabel.init(frame: innerlbl.frame)
                lbl.text = innerlbl.text
                lbl.font = innerlbl.font
                lbl.textAlignment = NSTextAlignment.Right
                let img = UIImageView.init(frame: innerimg.frame)
                if(boolarr[section] == true){
                    img.image = UIImage.init(named: "less_data")
                    lbl.text = "Less details"
                }else{
                    img.image = UIImage.init(named: "more_data")
                    lbl.text = "More details"
                }
                innervv.addSubview(lbl)
                innervv.addSubview(img)
                vieww.addSubview(innervv)
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
                gestureRecognizer.delegate = self
                innervv.tag = section
                innervv.addGestureRecognizer(gestureRecognizer)
            }
            vieww.backgroundColor = UIColor.whiteColor()
            let v = circularprogress.init(frame: vv.frame)
            v.current = Double(energyscore)
            v.max = Double(energymaxscore)
            v.strokecolor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
            v.setupProperties()
            v.removeAllAnimations()
            v.addUntitled1Animation()
            if(self.view.viewWithTag(40) != nil){
                self.view.viewWithTag(40)?.removeFromSuperview()
            }
            v.tag = 40
            vieww.addSubview(v)
            let decorvv = UIView.init(frame: decorview.frame)
            //decorvv.backgroundColor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
            
            let globalimage = UIImageView.init(frame: globalimg.frame)
            globalimage.image = globalimg.image
            decorvv.addSubview(globalimage)
            
            let localimage = UIImageView.init(frame: localimg.frame)
            localimage.image = localimg.image
            decorvv.addSubview(localimage)
            
            let globalscore = UILabel.init(frame: globalvalue.frame)
            var actualstring = NSMutableAttributedString()
            var tempostring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString(string:"\(globalavgarr.objectAtIndex(0) as! Int)")
            tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 17)! , range: NSMakeRange(0, tempostring.length))
            tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, tempostring.length))
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:"/\(energymaxscore as! Int)")
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            //print(actualstring)
            globalscore.font = UIFont.init(name: "OpenSans", size: 17)
            globalscore.attributedText = actualstring
            globalscore.textAlignment = NSTextAlignment.Center
            //globalscore.textColor = UIColor.whiteColor()
            decorvv.addSubview(globalscore)
            
            let localscore = UILabel.init(frame: localvalue.frame)
            actualstring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString(string:"\(localavgarr.objectAtIndex(0) as! Int)")
            tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 17)! , range: NSMakeRange(0, tempostring.length))
            tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, tempostring.length))
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:"/\(energymaxscore as! Int)")
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            //print(actualstring)
            localscore.font = UIFont.init(name: "OpenSans", size: 17)
            localscore.attributedText = actualstring
            //localscore.textColor = UIColor.whiteColor()
            localscore.textAlignment = NSTextAlignment.Center
            decorvv.addSubview(localscore)
            
            let avgscore = UILabel.init(frame: avgvalue.frame)
            avgscore.text = avgvalue.text
            avgscore.font = avgvalue.font
            var sum = 0
            for item in scoresarr{
                var dict = item as! NSDictionary
                if(dict["energy"] is NSNull || dict["energy"] == nil){
                    
                }else{
                    sum = sum + (dict["energy"] as! Int)
                }
            }
            actualstring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString(string:"\(sum/12 as! Int)")
            tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 17)! , range: NSMakeRange(0, tempostring.length))
            tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, tempostring.length))
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:"/\(energymaxscore as! Int)")
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            //print(actualstring)
            avgscore.font = UIFont.init(name: "OpenSans", size: 17)
            avgscore.attributedText = actualstring
            
            
            
            //avgscore.textColor = UIColor.whiteColor()
            avgscore.textAlignment = NSTextAlignment.Center
            
            let avgvv = UIView.init(frame: avgview.frame)
            avgvv.backgroundColor = UIColor.whiteColor()
            avgvv.layer.cornerRadius = avgvv.frame.size.height/2
            let lbll = UILabel.init(frame: avglbl.frame)
            lbll.text = avglbl.titleLabel?.text
            lbll.alpha = avglbl.alpha
            lbll.font = avglbl.titleLabel?.font
            lbll.textAlignment = NSTextAlignment.Center
            avgvv.addSubview(lbll)
            let avgimage = UIImageView.init(frame: avgimg.frame)
            avgimage.image = avgimg.image
            avgimage.alpha = avgimg.alpha
            avgvv.alpha = avgview.alpha
            avgvv.addSubview(avgimage)
            decorvv.addSubview(avgvv)
            decorvv.addSubview(avgscore)
            decorvv.layer.cornerRadius = 7
            let highest = UILabel.init(frame: highestscore.frame)
            actualstring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString(string:"\(energymax as! Int)")
            tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 17)! , range: NSMakeRange(0, tempostring.length))
            tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, tempostring.length))
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:"/\(energymaxscore as! Int)")
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            //print(actualstring)
            highest.font = UIFont.init(name: "OpenSans", size: 17)
            highest.attributedText = actualstring
            highest.textAlignment = highestscore.textAlignment
            
            let lowestimage = UIImageView.init(frame: lowestscoreimg.frame)
            lowestimage.image = lowestscoreimg.image
            let highestimage = UIImageView.init(frame: highestscoreimg.frame)
            highestimage.image = highestscoreimg.image
            let lowestlbl = UILabel.init(frame: lowestscorelbl.frame)
            lowestlbl.text = lowestscorelbl.text
            lowestlbl.numberOfLines = lowestscorelbl.numberOfLines
            lowestlbl.font = lowestscorelbl.font
            lowestlbl.textAlignment = lowestscorelbl.textAlignment
            let highestlbl = UILabel.init(frame: highestscorelbl.frame)
            highestlbl.text = highestscorelbl.text
            highestlbl.numberOfLines = highestscorelbl.numberOfLines
            highestlbl.font = highestscorelbl.font
            highestlbl.textAlignment = highestscorelbl.textAlignment
            
            vieww.addSubview(lowestimage)
            vieww.addSubview(highestimage)
            vieww.addSubview(lowestlbl)
            vieww.addSubview(highestlbl)
            
            let lowest = UILabel.init(frame: lowestscore.frame)
            actualstring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString(string:"0")
            tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 17)! , range: NSMakeRange(0, tempostring.length))
            tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, tempostring.length))
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:"/\(energymaxscore as! Int)")
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            //print(actualstring)
            lowest.font = UIFont.init(name: "OpenSans", size: 17)
            lowest.attributedText = actualstring
            lowest.textAlignment = lowestscore.textAlignment
            vieww.addSubview(highest)
            vieww.addSubview(lowest)
            vieww.addSubview(decorvv)
            
            return vieww
        }else if(section == 4){
            let vieww = UIView.init(frame: dualsliderview.frame)
            let inset: CGFloat = 10
            var frame = vieww.frame
            frame.origin.x += inset
            frame.size.width -= 2 * inset
            vieww.frame = frame
            
            if(waterpercentagedata.count > 0 && waterscoreedata.count > 0){
                
                
                let total: Float = 5
                var typeimg = UIImageView.init(frame: dualsliderimage.frame)
                
                var s1 = UISlider.init(frame: slider1.frame)
                var s2 = UISlider.init(frame: slider2.frame)
                var l1 = UILabel.init(frame: context1.frame)
                var l2 = UILabel.init(frame: context2.frame)
                var l3 = UILabel.init(frame: context3.frame)
                var l4 = UILabel.init(frame: context4.frame)
                
                var global = UILabel.init(frame: dualsliderglobal.frame)
                var local = UILabel.init(frame: dualsliderlowest.frame)
                var outof = UILabel.init(frame: dualslideroutof.frame)
                var typename = UILabel.init(frame: dualslidertitle.frame)
                l1.font = context1.font
                l2.font = context2.font
                l3.font = context3.font
                l4.font = context4.font
                global.font = dualsliderglobal.font
                local.font = dualsliderlowest.font
                outof.font = dualslideroutof.font
                typename.font = dualslidertitle.font
                l1.textAlignment = context1.textAlignment
                l2.textAlignment = context2.textAlignment
                l3.textAlignment = context3.textAlignment
                l4.textAlignment = context4.textAlignment
                global.textAlignment = dualsliderglobal.textAlignment
                local.textAlignment = dualsliderlowest.textAlignment
                outof.textAlignment = dualslideroutof.textAlignment
                typename.textAlignment = dualslidertitle.textAlignment
                l1.tag = 2001
                l2.tag = 2002
                l3.tag = 2003
                l4.tag = 2004
                
                l1.numberOfLines = 3
                l2.numberOfLines = 3
                l3.numberOfLines = 3
                l4.numberOfLines = 3
                global.numberOfLines = dualsliderglobal.numberOfLines
                local.numberOfLines = dualsliderlowest.numberOfLines
                outof.numberOfLines = dualslideroutof.numberOfLines
                typename.numberOfLines = dualslidertitle.numberOfLines
                
                s1.minimumValue = 0.0
                s1.tag = 11
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
                s1.maximumValue = Float(temparr.count-1)
                s2.maximumValue = Float(temparr1.count-1)
                s2.minimumValue = 0.0
                s2.tag = 21
                s1.value = 0.0
                s1.setValue(0.0, animated: true)
                var tempstr = temparr.objectAtIndex(water1sel).allKeys.first as! String
                var tempvalue = temparr.objectAtIndex(water1sel).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Water Plaque Score with", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("WaterPlaqueScorewith", withString: "")
                l1.text = "If I reduce my emissions by \(tempstr as! String)"
                l2.text = "My new water score will be \(Int(tempvalue as! NSNumber))"
                tempstr = temparr1.objectAtIndex(water2sel).allKeys.first as! String
                tempvalue = temparr1.objectAtIndex(water2sel).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Percent emissions reduction for a plaque score of", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                l3.text = "If I want to increase my score to \(tempstr as! String)"
                l4.text = "I need to reduce my emission by \(Int(tempvalue as! NSNumber))%"
                s2.addTarget(self, action: #selector(self.slider2Changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                s1.addTarget(self, action: #selector(self.slider1Changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                s1.value = Float(water1sel)
                s1.setValue(Float(water1sel), animated: true)
                s2.value = Float(water2sel)
                s2.setValue(Float(water2sel), animated: true)
                typeimg.image = UIImage.init(named: "ic_lomobile_navitem_water")
                typename.text = "WATER"
                global.text = String(format: "Global avg : %d \nLocal avg : %d", globalavgarr.objectAtIndex(1) as! Int,localavgarr.objectAtIndex(1) as! Int)
                local.text = String(format: "Local avg : %d", localavgarr.objectAtIndex(0) as! Int)
                local.text = String(format: "Highest score : %d \nLowest score : 0", watermax)
                outof.text = "\(waterscore) out of \(watermaxscore)"
                outof.textColor = UIColor.init(red: 0.303, green: 0.751, blue: 0.94, alpha: 1)
                typename.textColor = outof.textColor
                vieww.addSubview(typeimg)
                vieww.addSubview(s1)
                vieww.addSubview(s2)
                vieww.addSubview(l1)
                vieww.addSubview(l2)
                vieww.addSubview(l3)
                vieww.addSubview(l4)
                vieww.addSubview(global)
                vieww.addSubview(local)
                vieww.addSubview(outof)
                vieww.addSubview(typename)
                let innervv = UIView.init(frame: innerview.frame)
                innervv.frame.origin.y = l4.frame.size.height + l4.frame.origin.y
                let lbl = UILabel.init(frame: innerlbl.frame)
                lbl.text = innerlbl.text
                lbl.font = innerlbl.font
                lbl.textAlignment = NSTextAlignment.Right
                let img = UIImageView.init(frame: innerimg.frame)
                if(boolarr[section] == true){
                    img.image = UIImage.init(named: "less_data")
                    lbl.text = "Less details"
                }else{
                    img.image = UIImage.init(named: "more_data")
                    lbl.text = "More details"
                }
                innervv.addSubview(lbl)
                innervv.addSubview(img)
                vieww.addSubview(innervv)
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
                gestureRecognizer.delegate = self
                innervv.tag = section
                innervv.addGestureRecognizer(gestureRecognizer)
                
            }else if((waterpercentagedata.count > 0 && waterscoreedata.count == 0) || waterpercentagedata.count == 0 && waterscoreedata.count > 0){
                let total: Float = 5
                var typeimg = UIImageView.init(frame: dualsliderimage.frame)
                
                var s1 = UISlider.init(frame: slider1.frame)
                var l1 = UILabel.init(frame: context1.frame)
                var l2 = UILabel.init(frame: context2.frame)
                var global = UILabel.init(frame: dualsliderglobal.frame)
                var local = UILabel.init(frame: dualsliderlowest.frame)
                var outof = UILabel.init(frame: dualslideroutof.frame)
                var typename = UILabel.init(frame: dualslidertitle.frame)
                l1.font = context1.font
                l2.font = context2.font
                global.font = dualsliderglobal.font
                local.font = dualsliderlowest.font
                outof.font = dualslideroutof.font
                typename.font = dualslidertitle.font
                l1.textAlignment = context1.textAlignment
                l2.textAlignment = context2.textAlignment
                global.textAlignment = dualsliderglobal.textAlignment
                local.textAlignment = dualsliderlowest.textAlignment
                outof.textAlignment = dualslideroutof.textAlignment
                typename.textAlignment = dualslidertitle.textAlignment
                l1.numberOfLines = 3
                l2.numberOfLines = 3
                l1.tag = 2001
                l2.tag = 2002
                global.numberOfLines = 3
                local.numberOfLines = 3
                outof.numberOfLines = 3
                typename.numberOfLines = 3
                
                s1.minimumValue = 0.0
                s1.tag = 11
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
                s1.maximumValue = Float(temparr.count-1)
                s1.value = 0.0
                s1.setValue(0.0, animated: true)
                var tempstr = temparr.objectAtIndex(water1sel).allKeys.first as! String
                var tempvalue = temparr.objectAtIndex(water1sel).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("water Plaque Score with", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("WaterPlaqueScorewith", withString: "")
                
                l1.text = "If I reduce my emissions by \(tempstr as! String)"
                l2.text = "My new water score will be \(Int(tempvalue as! NSNumber))"
                s1.addTarget(self, action: #selector(self.slider1Changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                s1.value = Float(water1sel)
                s1.setValue(Float(water1sel), animated: true)
                typeimg.image = UIImage.init(named: "ic_lomobile_navitem_water")
                typename.text = "WATER"
                global.text = String(format: "Global avg : %d \nLocal avg : %d", globalavgarr.objectAtIndex(1) as! Int,localavgarr.objectAtIndex(1) as! Int)
                local.text = String(format: "Local avg : %d", localavgarr.objectAtIndex(0) as! Int)
                local.text = String(format: "Highest score : %d \nLowest score : 0", watermax)
                outof.text = "\(waterscore) out of \(watermaxscore)"
                outof.textColor = UIColor.init(red: 0.303, green: 0.751, blue: 0.94, alpha: 1)
                typename.textColor = outof.textColor
                vieww.addSubview(typeimg)
                vieww.addSubview(s1)
                vieww.addSubview(l1)
                vieww.addSubview(l2)
                vieww.addSubview(global)
                vieww.addSubview(local)
                vieww.addSubview(outof)
                vieww.addSubview(typename)
                
                let innervv = UIView.init(frame: innerview.frame)
                innervv.frame.origin.y = l2.frame.size.height + l2.frame.origin.y
                let lbl = UILabel.init(frame: innerlbl.frame)
                lbl.text = innerlbl.text
                lbl.font = innerlbl.font
                lbl.textAlignment = NSTextAlignment.Right
                let img = UIImageView.init(frame: innerimg.frame)
                if(boolarr[section] == true){
                    img.image = UIImage.init(named: "less_data")
                    lbl.text = "Less details"
                }else{
                    img.image = UIImage.init(named: "more_data")
                    lbl.text = "More details"
                }
                innervv.addSubview(lbl)
                innervv.addSubview(img)
                vieww.addSubview(innervv)
                
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
                gestureRecognizer.delegate = self
                innervv.tag = section
                innervv.addGestureRecognizer(gestureRecognizer)
            }else{
                let total: Float = 5
                var typeimg = UIImageView.init(frame: dualsliderimage.frame)
                var global = UILabel.init(frame: dualsliderglobal.frame)
                var local = UILabel.init(frame: dualsliderlowest.frame)
                var outof = UILabel.init(frame: dualslideroutof.frame)
                var typename = UILabel.init(frame: dualslidertitle.frame)
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
                typeimg.image = UIImage.init(named: "ic_lomobile_navitem_water")
                typename.text = "WATER"
                global.text = String(format: "Global avg : %d \nLocal avg : %d", globalavgarr.objectAtIndex(1) as! Int,localavgarr.objectAtIndex(1) as! Int)
                local.text = String(format: "Local avg : %d", localavgarr.objectAtIndex(0) as! Int)
                local.text = String(format: "Highest score : %d \nLowest score : 0", watermax)
                outof.text = "\(waterscore) out of \(watermaxscore)"
                outof.textColor = UIColor.init(red: 0.303, green: 0.751, blue: 0.94, alpha: 1)
                typename.textColor = outof.textColor
                global.font = dualsliderglobal.font
                local.font = dualsliderlowest.font
                outof.font = dualslideroutof.font
                typename.font = dualslidertitle.font
                global.textAlignment = dualsliderglobal.textAlignment
                local.textAlignment = dualsliderlowest.textAlignment
                outof.textAlignment = dualslideroutof.textAlignment
                typename.textAlignment = dualslidertitle.textAlignment
                global.numberOfLines = 3
                local.numberOfLines = 3
                outof.numberOfLines = 3
                typename.numberOfLines = 3
                
                vieww.addSubview(typeimg)
                vieww.addSubview(global)
                vieww.addSubview(local)
                vieww.addSubview(outof)
                vieww.addSubview(typename)
                
                let innervv = UIView.init(frame: innerview.frame)
                innervv.frame.origin.y = decorview.frame.size.height + decorview.frame.origin.y
                let lbl = UILabel.init(frame: innerlbl.frame)
                lbl.text = innerlbl.text
                lbl.font = innerlbl.font
                lbl.textAlignment = NSTextAlignment.Right
                let img = UIImageView.init(frame: innerimg.frame)
                if(boolarr[section] == true){
                    img.image = UIImage.init(named: "less_data")
                    lbl.text = "Less details"
                }else{
                    img.image = UIImage.init(named: "more_data")
                    lbl.text = "More details"
                }
                innervv.addSubview(lbl)
                innervv.addSubview(img)
                vieww.addSubview(innervv)
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
                gestureRecognizer.delegate = self
                innervv.tag = section
                innervv.addGestureRecognizer(gestureRecognizer)
            }
            vieww.backgroundColor = UIColor.whiteColor()
            let v = circularprogress.init(frame: vv.frame)
            v.current = Double(waterscore)
            v.max = Double(watermaxscore)
            v.strokecolor = UIColor.init(red: 0.303, green: 0.751, blue: 0.94, alpha: 1)
            v.setupProperties()
            v.removeAllAnimations()
            v.addUntitled1Animation()
            if(self.view.viewWithTag(41) != nil){
                self.view.viewWithTag(41)?.removeFromSuperview()
            }
            v.tag = 41
            vieww.addSubview(v)
            
            let decorvv = UIView.init(frame: decorview.frame)
            //decorvv.backgroundColor = v.strokecolor
            
            let globalimage = UIImageView.init(frame: globalimg.frame)
            globalimage.image = globalimg.image
            decorvv.addSubview(globalimage)
            
            let localimage = UIImageView.init(frame: localimg.frame)
            localimage.image = localimg.image
            decorvv.addSubview(localimage)
            
            let globalscore = UILabel.init(frame: globalvalue.frame)
            var actualstring = NSMutableAttributedString()
            var tempostring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString(string:"\(globalavgarr.objectAtIndex(1) as! Int)")
            tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 17)! , range: NSMakeRange(0, tempostring.length))
            tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, tempostring.length))
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:"/\(watermaxscore as! Int)")
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            //print(actualstring)
            globalscore.font = UIFont.init(name: "OpenSans", size: 17)
            globalscore.attributedText = actualstring
            globalscore.textAlignment = NSTextAlignment.Center
            //globalscore.textColor = UIColor.whiteColor()
            decorvv.addSubview(globalscore)
            
            let localscore = UILabel.init(frame: localvalue.frame)
            actualstring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString(string:"\(localavgarr.objectAtIndex(1) as! Int)")
            tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 17)! , range: NSMakeRange(0, tempostring.length))
            tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, tempostring.length))
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:"/\(watermaxscore as! Int)")
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            //print(actualstring)
            localscore.font = UIFont.init(name: "OpenSans", size: 17)
            localscore.attributedText = actualstring
            //localscore.textColor = UIColor.whiteColor()
            localscore.textAlignment = NSTextAlignment.Center
            decorvv.addSubview(localscore)
            
            let avgscore = UILabel.init(frame: avgvalue.frame)
            avgscore.text = avgvalue.text
            avgscore.font = avgvalue.font
            var sum = 0
            for item in scoresarr{
                var dict = item as! NSDictionary
                if(dict["water"] is NSNull || dict["water"] == nil){
                    
                }else{
                    sum = sum + (dict["water"] as! Int)
                }
            }
            actualstring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString(string:"\(sum/12 as! Int)")
            tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 17)! , range: NSMakeRange(0, tempostring.length))
            tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, tempostring.length))
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:"/\(watermaxscore as! Int)")
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            //print(actualstring)
            avgscore.font = UIFont.init(name: "OpenSans", size: 17)
            avgscore.attributedText = actualstring
            //avgscore.textColor = UIColor.whiteColor()
            avgscore.textAlignment = NSTextAlignment.Center
            
            
            let avgvv = UIView.init(frame: avgview.frame)
            avgvv.backgroundColor = UIColor.whiteColor()
            avgvv.layer.cornerRadius = avgvv.frame.size.height/2
            let lbll = UILabel.init(frame: avglbl.frame)
            lbll.text = avglbl.titleLabel?.text
            lbll.alpha = avglbl.alpha
            lbll.font = avglbl.titleLabel?.font
            lbll.textAlignment = NSTextAlignment.Center
            avgvv.addSubview(lbll)
            let avgimage = UIImageView.init(frame: avgimg.frame)
            avgimage.image = avgimg.image
            avgimage.alpha = avgimg.alpha
            avgvv.alpha = avgview.alpha
            avgvv.addSubview(avgimage)
            decorvv.addSubview(avgvv)
            decorvv.addSubview(avgscore)
            decorvv.layer.cornerRadius = 7
            vieww.addSubview(decorvv)
            let highest = UILabel.init(frame: highestscore.frame)
            actualstring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString(string:"\(watermax as! Int)")
            tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 17)! , range: NSMakeRange(0, tempostring.length))
            tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, tempostring.length))
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:"/\(watermaxscore as! Int)")
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            //print(actualstring)
            highest.font = UIFont.init(name: "OpenSans", size: 17)
            highest.attributedText = actualstring
            highest.textAlignment = highestscore.textAlignment
            
            let lowestimage = UIImageView.init(frame: lowestscoreimg.frame)
            lowestimage.image = lowestscoreimg.image
            let highestimage = UIImageView.init(frame: highestscoreimg.frame)
            highestimage.image = highestscoreimg.image
            let lowestlbl = UILabel.init(frame: lowestscorelbl.frame)
            lowestlbl.text = lowestscorelbl.text
            lowestlbl.numberOfLines = lowestscorelbl.numberOfLines
            lowestlbl.font = lowestscorelbl.font
            lowestlbl.textAlignment = lowestscorelbl.textAlignment
            let highestlbl = UILabel.init(frame: highestscorelbl.frame)
            highestlbl.text = highestscorelbl.text
            highestlbl.numberOfLines = highestscorelbl.numberOfLines
            highestlbl.font = highestscorelbl.font
            highestlbl.textAlignment = highestscorelbl.textAlignment
            
            vieww.addSubview(lowestimage)
            vieww.addSubview(highestimage)
            vieww.addSubview(lowestlbl)
            vieww.addSubview(highestlbl)
            
            let lowest = UILabel.init(frame: lowestscore.frame)
            actualstring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString(string:"0")
            tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 17)! , range: NSMakeRange(0, tempostring.length))
            tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, tempostring.length))
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:"/\(watermaxscore as! Int)")
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            //print(actualstring)
            lowest.font = UIFont.init(name: "OpenSans", size: 17)
            lowest.attributedText = actualstring
            lowest.textAlignment = lowestscore.textAlignment
            vieww.addSubview(highest)
            vieww.addSubview(lowest)
            return vieww
        }else if(section == 5){
            let vieww = UIView.init(frame: dualsliderview.frame)
            let inset: CGFloat = 10
            var frame = vieww.frame
            frame.origin.x += inset
            frame.size.width -= 2 * inset
            vieww.frame = frame
            
            if(wastepercentagedata.count > 0 && wastescoreedata.count > 0){
                
                
                let total: Float = 5
                var typeimg = UIImageView.init(frame: dualsliderimage.frame)
                
                var s1 = UISlider.init(frame: slider1.frame)
                var s2 = UISlider.init(frame: slider2.frame)
                var l1 = UILabel.init(frame: context1.frame)
                var l2 = UILabel.init(frame: context2.frame)
                var l3 = UILabel.init(frame: context3.frame)
                var l4 = UILabel.init(frame: context4.frame)
                
                var global = UILabel.init(frame: dualsliderglobal.frame)
                var local = UILabel.init(frame: dualsliderlowest.frame)
                var outof = UILabel.init(frame: dualslideroutof.frame)
                var typename = UILabel.init(frame: dualslidertitle.frame)
                l1.font = context1.font
                l2.font = context2.font
                l3.font = context3.font
                l4.font = context4.font
                global.font = dualsliderglobal.font
                local.font = dualsliderlowest.font
                outof.font = dualslideroutof.font
                typename.font = dualslidertitle.font
                l1.textAlignment = context1.textAlignment
                l2.textAlignment = context2.textAlignment
                l3.textAlignment = context3.textAlignment
                l4.textAlignment = context4.textAlignment
                global.textAlignment = dualsliderglobal.textAlignment
                local.textAlignment = dualsliderlowest.textAlignment
                outof.textAlignment = dualslideroutof.textAlignment
                typename.textAlignment = dualslidertitle.textAlignment
                l1.tag = 3001
                l2.tag = 3002
                l3.tag = 3003
                l4.tag = 3004
                
                l1.numberOfLines = 3
                l2.numberOfLines = 3
                l3.numberOfLines = 3
                l4.numberOfLines = 3
                global.numberOfLines = dualsliderglobal.numberOfLines
                local.numberOfLines = dualsliderlowest.numberOfLines
                outof.numberOfLines = dualslideroutof.numberOfLines
                typename.numberOfLines = dualslidertitle.numberOfLines
                
                s1.minimumValue = 0.0
                s1.tag = 12
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
                s1.maximumValue = Float(temparr.count-1)
                s2.maximumValue = Float(temparr1.count-1)
                s2.minimumValue = 0.0
                s2.tag = 22
                s1.value = 0.0
                s1.setValue(0.0, animated: true)
                var tempstr = temparr.objectAtIndex(waste1sel).allKeys.first as! String
                var tempvalue = temparr.objectAtIndex(waste1sel).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("waste Plaque Score with", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("wastePlaqueScorewith", withString: "")
                l1.text = "If I reduce my emissions by \(tempstr as! String)"
                l2.text = "My new waste score will be \(Int(tempvalue as! NSNumber))"
                tempstr = temparr1.objectAtIndex(waste2sel).allKeys.first as! String
                tempvalue = temparr1.objectAtIndex(waste2sel).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Percent emissions reduction for a plaque score of", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                l3.text = "If I want to increase my score to \(tempstr as! String)"
                l4.text = "I need to reduce my emission by \(Int(tempvalue as! NSNumber))%"
                s2.addTarget(self, action: #selector(self.slider2Changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                s1.addTarget(self, action: #selector(self.slider1Changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                s1.value = Float(waste1sel)
                s1.setValue(Float(waste1sel), animated: true)
                s2.value = Float(waste2sel)
                s2.setValue(Float(waste2sel), animated: true)
                typeimg.image = UIImage.init(named: "ic_lomobile_navitem_waste")
                typename.text = "WASTE"
                global.text = String(format: "Global avg : %d \nLocal avg : %d", globalavgarr.objectAtIndex(2) as! Int,localavgarr.objectAtIndex(2) as! Int)
                local.text = String(format: "Local avg : %d", localavgarr.objectAtIndex(0) as! Int)
                local.text = String(format: "Highest score : %d \nLowest score : 0", wastemax)
                outof.text = "\(wastescore) out of \(wastemaxscore)"
                outof.textColor = UIColor.init(red: 0.461, green: 0.76, blue: 0.629, alpha: 1)
                typename.textColor = outof.textColor
                vieww.addSubview(typeimg)
                vieww.addSubview(s1)
                vieww.addSubview(s2)
                vieww.addSubview(l1)
                vieww.addSubview(l2)
                vieww.addSubview(l3)
                vieww.addSubview(l4)
                vieww.addSubview(global)
                vieww.addSubview(local)
                vieww.addSubview(outof)
                vieww.addSubview(typename)
                let innervv = UIView.init(frame: innerview.frame)
                innervv.frame.origin.y = l4.frame.size.height + l4.frame.origin.y
                let lbl = UILabel.init(frame: innerlbl.frame)
                lbl.text = innerlbl.text
                lbl.font = innerlbl.font
                lbl.textAlignment = NSTextAlignment.Right
                let img = UIImageView.init(frame: innerimg.frame)
                if(boolarr[section] == true){
                    img.image = UIImage.init(named: "less_data")
                    lbl.text = "Less details"
                }else{
                    img.image = UIImage.init(named: "more_data")
                    lbl.text = "More details"
                }
                innervv.addSubview(lbl)
                innervv.addSubview(img)
                vieww.addSubview(innervv)
                
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
                gestureRecognizer.delegate = self
                innervv.tag = section
                innervv.addGestureRecognizer(gestureRecognizer)
                
            }else if((wastepercentagedata.count > 0 && wastescoreedata.count == 0) || wastepercentagedata.count == 0 && wastescoreedata.count > 0){
                let total: Float = 5
                var typeimg = UIImageView.init(frame: dualsliderimage.frame)
                
                var s1 = UISlider.init(frame: slider1.frame)
                var l1 = UILabel.init(frame: context1.frame)
                var l2 = UILabel.init(frame: context2.frame)
                var global = UILabel.init(frame: dualsliderglobal.frame)
                var local = UILabel.init(frame: dualsliderlowest.frame)
                var outof = UILabel.init(frame: dualslideroutof.frame)
                var typename = UILabel.init(frame: dualslidertitle.frame)
                l1.font = context1.font
                l2.font = context2.font
                global.font = dualsliderglobal.font
                local.font = dualsliderlowest.font
                outof.font = dualslideroutof.font
                typename.font = dualslidertitle.font
                l1.textAlignment = context1.textAlignment
                l2.textAlignment = context2.textAlignment
                global.textAlignment = dualsliderglobal.textAlignment
                local.textAlignment = dualsliderlowest.textAlignment
                outof.textAlignment = dualslideroutof.textAlignment
                typename.textAlignment = dualslidertitle.textAlignment
                l1.numberOfLines = 3
                l2.numberOfLines = 3
                l1.tag = 3001
                l2.tag = 3002
                global.numberOfLines = 3
                local.numberOfLines = 3
                outof.numberOfLines = 3
                typename.numberOfLines = 3
                
                s1.minimumValue = 0.0
                s1.tag = 12
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
                s1.maximumValue = Float(temparr.count-1)
                s1.value = 0.0
                s1.setValue(0.0, animated: true)
                var tempstr = temparr.objectAtIndex(waste1sel).allKeys.first as! String
                var tempvalue = temparr.objectAtIndex(waste1sel).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("waste Plaque Score with", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("wastePlaqueScorewith", withString: "")
                
                l1.text = "If I reduce my emissions by \(tempstr as! String)"
                l2.text = "My new waste score will be \(Int(tempvalue as! NSNumber))"
                s1.addTarget(self, action: #selector(self.slider1Changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                s1.value = Float(waste1sel)
                s1.setValue(Float(waste1sel), animated: true)
                typeimg.image = UIImage.init(named: "ic_lomobile_navitem_waste")
                typename.text = "WASTE"
                global.text = String(format: "Global avg : %d \nLocal avg : %d", globalavgarr.objectAtIndex(2) as! Int,localavgarr.objectAtIndex(2) as! Int)
                local.text = String(format: "Local avg : %d", localavgarr.objectAtIndex(0) as! Int)
                local.text = String(format: "Highest score : %d \nLowest score : 0", wastemax)
                outof.text = "\(wastescore) out of \(wastemaxscore)"
                outof.textColor = UIColor.init(red: 0.461, green: 0.76, blue: 0.629, alpha: 1)
                typename.textColor = outof.textColor
                vieww.addSubview(typeimg)
                vieww.addSubview(s1)
                vieww.addSubview(l1)
                vieww.addSubview(l2)
                vieww.addSubview(global)
                vieww.addSubview(local)
                vieww.addSubview(outof)
                vieww.addSubview(typename)
                
                let innervv = UIView.init(frame: innerview.frame)
                innervv.frame.origin.y = l2.frame.size.height + l2.frame.origin.y
                let lbl = UILabel.init(frame: innerlbl.frame)
                lbl.text = innerlbl.text
                lbl.font = innerlbl.font
                lbl.textAlignment = NSTextAlignment.Right
                let img = UIImageView.init(frame: innerimg.frame)
                if(boolarr[section] == true){
                    img.image = UIImage.init(named: "less_data")
                    lbl.text = "Less details"
                }else{
                    img.image = UIImage.init(named: "more_data")
                    lbl.text = "More details"
                }
                innervv.addSubview(lbl)
                innervv.addSubview(img)
                vieww.addSubview(innervv)
                
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
                gestureRecognizer.delegate = self
                innervv.tag = section
                innervv.addGestureRecognizer(gestureRecognizer)
            }else{
                let total: Float = 5
                var typeimg = UIImageView.init(frame: dualsliderimage.frame)
                var global = UILabel.init(frame: dualsliderglobal.frame)
                var local = UILabel.init(frame: dualsliderlowest.frame)
                var outof = UILabel.init(frame: dualslideroutof.frame)
                var typename = UILabel.init(frame: dualslidertitle.frame)
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
                typeimg.image = UIImage.init(named: "ic_lomobile_navitem_waste")
                typename.text = "WASTE"
                global.text = String(format: "Global avg : %d \nLocal avg : %d", globalavgarr.objectAtIndex(2) as! Int,localavgarr.objectAtIndex(2) as! Int)
                local.text = String(format: "Local avg : %d", localavgarr.objectAtIndex(0) as! Int)
                local.text = String(format: "Highest score : %d \nLowest score : 0", wastemax)
                outof.text = "\(wastescore) out of \(wastemaxscore)"
                outof.textColor = UIColor.init(red: 0.461, green: 0.76, blue: 0.629, alpha: 1)
                typename.textColor = outof.textColor
                global.font = dualsliderglobal.font
                local.font = dualsliderlowest.font
                outof.font = dualslideroutof.font
                typename.font = dualslidertitle.font
                global.textAlignment = dualsliderglobal.textAlignment
                local.textAlignment = dualsliderlowest.textAlignment
                outof.textAlignment = dualslideroutof.textAlignment
                typename.textAlignment = dualslidertitle.textAlignment
                global.numberOfLines = 3
                local.numberOfLines = 3
                outof.numberOfLines = 3
                typename.numberOfLines = 3
                
                vieww.addSubview(typeimg)
                vieww.addSubview(global)
                vieww.addSubview(local)
                vieww.addSubview(outof)
                vieww.addSubview(typename)
                
                let innervv = UIView.init(frame: innerview.frame)
                innervv.frame.origin.y = decorview.frame.size.height + decorview.frame.origin.y
                let lbl = UILabel.init(frame: innerlbl.frame)
                lbl.text = innerlbl.text
                lbl.font = innerlbl.font
                lbl.textAlignment = NSTextAlignment.Right
                let img = UIImageView.init(frame: innerimg.frame)
                if(boolarr[section] == true){
                    img.image = UIImage.init(named: "less_data")
                    lbl.text = "Less details"
                }else{
                    img.image = UIImage.init(named: "more_data")
                    lbl.text = "More details"
                }
                innervv.addSubview(lbl)
                innervv.addSubview(img)
                vieww.addSubview(innervv)
                
                
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
                gestureRecognizer.delegate = self
                innervv.tag = section
                innervv.addGestureRecognizer(gestureRecognizer)
            }
            vieww.backgroundColor = UIColor.whiteColor()
            let v = circularprogress.init(frame: vv.frame)
            v.current = Double(wastescore)
            v.max = Double(wastemaxscore)
            v.strokecolor = UIColor.init(red: 0.461, green: 0.76, blue: 0.629, alpha: 1)
            v.setupProperties()
            v.removeAllAnimations()
            v.addUntitled1Animation()
            if(self.view.viewWithTag(42) != nil){
                self.view.viewWithTag(42)?.removeFromSuperview()
            }
            v.tag = 42
            vieww.addSubview(v)
            
            let decorvv = UIView.init(frame: decorview.frame)
            //decorvv.backgroundColor = v.strokecolor
            
            let globalimage = UIImageView.init(frame: globalimg.frame)
            globalimage.image = globalimg.image
            decorvv.addSubview(globalimage)
            
            let localimage = UIImageView.init(frame: localimg.frame)
            localimage.image = localimg.image
            decorvv.addSubview(localimage)
            
            let globalscore = UILabel.init(frame: globalvalue.frame)
            var actualstring = NSMutableAttributedString()
            var tempostring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString(string:"\(globalavgarr.objectAtIndex(2) as! Int)")
            tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 17)! , range: NSMakeRange(0, tempostring.length))
            tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, tempostring.length))
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:"/\(wastemaxscore as! Int)")
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            //print(actualstring)
            globalscore.font = UIFont.init(name: "OpenSans", size: 17)
            globalscore.attributedText = actualstring
            globalscore.textAlignment = NSTextAlignment.Center
            //globalscore.textColor = UIColor.whiteColor()
            decorvv.addSubview(globalscore)
            
            let localscore = UILabel.init(frame: localvalue.frame)
            actualstring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString(string:"\(localavgarr.objectAtIndex(2) as! Int)")
            tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 17)! , range: NSMakeRange(0, tempostring.length))
            tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, tempostring.length))
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:"/\(wastemaxscore as! Int)")
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            //print(actualstring)
            localscore.font = UIFont.init(name: "OpenSans", size: 17)
            localscore.attributedText = actualstring
            //localscore.textColor = UIColor.whiteColor()
            localscore.textAlignment = NSTextAlignment.Center
            decorvv.addSubview(localscore)
            
            let avgscore = UILabel.init(frame: avgvalue.frame)
            avgscore.text = avgvalue.text
            avgscore.font = avgvalue.font
            var sum = 0
            for item in scoresarr{
                var dict = item as! NSDictionary
                if(dict["waste"] is NSNull || dict["waste"] == nil){
                    
                }else{
                    sum = sum + (dict["waste"] as! Int)
                }
            }
            actualstring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString(string:"\(sum/12 as! Int)")
            tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 17)! , range: NSMakeRange(0, tempostring.length))
            tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, tempostring.length))
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:"/\(wastemaxscore as! Int)")
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            //print(actualstring)
            avgscore.font = UIFont.init(name: "OpenSans", size: 17)
            avgscore.attributedText = actualstring
            //avgscore.textColor = UIColor.whiteColor()
            avgscore.textAlignment = NSTextAlignment.Center
            
            let avgvv = UIView.init(frame: avgview.frame)
            avgvv.backgroundColor = UIColor.whiteColor()
            avgvv.layer.cornerRadius = avgvv.frame.size.height/2
            let lbll = UILabel.init(frame: avglbl.frame)
            lbll.text = avglbl.titleLabel?.text
            lbll.alpha = avglbl.alpha
            lbll.font = avglbl.titleLabel?.font
            lbll.textAlignment = NSTextAlignment.Center
            avgvv.addSubview(lbll)
            let avgimage = UIImageView.init(frame: avgimg.frame)
            avgimage.image = avgimg.image
            avgimage.alpha = avgimg.alpha
            avgvv.alpha = avgview.alpha
            avgvv.addSubview(avgimage)
            decorvv.addSubview(avgvv)
            decorvv.addSubview(avgscore)
            decorvv.layer.cornerRadius = 7
            vieww.addSubview(decorvv)
            let highest = UILabel.init(frame: highestscore.frame)
            actualstring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString(string:"\(wastemax as! Int)")
            tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 17)! , range: NSMakeRange(0, tempostring.length))
            tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, tempostring.length))
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:"/\(wastemaxscore as! Int)")
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            //print(actualstring)
            highest.font = UIFont.init(name: "OpenSans", size: 17)
            highest.attributedText = actualstring
            highest.textAlignment = highestscore.textAlignment
            
            let lowestimage = UIImageView.init(frame: lowestscoreimg.frame)
            lowestimage.image = lowestscoreimg.image
            let highestimage = UIImageView.init(frame: highestscoreimg.frame)
            highestimage.image = highestscoreimg.image
            let lowestlbl = UILabel.init(frame: lowestscorelbl.frame)
            lowestlbl.text = lowestscorelbl.text
            lowestlbl.numberOfLines = lowestscorelbl.numberOfLines
            lowestlbl.font = lowestscorelbl.font
            lowestlbl.textAlignment = lowestscorelbl.textAlignment
            let highestlbl = UILabel.init(frame: highestscorelbl.frame)
            highestlbl.text = highestscorelbl.text
            highestlbl.numberOfLines = highestscorelbl.numberOfLines
            highestlbl.font = highestscorelbl.font
            highestlbl.textAlignment = highestscorelbl.textAlignment
            
            vieww.addSubview(lowestimage)
            vieww.addSubview(highestimage)
            vieww.addSubview(lowestlbl)
            vieww.addSubview(highestlbl)
            
            let lowest = UILabel.init(frame: lowestscore.frame)
            actualstring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString(string:"0")
            tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 17)! , range: NSMakeRange(0, tempostring.length))
            tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, tempostring.length))
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:"/\(wastemaxscore as! Int)")
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            //print(actualstring)
            lowest.font = UIFont.init(name: "OpenSans", size: 17)
            lowest.attributedText = actualstring
            lowest.textAlignment = lowestscore.textAlignment
            vieww.addSubview(highest)
            vieww.addSubview(lowest)
            return vieww
        } else if(section == 6){
            let vieww = UIView.init(frame: dualsliderview.frame)
            let inset: CGFloat = 10
            var frame = vieww.frame
            frame.origin.x += inset
            frame.size.width -= 2 * inset
            vieww.frame = frame
            
            if(transitpercentagedata.count > 0 && transitscoreedata.count > 0){
                
                
                let total: Float = 5
                var typeimg = UIImageView.init(frame: dualsliderimage.frame)
                
                var s1 = UISlider.init(frame: slider1.frame)
                var s2 = UISlider.init(frame: slider2.frame)
                var l1 = UILabel.init(frame: context1.frame)
                var l2 = UILabel.init(frame: context2.frame)
                var l3 = UILabel.init(frame: context3.frame)
                var l4 = UILabel.init(frame: context4.frame)
                
                var global = UILabel.init(frame: dualsliderglobal.frame)
                var local = UILabel.init(frame: dualsliderlowest.frame)
                var outof = UILabel.init(frame: dualslideroutof.frame)
                var typename = UILabel.init(frame: dualslidertitle.frame)
                l1.font = context1.font
                l2.font = context2.font
                l3.font = context3.font
                l4.font = context4.font
                global.font = dualsliderglobal.font
                local.font = dualsliderlowest.font
                outof.font = dualslideroutof.font
                typename.font = dualslidertitle.font
                l1.textAlignment = context1.textAlignment
                l2.textAlignment = context2.textAlignment
                l3.textAlignment = context3.textAlignment
                l4.textAlignment = context4.textAlignment
                global.textAlignment = dualsliderglobal.textAlignment
                local.textAlignment = dualsliderlowest.textAlignment
                outof.textAlignment = dualslideroutof.textAlignment
                typename.textAlignment = dualslidertitle.textAlignment
                l1.tag = 4001
                l2.tag = 4002
                l3.tag = 4003
                l4.tag = 4004
                
                l1.numberOfLines = 3
                l2.numberOfLines = 3
                l3.numberOfLines = 3
                l4.numberOfLines = 3
                global.numberOfLines = dualsliderglobal.numberOfLines
                local.numberOfLines = dualsliderlowest.numberOfLines
                outof.numberOfLines = dualslideroutof.numberOfLines
                typename.numberOfLines = dualslidertitle.numberOfLines
                
                s1.minimumValue = 0.0
                s1.tag = 13
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
                s1.maximumValue = Float(temparr.count-1)
                s2.maximumValue = Float(temparr1.count-1)
                s2.minimumValue = 0.0
                s2.tag = 23
                s1.value = 0.0
                s1.setValue(0.0, animated: true)
                var tempstr = temparr.objectAtIndex(transit1sel).allKeys.first as! String
                var tempvalue = temparr.objectAtIndex(transit1sel).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("transit Plaque Score with", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("transitPlaqueScorewith", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("TransportationPlaqueScorewith", withString: "")
                l1.text = "If I reduce my emissions by \(tempstr as! String)"
                l2.text = "My new transit score will be \(Int(tempvalue as! NSNumber))"
                tempstr = temparr1.objectAtIndex(transit2sel).allKeys.first as! String
                tempvalue = temparr1.objectAtIndex(transit2sel).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Percent emissions reduction for a plaque score of", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                l3.text = "If I want to increase my score to \(tempstr as! String)"
                l4.text = "I need to reduce my emission by \(Int(tempvalue as! NSNumber))%"
                s2.addTarget(self, action: #selector(self.slider2Changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                s1.addTarget(self, action: #selector(self.slider1Changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                s1.value = Float(transit1sel)
                s1.setValue(Float(transit1sel), animated: true)
                s2.value = Float(transit2sel)
                s2.setValue(Float(transit2sel), animated: true)
                typeimg.image = UIImage.init(named: "ic_lomobile_navitem_transport")
                typename.text = "TRANSPORTATION"
                global.text = String(format: "Global avg : %d \nLocal avg : %d", globalavgarr.objectAtIndex(3) as! Int,localavgarr.objectAtIndex(3) as! Int)
                local.text = String(format: "Local avg : %d", localavgarr.objectAtIndex(0) as! Int)
                local.text = String(format: "Highest score : %d \nLowest score : 0", transportmax)
                outof.text = "\(transportscore) out of \(transportmax)"
                outof.textColor = UIColor.init(red: 0.572, green: 0.556, blue: 0.505, alpha: 1)
                typename.textColor = outof.textColor
                vieww.addSubview(typeimg)
                vieww.addSubview(s1)
                vieww.addSubview(s2)
                vieww.addSubview(l1)
                vieww.addSubview(l2)
                vieww.addSubview(l3)
                vieww.addSubview(l4)
                vieww.addSubview(global)
                vieww.addSubview(local)
                vieww.addSubview(outof)
                vieww.addSubview(typename)
                let innervv = UIView.init(frame: innerview.frame)
                innervv.frame.origin.y = l4.frame.size.height + l4.frame.origin.y
                let lbl = UILabel.init(frame: innerlbl.frame)
                lbl.text = innerlbl.text
                lbl.font = innerlbl.font
                lbl.textAlignment = NSTextAlignment.Right
                let img = UIImageView.init(frame: innerimg.frame)
                if(boolarr[section] == true){
                    img.image = UIImage.init(named: "less_data")
                    lbl.text = "Less details"
                }else{
                    img.image = UIImage.init(named: "more_data")
                    lbl.text = "More details"
                }
                innervv.addSubview(lbl)
                innervv.addSubview(img)
                vieww.addSubview(innervv)
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
                gestureRecognizer.delegate = self
                innervv.tag = section
                innervv.addGestureRecognizer(gestureRecognizer)
            }else if((transitpercentagedata.count > 0 && transitscoreedata.count == 0) || transitpercentagedata.count == 0 && transitscoreedata.count > 0){
                let total: Float = 5
                var typeimg = UIImageView.init(frame: dualsliderimage.frame)
                
                var s1 = UISlider.init(frame: slider1.frame)
                var l1 = UILabel.init(frame: context1.frame)
                var l2 = UILabel.init(frame: context2.frame)
                var global = UILabel.init(frame: dualsliderglobal.frame)
                var local = UILabel.init(frame: dualsliderlowest.frame)
                var outof = UILabel.init(frame: dualslideroutof.frame)
                var typename = UILabel.init(frame: dualslidertitle.frame)
                l1.font = context1.font
                l2.font = context2.font
                global.font = dualsliderglobal.font
                local.font = dualsliderlowest.font
                outof.font = dualslideroutof.font
                typename.font = dualslidertitle.font
                l1.textAlignment = context1.textAlignment
                l2.textAlignment = context2.textAlignment
                global.textAlignment = dualsliderglobal.textAlignment
                local.textAlignment = dualsliderlowest.textAlignment
                outof.textAlignment = dualslideroutof.textAlignment
                typename.textAlignment = dualslidertitle.textAlignment
                l1.numberOfLines = 3
                l2.numberOfLines = 3
                l1.tag = 4001
                l2.tag = 4002
                global.numberOfLines = 3
                local.numberOfLines = 3
                outof.numberOfLines = 3
                typename.numberOfLines = 3
                
                s1.minimumValue = 0.0
                s1.tag = 13
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
                s1.maximumValue = Float(temparr.count-1)
                s1.value = 0.0
                s1.setValue(0.0, animated: true)
                var tempstr = temparr.objectAtIndex(transit1sel).allKeys.first as! String
                var tempvalue = temparr.objectAtIndex(transit1sel).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("transit Plaque Score with", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("transitPlaqueScorewith", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("TransportationPlaqueScorewith", withString: "")
                
                l1.text = "If I reduce my emissions by \(tempstr as! String)"
                l2.text = "My new transit score will be \(Int(tempvalue as! NSNumber))"
                s1.addTarget(self, action: #selector(self.slider1Changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                s1.value = Float(transit1sel)
                s1.setValue(Float(transit1sel), animated: true)
                typeimg.image = UIImage.init(named: "ic_lomobile_navitem_transport")
                typename.text = "TRANSPORTATION"
                global.text = String(format: "Global avg : %d \nLocal avg : %d", globalavgarr.objectAtIndex(3) as! Int,localavgarr.objectAtIndex(3) as! Int)
                local.text = String(format: "Local avg : %d", localavgarr.objectAtIndex(0) as! Int)
                local.text = String(format: "Highest score : %d \nLowest score : 0", transportmax)
                outof.text = "\(transportscore) out of \(transportmax)"
                outof.textColor = UIColor.init(red: 0.572, green: 0.556, blue: 0.505, alpha: 1)
                typename.textColor = outof.textColor
                vieww.addSubview(typeimg)
                vieww.addSubview(s1)
                vieww.addSubview(l1)
                vieww.addSubview(l2)
                vieww.addSubview(global)
                vieww.addSubview(local)
                vieww.addSubview(outof)
                vieww.addSubview(typename)
                
                let innervv = UIView.init(frame: innerview.frame)
                innervv.frame.origin.y = l2.frame.size.height + l2.frame.origin.y
                let lbl = UILabel.init(frame: innerlbl.frame)
                lbl.text = innerlbl.text
                lbl.font = innerlbl.font
                lbl.textAlignment = NSTextAlignment.Right
                let img = UIImageView.init(frame: innerimg.frame)
                if(boolarr[section] == true){
                    img.image = UIImage.init(named: "less_data")
                    lbl.text = "Less details"
                }else{
                    img.image = UIImage.init(named: "more_data")
                    lbl.text = "More details"
                }
                innervv.addSubview(lbl)
                innervv.addSubview(img)
                vieww.addSubview(innervv)
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
                gestureRecognizer.delegate = self
                innervv.tag = section
                innervv.addGestureRecognizer(gestureRecognizer)
            }else{
                let total: Float = 5
                var typeimg = UIImageView.init(frame: dualsliderimage.frame)
                var global = UILabel.init(frame: dualsliderglobal.frame)
                var local = UILabel.init(frame: dualsliderlowest.frame)
                var outof = UILabel.init(frame: dualslideroutof.frame)
                var typename = UILabel.init(frame: dualslidertitle.frame)
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
                typeimg.image = UIImage.init(named: "ic_lomobile_navitem_transport")
                typename.text = "TRANSPORTATION"
                global.text = String(format: "Global avg : %d \nLocal avg : %d", globalavgarr.objectAtIndex(3) as! Int,localavgarr.objectAtIndex(3) as! Int)
                local.text = String(format: "Local avg : %d", localavgarr.objectAtIndex(0) as! Int)
                local.text = String(format: "Highest score : %d \nLowest score : 0", transportmax)
                outof.text = "\(transportscore) out of \(transportmax)"
                outof.textColor = UIColor.init(red: 0.572, green: 0.556, blue: 0.505, alpha: 1)
                typename.textColor = outof.textColor
                global.font = dualsliderglobal.font
                local.font = dualsliderlowest.font
                outof.font = dualslideroutof.font
                typename.font = dualslidertitle.font
                global.textAlignment = dualsliderglobal.textAlignment
                local.textAlignment = dualsliderlowest.textAlignment
                outof.textAlignment = dualslideroutof.textAlignment
                typename.textAlignment = dualslidertitle.textAlignment
                global.numberOfLines = 3
                local.numberOfLines = 3
                outof.numberOfLines = 3
                typename.numberOfLines = 3
                
                vieww.addSubview(typeimg)
                vieww.addSubview(global)
                vieww.addSubview(local)
                vieww.addSubview(outof)
                vieww.addSubview(typename)
                
                let innervv = UIView.init(frame: innerview.frame)
                innervv.frame.origin.y = decorview.frame.size.height + decorview.frame.origin.y
                let lbl = UILabel.init(frame: innerlbl.frame)
                lbl.text = innerlbl.text
                lbl.font = innerlbl.font
                lbl.textAlignment = NSTextAlignment.Right
                let img = UIImageView.init(frame: innerimg.frame)
                if(boolarr[section] == true){
                    img.image = UIImage.init(named: "less_data")
                    lbl.text = "Less details"
                }else{
                    img.image = UIImage.init(named: "more_data")
                    lbl.text = "More details"
                }
                innervv.addSubview(lbl)
                innervv.addSubview(img)
                vieww.addSubview(innervv)
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
                gestureRecognizer.delegate = self
                innervv.tag = section
                innervv.addGestureRecognizer(gestureRecognizer)
            }
            vieww.backgroundColor = UIColor.whiteColor()
            let v = circularprogress.init(frame: vv.frame)
            v.current = Double(transportscore)
            v.max = Double(transportmaxscore)
            v.strokecolor = UIColor.init(red: 0.572, green: 0.556, blue: 0.505, alpha: 1)
            v.setupProperties()
            v.removeAllAnimations()
            v.addUntitled1Animation()
            if(self.view.viewWithTag(43) != nil){
                self.view.viewWithTag(43)?.removeFromSuperview()
            }
            v.tag = 43
            vieww.addSubview(v)
            
            
            let decorvv = UIView.init(frame: decorview.frame)
            //decorvv.backgroundColor = v.strokecolor
            
            let globalimage = UIImageView.init(frame: globalimg.frame)
            globalimage.image = globalimg.image
            decorvv.addSubview(globalimage)
            
            let localimage = UIImageView.init(frame: localimg.frame)
            localimage.image = localimg.image
            decorvv.addSubview(localimage)
            
            let globalscore = UILabel.init(frame: globalvalue.frame)
            var actualstring = NSMutableAttributedString()
            var tempostring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString(string:"\(globalavgarr.objectAtIndex(3) as! Int)")
            tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 17)! , range: NSMakeRange(0, tempostring.length))
            tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, tempostring.length))
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:"/\(transportmaxscore as! Int)")
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            //print(actualstring)
            globalscore.font = UIFont.init(name: "OpenSans", size: 17)
            globalscore.attributedText = actualstring
            globalscore.textAlignment = NSTextAlignment.Center
            //globalscore.textColor = UIColor.whiteColor()
            decorvv.addSubview(globalscore)
            
            let localscore = UILabel.init(frame: localvalue.frame)
            actualstring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString(string:"\(localavgarr.objectAtIndex(3) as! Int)")
            tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 17)! , range: NSMakeRange(0, tempostring.length))
            tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, tempostring.length))
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:"/\(transportmaxscore as! Int)")
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            //print(actualstring)
            localscore.font = UIFont.init(name: "OpenSans", size: 17)
            localscore.attributedText = actualstring
            //localscore.textColor = UIColor.whiteColor()
            localscore.textAlignment = NSTextAlignment.Center
            decorvv.addSubview(localscore)
            
            let avgscore = UILabel.init(frame: avgvalue.frame)
            avgscore.text = avgvalue.text
            avgscore.font = avgvalue.font
            var sum = 0
            for item in scoresarr{
                var dict = item as! NSDictionary
                if(dict["transport"] is NSNull || dict["transport"] == nil){
                    
                }else{
                    sum = sum + (dict["transport"] as! Int)
                }
            }
            actualstring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString(string:"\(sum/12 as! Int)")
            tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 17)! , range: NSMakeRange(0, tempostring.length))
            tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, tempostring.length))
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:"/\(transportmaxscore as! Int)")
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            //print(actualstring)
            avgscore.font = UIFont.init(name: "OpenSans", size: 17)
            avgscore.attributedText = actualstring
            //avgscore.textColor = UIColor.whiteColor()
            avgscore.textAlignment = NSTextAlignment.Center
            
            
            let avgvv = UIView.init(frame: avgview.frame)
            avgvv.backgroundColor = UIColor.whiteColor()
            avgvv.layer.cornerRadius = avgvv.frame.size.height/2
            let lbll = UILabel.init(frame: avglbl.frame)
            lbll.text = avglbl.titleLabel?.text
            lbll.alpha = avglbl.alpha
            lbll.font = avglbl.titleLabel?.font
            lbll.textAlignment = NSTextAlignment.Center
            avgvv.addSubview(lbll)
            let avgimage = UIImageView.init(frame: avgimg.frame)
            avgimage.image = avgimg.image
            avgimage.alpha = avgimg.alpha
            avgvv.alpha = avgview.alpha
            avgvv.addSubview(avgimage)
            decorvv.addSubview(avgvv)
            decorvv.addSubview(avgscore)
            decorvv.layer.cornerRadius = 7
            vieww.addSubview(decorvv)
            let highest = UILabel.init(frame: highestscore.frame)
            actualstring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString(string:"\(transportmax as! Int)")
            tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 17)! , range: NSMakeRange(0, tempostring.length))
            tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, tempostring.length))
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:"/\(transportmaxscore as! Int)")
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            //print(actualstring)
            highest.font = UIFont.init(name: "OpenSans", size: 17)
            highest.attributedText = actualstring
            highest.textAlignment = highestscore.textAlignment
            
            let lowestimage = UIImageView.init(frame: lowestscoreimg.frame)
            lowestimage.image = lowestscoreimg.image
            let highestimage = UIImageView.init(frame: highestscoreimg.frame)
            highestimage.image = highestscoreimg.image
            let lowestlbl = UILabel.init(frame: lowestscorelbl.frame)
            lowestlbl.text = lowestscorelbl.text
            lowestlbl.numberOfLines = lowestscorelbl.numberOfLines
            lowestlbl.font = lowestscorelbl.font
            lowestlbl.textAlignment = lowestscorelbl.textAlignment
            let highestlbl = UILabel.init(frame: highestscorelbl.frame)
            highestlbl.text = highestscorelbl.text
            highestlbl.numberOfLines = highestscorelbl.numberOfLines
            highestlbl.font = highestscorelbl.font
            highestlbl.textAlignment = highestscorelbl.textAlignment
            
            vieww.addSubview(lowestimage)
            vieww.addSubview(highestimage)
            vieww.addSubview(lowestlbl)
            vieww.addSubview(highestlbl)
            
            let lowest = UILabel.init(frame: lowestscore.frame)
            actualstring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString(string:"0")
            tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 17)! , range: NSMakeRange(0, tempostring.length))
            tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, tempostring.length))
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:"/\(transportmaxscore as! Int)")
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            //print(actualstring)
            lowest.font = UIFont.init(name: "OpenSans", size: 17)
            lowest.attributedText = actualstring
            lowest.textAlignment = lowestscore.textAlignment
            vieww.addSubview(highest)
            vieww.addSubview(lowest)
            return vieww
        }    else if(section == 7){
            let vieww = UIView.init(frame: dualsliderview.frame)
            let inset: CGFloat = 10
            var frame = vieww.frame
            frame.origin.x += inset
            frame.size.width -= 2 * inset
            vieww.frame = frame
            
            if(humanpercentagedata.count > 0 && humanscoreedata.count > 0){
                
                
                let total: Float = 5
                var typeimg = UIImageView.init(frame: dualsliderimage.frame)
                
                var s1 = UISlider.init(frame: slider1.frame)
                var s2 = UISlider.init(frame: slider2.frame)
                var l1 = UILabel.init(frame: context1.frame)
                var l2 = UILabel.init(frame: context2.frame)
                var l3 = UILabel.init(frame: context3.frame)
                var l4 = UILabel.init(frame: context4.frame)
                
                var global = UILabel.init(frame: dualsliderglobal.frame)
                var local = UILabel.init(frame: dualsliderlowest.frame)
                var outof = UILabel.init(frame: dualslideroutof.frame)
                var typename = UILabel.init(frame: dualslidertitle.frame)
                l1.font = context1.font
                l2.font = context2.font
                l3.font = context3.font
                l4.font = context4.font
                global.font = dualsliderglobal.font
                local.font = dualsliderlowest.font
                outof.font = dualslideroutof.font
                typename.font = dualslidertitle.font
                l1.textAlignment = context1.textAlignment
                l2.textAlignment = context2.textAlignment
                l3.textAlignment = context3.textAlignment
                l4.textAlignment = context4.textAlignment
                global.textAlignment = dualsliderglobal.textAlignment
                local.textAlignment = dualsliderlowest.textAlignment
                outof.textAlignment = dualslideroutof.textAlignment
                typename.textAlignment = dualslidertitle.textAlignment
                l1.tag = 5001
                l2.tag = 5002
                l3.tag = 5003
                l4.tag = 5004
                
                l1.numberOfLines = 3
                l2.numberOfLines = 3
                l3.numberOfLines = 3
                l4.numberOfLines = 3
                global.numberOfLines = dualsliderglobal.numberOfLines
                local.numberOfLines = dualsliderlowest.numberOfLines
                outof.numberOfLines = dualslideroutof.numberOfLines
                typename.numberOfLines = dualslidertitle.numberOfLines
                
                s1.minimumValue = 0.0
                s1.tag = 14
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
                s1.maximumValue = Float(temparr.count-1)
                s2.maximumValue = Float(temparr1.count-1)
                s2.minimumValue = 0.0
                s2.tag = 24
                s1.value = 0.0
                s1.setValue(0.0, animated: true)
                var tempstr = temparr.objectAtIndex(human1sel).allKeys.first as! String
                var tempvalue = temparr.objectAtIndex(human1sel).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("human Plaque Score with", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("humanPlaqueScorewith", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("TransportationPlaqueScorewith", withString: "")
                l1.text = "If I reduce my emissions by \(tempstr as! String)"
                l2.text = "My new human score will be \(Int(tempvalue as! NSNumber))"
                tempstr = temparr1.objectAtIndex(human2sel).allKeys.first as! String
                tempvalue = temparr1.objectAtIndex(human2sel).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Percent emissions reduction for a plaque score of", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                l3.text = "If I want to increase my score to \(tempstr as! String)"
                l4.text = "I need to reduce my emission by \(Int(tempvalue as! NSNumber))%"
                s2.addTarget(self, action: #selector(self.slider2Changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                s1.addTarget(self, action: #selector(self.slider1Changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                s1.value = Float(human1sel)
                s1.setValue(Float(human1sel), animated: true)
                s2.value = Float(human2sel)
                s2.setValue(Float(human2sel), animated: true)
                typeimg.image = UIImage.init(named: "ic_lomobile_navitem_human")
                typename.text = "HUMAN EXPERIENCE"
                global.text = String(format: "Global avg : %d \nLocal avg : %d", globalavgarr.objectAtIndex(4) as! Int,localavgarr.objectAtIndex(4) as! Int)
                local.text = String(format: "Local avg : %d", localavgarr.objectAtIndex(0) as! Int)
                local.text = String(format: "Highest score : %d \nLowest score : 0", transportmax)
                outof.text = "\(transportscore) out of \(transportmax)"
                outof.textColor = UIColor.init(red: 0.92, green: 0.609, blue: 0.236, alpha: 1)
                typename.textColor = outof.textColor
                vieww.addSubview(typeimg)
                vieww.addSubview(s1)
                vieww.addSubview(s2)
                vieww.addSubview(l1)
                vieww.addSubview(l2)
                vieww.addSubview(l3)
                vieww.addSubview(l4)
                vieww.addSubview(global)
                vieww.addSubview(local)
                vieww.addSubview(outof)
                vieww.addSubview(typename)
                let innervv = UIView.init(frame: innerview.frame)
                innervv.frame.origin.y = l4.frame.size.height + l4.frame.origin.y
                let lbl = UILabel.init(frame: innerlbl.frame)
                lbl.text = innerlbl.text
                lbl.font = innerlbl.font
                lbl.textAlignment = NSTextAlignment.Right
                let img = UIImageView.init(frame: innerimg.frame)
                if(boolarr[section] == true){
                    img.image = UIImage.init(named: "less_data")
                    lbl.text = "Less details"
                }else{
                    img.image = UIImage.init(named: "more_data")
                    lbl.text = "More details"
                }
                innervv.addSubview(lbl)
                innervv.addSubview(img)
                vieww.addSubview(innervv)
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
                gestureRecognizer.delegate = self
                innervv.tag = section
                innervv.addGestureRecognizer(gestureRecognizer)
            }else if((humanpercentagedata.count > 0 && humanscoreedata.count == 0) || humanpercentagedata.count == 0 && humanscoreedata.count > 0){
                let total: Float = 5
                var typeimg = UIImageView.init(frame: dualsliderimage.frame)
                
                var s1 = UISlider.init(frame: slider1.frame)
                var l1 = UILabel.init(frame: context1.frame)
                var l2 = UILabel.init(frame: context2.frame)
                var global = UILabel.init(frame: dualsliderglobal.frame)
                var local = UILabel.init(frame: dualsliderlowest.frame)
                var outof = UILabel.init(frame: dualslideroutof.frame)
                var typename = UILabel.init(frame: dualslidertitle.frame)
                l1.font = context1.font
                l2.font = context2.font
                global.font = dualsliderglobal.font
                local.font = dualsliderlowest.font
                outof.font = dualslideroutof.font
                typename.font = dualslidertitle.font
                l1.textAlignment = context1.textAlignment
                l2.textAlignment = context2.textAlignment
                global.textAlignment = dualsliderglobal.textAlignment
                local.textAlignment = dualsliderlowest.textAlignment
                outof.textAlignment = dualslideroutof.textAlignment
                typename.textAlignment = dualslidertitle.textAlignment
                l1.numberOfLines = 3
                l2.numberOfLines = 3
                l1.tag = 5001
                l2.tag = 5002
                global.numberOfLines = 3
                local.numberOfLines = 3
                outof.numberOfLines = 3
                typename.numberOfLines = 3
                
                s1.minimumValue = 0.0
                s1.tag = 14
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
                s1.maximumValue = Float(temparr.count-1)
                s1.value = 0.0
                s1.setValue(0.0, animated: true)
                var tempstr = temparr.objectAtIndex(human1sel).allKeys.first as! String
                var tempvalue = temparr.objectAtIndex(human1sel).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("human Plaque Score with", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("humanPlaqueScorewith", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("TransportationPlaqueScorewith", withString: "")
                
                l1.text = "If I reduce my emissions by \(tempstr as! String)"
                l2.text = "My new human score will be \(Int(tempvalue as! NSNumber))"
                s1.addTarget(self, action: #selector(self.slider1Changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                s1.value = Float(human1sel)
                s1.setValue(Float(human1sel), animated: true)
                typeimg.image = UIImage.init(named: "ic_lomobile_navitem_human")
                typename.text = "HUMAN EXPERIENCE"
                global.text = String(format: "Global avg : %d \nLocal avg : %d", globalavgarr.objectAtIndex(4) as! Int,localavgarr.objectAtIndex(4) as! Int)
                local.text = String(format: "Local avg : %d", localavgarr.objectAtIndex(0) as! Int)
                local.text = String(format: "Highest score : %d \nLowest score : 0", transportmax)
                outof.text = "\(transportscore) out of \(transportmax)"
                outof.textColor = UIColor.init(red: 0.92, green: 0.609, blue: 0.236, alpha: 1)
                typename.textColor = outof.textColor
                vieww.addSubview(typeimg)
                vieww.addSubview(s1)
                vieww.addSubview(l1)
                vieww.addSubview(l2)
                vieww.addSubview(global)
                vieww.addSubview(local)
                vieww.addSubview(outof)
                vieww.addSubview(typename)
                
                let innervv = UIView.init(frame: innerview.frame)
                innervv.frame.origin.y = l2.frame.size.height + l2.frame.origin.y
                let lbl = UILabel.init(frame: innerlbl.frame)
                lbl.text = innerlbl.text
                lbl.font = innerlbl.font
                lbl.textAlignment = NSTextAlignment.Right
                let img = UIImageView.init(frame: innerimg.frame)
                if(boolarr[section] == true){
                    img.image = UIImage.init(named: "less_data")
                    lbl.text = "Less details"
                }else{
                    img.image = UIImage.init(named: "more_data")
                    lbl.text = "More details"
                }
                innervv.addSubview(lbl)
                innervv.addSubview(img)
                vieww.addSubview(innervv)
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
                gestureRecognizer.delegate = self
                innervv.tag = section
                innervv.addGestureRecognizer(gestureRecognizer)
            }else{
                let total: Float = 5
                var typeimg = UIImageView.init(frame: dualsliderimage.frame)
                var global = UILabel.init(frame: dualsliderglobal.frame)
                var local = UILabel.init(frame: dualsliderlowest.frame)
                var outof = UILabel.init(frame: dualslideroutof.frame)
                var typename = UILabel.init(frame: dualslidertitle.frame)
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
                typeimg.image = UIImage.init(named: "ic_lomobile_navitem_human")
                typename.text = "HUMAN EXPERIENCE"
                global.text = String(format: "Global avg : %d \nLocal avg : %d", globalavgarr.objectAtIndex(4) as! Int,localavgarr.objectAtIndex(4) as! Int)
                local.text = String(format: "Local avg : %d", localavgarr.objectAtIndex(0) as! Int)
                local.text = String(format: "Highest score : %d \nLowest score : 0", transportmax)
                outof.text = "\(humanscore) out of \(humanmax)"
                outof.textColor = UIColor.init(red: 0.92, green: 0.609, blue: 0.236, alpha: 1)
                typename.textColor = outof.textColor
                global.font = dualsliderglobal.font
                local.font = dualsliderlowest.font
                outof.font = dualslideroutof.font
                typename.font = dualslidertitle.font
                global.textAlignment = dualsliderglobal.textAlignment
                local.textAlignment = dualsliderlowest.textAlignment
                outof.textAlignment = dualslideroutof.textAlignment
                typename.textAlignment = dualslidertitle.textAlignment
                global.numberOfLines = 3
                local.numberOfLines = 3
                outof.numberOfLines = 3
                typename.numberOfLines = 3
                
                vieww.addSubview(typeimg)
                vieww.addSubview(global)
                vieww.addSubview(local)
                vieww.addSubview(outof)
                vieww.addSubview(typename)
                
                let innervv = UIView.init(frame: innerview.frame)
                innervv.frame.origin.y = decorview.frame.size.height + decorview.frame.origin.y
                let lbl = UILabel.init(frame: innerlbl.frame)
                lbl.text = innerlbl.text
                lbl.font = innerlbl.font
                lbl.textAlignment = NSTextAlignment.Right
                let img = UIImageView.init(frame: innerimg.frame)
                if(boolarr[section] == true){
                    img.image = UIImage.init(named: "less_data")
                    lbl.text = "Less details"
                }else{
                    img.image = UIImage.init(named: "more_data")
                    lbl.text = "More details"
                }
                innervv.addSubview(lbl)
                innervv.addSubview(img)
                vieww.addSubview(innervv)
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
                gestureRecognizer.delegate = self
                innervv.tag = section
                innervv.addGestureRecognizer(gestureRecognizer)
            }
            vieww.backgroundColor = UIColor.whiteColor()
            let v = circularprogress.init(frame: vv.frame)
            v.current = Double(humanscore)
            v.max = Double(humanmaxscore)
            v.strokecolor = UIColor.init(red: 0.92, green: 0.609, blue: 0.236, alpha: 1)
            v.setupProperties()
            v.removeAllAnimations()
            v.addUntitled1Animation()
            if(self.view.viewWithTag(44) != nil){
                self.view.viewWithTag(44)?.removeFromSuperview()
            }
            v.tag = 44
            vieww.addSubview(v)
            
            let decorvv = UIView.init(frame: decorview.frame)
            //decorvv.backgroundColor = v.strokecolor
            
            let globalimage = UIImageView.init(frame: globalimg.frame)
            globalimage.image = globalimg.image
            decorvv.addSubview(globalimage)
            
            let localimage = UIImageView.init(frame: localimg.frame)
            localimage.image = localimg.image
            decorvv.addSubview(localimage)
            
            let globalscore = UILabel.init(frame: globalvalue.frame)
            var actualstring = NSMutableAttributedString()
            var tempostring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString(string:"\(globalavgarr.objectAtIndex(4) as! Int)")
            tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 17)! , range: NSMakeRange(0, tempostring.length))
            tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, tempostring.length))
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:"/\(humanmaxscore as! Int)")
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            //print(actualstring)
            globalscore.font = UIFont.init(name: "OpenSans", size: 17)
            globalscore.attributedText = actualstring
            globalscore.textAlignment = NSTextAlignment.Center
            //globalscore.textColor = UIColor.whiteColor()
            decorvv.addSubview(globalscore)
            
            let localscore = UILabel.init(frame: localvalue.frame)
            actualstring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString(string:"\(localavgarr.objectAtIndex(4) as! Int)")
            tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 17)! , range: NSMakeRange(0, tempostring.length))
            tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, tempostring.length))
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:"/\(humanmaxscore as! Int)")
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            //print(actualstring)
            localscore.font = UIFont.init(name: "OpenSans", size: 17)
            localscore.attributedText = actualstring
            //localscore.textColor = UIColor.whiteColor()
            localscore.textAlignment = NSTextAlignment.Center
            decorvv.addSubview(localscore)
            
            let avgscore = UILabel.init(frame: avgvalue.frame)
            avgscore.text = avgvalue.text
            avgscore.font = avgvalue.font
            //avgscore.textColor = UIColor.whiteColor()
            var sum = 0
            for item in scoresarr{
                var dict = item as! NSDictionary
                if(dict["human_experience"] is NSNull || dict["human_experience"] == nil){
                    
                }else{
                    sum = sum + (dict["human_experience"] as! Int)
                }
            }
            actualstring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString(string:"\(sum/12 as! Int)")
            tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 17)! , range: NSMakeRange(0, tempostring.length))
            tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, tempostring.length))
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:"/\(humanmaxscore as! Int)")
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            //print(actualstring)
            avgscore.font = UIFont.init(name: "OpenSans", size: 17)
            avgscore.attributedText = actualstring
            avgscore.textAlignment = NSTextAlignment.Center
            decorvv.addSubview(avgscore)
            
            let avgvv = UIView.init(frame: avgview.frame)
            avgvv.backgroundColor = UIColor.whiteColor()
            avgvv.layer.cornerRadius = avgvv.frame.size.height/2
            let lbll = UILabel.init(frame: avglbl.frame)
            lbll.text = avglbl.titleLabel?.text
            lbll.alpha = avglbl.alpha
            lbll.font = avglbl.titleLabel?.font
            lbll.textAlignment = NSTextAlignment.Center
            avgvv.addSubview(lbll)
            let avgimage = UIImageView.init(frame: avgimg.frame)
            avgimage.image = avgimg.image
            avgimage.alpha = avgimg.alpha
            avgvv.alpha = avgview.alpha
            avgvv.addSubview(avgimage)
            decorvv.addSubview(avgvv)
            decorvv.addSubview(avgscore)
            decorvv.layer.cornerRadius = 7
            vieww.addSubview(decorvv)
            let highest = UILabel.init(frame: highestscore.frame)
            actualstring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString(string:"\(humanmax as! Int)")
            tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 17)! , range: NSMakeRange(0, tempostring.length))
            tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, tempostring.length))
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:"/\(humanmaxscore as! Int)")
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            //print(actualstring)
            highest.font = UIFont.init(name: "OpenSans", size: 17)
            highest.attributedText = actualstring
            highest.textAlignment = highestscore.textAlignment
            
            let lowestimage = UIImageView.init(frame: lowestscoreimg.frame)
            lowestimage.image = lowestscoreimg.image
            let highestimage = UIImageView.init(frame: highestscoreimg.frame)
            highestimage.image = highestscoreimg.image
            let lowestlbl = UILabel.init(frame: lowestscorelbl.frame)
            lowestlbl.text = lowestscorelbl.text
            lowestlbl.numberOfLines = lowestscorelbl.numberOfLines
            lowestlbl.font = lowestscorelbl.font
            lowestlbl.textAlignment = lowestscorelbl.textAlignment
            let highestlbl = UILabel.init(frame: highestscorelbl.frame)
            highestlbl.text = highestscorelbl.text
            highestlbl.numberOfLines = highestscorelbl.numberOfLines
            highestlbl.font = highestscorelbl.font
            highestlbl.textAlignment = highestscorelbl.textAlignment
            
            vieww.addSubview(lowestimage)
            vieww.addSubview(highestimage)
            vieww.addSubview(lowestlbl)
            vieww.addSubview(highestlbl)
            
            let lowest = UILabel.init(frame: lowestscore.frame)
            actualstring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString(string:"0")
            tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 17)! , range: NSMakeRange(0, tempostring.length))
            tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, tempostring.length))
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:"/\(humanmaxscore as! Int)")
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            //print(actualstring)
            lowest.font = UIFont.init(name: "OpenSans", size: 17)
            lowest.attributedText = actualstring
            lowest.textAlignment = lowestscore.textAlignment
            vieww.addSubview(highest)
            vieww.addSubview(lowest)
            return vieww
        }else if(section == 8){
            let vieww = UIView.init(frame: emissionsview.frame)
            let inset: CGFloat = 10
            var frame = vieww.frame
            frame.origin.x += inset
            frame.size.width -= 2 * inset
            vieww.frame = frame
            
            var emissionsimg = UIImageView.init(frame: innerimg1.frame)
            emissionsimg.image = innerimg1.image
            vieww.addSubview(emissionsimg)
            
            var emissionstitle = UILabel.init(frame: innertitle1.frame)
            emissionstitle.font = innertitle1.font
            emissionstitle.text = "CARBON EMISSIONS"
            vieww.addSubview(emissionstitle)
            
            
            let innerimage1 = UIImageView.init(frame: innerimg.frame)
            innerimage1.image = innerimg.image
            
            
            
            innerlbl.textAlignment = .Right
            
            vieww.backgroundColor = UIColor.whiteColor()
            vieww.addSubview(innerimage1)
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
            gestureRecognizer.delegate = self
            vieww.tag = section
            vieww.addGestureRecognizer(gestureRecognizer)
            return vieww
        }
        
 
        return UIView()
    }
    
    
       

     
    
    func handleTap(gestureRecognizer: UIGestureRecognizer) {
        let section = (gestureRecognizer.view!.tag) as! Int
        boolarr[section] = !boolarr[section]
        dispatch_async(dispatch_get_main_queue(), {
        self.tableview.beginUpdates()
        self.tableview.reloadSections(NSIndexSet.init(index: section), withRowAnimation: UITableViewRowAnimation.Automatic)
        self.tableview.endUpdates()
        //self.tableview.reloadData()
            })
     //print("tap")
    }
    
    
    func slider1Changed(sender: UISlider) {
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        //print(sender.value,sender.tag)
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
            var cell1 = tableview.headerViewForSection(3)
            if(cell is totalanalysis3){
                var c = cell as! totalanalysis3
                var tempstr = temparr.objectAtIndex(Int(sender.value)).allKeys.first as! String
                var tempvalue = temparr.objectAtIndex(Int(sender.value)).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Energy Plaque Score with", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                c.l1.text = "If I reduce my emissions by \(tempstr as! String)"
                c.l2.text = "My new energy score will be \(Int(tempvalue as! NSNumber))"
                (self.view.viewWithTag(1001) as! UILabel).text = "If I reduce my emissions by \(tempstr as! String)"
                (self.view.viewWithTag(1002) as! UILabel).text = "My new energy score will be \(Int(tempvalue as! NSNumber))"
                //print(Int(sender.value))
                //print(temparr.count)
            }else{
                
                var tempstr = temparr.objectAtIndex(Int(sender.value)).allKeys.first as! String
                var tempvalue = temparr.objectAtIndex(Int(sender.value)).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Energy Plaque Score with", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                (self.view.viewWithTag(1001) as! UILabel).text = "If I reduce my emissions by \(tempstr as! String)"
                (self.view.viewWithTag(1002) as! UILabel).text = "My new energy score will be \(Int(tempvalue as! NSNumber))"
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
                (self.view.viewWithTag(2001) as! UILabel).text = "If I reduce my emissions by \(tempstr as! String)"
                (self.view.viewWithTag(2002) as! UILabel).text = "My new water score will be \(Int(tempvalue as! NSNumber))"
            }else {
                var tempstr = temparr.objectAtIndex(Int(sender.value)).allKeys.first as! String
                var tempvalue = temparr.objectAtIndex(Int(sender.value)).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Water Plaque Score with", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                (self.view.viewWithTag(2001) as! UILabel).text = "If I reduce my emissions by \(tempstr as! String)"
                (self.view.viewWithTag(2002) as! UILabel).text = "My new water score will be \(Int(tempvalue as! NSNumber))"
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
                (self.view.viewWithTag(3001) as! UILabel).text = "If I reduce my emissions by \(tempstr as! String)"
                (self.view.viewWithTag(3002) as! UILabel).text = "My new waste score will be \(Int(tempvalue as! NSNumber))"
            }else {
                var tempstr = temparr.objectAtIndex(Int(sender.value)).allKeys.first as! String
                var tempvalue = temparr.objectAtIndex(Int(sender.value)).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Waste Plaque Score with", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                
                (self.view.viewWithTag(3001) as! UILabel).text = "If I reduce my emissions by \(tempstr as! String)"
                (self.view.viewWithTag(3002) as! UILabel).text = "My new waste score will be \(Int(tempvalue as! NSNumber))"
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
                (self.view.viewWithTag(4001) as! UILabel).text = "If I reduce my emissions by \(tempstr as! String)"
                (self.view.viewWithTag(4002) as! UILabel).text = "My new waste transit will be \(Int(tempvalue as! NSNumber))"
            }else {
                var tempstr = temparr.objectAtIndex(Int(sender.value)).allKeys.first as! String
                var tempvalue = temparr.objectAtIndex(Int(sender.value)).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Transportation Plaque Score with", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                (self.view.viewWithTag(4001) as! UILabel).text = "If I reduce my emissions by \(tempstr as! String)"
                (self.view.viewWithTag(4002) as! UILabel).text = "My new transit score will be \(Int(tempvalue as! NSNumber))"
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
                (self.view.viewWithTag(5001) as! UILabel).text = "If I reduce my emissions by \(tempstr as! String)"
                (self.view.viewWithTag(5002) as! UILabel).text = "My new human experience score will be \(Int(tempvalue as! NSNumber))"
            }else {
                var tempstr = temparr.objectAtIndex(Int(sender.value)).allKeys.first as! String
                var tempvalue = temparr.objectAtIndex(Int(sender.value)).allValues.first
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Human Experience Plaque Score with", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString("Lower Emissions", withString: "")
                tempstr = tempstr.stringByReplacingOccurrencesOfString(" ", withString: "")
                (self.view.viewWithTag(5001) as! UILabel).text = "If I reduce my emissions by \(tempstr as! String)"
                (self.view.viewWithTag(5002) as! UILabel).text = "My new human experience score will be \(Int(tempvalue as! NSNumber))"
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
    
    /*func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if(indexPath.section == 0){
            //print("Anslysis dict",analysisdict)
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
        
        
    }*/
    
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
            
            vc.buildingdetails = self.buildingdetails
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
                        str1.replaceOccurrencesOfString("None", withString: "\"None\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
                        str = str1.mutableCopy() as! String
                        let jsonData = (str).dataUsingEncoding(NSUTF8StringEncoding)
                        do {
                            dict = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions()) as! NSDictionary
                            if(dict["Raw GHG (mtCO2e/day)"] is NSNull){
                                
                            }else{
                                var gross = Float(0)
                                if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                                }else{
                                    gross = Float( self.buildingdetails["gross_area"] as! Int)
                                }
                                vc.str1 =  String(format:"%.5f",(dict["Raw GHG (mtCO2e/day)"] as! Float  * 365) / gross)
                                var occupant = Float(0)
                                if(self.buildingdetails["occupancy"] == nil || self.buildingdetails["occupancy"] is NSNull){
                                }else{
                                    occupant = Float( self.buildingdetails["occupancy"] as! Int)
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
                        str1.replaceOccurrencesOfString("None", withString: "\"None\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str!.characters.count))
                        str = str1.mutableCopy() as! String
                        let jsonData = (str!).dataUsingEncoding(NSUTF8StringEncoding)
                        do {
                            dict = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions()) as! NSDictionary
                            if(dict["Raw Water Use (gallons/day)"] is NSNull){
                                
                            }else{
                                var gross = Float(0)
                                if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                                }else{
                                    gross = Float( self.buildingdetails["gross_area"] as! Int)
                                }
                                vc.str1 =  String(format:"%.5f",(dict["Raw Water Use (gallons/day)"] as! Float  * 365) / gross )
                                var occupant = Float(0)
                                if(self.buildingdetails["occupancy"] == nil || self.buildingdetails["occupancy"] is NSNull){
                                }else{
                                    occupant = Float( self.buildingdetails["occupancy"] as! Int)
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
                        str1.replaceOccurrencesOfString("None", withString: "\"None\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
                        str = str1.mutableCopy() as! String
                        let jsonData = (str).dataUsingEncoding(NSUTF8StringEncoding)
                        do {
                            dict = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions()) as! NSDictionary
                            if(dict["Generated Waste (lbs per occupant per day)"] is NSNull){
                                
                            }else{
                                var gross = Float(0)
                                if(self.buildingdetails["gross_area"] == nil || self.buildingdetails["gross_area"] is NSNull){
                                }else{
                                    gross = Float( self.buildingdetails["gross_area"] as! Int)
                                }
                                vc.str1 =  String(format:"%.5f",(dict["Generated Waste (lbs per occupant per day)"] as! Float  * 365) / gross )
                                var occupant = Float(0)
                                if(self.buildingdetails["occupancy"] == nil || self.buildingdetails["occupancy"] is NSNull){
                                }else{
                                    occupant = Float( self.buildingdetails["occupancy"] as! Int)
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
    
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    
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


