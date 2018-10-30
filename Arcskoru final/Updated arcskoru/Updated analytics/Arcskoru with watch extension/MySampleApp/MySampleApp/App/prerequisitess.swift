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
    var leedid = UserDefaults.standard.integer(forKey: "leed_id")
    var framee = CGRect()
    var tframee = CGRect()
    @IBOutlet weak var statusswitch: UISwitch!
    @IBOutlet weak var feedstable: UITableView!
    var filescount = 1
    var download_requests = [URLSession]()
    var task = URLSessionTask()
    var statusarr = ["Ready for Review"]
    var statusupdate = 0
    var currentfeeds = NSArray()
    @IBOutlet weak var nxt: UIButton!
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
    var currentarr = NSMutableDictionary()
    var currentcategory = NSMutableArray()
    var currentindex = 0
    
    @IBOutlet weak var affirmation1text: UILabel!
    @IBOutlet weak var afriamtion1title: UILabel!
    @IBOutlet weak var affirmation2title: UILabel!
    @IBOutlet weak var affirmation2text2: UILabel!
    @IBOutlet weak var affirmation2text1: UILabel!
    
    var fromnotification = UserDefaults.standard.integer(forKey: "fromnotification")
    var building_dict = NSDictionary()
    
    @IBAction func statuschange(_ sender: AnyObject) {
        if(ivupload1.isOn == false){
            maketoast("Affirmation required before changing the status", type: "error")
            if(self.creditstatus.text == ""){
                self.creditstatus.text = "Not available"
                self.statusswitch.isOn = false
            }else{
                if let creditstatus = currentarr["CreditStatus"] as? String{
                    self.creditstatus.text = String(format: "%@",creditstatus.capitalized)
                    if(creditstatus == "Ready for Review"){
                        creditstatusimg.image = UIImage.init(named: "tick")
                        self.statusswitch.isOn = true
                    }else{
                        creditstatusimg.image = UIImage.init(named: "circle")
                        self.statusswitch.isOn = false
                    }
                }else{
                    self.statusswitch.isOn = false
                }
            }
            
        }else{
            statusupdate = 1
            self.okassignthemember(UIButton())
        }
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if(tableView ==  feedstable){
            if(building_dict["project_type"] as! String == "city" || building_dict["project_type"] as! String == "community"){
                if(section == 2){
                    if let headerView = view as? UITableViewHeaderFooterView {
                        if(headerView.textLabel?.text?.lowercased() == "activities"){
                            headerView.textLabel?.textAlignment = .left
                        }else{
                            headerView.textLabel?.textAlignment = .left
                        }
                    }
                }
            }
        }
    }
    var tempframe = CGRect()
    override func viewDidLoad() {
        framee = self.sview.frame
        tframee = self.feedstable.frame
        self.tableview.delegate = nil
        self.tableview.dataSource = nil
        self.tableview.isHidden = true
        self.feedstable.isScrollEnabled = false
        super.viewDidLoad()
        self.statusswitch.isHidden = true
        self.creditstatus.isHidden = true
        tempframe = self.actiontitle.frame
        feedstable.keyboardDismissMode = UIScrollViewKeyboardDismissMode.interactive
        feedstable.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        tableview.keyboardDismissMode = UIScrollViewKeyboardDismissMode.interactive
        tableview.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        addbtn.layer.cornerRadius = addbtn.frame.size.height/2.0
        self.feedstable.isHidden = false
        building_dict = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary
        if(fromnotification == 1){
            prev.isHidden = true
            nxt.isHidden = true
        }else{
            prev.isHidden = false
            nxt.isHidden = false
        }
        self.titlefont()
        //self.prev.layer.frame.origin.x = 0.98 * (self.nxt.layer.frame.origin.x - self.prev.layer.frame.size.width)
        afriamtion1title.adjustsFontSizeToFitWidth = true
        affirmation1text.adjustsFontSizeToFitWidth = true
        affirmation2text1.adjustsFontSizeToFitWidth = true
        affirmation2text2.adjustsFontSizeToFitWidth = true
        affirmation2title.adjustsFontSizeToFitWidth = true
        if(UIDevice.current.orientation == .portrait){
            //sview.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width,UIScreen.mainScreen().bounds.size.height)
        }else{
            //sview.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.height,UIScreen.mainScreen().bounds.size.width)
        }
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
        self.spinner.layer.cornerRadius = 5
        self.spinner.isHidden = true
        //self.view.userInteractionEnabled = true
        assignokbtn.isEnabled = false
        picker.delegate = self
        picker.dataSource = self
        self.prev.layer.cornerRadius = 4
        self.nxt.layer.cornerRadius = 4
        self.tabbar.delegate = self
        self.tabbar.selectedItem = self.tabbar.items![1]
        tableview.register(UINib.init(nibName: "prerequisitescell1", bundle: nil), forCellReuseIdentifier: "cell1")
        feedstable.register(UINib.init(nibName: "textcell", bundle: nil), forCellReuseIdentifier: "textcell")
        tableview.register(UINib.init(nibName: "prerequisitescell2", bundle: nil), forCellReuseIdentifier: "cell2")
        feedstable.register(UINib.init(nibName: "prerequisitescell2", bundle: nil), forCellReuseIdentifier: "cell2")
        feedstable.register(UINib.init(nibName: "prerequisitescell1", bundle: nil), forCellReuseIdentifier: "cell1")
        feedstable.register(UINib.init(nibName: "manageprojcellwithswitch", bundle: nil), forCellReuseIdentifier: "manageprojcellwithswitch")
        feedstable.register(UINib.init(nibName: "additionalcell", bundle: nil), forCellReuseIdentifier: "additionalcell")
        actualtableframe = tableview.frame
        var datakeyed = Data()
        token = UserDefaults.standard.object(forKey: "token") as! String
        datakeyed = UserDefaults.standard.object(forKey: "currentcategory") as! Data
        currentcategory = (NSKeyedUnarchiver.unarchiveObject(with: datakeyed) as! NSArray).mutableCopy() as! NSMutableArray
        currentindex = UserDefaults.standard.integer(forKey: "selected_action")
        UserDefaults.standard.synchronize()
        //print("aarra", currentcategory)
        currentarr = (currentcategory[currentindex] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        category.text = checkcredit_type(currentarr)
        self.actiontitle.text = currentarr["CreditDescription"] as? String
        self.creditstatus.text = currentarr["CreditStatus"] as? String
        if(self.creditstatus.text == ""){
            self.creditstatus.text = "Not available"
            self.statusswitch.isOn = false
        }else{
            if let creditstatus = currentarr["CreditStatus"] as? String{
                self.creditstatus.text = String(format: "%@",creditstatus.capitalized)
                if(creditstatus == "Ready for Review"){
                    creditstatusimg.image = UIImage.init(named: "tick")
                    self.statusswitch.isOn = true
                }else{
                    creditstatusimg.image = UIImage.init(named: "circle")
                    self.statusswitch.isOn = false
                }
            }
        }
        self.creditstatus.text = "Ready for Review"
        let c = credentials()
        domain_url = c.domain_url
        let dict = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary
        self.navigationItem.title = dict["name"] as? String
        let navItem = UINavigationItem(title: (dict["name"] as! String));
        self.nav.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!]
        let doneItem = UIBarButtonItem(title: "< Credits/Actions", style: .plain, target: self, action: #selector(sayHello(_:)))
        navItem.leftBarButtonItem = doneItem;
        nav.setItems([navItem], animated: false);
        
        self.affirmationsclick(self.activityfeedbutton)
        self.affirmationview1.layer.cornerRadius = 5
        self.affirmationview2.layer.cornerRadius = 5
        ivupload1.tag = 101
        ivupload2.tag = 102
        ivattached2.tag = 103
        ivupload1.addTarget(self, action: #selector(self.valuechanged(_:)), for: UIControlEvents.valueChanged)
        ivupload2.addTarget(self, action: #selector(self.valuechanged(_:)), for: UIControlEvents.valueChanged)
        ivattached2.addTarget(self, action: #selector(self.valuechanged(_:)), for: UIControlEvents.valueChanged)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.statusupdate(_:)))
        //self.creditstatus.userInteractionEnabled = true
        //self.creditstatus.addGestureRecognizer(tap)
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.shouldRotate = false
        
        // 2. Force the device in landscape mode when the view controller gets loaded
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
    @IBAction func add(_ sender: AnyObject) {
        if let creditDescription = self.currentarr["CreditStatus"] as? String{
            if(creditDescription.lowercased() == "under review"){
                self.showalert("Updation is not allowed when the credit is under review", title: "Error", action: "OK")
            }else{
                if((currentarr["CreditDescription"] as! String).lowercased() == "additional details" || (currentarr["CreditDescription"] as! String).lowercased() == "additional data"){
                    edit = 0
                    
                self.performSegue(withIdentifier: "addnew", sender: nil)
                    
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
            if(UserDefaults.standard.integer(forKey: "fromnotifications") == 0){
            self.navigationController?.navigationBar.backItem?.title = "Credits/Actions"
            }else{
                
            }
        }
        var buildingdetails = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.navigationItem.title = buildingdetails["name"] as? String
        navigate()
    }
    
    override var shouldAutorotate : Bool {
        // 3. Lock autorotate
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait]
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        //stop all download requests
        for request in download_requests
        {
            request.invalidateAndCancel()
        }
        var buildingdetails = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.navigationItem.title = buildingdetails["name"] as? String
        //self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as! String
    }
    
    @IBAction func activityfeed(_ sender: AnyObject) {
        self.spinner.isHidden = false
        //self.view.userInteractionEnabled = false
        showactivityfeed(UserDefaults.standard.integer(forKey: "leed_id"), creditID: currentarr["CreditId"] as! String, shortcreditID: currentarr["CreditShortId"] as! String)
    }
    
    @IBAction func goback(_ sender: AnyObject) {
        
    }
    @IBOutlet weak var nav: UINavigationBar!
    
    func sayHello(_ sender: UIBarButtonItem) {
        //print("Projects clicked")
        self.performSegue(withIdentifier: "gotoactions", sender: nil)
    }
    
    
    func showactivityfeed(_ leedid: Int, creditID : String, shortcreditID : String){
        let url = URL.init(string:String(format: "%@assets/activity/?type=credit&leed_id=%d&credit_id=%@&credit_short_id=%@",domain_url, leedid,creditID, shortcreditID))
        ////print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(session)
        self.task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.localizedDescription.contains("cancelled")) != nil){
                    if(error?._code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    //print("error=\(error?.localizedDescription)")
                    DispatchQueue.main.async(execute: {
                        self.tableview.isHidden = true
                        self.spinner.isHidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            }
            else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                
                var jsonDictionary : NSArray
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSArray
                    //print(jsonDictionary)
                    self.currentfeeds = jsonDictionary
                    DispatchQueue.main.async(execute: {
                        self.spinner.isHidden = true
                        self.view.isUserInteractionEnabled = true
                        //self.performSegueWithIdentifier("gotofeeds", sender: nil)
                        if(self.currentfeeds.count > 0){
                            //self.feedstable.hidden = false
                        }else{
                            //self.feedstable.hidden = true
                        }
                        self.feedstable.layoutIfNeeded()
                        let h = UIScreen.main.bounds.size.height
                        self.feedstable.frame.size.height =  ((CGFloat(self.currentfeeds.count + 3) * 0.03 * h) + (CGFloat(self.currentfeeds.count + 3) * 0.168 * h))
                        //print(self.feedstable.frame.size.height)
                        if(self.checkcredit_type(self.currentarr) == "Data input" || (self.currentarr["CreditDescription"] as! String).lowercased() == "additional details" || (self.currentarr["CreditDescription"] as! String).lowercased() == "additional data"){
                        self.sview.contentSize = CGSize(width: UIScreen.main.bounds.size.width ,height:  (self.feedstable.frame.origin.y + self.feedstable.frame.size.height + (1 * self.affirmationview1.frame.size.height)))
                            self.affirmationview1.isHidden = true
                            self.creditstatus.isHidden = true
                            self.statusswitch.isHidden = true
                        }else{
                        self.sview.contentSize = CGSize(width: UIScreen.main.bounds.size.width ,height:  (self.feedstable.frame.origin.y + self.feedstable.frame.size.height))
                            self.affirmationview1.isHidden = false
                            self.creditstatus.isHidden = false
                            self.statusswitch.isHidden = false
                        }
                        self.feedstable.reloadData()
                        
                    })
                    
                } catch {
                    //print(error)
                    DispatchQueue.main.async(execute: {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
            }
            
        })
        task.resume()
        
    }
    
    func statusupdate(_ sender:UILabel){
        if(ivupload1.isOn == false){
            maketoast("Affirmation required before changing the status", type: "error")
        }else{
            self.teammembers = statusarr as NSArray
            DispatchQueue.main.async(execute: {
                self.assigncontainer.isHidden = false
                self.spinner.isHidden = true
                self.statusupdate = 1
                //self.view.userInteractionEnabled = true
                self.pleasekindly.text = "Please kindly select the below status for the action"
                self.assignokbtn.setTitle("Save", for: UIControlState())
                self.picker.reloadAllComponents()
            })
        }
    }
    
    
    func checkcredit_type(_ tempdict:NSMutableDictionary) -> String {
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
    
    func textViewDidChange(_ textView: UITextView) {
        //print(textView.tag)
        //print(textView.text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
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
        }else if(textView.text == "Project Team. Identify the names of individual stakeholders within the \(s) who will work on the LEED for \(t) certification and describe their role."){
            textView.text = ""
        }else if(textView.text == "\(s.capitalized) Engagement. Identify key stakeholder groups within the \(s) who the \(s) has engaged or will engage as part of its planning."){
            textView.text = ""
        }else if (textView.text == "For \(t) with existing plans:Upload or link to relevant planning documents, upload a crosswalk between goals or strategies in the relevant planning documents and categories in the performance score. \n For \(t) that are developing plans: Upload a document that: Lists goals, lists strategies under each goal, and lists the performance score metric associated with each strategy"){
            textView.text = ""
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        //print(textView.tag)x5
        //print(textView.text)
        var s = ""
        var t = ""
        if(building_dict["project_type"] as! String == "city"){
            s = "city"
            t = "cities"
        }else{
            t = "communities"
            s = "community"
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
        }else if(currentarr["CreditDescription"] as! String == "Stakeholders" || currentarr["CreditDescription"] as! String == "Skateholders" ){
            if(textView.tag == 0){
                if(textView.text.characters.count == 0){
                    textView.text = "Project Team. Identify the names of individual stakeholders within the \(s) who will work on the LEED for \(t) certification and describe their role."
                }
            }else if(textView.tag == 1){
                if(textView.text.characters.count == 0){
                    textView.text = "\(s.capitalized) Engagement. Identify key stakeholder groups within the \(s) who the \(s) has engaged or will engage as part of its planning."
                }
            }
        }else if(currentarr["CreditDescription"] as! String != "Roadmap"){
            if(textView.tag == 0){
                if(textView.text.characters.count == 0){
                    textView.text = "For \(t) with existing plans:Upload or link to relevant planning documents, upload a crosswalk between goals or strategies in the relevant planning documents and categories in the performance score. \n For \(t) that are developing plans: Upload a document that: Lists goals, lists strategies under each goal, and lists the performance score metric associated with each strategy"
                }
            }
            
        }else if(currentarr["CreditDescription"] as! String == "Roadmap"){
            if(textView.tag == 0){
                if(textView.text.characters.count == 0){
                    textView.text = "For \(t) with existing plans:Upload or link to relevant planning documents, upload a crosswalk between goals or strategies in the relevant planning documents and categories in the performance score. \n For \(t) that are developing plans: Upload a document that: Lists goals, lists strategies under each goal, and lists the performance score metric associated with each strategy"
                }
            }
            
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            let tempstring = NSMutableString()
            if((currentarr["CreditDescription"] as! String).lowercased() == "project boundary"){
                if(self.uploadsdata.count > 0){
                    var dict = (self.uploadsdata.firstObject as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    var tempdata = dict["data"] as! String
                    
                    tempdata = tempdata.replacingOccurrences(of: "'", with: "\"")
                    //print(tempdata)
                    dict["data"] = self.convertStringToDictionary(tempdata)
                    tempstring.append("{\"data\":\"{")
                    for (i,key) in ((dict["data"] as! NSDictionary).mutableCopy() as! NSDictionary).mutableCopy() as! NSMutableDictionary{
                        let item = i as! String
                        if(item != "land_use_txtarea"){
                            tempstring.append("'\(item )':'\(key as! String)',")
                        }
                    }
                    var str = tempstring as String
                    if(tempstring != "{\"data\":\"{"){
                        //tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                    }
                    if(textView.text.characters.count > 0){
                        tempstring.append("'land_use_txtarea':'\(textView.text as String)'")
                        //cell.tview.text = "\(dict["data"]!["land_use_txtarea"] as! String)"
                    }else{
                        tempstring.append("'land_use_txtarea':''")
                    }
                    tempstring.append("}\"}")
                    str = tempstring as String
                    self.spinner.isHidden = false
                    self.view.isUserInteractionEnabled = false
                    
                    if let creditDescription = self.currentarr["CreditStatus"] as? String{
                        if(creditDescription.lowercased() == "under review"){
                            self.showalert("Updation is not allowed when the credit is under review", title: "Error", action: "OK")
                        }else{
                    self.addactiondata(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"), ID: self.currentarr["CreditShortId"] as! String, payload: str, year: Int(dict["year"] as! String)!)
                        }
                    }
                }else{
                    tempstring.append("{\"data\":\"{")
                    tempstring.append("'land_use_txtarea':'\(textView.text as String)'")
                    tempstring.append("}\"}")
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy"
                    let date = formatter.string(from: Date())
                    self.spinner.isHidden = false
                    self.view.isUserInteractionEnabled = false
                    if let creditDescription = self.currentarr["CreditStatus"] as? String{
                        if(creditDescription.lowercased() == "under review"){
                            self.showalert("Updation is not allowed when the credit is under review", title: "Error", action: "OK")
                        }else{
                    self.addactiondata(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"), ID: self.currentarr["CreditShortId"] as! String, payload: tempstring as String, year: Int(date)!)
                        }
                    }
                }
            }else if((currentarr["CreditDescription"] as! String).lowercased() == "governance"){
                var s = ""
                if(textView.tag == 0){
                    s = "policy_entity_txtarea"
                }else{
                    s = "influnence_txtarea"
                }
                if(self.uploadsdata.count > 0){
                    var dict = (self.uploadsdata.firstObject as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    var tempdata = dict["data"] as! String
                    
                    tempdata = tempdata.replacingOccurrences(of: "'", with: "\"")
                    //print(tempdata)
                    dict["data"] = self.convertStringToDictionary(tempdata)
                    tempstring.append("{\"data\":\"{")
                    for (i,key) in ((dict["data"] as! NSDictionary).mutableCopy() as! NSDictionary).mutableCopy() as! NSMutableDictionary{
                        let item = i as! String
                        if(item != s){
                            tempstring.append("'\(item )':'\(key as! String)',")
                        }
                    }
                    var str = tempstring as String
                    if(textView.text.characters.count > 0){
                        tempstring.append("'\(s)':'\(textView.text as String)'")
                        //cell.tview.text = "\(dict["data"]!["land_use_txtarea"] as! String)"
                    }else{
                        tempstring.append("'\(s)':''")
                    }
                    tempstring.append("}\"}")
                    str = tempstring as String
                    self.spinner.isHidden = false
                    self.view.isUserInteractionEnabled = false
                    if let creditDescription = self.currentarr["CreditStatus"] as? String{
                        if(creditDescription.lowercased() == "under review"){
                            self.showalert("Updation is not allowed when the credit is under review", title: "Error", action: "OK")
                        }else{
                    self.addactiondata(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"), ID: self.currentarr["CreditShortId"] as! String, payload: str, year: Int(dict["year"] as! String)!)
                        }
                    }
                }else{
                    tempstring.append("{\"data\":\"{")
                    tempstring.append("'\(s)':'\(textView.text as String)'")
                    tempstring.append("}\"}")
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy"
                    let date = formatter.string(from: Date())
                    self.spinner.isHidden = false
                    self.view.isUserInteractionEnabled = false
                    if let creditDescription = self.currentarr["CreditStatus"] as? String{
                        if(creditDescription.lowercased() == "under review"){
                            self.showalert("Updation is not allowed when the credit is under review", title: "Error", action: "OK")
                        }else{
                    self.addactiondata(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"), ID: self.currentarr["CreditShortId"] as! String, payload: tempstring as String, year: Int(date)!)
                        }
                    }
                }
            }else if((currentarr["CreditDescription"] as! String).lowercased() == "stakeholders" || currentarr["CreditDescription"] as! String == "Skateholders" ){
                var s = ""
                if(textView.tag == 0){
                    s = "project_team_txtarea"
                }else{
                    s = "key_stakeholder_txtarea"
                }
                if(self.uploadsdata.count > 0){
                    var dict = (self.uploadsdata.firstObject as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    var tempdata = dict["data"] as! String
                    
                    tempdata = tempdata.replacingOccurrences(of: "'", with: "\"")
                    //print(tempdata)
                    dict["data"] = self.convertStringToDictionary(tempdata)
                    tempstring.append("{\"data\":\"{")
                    for (i,key) in ((dict["data"] as! NSDictionary).mutableCopy() as! NSDictionary).mutableCopy() as! NSMutableDictionary{
                        let item = i as! String
                        if(item != s){
                            tempstring.append("'\(item )':'\(key as! String)',")
                        }
                    }
                    var str = tempstring as String
                    if(textView.text.characters.count > 0){
                        tempstring.append("'\(s)':'\(textView.text as String)'")
                        //cell.tview.text = "\(dict["data"]!["land_use_txtarea"] as! String)"
                    }else{
                        tempstring.append("'\(s)':''")
                    }
                    tempstring.append("}\"}")
                    str = tempstring as String
                    self.spinner.isHidden = false
                    self.view.isUserInteractionEnabled = false
                    if let creditDescription = self.currentarr["CreditStatus"] as? String{
                        if(creditDescription.lowercased() == "under review"){
                            self.showalert("Updation is not allowed when the credit is under review", title: "Error", action: "OK")
                        }else{
                    self.addactiondata(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"), ID: self.currentarr["CreditShortId"] as! String, payload: str, year: Int(dict["year"] as! String)!)
                        }
                    }
                }else{
                    tempstring.append("{\"data\":\"{")
                    tempstring.append("'\(s)':'\(textView.text as String)'")
                    tempstring.append("}\"}")
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy"
                    let date = formatter.string(from: Date())
                    self.spinner.isHidden = false
                    self.view.isUserInteractionEnabled = false
                    if let creditDescription = self.currentarr["CreditStatus"] as? String{
                        if(creditDescription.lowercased() == "under review"){
                            self.showalert("Updation is not allowed when the credit is under review", title: "Error", action: "OK")
                        }else{
                    self.addactiondata(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"), ID: self.currentarr["CreditShortId"] as! String, payload: tempstring as String, year: Int(date)!)
                        }
                    }
                }
            }else if((currentarr["CreditDescription"] as! String).lowercased() == "meeting"){
                if(self.uploadsdata.count > 0){
                    var dict = (self.uploadsdata.firstObject as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    var tempdata = dict["data"] as! String
                    
                    tempdata = tempdata.replacingOccurrences(of: "'", with: "\"")
                    //print(tempdata)
                    dict["data"] = self.convertStringToDictionary(tempdata)
                    tempstring.append("{\"data\":\"{")
                    for (i,key) in ((dict["data"] as! NSDictionary).mutableCopy() as! NSDictionary).mutableCopy() as! NSMutableDictionary{
                        let item = i as! String
                        if(item != "meeting_docs_txtarea"){
                            tempstring.append("'\(item )':'\(key as! String)',")
                        }
                    }
                    var str = tempstring as String
                    if(tempstring != "{\"data\":\"{"){
                        //tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                    }
                    if(textView.text.characters.count > 0){
                        tempstring.append("'meeting_docs_txtarea':'\(textView.text as String)'")
                        //cell.tview.text = "\(dict["data"]!["land_use_txtarea"] as! String)"
                    }else{
                        tempstring.append("'meeting_docs_txtarea':''")
                    }
                    tempstring.append("}\"}")
                    str = tempstring as String
                    self.spinner.isHidden = false
                    self.view.isUserInteractionEnabled = false
                    if let creditDescription = self.currentarr["CreditStatus"] as? String{
                        if(creditDescription.lowercased() == "under review"){
                            self.showalert("Updation is not allowed when the credit is under review", title: "Error", action: "OK")
                        }else{
                    self.addactiondata(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"), ID: self.currentarr["CreditShortId"] as! String, payload: str, year: Int(dict["year"] as! String)!)
                        }
                    }
                }else{
                    tempstring.append("{\"data\":\"{")
                    tempstring.append("'meeting_docs_txtarea':'\(textView.text as String)'")
                    tempstring.append("}\"}")
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy"
                    let date = formatter.string(from: Date())
                    self.spinner.isHidden = false
                    self.view.isUserInteractionEnabled = false
                    if let creditDescription = self.currentarr["CreditStatus"] as? String{
                        if(creditDescription.lowercased() == "under review"){
                            self.showalert("Updation is not allowed when the credit is under review", title: "Error", action: "OK")
                        }else{
                    self.addactiondata(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"), ID: self.currentarr["CreditShortId"] as! String, payload: tempstring as String, year: Int(date)!)
                        }
                    }
                }
            }else if((currentarr["CreditDescription"] as! String).lowercased() == "roadmap"){
                if(self.uploadsdata.count > 0){
                    var dict = (self.uploadsdata.firstObject as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    var tempdata = dict["data"] as! String
                    
                    tempdata = tempdata.replacingOccurrences(of: "'", with: "\"")
                    //print(tempdata)
                    dict["data"] = self.convertStringToDictionary(tempdata)
                    tempstring.append("{\"data\":\"{")
                    for (i,key) in ((dict["data"] as! NSDictionary).mutableCopy() as! NSDictionary).mutableCopy() as! NSMutableDictionary{
                        let item = i as! String
                        if(item != "score_metrics_txtarea"){
                            tempstring.append("'\(item )':'\(key as! String)',")
                        }
                    }
                    var str = tempstring as String
                    if(tempstring != "{\"data\":\"{"){
                        //tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                    }
                    if(textView.text.characters.count > 0){
                        tempstring.append("'score_metrics_txtarea':'\(textView.text as String)'")
                        //cell.tview.text = "\(dict["data"]!["land_use_txtarea"] as! String)"
                    }else{
                        tempstring.append("'score_metrics_txtarea':''")
                    }
                    tempstring.append("}\"}")
                    str = tempstring as String
                    self.spinner.isHidden = false
                    self.view.isUserInteractionEnabled = false
                    if let creditDescription = self.currentarr["CreditStatus"] as? String{
                        if(creditDescription.lowercased() == "under review"){
                            self.showalert("Updation is not allowed when the credit is under review", title: "Error", action: "OK")
                        }else{
                    self.addactiondata(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"), ID: self.currentarr["CreditShortId"] as! String, payload: str, year: Int(dict["year"] as! String)!)
                        }
                    }
                }else{
                    tempstring.append("{\"data\":\"{")
                    tempstring.append("'score_metrics_txtarea':'\(textView.text as String)'")
                    tempstring.append("}\"}")
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy"
                    let date = formatter.string(from: Date())
                    self.spinner.isHidden = false
                    self.view.isUserInteractionEnabled = false
                    if let creditDescription = self.currentarr["CreditStatus"] as? String{
                        if(creditDescription.lowercased() == "under review"){
                            self.showalert("Updation is not allowed when the credit is under review", title: "Error", action: "OK")
                        }else{
                    self.addactiondata(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"), ID: self.currentarr["CreditShortId"] as! String, payload: tempstring as String, year: Int(date)!)
                        }
                    }
                }
            }
            
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return teammembers.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(tableView ==  feedstable){
            if(building_dict["project_type"] as! String == "city" || building_dict["project_type"] as! String == "community"){
                if(section == 0){
                    
                    if((currentarr["CreditDescription"] as! String).lowercased() == "additional details" || (currentarr["CreditDescription"] as! String).lowercased() == "additional data"){
                        
                        if(elementarr.count > 0){
                            return "Requirements (Please swipe left the below to explore data)"
                        }
                        return ""
                    }
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
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(statusupdate == 1){
            return teammembers[row] as? String
        }
        let dict = teammembers[row] as! NSDictionary
        return dict["Useralias"] as? String
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(tableView ==  feedstable){
            if(building_dict["project_type"] as! String == "city" || building_dict["project_type"] as! String == "community"){
                return 3
            }
        }
        return 1
    }
    var elementarr = NSMutableArray()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
                        if((currentarr["CreditDescription"] as! String).lowercased() == "human experience"){
                            return 4
                        }else if((currentarr["CreditDescription"] as! String).lowercased() == "transportation"){
                            return 1
                        }else if((currentarr["CreditDescription"] as! String).lowercased() == "waste"){
                            return 2
                        }else if((currentarr["CreditDescription"] as! String).lowercased() == "water"){
                            return 1
                        }else if((currentarr["CreditDescription"] as! String).lowercased() == "energy"){
                            return 1
                        }
                        else if((currentarr["CreditDescription"] as! String).lowercased() == "additional details" || (currentarr["CreditDescription"] as! String).lowercased() == "additional data"){
                            return elementarr.count
                        }
                        if(currentarr["CreditDescription"] as! String == "Governance" || currentarr["CreditDescription"] as! String == "Stakeholders" || currentarr["CreditDescription"] as! String == "Skateholders" ){
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
    
    @IBOutlet weak var sview: UIScrollView!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.contentInset = UIEdgeInsets.zero
        var s = ""
        var t = ""
        if(building_dict["project_type"] as! String == "city"){
            s = "city"
            t = "cities"
        }else{
            t = "communities"
            s = "community"
        }
        /*if(tableView == tableview){
            let cell = UITableViewCell()
            if(indexPath.section == 0){
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! prerequisitescell2
                cell.fileuploaded.isHidden = true
                cell.uploadbutton.isHidden = true
                cell.uploadanewfile.isHidden = true
                cell.assignedto.isHidden = false
                cell.editbutton.isHidden = false
                cell.editbutton.addTarget(self, action: #selector(edited), for: UIControlEvents.touchUpInside)
                cell.assignedto.isHidden = false
                if let assignedto = currentarr["PersonAssigned"] as? String{
                    var _ = assignedto
                    if(assignedto == ""){
                        cell.assignedto.text = "Assigned to None"
                    }else{
                        cell.assignedto.text = String(format:"Assigned to %@",assignedto)
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                }else{
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                    cell.assignedto.text = "Assigned to None"
                }
                cell.textLabel?.numberOfLines = 3
                cell.textLabel?.font = cell.assignedto.font
                cell.textLabel?.text = cell.assignedto.text
                cell.assignedto.text = ""
                
                return cell
                
            }
            return cell
        }*/
        if(indexPath.section == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! prerequisitescell2
            cell.fileuploaded.isHidden = true
            cell.uploadbutton.isHidden = true
            cell.uploadanewfile.isHidden = true
            cell.assignedto.isHidden = false
            cell.editbutton.isHidden = false
            cell.editbutton.addTarget(self, action: #selector(edited), for: UIControlEvents.touchUpInside)
            cell.assignedto.isHidden = false
            if let assignedto = currentarr["PersonAssigned"] as? String{
                var _ = assignedto
                if(assignedto == ""){
                    cell.assignedto.text = "Assigned to None"
                }else{
                    cell.assignedto.text = String(format:"Assigned to %@",assignedto)
                }
                cell.selectionStyle = UITableViewCellSelectionStyle.none
            }else{
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.assignedto.text = "Assigned to None"
            }
            cell.textLabel?.numberOfLines = 3
            cell.textLabel?.font = cell.assignedto.font
            cell.textLabel?.text = cell.assignedto.text
            cell.assignedto.text = ""
            return cell
        }
        
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            cell.textLabel?.numberOfLines = 5
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            if((currentarr["CreditDescription"] as! String).lowercased() == "human experience"){
                cell.selectionStyle = .none
                cell.textLabel?.text = humanarr[indexPath.row]
                return cell
            }else if((currentarr["CreditDescription"] as! String).lowercased() == "transportation"){
                cell.textLabel?.text = transportarr[indexPath.row]
                cell.selectionStyle = .none
                return cell
            }else if((currentarr["CreditDescription"] as! String).lowercased() == "waste"){
                cell.textLabel?.text = wastearr[indexPath.row]
                return cell
            }else if((currentarr["CreditDescription"] as! String).lowercased() == "water"){
                cell.textLabel?.text = waterarr[indexPath.row]
                return cell
            }else if((currentarr["CreditDescription"] as! String).lowercased() == "energy"){
                cell.textLabel?.text = energyarr[indexPath.row]
                return cell
            }else if((currentarr["CreditDescription"] as! String).lowercased() == "additional details" || (currentarr["CreditDescription"] as! String).lowercased() == "additional data"){
                let cell = tableView.dequeueReusableCell(withIdentifier: "additionalcell") as! additionalcell
                cell.selectionStyle = .none
                let data = (elementarr[indexPath.row] as! NSArray).mutableCopy() as! NSMutableArray
                cell.name.text = "Field : \(data[0] as! String)"
                cell.yr.text = "Year : \(data[3] as! String)"
                cell.val.text = "Value : \(data[1] as! String) | Unit : \(data[2] as! String)"
                return cell
            }else if(currentarr["CreditDescription"] as! String == "Commit to sharing data"){
                let cell = tableView.dequeueReusableCell(withIdentifier: "manageprojcellwithswitch")! as! manageprojcellwithswitch
                cell.yesorno.addTarget(self, action: #selector(self.datasharing(_:)), for: UIControlEvents.valueChanged)
                //
                if(self.uploadsdata.count > 0){
                    var dict = (self.uploadsdata.firstObject as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    var tempdata = dict["data"] as! String
                    
                    tempdata = tempdata.replacingOccurrences(of: "'", with: "\"")
                    //print(tempdata)
                    dict["data"] = self.convertStringToDictionary(tempdata)
                    if(dict["data"] != nil){
                        let d = dict["data"] as! NSDictionary
                        if let value = d["data_sharing_chk"] as? String{
                            if(value == "false"){
                                cell.yesorno.isOn = false
                            }else{
                                cell.yesorno.isOn = true
                            }
                        }
                    }
                }else{
                    cell.yesorno.isOn = false
                }
                
                //cell.valuetxtfld.keyboardType = UIKeyboardType.Default
                //cell.valuetxtfld.userInteractionEnabled = false
                cell.lbl?.font = UIFont.init(name: "OpenSans", size: 13)
                if(self.actiontitle.text == "Commit to sharing data"){
                    cell.lbl?.numberOfLines = 5
                    cell.lbl.adjustsFontSizeToFitWidth = true
                    cell.lbl?.text = "Commit to measuring each metric in the performance score on an ongoing basis."
                }
                cell.accessoryType = UITableViewCellAccessoryType.none
                return cell
            }else if (currentarr["CreditDescription"] as! String == "Project boundary" || currentarr["CreditDescription"] as! String == "Meeting" || currentarr["CreditDescription"] as! String == "Roadmap"){
                let cell = tableView.dequeueReusableCell(withIdentifier: "textcell")! as! textcell
                if(currentarr["CreditDescription"] as! String == "Roadmap"){
                    cell.tview.text = "For \(t) with existing plans:Upload or link to relevant planning documents, upload a crosswalk between goals or strategies in the relevant planning documents and categories in the performance score. \n For \(t) that are developing plans: Upload a document that: Lists goals, lists strategies under each goal, and lists the performance score metric associated with each strategy"
                    
                    if(self.uploadsdata.count > 0){
                        var dict = (self.uploadsdata.firstObject as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        var tempdata = dict["data"] as! String
                        
                        tempdata = tempdata.replacingOccurrences(of: "'", with: "\"")
                        //print(tempdata)
                        dict["data"] = self.convertStringToDictionary(tempdata)
                        if(dict["data"] != nil){
                            let d = dict["data"] as! NSDictionary
                            if let value = d["score_metrics_txtarea"] as? String{
                                if(value != ""){
                                    cell.tview.text = value
                                }
                            }
                        }
                    }
                    
                }else if(currentarr["CreditDescription"] as! String != "Meeting"){
                    if(building_dict["project_type"] as! String == "city"){
                        cell.tview.text = "Describe the \(s) and the types of land use types and building types it includes."
                    }else{
                        cell.tview.text = "Describe the \(s) and the types of land use types and building types it includes."
                    }
                    if((currentarr["CreditDescription"] as! String).lowercased() == "project boundary"){
                        if(self.uploadsdata.count > 0){
                            var dict = (self.uploadsdata.firstObject as! NSDictionary).mutableCopy() as! NSMutableDictionary
                            var tempdata = dict["data"] as! String
                            
                            tempdata = tempdata.replacingOccurrences(of: "'", with: "\"")
                            //print(tempdata)
                            dict["data"] = self.convertStringToDictionary(tempdata)
                            if(dict["data"] != nil){
                                let d = dict["data"] as! NSDictionary
                                if let value = d["land_use_txtarea"] as? String{
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
                        var dict = (self.uploadsdata.firstObject as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        var tempdata = dict["data"] as! String
                        
                        tempdata = tempdata.replacingOccurrences(of: "'", with: "\"")
                        //print(tempdata)
                        dict["data"] = self.convertStringToDictionary(tempdata)
                        if(dict["data"] != nil){
                            let d = dict["data"] as! NSDictionary
                            if let value = d["meeting_docs_txtarea"] as? String{
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
            }else if (currentarr["CreditDescription"] as! String == "Governance"){
                if(indexPath.row == 0){
                    let cell = tableView.dequeueReusableCell(withIdentifier: "textcell")! as! textcell
                    if(building_dict["project_type"] as! String == "city"){
                        cell.tview.text = "Describe the body or entity that conducts the policies, actions, and affairs for the \(s)."
                    }else{
                        cell.tview.text = "Describe the body or entity that conducts the policies, actions, and affairs for the \(s)."
                    }
                    cell.tview.font = UIFont.init(name: "OpenSans", size: 12)
                    cell.tview.tag = 0
                    cell.tview.delegate = self
                    if(self.uploadsdata.count > 0){
                        var dict = (self.uploadsdata.firstObject as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        var tempdata = dict["data"] as! String
                        
                        tempdata = tempdata.replacingOccurrences(of: "'", with: "\"")
                        dict["data"] = self.convertStringToDictionary(tempdata)
                        
                        if(dict["data"] != nil){
                            let d = dict["data"] as! NSDictionary
                            if let value = d["policy_entity_txtarea"] as? String{
                                if(value != ""){
                                    cell.tview.text = value
                                }
                            }
                        }
                    }
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "textcell")! as! textcell
                    cell.tview.text = "Describe the level of control/influence over infrastructure, operations, policies, and individual buildings for the project."
                    cell.tview.font = UIFont.init(name: "OpenSans", size: 12)
                    cell.tview.tag = 1
                    cell.tview.delegate = self
                    if(self.uploadsdata.count > 0){
                        var dict = (self.uploadsdata.firstObject as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        var tempdata = dict["data"] as! String
                        
                        tempdata = tempdata.replacingOccurrences(of: "'", with: "\"")
                        //print(tempdata)
                        dict["data"] = self.convertStringToDictionary(tempdata)
                        if(dict["data"] != nil){
                            let d = dict["data"] as! NSDictionary
                            if let value = d["influnence_txtarea"] as? String{
                                if(value != ""){
                                    cell.tview.text = value
                                }
                            }
                        }
                    }
                    return cell
                }
            }else if (currentarr["CreditDescription"] as! String == "Stakeholders" || currentarr["CreditDescription"] as! String == "Skateholders" ){
                let cell = tableView.dequeueReusableCell(withIdentifier: "textcell")! as! textcell
                if(indexPath.row == 0){
                    if(building_dict["project_type"] as! String == "city"){
                        cell.tview.text = "Project Team. Identify the names of individual stakeholders within the \(s) who will work on the LEED for \(t) certification and describe their role."
                    }else{
                        cell.tview.text = "Project Team. Identify the names of individual stakeholders within the \(s) who will work on the LEED for \(t) certification and describe their role."
                    }
                    cell.tview.font = UIFont.init(name: "OpenSans", size: 12)
                    cell.tview.tag = 0
                    cell.tview.delegate = self
                    if(self.uploadsdata.count > 0){
                        var dict = (self.uploadsdata.firstObject as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        var tempdata = dict["data"] as! String
                        
                        tempdata = tempdata.replacingOccurrences(of: "'", with: "\"")
                        //print(tempdata)
                        dict["data"] = self.convertStringToDictionary(tempdata)
                        if(dict["data"] != nil){
                            let d = dict["data"] as! NSDictionary
                            if let value = d["project_team_txtarea"] as? String{
                                if(value != ""){
                                    cell.tview.text = value
                                }
                            }
                        }
                    }
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "textcell")! as! textcell
                    if(building_dict["project_type"] as! String == "city"){
                        cell.tview.text = "\(s.capitalized) Engagement. Identify key stakeholder groups within the \(s) who the \(s) has engaged or will engage as part of its planning."
                    }else{
                        cell.tview.text = "\(s.capitalized) Engagement. Identify key stakeholder groups within the \(s) who the \(s) has engaged or will engage as part of its planning."
                    }
                    cell.tview.font = UIFont.init(name: "OpenSans", size: 12)
                    cell.tview.tag = 1
                    cell.tview.delegate = self
                    if(self.uploadsdata.count > 0){
                        var dict = (self.uploadsdata.firstObject as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        var tempdata = dict["data"] as! String
                        
                        tempdata = tempdata.replacingOccurrences(of: "'", with: "\"")
                        //print(tempdata)
                        dict["data"] = self.convertStringToDictionary(tempdata)
                        if(dict["data"] != nil){
                            let d = dict["data"] as! NSDictionary
                            if let value = d["key_stakeholder_txtarea"] as? String{
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

        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedcell")!
        cell.selectionStyle = .none
        if(currentfeeds.count > 0){
            if let dict = (currentfeeds.object(at: indexPath.row) as! NSDictionary).mutableCopy() as? NSMutableDictionary{
                if(dict["verb"] != nil){
                    cell.textLabel?.text = dict["verb"] as? String
                    var s = cell.textLabel?.text
                    s = s?.replacingOccurrences(of: "for  ", with: "for ")
                    cell.textLabel?.text = s
                    cell.textLabel?.numberOfLines = 5
                }
                var str = ""
                if(dict["timestamp"] != nil){
                    str = dict["timestamp"] as! String
                }
                
                let formatter = DateFormatter()
                formatter.dateFormat = credentials().micro_secs
                if(formatter.date(from: str) == nil){
                    formatter.dateFormat = credentials().milli_secs
                }
                let date = formatter.date(from: str)!
                formatter.dateFormat = "MMM dd, yyyy"
                str = formatter.string(from: date)
                cell.detailTextLabel?.numberOfLines = 5
                cell.textLabel?.numberOfLines = 5
                var str1 = String()
                formatter.dateFormat = "hh:mm a"
                str1 = formatter.string(from: date)
                cell.detailTextLabel?.text = "on \(str) at \(str1)"
            }else{
                
            }
        }
        return cell
    }
    @IBAction func assigneecancel(_ sender: Any) {
        self.assigncontainer.isHidden = true
        self.sview.alpha = 1
    }
    
    @IBAction func assigneesave(_ sender: Any) {
        DispatchQueue.main.async(execute: {
        self.view.isUserInteractionEnabled = false
        self.spinner.isHidden = false
        if let snapshotValue = self.teammembers[self.picker.selectedRow(inComponent: 0)] as? NSDictionary, let currentcountr = snapshotValue["Useralias"] as? String,let first_name = snapshotValue["Firstname"] as? String,let last_name = snapshotValue["Lastname"] as? String {
            self.assignnewmember(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"), actionID: self.currentarr["CreditId"] as! String, email:currentcountr,firstname:first_name,lastname: last_name)
        }
        })
    }
    var humanarr = ["Education","Equitablity", "Prosperity", "Health & Safety"]
    var transportarr = ["Vehicle miles traveled on individual vehicles daily (Miles)"]
    var wastearr = ["Municipal solid waste generation intensity (Tons/Year/Person)", "Municipal solid waste diversion rate from landfill (%)"]
    var waterarr = ["Water Consumption (Gallons/Year/Person)"]
    var energyarr = ["GHG Emissions (CO2 equivalent)"]
    func deleted(){
        //print("deleted")
    }
    
    
    func edited(){
        //print("edited")
        DispatchQueue.main.async(execute: {
            if let creditDescription = self.currentarr["CreditStatus"] as? String{
                if(creditDescription.lowercased() == "under review"){
                    self.showalert("Updation is not allowed when the credit is under review", title: "Error", action: "OK")
                }else{
            self.assignokbtn.isEnabled = false
            self.statusupdate = 0
            self.spinner.isHidden = false
            //self.view.userInteractionEnabled = false
            self.pleasekindly.text = "Please kindly the team member to assign this action"
            self.assignokbtn.setTitle("Assign", for: UIControlState())
            self.getteammembers(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"))
                }
            }
        })
    }
    
    func uploaded(){
        //print("uploaded")
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        assignokbtn.isEnabled = true
        if(statusupdate == 0){
            
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height = UIScreen.main.bounds.size.height
        if(tableView == tableview){
            return 0.022 * UIScreen.main.bounds.size.height
        }
        if(section == 0){
        return 0.034 * UIScreen.main.bounds.size.height//30
        }
        return 0.022 * UIScreen.main.bounds.size.height
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = UIScreen.main.bounds.size.height
        if(tableView == tableview){
            return  0.067 * height
        }
        if(tableView ==  feedstable){
            if(building_dict["project_type"] as! String == "city" || building_dict["project_type"] as! String == "community"){
                if(indexPath.section == 0 || indexPath.section == 1){
                    if(indexPath.section == 1){
                        return 0.067 * height
                    }else{
                        if((currentarr["CreditDescription"] as! String).lowercased() == "human experience" ||
                            (currentarr["CreditDescription"] as! String).lowercased() == "transportation" || (currentarr["CreditDescription"] as! String).lowercased() == "waste" || (currentarr["CreditDescription"] as! String).lowercased() == "water" || (currentarr["CreditDescription"] as! String).lowercased() == "energy"){
                            return 0.095 * height
                        }
                    }
                    return 0.118 * height
                }
            }
        }
        return 0.117 * height
    }
    
    func datasharing(_ sender:UISwitch){
        //data_sharing_chk
        let tempstring = NSMutableString()
        var check = false
        if(sender.isOn){
            check = true
        }
        
        if(self.uploadsdata.count > 0){
            var dict = (self.uploadsdata.firstObject as! NSDictionary).mutableCopy() as! NSMutableDictionary
            var tempdata = dict["data"] as! String
            
            tempdata = tempdata.replacingOccurrences(of: "'", with: "\"")
            //print(tempdata)
            dict["data"] = self.convertStringToDictionary(tempdata)
            tempstring.append("{\"data\":\"{")
            for (i,key) in ((dict["data"] as! NSDictionary).mutableCopy()  as! NSDictionary).mutableCopy() as! NSMutableDictionary{
                let item = i as! String
                if(item != "data_sharing_chk"){
                    tempstring.append("'\(item )':'\(key as! String)',")
                }
            }
            var str = tempstring as String
            if(tempstring != "{\"data\":\"{"){
                //tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
            }
            tempstring.append("'data_sharing_chk':'\(check )'")
            tempstring.append("}\"}")
            str = tempstring as String
            self.spinner.isHidden = false
            self.view.isUserInteractionEnabled = false
            self.addactiondata(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"), ID: self.currentarr["CreditShortId"] as! String, payload: str, year: Int(dict["year"] as! String)!)
        }else{
            tempstring.append("{\"data\":\"{")
            tempstring.append("'data_sharing_chk':'\(check )'")
            tempstring.append("}\"}")
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            let date = formatter.string(from: Date())
            self.spinner.isHidden = false
            self.view.isUserInteractionEnabled = false
            self.addactiondata(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"), ID: self.currentarr["CreditShortId"] as! String, payload: tempstring as String, year: Int(date)!)
        }
    }
    
    func getteammembers(_ subscription_key:String, leedid:Int){
        let url = URL.init(string:String(format: "%@assets/LEED:%d/teams/",domain_url, leedid))
        ////print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(session)
        self.task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.localizedDescription.contains("cancelled")) != nil){
                    if(error?._code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    //print("error=\(error?.localizedDescription)")
                    DispatchQueue.main.async(execute: {
                        self.tableview.isHidden = true
                        self.spinner.isHidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            }
            else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print(jsonDictionary)
                    let team_membersarray = jsonDictionary["EtTeamMembers"] as! NSArray
                    self.teammembers = team_membersarray
                    var temparr = NSMutableArray()
                    for item in self.teammembers{
                        var arr = item as! NSDictionary
                        if(arr["Rolestatus"] as! String != "Deactivated Relationship"){
                            temparr.add(arr)
                        }
                    }
                    var currentar = NSMutableArray()
                    var keys = NSMutableSet()
                    var result = NSMutableArray()
                    
                    
                    for d in temparr{
                        let data = d as! NSDictionary
                        var key = data["email"] as! String
                        if(keys.contains(key)){
                            continue
                        }
                        keys.add(key)
                        result.add(data)
                        
                    }
                    
                    //print(result)
                    self.teammembers = result
                    DispatchQueue.main.async(execute: {
                        self.assigncontainer.isHidden = false
                        self.spinner.isHidden = true
                        //self.view.userInteractionEnabled = true
                        self.picker.reloadAllComponents()
                    })
                    
                    //self.tableview.reloadData()
                    // self.buildingactions(subscription_key, leedid: leedid)
                } catch {
                    //print(error)
                    DispatchQueue.main.async(execute: {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
            }
            
        })
        task.resume()
    }
    
    
    @IBAction func affirmationview2close(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.beginFromCurrentState, animations: { () -> Void in
            //self.tableview.frame = self.actualtableframe
            self.affirmationview2.isHidden = true
        }, completion: { (finished: Bool) -> Void in
            
            // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
            
        })
    }
    
    @IBAction func previous(_ sender: AnyObject) {
        DispatchQueue.main.async(execute: {
        if(self.currentindex>0){
            /*if(task.currentRequest != nil){
             if (task.state == NSURLSessionTaskState.Running) {
             task.cancel()
             }
             }*/
            self.currentindex = self.currentindex-1
            UserDefaults.standard.set(self.currentindex, forKey: "selected_action")
            self.currentarr = (self.currentcategory[self.currentindex] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            if(self.checkcredit_type(self.currentarr) == "Data input"){
                //self.navigate()
                DispatchQueue.main.async(execute: {
                self.spinner.isHidden = false
                UserDefaults.standard.set(1, forKey: "notoast")
                self.buildingactions(credentials().subscription_key, leedid: self.leedid)
                })
            }else{
                //self.navigate()
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = false
                    UserDefaults.standard.set(1, forKey: "notoast")
                    self.buildingactions(credentials().subscription_key, leedid: self.leedid)
                })
            }
        }else{
            self.currentindex = self.currentcategory.count - 1
            UserDefaults.standard.set(self.currentindex, forKey: "selected_action")
            self.currentarr = (self.currentcategory[self.currentindex] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            var datakeyed = Data()
            datakeyed  = NSKeyedArchiver.archivedData(withRootObject: self.currentcategory)
                UserDefaults.standard.set(datakeyed, forKey: "currentcategory")
            //self.navigate()
            DispatchQueue.main.async(execute: {
                self.spinner.isHidden = false
                UserDefaults.standard.set(1, forKey: "notoast")
                self.buildingactions(credentials().subscription_key, leedid: self.leedid)
            })
        }
        })
    }
    @IBOutlet weak var ivupload2: UISwitch!
    
    @IBOutlet weak var assignokbtn: UIButton!
    @IBOutlet weak var assignclosebutton: UIButton!
    @IBOutlet weak var pleasekindly: UILabel!
    @IBOutlet weak var assigncontainer: UIView!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var ivattached2: UISwitch!
    
    @IBOutlet weak var ivupload1: UISwitch!
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let shareAction  = UITableViewRowAction(style: .normal, title: "Edit") { (rowAction, indexPath) in
            let data = (self.elementarr[indexPath.row] as! NSArray).mutableCopy() as! NSMutableArray
            self.sel_field = data[0] as! String
            self.sel_index = indexPath.row
            self.edit = 1
            self.performSegue(withIdentifier: "addnew", sender: nil)
        }
        let deleteAction  = UITableViewRowAction(style: .default, title: "Delete") { (rowAction, indexPath) in
            
            
            DispatchQueue.main.async(execute: {
                let alertController = UIAlertController(title: "Delete data", message: "Would you like to delete the selected data?", preferredStyle: .alert)
                let callActionHandler = { (action:UIAlertAction!) -> Void in
                    DispatchQueue.main.async(execute: {
                        var dict = (self.uploadsdata.firstObject as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        self.spinner.isHidden = false
                        self.view.isUserInteractionEnabled = false
                        self.delactiondata(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"), ID: self.currentarr["CreditShortId"] as! String, payload: "", year: Int(dict["year"] as! String)!)
                        
                    })
                    
                }
                
                let cancelActionHandler = { (action:UIAlertAction!) -> Void in
                    DispatchQueue.main.async(execute: {
                      tableView.setEditing(false, animated: true)
                    })
                    
                }
                let cancelAction = UIAlertAction(title: "No", style: .default, handler:cancelActionHandler)
                
                let defaultAction = UIAlertAction(title: "Yes", style: .destructive, handler:callActionHandler)
                
                alertController.addAction(cancelAction)
                alertController.addAction(defaultAction)
                
                alertController.view.subviews.first?.backgroundColor = UIColor.white
                alertController.view.layer.cornerRadius = 10
                alertController.view.layer.masksToBounds = true
                self.present(alertController, animated: true, completion: nil)
            
            })
        }
        deleteAction.backgroundColor = UIColor.init(red: 0.858, green: 0.211, blue: 0.196, alpha: 1)
        shareAction.backgroundColor = UIColor.init(red: 0.756, green: 0.756, blue: 0.756, alpha: 1)
        return [deleteAction,shareAction]
    }
    var sel_field = ""
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
                if ((currentarr["CreditDescription"] as! String).lowercased() == "additional details" || (currentarr["CreditDescription"] as! String).lowercased() == "additional data"){
        if(indexPath.section == 0){
            return indexPath.row >= 0 ? true : false
        }
        }
        return false
    }
    
    
    func navigate(){
        self.statusswitch.isHidden = false
        self.creditstatus.isHidden = false
        self.sview.scrollsToTop = true
        self.sview.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        addbtn.isHidden = true
        self.assigncontainer.isHidden = true
        currentindex = UserDefaults.standard.integer(forKey: "selected_action")
        UserDefaults.standard.synchronize()
        currentarr = (currentcategory[currentindex] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        //feedstable.hidden = true
        if(self.checkcredit_type(self.currentarr) == "Data input" || (currentarr["CreditDescription"] as! String).lowercased() == "additional details" || (currentarr["CreditDescription"] as! String).lowercased() == "additional data"){
         self.sview.frame.origin.y = 1.02 * (self.prev.frame.origin.y + self.prev.frame.size.height)
         self.feedstable.frame.origin.y = self.affirmationview1.frame.origin.y
        self.sview.frame.size.height = 1 * (self.tabbar.frame.origin.y - self.tabbar.frame.size.height)
            self.creditstatus.isHidden = true
            self.statusswitch.isHidden = true
            print(self.sview.frame.size.height)
        }else{
            self.creditstatus.isHidden = false
            self.statusswitch.isHidden = false
         self.sview.frame = framee
            self.feedstable.frame = tframee
        }
        showactivityfeed(UserDefaults.standard.integer(forKey: "leed_id"), creditID: currentarr["CreditId"] as! String, shortcreditID: currentarr["CreditShortId"] as! String)
        category.text = checkcredit_type(currentarr)
        category.isHidden = true
        self.actiontitle.text = currentarr["CreditDescription"] as? String
        self.creditstatus.text = currentarr["CreditStatus"] as? String
        if(self.creditstatus.text == ""){
            self.creditstatus.text = "Not available"
            self.statusswitch.isOn = false
        }else{
            if let creditstatus = currentarr["CreditStatus"] as? String{
                self.creditstatus.text = String(format: "%@",creditstatus.capitalized)
                if(creditstatus == "Ready for Review"){
                    creditstatusimg.image = UIImage.init(named: "tick")
                    self.statusswitch.isOn = true
                }else{
                    creditstatusimg.image = UIImage.init(named: "circle")
                    self.statusswitch.isOn = false
                }
            }else{
                self.statusswitch.isOn = false
            }
        }
        self.creditstatus.text = "Ready for Review"
        if let creditDescription = currentarr["CreditStatus"] as? String{
            if(creditDescription.lowercased() == "under review"){
                self.creditstatus.text = "Under review"                
                self.prev.isUserInteractionEnabled = true
                self.nxt.isUserInteractionEnabled = true
                self.sview.isUserInteractionEnabled = true
                self.tableview.isUserInteractionEnabled = true
                self.feedstable.isUserInteractionEnabled = true
                self.statusswitch.isEnabled = false
            }else{
                self.statusswitch.isEnabled = true
            }
        }
        self.actiontitle.isHidden = false
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
            self.actiontitle.isHidden = true
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
            shortcredit.image = self.imageWithImage(UIImage(named: "settings.png")!, scaledToSize: CGSize(width: 32, height: 32))
        }else{
            if((currentarr["CreditDescription"] as! String).lowercased() == "energy"){
                shortcredit.image = UIImage.init(named: "energy-border")
            }else if((currentarr["CreditDescription"] as! String).lowercased() == "water"){
                shortcredit.image = UIImage.init(named: "water-border")
            }else if((currentarr["CreditDescription"] as! String).lowercased() == "waste"){
                shortcredit.image = UIImage.init(named: "waste-border")
            }
            else if((currentarr["CreditDescription"] as! String).lowercased() == "transportation"){
                shortcredit.image = UIImage.init(named: "transport-border")
            }else if ((currentarr["CreditDescription"] as! String).lowercased() == "human experience"){
                shortcredit.image = UIImage.init(named: "human-border")
            }else{
                shortcredit.image = self.imageWithImage(UIImage(named: "settings.png")!, scaledToSize: CGSize(width: 32, height: 32))
            }
        }
        if ((currentarr["CreditDescription"] as! String).lowercased() == "additional details" || (currentarr["CreditDescription"] as! String).lowercased() == "additional data"){
            addbtn.isHidden = false
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
        DispatchQueue.main.async(execute: {
            self.tableview.isHidden = true
            self.spinner.isHidden = true
            for request in self.download_requests
            {
                request.invalidateAndCancel()
            }
                self.spinner.isHidden = false
                self.getuploadsdata(credentials().subscription_key, leedid: self.leedid, actionID: self.currentarr["CreditShortId"] as! String)
        })
        //self.getuploadsdata(c.subscription_key, leedid: 1000136954, actionID: currentarr["CreditId"] as! String)
    }
    
    func alignimageview (_ imageView: UIImageView, label : UILabel, superview : UIView){
        label.sizeToFit()
        imageView.frame = CGRect(x: (superview.frame.size.width - imageView.frame.size.width - label.frame.size.width)/2, y: imageView.frame.origin.y, width: imageView.frame.size.width, height: imageView.frame.size.height)
        label.frame = CGRect(x: imageView.frame.origin.x + imageView.frame.size.width, y: label.frame.origin.y, width: label.frame.size.width, height: imageView.frame.size.height)
    }

    
    func imageWithImage(_ image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
    @IBAction func next(_ sender: AnyObject) {
        if(currentindex<currentcategory.count-1){
            /*if(task.currentRequest != nil){
             if (task.state == NSURLSessionTaskState.Running) {
             task.cancel()
             }
             }*/
            currentindex = currentindex+1
            UserDefaults.standard.set(currentindex, forKey: "selected_action")
            currentarr = (currentcategory[currentindex] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            if(checkcredit_type(currentarr) == "Data input"){
                //self.performSegueWithIdentifier("datainput", sender: nil)
               /* let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                let listofactions = mainstoryboard.instantiateViewControllerWithIdentifier("listofactions")
                let datainput = mainstoryboard.instantiateViewControllerWithIdentifier("datainput")
                let rootViewController = self.navigationController
                var controllers = (rootViewController?.viewControllers)
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
                listofassets.navigationItem.title = dict["name"] as! String
                controllers.append(listofassets)
                controllers.append(listofactions)
                controllers.append(datainput)
                //self.navigationController?.setViewControllers(controllers, animated: false)*/
                DispatchQueue.main.async(execute: {
                //self.navigate()
                    DispatchQueue.main.async(execute: {
                        self.spinner.isHidden = false
                        UserDefaults.standard.set(1, forKey: "notoast")
                        self.buildingactions(credentials().subscription_key, leedid: self.leedid)
                    })
                })
            }else{
                DispatchQueue.main.async(execute: {
                //self.navigate()
                    
                })
                
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = false
                    UserDefaults.standard.set(1, forKey: "notoast")
                    self.buildingactions(credentials().subscription_key, leedid: self.leedid)
                })
            }
        }else{
            DispatchQueue.main.async(execute: {
            self.currentindex = 0
            UserDefaults.standard.set(self.currentindex, forKey: "selected_action")
            self.currentarr = (self.currentcategory[self.currentindex] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            var datakeyed = Data()
            datakeyed  = NSKeyedArchiver.archivedData(withRootObject: self.currentcategory)
            UserDefaults.standard.set(datakeyed, forKey: "currentcategory")
            //self.navigate()
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = false
                    UserDefaults.standard.set(1, forKey: "notoast")
                    self.buildingactions(credentials().subscription_key, leedid: self.leedid)
                })
            })
        }
    }
    
    
    @IBAction func affirmationview1close(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.beginFromCurrentState, animations: { () -> Void in
            //self.tableview.frame = self.actualtableframe
            self.affirmationview1.isHidden = true
            }, completion: { (finished: Bool) -> Void in
                
                // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
                
        })
    }
    
    
    
    
    @IBOutlet weak var activityfeedbutton: UIButton!
    @IBOutlet weak var tabbar: UITabBar!
    @IBAction func affirmationsclick(_ sender: AnyObject) {
        
        if(self.actiontitle.text?.contains("Policy"))!{
            self.affirmationview1.isHidden = true
            self.affirmationview2.isHidden = false
            self.affirmation1text.text = "The policy on the resources page has been implemented for the project."
            self.affirmation2text2.text = "And/or a custom policy meeting the prerequisite requirements has been implemented for the project. A copy of the policy has been uploaded."
            self.affirmationview2.isHidden = false
            feedstable.frame = CGRect(x: feedstable.frame.origin.x, y: affirmationview2.frame.origin.y + affirmationview2.frame.size.height, width: feedstable.frame.size.width, height: feedstable.frame.size.height)
            self.affirmationview2.transform = CGAffineTransform(scaleX: 1, y: 1);
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
            self.affirmationview1.isHidden = false
            self.affirmationview2.isHidden = true
            self.affirmationview1.isHidden = false
            feedstable.frame = CGRect(x: feedstable.frame.origin.x, y: affirmationview1.frame.origin.y + affirmationview1.frame.size.height, width: feedstable.frame.size.width, height: feedstable.frame.size.height)
            self.affirmationview1.transform = CGAffineTransform(scaleX: 1, y: 1);
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
    
    func getuploadsdata(_ subscription_key:String, leedid: Int, actionID: String){
        let url = URL.init(string: String(format: "%@assets/LEED:%d/actions/ID:%@/data/",credentials().domain_url,leedid,actionID))
        ////print(url?.absoluteURL)
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        //print(token)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(session)
        self.task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.localizedDescription.contains("cancelled")) != nil){
                    let httpStatus = response as? HTTPURLResponse
                    if(error?._code == -999){
                        
                    }else{
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    //print("error=\(error?.localizedDescription)")
                                        DispatchQueue.main.async(execute: {
                        self.tableview.isHidden = true
                        //       self.spinner.hidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                DispatchQueue.main.async(execute: {
                    //   self.spinner.hidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            }
            else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print("action data xcv",jsonDictionary)
                    self.uploadsdata = NSMutableArray()
                    self.elementarr = NSMutableArray()
                    self.uploadsdata = (jsonDictionary["results"] as! NSArray).mutableCopy() as! NSMutableArray
                    DispatchQueue.main.async(execute: {
                                    if ((self.currentarr["CreditDescription"] as! String).lowercased() == "additional details" || (self.currentarr["CreditDescription"] as! String).lowercased() == "additional data"){
                        //  self.spinner.hidden = true
                        //self.view.userInteractionEnabled = true
                        UserDefaults.standard.synchronize()
                        //  self.navigate()
                        
                        var i = 0
                        for j in self.uploadsdata{
                            let item = j as! NSDictionary
                            var data = item.mutableCopy() as! NSMutableDictionary
                            var tempdata = data["data"] as! String
                            
                            tempdata = tempdata.replacingOccurrences(of: "'", with: "\"")
                            //print(tempdata)
                            data["data"] = self.convertStringToDictionary(tempdata)
                            print(data)
                            for str in ((data["data"] as! NSDictionary).mutableCopy() as! NSDictionary){
                                var token = ((str.key) as! String).components(separatedBy: "_num_unit")
                                if(token.count > 1 ){
                                    var arr = NSMutableArray()
                                    var d = data["data"] as! NSDictionary
                                    print("\(token[0] as! String)_num_name")
                                    arr.add(d["\(token[0] as! String)_num_name"] as! String)
                                    arr.add(d["\(token[0] as! String)_num"] as! String)
                                    arr.add(d["\(token[0] as! String)_num_unit"] as! String)
                                    d = data as! NSDictionary
                                    arr.add(d["year"] as! String)
                                    arr.add(token[0])
                                    self.elementarr.add(arr)
                                }
                            }
                            
                            
                            var j = 0
                            var z = 0
                            
                            j = ((data["data"] as! NSDictionary).allValues.count)
                            if(j > 0 ){
                                z = (j/3)
                            }
                            i += z
                        }
                        //print("Number of data",i,self.elementarr)
                        }
                        self.showactivityfeed(UserDefaults.standard.integer(forKey: "leed_id"), creditID: self.currentarr["CreditId"] as! String, shortcreditID: self.currentarr["CreditShortId"] as! String)
                        self.feedstable.reloadData()
                    })
                } catch {
                    //print(error)
                    DispatchQueue.main.async(execute: {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
            }
            
        })
        task.resume()
    }
    
    
    func addactiondata(_ subscription_key:String, leedid: Int, ID : String, payload : String, year : Int){
        let url = URL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@/data/%d/",credentials().domain_url, leedid,ID,year))
        ////print(url?.absoluteURL)
        var subscription_key = credentials().subscription_key
        var token = UserDefaults.standard.object(forKey: "token") as! String
        DispatchQueue.main.async(execute: {
            self.view.isUserInteractionEnabled = false
        })
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "POST"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var httpbody = payload
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
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401{
                DispatchQueue.main.async(execute: {
                    //self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                    
                })
                return
            } else
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 && httpStatus.statusCode != 201{           // check for http errors
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
                            self.view.isUserInteractionEnabled = true
                            self.maketoast("Updated successfully", type: "message")
                            //self.navigationController?.popViewControllerAnimated(true)
                            self.navigate()
                        })
                    } catch {
                        //print(error)
                    }
            }
            
        })
        task.resume()
        
        
    }

    func delactiondata(_ subscription_key:String, leedid: Int, ID : String, payload : String, year : Int){
        let url = URL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@/data/%d/",credentials().domain_url, leedid,ID,year))
        ////print(url?.absoluteURL)
        var subscription_key = credentials().subscription_key
        var token = UserDefaults.standard.object(forKey: "token") as! String
        DispatchQueue.main.async(execute: {
            self.view.isUserInteractionEnabled = false
        })
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "DELETE"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var httpbody = "{}"
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
            if let httpStatus = response as? HTTPURLResponse{
                print(httpStatus.statusCode)
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
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 && httpStatus.statusCode != 201{           // check for http errors
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
                    } catch {
                        //print(error)
                    }
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200{
                        DispatchQueue.main.async(execute: {
                            self.view.isUserInteractionEnabled = true
                            self.maketoast("Deleted successfully", type: "message")
                            //self.navigationController?.popViewControllerAnimated(true)
                            self.navigate()
                        })
                    }
                    
            }
            
        })
        task.resume()
        
        
    }

    
    
    func getcreditformsuploadsdata(_ subscription_key:String, leedid: Int, actionID: String){
        
        let url = URL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@/uploads/",domain_url, leedid, actionID))
        ////print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(session)
        self.task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.localizedDescription.contains("cancelled")) != nil){
                    if(error?._code == -999){
                        
                    }else{
                   self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    //print("error=\(error?.localizedDescription)")
                                        DispatchQueue.main.async(execute: {
                        self.tableview.isHidden = true
                        self.spinner.isHidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            }
            else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    self.uploadsdata = jsonDictionary["EtFile"] as! NSArray
                    //print(jsonDictionary)
                    self.spinner.isHidden = true
                    //self.view.userInteractionEnabled = true
                    //self.tableview.reloadData()
                    // self.buildingactions(subscription_key, leedid: leedid)
                } catch {
                    //print(error)
                    DispatchQueue.main.async(execute: {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
            }
            
        })
        task.resume()
    }
    
    
    @IBOutlet weak var backbtn: UIButton!
    
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if((currentarr["CreditDescription"] as! String).lowercased() == "human experience" ||
            (currentarr["CreditDescription"] as! String).lowercased() == "transportation" || (currentarr["CreditDescription"] as! String).lowercased() == "waste" || (currentarr["CreditDescription"] as! String).lowercased() == "water" || (currentarr["CreditDescription"] as! String).lowercased() == "energy"){
            index = indexPath.row
            if(indexPath.section == 0){
                self.performSegue(withIdentifier: "yearlydata", sender: nil)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        //print("Selected")
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    var sel_index = 0
    var index = 0
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "gotofeeds"){
            let vc = segue.destination as! feeds
            vc.currentfeeds = currentfeeds
        }else if(segue.identifier == "yearlydata"){
            let vc = segue.destination as! yearlydata
            vc.currentdict = currentarr
            if((currentarr["CreditDescription"] as! String).lowercased() == "transportation" || (currentarr["CreditDescription"] as! String).lowercased() == "waste" || (currentarr["CreditDescription"] as! String).lowercased() == "water" || (currentarr["CreditDescription"] as! String).lowercased() == "energy"){
                vc.currenttitle = (currentarr["CreditDescription"] as! String).lowercased()
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
            let vc = segue.destination as! addnew
            vc.currentarr = currentarr as NSDictionary
            vc.listofdata = elementarr
            vc.edit = edit
            if(edit == 1){
            vc.currentfield = sel_field
            vc.sel_index = sel_index                
            }
        }
    }
    var edit = 0
    
    @IBAction func assignclose(_ sender: AnyObject) {
        self.assigncontainer.isHidden = true
    }
    
    func assignnewmember(_ subscription_key:String, leedid: Int, actionID: String, email:String,firstname: String, lastname:String){
        //https://api.usgbc.org/dev/leed/assets/LEED:{leed_id}/actions/ID:{action_id}/teams/
        let url = URL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@/teams/",domain_url, leedid, actionID))
        ////print(url?.absoluteURL)
        DispatchQueue.main.async(execute: {
            self.view.isUserInteractionEnabled = false
        })
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "POST"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let httpbody = String(format: "{\"emails\":\"%@\"}",email)
        request.httpBody = httpbody.data(using: String.Encoding.utf8)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(session)
        self.task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.localizedDescription.contains("cancelled")) != nil){
                    if(error?._code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    //print("error=\(error?.localizedDescription)")
                                        DispatchQueue.main.async(execute: {
                        self.tableview.isHidden = true
                        self.spinner.isHidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            }
            else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print(jsonDictionary)
                    DispatchQueue.main.async(execute: {
                        self.currentarr["PersonAssigned"] = String(format: "%@ %@",firstname,lastname)
                        self.currentcategory.replaceObject(at: self.currentindex, with: self.currentarr)
                        self.assigncontainer.isHidden = true
                        //self.view.userInteractionEnabled = true
                            UserDefaults.standard.set(0, forKey: "notoast")
                        self.buildingactions(subscription_key, leedid: leedid)
                    })
                    //self.tableview.reloadData()
                    // self.buildingactions(subscription_key, leedid: leedid)
                } catch {
                    //print(error)
                    DispatchQueue.main.async(execute: {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
            }
            
        })
        task.resume()
    }
    
    
    func buildingactions(_ subscription_key:String, leedid: Int){
        let url = URL.init(string: String(format: "%@assets/LEED:%d/actions/",domain_url,leedid))
        ////print(url?.absoluteURL)
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(session)
        self.task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.localizedDescription.contains("cancelled")) != nil){
                    if(error?._code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    //print("error=\(error?.localizedDescription)")
                                        DispatchQueue.main.async(execute: {
                        self.tableview.isHidden = true
                        self.spinner.isHidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            }
            else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print("Building xcv",jsonDictionary)
                    DispatchQueue.main.async(execute: {
                        let datakeyed = NSKeyedArchiver.archivedData(withRootObject: jsonDictionary)
                        UserDefaults.standard.set(datakeyed, forKey: "actions_data")
                        self.spinner.isHidden = true
                        self.view.isUserInteractionEnabled = true
                        UserDefaults.standard.synchronize()
                        self.currentcategory = (jsonDictionary["EtScorecardList"] as! NSArray).mutableCopy() as! NSMutableArray
                        self.navigate()
                        if(UserDefaults.standard.integer(forKey: "notoast") == 0){
                            self.maketoast("Updated successfully", type: "message")
                        }
                        return
                    })
                } catch {
                    //print(error)
                    DispatchQueue.main.async(execute: {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
            }
            
        })
        task.resume()
    }
    
    @IBAction func okassignthemember(_ sender: AnyObject) {
        if(statusupdate == 1){
            self.view.isUserInteractionEnabled = false
            self.spinner.isHidden = false
            savestatusupdate(currentarr["CreditId"] as! String, subscription_key: credentials().subscription_key)
            
        }else{
            self.view.isUserInteractionEnabled = false
            self.spinner.isHidden = false
            
            if let current = teammembers[picker.selectedRow(inComponent: 0)] as? NSDictionary{
            
            assignnewmember(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"), actionID: currentarr["CreditId"] as! String, email:current["Useralias"] as! String,firstname:current["Firstname"] as! String,lastname: current["Lastname"] as! String)
            }
        }
    }
    
    func affirmationupdate(_ actionID:String, leedid: Int, subscription_key:String){
        //
        var url = URL.init(string:"")
        let s = String(format:"%d",leedid)
        if(actionID.contains(s)){
            url = URL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@/",domain_url, leedid, actionID))!
        }
        else{
            url = URL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@-%d/",domain_url, leedid, actionID,leedid))!
        }
        ////print(url.absoluteString)
        DispatchQueue.main.async(execute: {
            self.view.isUserInteractionEnabled = false
        })
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "PUT"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var httpbody = String()
        if(self.actiontitle.text?.contains("Policy"))!{
            httpbody = String(format: "{\"IvAttchPolicy\": %@, \"IvReqFileupload\": %@}",self.ivattached2.isOn as CVarArg,ivupload2.isOn as CVarArg)
        }else{
            httpbody = String(format: "{\"IvAttchPolicy\": %@, \"IvReqFileupload\": %@}",self.ivattached2.isOn as CVarArg,ivupload1.isOn as CVarArg)
        }
        request.httpBody = httpbody.data(using: String.Encoding.utf8)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(session)
        self.task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.localizedDescription.contains("cancelled")) != nil){
                    if(error?._code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    //print("error=\(error?.localizedDescription)")
                                        DispatchQueue.main.async(execute: {
                        self.tableview.isHidden = true
                        self.spinner.isHidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            }
            else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401{
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            } else
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 && httpStatus.statusCode != 201 {           // check for http errors
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                    DispatchQueue.main.async(execute: {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }else{
                    
                    var jsonDictionary : NSDictionary
                    do {
                        if(self.actiontitle.text?.contains("Policy"))!{
                            if(self.ivattached2.isOn == true){
                                self.currentarr["IvAttchPolicy"] = "X"
                            }else{
                                self.currentarr["IvAttchPolicy"] = ""
                            }
                            
                            if(self.ivupload2.isOn == true){
                                self.currentarr["IvReqFileupload"] = "X"
                            }else{
                                self.currentarr["IvReqFileupload"] = ""
                            }
                        }else{
                            if(self.ivattached2.isOn == true){
                                self.currentarr["IvAttchPolicy"] = "X"
                            }else{
                                self.currentarr["IvAttchPolicy"] = ""
                            }
                            
                            if(self.ivupload1.isOn == true){
                                self.currentarr["IvReqFileupload"] = "X"
                            }else{
                                self.currentarr["IvReqFileupload"] = ""
                            }
                        }
                        self.currentcategory.replaceObject(at: UserDefaults.standard.integer(forKey: "selected_action"), with: self.currentarr)
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        //print(jsonDictionary)
                        UserDefaults.standard.set(0, forKey: "notoast")
                        self.buildingactions(subscription_key, leedid: leedid)
                        //self.tableview.reloadData()
                        //
                    } catch {
                        //print(error)
                        DispatchQueue.main.async(execute: {
                            self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                            
                        })
                    }
            }
            
        })
        task.resume()
        
    }
    
    
    
    
    func selectedaction(){
        
    }
    
    func valuechanged(_ sender:UISwitch){
        if let creditDescription = self.currentarr["CreditStatus"] as? String{
            if(creditDescription.lowercased() == "under review"){
                self.showalert("Updation is not allowed when the credit is under review", title: "Error", action: "OK")
            }else{
        if(sender.tag == 101 || sender.tag == 102 || sender.tag == 103){
            DispatchQueue.main.async(execute: {
                self.spinner.isHidden = false
                //self.view.userInteractionEnabled = false
            })
            
            affirmationupdate(currentarr["CreditId"] as! String, leedid: leedid, subscription_key: credentials().subscription_key)
        }
            }
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
        DispatchQueue.main.async(execute: {
            self.view.isUserInteractionEnabled = true
        })
        //        }
        //      let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        //    alertController.addAction(defaultAction)
        
        //presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    
    func savestatusupdate(_ actionID:String, subscription_key:String){
        //
        var url = URL.init(string:"")
        let s = String(format:"%d",leedid)
        if(actionID.contains(s)){
            url = URL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@/",domain_url, leedid, actionID))!
        }
        else{
            url = URL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@-%d/",domain_url, leedid, actionID,leedid))!
        }
        ////print(url.absoluteString)
        DispatchQueue.main.async(execute: {
            self.view.isUserInteractionEnabled = false
        })
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "PUT"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var httpbody = String()
        let string = self.statusarr[self.picker.selectedRow(inComponent: 0)] as! String
        /*if(string == "Ready for review"){
            httpbody = String(format: "{\"is_readyForReview\": %@}",true)
        }else{
            httpbody = String(format: "{\"is_readyForReview\": %@}",false)
        }*/
        if(statusswitch.isOn == true){
            httpbody = String(format: "{\"is_readyForReview\": %@}",statusswitch.isOn as CVarArg)
        }else{
            httpbody = String(format: "{\"is_readyForReview\": %@}",statusswitch.isOn as CVarArg)
        }
        request.httpBody = httpbody.data(using: String.Encoding.utf8)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(session)
        self.task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.localizedDescription.contains("cancelled")) != nil){
                    if(error?._code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    //print("error=\(error?.localizedDescription)")
                                        DispatchQueue.main.async(execute: {
                        self.tableview.isHidden = true
                        self.spinner.isHidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            }
            else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401{
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            } else
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 && httpStatus.statusCode != 201 {           // check for http errors
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                    DispatchQueue.main.async(execute: {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }else{
                    
                    var jsonDictionary : NSDictionary
                    do {
                        
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        //print(jsonDictionary)
                        DispatchQueue.main.async(execute: {
                            self.creditstatus.text = string
                            self.currentarr["CreditStatus"] = string
                            self.currentcategory.replaceObject(at: UserDefaults.standard.integer(forKey: "selected_action"), with: self.currentarr)
                            UserDefaults.standard.set(0, forKey: "notoast")
                            self.buildingactions(subscription_key, leedid: self.leedid)
                        })
                    } catch {
                        //print(error)
                        DispatchQueue.main.async(execute: {
                            self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                            
                        })
                    }
            }
            
        }) 
        task.resume()
    }
    
    @IBAction func changestatus(_ sender: AnyObject) {
        self.statusupdate(UILabel())
    }
    
    
}
