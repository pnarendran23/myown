//
//  totalanalytics.swift
//  LEEDOn
//
//  Created by Group X on 20/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit
import  AVFoundation

class totalanalytics: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate {
    @IBOutlet weak var tableview: UITableView!
    var buildingdetails = [String:AnyObject]()
    var highduringreport = 0
    var globalavgarr = NSMutableArray()
    var performancescoresarr = NSMutableArray()
    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var spinner: UIView!
    
    @IBAction func gotoscore(sender: AnyObject) {
                    NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"listofassets"])
    }
    
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
    var analysisdict = NSDictionary()
    var reportedscores = NSMutableArray()
    var countries = [String:AnyObject]()
    var datearr = NSMutableArray()
    var globaldata = [String:AnyObject]()
    var performancedata = [String:AnyObject]()
    var localdata = [String:AnyObject]()
    var fullcountryname = ""
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
    var fullstatename = ""
    var toload = true
    var scoresarr = NSMutableArray()
    var callrequest = 1
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 2){
            return 25
        }
        if(section == 0){
            return 0
        }
        return 5
    }
    
   /* override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [.Portrait]
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
        self.automaticallyAdjustsScrollViewInsets = false;
        self.navigationController!.navigationBar.translucent = false
        self.spinner.layer.cornerRadius = 5
NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.adjustwidth), name: UIDeviceOrientationDidChangeNotification, object: nil)
        self.tableview.hidden = true
        let notificationsarr = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("notifications") as! NSData) as! NSArray
        if(notificationsarr.count > 0 ){
            self.tabbar.items![4].badgeValue = "\(notificationsarr.count)"
        }else{
            self.tabbar.items![4].badgeValue = nil
        }
        self.tabbar.selectedItem = self.tabbar.items![2]
        tableview.registerNib(UINib.init(nibName: "totalanalysis1", bundle: nil), forCellReuseIdentifier: "totalcell1")
        
        tableview.registerNib(UINib.init(nibName: "certcell", bundle: nil), forCellReuseIdentifier: "certcell")
        
        tableview.registerNib(UINib.init(nibName: "totalanalysis2", bundle: nil), forCellReuseIdentifier: "totalcell2")
        
        tableview.registerNib(UINib.init(nibName: "totalanalysis3", bundle: nil), forCellReuseIdentifier: "totalcell3")
        
        tableview.registerNib(UINib.init(nibName: "typecategory", bundle: nil), forCellReuseIdentifier: "typecell")        
        
        if(self.toload == true){
            buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
            self.navigationItem.title = buildingdetails["name"] as? String
            
            globaldata  = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("comparable_data") as! NSData) as! [String : AnyObject]
            
            localdata  = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("local_comparable_data") as! NSData) as! [String : AnyObject]
            
            performancedata  = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("performance_data") as! NSData) as! [String : AnyObject]
            
            
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
            for (_,value) in tempdict{
                if(value as! String == buildingdetails["country"]! as! String){
                    present = 1
                    break
                }
            }
            tempdict = countries["countries"] as! [String:AnyObject]
            if(present == 1){
            fullcountryname = countries["countries"]![buildingdetails["country"] as! String]! as! String
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
        //comparable_data -> global
        
        
        // Do any additional setup after loading the view.
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
        self.tableview.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        self.navigationItem.title = buildingdetails["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as? String
    }
    
    func getanalysis(leedid:Int,token:String){
        let url = NSURL(string: "\(credentials().domain_url)assets/LEED:\(leedid)/analysis/")
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        
        
        let tasky = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
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
                        self.spinner.hidden = true
                        self.tableview.alpha = 1.0
                        self.getmax("energy", arr: self.scoresarr)
                    })
                } catch {
                    //print(error)
                }
                
                
            } else {
                taskerror = true
            }
            }
        })
        
        
        
        
        tasky.resume()
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
        return 8
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tableview.reloadData()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return 169
        }else if(indexPath.section == 1){
            return 254
        }
        if(indexPath.section >= 2 && indexPath.section <= 6){
            
            if(indexPath.section == 2){
                if(energyvalues.count > 0 && getnumberofdata(2) > 0){
                    return 360
                }else if(energyvalues.count == 0 && getnumberofdata(2) == 0){
                    return 80
                }else{
                    return 190
                }
            }
            if(indexPath.section == 3){
                if(watervalues.count > 0 && getnumberofdata(3) > 0){
                    return 360
                }else if(watervalues.count == 0 && getnumberofdata(3) == 0){
                    return 80
                }else{
                    return 190
                }
            }
            if(indexPath.section == 4){
                if(wastevalues.count > 0 && getnumberofdata(4) > 0){
                    return 360
                }else if(wastevalues.count == 0 && getnumberofdata(4) == 0){
                    return 80
                }else{
                    return 190
                }
            }
            if(indexPath.section == 5){
                if(transitvalues.count > 0 && getnumberofdata(5) > 0){
                    return 360
                }else if(transitvalues.count == 0 && getnumberofdata(5) == 0){
                    return 80
                }
                else{
                    return 190
                }
            }
            if(indexPath.section == 6){
                if(humanvalues.count > 0 && getnumberofdata(6) > 0){
                    return 360
                }else if(humanvalues.count == 0 && getnumberofdata(6) == 0){
                    return 80
                }else{
                    return 190
                }
            }
        }
        return 160
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
        
        if(indexPath.section == 0){
            let cell = tableview.dequeueReusableCellWithIdentifier("totalcell1")! as! totalanalysis1
            var tempstring = NSMutableString()
            tempstring = ""
            let actualstring = NSMutableAttributedString()
            var tempostring = NSMutableAttributedString()
            tempostring = NSMutableAttributedString(string:(buildingdetails["name"] as? String)!)
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
            
            
            tempostring = NSMutableAttributedString(string:fullcountryname)
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
            tempostring = NSMutableAttributedString(string:".")
            actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
            cell.details.attributedText = actualstring
            cell.leedid.numberOfLines = 3
            tempstring.deleteCharactersInRange(NSMakeRange(0, tempstring.length))
            tempstring.appendString(String(format: "%d",NSUserDefaults.standardUserDefaults().integerForKey("leed_id")))
            tempstring.appendString("\n")
            if let gross = buildingdetails["gross_area"] as? Int{
                tempstring.appendString(String(format: "%d Sq.Ft",gross))
            }else{
                tempstring.appendString(String(format: "0 Sq.Ft"))
            }
            
            cell.leedid.text = tempstring as String
           // cell.gross.text = String(format: "%d Sq.Ft",buildingdetails["gross_area"] as! Int)
            
            cell.duration.text = duration
            
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            //cell.backgroundColor = UIColor.clearColor()
            return cell
        }else if(indexPath.section == 1){
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
            tempstring.appendString(String(format: "Lowest score during reporting period:  %d", lessduringreport))
            cell.highscore.adjustsFontSizeToFitWidth = true
            cell.highscore.text = tempstring as String
            cell.layoutSubviews()
            //view.center = CGPointMake(cell.contentView.bounds.size.width/2,cell.contentView.bounds.size.height/2.5);
            return cell
        }
        else {
            if(indexPath.section == 2){
                let cell = tableview.dequeueReusableCellWithIdentifier("totalcell3")! as! totalanalysis3
                cell.graphbtn.tag = 50
                cell.graphbtn.addTarget(self, action: #selector(self.click(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                cell.accessoryType = UITableViewCellAccessoryType.None
                cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_energy")
                cell.typename.text = "ENERGY"
                cell.globalavg.text = String(format: "Global avg : %d", globalavgarr.objectAtIndex(0) as! Int)
                cell.localavg.text = String(format: "Local avg : %d", localavgarr.objectAtIndex(0) as! Int)
                cell.slider1.tag = 402
                cell.slider2.tag = 502
                cell.l1.tag = 1001
                cell.l2.tag = 1002
                cell.l3.tag = 1003
                cell.l4.tag = 1004
                cell.outoflbl.text = "\(energyscore) out of \(energymaxscore)"
                cell.outoflbl.textColor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
                cell.slider1.minimumValue = 0.0
                cell.slider1.maximumValue = 10.0
                // slider values go from 0 to the number of values in your numbers array
                cell.slider1.addTarget(self, action: #selector(self.slider1changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                cell.slider1.setValue(0.0, animated: true)
                self.slider1changed(cell.slider1)
                // slider values go from 0 to the number of values in your numbers array
                //print(energyvalues)
                if(energyvalues.count == 0){
                    cell.slider2.userInteractionEnabled = false
                    cell.l3.hidden = true
                    cell.l4.hidden = true
                    cell.slider2.hidden = true
                }
                else{
                    cell.slider2.hidden = false
                    cell.l3.hidden = false
                    cell.l4.hidden = false
                    
                    if(energyvalues.count == 1){
                        cell.slider2.userInteractionEnabled = false
                        cell.l3.text = "If I want to increase my score by +1"
                        cell.l4.text = "I need to reduce by emission by \(energyvalues[0])%"
                        cell.slider2.value = Float(energyvalues[0])
                    }else{
                        cell.slider2.userInteractionEnabled = true
                        cell.slider2.setValue(0.0, animated: true)
                        cell.slider2.minimumValue = 0.0
                        cell.slider2.maximumValue = Float(energyvalues.count)
                        if(energyvalues.count > 0){
                            step1 = Float(energyvalues.count)
                        }
                        
                    }
                }
                
                
                if((energyvalues.count <= 0 && getnumberofdata(2) > 0) || (energyvalues.count > 0 && getnumberofdata(2) <= 0)){
                    cell.vv.frame.size.height = 90
                }else if((energyvalues.count > 0 && getnumberofdata(2) > 0) || (energyvalues.count > 0 && getnumberofdata(2) > 0)){
                    cell.vv.frame.size.height = 0.725 * 360
                }
                
                cell.slider2.addTarget(self, action: #selector(self.slider2changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                slider2changed(cell.slider2)
                
                return cell
                
            }else if(indexPath.section == 3){
                let cell = tableview.dequeueReusableCellWithIdentifier("totalcell3")! as! totalanalysis3
                cell.graphbtn.tag = 51
                cell.graphbtn.addTarget(self, action: #selector(self.click(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                cell.accessoryType = UITableViewCellAccessoryType.None
                cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_water")
                cell.typename.text = "WATER"
                cell.globalavg.text = String(format: "Global avg : %d", globalavgarr.objectAtIndex(1) as! Int)
                cell.localavg.text = String(format: "Local avg : %d", localavgarr.objectAtIndex(1) as! Int)
                cell.slider1.tag = 403
                cell.slider2.tag = 503
                cell.l1.tag = 2001
                cell.l2.tag = 2002
                cell.l3.tag = 2003
                cell.l4.tag = 2004
                cell.slider1.minimumValue = 0.0
                cell.slider1.maximumValue = 10.0
                cell.outoflbl.textColor = UIColor.init(red: 0.303, green: 0.751, blue: 0.94, alpha: 1)
                cell.outoflbl.text = "\(waterscore) out of \(watermaxscore)"
                cell.slider1.addTarget(self, action: #selector(self.slider1changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                cell.slider1.setValue(0.0, animated: true)
                self.slider1changed(cell.slider1)
                if(watervalues.count == 0){
                    cell.slider2.userInteractionEnabled = false
                    cell.l3.hidden = true
                    cell.l4.hidden = true
                    cell.slider2.hidden = true
                }
                else{
                    cell.slider2.hidden = false
                    cell.l3.hidden = false
                    cell.l4.hidden = false
                    
                    if(watervalues.count == 1){
                        cell.slider2.userInteractionEnabled = false
                        cell.l3.text = "If I want to increase my score by +1"
                        cell.l4.text = "I need to reduce by emission by \(watervalues[0])%"
                        cell.slider2.value = Float(watervalues[0])
                    }else{
                        cell.slider2.setValue(0.0, animated: true)
                        cell.slider2.minimumValue = 0.0
                        cell.slider2.maximumValue = Float(watervalues.count)
                        if(watervalues.count > 0){
                            step1 = Float(watervalues.count)
                        }
                    }
                }
                cell.slider2.addTarget(self, action: #selector(self.slider2changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                slider2changed(cell.slider2)
                if((watervalues.count <= 0 && getnumberofdata(3) > 0) || (watervalues.count > 0 && getnumberofdata(3) <= 0)){
                    cell.vv.frame.size.height = 90
                }else if((watervalues.count > 0 && getnumberofdata(3) > 0) || (watervalues.count > 0 && getnumberofdata(3) > 0)){
                    cell.vv.frame.size.height = 0.725 * 360
                }
            
                return cell
                
            }else if(indexPath.section == 4){
                let cell = tableview.dequeueReusableCellWithIdentifier("totalcell3")! as! totalanalysis3
                cell.graphbtn.tag = 52
                cell.graphbtn.addTarget(self, action: #selector(self.click(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                cell.accessoryType = UITableViewCellAccessoryType.None
                cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_waste")
                cell.typename.text = "WASTE"
                cell.globalavg.text = String(format: "Global avg : %d", globalavgarr.objectAtIndex(2) as! Int)
                cell.localavg.text = String(format: "Local avg : %d", localavgarr.objectAtIndex(2) as! Int)
                cell.l1.tag = 3001
                cell.l2.tag = 3002
                cell.l3.tag = 3003
                cell.l4.tag = 3004
                cell.slider2.tag = 504
                cell.slider1.tag = 404
                // slider values go from 0 to the number of values in your numbers array
                cell.slider1.minimumValue = 0.0
                cell.slider1.maximumValue = 10.0
                // slider values go from 0 to the number of values in your numbers array
                cell.slider1.addTarget(self, action: #selector(self.slider1changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                cell.outoflbl.text = "\(wastescore) out of \(wastemaxscore)"
                cell.outoflbl.textColor = UIColor.init(red: 0.461, green: 0.76, blue: 0.629, alpha: 1)
                cell.slider1.setValue(0.0, animated: true)
                self.slider1changed(cell.slider1)
                if(wastevalues.count == 0){
                    cell.slider2.userInteractionEnabled = false
                    cell.l3.hidden = true
                    cell.l4.hidden = true
                    cell.slider2.hidden = true
                    cell.vv.layer.layoutIfNeeded()
                }
                else{
                    cell.slider2.hidden = false
                    cell.l3.hidden = false
                    cell.l4.hidden = false
                    cell.slider1.setValue(0.0, animated: true)
                    if(wastevalues.count == 1){
                        cell.slider2.userInteractionEnabled = false
                        cell.l3.text = "If I want to increase my score by +1"
                        cell.l4.text = "I need to reduce by emission by \(wastevalues[0])%"
                        cell.slider2.value = Float(wastevalues[0])
                    }else{
                        cell.slider2.value = Float(wastevalues.minElement()!)
                    }
                    cell.slider2.maximumValue = Float(wastevalues.count)
                    if(wastevalues.count > 0){
                        step1 = Float(wastevalues.count)
                    }
                }
                
                if((wastevalues.count <= 0 && getnumberofdata(4) > 0) || (wastevalues.count > 0 && getnumberofdata(4) <= 0)){
                    cell.vv.frame.size.height = 90
                }else if((wastevalues.count > 0 && getnumberofdata(4) > 0) || (wastevalues.count > 0 && getnumberofdata(4) > 0)){
                    cell.vv.frame.size.height = 0.725 * 360
                }
                slider2changed(cell.slider2)
                
                return cell
            }else if(indexPath.section == 5){
                let cell = tableview.dequeueReusableCellWithIdentifier("totalcell3")! as! totalanalysis3
                cell.graphbtn.tag = 53
                cell.graphbtn.addTarget(self, action: #selector(self.click(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                cell.accessoryType = UITableViewCellAccessoryType.None
                cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_transport")
                cell.typename.text = "TRANSPORTATION"
                cell.globalavg.text = String(format: "Global avg : %d", globalavgarr.objectAtIndex(3) as! Int)
                cell.localavg.text = String(format: "Local avg : %d", localavgarr.objectAtIndex(3) as! Int)
                cell.l1.tag = 4001
                cell.l2.tag = 4002
                cell.l3.tag = 4003
                cell.l4.tag = 4004
                cell.slider2.tag = 505
                cell.slider1.tag = 405
                // slider values go from 0 to the number of values in your numbers array
                cell.slider1.minimumValue = 0.0
                cell.slider1.maximumValue = 10.0
                // slider values go from 0 to the number of values in your numbers array
                cell.slider1.addTarget(self, action: #selector(self.slider1changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                cell.slider1.setValue(0.0, animated: true)
                cell.outoflbl.text = "\(transportscore) out of \(transportmaxscore)"
                cell.outoflbl.textColor = UIColor.init(red: 0.572, green: 0.556, blue: 0.505, alpha: 1)
                self.slider1changed(cell.slider1)
                if(transitvalues.count == 0){
                    cell.l3.hidden = true
                    cell.l4.hidden = true
                    cell.slider2.hidden = true
                    cell.slider2.userInteractionEnabled = false
                }
                else{
                    cell.slider2.hidden = false
                    cell.l3.hidden = false
                    cell.l4.hidden = false
                    cell.slider1.setValue(0.0, animated: true)
                    if(transitvalues.count == 1){
                        cell.slider2.userInteractionEnabled = false
                        cell.l3.text = "If I want to increase my score by +1"
                        cell.l4.text = "I need to reduce by emission by \(transitvalues[0])%"
                        cell.slider2.value = Float(transitvalues[0])
                    }else{
                        cell.slider2.value = Float(transitvalues.minElement()!)
                    }
                    cell.slider2.maximumValue = Float(transitvalues.count)
                    if(transitvalues.count > 0){
                        step1 = Float(transitvalues.count)
                    }
                }
                if((transitvalues.count <= 0 && getnumberofdata(5) > 0) || (transitvalues.count > 0 && getnumberofdata(5) <= 0)){
                    cell.vv.frame.size.height = 90
                }else if((transitvalues.count > 0 && getnumberofdata(5) > 0) || (transitvalues.count > 0 && getnumberofdata(5) > 0)){
                    cell.vv.frame.size.height = 0.725 * 360
                }
                cell.slider2.addTarget(self, action: #selector(self.slider2changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                slider2changed(cell.slider2)
                return cell
            }else if(indexPath.section == 6){
                let cell = tableview.dequeueReusableCellWithIdentifier("totalcell3")! as! totalanalysis3
                cell.graphbtn.tag = 54
                cell.graphbtn.addTarget(self, action: #selector(self.click(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                cell.accessoryType = UITableViewCellAccessoryType.None
                cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_human")
                cell.typename.text = "HUMAN EXPERIENCE"
                cell.globalavg.text = String(format: "Global avg : %d", globalavgarr.objectAtIndex(4) as! Int)
                cell.localavg.text = String(format: "Local avg : %d", localavgarr.objectAtIndex(4) as! Int)
                cell.l1.tag = 5001
                cell.l2.tag = 5002
                cell.l3.tag = 5003
                cell.l4.tag = 5004
                cell.slider2.tag = 506
                cell.slider1.tag = 406
                // slider values go from 0 to the number of values in your numbers array
                cell.slider1.minimumValue = 0.0
                cell.slider1.maximumValue = 10.0
                // slider values go from 0 to the number of values in your numbers array
                cell.slider1.addTarget(self, action: #selector(self.slider1changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                cell.outoflbl.text = "\(humanscore) out of \(humanmaxscore)"
                cell.outoflbl.textColor = UIColor.init(red: 0.92, green: 0.609, blue: 0.236, alpha: 1)
                cell.slider1.setValue(0.0, animated: true)
                self.slider1changed(cell.slider1)
                if(humanvalues.count == 0){
                    cell.l3.hidden = true
                    cell.l4.hidden = true
                    cell.slider2.hidden = true
                    cell.slider2.userInteractionEnabled = false
                }
                else{
                    cell.slider2.hidden = false
                    cell.l3.hidden = false
                    cell.l4.hidden = false
                    cell.slider1.setValue(0.0, animated: true)
                    if(humanvalues.count == 1){
                        cell.slider2.userInteractionEnabled = false
                        cell.l3.text = "If I want to increase my score by +1"
                        cell.l4.text = "I need to reduce by emission by \(humanvalues[0])%"
                        cell.slider2.value = Float(humanvalues[0])
                    }else{
                        cell.slider2.value = Float(humanvalues.minElement()!)
                    }
                    cell.slider2.maximumValue = Float(humanvalues.count)
                    if(humanvalues.count > 0){
                        step1 = Float(humanvalues.count)
                    }
                    slider2changed(cell.slider2)
                }
                cell.slider2.addTarget(self, action: #selector(self.slider2changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
                slider2changed(cell.slider2)
                if((humanvalues.count <= 0 && getnumberofdata(6) > 0) || (humanvalues.count > 0 && getnumberofdata(6) <= 0)){
                    cell.vv.frame.size.height = 90
                }else if((humanvalues.count > 0 && getnumberofdata(6) > 0) || (humanvalues.count > 0 && getnumberofdata(6) > 0)){
                    cell.vv.frame.size.height = 0.725*360
                }
                return cell
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
            let dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("certification_details") as! NSData) as! NSDictionary
            var titles = NSMutableAttributedString()
            
            if let rating = dict["ERatingSys"] as? String{
                if(rating == ""){
                    cell.certname.text = "Not available"
                }else{
                    cell.certname.text = "\(dict["ERatingSys"] as! String)"
                }
            }else{
                cell.certname.text = "Not available"
            }
            
            titles = NSMutableAttributedString(string: "CURRENT LEVEL : ")
            titles.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: NSMakeRange(0, titles.length))
            titles.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 12)! , range: NSMakeRange(0, titles.length))
            if let level = dict["EPrecertLevel"] as? String{
                if(level == ""){
                    titles.appendAttributedString(NSAttributedString.init(string: "Not available"))
                    cell.certlevel.attributedText = titles
                }else{
                    titles.appendAttributedString(NSAttributedString.init(string: dict["EPrecertLevel"] as! String))
                    cell.certlevel.attributedText = titles
                    //"\(titles.s):\(dict["EPrecertLevel"] as! String)"
                }
            }else{
                titles.appendAttributedString(NSAttributedString.init(string: "Not available"))
                cell.certlevel.attributedText = titles
            }
            titles.deleteCharactersInRange(NSMakeRange(0, titles.length))
            titles = NSMutableAttributedString(string: "DATE AWARDED: ")
            titles.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: NSMakeRange(0, titles.length))
            titles.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 12)! , range: NSMakeRange(0, titles.length))
            
            if let level = dict["EPrecertAcptdate"] as? String{
                if(level == "" || level == "0000-00-00"){
                    titles.appendAttributedString(NSAttributedString.init(string: "Not available"))
                    cell.certdate.attributedText = titles
                }else{
                    titles.appendAttributedString(NSAttributedString.init(string: dict["EPrecertAcptdate"] as! String))
                    cell.certdate.attributedText = titles
                }
            }else{
                titles.appendAttributedString(NSAttributedString.init(string: "Not available"))
                cell.certdate.attributedText = titles
            }
            titles.deleteCharactersInRange(NSMakeRange(0, titles.length))
            titles = NSMutableAttributedString(string: "OTHER CERTIFICATION DATES : ")
            titles.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: NSMakeRange(0, titles.length))
            titles.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Bold", size: 12)! , range: NSMakeRange(0, titles.length))
            titles.appendAttributedString(NSAttributedString.init(string: "Not available"))
            cell.othercert.attributedText = titles
            
            
            return cell
        }
        
        
        
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.section == 1){
            let cell = tableview.dequeueReusableCellWithIdentifier("totalcell2")! as! totalanalysis2
            cell.layoutSubviews()
            
        }
        
        if(indexPath.section == 2){
            let cell = tableview.dequeueReusableCellWithIdentifier("totalcell3")! as! totalanalysis3
            cell.graphbtn.tag = 50
            cell.graphbtn.addTarget(self, action: #selector(self.click(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_energy")
            cell.typename.text = "ENERGY"
            cell.globalavg.text = String(format: "Global avg : %d", globalavgarr.objectAtIndex(0) as! Int)
            cell.localavg.text = String(format: "Local avg : %d", localavgarr.objectAtIndex(0) as! Int)
            cell.slider1.tag = 402
            cell.slider2.tag = 502
            cell.l1.tag = 1001
            cell.l2.tag = 1002
            cell.l3.tag = 1003
            cell.l4.tag = 1004
            cell.slider1.minimumValue = 0.0
            cell.slider1.maximumValue = 10.0
            self.slider1changed(cell.slider1)
            // slider values go from 0 to the number of values in your numbers array
            cell.slider1.addTarget(self, action: #selector(self.slider1changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
            cell.slider1.setValue(0.0, animated: true)
            // slider values go from 0 to the number of values in your numbers array
            //print(energyvalues)
            if(energyvalues.count == 0){
                cell.slider2.userInteractionEnabled = false
                cell.l3.hidden = true
                cell.l4.hidden = true
                cell.slider2.hidden = true
            }
            else{
                cell.slider2.hidden = false
                cell.l3.hidden = false
                cell.l4.hidden = false
                
                if(energyvalues.count == 1){
                    cell.slider2.userInteractionEnabled = false
                    cell.l3.text = "If I want to increase my score by +1"
                    cell.l4.text = "I need to reduce by emission by \(energyvalues[0])%"
                    cell.slider2.value = Float(energyvalues[0])
                }else{
                    cell.slider2.userInteractionEnabled = true
                    step1 = Float(energyvalues.count)
                    cell.slider2.setValue(0.0, animated: true)
                    cell.slider2.minimumValue = 0.0
                    cell.slider2.maximumValue = Float(energyvalues.count)
                    step1 = Float(energyvalues.count)
                    
                }
            }
            
            
            if((energyvalues.count <= 0 && getnumberofdata(2) > 0) || (energyvalues.count > 0 && getnumberofdata(2) <= 0)){
                cell.vv.frame.size.height = 90
            }else if((energyvalues.count > 0 && getnumberofdata(2) > 0) || (energyvalues.count > 0 && getnumberofdata(2) > 0)){
                cell.vv.frame.size.height = 0.725 * 360
            }
            cell.setNeedsDisplay()
            
            cell.slider2.addTarget(self, action: #selector(self.slider2changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
            slider2changed(cell.slider2)
            
        }else if(indexPath.section == 3){
            let cell = tableview.dequeueReusableCellWithIdentifier("totalcell3")! as! totalanalysis3
            cell.graphbtn.tag = 51
            cell.graphbtn.addTarget(self, action: #selector(self.click(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_water")
            cell.typename.text = "WATER"
            cell.globalavg.text = String(format: "Global avg : %d", globalavgarr.objectAtIndex(1) as! Int)
            cell.localavg.text = String(format: "Local avg : %d", localavgarr.objectAtIndex(1) as! Int)
            cell.slider1.tag = 403
            cell.slider2.tag = 503
            cell.l1.tag = 2001
            cell.l2.tag = 2002
            cell.l3.tag = 2003
            cell.l4.tag = 2004
            cell.slider1.minimumValue = 0.0
            cell.slider1.maximumValue = 10.0
            self.slider1changed(cell.slider1)
            // slider values go from 0 to the number of values in your numbers array
            cell.slider1.addTarget(self, action: #selector(self.slider1changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
            cell.slider1.setValue(0.0, animated: true)
            if(watervalues.count == 0){
                cell.slider2.userInteractionEnabled = false
                cell.l3.hidden = true
                cell.l4.hidden = true
                cell.slider2.hidden = true
            }
            else{
                cell.slider2.hidden = false
                cell.l3.hidden = false
                cell.l4.hidden = false
                
                if(watervalues.count == 1){
                    cell.slider2.userInteractionEnabled = false
                    cell.l3.text = "If I want to increase my score by +1"
                    cell.l4.text = "I need to reduce by emission by \(watervalues[0])%"
                    cell.slider2.value = Float(watervalues[0])
                }else{
                    cell.slider2.setValue(0.0, animated: true)
                    cell.slider2.minimumValue = 0.0
                    cell.slider2.maximumValue = Float(watervalues.count)
                    step1 = Float(watervalues.count)
                }
            }
            cell.slider2.addTarget(self, action: #selector(self.slider2changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
            slider2changed(cell.slider2)
            if((watervalues.count <= 0 && getnumberofdata(3) > 0) || (watervalues.count > 0 && getnumberofdata(3) <= 0)){
                cell.vv.frame.size.height = 90
            }else if((watervalues.count > 0 && getnumberofdata(3) > 0) || (watervalues.count > 0 && getnumberofdata(3) > 0)){
                cell.vv.frame.size.height = 0.725 * 360
            }
            
        }else if(indexPath.section == 4){
            let cell = tableview.dequeueReusableCellWithIdentifier("totalcell3")! as! totalanalysis3
            cell.graphbtn.tag = 52
            cell.graphbtn.addTarget(self, action: #selector(self.click(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_waste")
            cell.typename.text = "WASTE"
            cell.globalavg.text = String(format: "Global avg : %d", globalavgarr.objectAtIndex(2) as! Int)
            cell.localavg.text = String(format: "Local avg : %d", localavgarr.objectAtIndex(2) as! Int)
            cell.l1.tag = 3001
            cell.l2.tag = 3002
            cell.l3.tag = 3003
            cell.l4.tag = 3004
            cell.slider2.tag = 504
            cell.slider1.tag = 404
            // slider values go from 0 to the number of values in your numbers array
            cell.slider1.minimumValue = 0.0
            cell.slider1.maximumValue = 10.0
            self.slider1changed(cell.slider1)
            // slider values go from 0 to the number of values in your numbers array
            cell.slider1.addTarget(self, action: #selector(self.slider1changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
            cell.slider1.setValue(0.0, animated: true)
            if(wastevalues.count == 0){
                cell.slider2.userInteractionEnabled = false
                cell.l3.hidden = true
                cell.l4.hidden = true
                cell.slider2.hidden = true
                cell.vv.layer.layoutIfNeeded()
            }
            else{
                cell.slider2.hidden = false
                cell.l3.hidden = false
                cell.l4.hidden = false
                cell.slider1.setValue(0.0, animated: true)
                if(wastevalues.count == 1){
                    cell.slider2.userInteractionEnabled = false
                    cell.l3.text = "If I want to increase my score by +1"
                    cell.l4.text = "I need to reduce by emission by \(wastevalues[0])%"
                    cell.slider2.value = Float(wastevalues[0])
                }else{
                    cell.slider2.value = Float(wastevalues.minElement()!)
                }
                cell.slider2.maximumValue = Float(wastevalues.count)
                step1 = Float(wastevalues.count)
            }
            slider2changed(cell.slider2)
            if((wastevalues.count <= 0 && getnumberofdata(4) > 0) || (wastevalues.count > 0 && getnumberofdata(4) <= 0)){
                cell.vv.frame.size.height = 90
            }else if((wastevalues.count > 0 && getnumberofdata(4) > 0) || (wastevalues.count > 0 && getnumberofdata(4) > 0)){
                cell.vv.frame.size.height = 0.725 * 360
            }
            
        }else if(indexPath.section == 5){
            let cell = tableview.dequeueReusableCellWithIdentifier("totalcell3")! as! totalanalysis3
            cell.graphbtn.tag = 53
            cell.graphbtn.addTarget(self, action: #selector(self.click(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_transport")
            cell.typename.text = "TRANSPORTATION"
            cell.globalavg.text = String(format: "Global avg : %d", globalavgarr.objectAtIndex(3) as! Int)
            cell.localavg.text = String(format: "Local avg : %d", localavgarr.objectAtIndex(3) as! Int)
            cell.l1.tag = 4001
            cell.l2.tag = 4002
            cell.l3.tag = 4003
            cell.l4.tag = 4004
            cell.slider2.tag = 505
            cell.slider1.tag = 405
            // slider values go from 0 to the number of values in your numbers array
            cell.slider1.minimumValue = 0.0
            cell.slider1.maximumValue = 10.0
            self.slider1changed(cell.slider1)
            // slider values go from 0 to the number of values in your numbers array
            cell.slider1.addTarget(self, action: #selector(self.slider1changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
            cell.slider1.setValue(0.0, animated: true)
            if(transitvalues.count == 0){
                cell.l3.hidden = true
                cell.l4.hidden = true
                cell.slider2.hidden = true
                cell.slider2.userInteractionEnabled = false
            }
            else{
                cell.slider2.hidden = false
                cell.l3.hidden = false
                cell.l4.hidden = false
                cell.slider1.setValue(0.0, animated: true)
                if(transitvalues.count == 1){
                    cell.slider2.userInteractionEnabled = false
                    cell.l3.text = "If I want to increase my score by +1"
                    cell.l4.text = "I need to reduce by emission by \(transitvalues[0])%"
                    cell.slider2.value = Float(transitvalues[0])
                }else{
                    cell.slider2.value = Float(transitvalues.minElement()!)
                }
                cell.slider2.maximumValue = Float(transitvalues.count)
                step1 = Float(transitvalues.count)
            }
            if((transitvalues.count <= 0 && getnumberofdata(5) > 0) || (transitvalues.count > 0 && getnumberofdata(5) <= 0)){
                cell.vv.frame.size.height = 90
            }else if((transitvalues.count > 0 && getnumberofdata(5) > 0) || (transitvalues.count > 0 && getnumberofdata(5) > 0)){
                cell.vv.frame.size.height = 0.725 * 360
            }
            cell.slider2.addTarget(self, action: #selector(self.slider2changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
            slider2changed(cell.slider2)
            
        }else if(indexPath.section == 6){
            let cell = tableview.dequeueReusableCellWithIdentifier("totalcell3")! as! totalanalysis3
            cell.graphbtn.tag = 54
            cell.graphbtn.addTarget(self, action: #selector(self.click(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.typeimg.image = UIImage.init(named: "ic_lomobile_navitem_human")
            cell.typename.text = "HUMAN EXPERIENCE"
            cell.globalavg.text = String(format: "Global avg : %d", globalavgarr.objectAtIndex(4) as! Int)
            cell.localavg.text = String(format: "Local avg : %d", localavgarr.objectAtIndex(4) as! Int)
            cell.l1.tag = 5001
            cell.l2.tag = 5002
            cell.l3.tag = 5003
            cell.l4.tag = 5004
            cell.slider2.tag = 506
            cell.slider1.tag = 406
            // slider values go from 0 to the number of values in your numbers array
            cell.slider1.minimumValue = 0.0
            cell.slider1.maximumValue = 10.0
            self.slider1changed(cell.slider1)
            // slider values go from 0 to the number of values in your numbers array
            cell.slider1.addTarget(self, action: #selector(self.slider1changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
            cell.slider1.setValue(0.0, animated: true)
            if(humanvalues.count == 0){
                cell.l3.hidden = true
                cell.l4.hidden = true
                cell.slider2.hidden = true
                cell.slider2.userInteractionEnabled = false
            }
            else{
                cell.slider2.hidden = false
                cell.l3.hidden = false
                cell.l4.hidden = false
                cell.slider1.setValue(0.0, animated: true)
                if(humanvalues.count == 1){
                    cell.slider2.userInteractionEnabled = false
                    cell.l3.text = "If I want to increase my score by +1"
                    cell.l4.text = "I need to reduce by emission by \(humanvalues[0])%"
                    cell.slider2.value = Float(humanvalues[0])
                }else{
                    cell.slider2.value = Float(humanvalues.minElement()!)
                }
                cell.slider2.maximumValue = Float(humanvalues.count)
                step1 = Float(humanvalues.count)
                slider2changed(cell.slider2)
            }
            cell.slider2.addTarget(self, action: #selector(self.slider2changed(_:)), forControlEvents: UIControlEvents.ValueChanged)
            slider2changed(cell.slider2)
            if((humanvalues.count <= 0 && getnumberofdata(6) > 0) || (humanvalues.count > 0 && getnumberofdata(6) <= 0)){
                cell.vv.frame.size.height = 90
            }else if((humanvalues.count > 0 && getnumberofdata(6) > 0) || (humanvalues.count > 0 && getnumberofdata(6) > 0)){
                cell.vv.frame.size.height = 0.725 * 360
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
        if(indexPath.section == 7){
            let _ = tableview.dequeueReusableCellWithIdentifier("certcell")!
        }
        
    }
    
    
    func slider1changed(sender: UISlider){
        if(analysisdict.count > 0){
            var tag = 0
            if(sender.tag == 402){
                tag = 1001
            }else if(sender.tag == 403){
                tag = 2001
            }else if(sender.tag == 404){
                tag = 3001
            }else if(sender.tag == 405){
                tag = 4001
            }else if(sender.tag == 406){
                tag = 5001
            }
            if(self.view.viewWithTag(tag) != nil){
                let label1 = self.view.viewWithTag(tag) as! UILabel
                let label2 = self.view.viewWithTag(tag+1) as! UILabel
                
                //print(sender.value)
                let roundedValue = round(sender.value / step) * step
                sender.value = roundedValue
                if(sender.value == 0.0){
                    label1.text = "If I reduce my emissions by 10%"
                    var key = ""
                    let dict = self.analysisdict.mutableCopy() as! NSMutableDictionary
                    if(sender.tag-400 == 2){
                        key = "energy"
                    }else if(sender.tag-400 == 3){
                        key = "water"
                    }else if(sender.tag-400 == 4){
                        key = "waste"
                    }else if(sender.tag-400 == 5){
                        key = "transit"
                    }else if(sender.tag-400 == 6){
                        key = "human"
                    }
                    if(dict[key] is NSNull || dict[key] == nil){
                        label2.text = "Not available"
                    }else{
                        if(dict[key]!["info_json"] is NSNull){
                            label2.text = "Not available"
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
                                let getkey = "\(dict[key]!["category"]!! as! String) Plaque Score with 10% Lower Emissions"
                                if let _ = dict[key]!["info_json"]!![getkey] as? Int {
                                    // action is not nil, is a String type, and is now stored in actionString
                                    label2.text = String(format:"My new %@ score will be %d",dict[key]!["category"]!! as! String,dict[key]!["info_json"]!![getkey] as! Int)
                                }else{
                                    label2.text = "Not available"
                                }
                            }catch{
                                
                            }
                        }
                    }
                    
                }else if(sender.value == 5.0){
                    label1.text = "If I reduce my emissions by 20%"
                    var key = ""
                    let dict = self.analysisdict.mutableCopy() as! NSMutableDictionary
                    if(sender.tag-400 == 2){
                        key = "energy"
                    }else if(sender.tag-400 == 3){
                        key = "water"
                    }else if(sender.tag-400 == 4){
                        key = "waste"
                    }else if(sender.tag-400 == 5){
                        key = "transit"
                    }else if(sender.tag-400 == 6){
                        key = "human"
                    }
                    if(dict[key] is NSNull){
                        label2.text = "Not available"
                    }else{
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
                                let getkey = "\(dict[key]!["category"]!! as! String) Plaque Score with 20% Lower Emissions"
                                if let _ = dict[key]!["info_json"]!![getkey] as? Int {
                                    // action is not nil, is a String type, and is now stored in actionString
                                    label2.text = String(format:"My new %@ score will be %d",dict[key]!["category"]!! as! String,dict[key]!["info_json"]!![getkey] as! Int)
                                }else{
                                    label2.text = "Not available"
                                }
                            }catch{
                                
                            }
                        }
                    }
                    
                }else if(sender.value == 10.0){
                    label1.text = "If I reduce my emissions by 50%"
                    var key = ""
                    let dict = self.analysisdict.mutableCopy() as! NSMutableDictionary
                    if(sender.tag-400 == 2){
                        key = "energy"
                    }else if(sender.tag-400 == 3){
                        key = "water"
                    }else if(sender.tag-400 == 4){
                        key = "waste"
                    }else if(sender.tag-400 == 5){
                        key = "transit"
                    }else if(sender.tag-400 == 6){
                        key = "human"
                    }
                    if(dict[key] is NSNull){
                        label2.text = "Not available"
                    }else{
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
                                let getkey = "\(dict[key]!["category"]!! as! String) Plaque Score with 50% Lower Emissions"
                                
                                //print(dict[key]!["category"]!! as! String)
                                if let _ = dict[key]!["info_json"]!![getkey] as? Int {
                                    // action is not nil, is a String type, and is now stored in actionString
                                    label2.text = String(format:"My new %@ score will be %d",dict[key]!["category"]!! as! String,dict[key]!["info_json"]!![getkey] as! Int)
                                }else{
                                    label2.text = "Not available"
                                }
                            }catch{
                                
                            }
                        }
                    }
                }
                if(sender.tag == 403){
                    let label1 = self.view.viewWithTag(2001) as! UILabel
                    let _ = self.view.viewWithTag(2002) as! UILabel
                    
                    //print(sender.value)
                    let roundedValue = round(sender.value / step) * step
                    sender.value = roundedValue
                    if(sender.value == 0.0){
                        label1.text = "If I reduce my emissions by 10%"
                    }else if(sender.value == 5.0){
                        label1.text = "If I reduce my emissions by 20%"
                    }else if(sender.value == 10.0){
                        label1.text = "If I reduce my emissions by 50%"
                    }
                    //print(sender.value)
                }
                if(sender.tag == 404){
                    let label1 = self.view.viewWithTag(3001) as! UILabel
                    let _ = self.view.viewWithTag(3002) as! UILabel
                    
                    //print(sender.value)
                    let roundedValue = round(sender.value / step) * step
                    sender.value = roundedValue
                    if(sender.value == 0.0){
                        label1.text = "If I reduce my emissions by 10%"
                    }else if(sender.value == 5.0){
                        label1.text = "If I reduce my emissions by 20%"
                    }else if(sender.value == 10.0){
                        label1.text = "If I reduce my emissions by 50%"
                    }
                    //print(sender.value)
                }
                if(sender.tag == 405){
                    let label1 = self.view.viewWithTag(4001) as! UILabel
                    let _ = self.view.viewWithTag(4002) as! UILabel
                    
                    //print(sender.value)
                    let roundedValue = round(sender.value / step) * step
                    sender.value = roundedValue
                    if(sender.value == 0.0){
                        label1.text = "If I reduce my emissions by 10%"
                    }else if(sender.value == 5.0){
                        label1.text = "If I reduce my emissions by 20%"
                    }else if(sender.value == 10.0){
                        label1.text = "If I reduce my emissions by 50%"
                    }
                    //print(sender.value)
                }
                if(sender.tag == 406){
                    let label1 = self.view.viewWithTag(5001) as! UILabel
                    let _ = self.view.viewWithTag(5002) as! UILabel
                    
                    //print(sender.value)
                    let roundedValue = round(sender.value / step) * step
                    sender.value = roundedValue
                    if(sender.value == 0.0){
                        label1.text = "If I reduce my emissions by 10%"
                    }else if(sender.value == 5.0){
                        label1.text = "If I reduce my emissions by 20%"
                    }else if(sender.value == 10.0){
                        label1.text = "If I reduce my emissions by 50%"
                    }
                    //print(sender.value)
                }
            }
        }
    }
    
    func slider2changed(sender: UISlider){
        if(self.analysisdict.count > 0 ){
            var tag = 0
            //print(sender.value)
            let roundedValue = round(sender.value / step1) * step1
            sender.value = roundedValue
            //print(sender.value)
            var temp = [String:AnyObject]()
            var tagstring = ""
            var tempemissions = [Int]()
            var tempvalues = [Int]()
            var score = 0
            if(sender.tag == 502){
                tag = 1003
                tagstring = "energy"
                tempemissions = energyemissions
                tempvalues = energyvalues
                score = energyscore
            }else if(sender.tag == 503){
                tag = 2003
                tagstring = "water"
                tempemissions = wateremissions
                tempvalues = watervalues
                score = waterscore
            }else if(sender.tag == 504){
                tag = 3003
                tagstring = "waste"
                tempemissions = wasteemissions
                tempvalues = wastevalues
                score = wastescore
            }else if(sender.tag == 505){
                tag = 4003
                tagstring = "transport"
                tempemissions = transitemissions
                tempvalues = transitvalues
                score = transportscore
            }else if(sender.tag == 506){
                tag = 5003
                tagstring = "human"
                tempemissions = humanemissions
                tempvalues = humanvalues
                score = humanscore
            }
            if(tempvalues.count > 0){
                if(self.view.viewWithTag(tag) != nil){
                    let label1 = self.view.viewWithTag(tag) as! UILabel
                    let label2 = self.view.viewWithTag(tag+1) as! UILabel
                    for i in 0..<tempvalues.count{
                        temp["\(tempemissions[i])"] = tempvalues[i]
                    }
                    //print(temp)
                    var sortedkeys = tempemissions.sort { $0 < $1 }
                    //print(sortedkeys,Int(Int(roundedValue)/Int(step1)))
                    if(Int(Int(roundedValue)/Int(step1)) < sortedkeys.count){
                        label1.text = "if I want to increase my \(tagstring) score by +\(sortedkeys[Int(Int(roundedValue)/Int(step1))]-score)"
                        let index = Int(roundedValue)/Int(step1)
                        
                        let str = String(format: "%d",sortedkeys[Int(index)])
                        //print(str)
                        label2.text = String(format: "I will need to reduce emissions by %d%%",temp [str] as! Int)
                    }
                }
            }/*else{
             label1.text = "if I want to increase my \(tagstring) score by \(sortedkeys[Int(Int(roundedValue)/Int(step1))-1])"
             var index = Int(roundedValue)/Int(step1)
             
             var str = String(format: "%d",sortedkeys[Int(index-1)])
             //print(str)
             label2.text = String(format: "I will need to reduce emissions by %d%%",temp [str] as! Int)
             }*/
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
        }else if(indexPath.section == 1){
            
            let _ = AVSpeechSynthesizer()
            var _ = AVSpeechUtterance(string: "")
            /*var texttobespelled = ""
            if(currentscore == 0){
                texttobespelled = "Seems like you don't have a LEED score for this project."
            }else {
                texttobespelled = "Your project score is \(currentscore). Human experience score is \(humanscore), Transportation score is \(transportscore), Waste score is \(wastescore), Water score is \(waterscore), Energy score is \(energyscore)"
            }
            myUtterance = AVSpeechUtterance(string: texttobespelled)
             var speechvoices = AVSpeechSynthesisVoice.speechVoices()
             print(speechvoices.count, speechvoices)
             //myUtterance.voice = AVSpeechSynthesisVoice.init(language: "en-US")
             myUtterance.rate = 0.5;
             //myUtterance.pitchMultiplier = 1;
             synth.speakUtterance(myUtterance)*/
            if(reportedscores.count > 0){
            self.performSegueWithIdentifier("gotographs", sender: nil)
            }
        }
        else{
            if(indexPath.section != 7){
            let button = UIButton()
            button.tag = 48 + indexPath.section
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
            }else if(sel == 51){
                vc.type = "water"
                vc.mttitlearr = ["Gallons/occupant", "Gallons/square foot"]
                vc.startcolor = UIColor.init(red: 0.801, green: 0.948, blue: 0.952, alpha: 1)
                vc.endcolor = UIColor.init(red: 0.303, green: 0.751, blue: 0.94, alpha: 1)
                
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
                
                vc.str1 = "0.000"
                vc.str2 = "0.000"
                
            }else if(sel == 54){
                vc.type = "human_experience"
                vc.startcolor = UIColor.init(red: 0.901, green: 0.867, blue: 0.603, alpha: 1)
                vc.endcolor = UIColor.init(red: 0.92, green: 0.609, blue: 0.236, alpha: 1)
                vc.str1 = "0.000"
                vc.str2 = "0.000"
            }
            vc.reportedscores = reportedscores
            
            
        }
    }
    
    
    func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if(section == 2){
        return 60
        }
        return 1
    }
    
    func tableView(tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 2){
            return "Last 12 months"
        }
        
        return ""
    }
    
    
    func showalert(message:String, title:String, action:String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                self.view.userInteractionEnabled = true
                self.spinner.hidden = true
                self.tableview.alpha = 1.0
               // self.navigationController?.popViewControllerAnimated(true)
            })
            
        }
        let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
        
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


