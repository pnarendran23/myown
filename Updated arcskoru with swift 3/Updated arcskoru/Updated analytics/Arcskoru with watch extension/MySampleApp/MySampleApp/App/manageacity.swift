//
//  managecity.swift
//  Arcskoru
//
//  Created by Group X on 04/04/17.
//
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class manageacity: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate, UITextFieldDelegate {
    var data_dict = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
    @IBOutlet weak var tableview: UITableView!
    var type = ""
    var s = ""
    var t = ""
    var titlearr = NSMutableArray()
    var download_requests = [URLSession]()
    var task = URLSessionTask()
    var country = ""
    var state = ""
    var managecountry = ""
    var managestate = ""
    var tempdata_dict = NSMutableDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        bgcolor = self.savebtn.backgroundColor!
        self.spinner.layer.cornerRadius = 5
        self.spinner.isHidden = true
        self.tabbar.delegate = self
        dateview.isHidden = true
        /* data_dict = [
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
        let notificationsarr = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "notifications") as! Data) as! NSArray
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
        self.tabbar.selectedItem = self.tabbar.items![3]
        
        if((data_dict["project_type"]as! String).lowercased() == "city"){
            s = "city"
            t = "cities"
        }else if((data_dict["project_type"]as! String).lowercased() == "community"){
            s = "community"
            t = "communities"
        }
        var countries = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "countries") as! Data) as! NSDictionary
        var currentcountry = self.data_dict["country"] as? String
        var currentstate = self.data_dict["state"] as? String
        // Getting country
        let tt = countries["countries"] as! NSDictionary
        if(tt[currentcountry] != nil){
            self.country = (tt[currentcountry] as? String)!
        }
        countries = countries["divisions"] as! NSDictionary
        if(countries[currentcountry] != nil){
            let dict = countries[currentcountry] as! NSDictionary
            if(dict[currentstate] != nil){
            self.state = dict[currentstate] as! String
            }
        }
        
        tableview.register(UINib.init(nibName: "manageprojcellwithswitch", bundle: nil), forCellReuseIdentifier: "manageprojcellwithswitch")
        tableview.register(UINib.init(nibName: "segmentcell", bundle: nil), forCellReuseIdentifier: "segmentcell")
        tableview.register(UINib.init(nibName: "manageprojcell", bundle: nil), forCellReuseIdentifier: "manageprojcell")
        tableview.register(UINib.init(nibName: "textcell", bundle: nil), forCellReuseIdentifier: "textcell")
        titlearr = NSMutableArray()
        titlearr.add("\((s ).capitalized) Name")
        titlearr.add("Unit Type")
        titlearr.add("Rating System")
        titlearr.add("Owner Type")
        titlearr.add("Owner Organization")
        titlearr.add("Owner Email")
        titlearr.add("Owner Country")
        titlearr.add("Area")
        titlearr.add("Keep project private")
        titlearr.add("Population")
        titlearr.add("Address")
        titlearr.add("City")
        titlearr.add("State")
        titlearr.add("Country")
        titlearr.add("Zip Code")
        titlearr.add("Year Founded")
        titlearr.add("Population - Daytime")
        titlearr.add("Population - Nighttime")
        titlearr.add("Managing entity Name")
        titlearr.add("Managing entity Address (line1)")
        titlearr.add("Managing entity Address (line2)")
        titlearr.add("Managing entity City")
        titlearr.add("Managing entity State")
        titlearr.add("Managing entity Country")
        titlearr.add("Intend to precertify?")
        titlearr.add("Target certification date")        
        /* data_dict["city"] = "Chennai"
         data_dict["confidential"] = false
         data_dict["country"] = "IN"
         //"county"] =null
         data_dict["gross_area"] = "1200"
         data_dict["name"] = "created community"
         data_dict["organization"] = "asd"
         data_dict["ownerType"] = "asd"
         data_dict["owner_email"] = "asdasd@gmail.com"
         data_dict["project_type"] = "community"
         data_dict["publish"] = true
         data_dict["rating_system"] = "LEED-CM"
         data_dict["state"] = "22"
         data_dict["street"] = "D2, West wood apartments"
         data_dict["unitType"] = "IP"
         data_dict["zip_code"] = "600032"*/
        
        // Do any additional setup after loading the view.
        
        tempdata_dict = NSMutableDictionary.init(dictionary: data_dict)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlearr.count
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

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "manageprojcell")! as! manageprojcell
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.textLabel?.text = titlearr.object(at: indexPath.row) as! String
        if(indexPath.row == 0){
            if(data_dict["name"] == nil || data_dict["name"] is NSNull){
                cell.detailTextLabel?.text = ""
            }else{
                cell.detailTextLabel?.text = "\(data_dict["name"] as! String)"
                
            }
        }else if(indexPath.row == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "segmentcell")! as! segmentcell
            cell.textLabel?.text = titlearr.object(at: indexPath.row) as! String
            cell.segmentedctrl.tag = indexPath.row
            cell.segmentedctrl.removeAllSegments()
            cell.selectionStyle = .none
            cell.textLabel?.font = UIFont.init(name: "OpenSans", size: 15)
            cell.segmentedctrl.insertSegment(withTitle: "IP", at: 0, animated: true)
            cell.segmentedctrl.insertSegment(withTitle: "SI", at: 1, animated: true)
            cell.segmentedctrl.addTarget(self, action: #selector(self.segmentchange(_:)), for: UIControlEvents.valueChanged)
            cell.segmentedctrl.selectedSegmentIndex = 0
            return cell
        }
        else if(indexPath.row == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: "segmentcell")! as! segmentcell
            cell.textLabel?.text = titlearr.object(at: indexPath.row) as! String
            cell.segmentedctrl.tag = indexPath.row
            cell.selectionStyle = .none
            cell.segmentedctrl.removeAllSegments()
            cell.textLabel?.font = UIFont.init(name: "OpenSans", size: 15)
            cell.segmentedctrl.insertSegment(withTitle: "LEED for \(t )", at: 0, animated: true)
            cell.segmentedctrl.insertSegment(withTitle: "Other", at: 1, animated: true)
            cell.segmentedctrl.insertSegment(withTitle: "None", at: 2, animated: true)
            cell.segmentedctrl.addTarget(self, action: #selector(self.segmentchange(_:)), for: UIControlEvents.valueChanged)
            cell.segmentedctrl.selectedSegmentIndex = 0
            return cell
        }
        else if(indexPath.row == 3){
            if(data_dict["ownerType"] == nil || data_dict["ownerType"] is NSNull){
                cell.detailTextLabel?.text = ""
            }else{
                cell.detailTextLabel?.text = "\(data_dict["ownerType"] as! String)"
            }
        }
        else if(indexPath.row == 4){
            cell.accessoryType = .none
            cell.selectionStyle = .none
            if(data_dict["organization"] == nil || data_dict["organization"] is NSNull){
                cell.detailTextLabel?.text = ""
            }else{
                cell.detailTextLabel?.text = "\(data_dict["organization"] as! String)"
            }
        }
        else if(indexPath.row == 5){
            cell.accessoryType = .none
            cell.selectionStyle = .none
            if(data_dict["owner_email"] == nil || data_dict["owner_email"] is NSNull){
                cell.detailTextLabel?.text = ""
            }else{
                
                cell.detailTextLabel?.text = "\(data_dict["owner_email"] as! String)"
            }
        }
        else if(indexPath.row == 6){
            cell.accessoryType = .none
            cell.selectionStyle = .none
            if(data_dict["country"] == nil || data_dict["country"] is NSNull){
                cell.detailTextLabel?.text = self.country
            }else{
                cell.detailTextLabel?.text = self.country
            }
            
        }
        else if(indexPath.row == 7){
            if(data_dict["gross_area"] == nil || data_dict["gross_area"] is NSNull){
                cell.detailTextLabel?.text = ""
            }else{
                if(data_dict["gross_area"] is String){
                    cell.detailTextLabel?.text = "\(data_dict["gross_area"] as! String)"
                }else{
                    cell.detailTextLabel?.text = "\(data_dict["gross_area"] as! Int)"
                }
            }
            
        }
        else if(indexPath.row == 8){
            let cell = tableView.dequeueReusableCell(withIdentifier: "manageprojcellwithswitch")! as! manageprojcellwithswitch
            cell.textLabel?.text = titlearr.object(at: indexPath.row) as? String
            cell.lbl.text = ""
            cell.textLabel?.font = UIFont.init(name: "OpenSans", size: 15)
            if(data_dict["confidential"] == nil || data_dict["confidential"] is NSNull){
                cell.yesorno.isOn = false
            }else{
                cell.yesorno.isOn = data_dict["confidential"] as! Bool
            }
            cell.yesorno.tag = indexPath.row
            cell.yesorno.addTarget(self, action: #selector(self.changevalue(_:)), for: UIControlEvents.valueChanged)
            return cell
        }
        else if(indexPath.row == 9){
            if(data_dict["occupancy"] == nil || data_dict["occupancy"] is NSNull){
                cell.detailTextLabel?.text = ""
            }else{
                if(data_dict["occupancy"] is String){
                    cell.detailTextLabel?.text = "\(data_dict["occupancy"] as! String)"
                }else{
                    cell.detailTextLabel?.text = "\(data_dict["occupancy"] as! Int)"
                }
            }
        }
        else if(indexPath.row == 10){
            cell.accessoryType = .none
            if(data_dict["street"] == nil || data_dict["street"] is NSNull){
                cell.detailTextLabel?.text = ""
            }else{
                cell.detailTextLabel?.text = "\(data_dict["street"] as! String)"
            }
            
        }
        else if(indexPath.row == 11){
            cell.accessoryType = .none
            if(data_dict["city"] == nil || data_dict["city"] is NSNull){
                cell.detailTextLabel?.text = ""
            }else{
                cell.detailTextLabel?.text = "\(data_dict["city"] as! String)"
            }
            
        }else if(indexPath.row == 12){
            cell.accessoryType = .none
            if(data_dict["state"] == nil || data_dict["state"] is NSNull){
                cell.detailTextLabel?.text = self.state
            }else{
                cell.detailTextLabel?.text = self.state
            }
            
        }
        else if(indexPath.row == 13){
            cell.accessoryType = .none
            if(data_dict["country"] == nil || data_dict["country"] is NSNull){
                cell.detailTextLabel?.text = self.country
            }else{
                cell.detailTextLabel?.text = self.country
            }
            
        }else if(indexPath.row == 14){
            if(data_dict["zip_code"] == nil || data_dict["zip_code"] is NSNull){
                cell.detailTextLabel?.text = ""
            }else{
                cell.detailTextLabel?.text = "\(data_dict["zip_code"] as! String)"
            }
            
        }else if(indexPath.row == 15){
            if(data_dict["year_constructed"] == nil || data_dict["year_constructed"] is NSNull){
                cell.detailTextLabel?.text = ""
            }else{
                cell.detailTextLabel?.text = "\(data_dict["year_constructed"] as! String)"
            }
        }
        else if(indexPath.row == 16){
            if(data_dict["populationDayTime"] == nil || data_dict["populationDayTime"] is NSNull){
                cell.detailTextLabel?.text = ""
            }else{
                cell.detailTextLabel?.text = "\(data_dict["populationDayTime"] as! String)"
            }
        }else if(indexPath.row == 17){
            if(data_dict["populationNightTime"] == nil || data_dict["populationNightTime"] is NSNull){
                cell.detailTextLabel?.text = ""
            }else{
                cell.detailTextLabel?.text = "\(data_dict["populationNightTime"] as! String)"
            }
        }else if(indexPath.row == 18){
            if(data_dict["manageEntityName"] == nil || data_dict["manageEntityName"] is NSNull){
                cell.detailTextLabel?.text = ""
            }else{
                cell.detailTextLabel?.text = "\(data_dict["manageEntityName"] as! String)"
            }
        }
        else if(indexPath.row == 19){
            if(data_dict["manageEntityAdd1"] == nil || data_dict["manageEntityAdd1"] is NSNull){
                cell.detailTextLabel?.text = ""
            }else{
                cell.detailTextLabel?.text = "\(data_dict["manageEntityAdd1"] as! String)"
            }
        }
        else if(indexPath.row == 20){
            if(data_dict["managEntityAdd2"] == nil || data_dict["managEntityAdd2"] is NSNull){
                cell.detailTextLabel?.text = ""
            }else{
                cell.detailTextLabel?.text = "\(data_dict["managEntityAdd2"] as! String)"
            }
        }
        else if(indexPath.row == 21){
            if(data_dict["manageEntityCity"] == nil || data_dict["manageEntityCity"] is NSNull){
                cell.detailTextLabel?.text = ""
            }else{
                cell.detailTextLabel?.text = "\(data_dict["manageEntityCity"] as! String)"
            }
        }else if(indexPath.row == 22){
            if(data_dict["manageEntityState"] == nil || data_dict["manageEntityState"] is NSNull){
                cell.detailTextLabel?.text = self.managestate
            }else{
                cell.detailTextLabel?.text = self.managestate
            }
        }
        else if(indexPath.row == 23){
            if(data_dict["manageEntityCountry"] == nil || data_dict["manageEntityCountry"] is NSNull){
                cell.detailTextLabel?.text = self.managecountry
            }else{
                cell.detailTextLabel?.text = self.managecountry
                
            }
        }
        else if(indexPath.row == 24){
            
           let cell = tableView.dequeueReusableCell(withIdentifier: "manageprojcellwithswitch")! as! manageprojcellwithswitch
            cell.textLabel?.text = titlearr.object(at: indexPath.row) as? String
            cell.lbl.text = ""
            cell.textLabel?.font = UIFont.init(name: "OpenSans", size: 15)
            if(data_dict["intentToPrecertify"] == nil || data_dict["intentToPrecertify"] is NSNull){
                cell.yesorno.isOn = false
            }else{
                cell.yesorno.isOn = data_dict["intentToPrecertify"] as! Bool
            }
            cell.yesorno.tag = indexPath.row
            cell.yesorno.addTarget(self, action: #selector(self.changevalue(_:)), for: UIControlEvents.valueChanged)
            return cell
            
        }else if(indexPath.row == 25){
            
            //intentToPrecertify   switch
            if(data_dict["targetCertDate"] == nil || data_dict["targetCertDate"] is NSNull){
                cell.detailTextLabel?.text = ""
            }else{
                cell.detailTextLabel?.text = "\(data_dict["targetCertDate"] as! String)"
            }
        }
        
        
        return cell
        
    }
    
    func changevalue(_ sender: UISwitch){
        if(sender.tag == 8){
            data_dict["confidential"] = sender.isOn
        }else if(sender.tag == 24){
            data_dict["intentToPrecertify"] = sender.isOn
        }
        if(self.tempdata_dict == self.data_dict){
            self.savebtn.isEnabled = false
            self.savebtn.backgroundColor = UIColor.gray
        }else{
            self.savebtn.isEnabled = true
            self.savebtn.backgroundColor = bgcolor
        }
    }
    
    func updateproject(){
        let url = URL.init(string:String(format: "%@assets/LEED:%d/",credentials().domain_url,data_dict["leed_id"] as! Int))
        ////print(url?.absoluteURL)
        var token = UserDefaults.standard.object(forKey: "token") as! String
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(session)
        var task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            } else
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                    DispatchQueue.main.async(execute: {
                        self.spinner.isHidden = true
                        self.view.isUserInteractionEnabled = true
                    })
                }else{
                    
                    var jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        //print(jsonDictionary)
                        var datakeyed = NSKeyedArchiver.archivedData(withRootObject: jsonDictionary)
                        UserDefaults.standard.set(datakeyed, forKey: "building_details")
                        UserDefaults.standard.synchronize()
                        UserDefaults.standard.set(0, forKey: "row")
                        DispatchQueue.main.async(execute: {
                            self.spinner.isHidden = true
                            self.view.isUserInteractionEnabled = true
                            self.data_dict =  NSMutableDictionary.init(dictionary: (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary)
                            self.tempdata_dict = NSMutableDictionary.init(dictionary: self.data_dict)
                            if(self.tempdata_dict == self.data_dict){
                                self.savebtn.isEnabled = false
                                self.savebtn.backgroundColor = UIColor.gray
                            }else{
                                self.savebtn.isEnabled = true
                                self.savebtn.backgroundColor = self.bgcolor
                            }
                            self.tableview.reloadData()
                            //self.navigationController?.popViewControllerAnimated(true)
                        })
                        
                        // self.buildingactions(subscription_key, leedid: leedid)
                    } catch {
                        //print(error)
                        DispatchQueue.main.async(execute: {
                            self.spinner.isHidden = true
                            self.view.isUserInteractionEnabled = true
                        })
                    }
            }
            
        }) 
        task.resume()
        
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "project"
        }
        
        return ""
    }
    
    func segmentchange(_ sender : UISegmentedControl){
        if(sender.tag == 1){
            data_dict["unitType"] = sender.titleForSegment(at: sender.selectedSegmentIndex)! as? String
        }else if(sender.tag == 2){
            if(sender.titleForSegment(at: sender.selectedSegmentIndex)! as? String == "LEED for cities"){
                data_dict["rating_system"] = "LEED-CT"
            }else if(sender.titleForSegment(at: sender.selectedSegmentIndex)! as? String == "LEED for communities"){
                data_dict["rating_system"] = "LEED-CM"
            }else{
                data_dict["rating_system"] = (sender.titleForSegment(at: sender.selectedSegmentIndex)! as? String)?.lowercased()
            }
            
        }
        if(self.tempdata_dict == self.data_dict){
            self.savebtn.isEnabled = false
            self.savebtn.backgroundColor = UIColor.gray
        }else{
            self.savebtn.isEnabled = true
            self.savebtn.backgroundColor = bgcolor
        }
    }
    
    //assets/LEED:1000122768/?recompute_score=1
    
    @IBOutlet weak var tabbar: UITabBar!
    @IBAction func submit(_ sender: AnyObject) {
        if((data_dict["name"] != nil || (data_dict["name"] as? String)?.characters.count > 0) && (data_dict["rating_system"] != nil || (data_dict["rating_system"] as? String)?.characters.count > 0) && (data_dict["unitType"] != nil || (data_dict["unitType"] as? String)?.characters.count > 0) && (data_dict["organization"] != nil || (data_dict["organization"] as? String)?.characters.count > 0) && (data_dict["owner_email"] != nil || (data_dict["owner_email"] as? String)?.characters.count > 0) && (data_dict["country"] != nil || (data_dict["country"] as? String)?.characters.count > 0) && (data_dict["gross_area"] != nil || (data_dict["gross_area"] as? String)?.characters.count > 0) && (data_dict["confidential"] != nil || (data_dict["confidential"] as? String)?.characters.count > 0) && (data_dict["occupancy"] != nil || (data_dict["occupancy"] as? String)?.characters.count > 0) && (data_dict["street"] != nil || (data_dict["street"] as? String)?.characters.count > 0) && (data_dict["city"] != nil || (data_dict["city"] as? String)?.characters.count > 0) && (data_dict["zip_code"] != nil || (data_dict["zip_code"] as? String)?.characters.count > 0)){
            
            DispatchQueue.main.async(execute: {
                self.spinner.isHidden = false
                self.savebuilding()
            })
        }else{
            
            //print("Missing fields")
            let temparr = NSMutableArray()
            if(data_dict["name"] == nil || (data_dict["name"] as? String)?.characters.count == 0){
                temparr.add("Name")
            }
            if(data_dict["rating_system"] == nil || (data_dict["rating_system"] as? String)?.characters.count == 0){
                temparr.add("Rating system")
            }
            if(data_dict["unitType"] == nil || (data_dict["unitType"] as? String)?.characters.count == 0){
                temparr.add("Unit Type")
            }
            if(data_dict["organization"] == nil || (data_dict["organization"] as? String)?.characters.count == 0){
                temparr.add("Organization")
            }
            if(data_dict["owner_email"] == nil || (data_dict["owner_email"] as? String)?.characters.count == 0){
                temparr.add("Owner email")
            }
            if(data_dict["country"] == nil || (data_dict["country"] as? String)?.characters.count == 0){
                temparr.add("Country")
            }
            if(data_dict["gross_area"] == nil || (data_dict["gross_area"] as? String)?.characters.count == 0){
                temparr.add("Area")
            }
            if(data_dict["confidential"] == nil || (data_dict["confidential"] as? String)?.characters.count == 0){
                temparr.add("Project private")
            }
            
            if(data_dict["occupancy"] == nil || (data_dict["occupancy"] as? String)?.characters.count == 0){
                temparr.add("Population")
            }
            if(data_dict["street"] == nil || (data_dict["street"] as? String)?.characters.count == 0){
                temparr.add("Address")
            }
            
            if(data_dict["city"] == nil || (data_dict["city"] as? String)?.characters.count == 0){
                temparr.add("City")
            }
            
            if(data_dict["zip_code"] == nil || (data_dict["zip_code"] as? String)?.characters.count == 0){
                temparr.add("Zip Code")
            }
            
            
            let string = temparr.componentsJoined(by: "\n")
            //print(string)
            let alert = UIAlertController(title: "Required fields are found empty", message: "Please kindly fill out the below fields :- \n \(string)", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            alert.view.subviews.first?.backgroundColor = UIColor.white
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(section == 0){
            return 30
        }
        
        return 12
    }
    
    func savebuilding(){
        var payload = NSMutableString()
        payload.append("{")
        
        
        for (key, value) in data_dict {
            if(value is String){
                payload.append("\"\(key)\": \"\(value)\",")
            }else if(value is Int){
                payload.append("\"\(key)\": \(value),")
            }
        }
        var str = payload as String
        payload.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
        payload.append("}")
        str = payload as String
        print(str)
        
        
        let url = URL.init(string:String(format: "%@assets/LEED:%d/",credentials().domain_url,data_dict["leed_id"] as! Int))
        ////print(url?.absoluteURL)
        var subscription_key = credentials().subscription_key
        var token = UserDefaults.standard.object(forKey: "token") as! String
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "PUT"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        
        var data = NSMutableDictionary()
        data = self.convertStringToDictionary(str)! as! NSMutableDictionary
        do {
            var postdata = try JSONSerialization.data(withJSONObject: data, options:  JSONSerialization.WritingOptions(rawValue:0))
            
            request.httpBody = postdata
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
        let session = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(session)
        var task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                DispatchQueue.main.async(execute: {
                      self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            } else
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                    DispatchQueue.main.async(execute: {
                        //   self.spinner.hidden = true
                        var jsonDictionary : NSDictionary
                        do {
                            jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                            //print(jsonDictionary)
                            //self.tableview.reloadData()
                            // self.buildingactions(subscription_key, leedid: leedid)
                            DispatchQueue.main.async(execute: {
                                self.maketoast("Updated successfully", type: "message")
                                      self.updateproject()
                            })
                        } catch {
                            //print(error)
                        }
                        self.view.isUserInteractionEnabled = true
                    })
                }else{
                    
                    var jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        //print(jsonDictionary)
                        //self.tableview.reloadData()
                        // self.buildingactions(subscription_key, leedid: leedid)
                        DispatchQueue.main.async(execute: {
                            self.maketoast("Updated successfully", type: "message")
                                  self.updateproject()
                        })
                    } catch {
                        //print(error)
                    }
            }
            
        }) 
        task.resume()
        
    }
    
    func convertStringToDictionary(_ text: String) -> NSMutableDictionary? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                let json = (try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                return json
            } catch {
                //print("Something went wrong")
            }
        }
        return nil
    }
    
    func showalert(_ message:String, title:String, action:String){
        
        //let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        //let callActionHandler = { (action:UIAlertAction!) -> Void in
        DispatchQueue.main.async(execute: {
            self.view.isUserInteractionEnabled = true
            //self.spinner.hidden = true
            self.view.isUserInteractionEnabled = true
            self.maketoast(message, type: "error")
            //self.navigationController?.popViewControllerAnimated(true)
        })
        
        //        }
        //      let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        //    alertController.addAction(defaultAction)
        
        //presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    var name = ""
    var currentcontext = ""
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async(execute: {
            //dateview.hidden = false
            self.selected_index = indexPath.row
            if(indexPath.row == 0){
                let cell = self.tableview.cellForRow(at: indexPath)! as! manageprojcell
                /*if(cell.detailTextLabel?.text != ""){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }*/
                self.name = (cell.detailTextLabel?.text)!
                self.currentcontext = (cell.textLabel?.text)!
                self.performSegue(withIdentifier: "gotoname", sender: nil)
            }else if(indexPath.row == 1){
                
            }else if(indexPath.row == 2){
                
            }else if(indexPath.row == 3){
                self.performSegue(withIdentifier: "gotochoose", sender: nil)
            }else if(indexPath.row == 4){
                
                /*if(cell.detailTextLabel?.text != ""){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }*/
                
                //self.performSegue(withIdentifier: "gotoname", sender: nil)
            }else if(indexPath.row == 5){
                
            }else if(indexPath.row == 6){
                
            }else if(indexPath.row == 7){
                let cell = self.tableview.cellForRow(at: indexPath)! as! manageprojcell
                /*if(cell.detailTextLabel?.text != ""){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }*/
                self.name = (cell.detailTextLabel?.text)!
                self.currentcontext = (cell.textLabel?.text)!
                self.performSegue(withIdentifier: "gotoname", sender: nil)
            }else if(indexPath.row == 8){
                
            }else if(indexPath.row == 9){
                let cell = self.tableview.cellForRow(at: indexPath)! as! manageprojcell
                /*if(cell.detailTextLabel?.text != ""){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }*/
                self.name = (cell.detailTextLabel?.text)!
                self.currentcontext = (cell.textLabel?.text)!
                self.performSegue(withIdentifier: "gotoname", sender: nil)
            }else if(indexPath.row == 10){
                
                self.performSegue(withIdentifier: "gotoname", sender: nil)
            }else if(indexPath.row == 11){
                
            }else if(indexPath.row == 12){
                
            }else if(indexPath.row == 13){
                
            }else if(indexPath.row == 14){
                let cell = self.tableview.cellForRow(at: indexPath)! as! manageprojcell
                /*if(cell.detailTextLabel?.text != ""){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }*/
                self.name = (cell.detailTextLabel?.text)!
                self.currentcontext = (cell.textLabel?.text)!
                self.performSegue(withIdentifier: "gotoname", sender: nil)
            }else if(indexPath.row == 15){
                let cell = self.tableview.cellForRow(at: indexPath)! as! manageprojcell
                /*if(cell.detailTextLabel?.text != ""){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }*/
                self.name = (cell.detailTextLabel?.text)!
                self.currentcontext = (cell.textLabel?.text)!
                self.performSegue(withIdentifier: "gotoname", sender: nil)
            }
            else if(indexPath.row == 16){
                let cell = self.tableview.cellForRow(at: indexPath)! as! manageprojcell
                /*if(cell.detailTextLabel?.text != ""){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }*/
                self.name = (cell.detailTextLabel?.text)!
                self.currentcontext = (cell.textLabel?.text)!
                self.performSegue(withIdentifier: "gotoname", sender: nil)
            }else if(indexPath.row == 17){
                let cell = self.tableview.cellForRow(at: indexPath)! as! manageprojcell
                /*if(cell.detailTextLabel?.text != ""){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }*/
                self.name = (cell.detailTextLabel?.text)!
                self.currentcontext = (cell.textLabel?.text)!
                self.performSegue(withIdentifier: "gotoname", sender: nil)
            }else if(indexPath.row == 18){
                let cell = self.tableview.cellForRow(at: indexPath)! as! manageprojcell
                /*if(cell.detailTextLabel?.text != ""){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }*/
                self.name = (cell.detailTextLabel?.text)!
                self.currentcontext = (cell.textLabel?.text)!
                self.performSegue(withIdentifier: "gotoname", sender: nil)
            }
            else if(indexPath.row == 19){
                let cell = self.tableview.cellForRow(at: indexPath)! as! manageprojcell
                /*if(cell.detailTextLabel?.text != ""){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }*/
                self.name = (cell.detailTextLabel?.text)!
                self.currentcontext = (cell.textLabel?.text)!
                self.performSegue(withIdentifier: "gotoname", sender: nil)
            }
            else if(indexPath.row == 20){
                let cell = self.tableview.cellForRow(at: indexPath)! as! manageprojcell
                /*if(cell.detailTextLabel?.text != ""){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }*/
                self.name = (cell.detailTextLabel?.text)!
                self.currentcontext = (cell.textLabel?.text)!
                self.performSegue(withIdentifier: "gotoname", sender: nil)
            }
            else if(indexPath.row == 21){
                let cell = self.tableview.cellForRow(at: indexPath)! as! manageprojcell
                /*if(cell.detailTextLabel?.text != ""){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }*/
                self.name = (cell.detailTextLabel?.text)!
                self.currentcontext = (cell.textLabel?.text)!
                self.performSegue(withIdentifier: "gotoname", sender: nil)
            }else if(indexPath.row == 22){
                self.category = "states"
                let cell = self.tableview.cellForRow(at: NSIndexPath.init(row: 23, section: 0) as IndexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text?.characters.count == 0){
                    self.maketoast("Please select country first", type: "error")
                }else{
                self.performSegue(withIdentifier: "gotochoosee", sender: nil)
                }
            }
            else if(indexPath.row == 23){
                self.category = "countries"
                self.performSegue(withIdentifier: "gotochoosee", sender: nil)
            }
            else if(indexPath.row == 24){
                
            }else if(indexPath.row == 25){
            let cell = self.tableview.cellForRow(at: indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != ""){
                    let str = cell.detailTextLabel?.text
                    let dateformatter = DateFormatter()
                    dateformatter.dateFormat = "yyyy-MM-dd"
                    let date = dateformatter.date(from: str!)! 
                    self.dpicker.setDate(date, animated: true)
                }else{
                    self.dpicker.date = Date()
                }
                self.dateview.isHidden = false
            //intentToPrecertify   switch
                
            }

            
            self.tableview.reloadData()
        })
    }
    
    weak var AddAlertSaveAction: UIAlertAction?
    var selected_index = 0
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "gotopickerview"){
            let dest = segue.destination as! pickerviewcontroller
            dest.indx = selected_index
        }else if(segue.identifier == "gotoname"){
            let dest = segue.destination as! nameeditforcity
            dest.data_dict = data_dict
            dest.currenttitle = currentcontext
            dest.name = name
        }else if(segue.identifier == "gotochoose"){
            let dest = segue.destination as! parkchoosefromlist
            dest.dict = data_dict
        }else if(segue.identifier == "gotochoosee"){
            let dest = segue.destination as! gotocountries
            dest.data_dict = data_dict
            dest.category = category
        }
    }
    var category = ""
    func configurationTextField(_ textField: UITextField!)
    {
        //print("configurat hire the TextField")
        
        if let tField = textField {
            tField.enablesReturnKeyAutomatically = true
            NotificationCenter.default.addObserver(self, selector: #selector(manageacity.handleTextFieldTextDidChangeNotification(_:)), name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
            //self.textField = textField!        //Save reference to the UITextField
            //self.textField.text = "Hello world"
        }
    }
    
    func handleTextFieldTextDidChangeNotification(_ notification: Notification) {
        let textField = notification.object as! UITextField
        
        // Enforce a minimum length of >= 1 for secure text alerts.
        AddAlertSaveAction!.isEnabled = textField.text?.characters.count >= 1
    }
    
    func handleCancel(_ alertView: UIAlertAction!, index: Int)
    {
        
    }
    
    func removeTextFieldObserver() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidChange, object: alert.textFields![0])
        alert.textFields![0].delegate = nil
    }
    var alert = UIAlertController()
    
    func showalert(_ index: Int, title : String, value : String){
        DispatchQueue.main.async(execute: {
            self.alert = UIAlertController(title: "", message: "Enter the \(title )", preferredStyle: UIAlertControllerStyle.alert)
            if(self.alert.textFields?.count > 0){
            let tfield = self.alert.textFields![0]
            tfield.delegate = self
            if(index == 0){
                self.type = "alphabet"
                tfield.keyboardType = UIKeyboardType.alphabet
            }
            else if(index == 3){
                self.type = "alphabet"
                tfield.keyboardType = UIKeyboardType.alphabet
            }else if(index == 4){
                self.type = "alphabet"
                tfield.keyboardType = UIKeyboardType.alphabet
            }
            else if(index == 5){
                self.type = ""
                tfield.keyboardType = UIKeyboardType.emailAddress
            }
            else if(index == 7){
                self.type = "float"
                tfield.keyboardType = UIKeyboardType.decimalPad
            }
            else if(index == 9){
                self.type = "number"
                tfield.keyboardType = UIKeyboardType.numberPad
            }
            else if(index == 10){
                self.type = "alphabet"
                tfield.keyboardType = UIKeyboardType.alphabet
            }else if(index == 11){
                self.type = "alphabet"
                tfield.keyboardType = UIKeyboardType.alphabet
            }else if(index == 14){
                self.type = "number"
                tfield.keyboardType = UIKeyboardType.numberPad
            }else if(index == 16){
                self.type = "number"
                tfield.keyboardType = UIKeyboardType.numberPad
            }else if(index == 17){
                self.type = "number"
                tfield.keyboardType = UIKeyboardType.numberPad
            }else if(index == 18){
                self.type = "alphabet"
                tfield.keyboardType = UIKeyboardType.alphabet
            }
            else if(index == 19){
                self.type = "alphabet"
                tfield.keyboardType = UIKeyboardType.alphabet
            }
            else if(index == 20){
                self.type = "alphabet"
                tfield.keyboardType = UIKeyboardType.alphabet
            }
            else if(index == 21){
                self.type = "alphabet"
                tfield.keyboardType = UIKeyboardType.alphabet
            }else if(index == 22){
                
            }
            else if(index == 23){
                
            }
            }

            
            self.alert.addTextField(configurationHandler: self.configurationTextField)
            let otherAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
                //print("User click Ok button")
                let txtfld = self.alert.textFields![0] 
                if(index == 0){
                    self.data_dict["name"] = txtfld.text
                }else if(index == 1){
                    self.data_dict["unitType"] = txtfld.text
                }else if(index == 2){
                    self.data_dict["rating_system"] = txtfld.text
                }
                else if(index == 3){
                    self.data_dict["ownerType"] = txtfld.text
                }
                else if(index == 4){
                    self.data_dict["organization"] = txtfld.text
                }
                else if(index == 5){
                    self.data_dict["owner_email"] = txtfld.text
                }
                else if(index == 6){
                    self.data_dict["country"] = txtfld.text
                }
                else if(index == 7){
                    self.data_dict["gross_area"] = txtfld.text
                }
                else if(index == 8){
                    
                }
                else if(index == 9){
                    self.data_dict["occupancy"] = txtfld.text
                }
                else if(index == 10){
                    self.data_dict["street"] = txtfld.text
                }
                else if(index == 11){
                    self.data_dict["city"] = txtfld.text
                }
                else if(index == 12){
                    self.data_dict["state"] = txtfld.text
                }else if(index == 13){
                    self.data_dict["country"] = txtfld.text
                }else if(index == 14){
                    self.data_dict["zip_code"] = txtfld.text
                }else if(index == 15){
                    self.data_dict["year_constructed"] = txtfld.text
                }
                else if(index == 16){
                    self.data_dict["populationDayTime"] = txtfld.text
                }else if(index == 17){
                    self.data_dict["populationNightTime"] = txtfld.text
                }else if(index == 18){
                   self.data_dict["manageEntityName"] = txtfld.text
                }
                else if(index == 19){
                    self.data_dict["manageEntityAdd1"] = txtfld.text
                }
                else if(index == 20){
                    self.data_dict["managEntityAdd2"] = txtfld.text
                }
                else if(index == 21){
                    self.data_dict["manageEntityCity"] = txtfld.text
                }else if(index == 22){
                    self.data_dict["manageEntityState"] = txtfld.text
                }
                else if(index == 23){
                    self.data_dict["manageEntityCountry"] = txtfld.text
                }
               
                
                
                self.tableview.reloadData()
                ////print(self.textField.text)
            })
            otherAction.isEnabled = false
            
            // save the other action to toggle the enabled/disabled state when the text changed.
            self.AddAlertSaveAction = otherAction
            
            
            
            self.alert.addAction(UIAlertAction(title: "cancel", style: UIAlertActionStyle.cancel, handler:{ (UIAlertAction)in
                
            }))
            self.alert.addAction(otherAction)
            self.alert.textFields![0].text = value
            self.alert.view.subviews.first?.backgroundColor = UIColor.white
        self.alert.view.layer.cornerRadius = 10
        self.alert.view.layer.masksToBounds = true
            self.present(self.alert, animated: true, completion: {
                //print("completion block")
            })
        })
    }
    
    @IBOutlet weak var dpicker: UIDatePicker!
    @IBOutlet weak var spinner: UIView!
    var bgcolor = UIColor()
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = data_dict["name"] as? String
        
        var countries = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "countries") as! Data) as! NSDictionary
        
        if(self.tempdata_dict == self.data_dict){
            self.savebtn.isEnabled = false
            self.savebtn.backgroundColor = UIColor.gray
        }else{
            self.savebtn.isEnabled = true
            self.savebtn.backgroundColor = bgcolor
        }
        self.navigationController?.navigationBar.backItem?.title = "More"
        
        countries = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "countries") as! Data) as! NSDictionary
        var d = countries["countries"] as! NSDictionary
        var current_country = ""
        if(data_dict["manageEntityCountry"] is NSNull || data_dict["manageEntityCountry"] == nil){
            
        }else{
        for (key,value) in d {
            let s = key as! String
            if(s == data_dict["manageEntityCountry"] as! String){
                managecountry = value as! String
                current_country = key as! String
                break
            }
        }
        }
        managestate = ""
        d = countries["divisions"] as! NSDictionary
        
        if(d[current_country] != nil){
            if(data_dict["manageEntityState"] is NSNull || data_dict["manageEntityState"] == nil){
                
            }else{
        d = d[current_country] as! NSDictionary
        for (key,value) in d {
            let s = key as! String
            if(s == data_dict["manageEntityState"] as! String){
                managestate = value as! String
                break
            }
        }
            }
        }
        tableview.reloadData()
    }
    @IBOutlet weak var savebtn: UIButton!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func datedone(_ sender: AnyObject) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        let date = dateformatter.string(from: dpicker.date) 
        data_dict["targetCertDate"] = date
        dateview.isHidden = true
        if(self.tempdata_dict == self.data_dict){
            self.savebtn.isEnabled = false
            self.savebtn.backgroundColor = UIColor.gray
        }else{
            self.savebtn.isEnabled = true
            self.savebtn.backgroundColor = bgcolor
        }
        tableview.reloadData()
    }
    var inputtype = ""
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var set = CharacterSet()
        if(type == ""){
            return true
        }else if(type == "alphabet"){
            set = CharacterSet(charactersIn: "ABCDEFGHIJKLMONPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 ").inverted
        }else if(type == "number"){
            set = CharacterSet(charactersIn: "0123456789").inverted
        }else if(type == "float"){
            set = CharacterSet(charactersIn: ".0123456789").inverted
        }
        
        return string.rangeOfCharacter(from: set) == nil
        
    }
    
    @IBAction func datechanged(_ sender: AnyObject) {
    }
    @IBAction func datecancel(_ sender: AnyObject) {
        dateview.isHidden = true
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
