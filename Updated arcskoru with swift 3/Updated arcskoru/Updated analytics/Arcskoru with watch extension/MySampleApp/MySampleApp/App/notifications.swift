//
//  more.swift
//  LEEDOn
//
//  Created by Group X on 28/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class notifications: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate,UINavigationControllerDelegate {
    var notificationsarr = NSArray()
    @IBOutlet weak var tableview: UITableView!
    var task = URLSessionTask()
    var download_requests = [URLSession]()
    @IBOutlet weak var nav: UINavigationBar!
    @IBOutlet weak var backbtn: UIButton!
    @IBOutlet weak var assetname: UILabel!
    @IBOutlet weak var tabbar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        notfound.text = "No notifications available"
        self.spinner.layer.cornerRadius = 5
        self.spinner.isHidden = true
        self.titlefont()
        backbtn.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12)
        self.tabbar.selectedItem = self.tabbar.items![3]
        notificationsarr = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "notifications") as! Data) as! NSArray
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
        let dict = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary
        tabbar.selectedItem = self.tabbar.items![3]
        self.navigationItem.title = dict["name"] as? String
        assetname.text = dict["name"] as? String        
        if(notificationsarr.count > 0){
            notfound.isHidden = true
        }else{
            notfound.isHidden = false
        }
        print(notificationsarr)
        var buildingdetails = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        assetname.text = buildingdetails["name"] as? String
        self.navigationItem.title = buildingdetails["name"] as? String
        let navItem = UINavigationItem(title: (buildingdetails["name"] as? String)!);
        self.nav.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!]
        let doneItem = UIBarButtonItem(title: "< More", style: .plain, target: self, action: #selector(sayHello(_:)))
        navItem.leftBarButtonItem = doneItem;
        nav.setItems([navItem], animated: false);
        if(UserDefaults.standard.object(forKey: "actions_data") == nil){
            self.view.isUserInteractionEnabled = false
            if(self.navigationController != nil){
            self.navigationController?.view.isUserInteractionEnabled = false
            }
            self.tabbar.isUserInteractionEnabled = true
            self.spinner.isHidden = false
            buildingactions(credentials().subscription_key, leedid: buildingdetails["leed_id"] as! Int)
        }
        // Do any additional setup after loading the view.
    }
    
    func sayHello(_ sender: UIBarButtonItem) {
        //print("Projects clicked")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "performsegue"), object: nil, userInfo: ["seguename":"more"])
    }
    
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if(viewController is more){
            self.navigationController?.title = "More"
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backItem?.title = "More"
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
    
    func buildingactions(_ subscription_key:String, leedid: Int){
        let url = URL.init(string: String(format: "%@assets/LEED:%d/actions/",credentials().domain_url,leedid))
        ////print(url?.absoluteURL)
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        var token = UserDefaults.standard.object(forKey: "token") as! String
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(session)
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
                    //self.spinner.hidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
                return
            } else
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
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
                        UserDefaults.standard.set(datakeyed, forKey: "actions_data")
                        UserDefaults.standard.synchronize()
                        DispatchQueue.main.async(execute: {
                            self.spinner.isHidden = true
                            self.tabbar.isUserInteractionEnabled = true
                            self.view.isUserInteractionEnabled = true
                            if(self.navigationController != nil){
                                self.navigationController?.view.isUserInteractionEnabled = true
                            }
                            self.tableview.reloadData()
                        })
                        
                    } catch {
                        //print(error)
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

    
    func showalert(_ message:String, title:String, action:String){
        
        //let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        //let callActionHandler = { (action:UIAlertAction!) -> Void in
        DispatchQueue.main.async(execute: {
            self.view.isUserInteractionEnabled = true
            //self.spinner.hidden = true
            self.view.isUserInteractionEnabled = true
            self.tabbar.isUserInteractionEnabled = true
            self.view.isUserInteractionEnabled = true
            if(self.navigationController != nil){
                self.navigationController?.view.isUserInteractionEnabled = true
            }
            self.maketoast(message, type: "error")
            //self.navigationController?.popViewControllerAnimated(true)
        })
        
        //        }
        //      let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        //    alertController.addAction(defaultAction)
        
        //presentViewController(alertController, animated: true, completion: nil)
        
        
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsarr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let dict = notificationsarr.object(at: indexPath.row) as! NSDictionary
        cell.textLabel?.text = getnotificationvalues(dict["foreign_id"] as! String)
        
        var date = Date()
        if(dict["time"] == nil && dict["time"] is NSNull){
            
        }else{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            date = formatter.date(from: dict["time"] as! String)!
            formatter.dateFormat = "MMM dd, yyyy"
            let temp = formatter.string(from: date)
            formatter.dateFormat = "hh:mm a"
            let time = formatter.string(from: date)
            ////print("asdasd",dict["time"])
            cell.detailTextLabel?.text = "\(temp) at \(time)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
            if(UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height){
                return 0.105 * UIScreen.main.bounds.size.height;
            }
            return 0.105 * UIScreen.main.bounds.size.width;
        }else{
        if(UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height){
            return 0.135 * UIScreen.main.bounds.size.height;
        }
        return 0.135 * UIScreen.main.bounds.size.width;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dict = notificationsarr.object(at: indexPath.row) as! NSDictionary
        let foreign_id = dict["foreign_id"] as! String
        if(foreign_id == "updated_userManual")
        {
            
        }
        else if(foreign_id == "data_input_human")
        {
            let dict = ["foreign_id":foreign_id]
            performsegue(dict as! NSMutableDictionary)
        }
        else if(foreign_id == "data_input_transportation")
        {
            let dict = ["foreign_id":foreign_id]
            performsegue(dict as! NSMutableDictionary)
        }
        else if(foreign_id == "data_input_waste")
        {
            let dict = ["foreign_id":foreign_id]
            performsegue(dict as! NSMutableDictionary)
        }
        else if(foreign_id == "data_input_water")
        {
            let dict = ["foreign_id":foreign_id]
            performsegue(dict as! NSMutableDictionary)
        }
        else if(foreign_id == "data_input_energy" || foreign_id == "data_input_electricity")
        {
            let dict = ["foreign_id":foreign_id]
            performsegue(dict as! NSMutableDictionary)
        }
        else if(foreign_id == "data_input_operating_hours")
        {
            let dict = ["foreign_id":foreign_id]
            performsegue(dict as! NSMutableDictionary)
        }
        else if(foreign_id == "data_input_density")
        {
            let dict = ["foreign_id":foreign_id]
            performsegue(dict as! NSMutableDictionary)
        }
        else if(foreign_id == "data_input_occupancy")
        {
            let dict = ["foreign_id":foreign_id]
            performsegue(dict as! NSMutableDictionary)
        }
        else if(foreign_id == "data_input_gfa")
        {
            let dict = ["foreign_id":foreign_id]
            performsegue(dict as! NSMutableDictionary)
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
    
    func getseguename(_ dict:NSMutableDictionary) -> String{
        let foreign_id = dict["foreign_id"] as! String
        
        if(foreign_id == "updated_userManual")
        {
        }
        else if(foreign_id == "data_input_human")
        {
            let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let datakeyed = UserDefaults.standard.object(forKey: "actions_data") as! Data
            let assets = (NSKeyedUnarchiver.unarchiveObject(with: datakeyed) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            let currentarr = (assets["EtScorecardList"]! as! NSArray).mutableCopy() as! NSMutableArray
            
            let arr = NSMutableDictionary()
            var sel = 0
            for i in 0..<currentarr.count {
                var temparr = (currentarr.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                if(temparr["CreditDescription"] as! String == "Human Experience"){
                    sel = i
                    break
                }
            }
            UserDefaults.standard.set(sel, forKey: "selected_action")
            let data = NSKeyedArchiver.archivedData(withRootObject: currentarr)
            UserDefaults.standard.set(data, forKey: "currentcategory")
            return "waste"
            
        }
        else if(foreign_id == "data_input_transportation")
        {
            var mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            
            let datakeyed = UserDefaults.standard.object(forKey: "actions_data") as! Data
            let assets = (NSKeyedUnarchiver.unarchiveObject(with: datakeyed) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            let currentarr = (assets["EtScorecardList"]! as! NSArray).mutableCopy() as! NSMutableArray
            
            var arr = NSMutableDictionary()
            var sel = 0
            for i in 0..<currentarr.count {
                var temparr = (currentarr.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                if(temparr["CreditDescription"] as! String == "Transportation"){
                    sel = i
                    break
                }
            }
            UserDefaults.standard.set(sel, forKey: "selected_action")
            let data = NSKeyedArchiver.archivedData(withRootObject: currentarr)
            UserDefaults.standard.set(data, forKey: "currentcategory")
            return "waste"
            
        }
        else if(foreign_id == "data_input_waste")
        {
            var mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            
            let datakeyed = UserDefaults.standard.object(forKey: "actions_data") as! Data
            let assets = (NSKeyedUnarchiver.unarchiveObject(with: datakeyed) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            let currentarr = (assets["EtScorecardList"]! as! NSArray).mutableCopy() as! NSMutableArray
            
            var arr = NSMutableDictionary()
            var sel = 0
            for i in 0..<currentarr.count {
                var temparr = (currentarr.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                if(temparr["CreditDescription"] as! String == "Waste"){
                    sel = i
                    break
                }
            }
            UserDefaults.standard.set(sel, forKey: "selected_action")
            let data = NSKeyedArchiver.archivedData(withRootObject: currentarr)
            UserDefaults.standard.set(data, forKey: "currentcategory")
            return "waste"
        }
        else if(foreign_id == "data_input_water")
        {
            var mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let datakeyed = UserDefaults.standard.object(forKey: "actions_data") as! Data
            let assets = (NSKeyedUnarchiver.unarchiveObject(with: datakeyed) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            let currentarr = (assets["EtScorecardList"]! as! NSArray).mutableCopy() as! NSMutableArray
            
            var arr = NSMutableDictionary()
            var sel = 0
            for i in 0..<currentarr.count {
                var temparr = (currentarr.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                if(temparr["CreditDescription"] as! String == "Water"){
                    sel = i
                    break
                }
            }
            UserDefaults.standard.set(sel, forKey: "selected_action")
            let data = NSKeyedArchiver.archivedData(withRootObject: currentarr)
            UserDefaults.standard.set(data, forKey: "currentcategory")
            return "datainput"
        }
        else if(foreign_id == "data_input_energy")
        {
            var mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            
            let datakeyed = UserDefaults.standard.object(forKey: "actions_data") as! Data
            let assets = (NSKeyedUnarchiver.unarchiveObject(with: datakeyed) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            let currentarr = (assets["EtScorecardList"]! as! NSArray).mutableCopy() as! NSMutableArray
            
            var arr = NSMutableDictionary()
            var sel = 0
            for i in 0..<currentarr.count {
                var temparr = (currentarr.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                if(temparr["CreditDescription"] as! String == "Energy"){
                    sel = i
                    break
                }
            }
            UserDefaults.standard.set(sel, forKey: "selected_action")
            let data = NSKeyedArchiver.archivedData(withRootObject: currentarr)
            UserDefaults.standard.set(data, forKey: "currentcategory")
            return "datainput"
        }
        else if(foreign_id == "data_input_operating_hours")
        {
            var mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            return "manageproj"
        }
        else if(foreign_id == "data_input_density")
        {
            var mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            return "manageproj"
        }
        else if(foreign_id == "data_input_occupancy")
        {
            return "manageproj"
        }
        else if(foreign_id == "data_input_gfa")
        {
            return "manageproj"
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
        override func viewWillDisappear(_ animated: Bool) {
            DispatchQueue.main.async(execute: {
                let t = self.download_requests
                for r in 0 ..< t.count
                {
                    let request = t[r] as! URLSession
                    request.invalidateAndCancel()                 
                }
                let buildingdetails = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                self.navigationItem.title = buildingdetails["name"] as? String
                self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as? String
                //stop all download requests
            })
        }

        //self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as? String
    
    @IBOutlet weak var spinner: UIView!
    
    @IBOutlet weak var notfound: UILabel!
    func performsegue(_ dict:NSMutableDictionary){
        
        
        var seguename = ""
        seguename = getseguename(dict)
        if(seguename != ""){
        let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            var v = UIViewController()
            var grid = 0
            if(UserDefaults.standard.integer(forKey: "grid") == 1){
                v = mainstoryboard.instantiateViewController(withIdentifier: "grid") as! UINavigationController
            }else{
                v = mainstoryboard.instantiateViewController(withIdentifier: "listofassets") as! UINavigationController
            }
        let more = mainstoryboard.instantiateViewController(withIdentifier: "more")
        let notifications = mainstoryboard.instantiateViewController(withIdentifier: "notifications")
        let datainputt = mainstoryboard.instantiateViewController(withIdentifier: seguename)
        UserDefaults.standard.set(1, forKey: "fromnotification")
        let rootViewController = self.navigationController
        var controllers = (rootViewController!.viewControllers)
        controllers.removeAll()
        var listofassets = mainstoryboard.instantiateViewController(withIdentifier: "projectslist")
                grid = UserDefaults.standard.integer(forKey: "grid")
            if(grid == 1){
                listofassets = mainstoryboard.instantiateViewController(withIdentifier: "gridvc") 
            }else{
                listofassets = mainstoryboard.instantiateViewController(withIdentifier: "projectslist")
            }
        let dict = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary
        listofassets.navigationItem.title = dict["name"] as? String
        controllers.append(listofassets)
        controllers.append(more)
        controllers.append(notifications)
        controllers.append(datainputt)
        self.navigationController?.setViewControllers(controllers, animated: false)
        }
    }
    
    func getnotificationvalues(_ foreign_id:String) -> String{
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
            var buildingdetails = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
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
