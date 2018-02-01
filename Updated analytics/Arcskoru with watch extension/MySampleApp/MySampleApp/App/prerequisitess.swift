//
//  prerequisites.swift
//  LEEDOn
//
//  Created by Group X on 16/11/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class prerequisitess: UIViewController, UITableViewDataSource,UITableViewDelegate,UITabBarDelegate, UIPickerViewDelegate,UIPickerViewDataSource, UITextViewDelegate {
    @IBOutlet weak var actiontitle: UILabel!
    var uploadsdata = NSArray()
    var leedid = NSUserDefaults.standardUserDefaults().integerForKey("leed_id")
    
    @IBOutlet weak var statusswitch: UISwitch!
    @IBOutlet weak var feedstable: UITableView!
    var filescount = 1
    var download_requests = [NSURLSession]()
    var task = NSURLSessionTask()
    var statusarr = ["Ready for Review"]
    var statusupdate = 0
    var currentfeeds = NSArray()
    @IBOutlet weak var next: UIButton!
    var teammembers = NSArray()
    @IBOutlet weak var prev: UIButton!
    @IBOutlet weak var spinner: UIView!
    
    @IBOutlet weak var shortcredit: UIImageView!
    @IBOutlet weak var assetname: UILabel!
    var domain_url = ""
    @IBOutlet weak var creditstatusimg: UIImageView!
    @IBOutlet weak var creditstatus: UILabel!
    @IBOutlet weak var affirmationview1: UIView!
    @IBOutlet weak var affirmationview2: UIView!
    
    @IBOutlet weak var addbtn: UIButton!
    @IBOutlet weak var category: UILabel!
    
    @IBOutlet weak var tableview: UITableView!
    var token = ""
    var actualtableframe = CGRect()
    var currentarr = [String:AnyObject]()
    var currentcategory = NSMutableArray()
    var currentindex = 0
    
    @IBOutlet weak var affirmation1text: UILabel!
    @IBOutlet weak var afriamtion1title: UILabel!
    @IBOutlet weak var affirmation2title: UILabel!
    @IBOutlet weak var affirmation2text2: UILabel!
    @IBOutlet weak var affirmation2text1: UILabel!
    
    var fromnotification = NSUserDefaults.standardUserDefaults().integerForKey("fromnotification")
    var building_dict = NSDictionary()
    
    @IBAction func statuschange(sender: AnyObject) {
        if(ivupload1.on == false){
            maketoast("Affirmation required before changing the status", type: "error")
            if(self.creditstatus.text == ""){
                self.creditstatus.text = "Not available"
                self.statusswitch.on = false
            }else{
                if let creditstatus = currentarr["CreditStatus"] as? String{
                    self.creditstatus.text = String(format: "%@",creditstatus.capitalizedString)
                    if(creditstatus == "Ready for Review"){
                        creditstatusimg.image = UIImage.init(named: "tick")
                        self.statusswitch.on = true
                    }else{
                        creditstatusimg.image = UIImage.init(named: "circle")
                        self.statusswitch.on = false
                    }
                }else{
                    self.statusswitch.on = false
                }
            }

        }else{
            statusupdate = 1
            self.okassignthemember(UIButton())
        }
    }
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if(tableView ==  feedstable){
            if(building_dict["project_type"] as! String == "city" || building_dict["project_type"] as! String == "community"){
                if(section == 2){
                    if let headerView = view as? UITableViewHeaderFooterView {
                        if(headerView.textLabel?.text?.lowercaseString == "activities"){
                            headerView.textLabel?.textAlignment = .Left
                        }else{
                            headerView.textLabel?.textAlignment = .Center
                        }
                    }
                }
            }
        }
    }
    var tempframe = CGRect()
    override func viewDidLoad() {
        self.feedstable.scrollEnabled = false
        super.viewDidLoad()
        tempframe = self.actiontitle.frame
        feedstable.keyboardDismissMode = UIScrollViewKeyboardDismissMode.Interactive
        feedstable.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        tableview.keyboardDismissMode = UIScrollViewKeyboardDismissMode.Interactive
        tableview.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        addbtn.layer.cornerRadius = addbtn.frame.size.height/2.0
        self.feedstable.hidden = false
        building_dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary
        if(fromnotification == 1){
            prev.hidden = true
            next.hidden = true
        }else{
            prev.hidden = false
            next.hidden = false
        }
        self.titlefont()
        //self.prev.layer.frame.origin.x = 0.98 * (self.next.layer.frame.origin.x - self.prev.layer.frame.size.width)
        afriamtion1title.adjustsFontSizeToFitWidth = true
        affirmation1text.adjustsFontSizeToFitWidth = true
        affirmation2text1.adjustsFontSizeToFitWidth = true
        affirmation2text2.adjustsFontSizeToFitWidth = true
        affirmation2title.adjustsFontSizeToFitWidth = true
        if(UIDevice.currentDevice().orientation == .Portrait){
            //sview.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width,UIScreen.mainScreen().bounds.size.height)
        }else{
            //sview.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.height,UIScreen.mainScreen().bounds.size.width)
        }
        let notificationsarr = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("notifications") as! NSData) as! NSArray
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
        self.spinner.layer.cornerRadius = 5
        self.spinner.hidden = true
        //self.view.userInteractionEnabled = true
        assignokbtn.enabled = false
        picker.delegate = self
        picker.dataSource = self
        self.prev.layer.cornerRadius = 4
        self.next.layer.cornerRadius = 4
        self.tabbar.delegate = self
        self.tabbar.selectedItem = self.tabbar.items![1]
        tableview.registerNib(UINib.init(nibName: "prerequisitescell1", bundle: nil), forCellReuseIdentifier: "cell1")
        feedstable.registerNib(UINib.init(nibName: "textcell", bundle: nil), forCellReuseIdentifier: "textcell")
        tableview.registerNib(UINib.init(nibName: "prerequisitescell2", bundle: nil), forCellReuseIdentifier: "cell2")
        feedstable.registerNib(UINib.init(nibName: "prerequisitescell2", bundle: nil), forCellReuseIdentifier: "cell2")
        feedstable.registerNib(UINib.init(nibName: "prerequisitescell1", bundle: nil), forCellReuseIdentifier: "cell1")
        feedstable.registerNib(UINib.init(nibName: "manageprojcellwithswitch", bundle: nil), forCellReuseIdentifier: "manageprojcellwithswitch")
        feedstable.registerNib(UINib.init(nibName: "additionalcell", bundle: nil), forCellReuseIdentifier: "additionalcell")
        actualtableframe = tableview.frame
        var datakeyed = NSData()
        token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        datakeyed = NSUserDefaults.standardUserDefaults().objectForKey("currentcategory") as! NSData
        currentcategory = NSKeyedUnarchiver.unarchiveObjectWithData(datakeyed)?.mutableCopy() as! NSMutableArray
        currentindex = NSUserDefaults.standardUserDefaults().integerForKey("selected_action")
        NSUserDefaults.standardUserDefaults().synchronize()
        print("aarra", currentcategory)
        currentarr = currentcategory[currentindex] as! [String:AnyObject]
        category.text = checkcredit_type(currentarr)
        self.actiontitle.text = currentarr["CreditDescription"] as? String
        self.creditstatus.text = currentarr["CreditStatus"] as? String
        if(self.creditstatus.text == ""){
            self.creditstatus.text = "Not available"
            self.statusswitch.on = false
        }else{
            if let creditstatus = currentarr["CreditStatus"] as? String{
                self.creditstatus.text = String(format: "%@",creditstatus.capitalizedString)
                if(creditstatus == "Ready for Review"){
                    creditstatusimg.image = UIImage.init(named: "tick")
                    self.statusswitch.on = true
                }else{
                    creditstatusimg.image = UIImage.init(named: "circle")
                    self.statusswitch.on = false
                }
            }
        }
        self.creditstatus.text = "Ready for Review"
        let c = credentials()
        domain_url = c.domain_url
        let dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary        
        self.navigationItem.title = dict["name"] as? String
        let navItem = UINavigationItem(title: (dict["name"] as? String)!);
        self.nav.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!]
        let doneItem = UIBarButtonItem(title: "< Credits/Actions", style: .Plain, target: self, action: #selector(sayHello(_:)))
        navItem.leftBarButtonItem = doneItem;
        nav.setItems([navItem], animated: false);
        
        self.affirmationsclick(self.activityfeedbutton)
        self.affirmationview1.layer.cornerRadius = 5
        self.affirmationview2.layer.cornerRadius = 5
        ivupload1.tag = 101
        ivupload2.tag = 102
        ivattached2.tag = 103
        ivupload1.addTarget(self, action: #selector(prerequisites.valuechanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        ivupload2.addTarget(self, action: #selector(prerequisites.valuechanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        ivattached2.addTarget(self, action: #selector(prerequisites.valuechanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(datainput.statusupdate(_:)))
        //self.creditstatus.userInteractionEnabled = true
        //self.creditstatus.addGestureRecognizer(tap)
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.shouldRotate = false
        
        // 2. Force the device in landscape mode when the view controller gets loaded
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
    }
    
    @IBAction func add(sender: AnyObject) {
        self.performSegueWithIdentifier("addnew", sender: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        for request in download_requests
        {
            request.invalidateAndCancel()
        }
        //feedstable.scrollEnabled = true
        //feedstable.bounces = true
        //feedstable.frame = CGRectMake(feedstable.frame.origin.x, tableview.frame.origin.y + tableview.frame.size.height, feedstable.frame.size.width, feedstable.frame.size.height)
        if(fromnotification == 1){
            self.navigationController?.navigationBar.backItem?.title = "Notifications"
        }else{
            self.navigationController?.navigationBar.backItem?.title = "Credits/Actions"
        }
        navigate()
    }
    
    override func shouldAutorotate() -> Bool {
        // 3. Lock autorotate
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait]
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        //stop all download requests
        for request in download_requests
        {
            request.invalidateAndCancel()
        }
        var buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        self.navigationItem.title = buildingdetails["name"] as? String
        //self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as? String
    }
    
    @IBAction func activityfeed(sender: AnyObject) {
        self.spinner.hidden = false
        //self.view.userInteractionEnabled = false
        showactivityfeed(NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), creditID: currentarr["CreditId"] as! String, shortcreditID: currentarr["CreditShortId"] as! String)
    }
    
    @IBAction func goback(sender: AnyObject) {
        
    }
    @IBOutlet weak var nav: UINavigationBar!
    
    func sayHello(sender: UIBarButtonItem) {
        print("Projects clicked")
        self.performSegueWithIdentifier("gotoactions", sender: nil)
    }
    
    
    func showactivityfeed(leedid: Int, creditID : String, shortcreditID : String){
        let url = NSURL.init(string:String(format: "%@assets/activity/?type=credit&leed_id=%d&credit_id=%@&credit_short_id=%@",domain_url, leedid,creditID, shortcreditID))
        print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.description.containsString("cancelled")) != nil){
                    if(error?.code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    print("error=\(error?.description)")
                    print("response",response)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableview.hidden = false
                        self.spinner.hidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401 {           // check for http errors
                dispatch_async(dispatch_get_main_queue(), {
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                })
            }
            else if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                print(data)
                var jsonDictionary : NSArray
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSArray
                    print(jsonDictionary)
                    self.currentfeeds = jsonDictionary
                    dispatch_async(dispatch_get_main_queue(), {
                        self.spinner.hidden = true
                        self.view.userInteractionEnabled = true
                        //self.performSegueWithIdentifier("gotofeeds", sender: nil)
                        if(self.currentfeeds.count > 0){
                            //self.feedstable.hidden = false
                        }else{
                            //self.feedstable.hidden = true
                        }
                        self.feedstable.layoutIfNeeded()
                        let h = UIScreen.mainScreen().bounds.size.height
                        self.feedstable.frame.size.height =  (CGFloat(self.currentfeeds.count) * 0.03 * h) + (CGFloat(self.currentfeeds.count) * 0.118 * h)
                        print(self.feedstable.frame.size.height)
                        self.sview.contentSize = CGSize(width: UIScreen.mainScreen().bounds.size.width ,height:  (self.feedstable.frame.origin.y + self.feedstable.frame.size.height))
                        self.feedstable.reloadData()
                        self.statusswitch.hidden = false
                        self.creditstatus.hidden = false
                    })
                    
                } catch {
                    print(error)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
            }
            
        }
        task.resume()
        
    }
    
    func statusupdate(sender:UILabel){
        if(ivupload1.on == false){
            maketoast("Affirmation required before changing the status", type: "error")
        }else{
        self.teammembers = statusarr
        dispatch_async(dispatch_get_main_queue(), {
            self.assigncontainer.hidden = false
            self.spinner.hidden = true
            self.statusupdate = 1
            //self.view.userInteractionEnabled = true
            self.pleasekindly.text = "Please kindly select the below status for the action"
            self.assignokbtn.setTitle("Save", forState: UIControlState.Normal)
            self.picker.reloadAllComponents()
        })
        }
    }
    
    
    func checkcredit_type(tempdict:[String:AnyObject]) -> String {
        var temp = ""
        if(tempdict["Mandatory"] as! String == "X"){
            temp = "Pre-requisites"
        }else if ((tempdict["Mandatory"] as! String != "X") && (tempdict["CreditcategoryDescrption"] as! String != "Performance Category") && (tempdict["CreditcategoryDescrption"] as! String != "Performance")){
            temp = "Base points"
        }
        else{
            temp = "Data input"
        }
        
        return temp
    }
    
    func textViewDidChange(textView: UITextView) {
        print(textView.tag)
        print(textView.text)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        var s = ""
        var t = ""
        if(building_dict["project_type"] as! String == "city"){
            s = "city"
            t = "cities"
        }else{
            t = "communities"
            s = "community"
        }
        if (textView.text == "Describe or upload documentation describing relevant planning meetings, including dates, times, locations, agenda, and attendee lists."){
            textView.text = ""
        }else if(textView.text == "Describe the \(s) and the types of land use types and building types it includes."){
            textView.text = ""
            
        }else if(textView.text == "Describe the body or entity that conducts the policies, actions, and affairs for the \(s)."){
            textView.text = ""
        }
        else if(textView.text == "Describe the level of control/influence over infrastructure, operations, policies, and individual buildings for the project."){
            textView.text = ""
        }else if(textView.text == "Identify the names of individual stakeholders within the \(s) who will work on the LEED for \(t) certification and describe their role."){
            textView.text = ""
        }else if(textView.text == "Identify key stakeholders within the \(s) who the \(s) has engaged or will engage as part of the certification."){
            textView.text = ""
        }else if (textView.text == "For \(t) with existing plans:Upload or link to relevant planning documents.Upload a crosswalk between goals or strategies in the relevant planning documents and categories in the performance score. \n For cities that are developing plans: Upload a document that: Lists goals Lists strategies under each goal Lists the performance score metric associated with each strategy"){
    }
    
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        print(textView.tag)
        print(textView.text)
        var s = ""
        var t = ""
        if(building_dict["project_type"] as! String == "city"){
            s = "city"
            t = "cities"
        }else{
            t = "communities"
            s = "community"
        }
        
        if(currentarr["CreditDescription"] as? String != "Roadmap"){
            if(textView.tag == 0){
                if(textView.text.characters.count == 0){
            textView.text = "For \(t) with existing plans:Upload or link to relevant planning documents.Upload a crosswalk between goals or strategies in the relevant planning documents and categories in the performance score. \n For \(t) that are developing plans: Upload a document that: Lists goals Lists strategies under each goal Lists the performance score metric associated with each strategy"
                }
            }
            
        }
        if(currentarr["CreditDescription"] as! String == "Meeting"){
            if(textView.tag == 0){
                if(textView.text.characters.count == 0){
                    textView.text = "Describe or upload documentation describing relevant planning meetings, including dates, times, locations, agenda, and attendee lists."
                }
            }
        }
        else if(currentarr["CreditDescription"] as! String == "Project boundary"){
            if(textView.tag == 0){
                if(textView.text.characters.count == 0){
                    textView.text = "Describe the \(s) and the types of land use types and building types it includes."
                }
            }
        }else if(currentarr["CreditDescription"] as! String == "Governance"){
            if(textView.tag == 0){
                if(textView.text.characters.count == 0){
                    textView.text = "Describe the body or entity that conducts the policies, actions, and affairs for the \(s)."
                }
            }else if(textView.tag == 1){
                if(textView.text.characters.count == 0){
                    textView.text = "Describe the level of control/influence over infrastructure, operations, policies, and individual buildings for the project."
                }
            }
        }else if(currentarr["CreditDescription"] as! String == "Stakeholders"){
            if(textView.tag == 0){
                if(textView.text.characters.count == 0){
                    textView.text = "Identify the names of individual stakeholders within the \(s) who will work on the LEED for \(t) certification and describe their role."
                }
            }else if(textView.tag == 1){
                if(textView.text.characters.count == 0){
                    textView.text = "Identify key stakeholders within the \(s) who the \(s) has engaged or will engage as part of the certification."
                }
            }
        }
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            var tempstring = NSMutableString()
            if((currentarr["CreditDescription"] as? String)?.lowercaseString == "project boundary"){
                if(self.uploadsdata.count > 0){
                    var dict = self.uploadsdata.firstObject as! [String:AnyObject]
                    var tempdata = dict["data"] as! String
                    
                    tempdata = tempdata.stringByReplacingOccurrencesOfString("'", withString: "\"")
                    print(tempdata)
                    dict["data"] = self.convertStringToDictionary(tempdata)
                    tempstring.appendString("{\"data\":\"{")                    
                    for (item,key) in (dict["data"] as? [String:AnyObject])!{
                        if(item as! String != "land_use_txtarea"){
                        tempstring.appendString("'\(item as! String)':'\(key as! String)',")
                        }
                    }
                    var str = tempstring as! String
                    if(tempstring != "{\"data\":\"{"){
                    //tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                    }
                    if(textView.text.characters.count > 0){
                        tempstring.appendString("'land_use_txtarea':'\(textView.text as! String)'")
                        //cell.tview.text = "\(dict["data"]!["land_use_txtarea"] as! String)"
                    }else{
                        tempstring.appendString("'land_use_txtarea':''")
                    }
                    tempstring.appendString("}\"}")
                    str = tempstring as! String
                    self.spinner.hidden = false
                    self.view.userInteractionEnabled = false
                    self.addactiondata(credentials().subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), ID: self.currentarr["CreditShortId"] as! String, payload: str, year: Int(dict["year"] as! String)!)
                }else{
                    tempstring.appendString("{\"data\":\"{")
                    tempstring.appendString("'land_use_txtarea':'\(textView.text as! String)'")
                    tempstring.appendString("}\"}")
                    var formatter = NSDateFormatter()
                    formatter.dateFormat = "yyyy"
                    var date = formatter.stringFromDate(NSDate())
                    self.spinner.hidden = false
                    self.view.userInteractionEnabled = false
                    self.addactiondata(credentials().subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), ID: self.currentarr["CreditShortId"] as! String, payload: tempstring as String, year: Int(date)!)
                }
            }else if((currentarr["CreditDescription"] as? String)?.lowercaseString == "governance"){
                var s = ""
                if(textView.tag == 0){
                    s = "policy_entity_txtarea"
                }else{
                    s = "influnence_txtarea"
                }
                if(self.uploadsdata.count > 0){
                    var dict = self.uploadsdata.firstObject as! [String:AnyObject]
                    var tempdata = dict["data"] as! String
                    
                    tempdata = tempdata.stringByReplacingOccurrencesOfString("'", withString: "\"")
                    print(tempdata)
                    dict["data"] = self.convertStringToDictionary(tempdata)
                    tempstring.appendString("{\"data\":\"{")
                    for (item,key) in (dict["data"] as? [String:AnyObject])!{
                        if(item as! String != s){
                            tempstring.appendString("'\(item as! String)':'\(key as! String)',")
                        }
                    }
                    var str = tempstring as! String
                    if(textView.text.characters.count > 0){
                        tempstring.appendString("'\(s)':'\(textView.text as! String)'")
                        //cell.tview.text = "\(dict["data"]!["land_use_txtarea"] as! String)"
                    }else{
                        tempstring.appendString("'\(s)':''")
                    }
                    tempstring.appendString("}\"}")
                    str = tempstring as! String
                    self.spinner.hidden = false
                    self.view.userInteractionEnabled = false
                    self.addactiondata(credentials().subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), ID: self.currentarr["CreditShortId"] as! String, payload: str, year: Int(dict["year"] as! String)!)
                }else{
                    tempstring.appendString("{\"data\":\"{")
                    tempstring.appendString("'\(s)':'\(textView.text as! String)'")
                    tempstring.appendString("}\"}")
                    var formatter = NSDateFormatter()
                    formatter.dateFormat = "yyyy"
                    var date = formatter.stringFromDate(NSDate())
                    self.spinner.hidden = false
                    self.view.userInteractionEnabled = false
                    self.addactiondata(credentials().subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), ID: self.currentarr["CreditShortId"] as! String, payload: tempstring as String, year: Int(date)!)
                }
            }else if((currentarr["CreditDescription"] as? String)?.lowercaseString == "stakeholders"){
                var s = ""
                if(textView.tag == 0){
                    s = "project_team_txtarea"
                }else{
                    s = "key_stakeholder_txtarea"
                }
                if(self.uploadsdata.count > 0){
                    var dict = self.uploadsdata.firstObject as! [String:AnyObject]
                    var tempdata = dict["data"] as! String
                    
                    tempdata = tempdata.stringByReplacingOccurrencesOfString("'", withString: "\"")
                    print(tempdata)
                    dict["data"] = self.convertStringToDictionary(tempdata)
                    tempstring.appendString("{\"data\":\"{")
                    for (item,key) in (dict["data"] as? [String:AnyObject])!{
                        if(item as! String != s){
                            tempstring.appendString("'\(item as! String)':'\(key as! String)',")
                        }
                    }
                    var str = tempstring as! String
                    if(textView.text.characters.count > 0){
                        tempstring.appendString("'\(s)':'\(textView.text as! String)'")
                        //cell.tview.text = "\(dict["data"]!["land_use_txtarea"] as! String)"
                    }else{
                        tempstring.appendString("'\(s)':''")
                    }
                    tempstring.appendString("}\"}")
                    str = tempstring as! String
                    self.spinner.hidden = false
                    self.view.userInteractionEnabled = false
                    self.addactiondata(credentials().subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), ID: self.currentarr["CreditShortId"] as! String, payload: str, year: Int(dict["year"] as! String)!)
                }else{
                    tempstring.appendString("{\"data\":\"{")
                    tempstring.appendString("'\(s)':'\(textView.text as! String)'")
                    tempstring.appendString("}\"}")
                    var formatter = NSDateFormatter()
                    formatter.dateFormat = "yyyy"
                    var date = formatter.stringFromDate(NSDate())
                    self.spinner.hidden = false
                    self.view.userInteractionEnabled = false
                    self.addactiondata(credentials().subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), ID: self.currentarr["CreditShortId"] as! String, payload: tempstring as String, year: Int(date)!)
                }
            }else if((currentarr["CreditDescription"] as? String)?.lowercaseString == "meeting"){
                if(self.uploadsdata.count > 0){
                    var dict = self.uploadsdata.firstObject as! [String:AnyObject]
                    var tempdata = dict["data"] as! String
                    
                    tempdata = tempdata.stringByReplacingOccurrencesOfString("'", withString: "\"")
                    print(tempdata)
                    dict["data"] = self.convertStringToDictionary(tempdata)
                    tempstring.appendString("{\"data\":\"{")
                    for (item,key) in (dict["data"] as? [String:AnyObject])!{
                        if(item as! String != "meeting_docs_txtarea"){
                            tempstring.appendString("'\(item as! String)':'\(key as! String)',")
                        }
                    }
                    var str = tempstring as! String
                    if(tempstring != "{\"data\":\"{"){
                        //tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                    }
                    if(textView.text.characters.count > 0){
                        tempstring.appendString("'meeting_docs_txtarea':'\(textView.text as! String)'")
                        //cell.tview.text = "\(dict["data"]!["land_use_txtarea"] as! String)"
                    }else{
                        tempstring.appendString("'meeting_docs_txtarea':''")
                    }
                    tempstring.appendString("}\"}")
                    str = tempstring as! String
                    self.spinner.hidden = false
                    self.view.userInteractionEnabled = false
                    self.addactiondata(credentials().subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), ID: self.currentarr["CreditShortId"] as! String, payload: str, year: Int(dict["year"] as! String)!)
                }else{
                    tempstring.appendString("{\"data\":\"{")
                    tempstring.appendString("'meeting_docs_txtarea':'\(textView.text as! String)'")
                    tempstring.appendString("}\"}")
                    var formatter = NSDateFormatter()
                    formatter.dateFormat = "yyyy"
                    var date = formatter.stringFromDate(NSDate())
                    self.spinner.hidden = false
                    self.view.userInteractionEnabled = false
                    self.addactiondata(credentials().subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), ID: self.currentarr["CreditShortId"] as! String, payload: tempstring as String, year: Int(date)!)
                }
            }else if((currentarr["CreditDescription"] as? String)?.lowercaseString == "roadmap"){
                if(self.uploadsdata.count > 0){
                    var dict = self.uploadsdata.firstObject as! [String:AnyObject]
                    var tempdata = dict["data"] as! String
                    
                    tempdata = tempdata.stringByReplacingOccurrencesOfString("'", withString: "\"")
                    print(tempdata)
                    dict["data"] = self.convertStringToDictionary(tempdata)
                    tempstring.appendString("{\"data\":\"{")
                    for (item,key) in (dict["data"] as? [String:AnyObject])!{
                        if(item as! String != "score_metrics_txtarea"){
                            tempstring.appendString("'\(item as! String)':'\(key as! String)',")
                        }
                    }
                    var str = tempstring as! String
                    if(tempstring != "{\"data\":\"{"){
                        //tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                    }
                    if(textView.text.characters.count > 0){
                        tempstring.appendString("'score_metrics_txtarea':'\(textView.text as! String)'")
                        //cell.tview.text = "\(dict["data"]!["land_use_txtarea"] as! String)"
                    }else{
                        tempstring.appendString("'score_metrics_txtarea':''")
                    }
                    tempstring.appendString("}\"}")
                    str = tempstring as! String
                    self.spinner.hidden = false
                    self.view.userInteractionEnabled = false
                    self.addactiondata(credentials().subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), ID: self.currentarr["CreditShortId"] as! String, payload: str, year: Int(dict["year"] as! String)!)
                }else{
                    tempstring.appendString("{\"data\":\"{")
                    tempstring.appendString("'score_metrics_txtarea':'\(textView.text as! String)'")
                    tempstring.appendString("}\"}")
                    var formatter = NSDateFormatter()
                    formatter.dateFormat = "yyyy"
                    var date = formatter.stringFromDate(NSDate())
                    self.spinner.hidden = false
                    self.view.userInteractionEnabled = false
                    self.addactiondata(credentials().subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), ID: self.currentarr["CreditShortId"] as! String, payload: tempstring as String, year: Int(date)!)
                }
            }

            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return teammembers.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(tableView ==  feedstable){
            if(building_dict["project_type"] as! String == "city" || building_dict["project_type"] as! String == "community"){
                if(section == 0){
                    return "Requirements"
                }else if(section == 1){
                    return "Assigned to"
                }else{
                    if(currentfeeds.count == 0 ){
                        return "No activities present"
                    }
                    return "Activities"
                }
            }
        }
        return ""
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(statusupdate == 1){
            return teammembers[row] as? String
        }
        return teammembers[row]["Useralias"] as? String
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(tableView ==  feedstable){
            if(building_dict["project_type"] as! String == "city" || building_dict["project_type"] as! String == "community"){
                return 3
            }
        }
        return 1
    }
    var elementarr = NSMutableArray()
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*if(section == 1){
         return 1
         }else if (section == 2){
         return uploadsdata.count+1
         }*/
        if(tableView == tableview){
            return 1
        }
        if(tableView ==  feedstable){
            if(building_dict["project_type"] as! String == "city" || building_dict["project_type"] as! String == "community"){
                if(section == 0 || section == 1){
                    if(section == 0){
                        if((currentarr["CreditDescription"] as! String).lowercaseString == "human experience"){
                         return 4
                        }else if((currentarr["CreditDescription"] as! String).lowercaseString == "transportation"){
                            return 1
                        }else if((currentarr["CreditDescription"] as! String).lowercaseString == "waste"){
                            return 2
                        }else if((currentarr["CreditDescription"] as! String).lowercaseString == "water"){
                            return 1
                        }else if((currentarr["CreditDescription"] as! String).lowercaseString == "energy"){
                            return 1
                        }
                        else if((currentarr["CreditDescription"] as! String).lowercaseString == "additional details" || (currentarr["CreditDescription"] as! String).lowercaseString == "additional data"){
                            return elementarr.count
                        }
                        if(currentarr["CreditDescription"] as! String == "Governance" || currentarr["CreditDescription"] as! String == "Stakeholders"){
                            return 2
                        }
                    }
                    return 1
                }else{
                    return currentfeeds.count
                }
                
            }
        }
        return 1
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
    
    @IBOutlet weak var sview: UIScrollView!
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.contentInset = UIEdgeInsetsZero
        var s = ""
        var t = ""
        if(building_dict["project_type"] as! String == "city"){
            s = "city"
            t = "cities"
        }else{
            t = "communities"
            s = "community"
        }
        
        if(tableView == tableview){
            let cell = UITableViewCell()
            if(indexPath.section == 0){
                let cell = tableView.dequeueReusableCellWithIdentifier("cell2") as! prerequisitescell2
                cell.fileuploaded.hidden = true
                cell.uploadbutton.hidden = true
                cell.uploadanewfile.hidden = true
                cell.assignedto.hidden = false
                cell.editbutton.hidden = false
                cell.editbutton.addTarget(self, action: #selector(edited), forControlEvents: UIControlEvents.TouchUpInside)
                cell.assignedto.hidden = false
                if let assignedto = currentarr["PersonAssigned"] as? String{
                    var _ = assignedto
                    if(assignedto == ""){
                        cell.assignedto.text = "Assigned to None"
                    }else{
                        cell.assignedto.text = String(format:"Assigned to %@",assignedto)
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                }else{
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.assignedto.text = "Assigned to None"
                }
                cell.textLabel?.numberOfLines = 3
                cell.textLabel?.font = cell.assignedto.font
                cell.textLabel?.text = cell.assignedto.text
                cell.assignedto.text = ""
                
                return cell
                
            }
            return cell
        }
        if(indexPath.section == 1){
            let cell = tableView.dequeueReusableCellWithIdentifier("cell2") as! prerequisitescell2
            cell.fileuploaded.hidden = true
            cell.uploadbutton.hidden = true
            cell.uploadanewfile.hidden = true
            cell.assignedto.hidden = false
            cell.editbutton.hidden = false
            cell.editbutton.addTarget(self, action: #selector(edited), forControlEvents: UIControlEvents.TouchUpInside)
            cell.assignedto.hidden = false
            if let assignedto = currentarr["PersonAssigned"] as? String{
                var _ = assignedto
                if(assignedto == ""){
                    cell.assignedto.text = "Assigned to None"
                }else{
                    cell.assignedto.text = String(format:"Assigned to %@",assignedto)
                }
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            }else{
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.assignedto.text = "Assigned to None"
            }
            cell.textLabel?.numberOfLines = 3
            cell.textLabel?.font = cell.assignedto.font
            cell.textLabel?.text = cell.assignedto.text
            cell.assignedto.text = ""
            return cell
        }
        
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
            cell.textLabel?.numberOfLines = 5
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            if((currentarr["CreditDescription"] as! String).lowercaseString == "human experience"){
                cell.textLabel?.text = humanarr[indexPath.row]
                return cell
            }else if((currentarr["CreditDescription"] as! String).lowercaseString == "transportation"){
                cell.textLabel?.text = transportarr[indexPath.row]
                return cell
            }else if((currentarr["CreditDescription"] as! String).lowercaseString == "waste"){
                cell.textLabel?.text = wastearr[indexPath.row]
                return cell
            }else if((currentarr["CreditDescription"] as! String).lowercaseString == "water"){
                cell.textLabel?.text = waterarr[indexPath.row]
                return cell
            }else if((currentarr["CreditDescription"] as! String).lowercaseString == "energy"){
                cell.textLabel?.text = energyarr[indexPath.row]
                return cell
            }else if((currentarr["CreditDescription"] as? String)?.lowercaseString == "additional details" || (currentarr["CreditDescription"] as? String)?.lowercaseString == "additional data"){
                let cell = tableView.dequeueReusableCellWithIdentifier("additionalcell") as! additionalcell
                let data = elementarr[indexPath.row].mutableCopy() as! NSMutableArray
                cell.name.text = data[0] as! String
                cell.yr.text = data[3] as! String
                cell.val.text = "\(data[1] as! String)\(data[2] as! String)"
                return cell
            }else if(currentarr["CreditDescription"] as? String == "Commit to sharing data"){
                let cell = tableView.dequeueReusableCellWithIdentifier("manageprojcellwithswitch")! as! manageprojcellwithswitch
                cell.yesorno.addTarget(self, action: #selector(self.datasharing(_:)), forControlEvents: UIControlEvents.ValueChanged)
                //
                if(self.uploadsdata.count > 0){
                    var dict = self.uploadsdata.firstObject as! [String:AnyObject]
                    var tempdata = dict["data"] as! String
                    
                    tempdata = tempdata.stringByReplacingOccurrencesOfString("'", withString: "\"")
                    print(tempdata)
                    dict["data"] = self.convertStringToDictionary(tempdata)
                    if(dict["data"] != nil){
                        if let value = dict["data"]!["data_sharing_chk"] as? String{
                            if(value == "false"){
                            cell.yesorno.on = false
                            }else{
                            cell.yesorno.on = true
                            }
                        }
                    }
                }else{
                    cell.yesorno.on = false
                }
                
                //cell.valuetxtfld.keyboardType = UIKeyboardType.Default
                //cell.valuetxtfld.userInteractionEnabled = false
                cell.lbl?.font = UIFont.init(name: "OpenSans", size: 13)
                if(self.actiontitle.text == "Commit to sharing data"){
                    cell.lbl?.numberOfLines = 5
                    cell.lbl.adjustsFontSizeToFitWidth = true
                    cell.lbl!.text = "Commit to measuring each metric in the performance score on an ongoing basis."
                }
                cell.accessoryType = UITableViewCellAccessoryType.None
                return cell
            }else if (currentarr["CreditDescription"] as? String == "Project boundary" || currentarr["CreditDescription"] as? String == "Meeting" || currentarr["CreditDescription"] as! String == "Roadmap"){
                let cell = tableView.dequeueReusableCellWithIdentifier("textcell")! as! textcell
                if(currentarr["CreditDescription"] as? String == "Roadmap"){
                    cell.tview.text = "For \(t) with existing plans:Upload or link to relevant planning documents.Upload a crosswalk between goals or strategies in the relevant planning documents and categories in the performance score. \n For \(t) that are developing plans: Upload a document that: Lists goals Lists strategies under each goal Lists the performance score metric associated with each strategy"
                    
                    if(self.uploadsdata.count > 0){
                        var dict = self.uploadsdata.firstObject as! [String:AnyObject]
                        var tempdata = dict["data"] as! String
                        
                        tempdata = tempdata.stringByReplacingOccurrencesOfString("'", withString: "\"")
                        print(tempdata)
                        dict["data"] = self.convertStringToDictionary(tempdata)
                        if(dict["data"] != nil){
                            if let value = dict["data"]!["score_metrics_txtarea"] as? String{
                                if(value != ""){
                                cell.tview.text = value
                                }
                            }
                        }
                    }
                    
                }else if(currentarr["CreditDescription"] as? String != "Meeting"){
                    if(building_dict["project_type"] as! String == "city"){
                    cell.tview.text = "Describe the \(s) and the types of land use types and building types it includes."
                    }else{
                    cell.tview.text = "Describe the \(s) and the types of land use types and building types it includes."
                    }
                    if((currentarr["CreditDescription"] as? String)?.lowercaseString == "project boundary"){
                        if(self.uploadsdata.count > 0){
                            var dict = self.uploadsdata.firstObject as! [String:AnyObject]
                            var tempdata = dict["data"] as! String
                            
                            tempdata = tempdata.stringByReplacingOccurrencesOfString("'", withString: "\"")
                            print(tempdata)
                            dict["data"] = self.convertStringToDictionary(tempdata)
                            if(dict["data"] != nil){
                            if let value = dict["data"]!["land_use_txtarea"] as? String{
                                if(value != ""){
                                cell.tview.text = value
                                }
                            }
                            }
                        }
                    }
                }else{
                    cell.tview.text = "Describe or upload documentation describing relevant planning meetings, including dates, times, locations, agenda, and attendee lists."
                    if(self.uploadsdata.count > 0){
                        var dict = self.uploadsdata.firstObject as! [String:AnyObject]
                        var tempdata = dict["data"] as! String
                        
                        tempdata = tempdata.stringByReplacingOccurrencesOfString("'", withString: "\"")
                        print(tempdata)
                        dict["data"] = self.convertStringToDictionary(tempdata)
                        if(dict["data"] != nil){
                            if let value = dict["data"]!["meeting_docs_txtarea"] as? String{
                                if(value != ""){
                                cell.tview.text = value
                                }
                            }
                        }
                    }
                }
                cell.tview.font = UIFont.init(name: "OpenSans", size: 12)
                cell.tview.tag = 0
                cell.tview.delegate = self
                return cell
            }else if (currentarr["CreditDescription"] as? String == "Governance"){
                if(indexPath.row == 0){
                    let cell = tableView.dequeueReusableCellWithIdentifier("textcell")! as! textcell
                    if(building_dict["project_type"] as! String == "city"){
                    cell.tview.text = "Describe the body or entity that conducts the policies, actions, and affairs for the \(s)."
                    }else{
                    cell.tview.text = "Describe the body or entity that conducts the policies, actions, and affairs for the \(s)."
                    }
                    cell.tview.font = UIFont.init(name: "OpenSans", size: 12)
                    cell.tview.tag = 0
                    cell.tview.delegate = self
                    if(self.uploadsdata.count > 0){
                        var dict = self.uploadsdata.firstObject as! [String:AnyObject]
                        var tempdata = dict["data"] as! String
                        
                        tempdata = tempdata.stringByReplacingOccurrencesOfString("'", withString: "\"")
                        dict["data"] = self.convertStringToDictionary(tempdata)
                        print(dict["data"])
                        if(dict["data"] != nil){
                        if let value = dict["data"]!["policy_entity_txtarea"] as? String{
                            if(value != ""){
                            cell.tview.text = value
                            }
                        }
                        }
                    }
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCellWithIdentifier("textcell")! as! textcell
                    cell.tview.text = "Describe the level of control/influence over infrastructure, operations, policies, and individual buildings for the project."
                    cell.tview.font = UIFont.init(name: "OpenSans", size: 12)
                    cell.tview.tag = 1
                    cell.tview.delegate = self
                    if(self.uploadsdata.count > 0){
                        var dict = self.uploadsdata.firstObject as! [String:AnyObject]
                        var tempdata = dict["data"] as! String
                        
                        tempdata = tempdata.stringByReplacingOccurrencesOfString("'", withString: "\"")
                        print(tempdata)
                        dict["data"] = self.convertStringToDictionary(tempdata)
                        if(dict["data"] != nil){
                        if let value = dict["data"]!["influnence_txtarea"] as? String{
                            if(value != ""){
                            cell.tview.text = value
                            }
                        }
                        }
                    }
                    return cell
                }
            }else if (currentarr["CreditDescription"] as? String == "Stakeholders"){
                if(indexPath.row == 0){
                    let cell = tableView.dequeueReusableCellWithIdentifier("textcell")! as! textcell
                    if(building_dict["project_type"] as! String == "city"){
                    cell.tview.text = "Identify the names of individual stakeholders within the \(s) who will work on the LEED for \(t) certification and describe their role."
                    }else{
                    cell.tview.text = "Identify the names of individual stakeholders within the \(s) who will work on the LEED for \(t) certification and describe their role."
                    }
                    cell.tview.font = UIFont.init(name: "OpenSans", size: 12)
                    cell.tview.tag = 0
                    cell.tview.delegate = self
                    if(self.uploadsdata.count > 0){
                        var dict = self.uploadsdata.firstObject as! [String:AnyObject]
                        var tempdata = dict["data"] as! String
                        
                        tempdata = tempdata.stringByReplacingOccurrencesOfString("'", withString: "\"")
                        print(tempdata)
                        dict["data"] = self.convertStringToDictionary(tempdata)
                        if(dict["data"] != nil){
                            if let value = dict["data"]!["project_team_txtarea"] as? String{
                                if(value != ""){
                                cell.tview.text = value
                                }
                            }
                        }
                    }
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCellWithIdentifier("textcell")! as! textcell
                    if(building_dict["project_type"] as! String == "city"){
                    cell.tview.text = "Identify key stakeholders within the \(s) who the \(s) has engaged or will engage as part of the certification."
                    }else{
                        cell.tview.text = "Identify key stakeholders within the \(s) who the \(s) has engaged or will engage as part of the certification."
                    }
                    cell.tview.font = UIFont.init(name: "OpenSans", size: 12)
                    cell.tview.tag = 1
                    cell.tview.delegate = self
                    if(self.uploadsdata.count > 0){
                        var dict = self.uploadsdata.firstObject as! [String:AnyObject]
                        var tempdata = dict["data"] as! String
                        
                        tempdata = tempdata.stringByReplacingOccurrencesOfString("'", withString: "\"")
                        print(tempdata)
                        dict["data"] = self.convertStringToDictionary(tempdata)
                        if(dict["data"] != nil){
                            if let value = dict["data"]!["key_stakeholder_txtarea"] as? String{
                                if(value != ""){
                                cell.tview.text = value
                                }
                            }
                        }
                    }
                    return cell
                }
            }
            
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("feedcell")!
        if(currentfeeds.count > 0){
        if let dict = currentfeeds.objectAtIndex(indexPath.row) as? [String:AnyObject]{
            if(dict["verb"] != nil){
            cell.textLabel?.text = dict["verb"] as? String
                cell.textLabel?.numberOfLines = 5
            }
            var str = ""
            if(dict["timestamp"] != nil){
              str = dict["timestamp"] as! String
            }
             
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
            let date = formatter.dateFromString(str)!
            formatter.dateFormat = "MMM dd, yyyy"
            str = formatter.stringFromDate(date)
            cell.detailTextLabel?.numberOfLines = 5
            cell.textLabel?.numberOfLines = 5
            var str1 = String()
            formatter.dateFormat = "hh:mm a"
            str1 = formatter.stringFromDate(date)
            cell.detailTextLabel?.text = "on \(str) at \(str1)"
        }else{
            
        }
        }
        
        return cell
        
    }
    
    var humanarr = ["Education","Equitablity", "Prosperity", "Health & Safety"]
    var transportarr = ["Vehicle miles traveled on individual vehicles daily (Miles)"]
    var wastearr = ["Municipal solid waste generation intensity (Tons/Year/Person)", "Municipal solid waste diversion rate from landfill (%)"]
    var waterarr = ["Water Consumption (Gallons/Year/Person)"]
    var energyarr = ["GHG Emissions (CO2 equivalent)"]
    func deleted(){
        print("deleted")
    }
    
    
    func edited(){
        print("edited")
        dispatch_async(dispatch_get_main_queue(), {
            self.assignokbtn.enabled = false
            self.statusupdate = 0
            self.spinner.hidden = false
            //self.view.userInteractionEnabled = false
            self.pleasekindly.text = "Please kindly the team member to assign this action"
            self.assignokbtn.setTitle("Assign", forState: UIControlState.Normal)
            self.getteammembers(credentials().subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"))
        })
    }
    
    func uploaded(){
        print("uploaded")
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        assignokbtn.enabled = true
        if(statusupdate == 0){
            print(teammembers[row]["Useralias"])
        }
    }
    
    
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height = UIScreen.mainScreen().bounds.size.height
        if(tableView == tableview){
            return 1
        }
        return 0.03 * height
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height = UIScreen.mainScreen().bounds.size.height
        if(tableView == tableview){
            return  0.067 * height
        }
        if(tableView ==  feedstable){
            if(building_dict["project_type"] as! String == "city" || building_dict["project_type"] as! String == "community"){
                if(indexPath.section == 0 || indexPath.section == 1){
                    if(indexPath.section == 1){
                        return 0.067 * height
                    }else{
                        if((currentarr["CreditDescription"] as! String).lowercaseString == "human experience" ||
                            (currentarr["CreditDescription"] as! String).lowercaseString == "transportation" || (currentarr["CreditDescription"] as! String).lowercaseString == "waste" || (currentarr["CreditDescription"] as! String).lowercaseString == "water" || (currentarr["CreditDescription"] as! String).lowercaseString == "energy"){
                            return 0.095 * height
                        }
                    }
                    return 0.118 * height
                }
            }
        }
        return 0.117 * height
    }
    
    func datasharing(sender:UISwitch){
        //data_sharing_chk
        var tempstring = NSMutableString()
        var check = false
        if(sender.on){
            check = true
        }
        
        if(self.uploadsdata.count > 0){
            var dict = self.uploadsdata.firstObject as! [String:AnyObject]
            var tempdata = dict["data"] as! String
            
            tempdata = tempdata.stringByReplacingOccurrencesOfString("'", withString: "\"")
            print(tempdata)
            dict["data"] = self.convertStringToDictionary(tempdata)
            tempstring.appendString("{\"data\":\"{")
            for (item,key) in (dict["data"] as? [String:AnyObject])!{
                if(item as! String != "data_sharing_chk"){
                    tempstring.appendString("'\(item as! String)':'\(key as! String)',")
                }
            }
            var str = tempstring as! String
            if(tempstring != "{\"data\":\"{"){
                //tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
            }
                tempstring.appendString("'data_sharing_chk':'\(check as! Bool)'")
            tempstring.appendString("}\"}")
            str = tempstring as! String
            self.spinner.hidden = false
            self.view.userInteractionEnabled = false
            self.addactiondata(credentials().subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), ID: self.currentarr["CreditShortId"] as! String, payload: str, year: Int(dict["year"] as! String)!)
        }else{
            tempstring.appendString("{\"data\":\"{")
            tempstring.appendString("'data_sharing_chk':'\(check as! Bool)'")
            tempstring.appendString("}\"}")
            var formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy"
            var date = formatter.stringFromDate(NSDate())
            self.spinner.hidden = false
            self.view.userInteractionEnabled = false
            self.addactiondata(credentials().subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), ID: self.currentarr["CreditShortId"] as! String, payload: tempstring as String, year: Int(date)!)
        }
    }
    
    func getteammembers(subscription_key:String, leedid:Int){
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/teams/",domain_url, leedid))
        print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.description.containsString("cancelled")) != nil){
                    if(error?.code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    print("error=\(error?.description)")
                    print("response",response)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableview.hidden = false
                        self.spinner.hidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401 {           // check for http errors
                dispatch_async(dispatch_get_main_queue(), {
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                })
            }
            else if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                print(data)
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                    let team_membersarray = jsonDictionary["EtTeamMembers"] as! NSArray
                    self.teammembers = team_membersarray
                    var temparr = NSMutableArray()
                    for item in self.teammembers{
                        var arr = item as! NSDictionary
                        if(arr["Rolestatus"] as! String != "Deactivated Relationship"){
                            temparr.addObject(arr)
                        }
                    }
                    var currentar = NSMutableArray()
                    var keys = NSMutableSet()
                    var result = NSMutableArray()
                    
                    
                    for data in temparr{
                        var key = data["email"] as! String
                        if(keys.containsObject(key)){
                            continue
                        }
                        keys.addObject(key)
                        result.addObject(data)
                        
                    }
                    
                    print(result)
                    self.teammembers = result
                    dispatch_async(dispatch_get_main_queue(), {
                        self.assigncontainer.hidden = false
                        self.spinner.hidden = true
                        //self.view.userInteractionEnabled = true
                        self.picker.reloadAllComponents()
                    })
                    
                    //self.tableview.reloadData()
                    // self.buildingactions(subscription_key, leedid: leedid)
                } catch {
                    print(error)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
            }
            
        }
        task.resume()
    }
    
    
    @IBAction func affirmationview2close(sender: AnyObject) {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            //self.tableview.frame = self.actualtableframe
            self.affirmationview2.hidden = true
            }, completion: { (finished: Bool) -> Void in
                
                // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
                
        })
    }
    
    @IBAction func previous(sender: AnyObject) {
        if(currentindex>0){
            /*if(task.currentRequest != nil){
             if (task.state == NSURLSessionTaskState.Running) {
             task.cancel()
             }
             }*/
            currentindex = currentindex-1
            NSUserDefaults.standardUserDefaults().setInteger(currentindex, forKey: "selected_action")
            currentarr = currentcategory[currentindex] as! [String:AnyObject]
            if(checkcredit_type(currentarr) == "Data input"){
                //self.performSegueWithIdentifier("datainput", sender: nil)
              /*  let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                let listofactions = mainstoryboard.instantiateViewControllerWithIdentifier("listofactions")
                var datainput = mainstoryboard.instantiateViewControllerWithIdentifier("datainput")
                if((currentarr["CreditDescription"] as! String).lowercaseString == "water" || (currentarr["CreditDescription"] as! String).lowercaseString == "energy"){
                    datainput = mainstoryboard.instantiateViewControllerWithIdentifier("datainput")
                }else{
                    datainput = mainstoryboard.instantiateViewControllerWithIdentifier("waste")
                }
                let rootViewController = self.navigationController
                var controllers = (rootViewController!.viewControllers)
                controllers.removeAll()
                var v = UIViewController()
                var grid = 0
                grid = NSUserDefaults.standardUserDefaults().integerForKey("grid")
                if(NSUserDefaults.standardUserDefaults().integerForKey("grid") == 1){
                    v = mainstoryboard.instantiateViewControllerWithIdentifier("grid") as! UINavigationController
                }else{
                    v = mainstoryboard.instantiateViewControllerWithIdentifier("listofassets") as! UINavigationController
                }
                var listofassets = mainstoryboard.instantiateViewControllerWithIdentifier("projectslist")
                if(grid == 1){
                    listofassets = mainstoryboard.instantiateViewControllerWithIdentifier("gridvc")
                }else{
                    listofassets = mainstoryboard.instantiateViewControllerWithIdentifier("projectslist")
                }
                listofassets.navigationItem.title = building_dict["name"] as? String
                controllers.append(listofassets)
                controllers.append(listofactions)
                controllers.append(datainput)
                //self.navigationController!.hidesBarsOnTap = false;
                //self.navigationController!.hidesBarsOnSwipe = false;
                //self.navigationController!.hidesBarsWhenVerticallyCompact = false;
                self.navigationController?.setViewControllers(controllers, animated: false)
                */
                navigate()
            }else{
                navigate()
            }
        }
    }
    @IBOutlet weak var ivupload2: UISwitch!
    
    @IBOutlet weak var assignokbtn: UIButton!
    @IBOutlet weak var assignclosebutton: UIButton!
    @IBOutlet weak var pleasekindly: UILabel!
    @IBOutlet weak var assigncontainer: UIView!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var ivattached2: UISwitch!
    
    @IBOutlet weak var ivupload1: UISwitch!
    func navigate(){
        self.sview.scrollsToTop = true
        self.sview.setContentOffset(CGPointMake(0, 0), animated: true)
        addbtn.hidden = true
        self.assigncontainer.hidden = true
        currentindex = NSUserDefaults.standardUserDefaults().integerForKey("selected_action")
        NSUserDefaults.standardUserDefaults().synchronize()
        currentarr = currentcategory[currentindex] as! [String:AnyObject]
        //feedstable.hidden = true
        showactivityfeed(NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), creditID: currentarr["CreditId"] as! String, shortcreditID: currentarr["CreditShortId"] as! String)
        category.text = checkcredit_type(currentarr)
        category.hidden = true
        self.actiontitle.text = currentarr["CreditDescription"] as? String
        self.creditstatus.text = currentarr["CreditStatus"] as? String
        if(self.creditstatus.text == ""){
            self.creditstatus.text = "Not available"
            self.statusswitch.on = false
        }else{
            if let creditstatus = currentarr["CreditStatus"] as? String{
                self.creditstatus.text = String(format: "%@",creditstatus.capitalizedString)
                if(creditstatus == "Ready for Review"){
                    creditstatusimg.image = UIImage.init(named: "tick")
                    self.statusswitch.on = true
                }else{
                    creditstatusimg.image = UIImage.init(named: "circle")
                    self.statusswitch.on = false
                }
            }else{
                self.statusswitch.on = false
            }
        }
        self.creditstatus.text = "Ready for Review"
        
        self.actiontitle.hidden = false
        if(currentarr["CreditcategoryDescrption"] as! String == "Indoor Environmental Quality"){
            shortcredit.image = UIImage.init(named: "iq-border")
        }else if(currentarr["CreditcategoryDescrption"] as! String == "Materials and Resources"){
            shortcredit.image = UIImage.init(named: "mr-border")
        }else if(currentarr["CreditcategoryDescrption"] as! String == "Energy and Atmosphere"){
            shortcredit.image = UIImage.init(named: "ea-border")
        }else if(currentarr["CreditcategoryDescrption"] as! String == "Water Efficiency"){
            shortcredit.image = UIImage.init(named: "we-border")
        }else if(currentarr["CreditcategoryDescrption"] as! String == "Sustainable Sites"){
            shortcredit.image = UIImage.init(named: "ss-border")
        }else if(currentarr["CreditcategoryDescrption"] as! String == "Innovation"){
            self.category.text = "Innovation"
            self.actiontitle.hidden = true
            shortcredit.image = UIImage.init(named: "id-border")
        }
        
        if(currentarr["CreditcategoryDescrption"] as! String == "Indoor Environmental Quality"){
            shortcredit.image = UIImage.init(named: "iq-border")
        }else if(currentarr["CreditcategoryDescrption"] as! String == "Materials and Resources"){
            shortcredit.image = UIImage.init(named: "mr-border")
        }else if(currentarr["CreditcategoryDescrption"] as! String == "Energy and Atmosphere"){
            shortcredit.image = UIImage.init(named: "ea-border")
        }else if(currentarr["CreditcategoryDescrption"] as! String == "Water Efficiency"){
            shortcredit.image = UIImage.init(named: "we-border")
        }else if(currentarr["CreditcategoryDescrption"] as! String == "Sustainable Sites"){
            shortcredit.image = UIImage.init(named: "ss-border")
        }else if(currentarr["CreditcategoryDescrption"] as! String == "Innovation"){
            shortcredit.image = UIImage.init(named: "id-border")
        }else if(currentarr["CreditcategoryDescrption"] as! String == "Prerequiste"){
            shortcredit.image = self.imageWithImage(UIImage(named: "settings.png")!, scaledToSize: CGSizeMake(32, 32))
        }else{
            if((currentarr["CreditDescription"] as! String).lowercaseString == "energy"){
                shortcredit.image = UIImage.init(named: "energy-border")
            }else if((currentarr["CreditDescription"] as! String).lowercaseString == "water"){
                shortcredit.image = UIImage.init(named: "water-border")
            }else if((currentarr["CreditDescription"] as! String).lowercaseString == "waste"){
                shortcredit.image = UIImage.init(named: "waste-border")
            }
            else if((currentarr["CreditDescription"] as! String).lowercaseString == "transportation"){
                shortcredit.image = UIImage.init(named: "transport-border")
            }else if ((currentarr["CreditDescription"] as! String).lowercaseString == "human experience"){
                shortcredit.image = UIImage.init(named: "human-border")
            }else{
                shortcredit.image = self.imageWithImage(UIImage(named: "settings.png")!, scaledToSize: CGSizeMake(32, 32))
            }
        }
        if ((currentarr["CreditDescription"] as! String).lowercaseString == "additional details" || (currentarr["CreditDescription"] as! String).lowercaseString == "additional data"){
            addbtn.hidden = false
        }
        if(currentarr["IvReqFileupload"] is String){
            if(currentarr["IvReqFileupload"] as! String == ""){
                ivupload1.setOn(false, animated: false)
                ivupload2.setOn(false, animated: false)
            }else if(currentarr["IvReqFileupload"] as! String == "X"){
                ivupload1.setOn(true, animated: false)
                ivupload2.setOn(true, animated: false)
            }
        }else{
            ivupload1.setOn(currentarr["IvReqFileupload"] as! Bool, animated: false)
            ivupload2.setOn(currentarr["IvReqFileupload"] as! Bool, animated: false)
        }
        
        if(currentarr["IvAttchPolicy"] is String){
            if(currentarr["IvAttchPolicy"] as! String == ""){
                ivattached2.setOn(false, animated: false)
            }else if(currentarr["IvAttchPolicy"] as! String == "X"){
                ivattached2.setOn(true, animated: false)
            }
        }else{
            ivattached2.setOn(currentarr["IvAttchPolicy"] as! Bool, animated: false)
        }
        self.shortcredit.frame.origin.y = 0.98 * self.actiontitle.frame.origin.y
        self.actiontitle.frame = tempframe
        self.alignimageview(shortcredit, label: actiontitle, superview: self.view)
        
        let c = credentials()
        domain_url = c.domain_url
        dispatch_async(dispatch_get_main_queue(), {
            self.statusswitch.hidden = true            
            self.creditstatus.hidden = true
            self.spinner.hidden = true
            for request in self.download_requests
            {
                request.invalidateAndCancel()
            }
                self.spinner.hidden = false
                self.getuploadsdata(credentials().subscription_key, leedid: self.leedid, actionID: self.currentarr["CreditShortId"] as! String)
        })
        //self.getuploadsdata(c.subscription_key, leedid: 1000136954, actionID: currentarr["CreditId"] as! String)
    }
    
    func alignimageview (imageView: UIImageView, label : UILabel, superview : UIView){
        label.sizeToFit()
        imageView.frame = CGRectMake((superview.frame.size.width - imageView.frame.size.width - label.frame.size.width)/2, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height)
        label.frame = CGRectMake(imageView.frame.origin.x + imageView.frame.size.width, label.frame.origin.y, label.frame.size.width, imageView.frame.size.height)
    }

    
    func imageWithImage(image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
    @IBAction func next(sender: AnyObject) {
        if(currentindex<currentcategory.count-1){
            /*if(task.currentRequest != nil){
             if (task.state == NSURLSessionTaskState.Running) {
             task.cancel()
             }
             }*/
            currentindex = currentindex+1
            NSUserDefaults.standardUserDefaults().setInteger(currentindex, forKey: "selected_action")
            currentarr = currentcategory[currentindex] as! [String:AnyObject]
            if(checkcredit_type(currentarr) == "Data input"){
                //self.performSegueWithIdentifier("datainput", sender: nil)
               /* let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                let listofactions = mainstoryboard.instantiateViewControllerWithIdentifier("listofactions")
                let datainput = mainstoryboard.instantiateViewControllerWithIdentifier("datainput")
                let rootViewController = self.navigationController
                var controllers = (rootViewController!.viewControllers)
                controllers.removeAll()
                var v = UIViewController()
                var grid = 0
                grid = NSUserDefaults.standardUserDefaults().integerForKey("grid")
                if(NSUserDefaults.standardUserDefaults().integerForKey("grid") == 1){
                    v = mainstoryboard.instantiateViewControllerWithIdentifier("grid") as! UINavigationController
                }else{
                    v = mainstoryboard.instantiateViewControllerWithIdentifier("listofassets") as! UINavigationController
                }
                var listofassets = mainstoryboard.instantiateViewControllerWithIdentifier("projectslist")
                if(grid == 1){
                    listofassets = mainstoryboard.instantiateViewControllerWithIdentifier("gridvc")
                }else{
                    listofassets = mainstoryboard.instantiateViewControllerWithIdentifier("projectslist")
                }
                let dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary
                listofassets.navigationItem.title = dict["name"] as? String
                controllers.append(listofassets)
                controllers.append(listofactions)
                controllers.append(datainput)
                //self.navigationController?.setViewControllers(controllers, animated: false)*/
                navigate()
            }else{
                navigate()
            }
        }
    }
    
    
    @IBAction func affirmationview1close(sender: AnyObject) {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            //self.tableview.frame = self.actualtableframe
            self.affirmationview1.hidden = true
            }, completion: { (finished: Bool) -> Void in
                
                // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
                
        })
    }
    
    
    
    
    @IBOutlet weak var activityfeedbutton: UIButton!
    @IBOutlet weak var tabbar: UITabBar!
    @IBAction func affirmationsclick(sender: AnyObject) {
        
        if(self.actiontitle.text!.containsString("Policy")){
            self.affirmationview1.hidden = true
            self.affirmationview2.hidden = false
            self.affirmation1text.text = "The policy on the resources page has been implemented for the project."
            self.affirmation2text2.text = "And/or a custom policy meeting the prerequisite requirements has been implemented for the project. A copy of the policy has been uploaded."
            self.affirmationview2.hidden = false
            feedstable.frame = CGRectMake(feedstable.frame.origin.x, affirmationview2.frame.origin.y + affirmationview2.frame.size.height, feedstable.frame.size.width, feedstable.frame.size.height)
            self.affirmationview2.transform = CGAffineTransformMakeScale(1, 1);
            //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview2.layer.frame.origin.y + self.affirmationview2.layer.frame.size.height), self.tableview.layer.frame.size.width,  self.tableview.layer.frame.size.height)
            
            
            /* UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
             self.affirmationview2.transform = CGAffineTransformMakeScale(1.3, 1.3);
             UIView.animateWithDuration(0.3, delay: 0.3, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
             self.affirmationview2.transform = CGAffineTransformMakeScale(1, 1);
             self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.1*self.affirmationview2.layer.frame.origin.y+self.affirmationview2.layer.frame.size.height, self.tableview.layer.frame.size.width, fabs(self.view.layer.frame.size.height-(self.activityfeedbutton.layer.frame.size.height+self.tabbar.layer.frame.size.height+(1.1*(self.affirmationview2.layer.frame.origin.y+self.affirmationview2.layer.frame.size.height)))))
             }, completion: { (finished: Bool) -> Void in
             
             // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
             
             })
             }, completion: { (finished: Bool) -> Void in
             
             // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
             
             })*/
            
        }else{
            self.affirmationview1.hidden = false
            self.affirmationview2.hidden = true
            self.affirmationview1.hidden = false
            feedstable.frame = CGRectMake(feedstable.frame.origin.x, affirmationview1.frame.origin.y + affirmationview1.frame.size.height, feedstable.frame.size.width, feedstable.frame.size.height)
            self.affirmationview1.transform = CGAffineTransformMakeScale(1, 1);
            //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  self.tableview.layer.frame.size.height)
            
            /* UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
             self.affirmationview1.transform = CGAffineTransformMakeScale(1.3, 1.3);
             UIView.animateWithDuration(0.3, delay: 0.3, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
             self.affirmationview1.transform = CGAffineTransformMakeScale(1, 1);
             self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.1*self.affirmationview1.layer.frame.origin.y+self.affirmationview1.layer.frame.size.height, self.tableview.layer.frame.size.width, fabs(self.view.layer.frame.size.height-(self.activityfeedbutton.layer.frame.size.height+self.tabbar.layer.frame.size.height+(1.1*(self.affirmationview1.layer.frame.origin.y+self.affirmationview1.layer.frame.size.height)))))
             }, completion: { (finished: Bool) -> Void in
             
             // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
             
             })
             }, completion: { (finished: Bool) -> Void in
             
             // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
             
             })*/
            
        }
        
        
        
    }
    
    func getuploadsdata(subscription_key:String, leedid: Int, actionID: String){
        let url = NSURL.init(string: String(format: "%@assets/LEED:%d/actions/ID:%@/data/",credentials().domain_url,leedid,actionID))
        print(url?.absoluteURL)
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        print(token)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.description.containsString("cancelled")) != nil){
                    let httpStatus = response as? NSHTTPURLResponse
                    if(error?.code == -999){
                        
                    }else{
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    print("error=\(error?.description)")
                    print("response",response)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableview.hidden = false
                        //       self.spinner.hidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401 {           // check for http errors
                dispatch_async(dispatch_get_main_queue(), {
                    //   self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                })
            }
            else if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print("action data xcv",jsonDictionary)
                    self.uploadsdata = NSMutableArray()
                    self.elementarr = NSMutableArray()
                    self.uploadsdata = jsonDictionary["results"]?.mutableCopy() as! NSMutableArray
                    dispatch_async(dispatch_get_main_queue(), {
                                    if ((self.currentarr["CreditDescription"] as! String).lowercaseString == "additional details" || (self.currentarr["CreditDescription"] as! String).lowercaseString == "additional data"){
                        //  self.spinner.hidden = true
                        //self.view.userInteractionEnabled = true
                        NSUserDefaults.standardUserDefaults().synchronize()
                        //  self.navigate()
                        
                        var i = 0
                        for item in self.uploadsdata{
                            var data = item as! [String : AnyObject]
                            var tempdata = data["data"] as! String
                            
                            tempdata = tempdata.stringByReplacingOccurrencesOfString("'", withString: "\"")
                            print(tempdata)
                            data["data"] = self.convertStringToDictionary(tempdata)
                            for str in (data["data"]!.mutableCopy() as! NSDictionary){
                                var token = (str.key).componentsSeparatedByString("_num_unit")
                                if(token.count > 1 ){
                                    var arr = NSMutableArray()
                                    arr.addObject(data["data"]!["\(token[0] as! String)_num_name"] as! String)
                                    arr.addObject(data["data"]!["\(token[0] as! String)_num"] as! String)
                                    arr.addObject(data["data"]!["\(token[0] as! String)_num_unit"] as! String)
                                    arr.addObject(data["year"] as! String)
                                    arr.addObject(token[0])
                                    self.elementarr.addObject(arr)
                                }
                            }
                            
                            
                            var j = 0
                            var z = 0
                            
                            j = data["data"]!.allValues.count
                            if(j > 0 ){
                                z = (j/3)
                            }
                            i += z
                        }
                        print("Number of data",i,self.elementarr)
                        }
                        self.showactivityfeed(NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), creditID: self.currentarr["CreditId"] as! String, shortcreditID: self.currentarr["CreditShortId"] as! String)
                        self.feedstable.reloadData()
                    })
                } catch {
                    print(error)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
            }
            
        }
        task.resume()
    }
    
    
    func addactiondata(subscription_key:String, leedid: Int, ID : String, payload : String, year : Int){
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@/data/%d/",credentials().domain_url, leedid,ID,year))
        print(url?.absoluteURL)
        var subscription_key = credentials().subscription_key
        var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        dispatch_async(dispatch_get_main_queue(), {
            self.view.userInteractionEnabled = false
        })
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var httpbody = payload
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
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401{
                dispatch_async(dispatch_get_main_queue(), {
                    //self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                    
                })
                return
            } else
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 && httpStatus.statusCode != 201{           // check for http errors
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
                            self.view.userInteractionEnabled = true
                            self.maketoast("Updated successfully", type: "message")
                            //self.navigationController?.popViewControllerAnimated(true)
                            self.navigate()
                        })
                    } catch {
                        print(error)
                    }
            }
            
        }
        task.resume()
        
        
    }

    
    func getcreditformsuploadsdata(subscription_key:String, leedid: Int, actionID: String){
        
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@/uploads/",domain_url, leedid, actionID))
        print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.description.containsString("cancelled")) != nil){
                    if(error?.code == -999){
                        
                    }else{
                   self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    print("error=\(error?.description)")
                    print("response",response)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableview.hidden = false
                        self.spinner.hidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401 {           // check for http errors
                dispatch_async(dispatch_get_main_queue(), {
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                })
            }
            else if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                print(data)
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    self.uploadsdata = jsonDictionary["EtFile"] as! NSArray
                    print(jsonDictionary)
                    self.spinner.hidden = true
                    //self.view.userInteractionEnabled = true
                    //self.tableview.reloadData()
                    // self.buildingactions(subscription_key, leedid: leedid)
                } catch {
                    print(error)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
            }
            
        }
        task.resume()
    }
    
    
    @IBOutlet weak var backbtn: UIButton!
    
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
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if((currentarr["CreditDescription"] as! String).lowercaseString == "human experience" ||
            (currentarr["CreditDescription"] as! String).lowercaseString == "transportation" || (currentarr["CreditDescription"] as! String).lowercaseString == "waste" || (currentarr["CreditDescription"] as! String).lowercaseString == "water" || (currentarr["CreditDescription"] as! String).lowercaseString == "energy"){
            index = indexPath.row
                self.performSegueWithIdentifier("yearlydata", sender: nil)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        print("Selected")
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    var index = 0
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "gotofeeds"){
            let vc = segue.destinationViewController as! feeds
            vc.currentfeeds = currentfeeds
        }else if(segue.identifier == "yearlydata"){
            let vc = segue.destinationViewController as! yearlydata
            vc.currentdict = currentarr
            if((currentarr["CreditDescription"] as! String).lowercaseString == "transportation" || (currentarr["CreditDescription"] as! String).lowercaseString == "waste" || (currentarr["CreditDescription"] as! String).lowercaseString == "water" || (currentarr["CreditDescription"] as! String).lowercaseString == "energy"){
                vc.currenttitle = (currentarr["CreditDescription"] as! String).lowercaseString    
                }else{
                if(index == 0){
                vc.currenttitle = "education"
                }else if(index == 1){
                vc.currenttitle = "equitablity"
                }else if(index == 2){
                vc.currenttitle = "prosperity"
                }else if(index == 3){
                    vc.currenttitle = "health & safety"
                }
                
            }
            
        }else if(segue.identifier == "addnew"){
            let vc = segue.destinationViewController as! addnew
            vc.currentarr = currentarr
            vc.listofdata = elementarr
        }
    }
    
    @IBAction func assignclose(sender: AnyObject) {
        self.assigncontainer.hidden = true
    }
    
    func assignnewmember(subscription_key:String, leedid: Int, actionID: String, email:String,firstname: String, lastname:String){
        //https://api.usgbc.org/dev/leed/assets/LEED:{leed_id}/actions/ID:{action_id}/teams/
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@/teams/",domain_url, leedid, actionID))
        print(url?.absoluteURL)
        dispatch_async(dispatch_get_main_queue(), {
            self.view.userInteractionEnabled = false
        })
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let httpbody = String(format: "{\"emails\":\"%@\"}",email)
        request.HTTPBody = httpbody.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.description.containsString("cancelled")) != nil){
                    if(error?.code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    print("error=\(error?.description)")
                    print("response",response)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableview.hidden = false
                        self.spinner.hidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401 {           // check for http errors
                dispatch_async(dispatch_get_main_queue(), {
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                })
            }
            else if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                print(data)
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.currentarr["PersonAssigned"] = String(format: "%@ %@",firstname,lastname)
                        self.currentcategory.replaceObjectAtIndex(self.currentindex, withObject: self.currentarr)
                        self.assigncontainer.hidden = true
                        self.spinner.hidden = true
                        //self.view.userInteractionEnabled = true
                        self.buildingactions(subscription_key, leedid: leedid)
                    })
                    //self.tableview.reloadData()
                    // self.buildingactions(subscription_key, leedid: leedid)
                } catch {
                    print(error)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
            }
            
        }
        task.resume()
    }
    
    
    func buildingactions(subscription_key:String, leedid: Int){
        let url = NSURL.init(string: String(format: "%@assets/LEED:%d/actions/",domain_url,leedid))
        print(url?.absoluteURL)
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.description.containsString("cancelled")) != nil){
                    if(error?.code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    print("error=\(error?.description)")
                    print("response",response)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableview.hidden = false
                        self.spinner.hidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401 {           // check for http errors
                dispatch_async(dispatch_get_main_queue(), {
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                })
            }
            else if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print("Building xcv",jsonDictionary)
                    dispatch_async(dispatch_get_main_queue(), {
                        let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                        NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "actions_data")
                        self.spinner.hidden = true
                        self.view.userInteractionEnabled = true
                        NSUserDefaults.standardUserDefaults().synchronize()
                        self.navigate()
                        self.tableview.reloadData()
                        
                        self.maketoast("Updated successfully",type: "message")
                        return
                    })
                } catch {
                    print(error)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
            }
            
        }
        task.resume()
    }
    
    @IBAction func okassignthemember(sender: AnyObject) {
        if(statusupdate == 1){
            self.view.userInteractionEnabled = false
            self.spinner.hidden = false
            savestatusupdate(currentarr["CreditId"] as! String, subscription_key: credentials().subscription_key)
            
        }else{
            self.view.userInteractionEnabled = false
            self.spinner.hidden = false
            assignnewmember(credentials().subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), actionID: currentarr["CreditId"] as! String, email:teammembers[picker.selectedRowInComponent(0)]["Useralias"] as! String,firstname:teammembers[picker.selectedRowInComponent(0)]["Firstname"] as! String,lastname: teammembers[picker.selectedRowInComponent(0)]["Lastname"] as! String)
        }
    }
    
    func affirmationupdate(actionID:String, leedid: Int, subscription_key:String){
        //
        var url = NSURL()
        let s = String(format:"%d",leedid)
        if(actionID.containsString(s)){
            url = NSURL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@/",domain_url, leedid, actionID))!
        }
        else{
            url = NSURL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@-%d/",domain_url, leedid, actionID,leedid))!
        }
        print(url.absoluteString)
        dispatch_async(dispatch_get_main_queue(), {
            self.view.userInteractionEnabled = false
        })
        let request = NSMutableURLRequest.init(URL: url)
        request.HTTPMethod = "PUT"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var httpbody = String()
        if(self.actiontitle.text!.containsString("Policy")){
            httpbody = String(format: "{\"IvAttchPolicy\": %@, \"IvReqFileupload\": %@}",self.ivattached2.on,ivupload2.on)
        }else{
            httpbody = String(format: "{\"IvAttchPolicy\": %@, \"IvReqFileupload\": %@}",self.ivattached2.on,ivupload1.on)
        }
        request.HTTPBody = httpbody.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.description.containsString("cancelled")) != nil){
                    if(error?.code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    print("error=\(error?.description)")
                    print("response",response)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableview.hidden = false
                        self.spinner.hidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401 {           // check for http errors
                dispatch_async(dispatch_get_main_queue(), {
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                })
            }
            else if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401{
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            } else
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 && httpStatus.statusCode != 201 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }else{
                    print(data)
                    var jsonDictionary : NSDictionary
                    do {
                        if(self.actiontitle.text!.containsString("Policy")){
                            if(self.ivattached2.on == true){
                                self.currentarr["IvAttchPolicy"] = "X"
                            }else{
                                self.currentarr["IvAttchPolicy"] = ""
                            }
                            
                            if(self.ivupload2.on == true){
                                self.currentarr["IvReqFileupload"] = "X"
                            }else{
                                self.currentarr["IvReqFileupload"] = ""
                            }
                        }else{
                            if(self.ivattached2.on == true){
                                self.currentarr["IvAttchPolicy"] = "X"
                            }else{
                                self.currentarr["IvAttchPolicy"] = ""
                            }
                            
                            if(self.ivupload1.on == true){
                                self.currentarr["IvReqFileupload"] = "X"
                            }else{
                                self.currentarr["IvReqFileupload"] = ""
                            }
                        }
                        self.currentcategory.replaceObjectAtIndex(NSUserDefaults.standardUserDefaults().integerForKey("selected_action"), withObject: self.currentarr)
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        print(jsonDictionary)
                        self.buildingactions(subscription_key, leedid: leedid)
                        //self.tableview.reloadData()
                        //
                    } catch {
                        print(error)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                            
                        })
                    }
            }
            
        }
        task.resume()
        
    }
    
    
    
    
    func selectedaction(){
        
    }
    
    func valuechanged(sender:UISwitch){
        if(sender.tag == 101 || sender.tag == 102 || sender.tag == 103){
            dispatch_async(dispatch_get_main_queue(), {
                self.spinner.hidden = false
                //self.view.userInteractionEnabled = false
            })
            
            affirmationupdate(currentarr["CreditId"] as! String, leedid: leedid, subscription_key: credentials().subscription_key)
        }
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
        dispatch_async(dispatch_get_main_queue(), {
            self.view.userInteractionEnabled = true
        })
        //        }
        //      let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        //    alertController.addAction(defaultAction)
        
        //presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    
    func savestatusupdate(actionID:String, subscription_key:String){
        //
        var url = NSURL()
        let s = String(format:"%d",leedid)
        if(actionID.containsString(s)){
            url = NSURL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@/",domain_url, leedid, actionID))!
        }
        else{
            url = NSURL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@-%d/",domain_url, leedid, actionID,leedid))!
        }
        print(url.absoluteString)
        dispatch_async(dispatch_get_main_queue(), {
            self.view.userInteractionEnabled = false
        })
        let request = NSMutableURLRequest.init(URL: url)
        request.HTTPMethod = "PUT"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var httpbody = String()
        let string = self.statusarr[self.picker.selectedRowInComponent(0)] as? String
        /*if(string == "Ready for review"){
            httpbody = String(format: "{\"is_readyForReview\": %@}",true)
        }else{
            httpbody = String(format: "{\"is_readyForReview\": %@}",false)
        }*/
        if(statusswitch.on == true){
            httpbody = String(format: "{\"is_readyForReview\": %@}",statusswitch.on)
        }else{
            httpbody = String(format: "{\"is_readyForReview\": %@}",statusswitch.on)
        }
        request.HTTPBody = httpbody.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.description.containsString("cancelled")) != nil){
                    if(error?.code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    print("error=\(error?.description)")
                    print("response",response)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableview.hidden = false
                        self.spinner.hidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401 {           // check for http errors
                dispatch_async(dispatch_get_main_queue(), {
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                })
            }
            else if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401{
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            } else
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 && httpStatus.statusCode != 201 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }else{
                    print(data)
                    var jsonDictionary : NSDictionary
                    do {
                        
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        print(jsonDictionary)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.creditstatus.text = string
                            self.currentarr["CreditStatus"] = string
                            self.currentcategory.replaceObjectAtIndex(NSUserDefaults.standardUserDefaults().integerForKey("selected_action"), withObject: self.currentarr)
                            self.buildingactions(subscription_key, leedid: self.leedid)
                        })
                    } catch {
                        print(error)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                            
                        })
                    }
            }
            
        }
        task.resume()
    }
    
    @IBAction func changestatus(sender: AnyObject) {
        self.statusupdate(UILabel())
    }
    
    
}
