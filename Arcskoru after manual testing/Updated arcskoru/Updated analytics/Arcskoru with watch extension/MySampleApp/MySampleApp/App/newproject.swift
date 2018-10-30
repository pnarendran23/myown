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


class newproject: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    var building_dict = NSMutableDictionary()//NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSMutableDictionary
    @IBOutlet weak var tableview: UITableView!
    var type = ""
    var s = ""
    var t = ""
    var titlearr = NSMutableArray()
    var download_requests = [URLSession]()
    var task = URLSessionTask()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.layer.cornerRadius = 5
        self.spinner.isHidden = true
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
         "confidential": false,
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
        
        
        
        if(type == "building"){
            s = "building"
            t = "buildings"
        }else if(type == "parksmart"){
            s = "parksmart"
            t = "buildings"
        }else if(type == "transit"){
            s = "transit"
            t = "buildings"
        }
        tableview.register(UINib.init(nibName: "manageprojcellwithswitch", bundle: nil), forCellReuseIdentifier: "manageprojcellwithswitch")
        tableview.register(UINib.init(nibName: "segmentcell", bundle: nil), forCellReuseIdentifier: "segmentcell")
        tableview.register(UINib.init(nibName: "manageprojcell", bundle: nil), forCellReuseIdentifier: "manageprojcell")
        tableview.register(UINib.init(nibName: "textcell", bundle: nil), forCellReuseIdentifier: "textcell")
        titlearr = NSMutableArray()
        titlearr.add("Name")
        titlearr.add("Unit Type")
        //titlearr.addObject("Rating System")
        titlearr.add("Owner Type")
        titlearr.add("Owner Organization")
        titlearr.add("Owner Email")
        titlearr.add("Owner Country")
        titlearr.add("Area")
        titlearr.add("Keep project private")
        //titlearr.addObject("Population")
        titlearr.add("Address")
        titlearr.add("City")
        titlearr.add("State")
        titlearr.add("Country")
        titlearr.add("Zip Code")
        building_dict["unitType"] = "IP"
        if(type == "building"){
            building_dict["rating_system"] = "LEED V4 O+M: EB WP"
        }else if(type == "transit"){
            building_dict["rating_system"] = "LEED V4 O+M: TR"
        }else if(type == "parksmart"){
            building_dict["rating_system"] = "PARKSMART"
        }
        building_dict["confidential"] = false
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlearr.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "manageprojcell")! as! manageprojcell
        cell.textLabel?.text = titlearr.object(at: indexPath.row) as! String
        if(indexPath.row == 0){
            if(building_dict["name"] == nil || building_dict["name"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
                cell.detailTextLabel?.text = "\(building_dict["name"] as! String)"
                
            }
        }else if(indexPath.row == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "segmentcell")! as! segmentcell
            cell.textLabel?.text = titlearr.object(at: indexPath.row) as! String
            cell.segmentedctrl.tag = indexPath.row
            cell.segmentedctrl.removeAllSegments()
            cell.textLabel?.font = UIFont.init(name: "OpenSans", size: 15)
            cell.segmentedctrl.insertSegment(withTitle: "IP", at: 0, animated: true)
            cell.segmentedctrl.insertSegment(withTitle: "SI", at: 1, animated: true)
            UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).numberOfLines = 3
            let font = UIFont.init(name: "OpenSans", size: 10)
            cell.segmentedctrl.setTitleTextAttributes([NSFontAttributeName: font!],
                                                      for: UIControlState())
            cell.segmentedctrl.addTarget(self, action: #selector(self.segmentchange(_:)), for: UIControlEvents.valueChanged)
            cell.segmentedctrl.selectedSegmentIndex = 0
            
            return cell
        }
        else if(indexPath.row == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: "segmentcell")! as! segmentcell
            cell.textLabel?.text = titlearr.object(at: indexPath.row) as! String
            cell.segmentedctrl.tag = indexPath.row
            cell.segmentedctrl.removeAllSegments()
            cell.textLabel?.font = UIFont.init(name: "OpenSans", size: 15)
            if(type == "building"){
            cell.segmentedctrl.insertSegment(withTitle: "LEED", at: 0, animated: true)
            }else if(type == "parksmart"){
                cell.segmentedctrl.insertSegment(withTitle: "Parksmart", at: 0, animated: true)
            }else if(type == "transit"){
                cell.segmentedctrl.insertSegment(withTitle: "LEED for transit", at: 0, animated: true)
            }
            UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).numberOfLines = 3
            let font = UIFont.init(name: "OpenSans", size: 10)
            cell.segmentedctrl.setTitleTextAttributes([NSFontAttributeName: font!],
                                                      for: UIControlState())
            
            cell.segmentedctrl.addTarget(self, action: #selector(self.segmentchange(_:)), for: UIControlEvents.valueChanged)
            cell.segmentedctrl.selectedSegmentIndex = 0
            return cell
        }
        else if(indexPath.row == 2){
            
            if(building_dict["ownerType"] == nil || building_dict["ownerType"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
                cell.detailTextLabel?.text = "\(building_dict["ownerType"] as! String)"
            }
        }
        else if(indexPath.row == 3){
            
            if(building_dict["organization"] == nil || building_dict["organization"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
                cell.detailTextLabel?.text = "\(building_dict["organization"] as! String)"
            }
        }
        else if(indexPath.row == 4){
            if(building_dict["owner_email"] == nil || building_dict["owner_email"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
                
                cell.detailTextLabel?.text = "\(building_dict["owner_email"] as! String)"
            }
        }
        else if(indexPath.row == 5){
            
            if(building_dict["country"] == nil || building_dict["country"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
                cell.detailTextLabel?.text = "\(building_dict["country"] as! String)"
            }
            
        }
        else if(indexPath.row == 6){
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
        else if(indexPath.row == 7){
            let cell = tableView.dequeueReusableCell(withIdentifier: "manageprojcellwithswitch")! as! manageprojcellwithswitch
            cell.textLabel?.text = titlearr.object(at: indexPath.row) as? String
            cell.lbl.text = ""
            cell.textLabel?.font = UIFont.init(name: "OpenSans", size: 15)
            if(building_dict["confidential"] == nil || building_dict["confidential"] is NSNull){
                cell.yesorno.isOn = false
            }else{
                cell.yesorno.isOn = building_dict["confidential"] as! Bool
            }
            cell.yesorno.tag = indexPath.row
            cell.yesorno.addTarget(self, action: #selector(self.changevalue(_:)), for: UIControlEvents.valueChanged)
            return cell
        }
        /*else if(indexPath.row == 9){
            if(building_dict["occupancy"] == nil || building_dict["occupancy"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
                if(building_dict["occupancy"] is String){
                    cell.detailTextLabel?.text = "\(building_dict["occupancy"] as! String)"
                }else{
                    cell.detailTextLabel?.text = "\(building_dict["occupancy"] as! Int)"
                }
            }
        }*/
        else if(indexPath.row == 8){
            
            if(building_dict["street"] == nil || building_dict["street"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
                cell.detailTextLabel?.text = "\(building_dict["street"] as! String)"
            }
            
        }
        else if(indexPath.row == 9){
            
            if(building_dict["city"] == nil || building_dict["city"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
                cell.detailTextLabel?.text = "\(building_dict["city"] as! String)"
            }
            
        }else if(indexPath.row == 10){
            
            if(building_dict["state"] == nil || building_dict["state"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
                cell.detailTextLabel?.text = "\(building_dict["state"] as! String)"
            }
            
        }
        else if(indexPath.row == 11){
            
            if(building_dict["country"] == nil || building_dict["country"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
                cell.detailTextLabel?.text = "\(building_dict["country"] as! String)"
            }
            
        }else if(indexPath.row == 12){
            if(building_dict["zip_code"] == nil || building_dict["zip_code"] is NSNull){
                cell.detailTextLabel?.text = "Not available"
            }else{
                cell.detailTextLabel?.text = "\(building_dict["zip_code"] as! String)"
            }
            
        }else if(indexPath.row == 13){
            cell.detailTextLabel?.text = "NA"
        }
        return cell
        
    }
    
    func changevalue(_ sender: UISwitch){
        if(sender.tag == 7){
            building_dict["confidential"] = sender.isOn
        }
    }
    
    
    func segmentchange(_ sender : UISegmentedControl){
        if(sender.tag == 1){
            building_dict["unitType"] = sender.titleForSegment(at: sender.selectedSegmentIndex)! as? String
        }else if(sender.tag == 2){
            if(sender.titleForSegment(at: sender.selectedSegmentIndex)! as? String == "LEED"){
                building_dict["rating_system"] = "LEED V4 O+M: EB WP"
            }else if(sender.titleForSegment(at: sender.selectedSegmentIndex)! as? String == "LEED for transit"){
                building_dict["rating_system"] = "LEED V4 O+M: TR"
            }else if(sender.titleForSegment(at: sender.selectedSegmentIndex)! as? String == "Parksmart"){
                building_dict["rating_system"] = "PARKSMART"
            }else{
                building_dict["rating_system"] = (sender.titleForSegment(at: sender.selectedSegmentIndex)! as! String).lowercased()
            }
            
        }
    }
    
    @IBOutlet weak var spinner: UIView!
    @IBAction func submit(_ sender: AnyObject) {
        if((building_dict["name"] != nil || (building_dict["name"] as? String)?.characters.count > 0) && (building_dict["unitType"] != nil || (building_dict["unitType"] as? String)?.characters.count > 0) && (building_dict["organization"] != nil || (building_dict["organization"] as? String)?.characters.count > 0) && (building_dict["owner_email"] != nil || (building_dict["owner_email"] as? String)?.characters.count > 0) && (building_dict["country"] != nil || (building_dict["country"] as? String)?.characters.count > 0) && (building_dict["gross_area"] != nil || (building_dict["gross_area"] as? String)?.characters.count > 0) && (building_dict["confidential"] != nil || (building_dict["confidential"] as? String)?.characters.count > 0) && (building_dict["street"] != nil || (building_dict["street"] as? String)?.characters.count > 0) && (building_dict["city"] != nil || (building_dict["city"] as? String)?.characters.count > 0) && (building_dict["rating_system"] != nil || (building_dict["rating_system"] as? String)?.characters.count > 0) && (building_dict["zip_code"] != nil || (building_dict["zip_code"] as? String)?.characters.count > 0)){
            building_dict["manageEntityCountry"] = building_dict["country"]
            building_dict["project_type"] = s
            DispatchQueue.main.async(execute: {
                self.spinner.isHidden = false
                self.savebuilding()
            })
            
            
        }else{
            
            //print("Missing fields")
            let temparr = NSMutableArray()
            if(building_dict["name"] == nil || (building_dict["name"] as? String)?.characters.count == 0){
                temparr.add("Name")
            }
            if(building_dict["unitType"] == nil || (building_dict["unitType"] as? String)?.characters.count == 0){
                temparr.add("Unit Type")
            }
            if(building_dict["rating_system"] == nil || (building_dict["rating_system"] as? String)?.characters.count == 0){
                temparr.add("Rating system")
            }
            if(building_dict["organization"] == nil || (building_dict["organization"] as? String)?.characters.count == 0){
                temparr.add("Organization")
            }
            if(building_dict["owner_email"] == nil || (building_dict["owner_email"] as? String)?.characters.count == 0){
                temparr.add("Owner email")
            }
            if(building_dict["country"] == nil || (building_dict["country"] as? String)?.characters.count == 0){
                temparr.add("Country")
            }
            if(building_dict["gross_area"] == nil || (building_dict["gross_area"] as? String)?.characters.count == 0){
                temparr.add("Area")
            }
            if(building_dict["confidential"] == nil || (building_dict["confidential"] as? String)?.characters.count == 0){
                temparr.add("Project private")
            }
            if(building_dict["street"] == nil || (building_dict["street"] as? String)?.characters.count == 0){
                temparr.add("Address")
            }
            
            if(building_dict["city"] == nil || (building_dict["city"] as? String)?.characters.count == 0){
                temparr.add("City")
            }
            
            if(building_dict["zip_code"] == nil || (building_dict["zip_code"] as? String)?.characters.count == 0){
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
    
    func savebuilding(){
        var payload = NSMutableString()
        payload.append("{")
        
        
        for (key, value) in building_dict {
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
        //print(str)
        
        
        let url = URL.init(string:String(format: "%@assets/",credentials().domain_url))
        ////print(url?.absoluteURL)
        var subscription_key = credentials().subscription_key
        var token = UserDefaults.standard.object(forKey: "token") as! String
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "POST"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        
        var data = NSMutableDictionary()
        data = self.convertStringToDictionary(str)!
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
                    //  self.spinner.hidden = true
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
                                //      self.updateproject()
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
                            self.maketoast("Project created successfully", type: "message")
                            self.navigationController?.popViewController(animated: true)
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async(execute: {
            //dateview.hidden = false
            
            if(indexPath.row == 0){
                let cell = self.tableview.cellForRow(at: indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != "Not available"){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }else if(indexPath.row == 1){
                
            }else if(indexPath.row == 2){
                let cell = self.tableview.cellForRow(at: indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != "Not available"){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }else if(indexPath.row == 3){
                let cell = self.tableview.cellForRow(at: indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != "Not available"){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }else if(indexPath.row == 4){
                let cell = self.tableview.cellForRow(at: indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != "Not available"){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }else if(indexPath.row == 5){
                self.performSegue(withIdentifier: "gotopickerview", sender: nil)
                
            }else if(indexPath.row == 6){
                let cell = self.tableview.cellForRow(at: indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != "Not available"){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }else if(indexPath.row == 7){
                
            }else if(indexPath.row == 8){
                let cell = self.tableview.cellForRow(at: indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != "Not available"){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }else if(indexPath.row == 9){
                let cell = self.tableview.cellForRow(at: indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != "Not available"){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }else if(indexPath.row == 10){
                self.performSegue(withIdentifier: "gotopickerview", sender: nil)
                /*let cell = self.tableview.cellForRowAtIndexPath(indexPath)! as! manageprojcell
                 if(cell.detailTextLabel?.text != "Not available"){
                 self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                 }else{
                 self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                 }*/
            }else if(indexPath.row == 11){
                self.performSegue(withIdentifier: "gotopickerview", sender: nil)
            }else if(indexPath.row == 12){
                let cell = self.tableview.cellForRow(at: indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != "Not available"){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }else if(indexPath.row == 13){
                let cell = self.tableview.cellForRow(at: indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != "Not available"){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }else if(indexPath.row == 14){
                let cell = self.tableview.cellForRow(at: indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != "Not available"){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }else if(indexPath.row == 15){
                let cell = self.tableview.cellForRow(at: indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != "Not available"){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }else if(indexPath.row == 16){
                let cell = tableView.dequeueReusableCell(withIdentifier: "textcell")! as! textcell
                cell.tview.text = "projectInfo"
                cell.textLabel?.numberOfLines = 3
                //return cell
            }
            
            self.tableview.reloadData()
        })
    }
    
    weak var AddAlertSaveAction: UIAlertAction?
    
    func configurationTextField(_ textField: UITextField!)
    {
        //print("configurat hire the TextField")
        
        if let tField = textField {
            tField.enablesReturnKeyAutomatically = true
            NotificationCenter.default.addObserver(self, selector: #selector(newproject.handleTextFieldTextDidChangeNotification(_:)), name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
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
    
    var inputtype = ""
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(string == ""){
            return true
        }
        var set = CharacterSet()
        if(type == ""){
            set = CharacterSet(charactersIn: " ").inverted
        }else if(type == "alphabet"){
            set = CharacterSet(charactersIn: "0123456789,.!@#$%^&*()~`<?:;{}[]'/|-_+=\"").inverted
        }else if(type == "number"){
            set = CharacterSet(charactersIn: "ABCDEFGHIJKLMONPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz,.;!@#$%^&*()~`</'-_?:+={}[]|\"").inverted
        }else if(type == "float"){
            set = CharacterSet(charactersIn: "ABCDEFGHIJKLMONPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz,!@#$%^&*()~`</'?+=:{}[]|\"").inverted
        }
        
        return string.rangeOfCharacter(from: set) != nil
        
    }
    
    
    func showalert(_ index: Int, title : String, value : String){
        DispatchQueue.main.async(execute: {
            self.alert = UIAlertController(title: "", message: "Enter the \(title )", preferredStyle: UIAlertControllerStyle.alert)
            self.alert.addTextField(configurationHandler: self.configurationTextField)
            let tfield = self.alert.textFields![0]
            tfield.delegate = self
            if(index == 0){
                self.type = "alphabet"
                tfield.keyboardType = UIKeyboardType.alphabet
            }
            else if(index == 2){
                self.type = "alphabet"
                tfield.keyboardType = UIKeyboardType.alphabet
            }
            else if(index == 3){
                self.type = "alphabet"
                tfield.keyboardType = UIKeyboardType.alphabet
            }
            else if(index == 4){
                self.type = ""
                tfield.keyboardType = UIKeyboardType.emailAddress
            }
            else if(index == 6){
                self.type = "float"
                tfield.keyboardType = UIKeyboardType.decimalPad
            }
            else if(index == 8){
                self.type = "alphabet"
                tfield.keyboardType = UIKeyboardType.alphabet
            }
            else if(index == 9){
                self.type = "alphabet"
                tfield.keyboardType = UIKeyboardType.alphabet
            }else if(index == 12){
                self.type = "number"
                tfield.keyboardType = UIKeyboardType.numberPad
            }

            
            
            let otherAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
                //print("User click Ok button")
                let txtfld = self.alert.textFields![0] 
                if(index == 0){
                    self.building_dict["name"] = txtfld.text
                }
                else if(index == 2){
                    self.building_dict["ownerType"] = txtfld.text
                }
                else if(index == 3){
                    self.building_dict["organization"] = txtfld.text
                }
                else if(index == 4){
                    self.building_dict["owner_email"] = txtfld.text
                }
                else if(index == 6){
                    self.building_dict["gross_area"] = txtfld.text
                }
                else if(index == 8){
                    self.building_dict["street"] = txtfld.text
                }
                else if(index == 9){
                    self.building_dict["city"] = txtfld.text
                }else if(index == 12){
                    self.building_dict["zip_code"] = txtfld.text
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        tableview.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
