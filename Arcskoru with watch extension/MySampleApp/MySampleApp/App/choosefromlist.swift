//
//  choosefromlist.swift
//  Arcskoru
//
//  Created by Group X on 07/02/17.
//
//

import UIKit

class choosefromlist: UIViewController, UITableViewDataSource , UITableViewDelegate, UITabBarDelegate {
var data_dict = NSMutableDictionary()
    var currentcontext = ""
    var leedid = NSUserDefaults.standardUserDefaults().integerForKey("leed_id")
    var pickerarr = NSArray()
    var currentselected = 0
    var tempselected = 0
    var selectedarr = NSMutableArray()
    var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
    var download_requests = [NSURLSession]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
        self.spinner.layer.cornerRadius = 5
        self.spinner.hidden = true
        //context.text = currentcontext
        tableview.allowsSelection = true
        tableview.allowsMultipleSelection = false
        for i in 0..<pickerarr.count {
            var str = pickerarr.objectAtIndex(i) as! String
            if(currentcontext == "Space Type"){
            if(str == data_dict["spaceType"] as! String){
                currentselected = i
                break
            }
            }
            if(currentcontext == "Other certification programs pursued"){
                if(data_dict["OtherCertProg"] is NSNull){
                }else{
                    if(str == data_dict["OtherCertProg"] as! String){
                        currentselected = i
                        break
                    }
                }
            }
        }
        
        tempselected = currentselected
        let notificationsarr = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("notifications") as! NSData) as! NSArray
        if(notificationsarr.count > 0 ){
            self.tabbar.items![4].badgeValue = "\(notificationsarr.count)"
        }else{
            self.tabbar.items![4].badgeValue = nil
        }
        self.tabbar.selectedItem = self.tabbar.items![3]
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var tabbar: UITabBar!
    override func viewDidAppear(animated: Bool) {
        token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        self.navigationController?.navigationBar.backItem?.title = "Manage project"
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
    
    @IBOutlet weak var spinner: UIView!
    @IBOutlet weak var tableview: UITableView!
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pickerarr.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")! as! UITableViewCell
        cell.textLabel?.text = pickerarr.objectAtIndex(indexPath.row) as! String
        cell.accessoryType = UITableViewCellAccessoryType.None
        if(currentcontext == "Unit Type"){
            if(data_dict["unitType"] != nil){
                if(data_dict["unitType"] as! String == "SI"){
                    if(indexPath.row == 0){
                       cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                    }else{
                       cell.accessoryType = UITableViewCellAccessoryType.None
                    }
                }else if(data_dict["unitType"] as! String == "IP"){
                    if(indexPath.row == 0){
                        cell.accessoryType = UITableViewCellAccessoryType.None
                    }else{
                        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                    }
                }
            }
        }else if(currentcontext == "Space Type"){
            if(indexPath.row == currentselected){
                        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
        }else if(currentcontext == "Other certification programs pursued"){
            if(indexPath.row == currentselected){
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
        }
        
        return cell
    }
    
    
    @IBAction func saveproject(selected: Int) {
        //{"name":"Test Auth","street":"2101 L Street NW","city":"Test city","state":"DC","country":"US","year_constructed":null,"gross_area":10000,"operating_hours":null,"occupancy":null,"confidential":false,"organization":null,"ownerType":null,"IsLovRecert":false,"PrevCertProdId":null,"OtherCertProg":null,"IsResidential":false,"noOfResUnits":null,"AffiliatedHigherEduIns":false,"nameOfSchool":null,"noOfFloors":null,"intentToPrecertify":false,"targetCertDate":null,"populationDayTime":null,"populationNightTime":null,"manageEntityName":null,"manageEntityAdd1":null,"managEntityAdd2":null,"manageEntityCity":null,"manageEntityState":null,"manageEntityCountry":null,"unitType":"IP"}
        
        
        dispatch_async(dispatch_get_main_queue(), {
            self.spinner.hidden = false
            self.view.userInteractionEnabled = false
        })
        
        print(data_dict)
        var payload = NSMutableString()
        payload.appendString("{")
        
        
        for (key, value) in data_dict {
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
        
        
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/?recompute_score=1",credentials().domain_url, leedid))
        print(url?.absoluteURL)
        var subscription_key = credentials().subscription_key
        var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "PUT"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var httpbody = str
        request.HTTPBody = httpbody.dataUsingEncoding(NSUTF8StringEncoding)
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
    func updateproject(){
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/",credentials().domain_url,leedid))
        print(url?.absoluteURL)
        
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
                            self.tempselected = self.currentselected
                            self.tableview.reloadData()
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

    
    func showalert(message:String, title:String, action:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                self.spinner.hidden = true
                self.currentselected = self.tempselected
                self.tableview.reloadData()
                self.view.userInteractionEnabled = true
            self.navigationController?.popViewControllerAnimated(true)
                
            })
            
        }
        let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath)! as! UITableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        print(currentcontext)
        selectedarr.addObject(pickerarr.objectAtIndex(indexPath.row) as! String)
        dispatch_async(dispatch_get_main_queue(), {
            self.currentselected = indexPath.row
            if(self.currentcontext == "Unit Type"){
                self.data_dict["unitType"] = self.pickerarr.objectAtIndex(self.currentselected) as! String
            }else if(self.currentcontext == "Space Type"){
                self.data_dict["spaceType"] = self.pickerarr.objectAtIndex(self.currentselected) as! String
            }else if(self.currentcontext == "Other certification programs pursued"){
                self.data_dict["OtherCertProg"] = self.pickerarr.objectAtIndex(self.currentselected) as! String
            }
            
            self.spinner.hidden = false
            self.saveproject(indexPath.row)
        })
        tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        for request in download_requests
        {
            request.invalidateAndCancel()
        }
        var    buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        self.navigationItem.title = buildingdetails["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as? String
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
            data_dict["unitType"] = ""
        var cell = tableView.cellForRowAtIndexPath(indexPath)! as! UITableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.None
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return currentcontext
    }
    
    @IBOutlet weak var context: UILabel!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func done(sender: AnyObject) {
    }
    
    @IBOutlet weak var picker: UIPickerView!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

