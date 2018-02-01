//
//  managecity.swift
//  Arcskoru
//
//  Created by Group X on 04/04/17.
//
//

import UIKit

class manageacity: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate {
    var building_dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData)?.mutableCopy() as! NSMutableDictionary
    @IBOutlet weak var tableview: UITableView!
    var type = ""
    var s = ""
    var t = ""
    var titlearr = NSMutableArray()
    var download_requests = [NSURLSession]()
    var task = NSURLSessionTask()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.layer.cornerRadius = 5
        self.spinner.hidden = true
        self.tabbar.delegate = self
        dateview.hidden = true
        /* building_dict = [
         "name": "sample city iOS",
         "partners": [],
         "certifications": [],
         "gross_area": 2322,
         "street": "29, V S Nagar, Teachers Qtrs St",
         "city": "Chennai",
         "state": "22",
         "country": "IN",
         "zip_code": "600100",
         "unitType": "IP",
         "organization": "My org",
         "ownerType": "Test Owner",
         "intentToPrecertify": false,
         "manageEntityCountry": "IN",
         "dashboard_public": false,
         "plaque_public": false,
         "confidential": false,
         "occupancy": 49000,
         "certification": "",
         "publish": true,
         "owner_email": "dhiranontrack@gmail.com",
         "is_trial_selected": false,
         "leed_score_public": true,
         "survey_with_dashboard": false,
         "override_valid": false,
         "project_type": "city",
         "rating_system": "none",
         "scorecard_selected": false
         
         ]*/
        let notificationsarr = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("notifications") as! NSData) as! NSArray
        if(notificationsarr.count > 0 ){
            self.tabbar.items![4].badgeValue = "\(notificationsarr.count)"
        }else{
            self.tabbar.items![4].badgeValue = nil
        }
        self.tabbar.selectedItem = self.tabbar.items![3]
        
        if((building_dict["project_type"]as! String).lowercaseString == "city"){
            s = "city"
            t = "cities"
        }else if((building_dict["project_type"]as! String).lowercaseString == "community"){
            s = "community"
            t = "communities"
        }
  
        tableview.registerNib(UINib.init(nibName: "manageprojcellwithswitch", bundle: nil), forCellReuseIdentifier: "manageprojcellwithswitch")
        tableview.registerNib(UINib.init(nibName: "segmentcell", bundle: nil), forCellReuseIdentifier: "segmentcell")
        tableview.registerNib(UINib.init(nibName: "manageprojcell", bundle: nil), forCellReuseIdentifier: "manageprojcell")
        tableview.registerNib(UINib.init(nibName: "textcell", bundle: nil), forCellReuseIdentifier: "textcell")
        titlearr = NSMutableArray()
        titlearr.addObject("\((s as! String).capitalizedString) Name")
        titlearr.addObject("Unit Type")
        titlearr.addObject("Rating System")
        titlearr.addObject("Owner Type")
        titlearr.addObject("Owner Organization")
        titlearr.addObject("Owner Email")
        titlearr.addObject("Owner Country")
        titlearr.addObject("Area")
        titlearr.addObject("Keep project private")
        titlearr.addObject("Population")
        titlearr.addObject("Address")
        titlearr.addObject("City")
        titlearr.addObject("State")
        titlearr.addObject("Country")
        titlearr.addObject("Zip Code")
        titlearr.addObject("Year Founded")
        titlearr.addObject("Population - Daytime")
        titlearr.addObject("Population - Nighttime")
        titlearr.addObject("Managing entity Name")
        titlearr.addObject("Managing entity Address (line1)")
        titlearr.addObject("Managing entity Address (line2)")
        titlearr.addObject("Managing entity City")
        titlearr.addObject("Managing entity Country")
        titlearr.addObject("Managing entity State")
        titlearr.addObject("Intend to precertify?")
        titlearr.addObject("Target certification date")
        titlearr.addObject("Geo location")
        
        /* building_dict["city"] = "Chennai"
         building_dict["confidential"] = false
         building_dict["country"] = "IN"
         //"county"] =null
         building_dict["gross_area"] = "1200"
         building_dict["name"] = "created community"
         building_dict["organization"] = "asd"
         building_dict["ownerType"] = "asd"
         building_dict["owner_email"] = "asdasd@gmail.com"
         building_dict["project_type"] = "community"
         building_dict["publish"] = true
         building_dict["rating_system"] = "LEED-CM"
         building_dict["state"] = "22"
         building_dict["street"] = "D2, West wood apartments"
         building_dict["unitType"] = "IP"
         building_dict["zip_code"] = "600032"*/
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlearr.count
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

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("manageprojcell")! as! manageprojcell
        cell.textLabel?.text = titlearr.objectAtIndex(indexPath.row) as! String
        if(indexPath.row == 0){
            if(building_dict["name"] == nil || building_dict["name"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
                cell.detailTextLabel?.text = "\(building_dict["name"] as! String)"
                
            }
        }else if(indexPath.row == 1){
            let cell = tableView.dequeueReusableCellWithIdentifier("segmentcell")! as! segmentcell
            cell.textLabel?.text = titlearr.objectAtIndex(indexPath.row) as! String
            cell.segmentedctrl.tag = indexPath.row
            cell.segmentedctrl.removeAllSegments()
            cell.textLabel?.font = UIFont.init(name: "OpenSans", size: 15)
            cell.segmentedctrl.insertSegmentWithTitle("IP", atIndex: 0, animated: true)
            cell.segmentedctrl.insertSegmentWithTitle("SI", atIndex: 1, animated: true)
            cell.segmentedctrl.addTarget(self, action: #selector(self.segmentchange(_:)), forControlEvents: UIControlEvents.ValueChanged)
            cell.segmentedctrl.selectedSegmentIndex = 0
            return cell
        }
        else if(indexPath.row == 2){
            let cell = tableView.dequeueReusableCellWithIdentifier("segmentcell")! as! segmentcell
            cell.textLabel?.text = titlearr.objectAtIndex(indexPath.row) as! String
            cell.segmentedctrl.tag = indexPath.row
            cell.segmentedctrl.removeAllSegments()
            cell.textLabel?.font = UIFont.init(name: "OpenSans", size: 15)
            cell.segmentedctrl.insertSegmentWithTitle("LEED for \(t as! String)", atIndex: 0, animated: true)
            cell.segmentedctrl.insertSegmentWithTitle("Other", atIndex: 1, animated: true)
            cell.segmentedctrl.insertSegmentWithTitle("None", atIndex: 2, animated: true)
            cell.segmentedctrl.addTarget(self, action: #selector(self.segmentchange(_:)), forControlEvents: UIControlEvents.ValueChanged)
            cell.segmentedctrl.selectedSegmentIndex = 0
            return cell
        }
        else if(indexPath.row == 3){
            
            if(building_dict["ownerType"] == nil || building_dict["ownerType"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
                cell.detailTextLabel?.text = "\(building_dict["ownerType"] as! String)"
            }
        }
        else if(indexPath.row == 4){
            
            if(building_dict["organization"] == nil || building_dict["organization"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
                cell.detailTextLabel?.text = "\(building_dict["organization"] as! String)"
            }
        }
        else if(indexPath.row == 5){
            if(building_dict["owner_email"] == nil || building_dict["owner_email"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
                
                cell.detailTextLabel?.text = "\(building_dict["owner_email"] as! String)"
            }
        }
        else if(indexPath.row == 6){
            
            if(building_dict["country"] == nil || building_dict["country"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
                cell.detailTextLabel?.text = "\(building_dict["country"] as! String)"
            }
            
        }
        else if(indexPath.row == 7){
            if(building_dict["gross_area"] == nil || building_dict["gross_area"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
                if(building_dict["gross_area"] is String){
                    cell.detailTextLabel?.text = "\(building_dict["gross_area"] as! String)"
                }else{
                    cell.detailTextLabel?.text = "\(building_dict["gross_area"] as! Int)"
                }
            }
            
        }
        else if(indexPath.row == 8){
            let cell = tableView.dequeueReusableCellWithIdentifier("manageprojcellwithswitch")! as! manageprojcellwithswitch
            cell.textLabel?.text = titlearr.objectAtIndex(indexPath.row) as? String
            cell.lbl.text = ""
            cell.textLabel?.font = UIFont.init(name: "OpenSans", size: 15)
            if(building_dict["confidential"] == nil || building_dict["confidential"] is NSNull){
                cell.yesorno.on = false
            }else{
                cell.yesorno.on = building_dict["confidential"] as! Bool
            }
            cell.yesorno.tag = indexPath.row
            cell.yesorno.addTarget(self, action: #selector(self.changevalue(_:)), forControlEvents: UIControlEvents.ValueChanged)
            return cell
        }
        else if(indexPath.row == 9){
            if(building_dict["occupancy"] == nil || building_dict["occupancy"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
                if(building_dict["occupancy"] is String){
                    cell.detailTextLabel?.text = "\(building_dict["occupancy"] as! String)"
                }else{
                    cell.detailTextLabel?.text = "\(building_dict["occupancy"] as! Int)"
                }
            }
        }
        else if(indexPath.row == 10){
            
            if(building_dict["street"] == nil || building_dict["street"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
                cell.detailTextLabel?.text = "\(building_dict["street"] as! String)"
            }
            
        }
        else if(indexPath.row == 11){
            
            if(building_dict["city"] == nil || building_dict["city"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
                cell.detailTextLabel?.text = "\(building_dict["city"] as! String)"
            }
            
        }else if(indexPath.row == 12){
            
            if(building_dict["state"] == nil || building_dict["state"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
                cell.detailTextLabel?.text = "\(building_dict["state"] as! String)"
            }
            
        }
        else if(indexPath.row == 13){
            
            if(building_dict["country"] == nil || building_dict["country"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
                cell.detailTextLabel?.text = "\(building_dict["country"] as! String)"
            }
            
        }else if(indexPath.row == 14){
            if(building_dict["zip_code"] == nil || building_dict["zip_code"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
                cell.detailTextLabel?.text = "\(building_dict["zip_code"] as! String)"
            }
            
        }else if(indexPath.row == 15){
            if(building_dict["year_constructed"] == nil || building_dict["year_constructed"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
                cell.detailTextLabel?.text = "\(building_dict["year_constructed"] as! String)"
            }
        }
        else if(indexPath.row == 16){
            if(building_dict["populationDayTime"] == nil || building_dict["populationDayTime"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
                cell.detailTextLabel?.text = "\(building_dict["populationDayTime"] as! String)"
            }
        }else if(indexPath.row == 17){
            if(building_dict["populationNightTime"] == nil || building_dict["populationNightTime"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
                cell.detailTextLabel?.text = "\(building_dict["populationNightTime"] as! String)"
            }
        }else if(indexPath.row == 18){
            if(building_dict["manageEntityName"] == nil || building_dict["manageEntityName"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
                cell.detailTextLabel?.text = "\(building_dict["manageEntityName"] as! String)"
            }
        }
        else if(indexPath.row == 19){
            if(building_dict["manageEntityAdd1"] == nil || building_dict["manageEntityAdd1"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
                cell.detailTextLabel?.text = "\(building_dict["manageEntityAdd1"] as! String)"
            }
        }
        else if(indexPath.row == 20){
            if(building_dict["managEntityAdd2"] == nil || building_dict["managEntityAdd2"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
                cell.detailTextLabel?.text = "\(building_dict["managEntityAdd2"] as! String)"
            }
        }
        else if(indexPath.row == 21){
            if(building_dict["manageEntityCity"] == nil || building_dict["manageEntityCity"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
                cell.detailTextLabel?.text = "\(building_dict["manageEntityCity"] as! String)"
            }
        }else if(indexPath.row == 22){
            if(building_dict["manageEntityState"] == nil || building_dict["manageEntityState"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
                cell.detailTextLabel?.text = "\(building_dict["manageEntityState"] as! String)"
            }
        }
        else if(indexPath.row == 23){
            if(building_dict["manageEntityCountry"] == nil || building_dict["manageEntityCountry"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
                cell.detailTextLabel?.text = "\(building_dict["manageEntityCountry"] as! String)"
            }
        }
        else if(indexPath.row == 24){
            
           let cell = tableView.dequeueReusableCellWithIdentifier("manageprojcellwithswitch")! as! manageprojcellwithswitch
            cell.textLabel?.text = titlearr.objectAtIndex(indexPath.row) as? String
            cell.lbl.text = ""
            cell.textLabel?.font = UIFont.init(name: "OpenSans", size: 15)
            if(building_dict["intentToPrecertify"] == nil || building_dict["intentToPrecertify"] is NSNull){
                cell.yesorno.on = false
            }else{
                cell.yesorno.on = building_dict["intentToPrecertify"] as! Bool
            }
            cell.yesorno.tag = indexPath.row
            cell.yesorno.addTarget(self, action: #selector(self.changevalue(_:)), forControlEvents: UIControlEvents.ValueChanged)
            return cell
            
        }else if(indexPath.row == 25){
            
            //intentToPrecertify   switch
            if(building_dict["targetCertDate"] == nil || building_dict["targetCertDate"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
                cell.detailTextLabel?.text = "\(building_dict["targetCertDate"] as! String)"
            }
        }
        
        
        return cell
        
    }
    
    func changevalue(sender: UISwitch){
        if(sender.tag == 8){
            building_dict["confidential"] = sender.on
        }else if(sender.tag == 24){
            building_dict["intentToPrecertify"] = sender.on
        }
    }
    
    func updateproject(){
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/",credentials().domain_url,building_dict["leed_id"] as! Int))
        print(url?.absoluteURL)
        var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        var task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401 {           // check for http errors
                dispatch_async(dispatch_get_main_queue(), {
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                })
            } else
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.spinner.hidden = true
                        self.view.userInteractionEnabled = true
                    })
                }else{
                    print(data)
                    var jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        print(jsonDictionary)
                        var datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                        NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "building_details")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "row")
                        dispatch_async(dispatch_get_main_queue(), {
                            self.spinner.hidden = true
                            self.view.userInteractionEnabled = true
                            //self.navigationController?.popViewControllerAnimated(true)
                        })
                        //self.tableview.reloadData()
                        // self.buildingactions(subscription_key, leedid: leedid)
                    } catch {
                        print(error)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.spinner.hidden = true
                            self.view.userInteractionEnabled = true
                        })
                    }
            }
            
        }
        task.resume()
        
    }

    
    
    func segmentchange(sender : UISegmentedControl){
        if(sender.tag == 1){
            building_dict["unitType"] = sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)! as? String
        }else if(sender.tag == 2){
            if(sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)! as? String == "LEED for cities"){
                building_dict["rating_system"] = "LEED-CT"
            }else if(sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)! as? String == "LEED for communities"){
                building_dict["rating_system"] = "LEED-CM"
            }else{
                building_dict["rating_system"] = (sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)! as? String)?.lowercaseString
            }
            
        }
    }
    
    //assets/LEED:1000122768/?recompute_score=1
    
    @IBOutlet weak var tabbar: UITabBar!
    @IBAction func submit(sender: AnyObject) {
        if((building_dict["name"] != nil || (building_dict["name"] as? String)?.characters.count > 0) && (building_dict["rating_system"] != nil || (building_dict["rating_system"] as? String)?.characters.count > 0) && (building_dict["unitType"] != nil || (building_dict["unitType"] as? String)?.characters.count > 0) && (building_dict["organization"] != nil || (building_dict["organization"] as? String)?.characters.count > 0) && (building_dict["owner_email"] != nil || (building_dict["owner_email"] as? String)?.characters.count > 0) && (building_dict["country"] != nil || (building_dict["country"] as? String)?.characters.count > 0) && (building_dict["gross_area"] != nil || (building_dict["gross_area"] as? String)?.characters.count > 0) && (building_dict["confidential"] != nil || (building_dict["confidential"] as? String)?.characters.count > 0) && (building_dict["occupancy"] != nil || (building_dict["occupancy"] as? String)?.characters.count > 0) && (building_dict["street"] != nil || (building_dict["street"] as? String)?.characters.count > 0) && (building_dict["city"] != nil || (building_dict["city"] as? String)?.characters.count > 0) && (building_dict["zip_code"] != nil || (building_dict["zip_code"] as? String)?.characters.count > 0)){
            building_dict["manageEntityCountry"] = building_dict["country"]
            dispatch_async(dispatch_get_main_queue(), {
                self.spinner.hidden = false
                self.savebuilding()
            })
        }else{
            
            print("Missing fields")
            var temparr = NSMutableArray()
            if(building_dict["name"] == nil || (building_dict["name"] as? String)?.characters.count == 0){
                temparr.addObject("Name")
            }
            if(building_dict["rating_system"] == nil || (building_dict["rating_system"] as? String)?.characters.count == 0){
                temparr.addObject("Rating system")
            }
            if(building_dict["unitType"] == nil || (building_dict["unitType"] as? String)?.characters.count == 0){
                temparr.addObject("Unit Type")
            }
            if(building_dict["organization"] == nil || (building_dict["organization"] as? String)?.characters.count == 0){
                temparr.addObject("Organization")
            }
            if(building_dict["owner_email"] == nil || (building_dict["owner_email"] as? String)?.characters.count == 0){
                temparr.addObject("Owner email")
            }
            if(building_dict["country"] == nil || (building_dict["country"] as? String)?.characters.count == 0){
                temparr.addObject("Country")
            }
            if(building_dict["gross_area"] == nil || (building_dict["gross_area"] as? String)?.characters.count == 0){
                temparr.addObject("Area")
            }
            if(building_dict["confidential"] == nil || (building_dict["confidential"] as? String)?.characters.count == 0){
                temparr.addObject("Project private")
            }
            
            if(building_dict["occupancy"] == nil || (building_dict["occupancy"] as? String)?.characters.count == 0){
                temparr.addObject("Population")
            }
            if(building_dict["street"] == nil || (building_dict["street"] as? String)?.characters.count == 0){
                temparr.addObject("Address")
            }
            
            if(building_dict["city"] == nil || (building_dict["city"] as? String)?.characters.count == 0){
                temparr.addObject("City")
            }
            
            if(building_dict["zip_code"] == nil || (building_dict["zip_code"] as? String)?.characters.count == 0){
                temparr.addObject("Zip Code")
            }
            
            
            var string = temparr.componentsJoinedByString("\n")
            print(string)
            let alert = UIAlertController(title: "Required fields are found empty", message: "Please kindly fill out the below fields :- \n \(string)", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    func savebuilding(){
        var payload = NSMutableString()
        payload.appendString("{")
        
        
        for (key, value) in building_dict {
            if(value is String){
                payload.appendString("\"\(key)\": \"\(value)\",")
            }else if(value is Int){
                payload.appendString("\"\(key)\": \(value),")
            }
        }
        var str = payload as! String
        payload.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
        payload.appendString("}")
        str = payload as! String
        print(str)
        
        
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/",credentials().domain_url,building_dict["leed_id"] as! Int))
        print(url?.absoluteURL)
        var subscription_key = credentials().subscription_key
        var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "PUT"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        
        var data = [String:AnyObject]()
        data = self.convertStringToDictionary(str)!
        do {
            var postdata = try NSJSONSerialization.dataWithJSONObject(data, options:  NSJSONWritingOptions(rawValue:0))
            print(data)
            request.HTTPBody = postdata
        }catch{
            
        }
        /*
         NSMutableDictionary *mapData = [[NSMutableDictionary alloc] init];
         
         mapData[@"tenant_name"] = name;
         mapData[@"response_method"] = @"web";
         mapData[@"location"] = loc;
         mapData[@"satisfaction"] = [NSNumber numberWithInteger:position];
         mapData[@"complaints"] = [USAImages componentsJoinedByString:@","];
         mapData[@"other_complaint"] = textVie.text;
         mapData[@"language"] = @"English";
         NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
         [requst setHTTPBody:postData];
         */
        
        
        
        //request.HTTPBody = httpbody.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        var task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401 {           // check for http errors
                dispatch_async(dispatch_get_main_queue(), {
                      self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                })
            } else
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    dispatch_async(dispatch_get_main_queue(), {
                        //   self.spinner.hidden = true
                        var jsonDictionary : NSDictionary
                        do {
                            jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                            print(jsonDictionary)
                            //self.tableview.reloadData()
                            // self.buildingactions(subscription_key, leedid: leedid)
                            dispatch_async(dispatch_get_main_queue(), {
                                //      self.updateproject()
                            })
                        } catch {
                            print(error)
                        }
                        self.view.userInteractionEnabled = true
                    })
                }else{
                    print(data)
                    var jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        print(jsonDictionary)
                        //self.tableview.reloadData()
                        // self.buildingactions(subscription_key, leedid: leedid)
                        dispatch_async(dispatch_get_main_queue(), {
                                  self.updateproject()
                        })
                    } catch {
                        print(error)
                    }
            }
            
        }
        task.resume()
        
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
    
    func showalert(message:String, title:String, action:String){
        
        //let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        //let callActionHandler = { (action:UIAlertAction!) -> Void in
        dispatch_async(dispatch_get_main_queue(), {
            self.view.userInteractionEnabled = true
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
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dispatch_async(dispatch_get_main_queue(), {
            //dateview.hidden = false
            self.selected_index = indexPath.row
            if(indexPath.row == 0){
                let cell = self.tableview.cellForRowAtIndexPath(indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != "Not available"){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }else if(indexPath.row == 1){
                
            }else if(indexPath.row == 2){
                
            }else if(indexPath.row == 3){
                let cell = self.tableview.cellForRowAtIndexPath(indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != "Not available"){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }else if(indexPath.row == 4){
                let cell = self.tableview.cellForRowAtIndexPath(indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != "Not available"){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }else if(indexPath.row == 5){
                let cell = self.tableview.cellForRowAtIndexPath(indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != "Not available"){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }else if(indexPath.row == 6){
                self.performSegueWithIdentifier("gotopickerview", sender: nil)
            }else if(indexPath.row == 7){
                let cell = self.tableview.cellForRowAtIndexPath(indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != "Not available"){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }else if(indexPath.row == 8){
                
            }else if(indexPath.row == 9){
                let cell = self.tableview.cellForRowAtIndexPath(indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != "Not available"){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }else if(indexPath.row == 10){
                let cell = self.tableview.cellForRowAtIndexPath(indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != "Not available"){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }else if(indexPath.row == 11){
                let cell = self.tableview.cellForRowAtIndexPath(indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != "Not available"){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }else if(indexPath.row == 12){
                self.performSegueWithIdentifier("gotopickerview", sender: nil)
                /*let cell = self.tableview.cellForRowAtIndexPath(indexPath)! as! manageprojcell
                 if(cell.detailTextLabel?.text != "Not available"){
                 self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                 }else{
                 self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                 }*/
            }else if(indexPath.row == 13){
                self.performSegueWithIdentifier("gotopickerview", sender: nil)
            }else if(indexPath.row == 14){
                let cell = self.tableview.cellForRowAtIndexPath(indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != "Not available"){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }else if(indexPath.row == 15){
                let cell = self.tableview.cellForRowAtIndexPath(indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != "Not available"){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }
            else if(indexPath.row == 16){
                let cell = self.tableview.cellForRowAtIndexPath(indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != "Not available"){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }else if(indexPath.row == 17){
                let cell = self.tableview.cellForRowAtIndexPath(indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != "Not available"){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }else if(indexPath.row == 18){
                let cell = self.tableview.cellForRowAtIndexPath(indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != "Not available"){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }
            else if(indexPath.row == 19){
                let cell = self.tableview.cellForRowAtIndexPath(indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != "Not available"){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }
            else if(indexPath.row == 20){
                let cell = self.tableview.cellForRowAtIndexPath(indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != "Not available"){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }
            else if(indexPath.row == 21){
                let cell = self.tableview.cellForRowAtIndexPath(indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != "Not available"){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }else if(indexPath.row == 22){
                self.performSegueWithIdentifier("gotopickerview", sender: nil)
            }
            else if(indexPath.row == 23){
                self.performSegueWithIdentifier("gotopickerview", sender: nil)
            }
            else if(indexPath.row == 24){
                
            }else if(indexPath.row == 25){
            let cell = self.tableview.cellForRowAtIndexPath(indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != "Not available"){
                    var str = cell.detailTextLabel?.text
                    var dateformatter = NSDateFormatter()
                    dateformatter.dateFormat = "yyyy-MM-dd"
                    var date = dateformatter.dateFromString(str!)! as! NSDate
                    self.dpicker.setDate(date, animated: true)
                }else{
                    self.dpicker.date = NSDate()
                }
                self.dateview.hidden = false
            //intentToPrecertify   switch
                
            }

            
            self.tableview.reloadData()
        })
    }
    
    weak var AddAlertSaveAction: UIAlertAction?
    var selected_index = 0
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "gotopickerview"){
            var dest = segue.destinationViewController as! pickerviewcontroller
            dest.indx = selected_index
        }
    }
    
    func configurationTextField(textField: UITextField!)
    {
        print("configurat hire the TextField")
        
        if let tField = textField {
            tField.enablesReturnKeyAutomatically = true
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleTextFieldTextDidChangeNotification:", name: UITextFieldTextDidChangeNotification, object: textField)
            //self.textField = textField!        //Save reference to the UITextField
            //self.textField.text = "Hello world"
        }
    }
    
    func handleTextFieldTextDidChangeNotification(notification: NSNotification) {
        let textField = notification.object as! UITextField
        
        // Enforce a minimum length of >= 1 for secure text alerts.
        AddAlertSaveAction!.enabled = textField.text?.characters.count >= 1
    }
    
    func handleCancel(alertView: UIAlertAction!, index: Int)
    {
        
    }
    
    func removeTextFieldObserver() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidChangeNotification, object: alert.textFields![0])
    }
    var alert = UIAlertController()
    
    func showalert(index: Int, title : String, value : String){
        dispatch_async(dispatch_get_main_queue(), {
            self.alert = UIAlertController(title: "", message: "Enter the \(title as! String)", preferredStyle: UIAlertControllerStyle.Alert)
            self.alert.addTextFieldWithConfigurationHandler(self.configurationTextField)
            var otherAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
                print("User click Ok button")
                var txtfld = self.alert.textFields![0] as! UITextField
                if(index == 0){
                    self.building_dict["name"] = txtfld.text
                }else if(index == 1){
                    self.building_dict["unitType"] = txtfld.text
                }else if(index == 2){
                    self.building_dict["rating_system"] = txtfld.text
                }
                else if(index == 3){
                    self.building_dict["ownerType"] = txtfld.text
                }
                else if(index == 4){
                    self.building_dict["organization"] = txtfld.text
                }
                else if(index == 5){
                    self.building_dict["owner_email"] = txtfld.text
                }
                else if(index == 6){
                    self.building_dict["country"] = txtfld.text
                }
                else if(index == 7){
                    self.building_dict["gross_area"] = txtfld.text
                }
                else if(index == 8){
                    
                }
                else if(index == 9){
                    self.building_dict["occupancy"] = txtfld.text
                }
                else if(index == 10){
                    self.building_dict["street"] = txtfld.text
                }
                else if(index == 11){
                    self.building_dict["city"] = txtfld.text
                }
                else if(index == 12){
                    self.building_dict["state"] = txtfld.text
                }else if(index == 13){
                    self.building_dict["country"] = txtfld.text
                }else if(index == 14){
                    self.building_dict["zip_code"] = txtfld.text
                }else if(index == 15){
                    self.building_dict["year_constructed"] = txtfld.text
                }
                else if(index == 16){
                    self.building_dict["populationDayTime"] = txtfld.text
                }else if(index == 17){
                    self.building_dict["populationNightTime"] = txtfld.text
                }else if(index == 18){
                   self.building_dict["manageEntityName"] = txtfld.text
                }
                else if(index == 19){
                    self.building_dict["manageEntityAdd1"] = txtfld.text
                }
                else if(index == 20){
                    self.building_dict["managEntityAdd2"] = txtfld.text
                }
                else if(index == 21){
                    self.building_dict["manageEntityCity"] = txtfld.text
                }else if(index == 22){
                    self.building_dict["manageEntityState"] = txtfld.text
                }
                else if(index == 23){
                    self.building_dict["manageEntityCountry"] = txtfld.text
                }
               
                
                
                self.tableview.reloadData()
                //print(self.textField.text)
            })
            otherAction.enabled = false
            
            // save the other action to toggle the enabled/disabled state when the text changed.
            self.AddAlertSaveAction = otherAction
            
            
            
            self.alert.addAction(UIAlertAction(title: "cancel", style: UIAlertActionStyle.Cancel, handler:{ (UIAlertAction)in
                
            }))
            self.alert.addAction(otherAction)
            self.alert.textFields![0].text = value
            
            self.presentViewController(self.alert, animated: true, completion: {
                print("completion block")
            })
        })
    }
    
    @IBOutlet weak var dpicker: UIDatePicker!
    @IBOutlet weak var spinner: UIView!
    
    override func viewDidAppear(animated: Bool) {
        self.navigationItem.title = building_dict["name"] as? String
        tableview.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func datedone(sender: AnyObject) {
        var dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        var date = dateformatter.stringFromDate(dpicker.date) as! String
        building_dict["targetCertDate"] = date
        dateview.hidden = true
        tableview.reloadData()
    }
    
    @IBAction func datechanged(sender: AnyObject) {
    }
    @IBAction func datecancel(sender: AnyObject) {
        dateview.hidden = true
    }
    @IBOutlet weak var dateview: UIView!
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     
     
     */
    
}
