//
//  manageparking.swift
//  Arcskoru
//
//  Created by Group X on 30/03/17.
//
//

import UIKit

class manageparking: UIViewController,UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UITextViewDelegate, UITabBarDelegate {
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var tabbar: UITabBar!
    var leftdetail = NSMutableArray()
    var download_requests = [NSURLSession]()
    var task = NSURLSessionTask()
    var rightdetail = NSMutableArray()
    var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
    var dict = NSMutableDictionary()
    
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if(item.title == "Manage project"){
            NSNotificationCenter.defaultCenter().postNotificationName("performrootsegue", object: nil, userInfo: ["seguename":"parkmanage"])
        }else{
            NSNotificationCenter.defaultCenter().postNotificationName("performrootsegue", object: nil, userInfo: ["seguename":"parkbilling"])
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabbar.delegate = self
        self.tabbar.items![0].title = "Manage project"
        self.tabbar.items![1].title = "Billing"
        self.tabbar.selectedItem = self.tabbar.items![0]
        self.spinner.hidden = true
        self.spinner.layer.cornerRadius = 5
        tableview.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        self.tableview.contentSize = CGSizeMake(self.tableview.frame.size.width, self.view.frame.size.height)
        tableview.registerNib(UINib.init(nibName: "manageprojcellwithswitch", bundle: nil), forCellReuseIdentifier: "manageprojcellwithswitch")
        tableview.registerNib(UINib.init(nibName: "manageprojcell", bundle: nil), forCellReuseIdentifier: "manageprojcell")
        tableview.registerNib(UINib.init(nibName: "textcell", bundle: nil), forCellReuseIdentifier: "textcell")
        dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData)?.mutableCopy() as! NSMutableDictionary
        self.navigationItem.title = dict["name"] as! String
        print(dict)
        datepicker.maximumDate = NSDate()
        dateview.hidden = true
        print("total count ",dict.allKeys.count,dict)
        
