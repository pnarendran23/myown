//
//  analysisgraph.swift
//  LEEDOn
//
//  Created by Group X on 22/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class analysisgraph: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var graphview: actualgraph!
    @IBOutlet weak var backbtn: UIButton!
    var sortedArray = NSArray()
    @IBOutlet weak var str2lbl: UILabel!
    @IBOutlet weak var str1lbl: UILabel!
    var analysisdict = NSDictionary()
    @IBOutlet weak var str2value: UILabel!
    @IBOutlet weak var str1value: UILabel!
    @IBOutlet weak var segctrl: UISegmentedControl!
    @IBOutlet weak var vv: UIView!
    var mttitlearr = NSArray()
    var str1 = ""
    var str2 = ""
    var type = String()
    var reportedscores = NSMutableArray()
    @IBOutlet weak var maxlbl: UILabel!
    @IBOutlet weak var last12lbl: UILabel!
    @IBOutlet weak var zerolbl: UILabel!
    var startcolor = UIColor()
    var endcolor = UIColor()
    var sectiontitle = NSMutableArray()
    @IBOutlet weak var scoreslbl: UILabel!
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var reportingperiod: UILabel!
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height = UIScreen.mainScreen().bounds.size.height
        return 0.065 * height
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var height = UIScreen.mainScreen().bounds.size.height
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height = UIScreen.mainScreen().bounds.size.height
        return 0.106 * height
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return currentarr.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr = currentarr.objectAtIndex(section) as! NSArray
        
        return arr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
            var arr = currentarr[indexPath.section] as! NSArray
            if(indexPath.row == 0){
                cell?.textLabel?.text = "PROJECT"
            }else if(indexPath.row == 1){
                if(type == "transport"){
                    cell?.textLabel?.text = "PER OCC"
                }else{
                cell?.textLabel?.text = "PER SQ FT"
                }
            }else if(indexPath.row == 2){
                cell?.textLabel?.text = "PER OCC"
            }
        if(type == "transport" && indexPath.row == 0 && indexPath.section == 1){
            cell?.detailTextLabel?.text = String(format: "%.2f%%",arr[indexPath.row] as! Float)
        }else if(type == "transport" && indexPath.row == 1 && indexPath.section == 1){
            cell?.detailTextLabel?.text = "-"
        }else{
            cell?.detailTextLabel?.text = String(format: "%.4f",arr[indexPath.row] as! Float)
        }
        
        if(indexPath.section == currentarr.count - 1){
            cell?.detailTextLabel?.text = String(format: "%.4f",arr[indexPath.row] as! Float)
        }
        
        if(type == "transport"){
            if(indexPath.section == 1){
                if(indexPath.row == 0){
                        cell?.detailTextLabel?.text = ""
                        cell?.detailTextLabel?.text = String(format: "%.2f%%",arr[indexPath.row] as! Float)
                }else{
                    cell?.detailTextLabel?.text = "-"
                }
            }
        }
        if(type == "human_experience"){
            if(indexPath.section == 3){
                if(indexPath.row == 0){
                    cell?.detailTextLabel?.text = ""
                    cell?.detailTextLabel?.text = String(format: "%.2f%%",arr[indexPath.row] as! Float)
                }
            }
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectiontitle[section] as! String
    }
    
    func adjustwidth(){
        
        reportedscores = sortedArray.mutableCopy() as! NSMutableArray
        
        self.view.bringSubviewToFront(self.backbtn)
        var temp = UIView()
        temp.frame = graphview.frame
        print(vv.frame.size.width, vv.frame.size.height)
        self.graphview.frame = CGRect(x: vv.layer.frame.origin.x ,y:temp.layer.frame.origin.y,width:vv.layer.frame.size.width,height:vv.layer.frame.size.height)
        
        var data = [Int]()
        graphview.layer.cornerRadius = 10
        graphview.layer.masksToBounds = true
        graphview.graphPoints = [0,0,0]
        for dict in reportedscores{
            print(dict["scores"])
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
        graphview.graphPoints = data
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
        
        print(num)
        if(mttitlearr.count > 0){
            str1lbl.adjustsFontSizeToFitWidth = true
            str1lbl.text = mttitlearr.objectAtIndex(0) as? String
            str1lbl.text = mttitlearr.objectAtIndex(1) as? String
            print("str1 str2",str1,str2)
            str1value.text = str1
            str2value.text = str2
            str1value.adjustsFontSizeToFitWidth = true
            str2value.adjustsFontSizeToFitWidth = true
        }else{
            self.vv.hidden = true
        }
        var l1 = UILabel()
        var l2 = UILabel()
        var l3 = UILabel()
        var l4 = UILabel()
        var l5 = UILabel()
        l1 = self.maxlbl
        self.vv.layer.cornerRadius = 10
        l2 = self.last12lbl
        l3 = self.zerolbl
        graphview.startColor = startcolor
        graphview.endColor = endcolor
        self.segctrl.tintColor = endcolor
        self.str1value.textColor = endcolor
        self.str2value.textColor = endcolor
        l4 = self.scoreslbl
        l5 = self.reportingperiod
        self.view.bringSubviewToFront(self.backbtn)
        self.graphview.bringSubviewToFront(reportingperiod)        
        if(num > 0){
        l1.text = String(format: "%d",num)
        }else{
        l1.text = "10"
        }
        self.view.bringSubviewToFront(self.vv)
      //  self.view.addSubview(graphy)
         self.view.bringSubviewToFront(self.graphview)
        self.view.bringSubviewToFront(self.topview)
        self.view.bringSubviewToFront(self.tabbar)
        
       // graphview.hidden = true
        
        
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
    var currentarr = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableview.frame.origin.y = self.vv.frame.size.height + self.vv.frame.origin.y
        self.titlefont()
        backbtn.hidden = true
        //self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.adjustwidth), name: UIDeviceOrientationDidChangeNotification, object: nil)
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
        var dict = analysisdict
        var scope2annumarr = NSMutableArray()
        var scope2dailyarr = NSMutableArray()
        var buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        currentarr = NSMutableArray()
        sectiontitle = NSMutableArray()
        if(type == "energy"){
            
            var arr = NSMutableArray()
            scope2annumarr = arr
            arr = NSMutableArray()
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
                    
                    arr = NSMutableArray()
                    if(dict["Adjusted Emissions per SF"] is NSNull || dict["Adjusted Emissions per SF"] == nil){
                        arr.addObject(0.00000)
                    }else if(dict["Adjusted Emissions per SF"] as? String == "None"){
                        arr.addObject(0.00000)
                    }else{
                        var gross = 0.0 as! Float
                        if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                        }else{
                            gross = Float( buildingdetails["gross_area"] as! Int)
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
                    scope2annumarr = arr
                    currentarr.addObject(arr)
                    arr = NSMutableArray()
                    
                    if(dict["Adjusted Emissions per SF"] is NSNull || dict["Adjusted Emissions per SF"] == nil){
                        arr.addObject(0.00000)
                    }else if(dict["Adjusted Emissions per SF"] as? String == "None"){
                        arr.addObject(0.00000)
                    }else{
                        var gross = 0.0 as! Float
                        if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                        }else{
                            gross = Float( buildingdetails["gross_area"] as! Int)
                        }
                        arr.addObject(dict["Adjusted Emissions per SF"] as! Float * gross)
                    }
                    
                    
                    if(dict["Adjusted Emissions per SF"] is NSNull || dict["Adjusted Emissions per SF"] == nil){
                        arr.addObject(0.00000)
                    }else if(dict["Adjusted Emissions per SF"] as? String == "None"){
                        arr.addObject(0.00000)
                    }else{
                        arr.addObject(dict["Adjusted Emissions per SF"] as! Float)
                    }
            
                    if(dict["Adjusted Emissions per Occupant"] is NSNull || dict["Adjusted Emissions per Occupant"] == nil){
                        arr.addObject(0.00000)
                    }else if(dict["Adjusted Emissions per Occupant"] as? String == "None"){
                        arr.addObject(0.00000)
                    }else{
                        arr.addObject((dict["Adjusted Emissions per Occupant"] as! Float))
                    }
            scope2dailyarr = arr
            currentarr.addObject(arr)
                    arr = NSMutableArray()
                    
                    arr = NSMutableArray()
                    if(dict["Raw GHG (mtCO2e/day)"] is NSNull || dict["Raw GHG (mtCO2e/day)"] == nil){
                        arr.addObject(0.00000)
                    }else if(dict["Raw GHG (mtCO2e/day)"] as? String == "None"){
                        arr.addObject(0.00000)
                    }else{
                        arr.addObject(dict["Raw GHG (mtCO2e/day)"] as! Float  * 365.0 )
                    }
                    if(dict["Raw GHG (mtCO2e/day)"] is NSNull || dict["Raw GHG (mtCO2e/day)"] == nil){
                        arr.addObject(0.00000)
                    }else if(dict["Raw GHG (mtCO2e/day)"] as? String == "None"){
                        arr.addObject(0.00000)
                    }else{
                        var gross = 0.0 as! Float
                        if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                        }else{
                            gross = Float( buildingdetails["gross_area"] as! Int)
                        }
                        arr.addObject((dict["Raw GHG (mtCO2e/day)"] as! Float  * 365.0) / gross )
                    }
                    
                    if(dict["Raw GHG (mtCO2e/day)"] is NSNull || dict["Raw GHG (mtCO2e/day)"] == nil){
                        arr.addObject(0.00000)
                    }else if(dict["Raw GHG (mtCO2e/day)"] as? String == "None"){
                        arr.addObject(0.00000)
                    }else{
                        var occupant = 0.0 as! Float
                        if(buildingdetails["gross_area"] == nil || buildingdetails["occupancy"] is NSNull){
                        }else{
                            occupant = Float( buildingdetails["occupancy"] as! Int)
                        }
                        arr.addObject((dict["Raw GHG (mtCO2e/day)"] as! Float  * 365.0) / occupant )
                    }
                    scope2annumarr = arr
                    currentarr.addObject(arr)
                    arr = NSMutableArray()
            sectiontitle.addObject("ANNUAL ENERGY CONSUMPTION (kBTU)")
            sectiontitle.addObject("DAILY ENERGY CONSUMPTION (kBTU)")
            sectiontitle.addObject("ANNUAL CARBON EMISSIONS (MTCO2e)")
            print(currentarr)
                    self.tableview.reloadData()
                }else{
                    sectiontitle.addObject("ANNUAL ENERGY CONSUMPTION (kBTU)")
                    sectiontitle.addObject("DAILY ENERGY CONSUMPTION (kBTU)")
                    sectiontitle.addObject("ANNUAL CARBON EMISSIONS (MTCO2e)")
                    arr = NSMutableArray()
                    arr.addObject(0.00000)
                    arr.addObject(0.00000)
                    arr.addObject(0.00000)
                    currentarr.addObject(arr)
                }
            }else{
                sectiontitle.addObject("ANNUAL ENERGY CONSUMPTION (kBTU)")
                sectiontitle.addObject("DAILY ENERGY CONSUMPTION (kBTU)")
                sectiontitle.addObject("ANNUAL CARBON EMISSIONS (MTCO2e)")
                arr = NSMutableArray()
                arr.addObject(0.00000)
                arr.addObject(0.00000)
                arr.addObject(0.00000)
                currentarr.addObject(arr)
            }
        }else if(type == "water"){
            var arr = NSMutableArray()
            scope2annumarr = arr
            arr = NSMutableArray()
            if(analysisdict["water"] != nil ){
                if(analysisdict["water"]!["info_json"] != nil){
                    var str = analysisdict["water"]!["info_json"] as! String
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
                    
                    arr = NSMutableArray()
                    
                    if(dict["Adjusted Gallons per SF"] is NSNull || dict["Adjusted Gallons per SF"] == nil){
                        arr.addObject(0.00000)
                    }else if(dict["Adjusted Gallons per SF"] as? String == "None"){
                        arr.addObject(0.00000)
                    }else{
                        var gross = 0.0 as! Float
                        if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                        }else{
                            gross = Float( buildingdetails["gross_area"] as! Int)
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
                        if(buildingdetails["gross_area"] == nil || buildingdetails["occupancy"] is NSNull){
                        }else{
                            gross = Float( buildingdetails["gross_area"] as! Int)
                            occupant = Float( buildingdetails["occupancy"] as! Int)
                        }
                        arr.addObject(((dict["Adjusted Gallons per Occupant"] as! Float  * gross) / occupant)*365)
                    }
                    scope2annumarr = arr
                    currentarr.addObject(arr)
                    arr = NSMutableArray()
                    
                    if(dict["Adjusted Gallons per SF"] is NSNull || dict["Adjusted Gallons per SF"] == nil){
                        arr.addObject(0.00000)
                    }else if(dict["Adjusted Gallons per SF"] as? String == "None"){
                        arr.addObject(0.00000)
                    }else{
                        var occupant = 0.0 as! Float
                        var gross = 0.0 as! Float
                        if(buildingdetails["gross_area"] == nil || buildingdetails["occupancy"] is NSNull){
                        }else{
                            gross = Float( buildingdetails["gross_area"] as! Int)
                        }
                        arr.addObject((dict["Adjusted Gallons per SF"] as! Float) * gross )
                    }
                    
                    
                    if(dict["Adjusted Gallons per SF"] is NSNull || dict["Adjusted Gallons per SF"] == nil){
                        arr.addObject(0.00000)
                    }else if(dict["Adjusted Gallons per SF"] as? String == "None"){
                        arr.addObject(0.00000)
                    }else{
                        var gross = 0.0 as! Float
                        if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                        }else{
                            gross = Float( buildingdetails["gross_area"] as! Int)
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
                        if(buildingdetails["gross_area"] == nil || buildingdetails["occupancy"] is NSNull){
                        }else{
                            gross = Float( buildingdetails["gross_area"] as! Int)
                            occupant = Float( buildingdetails["occupancy"] as! Int)
                        }
                        arr.addObject(((dict["Adjusted Gallons per Occupant"] as! Float  * gross) / occupant))
                    }
                    scope2dailyarr = arr
                    currentarr.addObject(arr)
                    arr = NSMutableArray()
                    sectiontitle.addObject("ANNUAL WATER CONSUMPTION (gal)")
                    sectiontitle.addObject("DAILY WATER CONSUMPTION (gal)")
                    print(currentarr)
                    self.tableview.reloadData()
                }else{
                    sectiontitle.addObject("ANNUAL WATER CONSUMPTION (gal)")
                    sectiontitle.addObject("DAILY WATER CONSUMPTION (gal)")
                    arr = NSMutableArray()
                    arr.addObject(0.00000)
                    arr.addObject(0.00000)
                    currentarr.addObject(arr)
                }
            }else{
                sectiontitle.addObject("ANNUAL WATER CONSUMPTION (gal)")
                sectiontitle.addObject("DAILY WATER CONSUMPTION (gal)")
                arr = NSMutableArray()
                arr.addObject(0.00000)
                arr.addObject(0.00000)
                currentarr.addObject(arr)
            }
            }else if(type == "waste"){
                var arr = NSMutableArray()
                scope2annumarr = arr
                arr = NSMutableArray()
                if(analysisdict["waste"] != nil ){
                    if(analysisdict["waste"]!["info_json"] != nil){
                        var str = analysisdict["waste"]!["info_json"] as! String
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
                        
                        arr = NSMutableArray()
                        
                        if(dict["Generated Waste (lbs per occupant per day)"] is NSNull || dict["Generated Waste (lbs per occupant per day)"] == nil){
                            arr.addObject(0.00000)
                        }else if(dict["Generated Waste (lbs per occupant per day)"] as? String == "None"){
                            arr.addObject(0.00000)
                        }else{
                            var occupancy = 0.0 as! Float
                            if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                            }else{
                                occupancy = Float( buildingdetails["occupancy"] as! Int)
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
                            if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                            }else{
                                occupancy = Float( buildingdetails["occupancy"] as! Int)
                                gross = Float( buildingdetails["gross_area"] as! Int)
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
                            if(buildingdetails["occupancy"] == nil || buildingdetails["occupancy"] is NSNull){
                            }else{
                                gross = Float( buildingdetails["gross_area"] as! Int)
                                occupant = Float( buildingdetails["occupancy"] as! Int)
                            }
                            arr.addObject(dict["Generated Waste (lbs per occupant per day)"] as! Float  * 365.0)
                        }
                        scope2annumarr = arr
                        currentarr.addObject(arr)
                        arr = NSMutableArray()
                        
                        if(dict["Generated Waste (lbs per occupant per day)"] is NSNull || dict["Generated Waste (lbs per occupant per day)"] == nil){
                            arr.addObject(0.00000)
                        }else if(dict["Generated Waste (lbs per occupant per day)"] as? String == "None"){
                            arr.addObject(0.00000)
                        }else{
                            var occupancy = 0.0 as! Float
                            if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                            }else{
                                occupancy = Float( buildingdetails["occupancy"] as! Int)
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
                            if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                            }else{
                                occupancy = Float( buildingdetails["occupancy"] as! Int)
                                gross = Float( buildingdetails["gross_area"] as! Int)
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
                            if(buildingdetails["gross_area"] == nil || buildingdetails["occupancy"] is NSNull){
                            }else{
                                gross = Float( buildingdetails["gross_area"] as! Int)
                                occupant = Float( buildingdetails["occupancy"] as! Int)
                            }
                            arr.addObject((dict["Generated Waste (lbs per occupant per day)"] as! Float))
                        }
                        scope2dailyarr = arr
                        currentarr.addObject(arr)
                        arr = NSMutableArray()
                        sectiontitle.addObject("AVERAGE DAILY WASTE GENERATED (lbs)")
                        sectiontitle.addObject("AVERAGE DAILY WASTE DIVERTED (lbs)")
                        print(currentarr)
                        self.tableview.reloadData()
                    }else{
                        sectiontitle.addObject("AVERAGE DAILY WASTE GENERATED (lbs)")
                        sectiontitle.addObject("AVERAGE DAILY WASTE DIVERTED (lbs)")
                        arr = NSMutableArray()
                        arr.addObject(0.00000)
                        arr.addObject(0.00000)
                        currentarr.addObject(arr)
                    }
                }else{
                    sectiontitle.addObject("AVERAGE DAILY WASTE GENERATED (lbs)")
                    sectiontitle.addObject("AVERAGE DAILY WASTE DIVERTED (lbs)")
                    arr = NSMutableArray()
                    arr.addObject(0.00000)
                    arr.addObject(0.00000)
                    currentarr.addObject(arr)
            }
        }else if(type == "transport"){
            var arr = NSMutableArray()
            scope2annumarr = arr
            arr = NSMutableArray()
            if(analysisdict["transit"] != nil ){
                if(analysisdict["transit"]!["info_json"] != nil){
                    var str = analysisdict["transit"]!["info_json"] as! String
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
                    
                    arr = NSMutableArray()
                    
                    if(dict["Average Transit CO2e"] is NSNull || dict["Average Transit CO2e"] == nil){
                        arr.addObject(0.00000)
                    }else if(dict["Average Transit CO2e"] as? String == "None"){
                        arr.addObject(0.00000)
                    }else{
                        var occupancy = 0.0 as! Float
                        if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                        }else{
                            occupancy = Float( buildingdetails["occupancy"] as! Int)
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
                        if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                        }else{
                            occupancy = Float( buildingdetails["occupancy"] as! Int)
                            gross = Float( buildingdetails["gross_area"] as! Int)
                        }
                        arr.addObject((dict["Average Transit CO2e"] as! Float ))
                    }
                    
                    scope2annumarr = arr
                    currentarr.addObject(arr)
                    arr = NSMutableArray()
                    
                    if(dict["Transportation Participation Fraction"] is NSNull || dict["Transportation Participation Fraction"] == nil){
                        arr.addObject(0.00000)
                    }else if(dict["Transportation Participation Fraction"] as? String == "None"){
                        arr.addObject(0.00000)
                    }else{
                        var occupancy = 0.0 as! Float
                        if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                        }else{
                            occupancy = Float( buildingdetails["occupancy"] as! Int)
                        }
                        arr.addObject((dict["Transportation Participation Fraction"] as! Float) * 100 )
                    }
                    
                    
                        arr.addObject(0.00000)
                    
                   
                    scope2dailyarr = arr
                    currentarr.addObject(arr)
                    arr = NSMutableArray()
                    sectiontitle.addObject("DAILY CARBON EMISSIONS (MTCO2e)")
                    sectiontitle.addObject("SURVEY RESPONSE RATE")
                    print(currentarr)
                    self.tableview.reloadData()
                }else{
                    sectiontitle.addObject("DAILY CARBON EMISSIONS (MTCO2e)")
                    sectiontitle.addObject("SURVEY RESPONSE RATE")
                    arr = NSMutableArray()
                    arr.addObject(0.00000)
                    arr.addObject(0.00000)
                    currentarr.addObject(arr)
                }
            }else{
                sectiontitle.addObject("DAILY CARBON EMISSIONS (MTCO2e)")
                sectiontitle.addObject("SURVEY RESPONSE RATE")
                arr = NSMutableArray()
                arr.addObject(0.00000)
                arr.addObject(0.00000)
                currentarr.addObject(arr)
            }
            //
        }else if(type == "human_experience"){
            var arr = NSMutableArray()
            scope2annumarr = arr
            arr = NSMutableArray()
            if(analysisdict["human"] != nil ){
                if(analysisdict["human"]!["info_json"] != nil){
                    var str = analysisdict["human"]!["info_json"] as! String
                    var str1 = NSMutableString()
                    str1.appendString(str)
                    str = str.stringByReplacingOccurrencesOfString("'", withString: "\"")
                    str = str.stringByReplacingOccurrencesOfString("None", withString: "\"None\"")
                    print(str1)
                    //str = str1.mutableCopy() as! String
                    var dict = NSDictionary()
                    var jsonData = str
                    if(convertStringToDictionary(str) == nil){
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
                        dict = convertStringToDictionary(str)!
                    var insidedict = dict["Human Experience Inputs"] as! [String:AnyObject]
                    //str = str1.mutableCopy() as! String
                    //insidedict = convertStringToDictionary(str)!
                    print(insidedict)
                        
                    
                    
                    
                    arr = []
                    
                    arr = NSMutableArray()
                    
                        if(insidedict["co2"] is NSNull || insidedict["co2"] == nil || insidedict["co2"] as? String == "None"){
                            arr.addObject(0.00000)
                        }else{
                        var occupancy = 0.0 as! Float
                        if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                        }else{
                            occupancy = Float( buildingdetails["occupancy"] as! Int)
                        }
                        arr.addObject((insidedict["co2"] as! Int))
                        }
                    
                    
                    scope2annumarr = arr
                    currentarr.addObject(arr)
                    arr = NSMutableArray()
                    
                    if(insidedict["voc"] is NSNull || insidedict["voc"] == nil || insidedict["voc"] as? String == "None"){
                        arr.addObject(0.00000)
                    }else{
                        var occupancy = 0.0 as! Float
                        if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                        }else{
                            occupancy = Float( buildingdetails["occupancy"] as! Int)
                        }
                        arr.addObject((insidedict["voc"] as! Int))
                    }
                
                    scope2dailyarr = arr
                    currentarr.addObject(arr)
                    arr = NSMutableArray()
                    
                    if(insidedict["occupant_satisfaction_fraction"] is NSNull || insidedict["occupant_satisfaction_fraction"] == nil || insidedict["occupant_satisfaction_fraction"] as? String == "None"){
                        arr.addObject(0.00000)
                    }else{
                        var occupancy = 0.0 as! Float
                        if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                        }else{
                            occupancy = Float( buildingdetails["occupancy"] as! Int)
                        }
                        arr.addObject((insidedict["occupant_satisfaction_fraction"] as! Float * 100 ))
                    }
                    
                    scope2dailyarr = arr
                    currentarr.addObject(arr)
                    arr = NSMutableArray()

                    if(analysisdict["transit"] != nil ){
                        if(analysisdict["transit"]!["info_json"] != nil){
                            var str = analysisdict["transit"]!["info_json"] as! String
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
                                if(dict["Transportation Participation Fraction"] is NSNull || dict["Transportation Participation Fraction"] == nil){
                                    arr.addObject(0.00000)
                                }else if(dict["Transportation Participation Fraction"] as? String == "None"){
                                    arr.addObject(0.00000)
                                }else{
                                    var occupancy = 0.0 as! Float
                                    if(buildingdetails["gross_area"] == nil || buildingdetails["gross_area"] is NSNull){
                                    }else{
                                        occupancy = Float( buildingdetails["occupancy"] as! Int)
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
                        scope2dailyarr = arr
                        currentarr.addObject(arr)
                        arr = NSMutableArray()
                        print(currentarr)
                        self.tableview.reloadData()
                    }
                    sectiontitle.addObject("INTERIOR CARBON DIOXIDE LEVELS (ppm)")
                    sectiontitle.addObject("INTERIOR TOTAL VOLATILE ORGANIC COMPOUND LEVELS (ug/m3)")
                    sectiontitle.addObject("AVERAGE OCCUPANT SATISFACTION")
                    sectiontitle.addObject("SURVEY RESPONSE RATE")
                }else{
                    sectiontitle.addObject("INTERIOR CARBON DIOXIDE LEVELS (ppm)")
                    sectiontitle.addObject("INTERIOR TOTAL VOLATILE ORGANIC COMPOUND LEVELS (ug/m3)")
                    sectiontitle.addObject("AVERAGE OCCUPANT SATISFACTION")
                    sectiontitle.addObject("SURVEY RESPONSE RATE")
                    arr = NSMutableArray()
                    arr.addObject(0.00000)
                    arr.addObject(0.00000)
                    arr.addObject(0.00000)
                    arr.addObject(0.00000)
                    currentarr.addObject(arr)
                }
            }else{
                sectiontitle.addObject("INTERIOR CARBON DIOXIDE LEVELS (ppm)")
                sectiontitle.addObject("INTERIOR TOTAL VOLATILE ORGANIC COMPOUND LEVELS (ug/m3)")
                sectiontitle.addObject("AVERAGE OCCUPANT SATISFACTION")
                sectiontitle.addObject("SURVEY RESPONSE RATE")
                arr = NSMutableArray()
                arr.addObject(0.00000)
                arr.addObject(0.00000)
                arr.addObject(0.00000)
                arr.addObject(0.00000)
                currentarr.addObject(arr)
            }
        }
        var height = UIScreen.mainScreen().bounds.size.height
        var sectionheight = 0.065 * height
        self.tableview.layer.frame.size.height = 3.5 * CGFloat((sectionheight * CGFloat(currentarr.count)) + ((0.106 * height) * CGFloat(currentarr.count)))
        if(type == "transport" || type == "human_experience"){
            self.tableview.frame.origin.y = self.graphview.frame.origin.y + self.graphview.frame.size.height
            self.scrollview.contentSize = CGSize(width: self.scrollview.frame.size.width,height:1.3 * (UIScreen.mainScreen().bounds.size.height))            
        }
        self.scrollview.contentSize = CGSize(width: self.scrollview.frame.size.width,height:2.5 * (UIScreen.mainScreen().bounds.size.height))
        
        var i = CGFloat(0)
        var j = CGFloat(0)
        i = i + ((0.059 * height) * CGFloat(currentarr.count))
        i = i + ((1) * CGFloat(currentarr.count))
        
        for item in currentarr{
            var arr = item as! NSArray
            j = j + ((0.106 * height) * CGFloat(arr.count))
        }
        i = i + j
        self.tableview.frame.size.height = i
        self.scrollview.contentSize.height = self.tableview.frame.origin.y + self.tableview.frame.size.height + self.vv.frame.size.height
        
        
        

        assetname.text = buildingdetails["name"] as? String
        self.tabbar.selectedItem = self.tabbar.items![2]
        segctrl.setTitle("Per year", forSegmentAtIndex: 0)
        segctrl.setTitle("Per month", forSegmentAtIndex: 1)
        segctrl.setTitle("Per day", forSegmentAtIndex: 2)
        
        print(type, reportedscores)
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let tempArray: NSMutableArray = NSMutableArray()
        for i in 0..<reportedscores.count{
            let dic: NSMutableDictionary = reportedscores[i].mutableCopy() as! NSMutableDictionary
            print(dic)
            if(dic["effective_at"] is String){
                print("String",dic["effective_at"])
            }else{
                print("date")
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
        sortedArray = tempArray.sortedArrayUsingDescriptors(descriptors as! [NSSortDescriptor])
        NSLog("%@", sortedArray)
        reportedscores = sortedArray.mutableCopy() as! NSMutableArray
        adjustwidth()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var scrollview: UIScrollView!
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return true
    }
    
    
    
    @IBOutlet weak var topview: UIView!

    @IBOutlet weak var assetname: UILabel!
    @IBOutlet weak var tabbar: UITabBar!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func valuechange(sender: AnyObject) {
        if(segctrl.selectedSegmentIndex == 0){
            str1value.text = str1
            str2value.text = str2
        }else if(segctrl.selectedSegmentIndex == 1){
            var f1 = Float()
            var f2 = Float()
            f1 = 0
            f2 = 0
            f1 = Float(str1)!
            f2 = Float(str2)!
            f1 = f1/30.0
            f2 = f2/30.0
                str1value.text = "0.000"
            str2value.text = "0.000"
            if(f1 != 0){
            str1value.text = String(format: "%.4f",f1)
            }
            if(f2 != 0){
                str2value.text = String(format: "%.4f",f2)
            }
        }else {
            var f1 = Float()
            var f2 = Float()
            f1 = 0
            f2 = 0
            f1 = Float(str1)!
            f2 = Float(str2)!
            f1 = f1/365.0
            f2 = f2/365.0
            str1value.text = "0.000"
            str2value.text = "0.000"
            if(f1 != 0){
                str1value.text = String(format: "%.4f",f1)
            }
            if(f2 != 0){
                str2value.text = String(format: "%.4f",f2)
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        var buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        self.navigationItem.title = buildingdetails["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as? String
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        var buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        self.navigationItem.title = buildingdetails["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = "Back"
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "gobacktoanalysis"){
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
