//
//  ViewController.swift
//  Analytics
//
//  Created by Group X on 31/05/17.
//  Copyright © 2017 USGBC. All rights reserved.
//

import UIKit
import WatchConnectivity

class totalanalytics: UIViewController, UITableViewDataSource, UITableViewDelegate, WCSessionDelegate, UITabBarDelegate {
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var spinner: UIView!
    @IBOutlet weak var tabbar: UITabBar!
    
    var analysisdict = NSDictionary()
    var scoresarr = NSMutableArray()
    @IBOutlet weak var vv: UIView!
    var countries = NSMutableDictionary()
    var fullcountryname = ""
    var fullstatename = ""
    var buildingdetails = NSMutableDictionary()
    var scoresarray = NSDictionary()
    var localavgarr = NSMutableArray()
    var lessduringreport = 0
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
    var reportedscores = NSMutableArray()
    var datearr = NSMutableArray()
    var globaldata = NSMutableDictionary()
    var performancedata = NSDictionary()
    var localdata = NSMutableDictionary()
    var step = Float(5)
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
    var toload = true
    var callrequest = 1
    var highduringreport = 0
    var watchsession = WCSession.default()
    var task = URLSessionTask()
    var download_requests = [URLSession]()
    var globalavgarr = NSMutableArray()
    var performancescoresarr = NSMutableArray()
    
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    @available(iOS 9.3, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        print("Analysis dict",analysisdict)
        
        buildingdetails = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.navigationItem.title = buildingdetails["name"] as? String
        print(self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2].restorationIdentifier)
        if(self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2].restorationIdentifier == "plaque"){
            self.navigationController?.navigationBar.backItem?.title = "Scores"
        }else{
        self.navigationController?.navigationBar.backItem?.title = "Projects"
        }
        self.navigationController?.navigationBar.barTintColor = UIColor.darkGray
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "OpenSans", size: 17)!, NSForegroundColorAttributeName: UIColor.white]
        self.tableview.isHidden = false
        if(UserDefaults.standard.object(forKey: "certification_details") == nil){
            let dict = NSMutableDictionary()
            let arr = NSArray()
            dict["certificates"] = arr
            dict["performance_periods"] = arr
            certificationsdict = dict
            let datakeyed = NSKeyedArchiver.archivedData(withRootObject: dict)
        }else{
            let datakeyed = UserDefaults.standard.object(forKey: "certification_details") as! NSData
            certificationsdict = NSKeyedUnarchiver.unarchiveObject(with: datakeyed as Data) as! NSDictionary
        }
        self.tableview.reloadData()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.separatorStyle = .singleLineEtched
        self.tableview.separatorColor = UIColor.black
        self.view.isUserInteractionEnabled = false
        let notificationsarr = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "notifications") as! Data) as! NSArray
        let plaque = UIImage.init(named: "score")
        let credits = UIImage.init(named: "Menu_icon")
        let analytics = UIImage.init(named: "chart")
        let more = UIImage.init(named: "more")
        self.tabbar.setItems([UITabBarItem.init(title: "Score", image: plaque, tag: 0),UITabBarItem.init(title: "Credits/Actions", image: credits, tag: 1),UITabBarItem.init(title: "Analytics", image: analytics, tag: 2),UITabBarItem.init(title: "More", image: more, tag: 3)], animated: false)
        self.tabbar.selectedItem = self.tabbar.items![2]
        if(notificationsarr.count > 0 ){
            
            self.tabbar.items![3].badgeValue = "\(notificationsarr.count)"
        }else{
            self.tabbar.items![3].badgeValue = nil
        }
        self.spinner.layer.cornerRadius = 5
        self.spinner.layer.masksToBounds = true
        scoresarray = [
            "id": 186740,
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
                "leed_id": 1000124631,
                "name": "US project",
                "city": "Apex",
                "country": "US",
                "state": "NC",
                "zip_code": "27523",
                "gross_area": 2000,
                "updated_at": "2017-04-27T12:05:13.404100Z",
                "occupancy": 15,
                "certification": "",
                "building_status": "activated_payment_done",
                "rating_system": "LEED V4 O+M: TR",
                "owner_name": NSNull(),
                "owner_email": "owner@gmail.com",
                "base_score": 100,
                "energy": 27,
                "water": 14,
                "waste": 8,
                "transport": 0,
                "human_experience": 15,
                "scores": [
                    "water": 14,
                    "energy": 27,
                    "waste": 8,
                    "human_experience": 15,
                    "transport": 0
                ]
            ],
            "scores": [
                "energy": 27,
                "water": 14,
                "base": 10,
                "human_experience": 15,
                "waste": 8,
                "transport": 0
            ],
            "version": "version3",
            "created_at": "2017-04-27T12:05:13.391770Z",
            "effective_at": "2017-04-27T00:00:00Z",
            "certification_level": "silver",
            "energy": 80.5794924746553,
            "water": 94.4917762993125,
            "waste": 100,
            "transport": 0,
            "human_experience": 75.64292633186,
            "base": 100
        ]
        
        //analysisdict = []
        buildingdetails = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.navigationItem.title = buildingdetails["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as? String
        
        self.titlefont()
        self.automaticallyAdjustsScrollViewInsets = false;
        self.navigationController!.navigationBar.isTranslucent = false
        self.spinner.layer.cornerRadius = 5
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.adjustwidth), name: UIDeviceOrientationDidChangeNotification, object: nil)
        self.tableview.isHidden = true
        
        if(notificationsarr.count > 0 ){
            //self.tabbar.items![4].badgeValue = "\(notificationsarr.count)"
        }else{
            //self.tabbar.items![4].badgeValue = nil
        }
        //self.tabbar.selectedItem = self.tabbar.items![2]
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
        ] as [String : Any]
        
        tableview.register(UINib.init(nibName:  "cell1", bundle: nil), forCellReuseIdentifier: "cell1")
        tableview.register(UINib.init(nibName:  "categorycell", bundle: nil), forCellReuseIdentifier: "categorycell")
        let datearray : NSMutableArray = []
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        var date = Date()
        let unitFlags: NSCalendar.Unit = [.hour, .day, .month, .year]
        var components = (Calendar.current as NSCalendar).components(unitFlags, from: date)
        
        for _ in (1...12).reversed() {
            ////print(components.year, components.month)
            components = (Calendar.current as NSCalendar).components(unitFlags, from: date)
            datearray.add(String(format:"%d-%02d-01",components.year!,components.month!))
            let monthAgo = (Calendar.current as NSCalendar).date(byAdding: .month, value: -1, to: date, options: [])
            date = monthAgo!
        }
        
        
        ////print(datearray)
        var date1 = Date()
        var date2 = Date()
        formatter.dateFormat = "yyyy-MM-dd"
        date1 = formatter.date(from: datearray.firstObject as! String)!
        date2 = formatter.date(from: datearray.lastObject as! String)!
        formatter.dateFormat = "MMM yyyy"
        duration = String(format: "%@ to %@",formatter.string(from: date2),formatter.string(from: date1))
        datearr = datearray
        
        

        
        DispatchQueue.main.async(execute: {
                self.spinner.isHidden = false
                self.tableview.alpha = 0.3
                self.recompute(leedid: UserDefaults.standard.integer(forKey: "leed_id"),token: UserDefaults.standard.object(forKey: "token") as! String)
        })
        
        
    /*    if(self.toload == true){
            if(UserDefaults.standard.object(forKey: "comparable_data") != nil){
                globaldata  = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "comparable_data") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            }else{
                globaldata = temparr as! NSMutableDictionary
            }
            
            if(UserDefaults.standard.object(forKey: "local_comparable_data") != nil){
                localdata  = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "local_comparable_data") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            }else{
                localdata = temparr as! NSMutableDictionary
            }
            
            
            
            if(UserDefaults.standard.object(forKey: "performance_data") != nil){
                performancedata  = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "performance_data") as! Data) as! NSDictionary
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
            
            self.scoresarray = self.performancedata
            
            ////print(globaldata,localdata)
            globalavgarr.add(0)
            globalavgarr.add(0)
            globalavgarr.add(0)
            globalavgarr.add(0)
            globalavgarr.add(0)
            
            for (i,value) in globaldata{
                let key = i as! String
                if(value is NSNull){
                    
                }else{
                    if(key == "energy_avg"){
                        globalavgarr.replaceObject(at: 0, with: value as! Int)
                    }else if(key == "water_avg"){
                        globalavgarr.replaceObject(at: 1, with: value as! Int)
                    }else if(key == "waste_avg"){
                        globalavgarr.replaceObject(at: 2, with: value as! Int)
                    }else if(key == "transport_avg"){
                        globalavgarr.replaceObject(at: 3, with: value as! Int)
                    }else if(key == "human_experience_avg"){
                        globalavgarr.replaceObject(at: 4, with: value as! Int)
                    }
                }
            }
            
            localavgarr.add(0)
            localavgarr.add(0)
            localavgarr.add(0)
            localavgarr.add(0)
            localavgarr.add(0)
            
            ////print("avg arrays",globaldata,localdata)
            
            for (i,value) in localdata{
                let key = i as! String
                if(value is NSNull){
                }else{
                    if(key == "energy_avg"){
                        localavgarr.replaceObject(at: 0, with: value as! Int)
                    }else if(key == "water_avg"){
                        localavgarr.replaceObject(at: 1, with: value as! Int)
                    }else if(key == "waste_avg"){
                        localavgarr.replaceObject(at: 2, with: value as! Int)
                    }else if(key == "transport_avg"){
                        localavgarr.replaceObject(at: 3, with: value as! Int)
                    }else if(key == "human_experience_avg"){
                        localavgarr.replaceObject(at: 4, with: value as! Int)
                    }
                }
            }
        
        countries = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "countries") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        
        var tempdictt = (countries["countries"] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        var present = 0
        
        tempdictt = (countries["countries"] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        for (_,value) in tempdictt{
            if(value as! String == buildingdetails["country"]! as! String){
                present = 1
                break
            }
        }
        tempdictt = (countries["countries"] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        if(present == 1){
            fullcountryname = tempdictt[buildingdetails["country"] as! String]! as! String
            let divisions = countries["divisions"] as! NSDictionary
            tempdictt = divisions[buildingdetails["country"] as! String]! as! NSMutableDictionary
            for (i,value) in tempdictt{
                let key = i as! String
                if(key == buildingdetails["state"] as! String){
                    fullstatename = value as! String
                    break
                }
            }
        }else{
            fullcountryname = ""
        }
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.tableview.contentInset = UIEdgeInsetsMake((self.navigationController?.navigationBar.layer.frame.size.height)!,0,0,0);
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        if(performancedata["scores"] != nil){
            var temparr = (performancedata["scores"] as! NSDictionary).mutableCopy() as! NSMutableDictionary
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
            var temparr = (performancedata["maxima"] as! NSDictionary).mutableCopy() as! NSMutableDictionary
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
        
        
        tableview.reloadData()
        
        
        
        
        
        
        
        
        if(isloaded == false){
            if(callrequest == 1){
                DispatchQueue.main.async(execute: {
                    self.view.isUserInteractionEnabled = false
                    self.spinner.isHidden = false
                    self.tableview.alpha = 0.4
                    self.getscores(UserDefaults.standard.integer(forKey: "leed_id"),token: UserDefaults.standard.object(forKey: "token") as! String)
                })
            }
        }
    }
        
        
    if(UserDefaults.standard.object(forKey: "local_comparable_data") != nil && UserDefaults.standard.object(forKey: "comparable_data") != nil && UserDefaults.standard.object(forKey: "performance_data") != nil){
    }else{
    DispatchQueue.main.async(execute: {
    let dte = Date()
    var dateformat = DateFormatter()
    dateformat.dateFormat = "yyyy-MM-dd"
    let datee = dateformat.string(from: dte)
    self.getperformancedata(credentials().subscription_key, leedid: self.buildingdetails["leed_id"] as! Int, date: datee)
    })
    }
    */
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func recompute(leedid: Int, token : String){
        //self.getscores(UserDefaults.standard.integer(forKey: "leed_id"),token: UserDefaults.standard.object(forKey: "token") as! String)
        
        let url = URL(string: "\(credentials().domain_url)assets/LEED:\(leedid)/analysis/recompute")
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        
        
        let tasky = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401{
                DispatchQueue.main.async(execute: {
                    //self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
                return
            } else
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for httCALayer * individualforiphone = [CALayer layer];
                    //[self.layer addSublayer:individualforiphone];
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                    DispatchQueue.main.async(execute: {
                        let jsonDictionary : NSDictionary
                        do {
                            jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                            if(jsonDictionary["error"] != nil){
                                if let snapshotValue = jsonDictionary["error"] as? NSArray, let currentcountr = snapshotValue[0] as? NSDictionary, let currentstat = currentcountr["message"] as? String {
                                    self.showalert(currentstat, title: "Error", action: "OK")
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
                    DispatchQueue.main.async(execute: {
                    self.getscores(UserDefaults.standard.integer(forKey: "leed_id"),token: UserDefaults.standard.object(forKey: "token") as! String)
                    })
            }
            
        })
        
        tasky.resume()

        
    }


    func assignanalysisvalue(){
        var dict = self.analysisdict
        if(dict["energy"] is NSNull || dict["energy"] == nil){
            let emissions = [Int]()
            let values = [Int]()
            self.energyemissions = emissions
            self.energyvalues = values
        }else{
            if let energy = dict["energy"] as? NSDictionary, let info_json = energy["info_json"] as? String {
                var str = info_json
                let str1 = NSMutableString()
                str1.append(str)
                str1.replaceOccurrences(of: "'", with: "\"", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(0, str.characters.count))
                ////print(str1)
                str = str1.mutableCopy() as! String
                let jsonData = (str).data(using: String.Encoding.utf8)
                do {
                    dict = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    let tempdict = NSMutableDictionary()
                    var emissions = [Int]()
                    var values = [Int]()
                    for (key, value) in dict{
                        if((key as AnyObject).contains("Percent emissions reduction for a plaque score of")){
                            tempdict.setValue(value, forKey: key as! String)
                            let str = NSMutableString()
                            str.append(key as! String)
                            str.replaceOccurrences(of: "Percent emissions reduction for a plaque score of ", with: "", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(0, str.length))
                            emissions.append(Int(str as String)!)
                            values.append(value as! Int)
                        }
                    }
                    ////print("Tempdict",tempdict,values,emissions)
                    self.energyemissions = emissions
                    self.energyvalues = values
                }catch{
                    
                }
            }else{
                let emissions = [Int]()
                let values = [Int]()
                self.energyemissions = emissions
                self.energyvalues = values
            }
        }
        
        
        if(dict["water"] is NSNull || dict["water"] == nil){
            let emissions = [Int]()
            let values = [Int]()
            
            self.wateremissions = emissions
            self.watervalues = values
        }else{
            if let water = dict["water"] as? NSDictionary, let info_json = water["info_json"] as? String {
                var str = info_json
                let str1 = NSMutableString()
                str1.append(str)
                str1.replaceOccurrences(of: "'", with: "\"", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(0, str.characters.count))
                ////print(str1)
                str = str1.mutableCopy() as! String
                let jsonData = (str).data(using: String.Encoding.utf8)
                do {
                    dict = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    let tempdict = NSMutableDictionary()
                    var emissions = [Int]()
                    var values = [Int]()
                    for (key, value) in dict{
                        if((key as AnyObject).contains("Percent emissions reduction for a plaque score of")){
                            tempdict.setValue(value, forKey: key as! String)
                            let str = NSMutableString()
                            str.append(key as! String)
                            str.replaceOccurrences(of: "Percent emissions reduction for a plaque score of ", with: "", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(0, str.length))
                            emissions.append(Int(str as String)!)
                            values.append(value as! Int)
                        }
                    }
                    ////print("Tempdict",tempdict,values,emissions)
                    self.wateremissions = emissions
                    self.watervalues = values
                }catch{
                    
                }
            }else{
                let emissions = [Int]()
                let values = [Int]()
                
                self.wateremissions = emissions
                self.watervalues = values
            }
        }
        
        if(dict["waste"] is NSNull || dict["waste"] == nil){
            let emissions = [Int]()
            let values = [Int]()
            self.wasteemissions = emissions
            self.wastevalues = values
        }else{
            if let waste = dict["waste"] as? NSDictionary, let info_json = waste["info_json"] as? String {
                var str = info_json
                let str1 = NSMutableString()
                str1.append(str)
                str1.replaceOccurrences(of: "'", with: "\"", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(0, str.characters.count))
                ////print(str1)
                str = str1.mutableCopy() as! String
                let jsonData = (str).data(using: String.Encoding.utf8)
                do {
                    dict = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    let tempdict = NSMutableDictionary()
                    var emissions = [Int]()
                    var values = [Int]()
                    for (key, value) in dict{
                        if((key as AnyObject).contains("Percent emissions reduction for a plaque score of")){
                            tempdict.setValue(value, forKey: key as! String)
                            let str = NSMutableString()
                            str.append(key as! String)
                            str.replaceOccurrences(of: "Percent emissions reduction for a plaque score of ", with: "", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(0, str.length))
                            emissions.append(Int(str as String)!)
                            values.append(value as! Int)
                        }
                    }
                    ////print("Tempdict",tempdict,values,emissions)
                    self.wasteemissions = emissions
                    self.wastevalues = values
                }catch{
                    
                }
            }else{
                let emissions = [Int]()
                let values = [Int]()
                self.wasteemissions = emissions
                self.wastevalues = values
            }
        }
        
        
        
        if(dict["transit"] is NSNull || dict["transit"] == nil){
            let emissions = [Int]()
            let values = [Int]()
            
            self.transitemissions = emissions
            self.transitvalues = values
        }else{
            if let water = dict["transit"] as? NSDictionary, let info_json = water["info_json"] as? String {
                
                var str = info_json
                let str1 = NSMutableString()
                str1.append(str)
                str1.replaceOccurrences(of: "'", with: "\"", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(0, str.characters.count))
                ////print(str1)
                str = str1.mutableCopy() as! String
                let jsonData = (str).data(using: String.Encoding.utf8)
                do {
                    dict = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    let tempdict = NSMutableDictionary()
                    var emissions = [Int]()
                    var values = [Int]()
                    for (key, value) in dict{
                        if((key as AnyObject).contains("Percent emissions reduction for a plaque score of")){
                            tempdict.setValue(value, forKey: key as! String)
                            let str = NSMutableString()
                            str.append(key as! String)
                            str.replaceOccurrences(of: "Percent emissions reduction for a plaque score of ", with: "", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(0, str.length))
                            emissions.append(Int(str as String)!)
                            values.append(value as! Int)
                        }
                    }
                    ////print("Tempdict",tempdict,values,emissions)
                    self.transitemissions = emissions
                    self.transitvalues = values
                }catch{
                    
                }
            }else{
                let emissions = [Int]()
                let values = [Int]()
                
                self.transitemissions = emissions
                self.transitvalues = values
            }
        }
        
        
        if(dict["human"] is NSNull || dict["human"] == nil){
            let emissions = [Int]()
            let values = [Int]()
            
            self.humanemissions = emissions
            self.humanvalues = values
        }else{
            if let human = dict["human"] as? NSDictionary, let info_json = human["info_json"] as? String {
                
                var str = info_json
                let str1 = NSMutableString()
                str1.append(str)
                str1.replaceOccurrences(of: "'", with: "\"", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(0, str.characters.count))
                ////print(str1)
                str = str1.mutableCopy() as! String
                let jsonData = (str).data(using: String.Encoding.utf8)
                do {
                    dict = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    let tempdict = NSMutableDictionary()
                    var emissions = [Int]()
                    var values = [Int]()
                    for (key, value) in dict{
                        if((key as AnyObject).contains("Percent emissions reduction for a plaque score of")){
                            tempdict.setValue(value, forKey: key as! String)
                            let str = NSMutableString()
                            str.append(key as! String)
                            str.replaceOccurrences(of: "Percent emissions reduction for a plaque score of ", with: "", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(0, str.length))
                            emissions.append(Int(str as String)!)
                            values.append(value as! Int)
                        }
                    }
                    ////print("Tempdict",tempdict,values,emissions)
                    self.humanemissions = emissions
                    self.humanvalues = values
                }catch{
                    
                }
            }else{
                let emissions = [Int]()
                let values = [Int]()
                
                self.humanemissions = emissions
                self.humanvalues = values
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
        DispatchQueue.main.async(execute: {
            self.view.isUserInteractionEnabled = true
            //self.tableview.alpha = 1.0
            //self.spinner.isHidden = true
            self.getmax("energy", arr: self.scoresarr)
        })
    }
    
    
    func getscores(_ leedid:Int, token:String){
        performancescoresarr.removeAllObjects()
        for index in 0...11 {
            ////print("Loop index: \(index)")
            
            let url = URL(string: "\(credentials().domain_url)assets/LEED:\(leedid)/scores/?at=\(datearr.object(at: index))&within=1")
            //print(url)
            let request = NSMutableURLRequest.init(url: url!)
            request.httpMethod = "GET"
            request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
            request.addValue("application/json", forHTTPHeaderField:"Content-type" )
            request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            self.download_requests.append(session)
            self.task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                var taskerror = false
                let httpStatus = response as? HTTPURLResponse
                if(error == nil){
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                        DispatchQueue.main.async(execute: {
                            self.spinner.isHidden = true
                            self.view.isUserInteractionEnabled = true
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                        })
                    } else
                        if (httpStatus!.statusCode != 200 && httpStatus!.statusCode != 201) {
                            taskerror = true
                        }else{
                            let jsonDictionary : NSDictionary
                            do {
                                jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                                ////print("Data \(index)",jsonDictionary)
                                DispatchQueue.main.async(execute: {
                                if(jsonDictionary["result"] == nil){
                                    self.scoresarr.add((jsonDictionary["scores"] as! NSDictionary).mutableCopy() as! NSMutableDictionary)
                                    self.reportedscores.add(jsonDictionary)
                                }else{
                                    var temp =  ["scores": [
                                        "energy": 0,
                                        "water": 0,
                                        "base": 0,
                                        "human_experience": 0,
                                        "waste": 0,
                                        "transport": 0
                                        ], "effective_at" : "\(self.datearr.object(at: index) as! String)"] as! NSDictionary
                                    
                                    self.reportedscores.add(temp)
                                }
                                })
                            } catch {
                                DispatchQueue.main.async(execute: {
                                var temp =  ["scores": [
                                    "energy": 0,
                                    "water": 0,
                                    "base": 0,
                                    "human_experience": 0,
                                    "waste": 0,
                                    "transport": 0
                                    ], "effective_at" : "\(self.datearr.object(at: index) as! String)"] as! NSDictionary
                                
                                self.reportedscores.add(temp)
                                })
                                ////print(error)
                            }
                            
                    }
                    
                    DispatchQueue.main.sync {
                        if (taskerror == true){
                            ////print(taskerror)
                            DispatchQueue.main.async(execute: {
                                self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                                return
                            })
                        } else {
                            
                            if(index == 11){
                                ////print("Scores arr",self.scoresarr)
                                self.getanalysis(leedid, token: token)
                                return
                            }
                        }
                    }
                }else{
                    return
                }
                
            })
            
            
            
            
            self.task.resume()
        }
    }

    
    func getanalysis(_ leedid:Int,token:String){
        let url = URL(string: "\(credentials().domain_url)assets/LEED:\(leedid)/analysis/")
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        
        
        let tasky = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
           
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401{
                DispatchQueue.main.async(execute: {
                    //self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
                return
            } else
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for httCALayer * individualforiphone = [CALayer layer];
                    //[self.layer addSublayer:individualforiphone];
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                    DispatchQueue.main.async(execute: {
                        let jsonDictionary : NSDictionary
                        do {
                            jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                            if(jsonDictionary["error"] != nil){
                                if let snapshotValue = jsonDictionary["error"] as? NSArray, let currentcountr = snapshotValue[0] as? NSDictionary, let currentstat = currentcountr["message"] as? String {
                                self.showalert(currentstat, title: "Error", action: "OK")
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
                    
                    let jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        self.analysisdict = jsonDictionary
                        //print(self.analysisdict)
                        DispatchQueue.main.async(execute: {
                            var dict = NSDictionary()
                            dict = self.analysisdict
                            if(dict["energy"] is NSNull || dict["energy"] == nil){
                                
                            }else{
                                let emissions = [Int]()
                                let values = [Int]()
                                self.energyemissions = emissions
                                self.energyvalues = values
                                if let human = dict["energy"] as? NSDictionary, let info_json = human["info_json"] as? String {
                                    var str = info_json
                                    let str1 = NSMutableString()
                                    str1.append(str)
                                    str1.replaceOccurrences(of: "'", with: "\"", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(0, str.characters.count))
                                    ////print(str1)
                                    str = str1.mutableCopy() as! String
                                    let jsonData = (str).data(using: String.Encoding.utf8)
                                    do {
                                        dict = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                                        let tempdict = NSMutableDictionary()
                                        var emissions = [Int]()
                                        var values = [Int]()
                                        for (key, value) in dict{
                                            if((key as! String).contains("Percent emissions reduction for a plaque score of")){
                                                tempdict.setValue(value, forKey: key as! String)
                                                let str = NSMutableString()
                                                str.append(key as! String)
                                                str.replaceOccurrences(of: "Percent emissions reduction for a plaque score of ", with: "", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(0, str.length))
                                                if(value as! Int > 0){
                                                emissions.append(Int(str as String)!)
                                                values.append(value as! Int)
                                                }
                                            }
                                        }
                                        ////print("Tempdict",tempdict,values,emissions)
                                        self.energyemissions = emissions
                                        self.energyvalues = values
                                    }catch{
                                        
                                    }
                                }else{
                                    let emissions = [Int]()
                                    let values = [Int]()
                                    self.energyemissions = emissions
                                    self.energyvalues = values
                                }
                            }

                            if(dict["water"] is NSNull || dict["water"] == nil){
                                let emissions = [Int]()
                                let values = [Int]()
                                
                                self.wateremissions = emissions
                                self.watervalues = values
                            }else{
                                    if let human = dict["water"] as? NSDictionary, let info_json = human["info_json"] as? String {
                                        var str = info_json
                                    
                                    let str1 = NSMutableString()
                                    str1.append(str)
                                    str1.replaceOccurrences(of: "'", with: "\"", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(0, str.characters.count))
                                    ////print(str1)
                                    str = str1.mutableCopy() as! String
                                    let jsonData = (str).data(using: String.Encoding.utf8)
                                    do {
                                        dict = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                                        let tempdict = NSMutableDictionary()
                                        var emissions = [Int]()
                                        var values = [Int]()
                                        for (key, value) in dict{
                                            if((key as! String).contains("Percent emissions reduction for a plaque score of")){
                                                tempdict.setValue(value, forKey: key as! String)
                                                let str = NSMutableString()
                                                str.append(key as! String)
                                                str.replaceOccurrences(of: "Percent emissions reduction for a plaque score of ", with: "", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(0, str.length))
                                                if(value as! Int > 0){
                                                emissions.append(Int(str as String)!)
                                                values.append(value as! Int)
                                                }
                                            }
                                        }
                                        ////print("Tempdict",tempdict,values,emissions)
                                        self.wateremissions = emissions
                                        self.watervalues = values
                                    }catch{
                                        
                                    }
                                    }else{
                                        let emissions = [Int]()
                                        let values = [Int]()
                                        
                                        self.wateremissions = emissions
                                        self.watervalues = values
                                    }
                            }

                            dict = self.analysisdict
                            if(dict["waste"] is NSNull || dict["waste"] == nil){
                                let emissions = [Int]()
                                let values = [Int]()
                                
                                self.wasteemissions = emissions
                                self.wastevalues = values
                            }else{
                                if let human = dict["waste"] as? NSDictionary, let info_json = human["info_json"] as? String {
                                    var str = info_json
                                    let str1 = NSMutableString()
                                    str1.append(str)
                                    str1.replaceOccurrences(of: "'", with: "\"", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(0, str.characters.count))
                                    ////print(str1)
                                    str = str1.mutableCopy() as! String
                                    let jsonData = (str).data(using: String.Encoding.utf8)
                                    do {
                                        dict = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                                        let tempdict = NSMutableDictionary()
                                        var emissions = [Int]()
                                        var values = [Int]()
                                        for (key, value) in dict{
                                            if((key as! String).contains("Percent emissions reduction for a plaque score of")){
                                                tempdict.setValue(value, forKey: key as! String)
                                                let str = NSMutableString()
                                                str.append(key as! String)
                                                str.replaceOccurrences(of: "Percent emissions reduction for a plaque score of ", with: "", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(0, str.length))
                                                if(value as! Int > 0){
                                                emissions.append(Int(str as String)!)
                                                values.append(value as! Int)
                                                }
                                            }
                                        }
                                        ////print("Tempdict",tempdict,values,emissions)
                                        self.wasteemissions = emissions
                                        self.wastevalues = values
                                    }catch{
                                        
                                    }
                                }else{
                                    let emissions = [Int]()
                                    let values = [Int]()
                                    
                                    self.wasteemissions = emissions
                                    self.wastevalues = values
                                }
                            }

                            dict = self.analysisdict
                            if(dict["transit"] is NSNull || dict["transit"] == nil){
                                let emissions = [Int]()
                                let values = [Int]()
                                
                                self.transitemissions = emissions
                                self.transitvalues = values
                            }else{
                                    if let human = dict["transit"] as? NSDictionary, let info_json = human["info_json"] as? String {
                                        var str = info_json
                                    let str1 = NSMutableString()
                                    str1.append(str)
                                    str = str.replacingOccurrences(of: "\"", with: "\"")
                                    str = str.replacingOccurrences(of: "'", with: "\"")
                                    str = str.replacingOccurrences(of: "None", with: "\"\"")
                                    ////print(str1)
                                    //str = str1.mutableCopy() as! String
                                    let jsonData = (str).data(using: String.Encoding.utf8)
                                    do {
                                        dict = try JSONSerialization.jsonObject(with: jsonData!, options: .mutableContainers) as! NSDictionary
                                        let tempdict = NSMutableDictionary()
                                        var emissions = [Int]()
                                        var values = [Int]()
                                        for (key, value) in dict{
                                            if((key as! String).contains("Percent emissions reduction for a plaque score of")){
                                                tempdict.setValue(value, forKey: key as! String)
                                                let str = NSMutableString()
                                                str.append(key as! String)
                                                str.replaceOccurrences(of: "Percent emissions reduction for a plaque score of ", with: "", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(0, str.length))
                                                if(value as! Int > 0){
                                                emissions.append(Int(str as String)!)
                                                values.append(value as! Int)
                                                }
                                            }
                                        }
                                        ////print("Tempdict",tempdict,values,emissions)
                                        self.transitemissions = emissions
                                        self.transitvalues = values
                                    }catch{
                                        
                                    }
                                    }else{
                                        let emissions = [Int]()
                                        let values = [Int]()
                                        
                                        self.transitemissions = emissions
                                        self.transitvalues = values
                                    }
                            }
                
                            dict = self.analysisdict
                            if(dict["human"] is NSNull || dict["human"] == nil){
                                let emissions = [Int]()
                                let values = [Int]()
                                
                                self.humanemissions = emissions
                                self.humanvalues = values
                            }else{
                                if let human = dict["human"] as? NSDictionary, let info_json = human["info_json"] as? String {
                                    var str = info_json
                                    let str1 = NSMutableString()
                                    str1.append(str)
                                    str1.replaceOccurrences(of: "'", with: "\"", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(0, str.characters.count))
                                    ////print(str1)
                                    str = str1.mutableCopy() as! String
                                    let jsonData = (str).data(using: String.Encoding.utf8)
                                    do {
                                        dict = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                                        let tempdict = NSMutableDictionary()
                                        var emissions = [Int]()
                                        var values = [Int]()
                                        for (key, value) in dict{
                                            if((key as! String).contains("Percent emissions reduction for a plaque score of")){
                                                tempdict.setValue(value, forKey: key as! String)
                                                let str = NSMutableString()
                                                str.append(key as! String)
                                                str.replaceOccurrences(of: "Percent emissions reduction for a plaque score of ", with: "", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(0, str.length))
                                                if(value as! Int > 0){
                                                emissions.append(Int(str as String)!)
                                                values.append(value as! Int)
                                                }
                                            }
                                        }
                                        ////print("Tempdict",tempdict,values,emissions)
                                        self.humanemissions = emissions
                                        self.humanvalues = values
                                    }catch{
                                        
                                    }
                                }else{
                                    let emissions = [Int]()
                                    let values = [Int]()
                                    
                                    self.humanemissions = emissions
                                    self.humanvalues = values
                                }
                            }

                            
                            dict = self.analysisdict
                            var str = ""
                            var str1 = NSMutableString()
                            if let energy = self.analysisdict["energy"] as? NSDictionary, let info_json = energy["info_json"] as? String{
                                str = info_json
                                
                                str1.append(str)
                                str = str.replacingOccurrences(of: "\"", with: "\"")
                                str = str.replacingOccurrences(of: "'", with: "\"")
                                str = str.replacingOccurrences(of: "None", with: "\"\"")
                                
                                
                                ////print(str1)
                                //str = str1.mutableCopy() as! String
                                dict = NSDictionary()
                            }
                            ////print(str)
                            do {
                                if(self.convertStringToDictionary(str) != nil){
                                    dict = self.convertStringToDictionary(str)! as NSDictionary
                                }
                                
                            }catch{
                                
                            }
                            var sortedKeys = (dict.allKeys as! [String]).sorted()
                            
                            var mut = NSMutableDictionary()
                            var mut1 = NSMutableDictionary()
                            var info_json = dict
                            var intarr = [Int]()
                            var intarr1 = [Int]()
                            for (key,value) in info_json{
                                var s = key as! String
                                var s1 = key as! String
                                if(s.contains("Energy Plaque Score with") && s.contains("Lower Emissions") && !s.contains("More Density and")){
                                    
                                    s = s.replacingOccurrences(of: "Lower Emissions", with: "")
                                    s = s.replacingOccurrences(of: "Energy Plaque Score with", with: "")
                                    s = s.replacingOccurrences(of: " ", with: "")
                                    s = s.replacingOccurrences(of: "%", with: "")
                                    
                                    //print(s)
                                    if(value as! Int > 0){
                                    intarr.append(Int(s)!)
                                    mut.setValue(value, forKey: s)
                                    }
                                }else if(s1.contains("Percent emissions reduction for a plaque score of ")){
                                    s1 = s1.replacingOccurrences(of: "Percent emissions reduction for a plaque score of ", with: "")
                                    if(value as! Int > 0){
                                    intarr1.append(Int(s1)!)
                                    mut1.setValue(value, forKey: s1)
                                    }
                                }
                            }
                            //print(mut)
                            var tempdict = NSMutableDictionary()
                            var a = intarr.sorted()
                            self.energypercentage = a
                            for item in self.energypercentage{
                                //print(item)
                                self.energyscores.add("\(mut["\(item)"] as! Int)")
                            }
                            
                            a = intarr1.sorted()
                            self.energypercentage1 = a
                            for item in self.energypercentage1{
                                //print(item)
                                self.energyscores1.add("\(mut1["\(item)"] as! Int)")
                            }
                            
                            
                            
                            dict = self.analysisdict
                            if let water = self.analysisdict["water"] as? NSDictionary, let info_json = water["info_json"] as? String{
                                str = info_json
                                str1 = NSMutableString()
                                str1.append(str)
                                
                                str = str.replacingOccurrences(of: "\"", with: "\"")
                                str = str.replacingOccurrences(of: "'", with: "\"")
                                str = str.replacingOccurrences(of: "None", with: "\"\"")
                                ////print(str1)
                                //str = str1.mutableCopy() as! String
                            }
                            dict = NSDictionary()
                            
                            ////print(str)
                            do {
                                if(self.convertStringToDictionary(str) != nil){
                                    dict = self.convertStringToDictionary(str)! as NSDictionary
                                }
                                
                            }catch{
                                
                            }
                            sortedKeys = (dict.allKeys as! [String]).sorted()
                            mut = NSMutableDictionary()
                            mut1 = NSMutableDictionary()
                            info_json = dict
                            intarr = [Int]()
                            intarr1 = [Int]()
                            for (key,value) in info_json{
                                var s = key as! String
                                var s1 = key as! String
                                if(s.contains("Water Plaque Score with") && s.contains("Lower Emissions") && !s.contains("More Density and")){
                                    s = s.replacingOccurrences(of: "Lower Emissions", with: "")
                                    s = s.replacingOccurrences(of: "Water Plaque Score with", with: "")
                                    s = s.replacingOccurrences(of: " ", with: "")
                                    s = s.replacingOccurrences(of: "%", with: "")
                                    //print(s)
                                    if(value as! Int > 0){
                                    intarr.append(Int(s)!)
                                    mut.setValue(value, forKey: s)
                                    }
                                }else if(s1.contains("Percent emissions reduction for a plaque score of ")){
                                    s1 = s1.replacingOccurrences(of: "Percent emissions reduction for a plaque score of ", with: "")
                                    if(value as! Int > 0){
                                    intarr1.append(Int(s1)!)
                                    mut1.setValue(value, forKey: s1)
                                    }
                                }
                            }
                            //print(mut)
                            tempdict = NSMutableDictionary()
                            a = intarr.sorted()
                            self.waterpercentage = a
                            for item in self.waterpercentage{
                                //print(item)
                                self.waterscores.add("\(mut["\(item)"] as! Int)")
                            }
                            
                            a = intarr1.sorted()
                            self.waterpercentage1 = a
                            for item in self.waterpercentage1{
                                //print(item)
                                self.waterscores1.add("\(mut1["\(item)"] as! Int)")
                            }
                            
                            dict = self.analysisdict
                            if let water = self.analysisdict["waste"] as? NSDictionary, let info_json = water["info_json"] as? String{
                                str = info_json
                                str1 = NSMutableString()
                                str1.append(str)
                                str = str.replacingOccurrences(of: "\"", with: "\"")
                                str = str.replacingOccurrences(of: "'", with: "\"")
                                str = str.replacingOccurrences(of: "None", with: "\"\"")
                                ////print(str1)
                                //str = str1.mutableCopy() as! String
                            }
                            dict = NSDictionary()
                            ////print(str)
                            do {
                                if(self.convertStringToDictionary(str) != nil){
                                    dict = self.convertStringToDictionary(str)! as NSDictionary
                                }
                                
                            }catch{
                                
                            }
                            sortedKeys = (dict.allKeys as! [String]).sorted()
                            
                            mut = NSMutableDictionary()
                            mut1 = NSMutableDictionary()
                            info_json = dict
                            intarr = [Int]()
                            intarr1 = [Int]()
                            for (key,value) in info_json{
                                var s = key as! String
                                var s1 = key as! String
                                if(s.contains("Waste Plaque Score with") && s.contains("Lower Emissions") && !s.contains("More Density and")){
                                    s = s.replacingOccurrences(of: "Lower Emissions", with: "")
                                    s = s.replacingOccurrences(of: "Waste Plaque Score with", with: "")
                                    s = s.replacingOccurrences(of: " ", with: "")
                                    s = s.replacingOccurrences(of: "%", with: "")
                                    //print(s)
                                    if(value as! Int > 0){
                                    intarr.append(Int(s)!)
                                    mut.setValue(value, forKey: s)
                                    }
                                }else if(s1.contains("Percent emissions reduction for a plaque score of ")){
                                    s1 = s1.replacingOccurrences(of: "Percent emissions reduction for a plaque score of ", with: "")
                                    if(value as! Int > 0){
                                    intarr1.append(Int(s1)!)
                                    mut1.setValue(value, forKey: s1)
                                    }
                                }
                            }
                            //print(mut)
                            tempdict = NSMutableDictionary()
                            a = intarr.sorted()
                            self.wastepercentage = a
                            for item in self.wastepercentage{
                                //print(item)
                                self.wastescores.add("\(mut["\(item)"] as! Int)")
                            }
                            
                            a = intarr1.sorted()
                            self.wastepercentage1 = a
                            for item in self.wastepercentage1{
                                //print(item)
                                self.wastescores1.add("\(mut1["\(item)"] as! Int)")
                            }
                            
                            
                            dict = self.analysisdict
                            if let water = self.analysisdict["transit"] as? NSDictionary, let info_json = water["info_json"] as? String{
                                str = info_json
                                str1 = NSMutableString()
                                str1.append(str)
                                str = str.replacingOccurrences(of: "\"", with: "\"")
                                str = str.replacingOccurrences(of: "'", with: "\"")
                                str = str.replacingOccurrences(of: "None", with: "\"\"")
                            }
                            ////print(str1)
                            //str = str1.mutableCopy() as! String
                            dict = NSDictionary()
                            
                            ////print(str)
                            do {
                                if(self.convertStringToDictionary(str) != nil){
                                    dict = self.convertStringToDictionary(str)! as NSDictionary
                                }
                                
                            }catch{
                                
                            }
                            sortedKeys = (dict.allKeys as! [String]).sorted()
                            //print(self.transitemissions,self.transitvalues)
                            mut = NSMutableDictionary()
                            mut1 = NSMutableDictionary()
                            info_json = dict
                            intarr = [Int]()
                            intarr1 = [Int]()
                            for (key,value) in info_json{
                                var s = key as! String
                                var s1 = key as! String
                                if(s.contains("Transportation Plaque Score with") && s.contains("Lower Emissions") && !s.contains("More Density and")){
                                    s = s.replacingOccurrences(of: "Lower Emissions", with: "")
                                    s = s.replacingOccurrences(of: "Transportation Plaque Score with", with: "")
                                    s = s.replacingOccurrences(of: " ", with: "")
                                    s = s.replacingOccurrences(of: "%", with: "")
                                    //print(s)
                                    if(value as! Int > 0){
                                    intarr.append(Int(s)!)
                                    mut.setValue(value, forKey: s)
                                    }
                                }else if(s1.contains("Percent emissions reduction for a plaque score of ")){
                                    s1 = s1.replacingOccurrences(of: "Percent emissions reduction for a plaque score of ", with: "")
                                    if(value as! Int > 0){
                                    intarr1.append(Int(s1)!)
                                    mut1.setValue(value, forKey: s1)
                                    }
                                }
                            }
                            //print(mut)
                            tempdict = NSMutableDictionary()
                            a = intarr.sorted()
                            self.transportpercentage = a
                            for item in self.transportpercentage{
                                //print(item)
                                self.transportscores.add("\(mut["\(item)"] as! Int)")
                            }
                            
                            a = intarr1.sorted()
                            self.transportpercentage1 = a
                            for item in self.transportpercentage1{
                                //print(item)
                                self.transportscores1.add("\(mut1["\(item)"] as! Int)")
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
                            self.view.isUserInteractionEnabled = true
                            //self.spinner.isHidden = true
                            //print(self.analysisdict)
                            //self.tableview.alpha = 1.0
                            self.getmax("energy", arr: self.scoresarr)
                            self.getperformancedata(credentials().subscription_key, leedid: leedid, date: "")
                        })
                        
                    } catch {
                        DispatchQueue.main.async(execute: {
                            let jsonDictionary : NSDictionary
                            do {
                                jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                                if(jsonDictionary["error"] != nil){
                                    if let snapshotValue = jsonDictionary["error"] as? NSArray, let currentcountr = snapshotValue[0] as? NSDictionary, let currentstat = currentcountr["message"] as? String {
                                self.showalert(currentstat, title: "Error", action: "OK")
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
            
    })

tasky.resume()
            
            
            /*
            
            var taskerror = false
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401 {           // check for http errors
                dispatch_async(dispatch_get_main_queue(), {
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                })
            }else{
                
                
                if error == nil {
                    
                    
                    
                    var jsonDictionary : NSDictionary
                    do {
         
         
         
                        dispatch_async(dispatch_get_main_queue(), {
         
                        })
                    } catch {
                        
                    }
                    
                    
                } else {
                    taskerror = true
                }
 
 
 
            }
        })
        
 */
    
    }

    
    
    func getmax(_ type:String,arr:NSMutableArray){
        var temparr = [Int]()
        
        for d in arr{
            let dict = d as! NSDictionary
            if(dict[type] is NSNull){
                temparr.append(0)
            }else{
                temparr.append(dict[type] as! Int)
            }
        }
        
        if(temparr.count > 0){
            if(type == "energy"){
                energymax = temparr.max()!
                self.getmax("water", arr: self.scoresarr)
            }else if(type == "water"){
                watermax = temparr.max()!
                self.getmax("waste", arr: self.scoresarr)
            }else if(type == "waste"){
                wastemax = temparr.max()!
                self.getmax("transport", arr: self.scoresarr)
            }else if(type == "transport"){
                transportmax = temparr.max()!
                self.getmax("human_experience", arr: self.scoresarr)
            }else if(type == "human_experience"){
                humanmax = temparr.max()!
                self.getmin("energy", arr: self.scoresarr)
            }
        }
    }
    
    
    func getmin(_ type:String,arr:NSMutableArray){
        var temparr = [Int]()
        if(arr.count > 0){
            for d in arr{
                var dict = d as! NSDictionary
                ////print(dict)
                if(dict[type] is NSNull){
                    temparr.append(0)
                }else{
                    temparr.append(dict[type] as! Int)
                }
            }
            if(temparr.count > 0){
                if(type == "energy"){
                    energymin = temparr.min()!
                    self.getmin("water", arr: self.scoresarr)
                }else if(type == "water"){
                    watermin = temparr.min()!
                    self.getmin("waste", arr: self.scoresarr)
                }else if(type == "waste"){
                    wastemin = temparr.min()!
                    self.getmin("transport", arr: self.scoresarr)
                }else if(type == "transport"){
                    transportmin = temparr.min()!
                    self.getmin("human_experience", arr: self.scoresarr)
                }else if(type == "human_experience"){
                    humanmin = temparr.min()!
                    self.gethighlowscores(self.scoresarr)
                    isloaded = true
                    self.tableview.reloadData()
                }
            }
        }
    }
    
    func gethighlowscores(_ arr:NSMutableArray){
        var tempp = 0
        var fullarr = [Int]()
        for dict in arr{
            ////print(dict)
            let temp = dict as! NSMutableDictionary
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
            highduringreport = fullarr.max()!
            lessduringreport = fullarr.min()!
        }
        
    }

    //analysis,scores,certifications, getscores
    
    
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
        self.download_requests.append(session)
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
                    self.spinner.isHidden = true
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
                        self.performancedata  = jsonDictionary
                        
                        if(self.performancedata["scores"] != nil){
                            var temparr = (self.performancedata["scores"] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                            if(temparr["energy"] is NSNull){
                                self.currentscore += 0
                                self.energyscore = 0
                            }else{
                                self.currentscore += temparr["energy"] as! Int
                                self.energyscore = temparr["energy"] as! Int
                            }
                            if(temparr["water"] is NSNull){
                                self.currentscore += 0
                                self.waterscore = 0
                            }else{
                                self.currentscore += temparr["water"] as! Int
                                self.waterscore = temparr["water"] as! Int
                            }
                            if(temparr["waste"] is NSNull){
                                self.currentscore += 0
                                self.wastescore = 0
                            }else{
                                self.currentscore += temparr["waste"] as! Int
                                self.wastescore = temparr["waste"] as! Int
                            }
                            if(temparr["transport"] is NSNull){
                                self.currentscore += 0
                                self.transportscore = 0
                            }else{
                                self.currentscore += temparr["transport"] as! Int
                                self.transportscore = temparr["transport"] as! Int
                            }
                            if(temparr["human_experience"] is NSNull){
                                self.currentscore += 0
                                self.humanscore = 0
                            }else{
                                self.currentscore += temparr["human_experience"] as! Int
                                self.humanscore = temparr["human_experience"] as! Int
                            }
                            if(temparr["base"] is NSNull){
                                self.currentscore += 0
                            }else{
                                self.currentscore += temparr["base"] as! Int
                            }
                            self.dontchange = self.currentscore
                            
                        }
                        
                        if(self.performancedata["maxima"] != nil){
                            var temparr = (self.performancedata["maxima"] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                            if(temparr["energy"] is NSNull){
                                self.maxscore += 0
                                self.energymaxscore = 0
                            }else{
                                self.maxscore += temparr["energy"] as! Int
                                self.energymaxscore = temparr["energy"] as! Int
                            }
                            if(temparr["water"] is NSNull){
                                self.maxscore += 0
                                self.watermaxscore = 0
                            }else{
                                self.watermaxscore = temparr["water"] as! Int
                                self.maxscore += temparr["water"] as! Int
                            }
                            if(temparr["waste"] is NSNull){
                                self.maxscore += 0
                                self.wastemaxscore = 0
                            }else{
                                self.maxscore += temparr["waste"] as! Int
                                self.wastemaxscore = temparr["waste"] as! Int
                            }
                            if(temparr["transport"] is NSNull){
                                self.maxscore += 0
                                self.transportmaxscore = 0
                            }else{
                                self.maxscore += temparr["transport"] as! Int
                                self.transportmaxscore = temparr["transport"] as! Int
                            }
                            if(temparr["human_experience"] is NSNull){
                                self.maxscore += 0
                                self.humanmaxscore = 0
                            }else{
                                self.maxscore += temparr["human_experience"] as! Int
                                self.humanmaxscore = temparr["human_experience"] as! Int
                            }
                            if(temparr["base"] is NSNull){
                                self.maxscore += 0
                            }else{
                                self.maxscore += temparr["base"] as! Int
                            }
                        }
                        
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
                                        dict["energy"] = scores["energy"]as! AnyObject?
                                    }
                                    
                                    if(scores["water"] == nil || scores["water"] is NSNull){
                                        dict["water"] = 0
                                    }else{
                                        dict["water"] = scores["water"]as! AnyObject?
                                    }
                                    
                                    if(scores["waste"] == nil || scores["waste"] is NSNull){
                                        dict["waste"] = 0
                                    }else{
                                        dict["waste"] = scores["waste"]as! AnyObject?
                                    }
                                    
                                    if(scores["transport"] == nil || scores["transport"] is NSNull){
                                        dict["transport"] = 0
                                    }else{
                                        dict["transport"] = scores["transport"]as! AnyObject?
                                    }
                                    
                                    if(scores["base"] == nil || scores["base"] is NSNull){
                                        dict["base"] = 0
                                    }else{
                                        dict["base"] = scores["base"]as! AnyObject?
                                    }
                                    
                                    if(scores["human_experience"] == nil || scores["human_experience"] is NSNull){
                                        dict["human_experience"] = 0
                                    }else{
                                        dict["human_experience"] = scores["human_experience"]as! AnyObject?
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
                            self.certdetails(credentials().subscription_key, leedid: self.buildingdetails["leed_id"] as! Int)
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

    
    func certdetails(_ subscription_key:String, leedid: Int){
        let url = URL.init(string: String(format: "%@assets/LEED:%d/certifications/",credentials().domain_url,leedid))
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        var token = UserDefaults.standard.object(forKey: "token") as! String
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-Type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        //print(url?.absoluteURL,token)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        self.download_requests.append(session)
        self.task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401{
                DispatchQueue.main.async(execute: {
                    //self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
                return
            } else
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for httCALayer * individualforiphone = [CALayer layer];
                    //[self.layer addSublayer:individualforiphone];
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                    DispatchQueue.main.async(execute: {
                        let jsonDictionary : NSDictionary
                        do {
                            jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                            if(jsonDictionary["error"] != nil){
                                if let snapshotValue = jsonDictionary["error"] as? NSArray, let currentcountr = snapshotValue[0] as? NSDictionary, let currentstat = currentcountr["message"] as? String {
                                self.showalert(currentstat, title: "Error", action: "OK")
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
                    
                    let jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        //print(jsonDictionary)
                        let datakeyed = NSKeyedArchiver.archivedData(withRootObject: jsonDictionary)
                        self.certificationsdict = jsonDictionary
                        DispatchQueue.main.async(execute: {
                            self.spinner.isHidden = true
                            self.tableview.alpha = 1
                            let datakeyed = NSKeyedArchiver.archivedData(withRootObject: jsonDictionary)
                            UserDefaults.standard.set(datakeyed, forKey: "certification_details")
                            UserDefaults.standard.set(0, forKey: "grid")
                            self.tableview.reloadData()
                            if(self.download_requests.count > 0){
                                //NotificationCenter.default.post(name: Notification.Name(rawValue: "performrootsegue"), object: nil, userInfo: ["seguename":"totalanalysis"])
                            }
                            //self.getcomparablesdata(subscription_key, leedid: leedid)
                        })
                        
                    } catch {
                        DispatchQueue.main.async(execute: {
                            let jsonDictionary : NSDictionary
                            do {
                                jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                                if(jsonDictionary["error"] != nil){
                                    if let snapshotValue = jsonDictionary["error"] as? NSArray, let currentcountr = snapshotValue[0] as? NSDictionary, let currentstat = currentcountr["message"] as? String {
                                self.showalert(currentstat, title: "Error", action: "OK")
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
            
        }) 
        task.resume()
    }

var certificationsdict = NSDictionary()
    
    func showalert(_ message:String, title:String, action:String){
        
        //let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        //let callActionHandler = { (action:UIAlertAction!) -> Void in
        DispatchQueue.main.async(execute: {
            self.view.isUserInteractionEnabled = true
            self.spinner.isHidden = true
            self.tableview.alpha = 1.0
            self.maketoast(message, type: "error")
            // self.navigationController?.popViewControllerAnimated(true)
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        DispatchQueue.main.async(execute: {
            let t = self.download_requests
            for r in 0 ..< t.count
            {
                let request = t[r] as! URLSession
                request.invalidateAndCancel()
            }
        })
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
        self.download_requests.append(session)
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
                    self.spinner.isHidden = true
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
        self.download_requests.append(session)
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
                    self.spinner.isHidden = true
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
                            self.tableview.alpha = 1
                            //make navigation bar unresponsive
                            if(self.navigationController != nil){
                                //self.navigationController!.view.userInteractionEnabled = true
                            }
                            //self.tabbar.userInteractionEnabled = true
                            self.view.isUserInteractionEnabled = false
                            if(self.download_requests.count > 0){
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "performrootsegue"), object: nil, userInfo: ["seguename":"totalanalysis"])
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

    

var emptydict = ["count": 1,"created_at_max": "2016-12-30T14:02:41.260478Z","created_at_min": "2016-12-30T14:02:41.260478Z","energy_avg": 0,"water_avg": 0,"waste_avg": 0,"transport_avg": 0,"base_avg": 0,"human_experience_avg": 0] as [String : Any]

    func convertStringToDictionary(_ text: String) -> NSMutableDictionary? {
        if let data = text.data(using: String.Encoding.utf8){
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSMutableDictionary
                return json
            } catch {
                //print("Something went wrong")
            }
        }
        return nil
    }


    var energypercentage = [Int]()
    var energyscores = NSMutableArray()
    
    var waterpercentage = [Int]()
    var waterscores = NSMutableArray()
    
    var wastepercentage = [Int]()
    var wastescores = NSMutableArray()
    
    var transportpercentage = [Int]()
    var transportscores = NSMutableArray()
    
    var energypercentage1 = [Int]()
    var energyscores1 = NSMutableArray()
    
    var waterpercentage1 = [Int]()
    var waterscores1 = NSMutableArray()
    
    var wastepercentage1 = [Int]()
    var wastescores1 = NSMutableArray()
    
    var transportpercentage1 = [Int]()
    var transportscores1 = NSMutableArray()
    
    

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "Analytics"
        }
        else if(section == 7){
            if(certificationsdict["certificates"] != nil){
                let d = certificationsdict["certificates"] as! NSArray
                if(d.count > 0){
                    return "certifications"
                }
            }
            return "NO CERTIFICATIONS FOUND"
        }
        
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section > 6){
            return 50
        }
        
        if(indexPath.section == 0){
            return 0.158 * UIScreen.main.bounds.size.height
        }
        
        return 0.105 * UIScreen.main.bounds.size.height
    }
    
    var currentcategory = ""
    ///assets/LEED:' + project_id + '/analysis/recompute/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if(segue.identifier == "gotodetails"){
            let v = segue.destination as! details
            v.reportedscores = reportedscores
            
            v.currentcategory = currentcategory
            v.details_dict1 = dict1
            v.details_dict2 = dict2
            v.currentscore = currentscore
            if(currentcategory == "Energy"){
                v.name = "energy"
                v.percentagearr = NSMutableArray.init(array: energypercentage)
                v.reductionarr = energyscores
                v.reductionarr1 = energyscores1
                v.percentagearr1 = NSMutableArray.init(array: energypercentage1)
                v.percentagearr1 = NSMutableArray.init(array:energyvalues)
                v.reductionarr1 = NSMutableArray.init(array:energyemissions)
                v.currentscore = energyscore
            }else if(currentcategory == "Water"){
                v.name = "water"
                v.percentagearr = NSMutableArray.init(array: waterpercentage)
                v.reductionarr = waterscores
                v.reductionarr1 = waterscores1
                v.percentagearr1 = NSMutableArray.init(array: waterpercentage1)
                v.percentagearr1 = NSMutableArray.init(array:watervalues)
                v.reductionarr1 = NSMutableArray() //NSMutableArray.init(array:wateremissions)
                v.currentscore = waterscore
            }else if(currentcategory == "Waste"){
                v.name = "waste"
                v.percentagearr = NSMutableArray.init(array: wastepercentage)
                v.reductionarr = wastescores
                v.reductionarr1 = wastescores1
                v.percentagearr1 = NSMutableArray.init(array: wastepercentage1)
                v.percentagearr1 = NSMutableArray.init(array:wastevalues)
                v.reductionarr1 = NSMutableArray.init(array:wasteemissions)
                v.currentscore = wastescore
            }else if(currentcategory == "Transportation"){
                v.name = "transportation"
                v.percentagearr = NSMutableArray.init(array: transportpercentage)
                v.reductionarr = transportscores
                v.percentagearr1 = NSMutableArray.init(array:transitvalues)
                v.reductionarr1 = NSMutableArray.init(array:transitemissions)
                v.currentscore = transportscore
            }else{
                v.name = "human experience"
            }
        }
    }
    var dict1 = NSArray()
    var dict2 = NSArray()
    var dontchange = 0
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        for i in 0..<reportedscores.count{
            let dict = reportedscores[i] as! NSDictionary
            let dict1 = dict["scores"] as! NSDictionary
            print(dict1["transport"])
        }
        if(indexPath.section == 2){
            if let s = ((scoresarray["scores"] as! NSDictionary).mutableCopy() as? NSMutableDictionary)?["energy"] as? Int{
                currentscore = s
            }
            currentcategory = "Energy"
            var temp = NSMutableArray()
            var temp1 = NSMutableArray()
            var dict = self.analysisdict
            
            if(dict["energy"] is NSNull || dict["energy"] == nil){
                let emissions = [Int]()
                let values = [Int]()
                self.energyemissions = emissions
                self.energyvalues = values
            }else{
                if let energy = dict["energy"] as? NSDictionary, let info_json = energy["info_json"] as? String {
                    var str = info_json
                    var str1 = NSMutableString()
                    str1.append(str)
                    str1.replaceOccurrences(of: "'", with: "\"", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(0, str.characters.count))
                    ////print(str1)
                    str1.replaceOccurrences(of: "None", with: "\"\"", options: NSString.CompareOptions.caseInsensitive , range: NSMakeRange(0, str.characters.count))
                    
                    str = str1.mutableCopy() as! String
                    let jsonData = (str).data(using: String.Encoding.utf8)
                    do {
                        dict = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        let tempdict = NSMutableDictionary()
                        var emissions = [Int]()
                        var values = [Int]()
                        for (key, value) in dict{
                            if((key as AnyObject).contains("Scope2 Raw GHG (mtCO2e/day)")){
                                temp.add("Raw GHG")
                                temp1.add(String(format:"%.4f mtCO2e",dict["Scope2 Raw GHG (mtCO2e/day)"] as! Float
))
                            }else if((key as AnyObject).contains("Temperature adjusted GHG")){
                                temp.add("Adjusted GHG")
                                temp1.add(String(format:"%.4f mtCO2e",dict["Temperature adjusted GHG"] as! Float
                                    ))
                            }else if((key as AnyObject).contains("Adjusted Emissions per Occupant")){
                                temp.add("Adjusted Emissions per Occupant")
                                temp1.add(String(format:"%.4f mtCO2e/person",dict["Adjusted Emissions per Occupant"] as! Float
                                    ))
                            }else if((key as AnyObject).contains("Adjusted Emissions per SF")){
                                temp.add("Adjusted Emissions per Sq.ft")
                                temp1.add(String(format:"%.4f mtCO2e/sq.ft",dict["Adjusted Emissions per SF"] as! Float
                                    ))
                            }else if((key as AnyObject).contains("Months of Energy Data")){
                                temp.add("Months of Energy Data")
                                temp1.add(String(format:"%d",dict["Months of Energy Data"] as! Int
                                    ))
                            }else if((key as AnyObject).contains("Months of Temperature Data")){
                                temp.add("Months of Temperature Data")
                                temp1.add(String(format:"%d",dict["Months of Temperature Data"] as! Int
                                    ))
                            }
                            
                        }
                        ////print("Tempdict",tempdict,values,emissions)
                        
                        dict1 = temp
                        dict2 = temp1
                        
                        
                    }catch{
                        
                    }
                }else{
                    let emissions = [Int]()
                    let values = [Int]()
                    self.energyemissions = emissions
                    self.energyvalues = values
                }
            }
            self.performSegue(withIdentifier: "gotodetails", sender: nil)
        }else if(indexPath.section == 3){
            currentcategory = "Water"
            if let s = ((scoresarray["scores"] as! NSDictionary).mutableCopy() as? NSMutableDictionary)?["water"] as? Int{
                currentscore = s
            }
            
            
            var temp = NSMutableArray()
            var temp1 = NSMutableArray()
            var dict = self.analysisdict
            
            if(dict["water"] is NSNull || dict["water"] == nil){
                let emissions = [Int]()
                let values = [Int]()
                self.wateremissions = emissions
                self.watervalues = values
            }else{
                    if let energy = dict["water"] as? NSDictionary, let info_json = energy["info_json"] as? String {
                        var str = info_json
                    var str1 = NSMutableString()
                    str1.append(str)
                    str1.replaceOccurrences(of: "'", with: "\"", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(0, str.characters.count))
                    ////print(str1)
                    str1.replaceOccurrences(of: "None", with: "\"\"", options: NSString.CompareOptions.caseInsensitive , range: NSMakeRange(0, str.characters.count))
                    
                    str = str1.mutableCopy() as! String
                    let jsonData = (str).data(using: String.Encoding.utf8)
                    do {
                        dict = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        let tempdict = NSMutableDictionary()
                        var emissions = [Int]()
                        var values = [Int]()
                        for (key, value) in dict{
                            if((key as AnyObject).contains("Raw Water Use (gallons/day)")){
                                temp.add("Raw Water Use")
                                temp1.add(String(format:"%.4f (gallons/day)",dict["Raw Water Use (gallons/day)"] as! Float
                                    ))
                            }else if((key as AnyObject).contains("Operating Hours adjusted Water Use")){
                                temp.add("Adjusted water use")
                                temp1.add(String(format:"%.4f (gallons/person)",dict["Operating Hours adjusted Water Use"] as! Float
                                    ))
                            }else if((key as AnyObject).contains("Adjusted Gallons per SF")){
                                temp.add("Adjusted Gallons per SF")
                                temp1.add(String(format:"%.4f (gallons/sq.ft)",dict["Adjusted Gallons per SF"] as! Float
                                    ))
                            }else if((key as AnyObject).contains("Months of Water Data")){
                                temp.add("Months of Water Data")
                                temp1.add(String(format:"%d",dict["Months of Water Data"] as! Int
                                    ))
                            }
                            
                        }
                        ////print("Tempdict",tempdict,values,emissions)
                        
                        dict1 = temp
                        dict2 = temp1
                        
                        
                    }catch{
                        
                    }
                    }else{
                        let emissions = [Int]()
                        let values = [Int]()
                        self.wateremissions = emissions
                        self.watervalues = values
                }
            }
            self.performSegue(withIdentifier: "gotodetails", sender: nil)
        }else if(indexPath.section == 4){
            currentcategory = "Waste"
            if let s = ((scoresarray["scores"] as! NSDictionary).mutableCopy() as? NSMutableDictionary)?["waste"] as? Int{
                currentscore = s
            }
            
            
            var temp = NSMutableArray()
            var temp1 = NSMutableArray()
            var dict = self.analysisdict
            
            if(dict["waste"] is NSNull || dict["waste"] == nil){
                let emissions = [Int]()
                let values = [Int]()
                self.wasteemissions = emissions
                self.wastevalues = values
            }else{
                
                    if let energy = dict["waste"] as? NSDictionary, let info_json = energy["info_json"] as? String {
                        var str = info_json
                    var str1 = NSMutableString()
                    str1.append(str)
                    str1.replaceOccurrences(of: "'", with: "\"", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(0, str.characters.count))
                    ////print(str1)
                    str1.replaceOccurrences(of: "None", with: "\"\"", options: NSString.CompareOptions.caseInsensitive , range: NSMakeRange(0, str.characters.count))
                    
                    str = str1.mutableCopy() as! String
                    let jsonData = (str).data(using: String.Encoding.utf8)
                    do {
                        dict = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        let tempdict = NSMutableDictionary()
                        var emissions = [Int]()
                        var values = [Int]()
                        for (k, value) in dict{
                            let key = k as! String
                            if(key.contains("Generated Waste (lbs per occupant per day)")){
                                temp.add("Generated Waste")
                                temp1.add(String(format:"%.4f (lbs/day)",dict["Generated Waste (lbs per occupant per day)"] as! Float
                                    ))
                            }else if(key.contains("Undiverted Waste (lbs per occupant per day)")){
                                temp.add("Undiverted Waste")
                                temp1.add(String(format:"%.4f lbs/day",dict["Undiverted Waste (lbs per occupant per day)"] as! Float
                                    ))
                            }else if(key.contains("Waste Diversion Rate")){
                                temp.add("Waste Diversion Rate")
                                temp1.add(String(format:"%.2f%%",dict["Waste Diversion Rate"] as! Float
                                    ))
                            }
                            
                        }
                        ////print("Tempdict",tempdict,values,emissions)
                        
                        dict1 = temp
                        dict2 = temp1
                        
                        
                    }catch{
                        
                    }
                }else{
                        let emissions = [Int]()
                    let values = [Int]()
                    self.wasteemissions = emissions
                    self.wastevalues = values
}
            }
            
            self.performSegue(withIdentifier: "gotodetails", sender: nil)
        }else if(indexPath.section == 5){
            currentcategory = "Transportation"
            if let s = ((scoresarray["scores"] as! NSDictionary).mutableCopy() as? NSMutableDictionary)?["transport"] as? Int{
                currentscore = s
            }
            
            var temp = NSMutableArray()
            var temp1 = NSMutableArray()
            var dict = self.analysisdict
            
            if(dict["transit"] is NSNull || dict["transit"] == nil){
                let emissions = [Int]()
                let values = [Int]()
                self.transitemissions = emissions
                self.transitvalues = values
            }else{
                
                    if let energy = dict["transit"] as? NSDictionary, let info_json = energy["info_json"] as? String {
                        var str = info_json
                    var str1 = NSMutableString()
                    str1.append(str)
                    str1.replaceOccurrences(of: "'", with: "\"", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(0, str.characters.count))
                    ////print(str1)
                    str1.replaceOccurrences(of: "None", with: "\"\"", options: NSString.CompareOptions.caseInsensitive , range: NSMakeRange(0, str.characters.count))
                    
                    str = str1.mutableCopy() as! String
                    let jsonData = (str).data(using: String.Encoding.utf8)
                    do {
                        dict = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        let tempdict = NSMutableDictionary()
                        var emissions = [Int]()
                        var values = [Int]()
                        for (k, value) in dict{
                            let key = k as! String
                            if(key.contains("Average Transit CO2e")){
                                temp.add("Average Transit")
                                temp1.add(String(format:"%.2f CO2e",dict["Average Transit CO2e"] as! Float
                                    ))
                            }else if(key.contains("Transportation Participation Fraction")){
                                temp.add("Transportation survey participation")
                                if let s = dict["Transportation Participation Fraction"] as? Float{
                                    temp1.add(String(format:"%.2f%%",100.00 * s))
                                }else if let s = dict["Transportation Participation Fraction"] as? Int{
                                    temp1.add(String(format:"%.2f%%",Float(100 * s)))
                                }else{
                                    temp1.add("0.00%")
                                }
                            }
                            
                        }
                        ////print("Tempdict",tempdict,values,emissions)
                        
                        dict1 = temp
                        dict2 = temp1
                        
                        
                    }catch{
                        
                    }
                }else{
                    let emissions = [Int]()
                    let values = [Int]()
                    self.transitemissions = emissions
                    self.transitvalues = values
                }
            }
            
            
            
            self.performSegue(withIdentifier: "gotodetails", sender: nil)
        }else if(indexPath.section == 6){
            currentcategory = "Human Experience"
            if let s = ((scoresarray["scores"] as! NSDictionary).mutableCopy() as? NSMutableDictionary)?["human_experience"] as? Int{
                currentscore = s
            }
            
            
            var temp = NSMutableArray()
            var temp1 = NSMutableArray()
            var dict = self.analysisdict
            dict1 = NSArray()
            dict2 = NSArray()
            if(dict["human"] is NSNull || dict["human"] == nil){
                let emissions = [Int]()
                let values = [Int]()
                self.humanemissions = emissions
                self.humanvalues = values
            }else{
                    if let energy = dict["human"] as? NSDictionary, let info_json = energy["info_json"] as? String {
                        var str = info_json
                        var str1 = NSMutableString()
                    str1.append(str)
                    str1.replaceOccurrences(of: "'", with: "\"", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(0, str.characters.count))
                    ////print(str1)
                    str1.replaceOccurrences(of: "None", with: "\"\"", options: NSString.CompareOptions.caseInsensitive , range: NSMakeRange(0, str.characters.count))
                    
                    str = str1.mutableCopy() as! String
                    let jsonData = (str).data(using: String.Encoding.utf8)
                    do {
                        dict = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        let tempdict = NSMutableDictionary()
                        var emissions = [Int]()
                        
                        var values = [Int]()
                        print(dict)
                        dict = dict["Human Experience Inputs"] as! NSDictionary
                        for (k, value) in dict{
                            let key = k as! String
                            if(key.contains("mean_response")){
                                temp.add("Mean response")
                                if let s = dict["mean_response"] as? Float{
                                temp1.add(String(format:"%.2f",s))
                                }else if let s = dict["mean_response"] as? Int{
                                    temp1.add(String(format:"%.2f",Float(s)))
                                }else{
                                    temp1.add("0.00")
                                }
                                
                            }else if(key.contains("variance_response")){
                                temp.add("Variance")
                                if let s = dict["variance_response"] as? Float{
                                    temp1.add(String(format:"%.2f",s))
                                }else if let s = dict["variance_response"] as? Int{
                                    temp1.add(String(format:"%.2f",Float(s)))
                                }else{
                                    temp1.add("0.00")
                                }
                                
                            }else if(key.contains("occupant_satisfaction")){
                                temp.add("Occupant satisfaction")
                                if let s = dict["occupant_satisfaction_fraction"] as? Float{
                                    temp1.add(String(format:"%.2f%%",100.00 * s))
                                }else if let s = dict["occupant_satisfaction_fraction"] as? Int{
                                    temp1.add(String(format:"%.2f%%",Float(100 * s)))
                                }else{
                                    temp1.add("0.00%")
                                }
                                
                            }else if(key.contains("occupant_satisfaction_fraction")){
                                temp.add("Occupant survey participation")
                                if let s = dict["occupant_satisfaction_fraction"] as? Float{
                                    temp1.add(String(format:"%.2f",100.00 * s))
                                }else if let s = dict["occupant_satisfaction_fraction"] as? Int{
                                    temp1.add(String(format:"%.2f",Float(100 * s)))
                                }else{
                                    temp1.add("0.00")
                                }
                                
                                
                            }else if(key.contains("voc")){
                                temp.add("VOC")
                                if let s = dict["voc"] as? Float{
                                    temp1.add(String(format:"%.2f",s))
                                }else if let s = dict["voc"] as? Int{
                                    temp1.add(String(format:"%.2f",Float(s)))
                                }else{
                                    temp1.add("0.00")
                                }
                                
                            }else if(key.contains("co2")){
                                temp.add("CO2")
                                if let s = dict["co2"] as? Float{
                                    temp1.add(String(format:"%.2f",s))
                                }else if let s = dict["co2"] as? Int{
                                    temp1.add(String(format:"%.2f",Float(s)))
                                }else{
                                    temp1.add("0.00")
                                }
                                
                            }
                            
                            
                        }
                        ////print("Tempdict",tempdict,values,emissions)
                        
                        dict1 = temp
                        dict2 = temp1
                        
                        
                    }catch{
                        
                    }
                }else{
                    let emissions = [Int]()
                    let values = [Int]()
                    self.humanemissions = emissions
                    self.humanvalues = values
                }
            }
            self.performSegue(withIdentifier: "gotodetails", sender: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let n = tableView.numberOfSections
        if(section == n - 1){
            return 10
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(certificationsdict["certificates"] != nil){
            let d = certificationsdict["certificates"] as! NSArray
            if(d.count > 0){
            return 7 + d.count
            }
            return 8
        }
        return 8
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section <= 6){
            return 1
        }
        
        if(certificationsdict["certificates"] != nil){
            let d = certificationsdict["certificates"] as! NSArray
            if(d.count > 0){
        return 4
            }
            return 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section <= 6){
            if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! cell1
            var firstColor =  UIColor(red: 69/255, green: 90/255, blue: 195/255, alpha: 1.0).cgColor
            firstColor =  UIColor(red: 237/255, green: 145/255, blue: 132/255, alpha: 1.0).cgColor
            let secondColor = cell.contentView.backgroundColor!.cgColor
            firstColor = secondColor
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [ firstColor, secondColor]
            gradientLayer.locations = [ 0.0, 0.096]
            gradientLayer.frame = CGRect(x: 0, y: 0, width: cell.contentView.layer.frame.size.width , height: cell.contentView.layer.frame.size.height)// You can mention frame here
            cell.contentView.layer.addSublayer(gradientLayer)
            cell.contentView.bringSubview(toFront: cell.t1)
            cell.contentView.bringSubview(toFront: cell.img)
            
            var tempstring = NSMutableString()
            tempstring = ""
            let actualstring = NSMutableAttributedString()
            var tempostring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString(string:(buildingdetails["name"] as? String)!)
            actualstring.append(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharacters(in: NSMakeRange(0, tempostring.length))
            tempostring = NSMutableAttributedString(string:"\n")
            actualstring.append(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharacters(in: NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:buildingdetails["street"] as! String)
            actualstring.append(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharacters(in: NSMakeRange(0, tempostring.length))
            tempostring = NSMutableAttributedString(string:"\n")
            actualstring.append(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharacters(in: NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:buildingdetails["city"] as! String)
            
            actualstring.append(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharacters(in: NSMakeRange(0, tempostring.length))
            tempostring = NSMutableAttributedString(string:", ")
            actualstring.append(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharacters(in: NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:fullstatename)
            
            actualstring.append(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharacters(in: NSMakeRange(0, tempostring.length))
            tempostring = NSMutableAttributedString(string:" ")
            actualstring.append(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharacters(in: NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:buildingdetails["zip_code"] as! String)
            actualstring.append(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharacters(in: NSMakeRange(0, tempostring.length))
            tempostring = NSMutableAttributedString(string:"")
            actualstring.append(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharacters(in: NSMakeRange(0, tempostring.length))
            
            
            tempostring = NSMutableAttributedString(string:fullcountryname)
            actualstring.append(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharacters(in: NSMakeRange(0, tempostring.length))
            tempostring = NSMutableAttributedString(string:".")
            actualstring.append(tempostring.mutableCopy() as! NSAttributedString)
            cell.t1.attributedText = actualstring
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                // It's an iPhone
                
                break
            case .pad:
                cell.t1.font = UIFont.init(name: "OpenSans", size: 0.038 * cell.contentView.frame.size.width)
                // It's an iPad
                
                break
            case .unspecified:
                
                break
                
            default : break
                
                // Uh, oh! What could it be?
            }

            //cell.layoutIfNeeded()
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "categorycell", for: indexPath) as! categorycell
                if(indexPath.section == 1){
                cell.categoryimg.frame.size.width = cell.categoryimg.frame.size.height
                cell.contentView.backgroundColor = UIColor.black
                cell.categoryimg.image = UIImage.init(named: "nav_plaque")
                cell.categoryimg.layer.cornerRadius = cell.categoryimg.layer.frame.size.height/2
                cell.categoryname.text = "Total score"
                cell.categoryname.font = UIFont.init(name: "OpenSans-Semibold", size: 0.038 * cell.contentView.frame.size.width)
                var t = ""
                if let scores = scoresarray["scores"] as? NSDictionary, let base = scores["base"] as? Int {
                    t = "\(energyscore + waterscore + wastescore + transportscore + humanscore + base)"
                }else{
                    t = "\(energyscore + waterscore + wastescore + transportscore + humanscore)"
                }
                     t = "\(dontchange)"
                var s = NSMutableAttributedString()
                var actualstring = NSMutableAttributedString()
                s = NSMutableAttributedString.init(string: t)
                s.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Semibold", size: 0.5 * cell.contentView.frame.size.height)!, range: NSMakeRange(0, t.characters.count))
                var tstring = NSMutableAttributedString.init(attributedString: s)
                actualstring.append(tstring)
                
                t = " out of \(maxscore)"
                s = NSMutableAttributedString()
                s = NSMutableAttributedString.init(string: t)
                s.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans", size: 0.25 * cell.contentView.frame.size.height)!, range: NSMakeRange(0, t.characters.count))
                tstring = NSMutableAttributedString.init(attributedString: s)
                actualstring.append(tstring)
                cell.categoryright.attributedText = actualstring
                
                
                t = "Reported period : "
                s = NSMutableAttributedString()
                actualstring = NSMutableAttributedString()
                s = NSMutableAttributedString.init(string: t)
                s.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans", size: 0.22 * cell.contentView.frame.size.height)!, range: NSMakeRange(0, t.characters.count))
                tstring = NSMutableAttributedString.init(attributedString: s)
                actualstring.append(tstring)
                
                
                let datearray : NSMutableArray = []
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                var date = Date()
                let unitFlags: NSCalendar.Unit = [.hour, .day, .month, .year]
                var components = (Calendar.current as NSCalendar).components(unitFlags, from: date)
                
                for _ in (1...12).reversed() {
                    ////print(components.year, components.month)
                    components = (Calendar.current as NSCalendar).components(unitFlags, from: date)
                    datearray.add(String(format:"%d-%02d-01",components.year!,components.month!))
                    let monthAgo = (Calendar.current as NSCalendar).date(byAdding: .month, value: -1, to: date, options: [])
                    date = monthAgo!
                }
                
                
                ////print(datearray)
                var date1 = Date()
                var date2 = Date()
                formatter.dateFormat = "yyyy-MM-dd"
                date1 = formatter.date(from: datearray.firstObject as! String)!
                date2 = formatter.date(from: datearray.lastObject as! String)!
                formatter.dateFormat = "MMM yyyy"
                t = String(format: "%@ to %@",formatter.string(from: date2),formatter.string(from: date1))
                s = NSMutableAttributedString()
                s = NSMutableAttributedString.init(string: t)
                s.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans", size: 0.22 * cell.contentView.frame.size.height)!, range: NSMakeRange(0, t.characters.count))
                tstring = NSMutableAttributedString.init(attributedString: s)
                actualstring.append(tstring)
                cell.categorybottom.attributedText = actualstring
            }else if(indexPath.section == 2){
                cell.contentView.backgroundColor = UIColor.init(red: 206/255, green: 220/255, blue: 38/255, alpha: 1)
                cell.categoryimg.image = UIImage.init(named: "white_edited_energy")
                cell.categoryimg.layer.cornerRadius = cell.categoryimg.layer.frame.size.height/2
                cell.categoryname.text = "Energy"
                cell.categoryname.font = UIFont.init(name: "OpenSans-Semibold", size: 0.038 * cell.contentView.frame.size.width)
                var t = "\(energyscore)"
                var s = NSMutableAttributedString()
                var actualstring = NSMutableAttributedString()
                s = NSMutableAttributedString.init(string: t)
                s.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Semibold", size: 0.5 * cell.contentView.frame.size.height)!, range: NSMakeRange(0, t.characters.count))
                var tstring = NSMutableAttributedString.init(attributedString: s)
                actualstring.append(tstring)
                
                t = " out of \(energymaxscore)"
                s = NSMutableAttributedString()
                s = NSMutableAttributedString.init(string: t)
                s.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans", size: 0.25 * cell.contentView.frame.size.height)!, range: NSMakeRange(0, t.characters.count))
                tstring = NSMutableAttributedString.init(attributedString: s)
                actualstring.append(tstring)
                cell.categoryright.attributedText = actualstring
                actualstring = NSMutableAttributedString()
                
                t = "0 months of data"
                if(self.analysisdict ["energy"] != nil){
                    var str = ""
                    if let scores = self.analysisdict["energy"] as? NSDictionary, let info_json = scores["info_json"] as? String {
                        str = info_json
                    }
                    let str1 = NSMutableString()
                    str1.append(str)
                    var dict = NSDictionary()
                    str = str.replacingOccurrences(of: "u'", with: "\"")
                    str = str.replacingOccurrences(of: "\"", with: "\"")
                    str = str.replacingOccurrences(of: "'", with: "\"")
                    str = str.replacingOccurrences(of: "None", with: "\"\"")
                    //print(str)
                    ////print(str1)
                    //str = str1.mutableCopy() as! String
                    let jsonData = (str).data(using: String.Encoding.utf8)
                    do {
                        dict = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        if(dict["Months of Energy Data"] == nil || dict["Months of Energy Data"] is NSNull){
                            
                        }else{
                            let i = dict["Months of Energy Data"] as! Int
                            t = String(format: "%d months of data",i)
                        }
                    }catch{
                        
                    }
                }
                s = NSMutableAttributedString()
                s = NSMutableAttributedString.init(string: t)
                s.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans", size: 0.22 * cell.contentView.frame.size.height)!, range: NSMakeRange(0, t.characters.count))
                tstring = NSMutableAttributedString.init(attributedString: s)
                actualstring.append(tstring)
                cell.categorybottom.attributedText = actualstring
            }else if(indexPath.section == 3){
                cell.contentView.backgroundColor = UIColor.init(red: 78/255, green: 201/255, blue: 247/255, alpha: 1)
                cell.categoryimg.image = UIImage.init(named: "white_edited_water")
                cell.categoryimg.layer.cornerRadius = cell.categoryimg.layer.frame.size.height/2
                cell.categoryname.text = "Water"
                cell.categoryname.font = UIFont.init(name: "OpenSans-Semibold", size: 0.038 * cell.contentView.frame.size.width)
                var t = "\(waterscore)"
                var s = NSMutableAttributedString()
                var actualstring = NSMutableAttributedString()
                s = NSMutableAttributedString.init(string: t)
                s.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Semibold", size: 0.5 * cell.contentView.frame.size.height)!, range: NSMakeRange(0, t.characters.count))
                var tstring = NSMutableAttributedString.init(attributedString: s)
                actualstring.append(tstring)
                
                t = " out of \(watermaxscore)"
                s = NSMutableAttributedString()
                s = NSMutableAttributedString.init(string: t)
                s.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans", size: 0.25 * cell.contentView.frame.size.height)!, range: NSMakeRange(0, t.characters.count))
                tstring = NSMutableAttributedString.init(attributedString: s)
                actualstring.append(tstring)
                cell.categoryright.attributedText = actualstring
                actualstring = NSMutableAttributedString()
                
                t = "0 months of data"
                if(self.analysisdict ["water"] != nil){
                    var str = ""
                    if let scores = self.analysisdict["water"] as? NSDictionary, let info_json = scores["info_json"] as? String {
                        str = info_json
                    }
                    let str1 = NSMutableString()
                    str1.append(str)
                    var dict = NSDictionary()
                    str = str.replacingOccurrences(of: "u'", with: "\"")
                    str = str.replacingOccurrences(of: "\"", with: "\"")
                    str = str.replacingOccurrences(of: "'", with: "\"")
                    str = str.replacingOccurrences(of: "None", with: "\"\"")
                    //print(str)
                    ////print(str1)
                    //str = str1.mutableCopy() as! String
                    let jsonData = (str).data(using: String.Encoding.utf8)
                    do {
                        dict = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        if(dict["Months of Water Data"] == nil || dict["Months of Water Data"] is NSNull){
                            
                        }else{
                            let i = dict["Months of Water Data"] as! Int
                            t = String(format: "%d months of data",i)
                        }
                    }catch{
                        
                    }
                }

                s = NSMutableAttributedString()
                s = NSMutableAttributedString.init(string: t)
                s.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans", size: 0.22 * cell.contentView.frame.size.height)!, range: NSMakeRange(0, t.characters.count))
                tstring = NSMutableAttributedString.init(attributedString: s)
                actualstring.append(tstring)
                cell.categorybottom.attributedText = actualstring
            }else if(indexPath.section == 4){
                cell.contentView.backgroundColor = UIColor.init(red: 129/255, green: 205/255, blue: 174/255, alpha: 1)
                cell.categoryimg.image = UIImage.init(named: "white_edited_waste")
                cell.categoryimg.layer.cornerRadius = cell.categoryimg.layer.frame.size.height/2
                cell.categoryname.text = "Waste"
                cell.categoryname.font = UIFont.init(name: "OpenSans-Semibold", size: 0.038 * cell.contentView.frame.size.width)
                var t = "\(wastescore)"
                var s = NSMutableAttributedString()
                var actualstring = NSMutableAttributedString()
                s = NSMutableAttributedString.init(string: t)
                s.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Semibold", size: 0.5 * cell.contentView.frame.size.height)!, range: NSMakeRange(0, t.characters.count))
                var tstring = NSMutableAttributedString.init(attributedString: s)
                actualstring.append(tstring)
                
                t = " out of \(wastemaxscore)"
                s = NSMutableAttributedString()
                s = NSMutableAttributedString.init(string: t)
                s.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans", size: 0.25 * cell.contentView.frame.size.height)!, range: NSMakeRange(0, t.characters.count))
                tstring = NSMutableAttributedString.init(attributedString: s)
                actualstring.append(tstring)
                cell.categoryright.attributedText = actualstring
                actualstring = NSMutableAttributedString()
                
                t = "Divertion rate : 0%"
                if(self.analysisdict ["waste"] != nil){
                    var str = ""
                    if let scores = self.analysisdict["waste"] as? NSDictionary, let info_json = scores["info_json"] as? String {
                            str = info_json
                    }
                    let str1 = NSMutableString()
                    str1.append(str)
                    var dict = NSDictionary()
                    str = str.replacingOccurrences(of: "u'", with: "\"")
                    str = str.replacingOccurrences(of: "\"", with: "\"")
                    str = str.replacingOccurrences(of: "'", with: "\"")
                    str = str.replacingOccurrences(of: "None", with: "\"\"")
                    //print(str)
                    ////print(str1)
                    //str = str1.mutableCopy() as! String
                    let jsonData = (str).data(using: String.Encoding.utf8)
                    do {
                        dict = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        if(dict["Waste Diversion Rate"] == nil || dict["Waste Diversion Rate"] is NSNull){
                            
                        }else{
                            let f = Float(dict["Waste Diversion Rate"] as! Float)
                            t = String(format: "Diversion rate : %.2f%%",f)
                        }
                    }catch{
                        
                    }
                }

                s = NSMutableAttributedString()
                s = NSMutableAttributedString.init(string: t)
                s.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans", size: 0.22 * cell.contentView.frame.size.height)!, range: NSMakeRange(0, t.characters.count))
                tstring = NSMutableAttributedString.init(attributedString: s)
                actualstring.append(tstring)
                cell.categorybottom.attributedText = actualstring
            }else if(indexPath.section == 5){
                cell.contentView.backgroundColor = UIColor.init(red: 164/255, green: 160/255, blue: 146/255, alpha: 1)
                cell.categoryimg.image = UIImage.init(named: "white_edited_transport")
                cell.categoryimg.layer.cornerRadius = cell.categoryimg.layer.frame.size.height/2
                cell.categoryname.text = "Transportation"
                cell.categoryname.font = UIFont.init(name: "OpenSans-Semibold", size: 0.038 * cell.contentView.frame.size.width)
                var t = "\(transportscore)"
                var s = NSMutableAttributedString()
                var actualstring = NSMutableAttributedString()
                s = NSMutableAttributedString.init(string: t)
                s.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Semibold", size: 0.5 * cell.contentView.frame.size.height)!, range: NSMakeRange(0, t.characters.count))
                var tstring = NSMutableAttributedString.init(attributedString: s)
                actualstring.append(tstring)
                
                t = " out of \(transportmaxscore)"
                s = NSMutableAttributedString()
                s = NSMutableAttributedString.init(string: t)
                s.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans", size: 0.25 * cell.contentView.frame.size.height)!, range: NSMakeRange(0, t.characters.count))
                tstring = NSMutableAttributedString.init(attributedString: s)
                actualstring.append(tstring)
                cell.categoryright.attributedText = actualstring
                actualstring = NSMutableAttributedString()
                
                t = "Survey participation : 0%"
                if(self.analysisdict ["transit"] != nil){
                    var str = ""
                    if let scores = self.analysisdict["transit"] as? NSDictionary, let info_json = scores["info_json"] as? String {
                        str = info_json
                    }
                    let str1 = NSMutableString()
                    str1.append(str)
                    var dict = NSDictionary()
                    str = str.replacingOccurrences(of: "u'", with: "\"")
                    str = str.replacingOccurrences(of: "\"", with: "\"")
                    str = str.replacingOccurrences(of: "'", with: "\"")
                    str = str.replacingOccurrences(of: "None", with: "\"\"")
                    //print(str)
                    ////print(str1)
                    //str = str1.mutableCopy() as! String
                    let jsonData = (str).data(using: String.Encoding.utf8)
                    do {
                        dict = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        if(dict["Transportation Participation Fraction"] == nil || dict["Transportation Participation Fraction"] is NSNull){
                            
                        }else{
                            let f = Float(dict["Transportation Participation Fraction"] as! Float)
                            t = String(format: "Survey participation : %d%%",Int(f * 100.0))
                        }
                    }catch{
                        
                    }
                }
                s = NSMutableAttributedString()
                s = NSMutableAttributedString.init(string: t)
                s.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans", size: 0.22 * cell.contentView.frame.size.height)!, range: NSMakeRange(0, t.characters.count))
                tstring = NSMutableAttributedString.init(attributedString: s)
                actualstring.append(tstring)
                cell.categorybottom.attributedText = actualstring
            }else if(indexPath.section == 6){
                cell.contentView.backgroundColor = UIColor.init(red: 242/255, green: 172/255, blue: 65/255, alpha: 1)
                cell.categoryimg.image = UIImage.init(named: "white_edited_human")
                cell.categoryimg.layer.cornerRadius = cell.categoryimg.layer.frame.size.height/2
                cell.categoryname.text = "Human experience"
                cell.categoryname.font = UIFont.init(name: "OpenSans-Semibold", size: 0.038 * cell.contentView.frame.size.width)
                var t = "\(humanscore)"
                var s = NSMutableAttributedString()
                var actualstring = NSMutableAttributedString()
                s = NSMutableAttributedString.init(string: t)
                s.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Semibold", size: 0.5 * cell.contentView.frame.size.height)!, range: NSMakeRange(0, t.characters.count))
                var tstring = NSMutableAttributedString.init(attributedString: s)
                actualstring.append(tstring)
                
                t = " out of \(humanmaxscore)"
                s = NSMutableAttributedString()
                s = NSMutableAttributedString.init(string: t)
                s.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans", size: 0.25 * cell.contentView.frame.size.height)!, range: NSMakeRange(0, t.characters.count))
                tstring = NSMutableAttributedString.init(attributedString: s)
                actualstring.append(tstring)
                cell.categoryright.attributedText = actualstring
                actualstring = NSMutableAttributedString()
                
                t = "Co2 : 78 | VOC : 80"
                if(self.analysisdict ["human"] != nil){
                    var str = ""
                    if let scores = self.analysisdict["human"] as? NSDictionary, let info_json = scores["info_json"] as? String {
                        str = info_json
                    }
                    let str1 = NSMutableString()
                    str1.append(str)
                    var dict = NSDictionary()
                    str = str.replacingOccurrences(of: "u'", with: "\"")
                    str = str.replacingOccurrences(of: "\"", with: "\"")
                    str = str.replacingOccurrences(of: "'", with: "\"")
                    str = str.replacingOccurrences(of: "None", with: "\"\"")
                    //print(str)
                    ////print(str1)
                    //str = str1.mutableCopy() as! String
                    let jsonData = (str).data(using: String.Encoding.utf8)
                    do {
                        dict = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        var temp = ""
                        if(dict["Human Experience Subscores (out of 100, weighted equally)"] != nil){
                            var c = dict["Human Experience Subscores (out of 100, weighted equally)"] as! NSDictionary
                        if(c["voc"] == nil || c["voc"] is NSNull){
                            temp = "VOC : 0 | "
                        }else{
                            let i = Float(c["voc"] as! Float)
                            temp = String(format:"VOC : %.2f | ",i)
                        }
                        
                        if(c["co2"] == nil || c["co2"] is NSNull){
                            temp = String(format:"%@CO2 : 0",temp)
                        }else{
                            let i = Float(c["co2"] as! Float)
                            temp = String(format:"%@CO2 : %.2f",temp,i)
                        }
                        t = temp
                        }
                    }catch{
                        
                    }
                }
                s = NSMutableAttributedString()
                s = NSMutableAttributedString.init(string: t)
                s.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans", size: 0.22 * cell.contentView.frame.size.height)!, range: NSMakeRange(0, t.characters.count))
                tstring = NSMutableAttributedString.init(attributedString: s)
                actualstring.append(tstring)
                cell.categorybottom.attributedText = actualstring
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            return cell
        }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            cell.selectionStyle = .none
            if(certificationsdict["certificates"] != nil){
                
                let d = certificationsdict["certificates"] as! NSArray
                let dict = d[indexPath.section - 7] as! NSDictionary
                if(indexPath.row == 0){
                    cell.textLabel?.text = "Certification"
                    
                    if let project_type = dict["project_type"] as? String{
                        cell.detailTextLabel?.text = project_type
                    }else{
                        cell.detailTextLabel?.text = "None"
                    }
                    
                    
                    if let rating_system = dict["rating_system"] as? NSDictionary{
                        if let name = rating_system["name"] as? String{
                            cell.detailTextLabel?.text = name
                        }
                    }
                    
                }else if(indexPath.row == 1){
                    cell.textLabel?.text = "Level"
                    if let project_level = dict["certification_level"] as? String{
                        cell.detailTextLabel?.text = project_level.capitalized
                    }else{
                        cell.detailTextLabel?.text = ""
                    }
                    
                }else if(indexPath.row == 2){
                    cell.textLabel?.text = "Points"
                    if let points = dict["certification_points"] as? Int{
                        cell.detailTextLabel?.text = "\(points as! Int)"
                    }else{
                        cell.detailTextLabel?.text = ""
                    }
                }else if(indexPath.row == 3){
                    cell.textLabel?.text = "Certified Date"
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    if let str = dict["date_certified"] as? String{
                        var date = formatter.date(from: str)
                        formatter.dateFormat = "MMM dd, yyyy"
                        var s = formatter.string(from: date!)
                        cell.detailTextLabel?.text = s
                    }else{
                        cell.detailTextLabel?.text = ""
                    }
                }
                
            }
            return cell
        }
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

