//
//  listofteams.swift
//  Arcskoru
//
//  Created by Group X on 10/02/17.
//
//

import UIKit

class listofteams: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
    var leedid = 0
    var teamarr = NSArray()
    var currentrole = ""
    var refresh = 0
    var rolesarr = NSMutableArray()
    var selectedemail = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
        self.spinner.hidden = true
        self.spinner.layer.cornerRadius = 5
        leedid = NSUserDefaults.standardUserDefaults().integerForKey("leed_id")
        let dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary
        
        self.navigationItem.title = dict["name"] as? String
        let add = UIBarButtonItem(barButtonSystemItem: .Add , target: self, action: #selector(add(_:)))
        self.navigationItem.rightBarButtonItem = add
        let notificationsarr = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("notifications") as! NSData) as! NSArray
        if(notificationsarr.count > 0 ){
            self.tabbar.items![4].badgeValue = "\(notificationsarr.count)"
        }else{
            self.tabbar.items![4].badgeValue = nil
        }
        self.tabbar.selectedItem = self.tabbar.items![3]
        
        dispatch_async(dispatch_get_main_queue(), {
        self.spinner.hidden = false
        self.getroles(self.leedid)
        })
        
        // Do any additional setup after loading the view.
    }

    
    func back(sender:UIBarButtonItem){
        NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"manage"])
    }
    
    @IBOutlet weak var spinner: UIView!
    
    @IBOutlet weak var tabbar: UITabBar!
    
    override func viewWillDisappear(animated: Bool) {
        
        var buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        self.navigationItem.title = buildingdetails["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as? String
    }
    
    
    override func viewDidAppear(animated: Bool) {
        token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        self.navigationController?.navigationBar.backItem?.title = "Manage"
        if(refresh == 1){
            leedid = NSUserDefaults.standardUserDefaults().integerForKey("leed_id")
            self.spinner.hidden = false
            self.getroles(leedid)
        }
        let indexPath = self.tableview.indexPathForSelectedRow
        if(indexPath != nil){
            self.tableview.deselectRowAtIndexPath(indexPath!, animated:true)
        }
        
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "Teams"
        }
        return ""
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 15
        }
        return 1
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    @IBAction func add(sender: AnyObject) {
        let alertController = UIAlertController(title: "Add New user", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            self.adduser(firstTextField.text! )
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter the user email ID to add"
        }
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func adduser(mailID:String){
        let payload = NSMutableString()
        payload.appendString("{")
        payload.appendString("\"user_email\":\"\(mailID)\",")
        payload.appendString("\"Reltyp\":\"ZRPO81\"")
        payload.appendString("}")
        let str = payload as String
        print(str)
        
        
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/teams/",credentials().domain_url, leedid))
        print(url?.absoluteURL)
        let subscription_key = credentials().subscription_key
        let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let httpbody = str
        request.HTTPBody = httpbody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
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
                    var jsonDictionary = NSDictionary()
                    do{
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        print(jsonDictionary)
                    }catch{
                    }
                }else{
                    print(data)
                    var jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        print(jsonDictionary)
                        //self.tableview.reloadData()
                        // self.buildingactions(subscription_key, leedid: leedid)
                        print("Successfully updated")
                        self.getteamdata(self.leedid)
                        
                    } catch {
                        print(error)
                    }
            }
            
        }
        task.resume()
        
    }
    
    
    
    func getroles(leedid:Int){
        //
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/teams/roles/",credentials().domain_url,leedid))
        print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
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
                }else{
                    print(data)
                    var jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        print(jsonDictionary)
                        self.rolesarr = (jsonDictionary["EtZstrRole"] as! NSArray).mutableCopy() as! NSMutableArray
                        let temparr = NSMutableArray()
                        for i in 0..<self.rolesarr.count{
                            let dict = self.rolesarr.objectAtIndex(i) as! NSDictionary
                            if((dict["Rtitl"] as! String) .containsString("ARC")){
                                temparr.addObject(dict)
                            }
                        }
                        self.rolesarr = temparr
                        
                        self.getteamdata(leedid)
                        
                    } catch {
                        print(error)
                    }
            }
            
        }
        task.resume()
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "gotoexploreview"){
            let vc = segue.destinationViewController as! teamrole
            vc.rolesarr = rolesarr
            vc.email = selectedemail
            vc.currentrole = currentrole
        }
    }
    
    
    func getteamdata(leedid:Int){
        //
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/teams/",credentials().domain_url,leedid))
        print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
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
                }else{
                    print(data)
                    var jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        print(jsonDictionary)
                        self.teamarr = jsonDictionary["EtTeamMembers"] as! NSArray
                        let temparr = NSMutableArray()
                        for i in 0..<self.teamarr.count{
                            let dict = self.teamarr.objectAtIndex(i) as! NSDictionary
                            if((dict["Roledescription"] as! String) .containsString("ARC") || (dict["Roledescription"] as! String) .containsString("PROJECT ADMIN")){
                                temparr.addObject(dict)
                            }
                        }
                        self.teamarr = temparr
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.spinner.hidden = true
                            self.tableview.reloadData()
                        })
                        
                    } catch {
                        print(error)
                    }
            }
            
        }
        task.resume()
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
    
    func showalert(message:String, title:String, action:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                self.view.userInteractionEnabled = true
                self.navigationController?.popViewControllerAnimated(true)
                
            })
            
        }
        let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return teamarr.count
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    // #warning Incomplete implementation, return the number of rows
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        
        if(indexPath.row == 2){
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }else{
            cell?.accessoryType = UITableViewCellAccessoryType.None
        }
        var dict = teamarr.objectAtIndex(indexPath.section) as! [String:AnyObject]
        let name = String(format:"%@ %@",dict["Firstname"] as! String,dict["Lastname"] as! String)
        
        if(indexPath.row == 0){
            cell?.userInteractionEnabled = false
            cell?.textLabel?.text = "Name"
            cell?.detailTextLabel?.text = name
        }else if(indexPath.row == 1){
            cell?.userInteractionEnabled = false
            cell?.textLabel?.text = "Email"
            cell?.detailTextLabel?.text = dict["email"] as? String
        }
        else if(indexPath.row == 2){
            cell?.userInteractionEnabled = true
            cell?.textLabel?.text = "Role Description"
            cell?.detailTextLabel?.text = (dict["Roledescription"] as! String).capitalizedString
            if(cell?.detailTextLabel?.text == "Project Admin"){
                cell?.userInteractionEnabled = false
                cell?.accessoryType = UITableViewCellAccessoryType.None
            }else{
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let dict = teamarr.objectAtIndex(indexPath.section) as! NSDictionary
        selectedemail = dict["email"] as! String
        currentrole = dict["Roledescription"] as! String
        self.performSegueWithIdentifier("gotoexploreview", sender: nil)
    }

    
    @IBOutlet weak var tableview: UITableView!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
