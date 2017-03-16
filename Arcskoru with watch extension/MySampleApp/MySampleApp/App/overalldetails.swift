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
        if(notificationsarr.count > 0 ){
            self.tabbar.items![4].badgeValue = "\(notificationsarr.count)"
        }else{
            self.tabbar.items![4].badgeValue = nil
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
        print("title arr",titlearr)
        sectiontitlearr = NSArray.init(objects: "Total annual carbon emissions","Total daily carbon emissions","Energy annual carbon emissions","Energy daily carbon emissions","Transportation annual carbon emissions","Transportation daily carbon emissions")
        var arr : NSMutableArray = []
        var buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]        
        if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
            
            arr.addObject("0")
        }else{
            arr.addObject(String(format:"%d",buildingdetails["gross_area"] as! Int))
        }
        
        if(buildingdetails["operating_hours"] == nil || buildingdetails["operating_hours"] is NSNull){
            arr.addObject("0")
        }else{
            
            arr.addObject(String(format:"%d",buildingdetails["operating_hours"] as! Int))
        }
        
        
        if(buildingdetails["occupancy"] == nil || buildingdetails["occupancy"] is NSNull){
            arr.addObject("0")
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
        str1.replaceOccurrencesOfString("'", withString: "\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
        print(str1)
        str = str1.mutableCopy() as! String
        var dict = NSDictionary()
        var jsonData = (str).dataUsingEncoding(NSUTF8StringEncoding)
        do {
        dict = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions()) as! NSDictionary
            print(dict)
            
        }catch{
            
        }
        arr = []
        if(dict.count > 0){
            if(dict["Raw GHG (mtCO2e/day)"] is NSNull){
                arr.addObject("0")
            }else{
                arr.addObject(String(format:"%.5f",dict["Raw GHG (mtCO2e/day)"] as! Float  * 365 ))
            }
                if(dict["Raw GHG (mtCO2e/day)"] is NSNull){
                    arr.addObject("0")
                }else{
                    var gross = 0.0 as! Float
                    if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                    }else{
                        gross = Float( buildingdetails["gross_area"] as! Int)
                    }
                    arr.addObject(String(format:"%.5f",(dict["Raw GHG (mtCO2e/day)"] as! Float  * 365) / gross ))
                }
            
            if(dict["Raw GHG (mtCO2e/day)"] is NSNull){
                arr.addObject("0")
            }else{
                var occupant = 0.0 as! Float
                if(buildingdetails["gross_area"] == nil || buildingdetails["occupancy"] is NSNull){
                }else{
                    occupant = Float( buildingdetails["occupancy"] as! Int)
                }
                arr.addObject(String(format:"%.5f",(dict["Raw GHG (mtCO2e/day)"] as! Float  * 365) / occupant ))
            }
            valuearr.addObject(arr)
            arr = []
            if(dict["Raw GHG (mtCO2e/day)"] is NSNull){
                arr.addObject("0")
            }else{
                arr.addObject(String(format:"%.5f",dict["Raw GHG (mtCO2e/day)"] as! Float))
            }
            if(dict["Raw GHG (mtCO2e/day)"] is NSNull){
                arr.addObject("0")
            }else{
                var gross = 0.0 as! Float
                if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                }else{
                    gross = Float( buildingdetails["gross_area"] as! Int)
                }
                arr.addObject(String(format:"%.5f",(dict["Raw GHG (mtCO2e/day)"] as! Float) / gross ))
            }
            
            if(dict["Raw GHG (mtCO2e/day)"] is NSNull){
                arr.addObject("0")
            }else{
                var occupant = 0.0 as! Float
                if(buildingdetails["gross_area"] == nil || buildingdetails["occupancy"] is NSNull){
                }else{
                    occupant = Float( buildingdetails["occupancy"] as! Int)
                }
                arr.addObject(String(format:"%.5f",(dict["Raw GHG (mtCO2e/day)"] as! Float) / occupant ))
            }
            valuearr.addObject(arr)
            arr = []
            if(dict["Adjusted Emissions per SF"] is NSNull){
                arr.addObject("0")
            }else{
                arr.addObject(String(format:"%.5f",dict["Adjusted Emissions per SF"] as! Float * 365))
            }
            if(dict["Adjusted Emissions per SF"] is NSNull){
                arr.addObject("0")
            }else{
                var gross = 0.0 as! Float
                if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                }else{
                    gross = Float( buildingdetails["gross_area"] as! Int)
                }
                arr.addObject(String(format:"%.5f",(dict["Adjusted Emissions per SF"] as! Float * 365) / gross ))
            }
            
            if(dict["Adjusted Emissions per SF"] is NSNull){
                arr.addObject("0")
            }else{
                var occupant = 0.0 as! Float
                if(buildingdetails["gross_area"] == nil || buildingdetails["occupancy"] is NSNull){
                }else{
                    occupant = Float( buildingdetails["occupancy"] as! Int)
                }
                arr.addObject(String(format:"%.5f",(dict["Adjusted Emissions per SF"] as! Float * 365) / occupant ))
            }
            valuearr.addObject(arr)
            arr = []
            if(dict["Adjusted Emissions per SF"] is NSNull){
                arr.addObject("0")
            }else{
                arr.addObject(String(format:"%.5f",dict["Adjusted Emissions per SF"] as! Float))
            }
            if(dict["Adjusted Emissions per SF"] is NSNull){
                arr.addObject("0")
            }else{
                var gross = 0.0 as! Float
                if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                }else{
                    gross = Float( buildingdetails["gross_area"] as! Int)
                }
                arr.addObject(String(format:"%.5f",(dict["Adjusted Emissions per SF"] as! Float) / gross ))
            }
            
            if(dict["Adjusted Emissions per SF"] is NSNull){
                arr.addObject("0")
            }else{
                var occupant = 0.0 as! Float
                if(buildingdetails["gross_area"] == nil || buildingdetails["occupancy"] is NSNull){
                }else{
                    occupant = Float( buildingdetails["occupancy"] as! Int)
                }
                arr.addObject(String(format:"%.5f",(dict["Adjusted Emissions per SF"] as! Float) / occupant ))
            }
            valuearr.addObject(arr)
            }
            }
            
            if(analysisdict["transit"] != nil){
                if(analysisdict["transit"]!["info_json"] != nil){
            arr = []
            print(valuearr)
            var str = analysisdict["transit"]!["info_json"] as! String
            var str1 = NSMutableString()
            str1.appendString(str)
            str1.replaceOccurrencesOfString("'", withString: "\"", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, str.characters.count))
            print(str1)
            str = str1.mutableCopy() as! String
            var dict = NSDictionary()
            var jsonData = (str).dataUsingEncoding(NSUTF8StringEncoding)
            do {
                 dict = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions()) as! NSDictionary
                print(dict)
                
            }catch{
                
            }
            
            if(dict["Average Transit CO2e"] is NSNull){
                arr.addObject("0")
            }else{
                arr.addObject(String(format:"%.5f",dict["Average Transit CO2e"] as! Float * 365))
            }
            if(dict["Average Transit CO2e"] is NSNull){
                arr.addObject("0")
            }else{
                var gross = 0.0 as! Float
                if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                }else{
                    gross = Float( buildingdetails["gross_area"] as! Int)
                }
                arr.addObject(String(format:"%.5f",(dict["Average Transit CO2e"] as! Float * 365)  / gross ))
            }
            
            if(dict["Average Transit CO2e"] is NSNull){
                arr.addObject("0")
            }else{
                var occupant = 0.0 as! Float
                if(buildingdetails["gross_area"] == nil || buildingdetails["occupancy"] is NSNull){
                }else{
                    occupant = Float( buildingdetails["occupancy"] as! Int)
                }
                arr.addObject(String(format:"%.5f",(dict["Average Transit CO2e"] as! Float * 365) / occupant ))
            }
            valuearr.addObject(arr)
            arr = []
            print(arr)
            if(dict["Average Transit CO2e"] is NSNull){
                arr.addObject("0")
            }else{
                arr.addObject(String(format:"%.5f",dict["Average Transit CO2e"] as! Float))
            }
            print(arr)
            if(dict["Average Transit CO2e"] is NSNull){
                arr.addObject("0")
            }else{
                var gross = 0.0 as! Float
                if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                }else{
                    gross = Float( buildingdetails["gross_area"] as! Int)
                }
                arr.addObject(String(format:"%.5f",(dict["Average Transit CO2e"] as! Float) / gross ))
            }
            print(arr)
            if(dict["Average Transit CO2e"] is NSNull){
                arr.addObject("0")
            }else{
                var occupant = 0.0 as! Float
                if(buildingdetails["gross_area"] == nil || buildingdetails["occupancy"] is NSNull){
                }else{
                    occupant = Float( buildingdetails["occupancy"] as! Int)
                }
                arr.addObject(String(format:"%.5f",(dict["Average Transit CO2e"] as! Float) / occupant ))
            }
            print(arr)
            valuearr.addObject(arr)
            arr = []
            }
            }
            //
        }
        
        print("Value arr",valuearr)
        
        
   /*     GHG * 365
        (GHG * 365) / 20000
        (GHG * 365) / 40*/
        
        
        
        //[myDictionary valueForKeyPath:@"@max.age"];
        // Do any additional setup after loading the view.
    }
    
    func getmax(type:String,arr:NSMutableArray){
        var temparr = [Int]()
        for dict in arr{
            print(dict)
            if(dict[type] is NSNull){
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
            if(dict[type] is NSNull){
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
        if(valuearr.count > 0){
        selectedtitle = sectiontitlearr.objectAtIndex(indexPath.row) as! String
        leftarr = titlearr.objectAtIndex(indexPath.row) as! NSArray
        rightarr = valuearr.objectAtIndex(indexPath.row) as! NSArray
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("gotoemissions", sender: nil)
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
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlearr.count-1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as! UITableViewCell
        cell.textLabel?.text = sectiontitlearr[indexPath.row] as! String
        cell.selectionStyle = UITableViewCellSelectionStyle.None
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
               cell.detailTextLabel?.text = "0"
            }
        }
        */
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectiontitlearr[section] as! String
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
