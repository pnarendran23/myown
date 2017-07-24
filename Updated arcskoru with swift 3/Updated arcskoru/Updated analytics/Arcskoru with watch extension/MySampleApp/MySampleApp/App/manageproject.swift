//
//  manageproject.swift
//  LEEDOn
//
//  Created by Group X on 07/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
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


class manageproject: UIViewController,UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource, UITabBarDelegate {
    @IBOutlet weak var assetname: UILabel!

    @IBOutlet weak var spinner: UIView!
    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var tableview: UITableView!
    var titlearr = NSArray()
    var state = ""
    var download_requests = [URLSession]()
    var data_dict = NSMutableDictionary()
            var leedid = UserDefaults.standard.integer(forKey: "leed_id")
    var listarr =  NSMutableArray()
    var unitarr = ["SI","IP"]
    var spacearr = ["Circulation space","Core learning space:College/University","Core learning space:K-12 Elementary/Middle school","Core learning space: K-12 High school","Core learning space:Other classroom education","Core learning space:Preschool/Daycare","Data Center","Healthcare: Clinic/Other outpatient","Healthcare:Inpatient","Healthcare:Nursing Home/Assisted living","Healthcare: Outpatient office(diagnostic)","Industrial manufacturing","Laboratory","Lodging: Dormitory","Lodging: Hotel/Motel/Report, Full service","Lodging: Hotel/Motel/Report, Limited service","Lodging: Hotel/Motel/Report, Select service","Lodging: Inn","Lodging: Other lodging","Multifamily residential: Apartment","Multifamily residential: Condomninum","Multifamily residential: Lowrise","Office: Administrative/Professional","Office: Financial","Office: Government","Office: Medical(non-diagnostic)","Office: Mixed use","Office: Other office","Public assembly: Convention Center","Public assembly: Recreation","Public assembly: Social/Meeting","Public assembly:Stadium/Arena","Public Order and safety:Fire/Police station","Public order and safety: Other public order","Religious worship","Retail: Bank branch","Retail: Convenience","Retail:Enclosed Mall","Fast Food","Grocery store/Food market","Retail: Open shopping center","Retail: Other Retail","Retail: Restaurant/cafeteria","Retail: Vehicle dealership","Service: Other service","Service: Post office/postal center","Service: Repair shop","Service: Vehicle service/repair","Service: Vehicle storage/maintanance","Single family home(attached)","Single family home(detached)","Warehouse: Nonrefridgerated distribution/shipping","Warehouse: Refridgerated","Warehouse: Self storage units","Warehouse:General","Other"]
    var currentarr = NSArray()
    var country = ""
    var pursedcertarr = NSArray()
    var yesorno = ["Yes","No"]
    var token = UserDefaults.standard.object(forKey: "token") as? String
    var dict = NSDictionary()
    