        print(dict)        
        self.navigationItem.title = dict["name"] as? String
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "OpenSans", size: 17)!, NSForegroundColorAttributeName : UIColor.whiteColor()]
        tableview.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    func showalert(message:String, title:String, action:String){
        
        //let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        //let callActionHandler = { (action:UIAlertAction!) -> Void in
        dispatch_async(dispatch_get_main_queue(), {
            self.view.userInteractionEnabled = true
            self.spinner.hidden = true
            self.view.userInteractionEnabled = true
            self.maketoast(message, type: "error")
            //self.navigationController?.popViewControllerAnimated(true)
        })
        
        //        }
        //      let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        //    alertController.addAction(defaultAction)
        
        //presentViewController(alertController, animated: true, completion: nil)
        
        
    }

    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            if(textView.text != "Please tell us about your project in about 200 words" && textView.text != ""){
                dict["projectInfo"] = textView.text
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 18
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("manageprojcell")! as! manageprojcell
            cell.alpha = 1.0
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.contentView.alpha = cell.alpha
            cell.textLabel?.numberOfLines = 3
            cell.textLabel?.text = "Name"
            if(dict["name"] != nil && (dict["name"] as? String)?.characters.count > 0){
            cell.detailTextLabel?.text = dict["name"] as? String
            cell.detailTextLabel?.textColor = UIColor.blackColor()
            }else{
            cell.detailTextLabel?.text = "Not available"
            }
            return cell
        }else if(indexPath.row == 1){
            let cell = tableView.dequeueReusableCellWithIdentifier("manageprojcell")! as! manageprojcell
            cell.textLabel?.text = "Project ID"
            cell.alpha = 0.6
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.contentView.alpha = cell.alpha
            cell.textLabel?.numberOfLines = 3
            cell.detailTextLabel?.textColor = UIColor.blackColor()
            if(dict["leed_id"] != nil){
                cell.detailTextLabel?.text = "\(dict["leed_id"] as! Int)"
            }else{
                cell.detailTextLabel?.text = "Not available"
            }
            return cell
        }else if(indexPath.row == 2){
            let cell = tableView.dequeueReusableCellWithIdentifier("manageprojcell")! as! manageprojcell
            cell.textLabel?.text = "Registration Date"
            cell.alpha = 0.6
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.contentView.alpha = cell.alpha
            cell.textLabel?.numberOfLines = 3
            cell.detailTextLabel?.textColor = UIColor.blackColor()
            if(dict["created_at"] != nil && (dict["created_at"] as? String)?.characters.count > 0){
                let dateFormatter: NSDateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
                var date = dateFormatter.dateFromString(dict["created_at"] as! String)! as! NSDate
                dateFormatter.dateFormat = "MM/dd/yyyy"
                cell.detailTextLabel?.text = dateFormatter.stringFromDate(date)
            }else{
                cell.detailTextLabel?.text = "Not available"
            }
            return cell
        }else if(indexPath.row == 3){
            let cell = tableView.dequeueReusableCellWithIdentifier("manageprojcell")! as! manageprojcell
            cell.textLabel?.text = "Address"
            cell.alpha = 0.6
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.contentView.alpha = cell.alpha
            cell.textLabel?.numberOfLines = 3
            cell.detailTextLabel?.textColor = UIColor.blackColor()
            if(dict["street"] != nil && (dict["street"] as? String)?.characters.count > 0){
                cell.detailTextLabel?.text = dict["street"] as? String
            }else{
                cell.detailTextLabel?.text = "Not available"
            }
            return cell
        }else if(indexPath.row == 4){
            let cell = tableView.dequeueReusableCellWithIdentifier("manageprojcell")! as! manageprojcell
            cell.alpha = 0.6
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.contentView.alpha = cell.alpha
            cell.textLabel?.text = "City"
            cell.textLabel?.numberOfLines = 3
            cell.detailTextLabel?.textColor = UIColor.blackColor()
            if(dict["city"] != nil && (dict["city"] as? String)?.characters.count > 0){
                cell.detailTextLabel?.text = dict["city"] as? String
            }else{
                cell.detailTextLabel?.text = "Not available"
            }
            return cell
        }else if(indexPath.row == 5){
            let cell = tableView.dequeueReusableCellWithIdentifier("manageprojcell")! as! manageprojcell
            cell.alpha = 0.6
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.contentView.alpha = cell.alpha
            cell.detailTextLabel?.textColor = UIColor.blackColor()
            cell.textLabel?.text = "State"
            cell.textLabel?.numberOfLines = 3
            if(dict["state"] != nil && (dict["state"] as? String)?.characters.count > 0){
                cell.detailTextLabel?.text = dict["state"] as? String
            }else{
                cell.detailTextLabel?.text = "Not available"
            }
            return cell
        }else if(indexPath.row == 6){
            let cell = tableView.dequeueReusableCellWithIdentifier("manageprojcell")! as! manageprojcell
            cell.alpha = 0.6
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.contentView.alpha = cell.alpha
            cell.textLabel?.text = "Country"
            cell.detailTextLabel?.textColor = UIColor.blackColor()
            cell.textLabel?.numberOfLines = 3
            if(dict["country"] != nil && (dict["country"] as? String)?.characters.count > 0){
                cell.detailTextLabel?.text = dict["country"] as? String
            }else{
                cell.detailTextLabel?.text = "Not available"
            }
            return cell
        }else if(indexPath.row == 7){
            let cell = tableView.dequeueReusableCellWithIdentifier("manageprojcellwithswitch")! as! manageprojcellwithswitch
            cell.alpha = 1.0
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.contentView.alpha = cell.alpha
            cell.lbl.text = ""
            cell.yesorno.tag = indexPath.row
            cell.yesorno.addTarget(self, action: #selector(self.switchused(_:)), forControlEvents: UIControlEvents.ValueChanged)
            cell.detailTextLabel?.textColor = UIColor.blackColor()
            cell.textLabel?.font = UIFont.init(name: "OpenSans", size: 13)
            cell.textLabel?.numberOfLines = 3
            //cell.textLabel?.text = key
            cell.textLabel?.text = "Private"
            cell.textLabel?.numberOfLines = 3
            if(dict["confidential"] != nil && (dict["confidential"] as? Bool)!){
                cell.yesorno.on = (dict["confidential"] as? Bool)!
            }else{
                cell.yesorno.on = false
            }
            
            /*if(dict["IsLovRecert"] != nil && (dict["IsLovRecert"] as? String)?.characters.count > 0){
             cell.detailTextLabel?.text = dict["IsLovRecert"] as? String
             }else{
             cell.detailTextLabel?.text = "Not available"
             }*/
            return cell
        }else if(indexPath.row == 8){
            let cell = tableView.dequeueReusableCellWithIdentifier("manageprojcell")! as! manageprojcell
            cell.alpha = 0.6
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.contentView.alpha = cell.alpha
            cell.textLabel?.text = "Owner Type"
            cell.detailTextLabel?.textColor = UIColor.blackColor()
            cell.textLabel?.numberOfLines = 3
            if(dict["ownerType"] != nil && (dict["ownerType"] as? String)?.characters.count > 0){
                cell.detailTextLabel?.text = dict["ownerType"] as? String
            }else{
                cell.detailTextLabel?.text = "Not available"
            }
            return cell
        }else if(indexPath.row == 9){
            let cell = tableView.dequeueReusableCellWithIdentifier("manageprojcell")! as! manageprojcell
            cell.alpha = 0.6
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.detailTextLabel?.textColor = UIColor.blackColor()
            cell.contentView.alpha = cell.alpha
            cell.textLabel?.text = "Owner Organization"
            cell.textLabel?.numberOfLines = 3
            if(dict["organization"] != nil && (dict["organization"] as? String)?.characters.count > 0){
                cell.detailTextLabel?.text = dict["organization"] as? String
            }else{
                cell.detailTextLabel?.text = "Not available"
            }
            return cell
        }else if(indexPath.row == 10){
            let cell = tableView.dequeueReusableCellWithIdentifier("manageprojcell")! as! manageprojcell
            cell.alpha = 0.6
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.detailTextLabel?.textColor = UIColor.blackColor()
            cell.contentView.alpha = cell.alpha
            cell.textLabel?.text = "Owner Email"
            cell.textLabel?.numberOfLines = 3
            if(dict["owner_email"] != nil && (dict["owner_email"] as? String)?.characters.count > 0){
                cell.detailTextLabel?.text = dict["owner_email"] as? String
            }else{
                cell.detailTextLabel?.text = "Not available"
            }
            return cell
        }else if(indexPath.row == 11){
            let cell = tableView.dequeueReusableCellWithIdentifier("manageprojcell")! as! manageprojcell
            cell.alpha = 0.6
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.detailTextLabel?.textColor = UIColor.blackColor()
            cell.contentView.alpha = cell.alpha
            cell.textLabel?.text = "Owner Country"
            cell.textLabel?.numberOfLines = 3
            if(dict["country"] != nil && (dict["country"] as? String)?.characters.count > 0){
                cell.detailTextLabel?.text = dict["country"] as? String
            }else{
                cell.detailTextLabel?.text = "Not available"
            }
            return cell
        }else if(indexPath.row == 12){
            let cell = tableView.dequeueReusableCellWithIdentifier("manageprojcell")! as! manageprojcell
            cell.alpha = 1.0
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.contentView.alpha = cell.alpha
            cell.detailTextLabel?.textColor = UIColor.blackColor()
            cell.textLabel?.text = "Date Commissioned"
            var dateformat = NSDateFormatter()
            dateformat.dateFormat = "dd/MM/yyyy"
            print(dict["year_constructed"])
            if(dict["year_constructed"] != nil && dict["year_constructed"] as! String != ""){
            cell.detailTextLabel?.text = dateformat.stringFromDate(selected_date)
            }else{
            cell.detailTextLabel?.text = "Not available"
            }
            cell.textLabel?.numberOfLines = 3
            return cell
        }else if(indexPath.row == 13){
            let cell = tableView.dequeueReusableCellWithIdentifier("manageprojcell")! as! manageprojcell
            cell.alpha = 1.0
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.detailTextLabel?.textColor = UIColor.blackColor()
            cell.contentView.alpha = cell.alpha
            cell.textLabel?.text = "Number of parking spaces"
            cell.textLabel?.numberOfLines = 3
            if(dict["noOfParkingSpace"] != nil && (dict["noOfParkingSpace"] as? String)?.characters.count > 0){
                cell.detailTextLabel?.text = dict["noOfParkingSpace"] as? String
            }else{
                cell.detailTextLabel?.text = "Not available"
            }
            return cell
        }else if(indexPath.row == 14){
            let cell = tableView.dequeueReusableCellWithIdentifier("manageprojcell")! as! manageprojcell
            cell.alpha = 1.0
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.contentView.alpha = cell.alpha
            cell.detailTextLabel?.textColor = UIColor.blackColor()
            cell.textLabel?.text = "How many levels in your parking structure?"
            cell.textLabel?.numberOfLines = 3
            if(dict["noOfParkingLevels"] != nil && (dict["noOfParkingLevels"] as? String)?.characters.count > 0){
                cell.detailTextLabel?.text = dict["noOfParkingLevels"] as? String
            }else{
                cell.detailTextLabel?.text = "Not available"
            }
            return cell
        }else if(indexPath.row == 15){
            let cell = tableView.dequeueReusableCellWithIdentifier("manageprojcellwithswitch")! as! manageprojcellwithswitch
            cell.lbl.text = ""
            cell.alpha = 1.0
            cell.yesorno.tag = indexPath.row
            
            cell.yesorno.addTarget(self, action: #selector(self.switchused(_:)), forControlEvents: UIControlEvents.ValueChanged)
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.contentView.alpha = cell.alpha
            cell.detailTextLabel?.textColor = UIColor.blackColor()
            cell.textLabel?.font = UIFont.init(name: "OpenSans", size: 13)
            cell.textLabel?.numberOfLines = 3
            //cell.textLabel?.text = key
            cell.textLabel?.text = "Previously LEED Certified?"
            cell.textLabel?.numberOfLines = 3
            if(dict["IsLovRecert"] != nil && (dict["IsLovRecert"] as? Bool)!){
                cell.yesorno.on = (dict["IsLovRecert"] as? Bool)!
            }else{
                cell.yesorno.on = false
            }
            return cell
        }else if(indexPath.row == 16){
            let cell = tableView.dequeueReusableCellWithIdentifier("manageprojcell")! as! manageprojcell
            cell.alpha = 1.0
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.contentView.alpha = cell.alpha
            cell.textLabel?.text = "Project Website"
            cell.detailTextLabel?.textColor = UIColor.blackColor()
            cell.textLabel?.numberOfLines = 3
            if(dict["projectWebsite"] != nil && (dict["projectWebsite"] as? String)?.characters.count > 0){
                cell.detailTextLabel?.text = dict["projectWebsite"] as? String
            }else{
                cell.detailTextLabel?.text = "Not available"
            }
            return cell
        }else if(indexPath.row == 17){
            let cell = tableView.dequeueReusableCellWithIdentifier("textcell")! as! textcell
            cell.alpha = 1.0
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.contentView.alpha = cell.alpha
            cell.tview.delegate = self
            cell.textLabel?.numberOfLines = 3
            if(dict["projectInfo"] != nil && (dict["projectInfo"] as? String)?.characters.count > 0){
                cell.tview.text = dict["projectInfo"] as? String
            }else{
                cell.tview.text = "Please tell us about your project in about 200 words"
            }
            return cell
        }
        return UITableViewCell()
        
    }
    
    @IBOutlet weak var spinner: UIView!
    @IBAction func save(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
        self.spinner.hidden = false
            self.view.userInteractionEnabled = false
        })
        
        var payload = NSMutableString()
        payload.appendString("{")
        
        
        for (key, value) in dict {
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
        
        
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/?recompute_score=1",credentials().domain_url, dict["leed_id"] as! Int))
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
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/",credentials().domain_url,dict["leed_id"] as! Int))
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
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401{
                dispatch_async(dispatch_get_main_queue(), {
                    //self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                    
                })
                return
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

    
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        var ptintable = textView.superview!.convertPoint(textView.frame.origin, toView: self.tableview)
        var contentoffset = self.tableview.contentOffset
        contentoffset.y = (ptintable.y - textView.layer.frame.size.height)
        self.tableview.setContentOffset(contentoffset, animated: true)
        if(textView.text != "Please tell us about your project in about 200 words"){
            textView.text = dict["projectInfo"] as? String
        }else{
            textView.text = ""
        }
        return true
    }
    
    
    
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        if textView.superview?.superview is UITableViewCell {
            // touch.view is of type UIPickerView
            let cell = textView.superview?.superview as! UITableViewCell
            var indexPath = self.tableview.indexPathForCell(cell)!
            self.tableview.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
            if(textView.text != "Please tell us about your project in about 200 words" && textView.text != ""){
                dict["projectInfo"] = textView.text
            }else{
                textView.text = "Please tell us about your project in about 200 words"
            }
            
        }
        
        
        return true
    }
    
    
    @IBOutlet weak var dateview: UIView!
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dispatch_async(dispatch_get_main_queue(), {
            //dateview.hidden = false
            
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
                
            }else if(indexPath.row == 4){
                
            }else if(indexPath.row == 5){
                
            }else if(indexPath.row == 6){
                
            }else if(indexPath.row == 7){
                let cell = tableView.dequeueReusableCellWithIdentifier("manageprojcell")! as! manageprojcell
                cell.textLabel?.text = "confidential"
                cell.textLabel?.numberOfLines = 3
                //return cell
            }else if(indexPath.row == 8){
                
            }else if(indexPath.row == 9){
                
            }else if(indexPath.row == 10){
                
            }else if(indexPath.row == 11){
                
            }else if(indexPath.row == 12){
                var dateformat = NSDateFormatter()
                dateformat.dateFormat = "dd/MM/yyyy"
                print(self.dict["year_constructed"])
                if(self.dict["year_constructed"] != nil && self.dict["year_constructed"] as! String != ""){
                    self.datepicker.date = self.selected_date
                }else{
                    self.datepicker.date = NSDate()
                }
                
                
                self.dateview.hidden = false
            }else if(indexPath.row == 13){
                let cell = self.tableview.cellForRowAtIndexPath(indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != "Not available"){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }else if(indexPath.row == 14){
                let cell = self.tableview.cellForRowAtIndexPath(indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != "Not available"){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }else if(indexPath.row == 15){
                
            }else if(indexPath.row == 16){
                let cell = self.tableview.cellForRowAtIndexPath(indexPath)! as! manageprojcell
                if(cell.detailTextLabel?.text != "Not available"){
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: (cell.detailTextLabel?.text)!)
                }else{
                    self.showalert(indexPath.row, title: cell.textLabel!.text!, value: "")
                }
            }else if(indexPath.row == 17){
                let cell = tableView.dequeueReusableCellWithIdentifier("textcell")! as! textcell
                cell.tview.text = "projectInfo"
                cell.textLabel?.numberOfLines = 3
                //return cell
            }
            
            self.tableview.reloadData()
        })
    }
    
    func switchused(sender:UISwitch){
        //15 - prev leed , 7 - confidential
        if(sender.tag == 7){
            dict["confidential"] = sender.on
        }else{
            dict["IsLovRecert"] = sender.on
            if(sender.on){
                self.showalert(sender.tag, title: "Enter your previous LEED ID", value:  "")
            }
        }
    }
    
    
    @IBOutlet weak var datepicker: UIDatePicker!
    
    @IBAction func datechanged(sender: AnyObject) {
        
    }
    
    var selected_date = NSDate()
    
    @IBAction func datecancel(sender: AnyObject) {
        dateview.hidden = true
    }
    weak var AddAlertSaveAction: UIAlertAction?
    
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
                self.dict["name"] = txtfld.text
            }else if(index == 13){
                self.dict["noOfParkingSpace"] = txtfld.text
            }else if(index == 14){
                self.dict["noOfParkingLevels"] = txtfld.text
            }else if(index == 16){
                self.dict["projectWebsite"] = txtfld.text
            }else if(index == 15){
                self.dict["PrevCertProdId"] = txtfld.text
            }
            
            
            self.tableview.reloadData()
            //print(self.textField.text)
        })
            otherAction.enabled = false
            
            // save the other action to toggle the enabled/disabled state when the text changed.
            self.AddAlertSaveAction = otherAction

            
            
        self.alert.addAction(UIAlertAction(title: "cancel", style: UIAlertActionStyle.Cancel, handler:{ (UIAlertAction)in
            if(index == 15){
         let cell = self.tableview.cellForRowAtIndexPath(NSIndexPath.init(forRow: 15, inSection: 0)) as! manageprojcellwithswitch
           cell.yesorno.setOn(false, animated: true)
            }
        }))
        self.alert.addAction(otherAction)
            self.alert.textFields![0].text = value
            
        self.presentViewController(self.alert, animated: true, completion: {
            print("completion block")
        })
    })
    }
    
    
    @IBAction func datedone(sender: AnyObject) {
        selected_date = datepicker.date
        var dateformat = NSDateFormatter()
        dateformat.dateFormat = "dd/MM/yyyy"
        dict["year_constructed"] = dateformat.stringFromDate(selected_date)
        dateview.hidden = true
        tableview.reloadData()
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
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
