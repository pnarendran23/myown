//
//  listofteams.swift
//  Arcskoru
//
//  Created by Group X on 10/02/17.
//
//

import UIKit

class listofteams: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    var token = UserDefaults.standard.object(forKey: "token") as! String
    var leedid = 0
    var teamarr = NSArray()
    var currentrole = ""
    var refresh = 0
    var rolesarr = NSMutableArray()
    var selectedemail = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assigncontainer.isHidden = true
        self.titlefont()
        self.rolepicker.delegate = self
        self.spinner.isHidden = true
        self.spinner.layer.cornerRadius = 5
        leedid = UserDefaults.standard.integer(forKey: "leed_id")
        let dict = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary
        
        self.navigationItem.title = dict["name"] as? String
        let add = UIBarButtonItem(barButtonSystemItem: .add , target: self, action: #selector(add(_:)))
        self.navigationItem.rightBarButtonItem = add
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
        
        DispatchQueue.main.async(execute: {
        self.spinner.isHidden = false
        self.getroles(self.leedid)
        })
        
        // Do any additional setup after loading the view.
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(row == rolesarr.count){
            return "None"
        }
        let dict = rolesarr.object(at: row) as! NSDictionary
        var str = ""
        if(dict["Reltyp"] as? String == "ZRPO03"){
            str = "Administrator"
        }else if(dict["Reltyp"] as? String == "ZRPO04"){
            str = "Team Member"
        }else if(dict["Reltyp"] as? String == "ZRPO81"){
            str = "Team Member"
        }else if(dict["Reltyp"] as? String == "ZRPO34"){
            str = "Team Manager"
        }else if(dict["Reltyp"] as? String == "ZRPO80"){
            str = "Administrator"
        }else if(dict["Reltyp"] as? String == "ZRPO82"){
            str = "Team Manager"
        }
        return str
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rolesarr.count + 1
    }
    
    
    func back(_ sender:UIBarButtonItem){
        NotificationCenter.default.post(name: Notification.Name(rawValue: "performsegue"), object: nil, userInfo: ["seguename":"manage"])
    }
    
    @IBOutlet weak var spinner: UIView!
    
    @IBOutlet weak var tabbar: UITabBar!
    
    @IBOutlet weak var assignnav: UINavigationBar!
    override func viewWillDisappear(_ animated: Bool) {
        
        var buildingdetails = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.navigationItem.title = buildingdetails["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as? String
    }
    @IBAction func assigncancel(_ sender: Any) {
        self.assigncontainer.isHidden = true
    }
    
    @IBAction func assignsave(_ sender: Any) {
        let row = self.rolepicker.selectedRow(inComponent: 0)
        if(row == rolesarr.count){
            DispatchQueue.main.async(execute: {
                self.assigncontainer.isHidden = true
                self.view.isUserInteractionEnabled = false
                self.spinner.isHidden = false
                self.delrole("", type:self.currentID)
            })
        }else{
            let dict = rolesarr.object(at: row) as! NSDictionary
            DispatchQueue.main.async(execute: {
                self.assigncontainer.isHidden = true
                self.view.isUserInteractionEnabled = false
                self.spinner.isHidden = false
                self.saverole(dict["Rtitl"] as! String, type:dict["Reltyp"] as! String)
            })
            
        }
   
    }
    
    @IBOutlet weak var assigncontainer: UIView!
    
    @IBOutlet weak var rolepicker: UIPickerView!
    override func viewDidAppear(_ animated: Bool) {
        token = UserDefaults.standard.object(forKey: "token") as! String
        self.navigationController?.navigationBar.backItem?.title = "More"
        if(refresh == 1){
            leedid = UserDefaults.standard.integer(forKey: "leed_id")
            self.spinner.isHidden = false
            self.getroles(leedid)
        }
        let indexPath = self.tableview.indexPathForSelectedRow
        if(indexPath != nil){
            self.tableview.deselectRow(at: indexPath!, animated:true)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "Team"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 15
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    @IBAction func add(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Add new user", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        let saveAction = UIAlertAction(title:"Save", style: .default, handler: { (action) -> Void in
            let str = alert.textFields![0] as UITextField
            DispatchQueue.main.async(execute: {
                self.spinner.isHidden = false
                self.view.isUserInteractionEnabled = false
                self.adduser(str.text!)
            })
        })
        alert.addAction(saveAction)
        saveAction.isEnabled = false
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "E-mail ID"
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                saveAction.isEnabled = self.isValidEmail(testStr: textField.text!)
            }
        })
        alert.view.subviews.first?.backgroundColor = UIColor.white
        present(alert, animated: true, completion: nil)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    func adduser(_ mailID:String){
        let payload = NSMutableString()
        payload.append("{")
        payload.append("\"user_email\":\"\(mailID)\",")
        payload.append("\"Reltyp\":\"ZRPO81\"")
        payload.append("}")
        let str = payload as String
        //print(str)
        
        
        let url = URL.init(string:String(format: "%@assets/LEED:%d/teams/",credentials().domain_url, leedid))
        print(url?.absoluteString)
        print(str)
        let subscription_key = credentials().subscription_key
        let token = UserDefaults.standard.object(forKey: "token") as! String
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "POST"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let httpbody = str
        request.httpBody = httpbody.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            if let httpStatus = response as? HTTPURLResponse{
                print(httpStatus.statusCode)
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
                    var jsonDictionary = NSDictionary()
                    do{
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        print(jsonDictionary)
                        if(jsonDictionary["error"] != nil){
                            if let snapshotValue = jsonDictionary["error"] as? NSArray, let currentcountr = snapshotValue[0] as? NSDictionary, let currentstat = currentcountr["message"] as? String {
                                
                                let alertController = UIAlertController(title: "Invalid email ID", message: currentstat, preferredStyle: .alert)
                                let callActionHandler = { (action:UIAlertAction!) -> Void in
                                DispatchQueue.main.async(execute: {
                                    self.view.isUserInteractionEnabled = true
                                    self.spinner.isHidden = true
                                    self.view.isUserInteractionEnabled = true
                                    //self.navigationController?.popViewControllerAnimated(true)
                                })
                                
                                 }
                                let ok = UIAlertAction.init(title: "OK", style: .default, handler: callActionHandler)
                                alertController.addAction(ok)
                                alertController.view.subviews.first?.backgroundColor = UIColor.white
        alertController.view.layer.cornerRadius = 10
        alertController.view.layer.masksToBounds = true
                                self.present(alertController, animated: true, completion: nil)
                            }else{
                                let alertController = UIAlertController(title: "Error", message: "Something went wrong. Please try again later", preferredStyle: .alert)
                                let callActionHandler = { (action:UIAlertAction!) -> Void in
                                    DispatchQueue.main.async(execute: {
                                        self.view.isUserInteractionEnabled = true
                                        self.spinner.isHidden = true
                                        self.view.isUserInteractionEnabled = true
                                        //self.navigationController?.popViewControllerAnimated(true)
                                    })
                                    
                                }
                                let ok = UIAlertAction.init(title: "OK", style: .default, handler: callActionHandler)
                                alertController.addAction(ok)
                                alertController.view.subviews.first?.backgroundColor = UIColor.white
        alertController.view.layer.cornerRadius = 10
        alertController.view.layer.masksToBounds = true
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }else{
                            let alertController = UIAlertController(title: "Error", message: "Something went wrong. Please try again later", preferredStyle: .alert)
                            let callActionHandler = { (action:UIAlertAction!) -> Void in
                                DispatchQueue.main.async(execute: {
                                    self.view.isUserInteractionEnabled = true
                                    self.spinner.isHidden = true
                                    self.view.isUserInteractionEnabled = true
                                    //self.navigationController?.popViewControllerAnimated(true)
                                })
                                
                            }
                            let ok = UIAlertAction.init(title: "OK", style: .default, handler: callActionHandler)
                            alertController.addAction(ok)
                            alertController.view.subviews.first?.backgroundColor = UIColor.white
        alertController.view.layer.cornerRadius = 10
        alertController.view.layer.masksToBounds = true
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }catch{
                    }
                }else{
                    
                    var jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        //print(jsonDictionary)
                        //self.tableview.reloadData()
                        // self.buildingactions(subscription_key, leedid: leedid)
                        //print("Successfully updated")
                        self.getteamdata(self.leedid)
                        
                    } catch {
                        //print(error)
                    }
            }
            
        }) 
        task.resume()
        
    }
    
    
    
    func getroles(_ leedid:Int){
        //
        let url = URL.init(string:String(format: "%@assets/LEED:%d/teams/roles/",credentials().domain_url,leedid))
        ////print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
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
                }else{
                    
                    var jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        //print(jsonDictionary)
                        DispatchQueue.main.async(execute: {
                        self.rolesarr = (jsonDictionary["EtZstrRole"] as! NSArray).mutableCopy() as! NSMutableArray
                        let temparr = NSMutableArray()
                        for i in 0..<self.rolesarr.count{
                            let dict = self.rolesarr.object(at: i) as! NSDictionary
                            if((dict["Rtitl"] as! String) .contains("ARC")){
                                temparr.add(dict)
                            }
                        }
                        self.rolesarr = temparr
                        self.getteamdata(leedid)
                        })
                    } catch {
                        //print(error)
                    }
            }
            
        }) 
        task.resume()
        
    }
    var status = ""
    var currentID = ""
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "gotoexploreview"){
            let vc = segue.destination as! teamrole
            vc.rolesarr = rolesarr
            vc.email = selectedemail
            vc.status = status
            vc.currentrole = currentrole
            vc.currentID = currentID
        }
    }
    
    
    func getteamdata(_ leedid:Int){
        //
        let url = URL.init(string:String(format: "%@assets/LEED:%d/teams/",credentials().domain_url,leedid))
        ////print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
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
                }else{
                    
                    var jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        //print(jsonDictionary)
                        self.teamarr = jsonDictionary["EtTeamMembers"] as! NSArray
                        let temparr = NSMutableArray()
                        for i in 0..<self.teamarr.count{
                            let dict = self.teamarr.object(at: i) as! NSDictionary
                            if((dict["Roledescription"] as! String) .contains("ARC") || (dict["Roledescription"] as! String) .contains("PROJECT ADMIN")){
                                temparr.add(dict)
                            }
                        }
                        self.teamarr = temparr
                        
                        DispatchQueue.main.async(execute: {
                            self.spinner.isHidden = true
                            self.tableview.reloadData()
                        })
                        
                    } catch {
                        //print(error)
                    }
            }
            
        }) 
        task.resume()
    }
    
    func tabBar(_ tabBar: UITabBar, didSelectItem item: UITabBarItem) {
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.view.isUserInteractionEnabled = true
        return teamarr.count
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    // #warning Incomplete implementation, return the number of rows
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if(indexPath.row == 2){
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }else{
            cell?.accessoryType = UITableViewCellAccessoryType.none
        }
        var dict = (teamarr.object(at: indexPath.section) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        let name = String(format:"%@ %@",dict["Firstname"] as! String,dict["Lastname"] as! String)
        
        if(indexPath.row == 0){
            cell?.isUserInteractionEnabled = false
            cell?.textLabel?.text = "Name"
            cell?.detailTextLabel?.text = name
        }else if(indexPath.row == 1){
            cell?.isUserInteractionEnabled = false
            cell?.textLabel?.text = "Email"
            cell?.detailTextLabel?.text = dict["email"] as? String
        }
        else if(indexPath.row == 2){
            cell?.isUserInteractionEnabled = true
            cell?.textLabel?.text = "Authorization level"
            
            
            cell?.detailTextLabel?.text = (dict["Roledescription"] as! String).capitalized
            
            if(cell?.detailTextLabel?.text == "Project Admin"){
                cell?.accessoryType = UITableViewCellAccessoryType.none
            }else{
                cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
            
            if let s = dict["Roledescription"] as? String{
                if(s.lowercased().contains("team member")){
                    cell?.detailTextLabel?.text = "Team Member"
                }else if(s.lowercased().contains("team manager")){
                    cell?.detailTextLabel?.text = "Team Manager"
                }
            }
            
            if let status = dict["Rolestatus"] as? String{
                if(status == "Deactivated Relationship"){
                    cell?.detailTextLabel?.text = "None"
                }
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if(cell?.detailTextLabel?.text == "Project Admin"){
            self.maketoast("Project should at least one admin", type: "error")
        }else{
        tableView.deselectRow(at: indexPath, animated: true)
        let dict = teamarr.object(at: indexPath.section) as! NSDictionary
        selectedemail = dict["email"] as! String
        currentrole = dict["Roledescription"] as! String
        status = dict["Rolestatus"] as! String
        currentID = dict["Roleid"] as! String
        self.assigncontainer.isHidden = false
        self.rolepicker.reloadComponent(0)
        }
        //self.performSegue(withIdentifier: "gotoexploreview", sender: nil)
    }

    
    @IBOutlet weak var tableview: UITableView!

    
    func delrole(_ role:String, type:String){
        //
        let payload = NSMutableString()
        payload.append("{")
        payload.append("\"user_email\":\"\(selectedemail)\",")
        payload.append("\"Responsibility\":\"\(leedid)\",")
        payload.append("\"Reltyp\":\"\(type)\"")
        payload.append("}")
        let str = payload as String
        //print(str)
        
        
        let url = URL.init(string:String(format: "%@assets/LEED:%d/teams/update/",credentials().domain_url, leedid))
        ////print(url?.absoluteURL)
        let subscription_key = credentials().subscription_key
        let token = UserDefaults.standard.object(forKey: "token") as! String
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "DELETE"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let httpbody = str
        request.httpBody = httpbody.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
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
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{           // check for http errors
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                    DispatchQueue.main.async(execute: {
                        self.view.isUserInteractionEnabled = true
                        self.spinner.isHidden = true
                    })
                    var jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        //print(jsonDictionary)
                        self.refresh = 0
                        //self.tableview.reloadData()
                        // self.buildingactions(subscription_key, leedid: leedid)
                        DispatchQueue.main.async(execute: {
                            self.view.isUserInteractionEnabled = true
                            self.spinner.isHidden = true
                        })
                        DispatchQueue.main.async(execute: {
                            
                            if let snapshotValue = jsonDictionary["error"] as? NSArray, let err = snapshotValue[0] as? NSDictionary, let message = err["message"] as? String {
                                self.showalert(message, title: "Error", action: "OK")
                            }
                            
                            
                            
                            
                        })
                        
                    } catch {
                        //print(error)
                    }
                }else{
                    
                    var jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        //print(jsonDictionary)
                        //self.tableview.reloadData()
                        // self.buildingactions(subscription_key, leedid: leedid)
                        //self.maketoast("Role has been assigned successfuly")
                        DispatchQueue.main.async(execute: {
                            self.refresh = 1
                            self.maketoast(jsonDictionary["result"] as! String, type: "message")
                            self.getroles(self.leedid)
                            //self.showalert("Role has been assigned successfully", title: "Success", action: "OK")
                        })
                        
                        
                    } catch {
                        //print(error)
                    }
            }
            
        })
        task.resume()
        
    }
    
    
    func saverole(_ role:String, type:String){
        //
        let payload = NSMutableString()
        payload.append("{")
        payload.append("\"user_email\":\"\(selectedemail)\",")
        payload.append("\"Reltyp\":\"\(type)\"")
        payload.append("}")
        let str = payload as String
        //print(str)
        
        
        let url = URL.init(string:String(format: "%@assets/LEED:%d/teams/update/",credentials().domain_url, leedid))
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
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
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
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{           // check for http errors
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                    DispatchQueue.main.async(execute: {
                        self.view.isUserInteractionEnabled = true
                        self.spinner.isHidden = true
                    })
                    var jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        //print(jsonDictionary)
                        self.refresh = 0
                        //self.tableview.reloadData()
                        // self.buildingactions(subscription_key, leedid: leedid)
                        DispatchQueue.main.async(execute: {
                            self.view.isUserInteractionEnabled = true
                            self.spinner.isHidden = true
                        })
                        DispatchQueue.main.async(execute: {
                            
                            if let snapshotValue = jsonDictionary["error"] as? NSArray, let err = snapshotValue[0] as? NSDictionary, let message = err["message"] as? String {
                                self.showalert(message, title: "Error", action: "OK")
                            }
                            
                            
                            
                            
                        })
                        
                    } catch {
                        //print(error)
                    }
                }else{
                    
                    var jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        //print(jsonDictionary)
                        //self.tableview.reloadData()
                        // self.buildingactions(subscription_key, leedid: leedid)
                        //self.maketoast("Role has been assigned successfuly")
                        DispatchQueue.main.async(execute: {
                            self.getroles(self.leedid)
                            
                            //self.showalert("Role has been assigned successfully", title: "Success", action: "OK")
                        })
                        
                        
                    } catch {
                        //print(error)
                    }
            }
            
        }) 
        task.resume()
        
    }
    
    
    // MARK: - Navigation
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "gotoexploreview"){
            let v = segue.destination as! teamrole
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 
*/
}
