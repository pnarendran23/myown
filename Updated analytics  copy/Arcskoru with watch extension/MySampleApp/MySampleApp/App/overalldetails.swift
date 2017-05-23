//
//  overalldetails.swift
//  LEEDOn
//
//  Created by Group X on 22/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class overalldetails: UIViewController,UITableViewDataSource,UITableViewDelegate, UITabBarDelegate {
    @IBOutlet weak var tableview: UITableView!
var titlearr = NSMutableArray()
var valuearr = NSMutableArray()
var datearr = NSMutableArray()
    var selectedtitle = String()
    var sectiontitlearr = NSArray()
var energymax = 0
    var totalannumarr = NSMutableArray()
    var totaldailyarr = NSMutableArray()
    var scope1annumarr = NSMutableArray()
    var scope2annumarr = NSMutableArray()
    var scope1dailyarr = NSMutableArray()
    var scope2dailyarr = NSMutableArray()
    var transitannumarr = NSMutableArray()
    var transitdailyarr = NSMutableArray()
    var watermax = 0
    var analysisdict = NSDictionary()
    var wastemax = 0
    var transportmax = 0    
    var humanmax = 0
    var energymin = 0
    var watermin = 0
    var wastemin = 0
    var transportmin = 0
    var humanmin = 0
    var leftarr = NSArray()
    var rightarr = NSArray()
    var buildingdetails = [String:AnyObject]()
    var highduringreport = 0
    var globalavgarr = NSMutableArray()
    
    @IBOutlet weak var spinner: UIView!
    override func viewWillDisappear(animated: Bool) {
        
        var buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        self.navigationItem.title = buildingdetails["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as? String
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        navigationItem.title = "Consumed emissions"
        self.navigationController?.navigationBar.backItem?.title = "Analytics"
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
    var reportedscores = NSMutableArray()
    var countries = [String:AnyObject]()
    var globaldata = [String:AnyObject]()
    var performancedata = [String:AnyObject]()
    var localdata = [String:AnyObject]()
    var fullcountryname = ""    
    var currentscore = 0
    var isloaded = false
    var maxscore = 0
    var sel = 0
    var energyscore = 0
    var waterscore = 0
    var wastescore = 0
    var transportscore = 0
    var humanscore = 0
    var duration = ""
    var fullstatename = ""
    var toload = true
    var scoresarr = NSMutableArray()

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        //self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 0.937, green: 0.937, blue: 0.957, alpha: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
        navigationItem.title = "Consumed emissions"
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
        var temparr = NSArray.init(objects: "Gross Floor area","Hours","Occupants","Reporting period")
        //titlearr.addObject(temparr)
        temparr = NSArray.init(objects: "Project","Per Sq. Ft","Per OCC")
        titlearr.addObject(temparr)
        temparr = NSArray.init(objects: "Project","Per Sq. Ft","Per OCC")
        titlearr.addObject(temparr)
        temparr = NSArray.init(objects: "Project","Per Sq. Ft","Per OCC")
        titlearr.addObject(temparr)
        temparr = NSArray.init(objects: "Project","Per Sq. Ft","Per OCC")
        titlearr.addObject(temparr)
        temparr = NSArray.init(objects: "Project","Per Sq. Ft","Per OCC")
        titlearr.addObject(temparr)
        temparr = NSArray.init(objects: "Project","Per Sq. Ft","Per OCC")
        titlearr.addObject(temparr)
        temparr = NSArray.init(objects: "Project","Per Sq. Ft","Per OCC")
        titlearr.addObject(temparr)
        temparr = NSArray.init(objects: "Project","Per Sq. Ft","Per OCC")
        titlearr.addObject(temparr)
        print("title arr",titlearr)
        sectiontitlearr = NSArray.init(objects: "TOTAL ANNUAL CARBON EMISSIONS (MTCO2e)","TOTAL DAILY CARBON EMISSIONS (MTCO2e)","ENERGY ANNUAL SCOPE 1 CARBON EMISSIONS (MTCO2e)","ENERGY DAILY SCOPE 1 CARBON EMISSIONS (MTCO2e)","ENERGY ANNUAL SCOPE 2 CARBON EMISSIONS (MTCO2e)","ENERGY DAILY SCOPE 2 CARBON EMISSIONS (MTCO2e)","TRANSPORTATION ANNUAL CARBON EMISSIONS (MTCO2e)","TRANSPORTATION DAILY CARBON EMISSIONS (MTCO2e)")
        var arr : NSMutableArray = []
        var buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]        
        if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
            
            arr.addObject(0.00000)
        }else{
            arr.addObject(String(format:"%d",buildingdetails["gross_area"] as! Int))
        }
        
        if(buildingdetails["operating_hours"] == nil || buildingdetails["operating_hours"] is NSNull){
            arr.addObject(0.00000)
        }else{
            
            arr.addObject(String(format:"%d",buildingdetails["operating_hours"] as! Int))
        }
        
        
        if(buildingdetails["occupancy"] == nil || buildingdetails["occupancy"] is NSNull){
            arr.addObject(0.00000)
        }else{
            arr.addObject(String(format:"%d",buildingdetails["occupancy"] as! Int))
        }
        
        print(datearr)
        var date1 = NSDate()
        var date2 = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        date1 = formatter.dateFromString(datearr.firstObject as! String)!
        date2 = formatter.dateFromString(datearr.lastObject as! String)!
        formatter.dateFormat = "MMM yyyy"                
        
        arr.addObject(String(format: "%@ to %@",formatter.stringFromDate(date2),formatter.stringFromDate(date1)))
       // valuearr.addObject(arr)
        print(analysisdict["energy"])
        if(analysisdict["energy"] != nil ){
            if(analysisdict["energy"]!["info_json"] != nil){
        var str = analysisdict["energy"]!["info_json"] as! String
        var str1 = NSMutableString()
        str1.appendString(str)
        str = str.stringByReplacingOccurrencesOfString("'", withString: "\"")
        str = str.stringByReplacingOccurrencesOfString("None", withString: "\"None\"")
        print(str1)
        //str = str1.mutableCopy() as! String
        var dict = NSDictionary()
        var jsonData = str
        do {
            if(convertStringToDictionary(str) != nil){
        dict = convertStringToDictionary(str)!
            
            }
        }catch{
            
        }
        arr = []
        if(dict.count > 0){
            print(dict["Scope1 Raw GHG (mtCO2e/day)"])
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
                if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                }else{
                    gross = Float( buildingdetails["gross_area"] as! Int)
                }
                arr.addObject((dict["Scope1 Raw GHG (mtCO2e/day)"] as! Float  * 365.0) / gross )
            }
            
            if(dict["Scope1 Raw GHG (mtCO2e/day)"] is NSNull || dict["Scope1 Raw GHG (mtCO2e/day)"] == nil){
                arr.addObject(0.00000)
            }else if(dict["Scope1 Raw GHG (mtCO2e/day)"] as? String == "None"){
                arr.addObject(0.00000)
            }else{
                var occupant = 0.0 as! Float
                if(buildingdetails["gross_area"] == nil || buildingdetails["occupancy"] is NSNull){
                }else{
                    occupant = Float( buildingdetails["occupancy"] as! Int)
                }
                arr.addObject((dict["Scope1 Raw GHG (mtCO2e/day)"] as! Float  * 365.0) / occupant )
            }
            scope1annumarr = arr
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
                if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                }else{
                    gross = Float( buildingdetails["gross_area"] as! Int)
                }
                arr.addObject((dict["Scope1 Raw GHG (mtCO2e/day)"] as! Float) / gross )
            }
            
            if(dict["Scope1 Raw GHG (mtCO2e/day)"] is NSNull || dict["Scope1 Raw GHG (mtCO2e/day)"] == nil){
                arr.addObject(0.00000)
            }else if(dict["Scope1 Raw GHG (mtCO2e/day)"] as? String == "None"){
                arr.addObject(0.00000)
            }else{
                var occupant = 0.0 as! Float
                if(buildingdetails["gross_area"] == nil || buildingdetails["occupancy"] is NSNull){
                }else{
                    occupant = Float( buildingdetails["occupancy"] as! Int)
                }
                arr.addObject((dict["Scope1 Raw GHG (mtCO2e/day)"] as! Float) / occupant )
            }
            scope1dailyarr = arr
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
                if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                }else{
                    gross = Float( buildingdetails["gross_area"] as! Int)
                }
                arr.addObject((dict["Scope2 Raw GHG (mtCO2e/day)"] as! Float  * 365.0) / gross )
            }
            
            if(dict["Scope2 Raw GHG (mtCO2e/day"] is NSNull || dict["Scope2 Raw GHG (mtCO2e/day)"] == nil){
                arr.addObject(0.00000)
            }else if(dict["Scope2 Raw GHG (mtCO2e/day)"] as? String == "None"){
                arr.addObject(0.00000)
            }else{
                var occupant = 0.0 as! Float
                if(buildingdetails["gross_area"] == nil || buildingdetails["occupancy"] is NSNull){
                }else{
                    occupant = Float( buildingdetails["occupancy"] as! Int)
                }
                arr.addObject((dict["Scope2 Raw GHG (mtCO2e/day)"] as! Float  * 365.0) / occupant )
            }
            scope2annumarr = arr
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
                if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                }else{
                    gross = Float( buildingdetails["gross_area"] as! Int)
                }
                arr.addObject((dict["Scope2 Raw GHG (mtCO2e/day)"] as! Float) / gross )
            }
            
            if(dict["Scope2 Raw GHG (mtCO2e/day"] is NSNull || dict["Scope2 Raw GHG (mtCO2e/day)"] == nil){
                arr.addObject(0.00000)
            }else if(dict["Scope2 Raw GHG (mtCO2e/day)"] as? String == "None"){
                arr.addObject(0.00000)
            }else{
                var occupant = 0.0 as! Float
                if(buildingdetails["gross_area"] == nil || buildingdetails["occupancy"] is NSNull){
                }else{
                    occupant = Float( buildingdetails["occupancy"] as! Int)
                }
                arr.addObject((dict["Scope2 Raw GHG (mtCO2e/day)"] as! Float ) / occupant )
            }
            scope2dailyarr = arr
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
                    if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                    }else{
                        gross = Float( buildingdetails["gross_area"] as! Int)
                    }
                    arr.addObject((dict["Raw GHG (mtCO2e/day)"] as! Float  * 365.0) / gross ))
                }
            
            if(dict["Raw GHG (mtCO2e/day)"] is NSNull){
                arr.addObject(0.00000)
            }else{
                var occupant = 0.0 as! Float
                if(buildingdetails["gross_area"] == nil || buildingdetails["occupancy"] is NSNull){
                }else{
                    occupant = Float( buildingdetails["occupancy"] as! Int)
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
                if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                }else{
                    gross = Float( buildingdetails["gross_area"] as! Int)
                }
                arr.addObject((dict["Raw GHG (mtCO2e/day)"] as! Float) / gross ))
            }
            
            if(dict["Raw GHG (mtCO2e/day)"] is NSNull){
                arr.addObject(0.00000)
            }else{
                var occupant = 0.0 as! Float
                if(buildingdetails["gross_area"] == nil || buildingdetails["occupancy"] is NSNull){
                }else{
                    occupant = Float( buildingdetails["occupancy"] as! Int)
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
                if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                }else{
                    gross = Float( buildingdetails["gross_area"] as! Int)
                }
                arr.addObject((dict["Adjusted Emissions per SF"] as! Float * 365.0) / gross ))
            }
            
            if(dict["Adjusted Emissions per SF"] is NSNull){
                arr.addObject(0.00000)
            }else{
                var occupant = 0.0 as! Float
                if(buildingdetails["gross_area"] == nil || buildingdetails["occupancy"] is NSNull){
                }else{
                    occupant = Float( buildingdetails["occupancy"] as! Int)
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
                if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                }else{
                    gross = Float( buildingdetails["gross_area"] as! Int)
                }
                arr.addObject((dict["Adjusted Emissions per SF"] as! Float) / gross ))
            }
            
            if(dict["Adjusted Emissions per SF"] is NSNull){
                arr.addObject(0.00000)
            }else{
                var occupant = 0.0 as! Float
                if(buildingdetails["gross_area"] == nil || buildingdetails["occupancy"] is NSNull){
                }else{
                    occupant = Float( buildingdetails["occupancy"] as! Int)
                }
                arr.addObject((dict["Adjusted Emissions per SF"] as! Float) / occupant ))
            }
            valuearr.addObject(arr)*/
            }
            }
 
            if(analysisdict["transit"] != nil){
                if(analysisdict["transit"]!["info_json"] != nil){
            arr = NSMutableArray()
            print(valuearr)
            var str = analysisdict["transit"]!["info_json"] as! String
            var str1 = NSMutableString()
            str1.appendString(str)
            str1.replaceOccurrencesOfString("'", withString: "\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
            str = str.stringByReplacingOccurrencesOfString("'", withString: "\"")
            str = str.stringByReplacingOccurrencesOfString("None", withString: "\"None\"")
            print(str1)
            //str = str1.mutableCopy() as! String
            var dict = NSDictionary()
            var jsonData = str
            do {
                if(convertStringToDictionary(str) != nil){
                 dict = convertStringToDictionary(str)!
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
                        if(buildingdetails["gross_area"] == nil || buildingdetails["occupancy"] is NSNull){
                        }else{
                            occupant = Float( buildingdetails["occupancy"] as! Int)
                        }
                        arr.addObject((dict["Average Transit CO2e"] as! Float) * occupant * 365)
                    }
                    
                    if(dict["Average Transit CO2e"] is NSNull || dict["Average Transit CO2e"] == nil){
                        arr.addObject(0.00000)
                    }else if(dict["Average Transit CO2e"] as? String == "None"){
                        arr.addObject(0.00000)
                    }else{
                        var gross = 0.0 as! Float
                        if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                        }else{
                            gross = Float( buildingdetails["gross_area"] as! Int)
                        }
                        arr.addObject(0.00000)
                    }
                    print(arr)
                    
                    
                    if(dict["Average Transit CO2e"] is NSNull || dict["Average Transit CO2e"] == nil){
                        arr.addObject(0.00000)
                    }else if(dict["Average Transit CO2e"] as? String == "None"){
                        arr.addObject(0.00000)
                    }else{
                        arr.addObject(dict["Average Transit CO2e"] as! Float * 365)
                    }
                    
                    print(arr)

                    
            transitannumarr = arr
                    
            //valuearr.addObject(arr)
            arr = NSMutableArray()
                    if(dict["Average Transit CO2e"] is NSNull || dict["Average Transit CO2e"] == nil){
                        arr.addObject(0.00000)
                    }else if(dict["Average Transit CO2e"] as? String == "None"){
                        arr.addObject(0.00000)
                    }else{
                        var occupant = 0.0 as! Float
                        if(buildingdetails["gross_area"] == nil || buildingdetails["occupancy"] is NSNull){
                        }else{
                            occupant = Float( buildingdetails["occupancy"] as! Int)
                        }
                        arr.addObject((dict["Average Transit CO2e"] as! Float) * occupant )
                    }
                    
            if(dict["Average Transit CO2e"] is NSNull || dict["Average Transit CO2e"] == nil){
                arr.addObject(0.00000)
            }else if(dict["Average Transit CO2e"] as? String == "None"){
                arr.addObject(0.00000)
            }else{
                var gross = 0.0 as! Float
                if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                }else{
                    gross = Float( buildingdetails["gross_area"] as! Int)
                }
                arr.addObject(0.00000)
            }
            print(arr)
            
                    
                    if(dict["Average Transit CO2e"] is NSNull || dict["Average Transit CO2e"] == nil){
                        arr.addObject(0.00000)
                    }else if(dict["Average Transit CO2e"] as? String == "None"){
                        arr.addObject(0.00000)
                    }else{
                        arr.addObject(dict["Average Transit CO2e"] as! Float)
                    }

            print(arr)
            //valuearr.addObject(arr)
            transitdailyarr = arr
            arr = NSMutableArray()
            }
            }
            //
        }
        
        var num1 = 0.00000, num2 = 0.00000, num3 = 0.00000
        var tmparr = NSMutableArray()
        var tmp = 0.00000 as! Float
        if(scope1dailyarr.count > 1 && transitdailyarr.count > 1){
        tmp = (scope1dailyarr[0] as! Float) + (scope2dailyarr[0] as! Float) + (transitdailyarr[0] as! Float)
        totaldailyarr.addObject(tmp as! Float)
        tmp = (scope1dailyarr[1] as! Float) + (scope2dailyarr[1] as! Float) + (transitdailyarr[1] as! Float)
        totaldailyarr.addObject(tmp as! Float)
        tmp = (scope1dailyarr[2] as! Float) + (scope2dailyarr[2] as! Float) + (transitdailyarr[2] as! Float)
        totaldailyarr.addObject(tmp as! Float)
        }else{
            
            totaldailyarr.addObject(num1)
            totaldailyarr.addObject(num1)
            totaldailyarr.addObject(num1)
        }
        
        num1 = 0.00000
        num2 = 0.00000
        num3 = 0.00000
        
        tmparr = NSMutableArray()
        tmp = 0.00000 as! Float
        if(scope1annumarr.count > 1 && transitannumarr.count > 1){
        tmp = (scope1annumarr[0] as! Float) + (scope2annumarr[0] as! Float) + (transitannumarr[0] as! Float)
        totalannumarr.addObject(tmp as! Float)
        tmp = (scope1annumarr[1] as! Float) + (scope2annumarr[1] as! Float) + (transitannumarr[1] as! Float)
        totalannumarr.addObject(tmp as! Float)
        tmp = (scope1annumarr[2] as! Float) + (scope2annumarr[2] as! Float) + (transitannumarr[2] as! Float)
        totalannumarr.addObject(tmp as! Float)
        }else{
            totalannumarr.addObject(num1)
            totalannumarr.addObject(num1)
            totalannumarr.addObject(num1)
        }
        
        
        if(scope1annumarr.count == 0){
            scope1annumarr.addObject(num1)
            scope1annumarr.addObject(num1)
            scope1annumarr.addObject(num1)
        }
        
        if(scope2annumarr.count == 0){
            scope2annumarr.addObject(num1)
            scope2annumarr.addObject(num1)
            scope2annumarr.addObject(num1)
        }
        
        if(scope1dailyarr.count == 0){
            scope1dailyarr.addObject(num1)
            scope1dailyarr.addObject(num1)
            scope1dailyarr.addObject(num1)
        }
        if(scope2dailyarr.count == 0){
            scope2dailyarr.addObject(num1)
            scope2dailyarr.addObject(num1)
            scope2dailyarr.addObject(num1)
        }
        if(transitannumarr.count == 0){
            transitdailyarr.addObject(num1)
            transitdailyarr.addObject(num1)
            transitdailyarr.addObject(num1)
        }
        if(transitdailyarr.count == 0){
            transitdailyarr.addObject(num1)
            transitdailyarr.addObject(num1)
            transitdailyarr.addObject(num1)
        }

        
        print("scope1 annum",scope1annumarr)
        print("scope2 annum",scope2annumarr)
        print("scope1 daily",scope1dailyarr)
        print("scope2 daily",scope2dailyarr)
        print("total annum",totalannumarr)
        print("total daily",totaldailyarr)
        print("transit annum",transitannumarr)
        print("transit daily",transitdailyarr)
        
        
   /*     GHG * 365.0
        (GHG * 365.0) / 20000
        (GHG * 365.0) / 40*/
        
        
        
        //[myDictionary valueForKeyPath:@"@max.age"];
        // Do any additional setup after loading the view.
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
    
    func getmax(type:String,arr:NSMutableArray){
        var temparr = [Int]()
        for dict in arr{
            print(dict)
            if(dict[type] is NSNull || dict[type] == nil){
                temparr.append(0)
            }else{
                temparr.append(dict[type] as! Int)
            }
        }
        
        if(type == "energy"){
            energymax = temparr.maxElement()!
        }else if(type == "water"){
            watermax = temparr.maxElement()!
        }else if(type == "waste"){
            wastemax = temparr.maxElement()!
        }else if(type == "transport"){
            transportmax = temparr.maxElement()!
        }else if(type == "human_experience"){
            humanmax = temparr.maxElement()!
        }
    
    }
    
    
    func getmin(type:String,arr:NSMutableArray){
        var temparr = [Int]()
        for dict in arr{
            print(dict)
            if(dict[type] is NSNull || dict[type] == nil){
                temparr.append(0)
            }else{
                temparr.append(dict[type] as! Int)
            }
        }
        
        if(type == "energy"){
            energymin = temparr.minElement()!
        }else if(type == "water"){
            watermin = temparr.minElement()!
        }else if(type == "waste"){
            wastemin = temparr.minElement()!
        }else if(type == "transport"){
            transportmin = temparr.minElement()!
        }else if(type == "human_experience"){
            humanmin = temparr.minElement()!
        }
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       // if(valuearr.count > 0){
        selectedtitle = sectiontitlearr.objectAtIndex(indexPath.row) as! String
        leftarr = titlearr.objectAtIndex(indexPath.row) as! NSArray
        if(indexPath.row == 0){
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
        }
        //rightarr = valuearr.objectAtIndex(indexPath.row) as! NSArray
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("gotoemissions", sender: nil)
        //}
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
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlearr.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as! UITableViewCell
        cell.textLabel?.text = sectiontitlearr[indexPath.row].capitalizedString as! String
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.textLabel?.font = UIFont.init(name: "OpenSans", size: 11)
        cell.textLabel?.numberOfLines = 2
       /* var leftarr = titlearr.objectAtIndex(indexPath.section) as! NSArray
        if(indexPath.section == 0){
            var rightarr = valuearr.objectAtIndex(indexPath.section) as! NSArray
            cell.detailTextLabel?.text = rightarr.objectAtIndex(indexPath.row) as! String
            cell.textLabel?.text = leftarr.objectAtIndex(indexPath.row) as! String
        }else{
            var rightarr = valuearr.objectAtIndex(indexPath.section) as! NSArray
            cell.detailTextLabel?.text = rightarr.objectAtIndex(indexPath.row) as! String
            cell.textLabel?.text = leftarr.objectAtIndex(indexPath.row) as! String
            if(cell.detailTextLabel?.text == "0.00000"){
               cell.detailTextLabel?.text = 0.00000
            }
        }
        */
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "CARBON"
    }
    
    @IBOutlet weak var tabbar: UITabBar!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "gotoemissions"){
        let vc = segue.destinationViewController as! emissions
            vc.leftarr = leftarr
            vc.rightarr = rightarr
            vc.sectiontitle = selectedtitle
        }else{
        var nav = segue.destinationViewController as! UINavigationController
        let vc = nav.viewControllers[0] as! totalanalytics
        vc.callrequest = 0
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