    override func viewDidAppear(_ animated: Bool) {
        token = UserDefaults.standard.object(forKey: "token") as! String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listarr = ["","","","","","","","","","","","","","","","","","","","","","","","",""]
        self.titlefont()
        self.view.backgroundColor = self.nav.backgroundColor
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
        backbtn.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12)
        self.spinner.layer.cornerRadius = 5
        self.spinner.isHidden = true
        self.view.isUserInteractionEnabled = true
        dict = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary
        let navItem = UINavigationItem(title: (dict["name"] as? String)!);
        self.nav.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!]
        let doneItem = UIBarButtonItem(title: "< Manage", style: .plain, target: self, action: #selector(sayHello(_:)))
        navItem.leftBarButtonItem = doneItem;
        nav.setItems([navItem], animated: false);
        
        
        //print(dict)
        assetname.text = dict["name"] as? String
        tabbar.selectedItem = self.tabbar.items![3]
        data_dict = dict.mutableCopy() as! NSMutableDictionary
        pursedcertarr = ["WELL","Sustainable SITES", "PEER","Parksmart","GRESB","EDGE","Green Star","DGNB","BREEAM","Zero Waste","ENERGY STAR","Beam","CASBEE","Green Mark","Pearl","Other"]
        titlearr = ["Name","Project ID","Unit Type","Space type","Address","City","State","Country","Private","Owner type","Owner organization","Owner Email","Owner country","Previously LEED Certified?","Other certification programs pursued","Contains residential units?","Is project affiliated with a higher education institute?","Is project affiliated with a LEED Lab?","Year built","Floors above grounds","Intend to precertify?","Gross floor area(square foot)","Target certification date","Operating hours","Occupancy"]
        tableview.register(UINib.init(nibName: "manageprojectdatacell", bundle: nil), forCellReuseIdentifier: "manageprojectdatacell")
        tableview.register(UINib.init(nibName: "extradetails", bundle: nil), forCellReuseIdentifier: "extradetails")
        /*dispatch_async(dispatch_get_main_queue(), {
            self.spinner.hidden = false
            self.view.userInteractionEnabled = false
        })
        getstates(credentials().subscription_key)*/
        // Do any additional setup after loading the view.
    }
    
    func sayHello(_ sender: UIBarButtonItem) {
        //print("Projects clicked")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "performsegue"), object: nil, userInfo: ["seguename":"manage"])
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
    
    
    func getstates(_ subscription_key:String){
        let url = URL.init(string:String(format: "%@country/states/",credentials().domain_url))
        ////print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token!), forHTTPHeaderField:"Authorization" )
        let session = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(session)
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
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
                    ////print(jsonDictionary)
                    DispatchQueue.main.async(execute: {
                    
                    let currentcountry = self.dict["country"] as? String
                    let currentstate = self.dict["state"] as? String
                        var tempstring = ""//jsonDictionary["divisions"]![currentcountry!]!![currentstate!]! as? String
                        if let snapshotValue = jsonDictionary["divisions"] as? NSDictionary, let currentcountr = snapshotValue[currentstate] as? String {
                            self.state =  currentcountr
                        }
                        
                        //print(tempstring)
                        
                        if let snapshotValue = jsonDictionary["countries"] as? NSDictionary, let currentcountr = snapshotValue[currentcountry] as? String {
                            tempstring =  currentcountr
                        }
                    
                    self.country = tempstring
                        self.spinner.isHidden = true
                        self.view.isUserInteractionEnabled = true
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

    @IBOutlet weak var backbtn: UIButton!

    //https://api.usgbc.org/dev/leed/country/states/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlearr.count
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        //stop all download requests
        for request in download_requests
        {
            request.invalidateAndCancel()
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "manageprojectdatacell") as! manageprojectdatacell
        cell.contentView.frame.size.width = self.view.frame.size.width
        cell.titlelbl.text = titlearr.object(at: indexPath.row) as? String
        cell.valuetxtfld.delegate = self
        //cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.valuetxtfld.tag = indexPath.row
        cell.contentView.alpha = 1
        cell.valuetxtfld.placeholder = ""
        if(indexPath.row == 0){
            cell.isUserInteractionEnabled = true
            //cell.valuetxtfld.enabled = true
            cell.yesnoswitch.isHidden = true
            cell.valuetxtfld.keyboardType = UIKeyboardType.default
            cell.valuetxtfld.text = data_dict["name"] as? String
            listarr.replaceObject(at: indexPath.row, with: cell.valuetxtfld.text!)
            let cel = tableView.dequeueReusableCell(withIdentifier: "extradetails", for: indexPath) as! extradetails
            cel.textLabel?.text = titlearr[indexPath.row] as! String
            cel.detailTextLabel?.text = data_dict["name"] as? String
            return cel
        }else if(indexPath.row == 1){
            cell.isUserInteractionEnabled = false
            cell.contentView.alpha = 0.4
            //cell.valuetxtfld.enabled = false
            cell.yesnoswitch.isHidden = true
            cell.valuetxtfld.keyboardType = UIKeyboardType.numberPad
            cell.valuetxtfld.text = String(format: "%d",dict["leed_id"] as! Int)
            listarr.replaceObject(at: indexPath.row, with: cell.valuetxtfld.text!)
            
            let cel = tableView.dequeueReusableCell(withIdentifier: "extradetails", for: indexPath) as! extradetails
            cel.textLabel?.text = titlearr[indexPath.row] as! String
            cel.detailTextLabel?.text = String(format: "%d",dict["leed_id"] as! Int)
            return cel
            
        }else if(indexPath.row == 2){
            cell.isUserInteractionEnabled = true
            //cell.valuetxtfld.enabled = true
            cell.yesnoswitch.isHidden = true
            cell.valuetxtfld.keyboardType = UIKeyboardType.alphabet
            cell.valuetxtfld.text = data_dict["unitType"] as? String
            
            let cel = tableView.dequeueReusableCell(withIdentifier: "extradetails", for: indexPath) as! extradetails
            cel.textLabel?.text = titlearr[indexPath.row] as! String
            cel.detailTextLabel?.text = data_dict["unitType"] as! String
            return cel
            
            listarr.replaceObject(at: indexPath.row, with: cell.valuetxtfld.text!)
        }else if(indexPath.row == 3){
            cell.isUserInteractionEnabled = true
            //cell.valuetxtfld.enabled = true
            cell.yesnoswitch.isHidden = true
            cell.valuetxtfld.keyboardType = UIKeyboardType.alphabet
            cell.valuetxtfld.text = data_dict["spaceType"] as? String
            listarr.replaceObject(at: indexPath.row, with: cell.valuetxtfld.text!)
        }else if(indexPath.row == 4){
            let cel = tableView.dequeueReusableCell(withIdentifier: "extradetails", for: indexPath) as! extradetails
            cel.textLabel?.text = titlearr[indexPath.row] as! String
            cel.detailTextLabel?.text = data_dict["street"] as! String
            return cel
            
            cell.isUserInteractionEnabled = false
            cell.contentView.alpha = 0.4
            //cell.valuetxtfld.enabled = false
            cell.yesnoswitch.isHidden = true
            cell.valuetxtfld.keyboardType = UIKeyboardType.default
            cell.valuetxtfld.text = data_dict["street"] as? String
            listarr.replaceObject(at: indexPath.row, with: cell.valuetxtfld.text!)
        }else if(indexPath.row == 5){
            
            let cel = tableView.dequeueReusableCell(withIdentifier: "extradetails", for: indexPath) as! extradetails
            cel.textLabel?.text = titlearr[indexPath.row] as! String
            cel.detailTextLabel?.text = data_dict["city"] as! String
            return cel
            
            cell.isUserInteractionEnabled = false
            cell.contentView.alpha = 0.4
            //cell.valuetxtfld.enabled = false
            cell.yesnoswitch.isHidden = true
            cell.valuetxtfld.keyboardType = UIKeyboardType.alphabet
            cell.valuetxtfld.text = data_dict["city"] as? String
            listarr.replaceObject(at: indexPath.row, with: cell.valuetxtfld.text!)
        }else if(indexPath.row == 6){
            let cel = tableView.dequeueReusableCell(withIdentifier: "extradetails", for: indexPath) as! extradetails
            cel.textLabel?.text = titlearr[indexPath.row] as! String
            cel.detailTextLabel?.text = state
            return cel
            cell.isUserInteractionEnabled = false
            cell.contentView.alpha = 0.4
            cell.yesnoswitch.isHidden = true
            //cell.valuetxtfld.enabled = false
            cell.valuetxtfld.keyboardType = UIKeyboardType.alphabet
            cell.valuetxtfld.text = state
            listarr.replaceObject(at: indexPath.row, with: cell.valuetxtfld.text!)
        }else if(indexPath.row == 7){
            let cel = tableView.dequeueReusableCell(withIdentifier: "extradetails", for: indexPath) as! extradetails
            cel.textLabel?.text = titlearr[indexPath.row] as! String
            cel.detailTextLabel?.text = country
            return cel
            cell.isUserInteractionEnabled = false
            cell.contentView.alpha = 0.4
            //cell.valuetxtfld.enabled = false
            cell.yesnoswitch.isHidden = true
            cell.valuetxtfld.keyboardType = UIKeyboardType.alphabet
            cell.valuetxtfld.text = country
            listarr.replaceObject(at: indexPath.row, with: cell.valuetxtfld.text!)
        }else if(indexPath.row == 8){
            let cel = tableView.dequeueReusableCell(withIdentifier: "extradetails", for: indexPath) as! extradetails
            cel.textLabel?.text = "adasdasd"
            cel.detailTextLabel?.text = country
            return cel
            /*cell.isUserInteractionEnabled = true
            cell.textLabel?.text = titlearr[indexPath.row] as! String
            //cell.valuetxtfld.enabled = false
            cell.yesnoswitch.isHidden = false
            cell.isUserInteractionEnabled = true
            cell.yesnoswitch.tag = 100+indexPath.row
            cell.yesnoswitch.addTarget(self, action: #selector(manageproject.switchused(_:)), for:UIControlEvents.valueChanged)
            
            //print(data_dict["plaque_public"])
            
            cell.yesnoswitch.isOn = !Bool(data_dict["plaque_public"] as! NSNumber)
            listarr.replaceObject(at: indexPath.row, with: cell.valuetxtfld.text!)*/
        }else if(indexPath.row == 9){
            cell.isUserInteractionEnabled = false
            cell.contentView.alpha = 0.4
            //cell.valuetxtfld.enabled = false
            cell.yesnoswitch.isHidden = true
            cell.valuetxtfld.text = data_dict["ownerType"] as? String
            let cel = tableView.dequeueReusableCell(withIdentifier: "extradetails", for: indexPath) as! extradetails
            cel.textLabel?.text = titlearr[indexPath.row] as! String
            cel.detailTextLabel?.text = data_dict["ownerType"] as! String
            return cel
            
            listarr.replaceObject(at: indexPath.row, with: cell.valuetxtfld.text!)
        }else if(indexPath.row == 10){
            cell.isUserInteractionEnabled = false
            cell.contentView.alpha = 0.4
            //cell.valuetxtfld.enabled = false
            cell.yesnoswitch.isHidden = true
            cell.valuetxtfld.text = data_dict["organization"] as? String
            let cel = tableView.dequeueReusableCell(withIdentifier: "extradetails", for: indexPath) as! extradetails
            cel.textLabel?.text = titlearr[indexPath.row] as! String
            cel.detailTextLabel?.text = data_dict["organization"] as! String
            return cel
            
            listarr.replaceObject(at: indexPath.row, with: cell.valuetxtfld.text!)
        }else if(indexPath.row == 11){
            cell.isUserInteractionEnabled = false
            cell.contentView.alpha = 0.4
            //cell.valuetxtfld.enabled = false
            cell.valuetxtfld.text = data_dict["owner_email"] as? String
            cell.yesnoswitch.isHidden = true
            
            let cel = tableView.dequeueReusableCell(withIdentifier: "extradetails", for: indexPath) as! extradetails
            cel.textLabel?.text = titlearr[indexPath.row] as! String
            cel.detailTextLabel?.text = data_dict["owner_email"] as! String
            return cel
            
            listarr.replaceObject(at: indexPath.row, with: cell.valuetxtfld.text!)
        }else if(indexPath.row == 12){
            cell.isUserInteractionEnabled = false
            cell.contentView.alpha = 0.4
            //cell.valuetxtfld.enabled = false
            cell.valuetxtfld.text = country
             cell.yesnoswitch.isHidden = true
            listarr.replaceObject(at: indexPath.row, with: cell.valuetxtfld.text!)
        }else if(indexPath.row == 13){
            cell.isUserInteractionEnabled = true            
            if(data_dict["ldp_old"] is NSNull){
                cell.yesnoswitch.isOn = false
                cell.valuetxtfld.text = ""
            }else{
            if(data_dict["ldp_old"] as! Int == 1){
                cell.valuetxtfld.placeholder = "Enter your previous LEED ID"
                cell.yesnoswitch.isOn = Bool(data_dict["ldp_old"] as! NSNumber)
                if let s = data_dict["PrevCertProdId"] as? String{
                cell.valuetxtfld.text = s
                }else{
                cell.valuetxtfld.text = ""
                }
                //cell.valuetxtfld.enabled = true
            }else{
              cell.yesnoswitch.isOn = false
                //cell.valuetxtfld.enabled = false
                cell.valuetxtfld.text = ""
            }
            }
            
            cell.yesnoswitch.isHidden = false
            cell.yesnoswitch.tag = 100+indexPath.row
            cell.yesnoswitch.addTarget(self, action: #selector(manageproject.switchused(_:)), for:UIControlEvents.valueChanged)
            listarr.replaceObject(at: indexPath.row, with: cell.valuetxtfld.text!)
        }else if(indexPath.row == 14){
            cell.isUserInteractionEnabled = true
            //cell.valuetxtfld.enabled = true
            cell.yesnoswitch.isHidden = true
            let arr = data_dict["certifications"] as! NSArray
            if(arr.count>0){
                let str = arr.componentsJoined(by: ",")
                cell.valuetxtfld.text = str
            }else{
                cell.valuetxtfld.text = ""
            }
            listarr.replaceObject(at: indexPath.row, with: cell.valuetxtfld.text!)
        }else if(indexPath.row == 15){
            cell.isUserInteractionEnabled = true
            
            if(data_dict["IsResidential"] as! Int == 0){
                //cell.valuetxtfld.enabled = false
                cell.yesnoswitch.isOn = Bool(data_dict["IsResidential"] as! NSNumber)
                cell.valuetxtfld.text = ""
            }else{
                cell.yesnoswitch.isOn = Bool(data_dict["IsResidential"] as! NSNumber)
                //cell.valuetxtfld.enabled = true
                if(data_dict["noOfResUnits"] != nil){
                    cell.valuetxtfld.placeholder = "Number of resident units"
                    cell.valuetxtfld.text = String(format: "%d",data_dict["noOfResUnits"] as! Int)
                }
            }
            cell.yesnoswitch.isHidden = false
            cell.yesnoswitch.tag = 100+indexPath.row
            cell.yesnoswitch.addTarget(self, action: #selector(manageproject.switchused(_:)), for:UIControlEvents.valueChanged)
        }else if(indexPath.row == 16){
            cell.isUserInteractionEnabled = true
            //cell.valuetxtfld.enabled = true
            //nameOfSchool
            if(data_dict["AffiliatedHigherEduIns"] as! Int == 0){
                //cell.valuetxtfld.enabled = false
                cell.yesnoswitch.isOn = Bool(data_dict["AffiliatedHigherEduIns"] as! NSNumber)
                cell.valuetxtfld.text = ""
            }else{
                cell.yesnoswitch.isOn = Bool(data_dict["AffiliatedHigherEduIns"] as! NSNumber)
                //cell.valuetxtfld.enabled = true
                if(data_dict["nameOfSchool"] != nil){
                    cell.valuetxtfld.placeholder = "Name of school"
                    cell.valuetxtfld.text = data_dict["nameOfSchool"] as? String
                }
            }
            cell.yesnoswitch.isHidden = false
            cell.yesnoswitch.tag = 100+indexPath.row
            cell.yesnoswitch.addTarget(self, action: #selector(manageproject.switchused(_:)), for:UIControlEvents.valueChanged)
            listarr.replaceObject(at: indexPath.row, with: cell.valuetxtfld.text!)
        }else if(indexPath.row == 17){
            cell.isUserInteractionEnabled = true
            //cell.valuetxtfld.enabled = false
            cell.valuetxtfld.text = ""
            if(data_dict["affiliatedWithLeedLab"] != nil){
                cell.yesnoswitch.isOn = Bool(data_dict["affiliatedWithLeedLab"] as! NSNumber)
            }
            cell.yesnoswitch.isHidden = false
            cell.yesnoswitch.tag = 100+indexPath.row
            cell.yesnoswitch.addTarget(self, action: #selector(manageproject.switchused(_:)), for:UIControlEvents.valueChanged)
        }else if(indexPath.row == 18){
            cell.isUserInteractionEnabled = true
            //cell.valuetxtfld.enabled = true
            if(data_dict["year_constructed"] is NSNull || data_dict["year_constructed"] as? String == ""){
                cell.valuetxtfld.text = ""
            }else{
                cell.valuetxtfld.text = String(format:"%d",data_dict["year_constructed"] as! Int)
            }
            cell.yesnoswitch.isHidden = true
        }else if(indexPath.row == 19){
            cell.isUserInteractionEnabled = true
            //cell.valuetxtfld.enabled = true
            if(data_dict["noOfFloors"] is NSNull || data_dict["noOfFloors"] as? String == ""){
                cell.valuetxtfld.text = ""
            }else{
                cell.valuetxtfld.text = String(format:"%d",data_dict["noOfFloors"] as! Int)
            }
            cell.yesnoswitch.isHidden = true
            cell.valuetxtfld.keyboardType = UIKeyboardType.numberPad
            listarr.replaceObject(at: indexPath.row, with: cell.valuetxtfld.text!)
            
            
            let cel = tableView.dequeueReusableCell(withIdentifier: "extradetails", for: indexPath) as! extradetails
            cel.textLabel?.text = titlearr[indexPath.row] as! String
            cel.detailTextLabel?.text = String(format:"%d",data_dict["noOfFloors"] as! Int)
            return cel
            
        }else if(indexPath.row == 20){
            cell.isUserInteractionEnabled = true
            //cell.valuetxtfld.enabled = true
            cell.valuetxtfld.text = ""
            if(data_dict["intentToPrecertify"] as! Int == 0){
                if(data_dict["intentToPrecertify"] != nil){
                    cell.yesnoswitch.isOn = Bool(data_dict["intentToPrecertify"] as! NSNumber)
                }
            }else{
                cell.valuetxtfld.text = "Yes"
            }
            cell.yesnoswitch.isHidden = false
            cell.yesnoswitch.tag = 100+indexPath.row
            cell.yesnoswitch.addTarget(self, action: #selector(manageproject.switchused(_:)), for:UIControlEvents.valueChanged)
        }else if(indexPath.row == 21){
            cell.isUserInteractionEnabled = true
            //cell.valuetxtfld.enabled = true
            cell.valuetxtfld.text = String(format:"%d",data_dict["gross_area"] as! Int)
            cell.valuetxtfld.keyboardType = UIKeyboardType.numberPad
            cell.yesnoswitch.isHidden = true
            
            let cel = tableView.dequeueReusableCell(withIdentifier: "extradetails", for: indexPath) as! extradetails
            cel.textLabel?.text = titlearr[indexPath.row] as! String
            cel.detailTextLabel?.text = String(format:"%d",data_dict["gross_area"] as! Int)
            return cel
            
        }else if(indexPath.row == 22){
            cell.isUserInteractionEnabled = true
            //cell.valuetxtfld.enabled = true
            if(data_dict["targetCertDate"] is NSNull || data_dict["targetCertDate"] as? String == ""){
                cell.valuetxtfld.text = ""
            }else{
                cell.valuetxtfld.text = String(format:"%@",data_dict["targetCertDate"] as! String)
            }
            
            let cel = tableView.dequeueReusableCell(withIdentifier: "extradetails", for: indexPath) as! extradetails
            cel.textLabel?.text = titlearr[indexPath.row] as! String
            cel.detailTextLabel?.text = cell.valuetxtfld.text
            return cel
            
            cell.yesnoswitch.isHidden = true
            listarr.replaceObject(at: indexPath.row, with: cell.valuetxtfld.text!)
        }else if(indexPath.row == 23){
            cell.isUserInteractionEnabled = true
            //cell.valuetxtfld.enabled = true
            if(data_dict["operating_hours"] is NSNull || data_dict["operating_hours"] as? String == ""){
                cell.valuetxtfld.text = ""
            }else{
                cell.valuetxtfld.text = String(format:"%d",data_dict["operating_hours"] as! Int)
            }
            cell.yesnoswitch.isHidden = true
            cell.valuetxtfld.keyboardType = UIKeyboardType.numberPad
            listarr.replaceObject(at: indexPath.row, with: cell.valuetxtfld.text!)
            
            let cel = tableView.dequeueReusableCell(withIdentifier: "extradetails", for: indexPath) as! extradetails
            cel.textLabel?.text = titlearr[indexPath.row] as! String
            cel.detailTextLabel?.text = cell.valuetxtfld.text
            return cel
            
        }else if(indexPath.row == 24){
            cell.isUserInteractionEnabled = true
            //cell.valuetxtfld.enabled = true
            if(data_dict["occupancy"] is NSNull || data_dict["occupancy"] as? String == ""){
                cell.valuetxtfld.text = ""
            }else{
                cell.valuetxtfld.text = String(format:"%d",data_dict["occupancy"] as! Int)
            }
            cell.yesnoswitch.isHidden = true
            cell.valuetxtfld.keyboardType = UIKeyboardType.numberPad
            listarr.replaceObject(at: indexPath.row, with: cell.valuetxtfld.text!)
            
            let cel = tableView.dequeueReusableCell(withIdentifier: "extradetails", for: indexPath) as! extradetails
            cel.textLabel?.text = titlearr[indexPath.row] as! String
            cel.detailTextLabel?.text = cell.valuetxtfld.text
            return cel
        }
        
        if(cell.yesnoswitch.isHidden == true){
            cell.valuetxtfld.frame.size.width = 0.95 * abs(cell.contentView.frame.size.width - cell.valuetxtfld.frame.origin.x)
            cell.valuetxtfld.backgroundColor = UIColor.clear
        }else{
            cell.valuetxtfld.frame.size.width = 0.5 * cell.yesnoswitch.frame.origin.x
            cell.valuetxtfld.backgroundColor = UIColor.clear
        }
        
        return cell
    }
    
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        
        tableview.reloadData()
        return [.portrait,.landscapeLeft,.landscapeRight]
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //print(textField.tag)
        let indexPath = IndexPath.init(row: textField.tag, section: 0)
        
        if(indexPath.row == 13){
            if(tableview.cellForRow(at: indexPath) != nil){
            let cell = tableview.cellForRow(at: indexPath) as! manageprojectcell
        data_dict["PrevCertProdId"] = cell.valuetxtfld.text
            }
        }else if(indexPath.row == 14){
            if(tableview.cellForRow(at: indexPath) != nil){
            let cell = tableview.cellForRow(at: indexPath) as! manageprojectcell
            data_dict["OtherCertProg"] = cell.valuetxtfld.text
        }
        }else if(indexPath.row == 15){
            if(tableview.cellForRow(at: indexPath) != nil){
            let cell = tableview.cellForRow(at: indexPath) as! manageprojectcell
            let a:Int? = Int(cell.valuetxtfld.text!)
            data_dict["noOfResUnits"] = a
        }
        }else if(indexPath.row == 16){
            if(tableview.cellForRow(at: indexPath) != nil){
            let cell = tableview.cellForRow(at: indexPath) as! manageprojectcell
            data_dict["nameOfSchool"] = cell.valuetxtfld.text!
            }
        }else if(indexPath.row == 18){
            if(tableview.cellForRow(at: indexPath) != nil){
            let cell = tableview.cellForRow(at: indexPath) as! manageprojectcell
            let a:Int? = Int(cell.valuetxtfld.text!)
            data_dict["year_constructed"] = a
            }
        }
        else if(indexPath.row == 21){
            if(tableview.cellForRow(at: indexPath) != nil){
            let cell = tableview.cellForRow(at: indexPath) as! manageprojectcell
            let _:Int? = Int(cell.valuetxtfld.text!)
            data_dict["gross_area"] = cell.valuetxtfld.text!
            }
        }
        else if(indexPath.row == 23){
            if(tableview.cellForRow(at: indexPath) != nil){
            let cell = tableview.cellForRow(at: indexPath) as! manageprojectcell
            let _:Int? = Int(cell.valuetxtfld.text!)
            data_dict["operating_hours"] = cell.valuetxtfld.text!
            }
        }
        else if(indexPath.row == 24){
            if(tableview.cellForRow(at: indexPath) != nil){
            let cell = tableview.cellForRow(at: indexPath) as! manageprojectcell
            let _:Int? = Int(cell.valuetxtfld.text!)
            data_dict["occupancy"] = cell.valuetxtfld.text!
            }
        }
        else if(indexPath.row == 22){
            if(tableview.cellForRow(at: indexPath) != nil){
            let cell = tableview.cellForRow(at: indexPath) as! manageprojectcell
            let _:Int? = Int(cell.valuetxtfld.text!)
            data_dict["targetCertDate"] = cell.valuetxtfld.text!
            }
        }else if(indexPath.row == 19){
            if(tableview.cellForRow(at: indexPath) != nil){
            let cell = tableview.cellForRow(at: indexPath) as! manageprojectcell
            let a:Int? = Int(cell.valuetxtfld.text!)
            data_dict["noOfFloors"] = a
            }
        }
        
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(currentarr[row] is String){
        return currentarr[row] as? String
        }else{
            return String(format:"%d",currentarr[row] as! Int)
        }
    }
    
    func switchused(_ sender:UISwitch){
        //print("Changing..")
        var _ = sender
        //print(sender.tag)
        let indexPath = IndexPath.init(row: sender.tag-100, section: 0)
        let cell = tableview.cellForRow(at: indexPath) as! manageprojectcell
        if(indexPath.row == 8){
        if(sender.isOn){
            data_dict["plaque_public"] = 0
        }else{
            data_dict["plaque_public"] = 1
            }
        }else if(indexPath.row == 13){
         //PrevCertProdId
            
        if(sender.isOn){
                cell.valuetxtfld.placeholder = "Enter your previous LEED ID"
                data_dict["ldp_old"] = 1
                cell.valuetxtfld.text = ""
                //cell.valuetxtfld.enabled = true
                cell.valuetxtfld.becomeFirstResponder()
            }else{
                cell.valuetxtfld.placeholder = ""
                data_dict["ldp_old"] = 0
                cell.valuetxtfld.text = ""
                //cell.valuetxtfld.enabled = false
                data_dict.setValue(NSNull(), forKey: "PrevCertProdId")
                cell.valuetxtfld.resignFirstResponder()
            }
        }else if(indexPath.row == 15){
            if(sender.isOn){
                cell.valuetxtfld.placeholder = "Number of resident units"
                data_dict["IsResidential"] = 1
                cell.valuetxtfld.text = ""
                //cell.valuetxtfld.enabled = true
                cell.valuetxtfld.becomeFirstResponder()
            }else{
                cell.valuetxtfld.placeholder = ""
                data_dict["IsResidential"] = 0
                cell.valuetxtfld.text = ""
                //cell.valuetxtfld.enabled = false
                data_dict.setValue(NSNull(),forKey:"noOfResUnits")
                cell.valuetxtfld.resignFirstResponder()
            }
   
        }else if(indexPath.row == 16){
        //
            if(sender.isOn){
                cell.valuetxtfld.placeholder = "Name of school"
                data_dict["AffiliatedHigherEduIns"] = 1
                cell.valuetxtfld.text = ""
                //cell.valuetxtfld.enabled = true
                cell.valuetxtfld.becomeFirstResponder()
            }else{
                cell.valuetxtfld.placeholder = ""
                data_dict["AffiliatedHigherEduIns"] = 0
                cell.valuetxtfld.text = ""
                //cell.valuetxtfld.enabled = false
                data_dict.setValue(NSNull(),forKey:"nameOfSchool")
                cell.valuetxtfld.resignFirstResponder()
            }
        }else if(indexPath.row == 17){
            if(sender.isOn){
                data_dict["affiliatedWithLeedLab"] = 1
            }else{
                data_dict["affiliatedWithLeedLab"] = 0
            }
        }
        else if(indexPath.row == 20){
            if(sender.isOn){
                data_dict["intentToPrecertify"] = 1
            }else{
                data_dict["intentToPrecertify"] = 0
            }
        }
        else{
        if(sender.isOn){
            cell.valuetxtfld.text = ""
        //cell.valuetxtfld.enabled = true
        cell.valuetxtfld.becomeFirstResponder()
        }else{
            cell.valuetxtfld.text = ""
            //cell.valuetxtfld.enabled = false
            cell.valuetxtfld.resignFirstResponder()
        }
        }
        //print("Final data dict", data_dict)
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currentarr.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let pointInTable:CGPoint = textField.superview!.convert(textField.frame.origin, to:tableview)
        var contentOffset:CGPoint = tableview.contentOffset
        contentOffset.y  = pointInTable.y
        if let accessoryView = textField.inputAccessoryView {
            contentOffset.y -= accessoryView.frame.size.height
        }
        tableview.contentOffset = contentOffset
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let indexPath = IndexPath.init(row: textField.tag, section: 0)
        let cell = tableview.cellForRow(at: indexPath) as! manageprojectcell
        if(indexPath.row == 17 || indexPath.row == 16 || indexPath.row == 15 || indexPath.row == 13 || indexPath.row == 20){
            cell.valuetxtfld.inputView = nil
        }else if(indexPath.row == 18){
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            let dte = Date()
            let str = formatter.string(from: dte)
            let year = Int(str)!
            //print(year)
            let yearsarr = NSMutableArray()
            var selectedindex = 0
            for i in 0..<25 {
                yearsarr.add(year-i)
                if(cell.valuetxtfld.text?.characters.count>0){
                    let s = String(format: "%d",year-i)
                    if(cell.valuetxtfld.text == s){
                        selectedindex = i
                    }
                }
            }
            let picker = UIPickerView()
            picker.delegate = self
            picker.dataSource = self
            currentarr = yearsarr
            picker.tag = 1000+indexPath.row
            cell.valuetxtfld.inputView = picker
            picker.selectRow(selectedindex, inComponent: 0, animated: true)
            picker.reloadAllComponents()
        }else if(indexPath.row == 14){
            let picker = UIPickerView()
            picker.delegate = self
            picker.dataSource = self
            var selectedindex = 0
            currentarr = pursedcertarr
            for i in 0..<pursedcertarr.count{
                let s = pursedcertarr.object(at: i) as! String
                if(cell.valuetxtfld.text == s){
                    selectedindex = i
                    break
                }
            }
            picker.reloadAllComponents()
            picker.selectRow(selectedindex, inComponent: 0, animated: true)
            picker.tag = 1000+indexPath.row
            cell.valuetxtfld.inputView = picker
        }else if(indexPath.row == 22){
            let picker = UIDatePicker()
            picker.datePickerMode = UIDatePickerMode.date
            picker.tag = 1000+indexPath.row
            cell.valuetxtfld.inputView = picker
            if(cell.valuetxtfld.text?.characters.count > 0){
                let s = cell.valuetxtfld.text!
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let date = formatter.date(from: s)
                picker.date = date!
            }
            picker.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        }else if(indexPath.row == 2){
            let picker = UIPickerView()
            picker.delegate = self
            picker.dataSource = self
            currentarr = unitarr as NSArray
            var selectedindex = 0
            for i in 0..<currentarr.count{
                let s = currentarr.object(at: i) as! String
                if(cell.valuetxtfld.text == s){
                    selectedindex = i
                    break
                }
            }
            
            picker.selectRow(selectedindex, inComponent: 0, animated: true)
            picker.reloadAllComponents()
            picker.tag = 1000+indexPath.row
            cell.valuetxtfld.inputView = picker
        }else if(indexPath.row == 3){
            let picker = UIPickerView()
            picker.delegate = self
            picker.dataSource = self
            currentarr = spacearr as NSArray
            var selectedindex = 0
            for i in 0..<currentarr.count{
                let s = currentarr.object(at: i) as! String
                if(cell.valuetxtfld.text == s){
                    selectedindex = i
                    break
                }
            }
            picker.selectRow(selectedindex, inComponent: 0, animated: true)
            picker.reloadAllComponents()
            picker.tag = 1000+indexPath.row
            cell.valuetxtfld.inputView = picker
        }else{
            cell.valuetxtfld.inputView = nil
        }
        
        cell.valuetxtfld.becomeFirstResponder()

    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //self.view.endEditing(true)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
  /*      //print("Selected row ",indexPath.row)
        //print(titlearr[indexPath.row])
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! manageprojectcell
        if(indexPath.row == 17 || indexPath.row == 16 || indexPath.row == 15 || indexPath.row == 13 || indexPath.row == 20){
            
            
            
        }else if(indexPath.row == 18){
            var formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy"
            var dte = NSDate()
            var str = formatter.stringFromDate(dte)
            var year = Int(str)!
            //print(year)
            var yearsarr = NSMutableArray()
            var selectedindex = 0
            for i in 0..<25 {
                yearsarr.addObject(year-i)
                if(cell.valuetxtfld.text?.characters.count>0){
                    var s = String(format: "%d",year-i)
                    if(cell.valuetxtfld.text == s){
                        selectedindex = i
                    }
                }
            }
            var picker = UIPickerView()
            picker.delegate = self
            picker.dataSource = self
            currentarr = yearsarr
            picker.tag = 1000+indexPath.row
            cell.valuetxtfld.inputView = picker
            picker.selectRow(selectedindex, inComponent: 0, animated: true)
            picker.reloadAllComponents()
            cell.valuetxtfld.becomeFirstResponder()
        }else if(indexPath.row == 14){
            var picker = UIPickerView()
            picker.delegate = self
            picker.dataSource = self
            currentarr = pursedcertarr
            picker.reloadAllComponents()
            var selectedindex = 0
            for i in 0..<pursedcertarr.count{
                var s = pursedcertarr.objectAtIndex(i) as! String
                if(cell.valuetxtfld.text == s){
                    selectedindex = i
                    break
                }
            }
            picker.tag = 1000+indexPath.row
            cell.valuetxtfld.inputView = picker
            cell.valuetxtfld.becomeFirstResponder()
        }else if(indexPath.row == 22){
            var picker = UIDatePicker()
            picker.datePickerMode = UIDatePickerMode.Date
            picker.tag = 1000+indexPath.row
            cell.valuetxtfld.inputView = picker
            if(cell.valuetxtfld.text?.characters.count > 0){
                var s = cell.valuetxtfld.text!
                var formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                var date = formatter.dateFromString(s)
                picker.date = date!
            }
            picker.addTarget(self, action: #selector(self.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
             cell.valuetxtfld.becomeFirstResponder()
        }
            else if(indexPath.row == 18 || indexPath.row == 21 || indexPath.row == 23 || indexPath.row == 24){
                //cell.valuetxtfld.inputView = nil
                //cell.valuetxtfld.reloadInputViews()
            cell.valuetxtfld.becomeFirstResponder()
            }
        
        if(cell.valuetxtfld.hidden == false){
            cell.valuetxtfld.becomeFirstResponder()
            cell.becomeFirstResponder()
        }
        */
        
    }
    
    func datePickerValueChanged(_ sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let textfld = self.view.viewWithTag(sender.tag-1000) as! UITextField
        textfld.text = dateFormatter.string(from: sender.date)
        listarr.replaceObject(at: sender.tag-1000, with: textfld.text!)
        textfld.resignFirstResponder()
    }
    
    @IBOutlet weak var nav: UINavigationBar!
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let textfld = self.view.viewWithTag(pickerView.tag-1000) as! UITextField
        if(currentarr[row] is String){
        textfld.text = currentarr[row] as? String
        }else{
            textfld.text = String(format:"%d",currentarr[row] as! Int)
        }
        textfld.resignFirstResponder()
    }
    

    @IBAction func saveproject(_ sender: AnyObject) {
        
        
        
        DispatchQueue.main.async(execute: {
            self.spinner.isHidden = false
            self.view.isUserInteractionEnabled = false
        })
        
        //print(data_dict)
        let payload = NSMutableString()
        payload.append("{")
        
        
        for (key, value) in data_dict {
            if(value is String){
                payload.append("\"\(key)\": \"\(value)\",")
            }else if(value is Int){
            payload.append("\"\(key)\": \(value),")
            }
        }
        var str = "\(payload)"
        payload.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
        payload.append("}")
        str = (payload as? String)!
        //print(str)


        let url = URL.init(string:String(format: "%@assets/LEED:%d/?recompute_score=1",credentials().domain_url, leedid))
        ////print(url?.absoluteURL)
        let subscription_key = credentials().subscription_key
        let token = UserDefaults.standard.object(forKey: "token") as! String
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "PUT"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let httpbody = str
        request.httpBody = httpbody.data(using: String.Encoding.utf8)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(session)
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
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
                    //self.tableview.reloadData()
                    // self.buildingactions(subscription_key, leedid: leedid)
                    DispatchQueue.main.async(execute: {
                            self.spinner.isHidden = true
                            self.view.isUserInteractionEnabled = true
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
    
    
    func updateproject(){
        let url = URL.init(string:String(format: "%@assets/LEED:%d/",credentials().domain_url,leedid))
        ////print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token!), forHTTPHeaderField:"Authorization" )
        let session = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(session)
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
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
                    let datakeyed = NSKeyedArchiver.archivedData(withRootObject: jsonDictionary)
                    UserDefaults.standard.set(datakeyed, forKey: "building_details")
                    UserDefaults.standard.synchronize()
                    UserDefaults.standard.set(0, forKey: "row")
                    DispatchQueue.main.async(execute: {
                        self.spinner.isHidden = true
                        self.view.isUserInteractionEnabled = true
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

    
    
    
    

}
