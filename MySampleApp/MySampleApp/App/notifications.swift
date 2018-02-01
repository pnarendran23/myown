//
//  more.swift
//  LEEDOn
//
//  Created by Group X on 28/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class notifications: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {
    var notificationsarr = NSArray()
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var backbtn: UIButton!
    @IBOutlet weak var assetname: UILabel!
    @IBOutlet weak var tabbar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        backbtn.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12)
        self.tabbar.selectedItem = self.tabbar.items![4]
        notificationsarr = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("notifications") as! NSData) as! NSArray
        var buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        assetname.text = buildingdetails["name"] as! String
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if(item.title == "Score"){
            NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"plaque"])
        }else if(item.title == "Analytics"){
            NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"beforeanalytics"])
        }else if(item.title == "Manage"){
            NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"manage"])
        }else if(item.title == "More"){
            NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"more"])
        }
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsarr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")! as! UITableViewCell
        var dict = notificationsarr.objectAtIndex(indexPath.row) as! NSDictionary
        cell.textLabel?.text = getnotificationvalues(dict["foreign_id"] as! String)
        
        var date = NSDate()
        if(dict["time"] == nil && dict["time"] is NSNull){
            
        }else{
            var formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            date = formatter.dateFromString(dict["time"] as! String)!
            formatter.dateFormat = "MMM dd, yyyy"
            var temp = formatter.stringFromDate(date)
            formatter.dateFormat = "hh:mm a"
            var time = formatter.stringFromDate(date)
            //print("asdasd",dict["time"])
            cell.detailTextLabel?.text = "\(temp) at \(time)"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var dict = notificationsarr.objectAtIndex(indexPath.section) as! NSDictionary
        var foreign_id = dict["foreign_id"] as! String
        if(foreign_id == "updated_userManual")
        {
            
        }
        else if(foreign_id == "data_input_human")
        {
            var dict = ["foreign_id":foreign_id]
            NSNotificationCenter.defaultCenter().postNotificationName("notifywindowchoose", object: nil, userInfo: dict)
        }
        else if(foreign_id == "data_input_transportation")
        {
            var dict = ["foreign_id":foreign_id]
            NSNotificationCenter.defaultCenter().postNotificationName("notifywindowchoose", object: nil, userInfo: dict)
        }
        else if(foreign_id == "data_input_waste")
        {
            var dict = ["foreign_id":foreign_id]
            NSNotificationCenter.defaultCenter().postNotificationName("notifywindowchoose", object: nil, userInfo: dict)
        }
        else if(foreign_id == "data_input_water")
        {
            var dict = ["foreign_id":foreign_id]
            NSNotificationCenter.defaultCenter().postNotificationName("notifywindowchoose", object: nil, userInfo: dict)
        }
        else if(foreign_id == "data_input_energy")
        {
            var dict = ["foreign_id":foreign_id]
            NSNotificationCenter.defaultCenter().postNotificationName("notifywindowchoose", object: nil, userInfo: dict)
        }
        else if(foreign_id == "data_input_operating_hours")
        {
            var dict = ["foreign_id":foreign_id]
            NSNotificationCenter.defaultCenter().postNotificationName("notifywindowchoose", object: nil, userInfo: dict)
        }
        else if(foreign_id == "data_input_density")
        {
            var dict = ["foreign_id":foreign_id]
            NSNotificationCenter.defaultCenter().postNotificationName("notifywindowchoose", object: nil, userInfo: dict)
        }
        else if(foreign_id == "data_input_occupancy")
        {
            var dict = ["foreign_id":foreign_id]
            NSNotificationCenter.defaultCenter().postNotificationName("notifywindowchoose", object: nil, userInfo: dict)
        }
        else if(foreign_id == "data_input_gfa")
        {
            var dict = ["foreign_id":foreign_id]
            NSNotificationCenter.defaultCenter().postNotificationName("notifywindowchoose", object: nil, userInfo: dict)
        }
        else if(foreign_id == "skipped_teamManagement")
        {
            
        }
        else if(foreign_id == "skipped_payment")
        {
            
        }
        else if(foreign_id == "skipped_agreement")
        {
            
        }
        else if(foreign_id == "score_computation")
        {
            
        }
        else if(foreign_id == "request_access")
        {
            
        }
        else if(foreign_id == "review_Completed")
        {
            
        }
        
    }
    
    func getnotificationvalues(foreign_id:String) -> String{
        if(foreign_id == "updated_userManual")
        {
            return "User manual has been updated";
        }
        else if(foreign_id == "data_input_human")
        {
            return "Input co2/voc use data";
        }
        else if(foreign_id == "data_input_transportation")
        {
            return "Survey contributes to total score when at least 25% of occupants have taken survey";
        }
        else if(foreign_id == "data_input_waste")
        {
            return "Input waste use data";
        }
        else if(foreign_id == "data_input_water")
        {
            return "Input water use data";
        }
        else if(foreign_id == "data_input_energy")
        {
            return "Input energy use data";
        }
        else if(foreign_id == "data_input_operating_hours")
        {
            return "Add operating hours";
        }
        else if(foreign_id == "data_input_density")
        {
            return "Density (gross floor area / occupancy) should be at least 25 in order to calculate the performance score";
        }
        else if(foreign_id == "data_input_occupancy")
        {
            var buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
            if(buildingdetails["project_type"] != nil){
                return "\(buildingdetails["project_type"] as! String) occupancy should be at least 5 in order to calculate the performance score"
            }else{
                return "occupancy should be at least 5 in order to calculate the performance score"
            }
            
        }
        else if(foreign_id == "data_input_gfa")
        {
            return "Gross floor area should be at least 100 sq ft in order to calculate the performance score";
        }
        else if(foreign_id == "skipped_teamManagement")
        {
            return "Add team members now";
        }
        else if(foreign_id == "skipped_payment")
        {
            return "Select a plan";
        }
        else if(foreign_id == "skipped_agreement")
        {
            return "Sign user agreement";
        }
        else if(foreign_id == "score_computation")
        {
            return "Score computation is in progress";
        }
        else if(foreign_id == "request_access")
        {
            return "Permission request";
        }
        else if(foreign_id == "review_Completed")
        {
            return "Certification Review completed";
        }
        
        return ""
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
