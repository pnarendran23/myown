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
    var task = NSURLSessionTask()
    var download_requests = [NSURLSession]()
    @IBOutlet weak var nav: UINavigationBar!
    @IBOutlet weak var backbtn: UIButton!
    @IBOutlet weak var assetname: UILabel!
    @IBOutlet weak var tabbar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        notfound.text = "No notifications available"
        self.spinner.layer.cornerRadius = 5
        self.spinner.hidden = true
        self.titlefont()
        backbtn.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12)
        self.tabbar.selectedItem = self.tabbar.items![3]
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
        let dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary
        tabbar.selectedItem = self.tabbar.items![3]
        self.navigationItem.title = dict["name"] as? String
        assetname.text = dict["name"] as? String        
        if(notificationsarr.count > 0){
            notfound.hidden = true
        }else{
            notfound.hidden = false
        }
        
        var buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        assetname.text = buildingdetails["name"] as? String
        self.navigationItem.title = buildingdetails["name"] as? String
        let navItem = UINavigationItem(title: (buildingdetails["name"] as? String)!);
        self.nav.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!]
        let doneItem = UIBarButtonItem(title: "< More", style: .Plain, target: self, action: #selector(sayHello(_:)))
        navItem.leftBarButtonItem = doneItem;
        nav.setItems([navItem], animated: false);
        if(NSUserDefaults.standardUserDefaults().objectForKey("actions_data") == nil){
            self.view.userInteractionEnabled = false
            if(self.navigationController != nil){
            self.navigationController?.view.userInteractionEnabled = false
            }
            self.tabbar.userInteractionEnabled = true
            self.spinner.hidden = false
            buildingactions(credentials().subscription_key, leedid: buildingdetails["leed_id"] as! Int)
        }
        // Do any additional setup after loading the view.
    }
    
    func sayHello(sender: UIBarButtonItem) {
        print("Projects clicked")
        NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"more"])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.backItem?.title = "More"
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
    
    func buildingactions(subscription_key:String, leedid: Int){
        let url = NSURL.init(string: String(format: "%@assets/LEED:%d/actions/",credentials().domain_url,leedid))
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
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
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
                        NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "actions_data")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        dispatch_async(dispatch_get_main_queue(), {
                            self.spinner.hidden = true
                            self.tabbar.userInteractionEnabled = true
                            self.view.userInteractionEnabled = true
                            if(self.navigationController != nil){
                                self.navigationController?.view.userInteractionEnabled = true
                            }
                            self.tableview.reloadData()
                        })
                        
                    } catch {
                        print(error)
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

    
    func showalert(message:String, title:String, action:String){
        
        //let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        //let callActionHandler = { (action:UIAlertAction!) -> Void in
        dispatch_async(dispatch_get_main_queue(), {
            self.view.userInteractionEnabled = true
            //self.spinner.hidden = true
            self.view.userInteractionEnabled = true
            self.tabbar.userInteractionEnabled = true
            self.view.userInteractionEnabled = true
            if(self.navigationController != nil){
                self.navigationController?.view.userInteractionEnabled = true
            }
            self.maketoast(message, type: "error")
            //self.navigationController?.popViewControllerAnimated(true)
        })
        
        //        }
        //      let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        //    alertController.addAction(defaultAction)
        
        //presentViewController(alertController, animated: true, completion: nil)
        
        
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsarr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        let dict = notificationsarr.objectAtIndex(indexPath.row) as! NSDictionary
        cell.textLabel?.text = getnotificationvalues(dict["foreign_id"] as! String)
        
        var date = NSDate()
        if(dict["time"] == nil && dict["time"] is NSNull){
            
        }else{
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            date = formatter.dateFromString(dict["time"] as! String)!
            formatter.dateFormat = "MMM dd, yyyy"
            let temp = formatter.stringFromDate(date)
            formatter.dateFormat = "hh:mm a"
            let time = formatter.stringFromDate(date)
            //print("asdasd",dict["time"])
            cell.detailTextLabel?.text = "\(temp) at \(time)"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tableview.reloadData()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(UIScreen.mainScreen().bounds.size.width < UIScreen.mainScreen().bounds.size.height){
            return 0.135 * UIScreen.mainScreen().bounds.size.height;
        }
        return 0.135 * UIScreen.mainScreen().bounds.size.width;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let dict = notificationsarr.objectAtIndex(indexPath.row) as! NSDictionary
        let foreign_id = dict["foreign_id"] as! String
        if(foreign_id == "updated_userManual")
        {
            
        }
        else if(foreign_id == "data_input_human")
        {
            let dict = ["foreign_id":foreign_id]
            performsegue(dict)
        }
        else if(foreign_id == "data_input_transportation")
        {
            let dict = ["foreign_id":foreign_id]
            performsegue(dict)
        }
        else if(foreign_id == "data_input_waste")
        {
            let dict = ["foreign_id":foreign_id]
            performsegue(dict)
        }
        else if(foreign_id == "data_input_water")
        {
            let dict = ["foreign_id":foreign_id]
            performsegue(dict)
        }
        else if(foreign_id == "data_input_energy" || foreign_id == "data_input_electricity")
        {
            let dict = ["foreign_id":foreign_id]
            performsegue(dict)
        }
        else if(foreign_id == "data_input_operating_hours")
        {
            let dict = ["foreign_id":foreign_id]
            performsegue(dict)
        }
        else if(foreign_id == "data_input_density")
        {
            let dict = ["foreign_id":foreign_id]
            performsegue(dict)
        }
        else if(foreign_id == "data_input_occupancy")
        {
            let dict = ["foreign_id":foreign_id]
            performsegue(dict)
        }
        else if(foreign_id == "data_input_gfa")
        {
            let dict = ["foreign_id":foreign_id]
            performsegue(dict)
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
    
    func getseguename(dict:[String:AnyObject]) -> String{
        let foreign_id = dict["foreign_id"] as! String
        
        if(foreign_id == "updated_userManual")
        {
        }
        else if(foreign_id == "data_input_human")
        {
            let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let datakeyed = NSUserDefaults.standardUserDefaults().objectForKey("actions_data") as! NSData
            let assets = NSKeyedUnarchiver.unarchiveObjectWithData(datakeyed)?.mutableCopy() as! NSMutableDictionary
            let currentarr = assets["EtScorecardList"]!.mutableCopy() as! NSMutableArray
            
            let arr = [String:AnyObject]()
            var sel = 0
            for i in 0..<currentarr.count {
                var temparr = currentarr.objectAtIndex(i) as! [String:AnyObject]
                if(temparr["CreditDescription"] as! String == "Human Experience"){
                    sel = i
                    break
                }
            }
            NSUserDefaults.standardUserDefaults().setInteger(sel, forKey: "selected_action")
            let data = NSKeyedArchiver.archivedDataWithRootObject(currentarr)
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: "currentcategory")
            return "waste"
            
        }
        else if(foreign_id == "data_input_transportation")
        {
            var mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            
            var datakeyed = NSUserDefaults.standardUserDefaults().objectForKey("actions_data") as! NSData
            var assets = NSKeyedUnarchiver.unarchiveObjectWithData(datakeyed)?.mutableCopy() as! NSMutableDictionary
            var currentarr = assets["EtScorecardList"]!.mutableCopy() as! NSMutableArray
            
            var arr = [String:AnyObject]()
            var sel = 0
            for i in 0..<currentarr.count {
                var temparr = currentarr.objectAtIndex(i) as! [String:AnyObject]
                if(temparr["CreditDescription"] as! String == "Transportation"){
                    sel = i
                    break
                }
            }
            NSUserDefaults.standardUserDefaults().setInteger(sel, forKey: "selected_action")
            let data = NSKeyedArchiver.archivedDataWithRootObject(currentarr)
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: "currentcategory")
            return "waste"
            
        }
        else if(foreign_id == "data_input_waste")
        {
            var mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            
            var datakeyed = NSUserDefaults.standardUserDefaults().objectForKey("actions_data") as! NSData
            var assets = NSKeyedUnarchiver.unarchiveObjectWithData(datakeyed)?.mutableCopy() as! NSMutableDictionary
            var currentarr = assets["EtScorecardList"]!.mutableCopy() as! NSMutableArray
            
            var arr = [String:AnyObject]()
            var sel = 0
            for i in 0..<currentarr.count {
                var temparr = currentarr.objectAtIndex(i) as! [String:AnyObject]
                if(temparr["CreditDescription"] as! String == "Waste"){
                    sel = i
                    break
                }
            }
            NSUserDefaults.standardUserDefaults().setInteger(sel, forKey: "selected_action")
            let data = NSKeyedArchiver.archivedDataWithRootObject(currentarr)
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: "currentcategory")
            return "waste"
        }
        else if(foreign_id == "data_input_water")
        {
            var mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            var datakeyed = NSUserDefaults.standardUserDefaults().objectForKey("actions_data") as! NSData
            var assets = NSKeyedUnarchiver.unarchiveObjectWithData(datakeyed)?.mutableCopy() as! NSMutableDictionary
            var currentarr = assets["EtScorecardList"]!.mutableCopy() as! NSMutableArray
            
            var arr = [String:AnyObject]()
            var sel = 0
            for i in 0..<currentarr.count {
                var temparr = currentarr.objectAtIndex(i) as! [String:AnyObject]
                if(temparr["CreditDescription"] as! String == "Water"){
                    sel = i
                    break
                }
            }
            NSUserDefaults.standardUserDefaults().setInteger(sel, forKey: "selected_action")
            let data = NSKeyedArchiver.archivedDataWithRootObject(currentarr)
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: "currentcategory")
            return "datainput"
        }
        else if(foreign_id == "data_input_energy")
        {
            var mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            
            var datakeyed = NSUserDefaults.standardUserDefaults().objectForKey("actions_data") as! NSData
            var assets = NSKeyedUnarchiver.unarchiveObjectWithData(datakeyed)?.mutableCopy() as! NSMutableDictionary
            var currentarr = assets["EtScorecardList"]!.mutableCopy() as! NSMutableArray
            
            var arr = [String:AnyObject]()
            var sel = 0
            for i in 0..<currentarr.count {
                var temparr = currentarr.objectAtIndex(i) as! [String:AnyObject]
                if(temparr["CreditDescription"] as! String == "Energy"){
                    sel = i
                    break
                }
            }
            NSUserDefaults.standardUserDefaults().setInteger(sel, forKey: "selected_action")
            let data = NSKeyedArchiver.archivedDataWithRootObject(currentarr)
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: "currentcategory")
            return "datainput"
        }
        else if(foreign_id == "data_input_operating_hours")
        {
            var mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            return "manageproject"
        }
        else if(foreign_id == "data_input_density")
        {
            var mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            return "manageproject"
        }
        else if(foreign_id == "data_input_occupancy")
        {
            return "manageproject"
        }
        else if(foreign_id == "data_input_gfa")
        {
            return "manageproject"
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
        return ""
    }
    override func viewDidDisappear(animated: Bool) {
        for request in download_requests
        {
            request.invalidateAndCancel()
        }
        var buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        self.navigationItem.title = buildingdetails["name"] as? String
        //self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as? String
    }
    @IBOutlet weak var spinner: UIView!
    
    @IBOutlet weak var notfound: UILabel!
    func performsegue(dict:[String:AnyObject]){
        
        
        var seguename = ""
        seguename = getseguename(dict)
        if(seguename != ""){
        let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            var v = UIViewController()
            var grid = 0
            if(NSUserDefaults.standardUserDefaults().integerForKey("grid") == 1){
                v = mainstoryboard.instantiateViewControllerWithIdentifier("grid") as! UINavigationController
            }else{
                v = mainstoryboard.instantiateViewControllerWithIdentifier("listofassets") as! UINavigationController
            }
        let more = mainstoryboard.instantiateViewControllerWithIdentifier("more")
        let notifications = mainstoryboard.instantiateViewControllerWithIdentifier("notifications")
        let datainputt = mainstoryboard.instantiateViewControllerWithIdentifier(seguename)
        NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "fromnotification")
        let rootViewController = self.navigationController
        var controllers = (rootViewController!.viewControllers)
        controllers.removeAll()
        var listofassets = mainstoryboard.instantiateViewControllerWithIdentifier("projectslist")
                grid = NSUserDefaults.standardUserDefaults().integerForKey("grid")
            if(grid == 1){
                listofassets = mainstoryboard.instantiateViewControllerWithIdentifier("gridvc") 
            }else{
                listofassets = mainstoryboard.instantiateViewControllerWithIdentifier("projectslist")
            }
        let dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary
        listofassets.navigationItem.title = dict["name"] as? String
        controllers.append(listofassets)
        controllers.append(more)
        controllers.append(notifications)
        controllers.append(datainputt)
        self.navigationController?.setViewControllers(controllers, animated: false)
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
        else if(foreign_id == "data_input_electricity")
        {
            return "No meters for electricity";
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
