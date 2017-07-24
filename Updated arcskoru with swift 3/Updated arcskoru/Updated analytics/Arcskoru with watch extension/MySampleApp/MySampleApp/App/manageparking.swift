//
//  manageparking.swift
//  Arcskoru
//
//  Created by Group X on 30/03/17.
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


class manageparking: UIViewController,UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UITextViewDelegate, UITabBarDelegate, UITextFieldDelegate {
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var tabbar: UITabBar!
    var leftdetail = NSMutableArray()
    var download_requests = [URLSession]()
    var task = URLSessionTask()
    var rightdetail = NSMutableArray()
    var token = UserDefaults.standard.object(forKey: "token") as! String
    var temp_dict = NSMutableDictionary()
    var dict = NSMutableDictionary()
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.title == "Manage project"){
            NotificationCenter.default.post(name: Notification.Name(rawValue: "performrootsegue"), object: nil, userInfo: ["seguename":"parkmanage"])
        }else{
            NotificationCenter.default.post(name: Notification.Name(rawValue: "performrootsegue"), object: nil, userInfo: ["seguename":"parkbilling"])
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(temp_dict == dict){
            savebtn.isEnabled = false
            self.savebtn.backgroundColor = UIColor.gray
        //self.savebtn.alpha = 0.2;
        }else{
            savebtn.isEnabled = true
            //self.savebtn.alpha = 1;
            self.savebtn.backgroundColor = bgcolor
        }
    }
    var bgcolor = UIColor()
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField.tag == 13 || textField.tag == 14){
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
        }
        return true
    }
    var state = ""
    var country = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        bgcolor = self.savebtn.backgroundColor!
        self.savebtn.clearsContextBeforeDrawing = false
        savebtn.isEnabled = false
        //self.savebtn.alpha = 0.2;
            self.savebtn.backgroundColor = UIColor.gray
        self.tabbar.delegate = self
        self.tabbar.items![0].title = "Manage project"
        self.tabbar.items![1].title = "Billing"
        self.tabbar.selectedItem = self.tabbar.items![0]
        self.spinner.isHidden = true
        self.spinner.layer.cornerRadius = 5
        tableview.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        self.tableview.contentSize = CGSize(width: self.tableview.frame.size.width, height: self.view.frame.size.height)
        tableview.register(UINib.init(nibName: "manageprojcellwithswitch", bundle: nil), forCellReuseIdentifier: "manageprojcellwithswitch")
        tableview.register(UINib.init(nibName: "manageprojcell", bundle: nil), forCellReuseIdentifier: "manageprojcell")
        tableview.register(UINib.init(nibName: "textcell", bundle: nil), forCellReuseIdentifier: "textcell")
        dict = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        temp_dict = NSMutableDictionary.init(dictionary: dict)
        var countries = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "countries") as! Data) as! NSDictionary
        var currentcountry = self.dict["country"] as? String
        var currentstate = self.dict["state"] as? String
        // Getting country
        let t = countries["countries"] as! NSDictionary
        if(t[currentcountry] != nil){
            self.country = (t[currentcountry] as? String)!
        }
        countries = countries["divisions"] as! NSDictionary
        if(countries[currentcountry] != nil){
            let dict = countries[currentcountry] as! NSDictionary
            if(dict[currentstate] != nil){
            self.state = dict[currentstate] as! String
            }
        }
        print(self.country,self.state)
        self.navigationItem.title = temp_dict["name"] as! String
        //print(temp_dict)
        datepicker.maximumDate = Date()
        dateview.isHidden = true
        //print("total count ",temp_dict.allKeys.count,temp_dict)
        
        //print(temp_dict)        
        self.navigationItem.title = temp_dict["name"] as? String
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "OpenSans", size: 17)!, NSForegroundColorAttributeName : UIColor.white]
        tableview.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    func showalert(_ message:String, title:String, action:String){
        
        //let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        //let callActionHandler = { (action:UIAlertAction!) -> Void in
        DispatchQueue.main.async(execute: {
            self.view.isUserInteractionEnabled = true
            self.spinner.isHidden = true
            self.view.isUserInteractionEnabled = true
            self.maketoast(message, type: "error")
            //self.navigationController?.popViewControllerAnimated(true)
        })
        
        //        }
        //      let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        //    alertController.addAction(defaultAction)
        
        //presentViewController(alertController, animated: true, completion: nil)
        
        
    }

    
    func textViewDidChange(_ textView: UITextView) {
        if(textView.text != "Please tell us about your project in about 200 words" && textView.text != ""){
            temp_dict["projectInfo"] = textView.text
        }else{
            textView.text = "Please tell us about your project in about 200 words"
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            if(textView.text != "Please tell us about your project in about 200 words" && textView.text != ""){
                temp_dict["projectInfo"] = textView.text
            }else{
                textView.text = "Please tell us about your project in about 200 words"
            }
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        DispatchQueue.main.async(execute: {
        if(self.temp_dict == self.dict){
            self.savebtn.isEnabled = false
        //self.savebtn.alpha = 0.2;
            self.savebtn.backgroundColor = UIColor.gray
        }else{
            self.savebtn.isEnabled = true
            //self.savebtn.alpha = 1;
            self.savebtn.backgroundColor = self.bgcolor
        }
        })
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 18
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "manageprojcell")! as! manageprojcell
            cell.alpha = 1.0
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.contentView.alpha = cell.alpha
            cell.textLabel?.numberOfLines = 3
            cell.textLabel?.text = "Name"
            if(temp_dict["name"] != nil && (temp_dict["name"] as? String)?.characters.count > 0){
            cell.detailTextLabel?.text = temp_dict["name"] as? String
            cell.detailTextLabel?.textColor = UIColor.black
            }else{
            cell.detailTextLabel?.text = ""
            }
            return cell
        }else if(indexPath.row == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "manageprojcell")! as! manageprojcell
            cell.textLabel?.text = "Project ID"
            cell.alpha = 0.6
            cell.accessoryType = UITableViewCellAccessoryType.none
            cell.contentView.alpha = cell.alpha
            cell.textLabel?.numberOfLines = 3
            cell.detailTextLabel?.textColor = UIColor.black
            if(temp_dict["leed_id"] != nil){
                cell.detailTextLabel?.text = "\(temp_dict["leed_id"] as! Int)"
            }else{
                cell.detailTextLabel?.text = ""
            }
            return cell
        }else if(indexPath.row == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: "manageprojcell")! as! manageprojcell
            cell.textLabel?.text = "Registration Date"
            cell.alpha = 0.6
            cell.accessoryType = UITableViewCellAccessoryType.none
            cell.contentView.alpha = cell.alpha
            cell.textLabel?.numberOfLines = 3
            cell.detailTextLabel?.textColor = UIColor.black
            if(temp_dict["created_at"] != nil && (temp_dict["created_at"] as? String)?.characters.count > 0){
                let dateFormatter: DateFormatter = DateFormatter()
                dateFormatter.dateFormat = credentials().milli_secs
                if(dateFormatter.date(from: temp_dict["created_at"] as! String) != nil){
                let date = dateFormatter.date(from: temp_dict["created_at"] as! String)! 
                dateFormatter.dateFormat = "MM/dd/yyyy"
                cell.detailTextLabel?.text = dateFormatter.string(from: date)
                }else{
                    dateFormatter.dateFormat = credentials().micro_secs
                    let date = dateFormatter.date(from: temp_dict["created_at"] as! String)!
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    cell.detailTextLabel?.text = dateFormatter.string(from: date)
                }
            }else{
                cell.detailTextLabel?.text = ""
            }
            return cell
        }else if(indexPath.row == 3){
            let cell = tableView.dequeueReusableCell(withIdentifier: "manageprojcell")! as! manageprojcell
            cell.textLabel?.text = "Address"
            cell.alpha = 0.6
            cell.accessoryType = UITableViewCellAccessoryType.none
            cell.contentView.alpha = cell.alpha
            cell.textLabel?.numberOfLines = 3
            cell.detailTextLabel?.textColor = UIColor.black
            if(temp_dict["street"] != nil && (temp_dict["street"] as? String)?.characters.count > 0){
                cell.detailTextLabel?.text = temp_dict["street"] as? String
            }else{
                cell.detailTextLabel?.text = ""
            }
            return cell
        }else if(indexPath.row == 4){
            let cell = tableView.dequeueReusableCell(withIdentifier: "manageprojcell")! as! manageprojcell
            cell.alpha = 0.6
            cell.accessoryType = UITableViewCellAccessoryType.none
            cell.contentView.alpha = cell.alpha
            cell.textLabel?.text = "City"
            cell.textLabel?.numberOfLines = 3
            cell.detailTextLabel?.textColor = UIColor.black
            if(temp_dict["city"] != nil && (temp_dict["city"] as? String)?.characters.count > 0){
                cell.detailTextLabel?.text = temp_dict["city"] as? String
            }else{
                cell.detailTextLabel?.text = ""
            }
            return cell
        }else if(indexPath.row == 5){
            let cell = tableView.dequeueReusableCell(withIdentifier: "manageprojcell")! as! manageprojcell
            cell.alpha = 0.6
            cell.accessoryType = UITableViewCellAccessoryType.none
            cell.contentView.alpha = cell.alpha
            cell.detailTextLabel?.textColor = UIColor.black
            cell.textLabel?.text = "State"
            cell.textLabel?.numberOfLines = 3
            cell.detailTextLabel?.text = self.state.capitalized
            return cell
        }else if(indexPath.row == 6){
            let cell = tableView.dequeueReusableCell(withIdentifier: "manageprojcell")! as! manageprojcell
            cell.alpha = 0.6
            cell.accessoryType = UITableViewCellAccessoryType.none
            cell.contentView.alpha = cell.alpha
            cell.textLabel?.text = "Country"
            cell.detailTextLabel?.textColor = UIColor.black
            cell.textLabel?.numberOfLines = 3
            cell.detailTextLabel?.text = self.country.capitalized
            return cell
        }else if(indexPath.row == 7){
            let cell = tableView.dequeueReusableCell(withIdentifier: "manageprojcellwithswitch")! as! manageprojcellwithswitch
            cell.alpha = 1.0
            cell.accessoryType = UITableViewCellAccessoryType.none
            cell.contentView.alpha = cell.alpha
            cell.lbl.text = ""
            cell.yesorno.tag = indexPath.row
            cell.yesorno.addTarget(self, action: #selector(self.switchused(_:)), for: UIControlEvents.valueChanged)
            cell.detailTextLabel?.textColor = UIColor.black
            cell.textLabel?.font = UIFont.init(name: "OpenSans", size: 13)
            cell.textLabel?.numberOfLines = 3
            //cell.textLabel?.text = key
            cell.textLabel?.text = "Private"
            cell.textLabel?.numberOfLines = 3
            if(temp_dict["confidential"] != nil && (temp_dict["confidential"] as? Bool)!){
                cell.yesorno.isOn = (temp_dict["confidential"] as? Bool)!
            }else{
                cell.yesorno.isOn = false
            }
            
            /*if(temp_dict["IsLovRecert"] != nil && (temp_dict["IsLovRecert"] as? String)?.characters.count > 0){
             cell.detailTextLabel?.text = temp_dict["IsLovRecert"] as? String
             }else{
             cell.detailTextLabel?.text = ""
             }*/
            return cell
        }else if(indexPath.row == 8){
            let cell = tableView.dequeueReusableCell(withIdentifier: "manageprojcell")! as! manageprojcell
            cell.alpha = 0.6
            cell.accessoryType = UITableViewCellAccessoryType.none
            cell.contentView.alpha = cell.alpha
            cell.textLabel?.text = "Owner Type"
            cell.detailTextLabel?.textColor = UIColor.black
            cell.textLabel?.numberOfLines = 3
            if(temp_dict["ownerType"] != nil && (temp_dict["ownerType"] as? String)?.characters.count > 0){
                cell.detailTextLabel?.text = temp_dict["ownerType"] as? String
            }else{
                cell.detailTextLabel?.text = ""
            }
            return cell
        }else if(indexPath.row == 9){
            let cell = tableView.dequeueReusableCell(withIdentifier: "manageprojcell")! as! manageprojcell
            cell.alpha = 0.6
            cell.accessoryType = UITableViewCellAccessoryType.none
            cell.detailTextLabel?.textColor = UIColor.black
            cell.contentView.alpha = cell.alpha
            cell.textLabel?.text = "Owner Organization"
            cell.textLabel?.numberOfLines = 3
            if(temp_dict["organization"] != nil && (temp_dict["organization"] as? String)?.characters.count > 0){
                cell.detailTextLabel?.text = temp_dict["organization"] as? String
            }else{
                cell.detailTextLabel?.text = ""
            }
            return cell
        }else if(indexPath.row == 10){
            let cell = tableView.dequeueReusableCell(withIdentifier: "manageprojcell")! as! manageprojcell
            cell.alpha = 0.6
            cell.accessoryType = UITableViewCellAccessoryType.none
            cell.detailTextLabel?.textColor = UIColor.black
            cell.contentView.alpha = cell.alpha
            cell.textLabel?.text = "Owner Email"
            cell.textLabel?.numberOfLines = 3
            if(temp_dict["owner_email"] != nil && (temp_dict["owner_email"] as? String)?.characters.count > 0){
                cell.detailTextLabel?.text = temp_dict["owner_email"] as? String
            }else{
                cell.detailTextLabel?.text = ""
            }
            return cell
        }else if(indexPath.row == 11){
            let cell = tableView.dequeueReusableCell(withIdentifier: "manageprojcell")! as! manageprojcell
            cell.alpha = 0.6
            cell.accessoryType = UITableViewCellAccessoryType.none
            cell.detailTextLabel?.textColor = UIColor.black
            cell.contentView.alpha = cell.alpha
            cell.textLabel?.text = "Owner Country"
            cell.textLabel?.numberOfLines = 3
            cell.detailTextLabel?.text = self.country.capitalized
            return cell
        }else if(indexPath.row == 12){
            let cell = tableView.dequeueReusableCell(withIdentifier: "manageprojcell")! as! manageprojcell
            cell.alpha = 1.0
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.contentView.alpha = cell.alpha
            cell.detailTextLabel?.textColor = UIColor.black
            cell.textLabel?.text = "Date Commissioned"
            let dateformat = DateFormatter()
            dateformat.dateFormat = "dd/MM/yyyy"
            //print(temp_dict["year_constructed"])
            if(temp_dict["year_constructed"] != nil && temp_dict["year_constructed"] as! String != ""){
            cell.detailTextLabel?.text = self.temp_dict["year_constructed"] as! String
                
            }else{
            cell.detailTextLabel?.text = ""
            }
            cell.textLabel?.numberOfLines = 3
            return cell
        }else if(indexPath.row == 13){
            let cell = tableView.dequeueReusableCell(withIdentifier: "manageprojcell")! as! manageprojcell
            cell.alpha = 1.0
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.detailTextLabel?.textColor = UIColor.black
            cell.contentView.alpha = cell.alpha
            cell.textLabel?.text = "Number of parking spaces"
            cell.textLabel?.numberOfLines = 3
            if(temp_dict["noOfParkingSpace"] != nil && (temp_dict["noOfParkingSpace"] as? String)?.characters.count > 0){
                cell.detailTextLabel?.text = temp_dict["noOfParkingSpace"] as? String
            }else{
                cell.detailTextLabel?.text = ""
            }
            
            if let nooflevels = temp_dict["noOfParkingSpace"] as? Int{
                cell.detailTextLabel?.text = "\(nooflevels as! Int)"
            }
            
            return cell
        }else if(indexPath.row == 14){
            let cell = tableView.dequeueReusableCell(withIdentifier: "manageprojcell")! as! manageprojcell
            cell.alpha = 1.0
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.contentView.alpha = cell.alpha
            cell.detailTextLabel?.textColor = UIColor.black
            cell.textLabel?.text = "How many levels in your parking structure?"
            cell.textLabel?.numberOfLines = 3
            if(temp_dict["noOfParkingLevels"] != nil && (temp_dict["noOfParkingLevels"] as? String)?.characters.count > 0){
                cell.detailTextLabel?.text = temp_dict["noOfParkingLevels"] as? String
            }else{
                cell.detailTextLabel?.text = ""
            }
            
            if let nooflevels = temp_dict["noOfParkingLevels"] as? Int{
                cell.detailTextLabel?.text = "\(nooflevels as! Int)"
            }
            
            return cell
        }else if(indexPath.row == 15){
            let cell = tableView.dequeueReusableCell(withIdentifier: "manageprojcellwithswitch")! as! manageprojcellwithswitch
            cell.lbl.text = ""
            cell.alpha = 1.0
            cell.yesorno.tag = indexPath.row
            
            cell.yesorno.addTarget(self, action: #selector(self.switchused(_:)), for: UIControlEvents.valueChanged)
            cell.accessoryType = UITableViewCellAccessoryType.none
            cell.contentView.alpha = cell.alpha
            cell.detailTextLabel?.textColor = UIColor.black
            cell.textLabel?.font = UIFont.init(name: "OpenSans", size: 13)
            cell.textLabel?.numberOfLines = 3
            //cell.textLabel?.text = key
            cell.textLabel?.text = "Previously LEED Certified?"
            cell.textLabel?.numberOfLines = 3
            if(temp_dict["IsLovRecert"] != nil && (temp_dict["IsLovRecert"] as? Bool)!){
                cell.yesorno.isOn = (temp_dict["IsLovRecert"] as? Bool)!
            }else{
                cell.yesorno.isOn = false
            }
            return cell
        }else if(indexPath.row == 16){
            let cell = tableView.dequeueReusableCell(withIdentifier: "manageprojcell")! as! manageprojcell
            cell.alpha = 1.0
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.contentView.alpha = cell.alpha
            cell.textLabel?.text = "Project Website"
            cell.detailTextLabel?.textColor = UIColor.black
            cell.textLabel?.numberOfLines = 3
            if(temp_dict["projectWebsite"] != nil && (temp_dict["projectWebsite"] as? String)?.characters.count > 0){
                cell.detailTextLabel?.text = temp_dict["projectWebsite"] as? String
            }else{
                cell.detailTextLabel?.text = ""
            }
            return cell
        }else if(indexPath.row == 17){
            let cell = tableView.dequeueReusableCell(withIdentifier: "textcell")! as! textcell
            cell.alpha = 1.0
            cell.accessoryType = UITableViewCellAccessoryType.none
            cell.contentView.alpha = cell.alpha
            cell.tview.delegate = self
            cell.textLabel?.numberOfLines = 3
            if(temp_dict["projectInfo"] != nil && (temp_dict["projectInfo"] as? String)?.characters.count > 0){
                cell.tview.text = temp_dict["projectInfo"] as? String
            }else{
                cell.tview.text = "Please tell us about your project in about 200 words"
            }
            return cell
        }
        return UITableViewCell()
        
    }
    
    @IBOutlet weak var spinner: UIView!
    @IBAction func save(_ sender: AnyObject) {
        DispatchQueue.main.async(execute: {
        self.spinner.isHidden = false
            self.view.isUserInteractionEnabled = false
        })
        
        var payload = NSMutableString()
        payload.append("{")
        
        
        for (key, value) in temp_dict {
            if(value is String){
                payload.append("\"\(key)\": \"\(value)\",")
            }else if(value is Int){
                payload.append("\"\(key)\": \(value),")
            }else if(value is  Bool){
                payload.append("\"\(key)\": \(value),")
            }
        }
        var str = payload as String
        payload.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
        payload.append("}")
        str = payload as String
        print(str)
        
        
        let url = URL.init(string:String(format: "%@assets/LEED:%d/?recompute_score=1",credentials().domain_url, temp_dict["leed_id"] as! Int))
        ////print(url?.absoluteURL)
        var subscription_key = credentials().subscription_key
        var token = UserDefaults.standard.object(forKey: "token") as! String
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "PUT"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var httpbody = str
        request.httpBody = httpbody.data(using: String.Encoding.utf8)
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
                    
                    var jsontemp_dictionary : NSDictionary
                    do {
                        jsontemp_dictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        //print(jsontemp_dictionary)
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
    @IBOutlet weak var savebtn: UIButton!
    
    func updateproject(){
        let url = URL.init(string:String(format: "%@assets/LEED:%d/",credentials().domain_url,temp_dict["leed_id"] as! Int))
        ////print(url?.absoluteURL)
        
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
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401{
                DispatchQueue.main.async(execute: {
                    //self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                    
                })
                return
            } else
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                    DispatchQueue.main.async(execute: {
                        self.spinner.isHidden = true
                        self.view.isUserInteractionEnabled = true
                    })
                }else{
                    
                    var jsontemp_dictionary : NSDictionary
                    do {
                        jsontemp_dictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        //print(jsontemp_dictionary)
                        var datakeyed = NSKeyedArchiver.archivedData(withRootObject: jsontemp_dictionary)
                        UserDefaults.standard.set(datakeyed, forKey: "building_details")
                        UserDefaults.standard.synchronize()
                        UserDefaults.standard.set(0, forKey: "row")
                        DispatchQueue.main.async(execute: {
                            self.spinner.isHidden = true
                            self.view.isUserInteractionEnabled = true
                            self.dict = jsontemp_dictionary.mutableCopy() as! NSMutableDictionary
                            self.temp_dict = NSMutableDictionary.init(dictionary: jsontemp_dictionary)
                            print()
                            self.tableview.reloadData()
                        })
                        //self.tableview.reloadData()
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

    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        let ptintable = textView.superview!.convert(textView.frame.origin, to: self.tableview)
        var contentoffset = self.tableview.contentOffset
        contentoffset.y = (ptintable.y - textView.layer.frame.size.height)
        self.tableview.setContentOffset(contentoffset, animated: true)
        if(textView.text != "Please tell us about your project in about 200 words"){
            textView.text = temp_dict["projectInfo"] as? String
        }else{
            textView.text = ""
        }
        return true
    }
  
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        if textView.superview?.superview is UITableViewCell {
            // touch.view is of type UIPickerView
            let cell = textView.superview?.superview as! UITableViewCell
            let indexPath = self.tableview.indexPath(for: cell)!
            self.tableview.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: true)
            if(textView.text != "Please tell us about your project in about 200 words" && textView.text != ""){
                temp_dict["projectInfo"] = textView.text
                print(temp_dict["projectInfo"], dict["projectInfo"])
            }else{
                textView.text = "Please tell us about your project in about 200 words"
            }
            DispatchQueue.main.async(execute: {
            self.tableview.reloadData()
            })
        }
        
        
        return true
    }
    
    
    @IBOutlet weak var dateview: UIView!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async(execute: {
            //dateview.hidden = false
            
            if(indexPath.row == 0){
                let cell = self.tableview.cellForRow(at: indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != ""){
                self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }else if(indexPath.row == 1){
                
            }else if(indexPath.row == 2){
                
            }else if(indexPath.row == 3){
                
            }else if(indexPath.row == 4){
                
            }else if(indexPath.row == 5){
                
            }else if(indexPath.row == 6){
                
            }else if(indexPath.row == 7){
                let cell = tableView.dequeueReusableCell(withIdentifier: "manageprojcell")! as! manageprojcell
                cell.textLabel?.text = "confidential"
                cell.textLabel?.numberOfLines = 3
                //return cell
            }else if(indexPath.row == 8){
                
            }else if(indexPath.row == 9){
                
            }else if(indexPath.row == 10){
                
            }else if(indexPath.row == 11){
                
            }else if(indexPath.row == 12){
                let dateformat = DateFormatter()
                dateformat.dateFormat = "dd/MM/yyyy"
                //print(self.temp_dict["year_constructed"])
                if(self.temp_dict["year_constructed"] != nil && self.temp_dict["year_constructed"] as! String != ""){
                    self.datepicker.date = dateformat.date(from: self.temp_dict["year_constructed"] as! String)!
                }else{
                    self.datepicker.date = Date()
                }
                
                
                self.dateview.isHidden = false
            }else if(indexPath.row == 13){
                let cell = self.tableview.cellForRow(at: indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != ""){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }else if(indexPath.row == 14){
                let cell = self.tableview.cellForRow(at: indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != ""){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }else if(indexPath.row == 15){
                
            }else if(indexPath.row == 16){
                let cell = self.tableview.cellForRow(at: indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != ""){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }else if(indexPath.row == 17){
                let cell = tableView.dequeueReusableCell(withIdentifier: "textcell")! as! textcell
                cell.tview.text = "projectInfo"
                cell.textLabel?.numberOfLines = 3
                //return cell
            }
            
            self.tableview.reloadData()
        })
    }
    
    func switchused(_ sender:UISwitch){
        //15 - prev leed , 7 - confidential
        if(sender.tag == 7){
            temp_dict["confidential"] = sender.isOn
        }else{
            temp_dict["IsLovRecert"] = sender.isOn
            if(sender.isOn){
                self.showalert(sender.tag, title: "Enter your previous LEED ID", value:  "")
            }
        }
        self.tableview.reloadData()
    }
    
    
    @IBOutlet weak var datepicker: UIDatePicker!
    
    @IBAction func datechanged(_ sender: AnyObject) {
        
    }
    
    var selected_date = Date()
    
    @IBAction func datecancel(_ sender: AnyObject) {
        dateview.isHidden = true
    }
    weak var AddAlertSaveAction: UIAlertAction?
    
    func configurationTextField(_ textField: UITextField!)
    {
        //print("configurat hire the TextField")
        
        if let tField = textField {
        tField.enablesReturnKeyAutomatically = true
            NotificationCenter.default.addObserver(self, selector: #selector(manageparking.handleTextFieldTextDidChangeNotification(_:)), name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
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
    }
    var alert = UIAlertController()
    
    func showalert(_ index: Int, title : String, value : String){
        DispatchQueue.main.async(execute: {
        self.alert = UIAlertController(title: "", message: "Enter the \(title )", preferredStyle: UIAlertControllerStyle.alert)
        self.alert.addTextField(configurationHandler: self.configurationTextField)
            if(index == 13 || index == 14){
                self.alert.textFields?[0].keyboardType = .numberPad
            }
            self.alert.textFields?[0].delegate = self
            self.alert.textFields?[0].tag = index
        let otherAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
            //print("User click Ok button")
            let txtfld = self.alert.textFields![0] 
            if(index == 0){
                self.temp_dict["name"] = txtfld.text
            }else if(index == 13){
                self.temp_dict["noOfParkingSpace"] = txtfld.text
            }else if(index == 14){
                self.temp_dict["noOfParkingLevels"] = txtfld.text
            }else if(index == 16){
                self.temp_dict["projectWebsite"] = txtfld.text
            }else if(index == 15){
                self.temp_dict["PrevCertProdId"] = txtfld.text
            }
            
            
            self.tableview.reloadData()
            ////print(self.textField.text)
        })
            otherAction.isEnabled = false
            
            // save the other action to toggle the enabled/disabled state when the text changed.
            self.AddAlertSaveAction = otherAction

            
            
        self.alert.addAction(UIAlertAction(title: "cancel", style: UIAlertActionStyle.cancel, handler:{ (UIAlertAction)in
            if(index == 15){
         let cell = self.tableview.cellForRow(at: IndexPath.init(row: 15, section: 0)) as! manageprojcellwithswitch
           cell.yesorno.setOn(false, animated: true)
            }
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
    
    
    @IBAction func datedone(_ sender: AnyObject) {
        selected_date = datepicker.date
        let dateformat = DateFormatter()
        dateformat.dateFormat = "dd/MM/yyyy"
        temp_dict["year_constructed"] = dateformat.string(from: selected_date)
        dateview.isHidden = true
        DispatchQueue.main.async(execute: {
            print(self.temp_dict["year_constructed"],self.dict["year_constructed"])
        self.tableview.reloadData()
        })
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 17){
            return 120
        }
        return 50
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
