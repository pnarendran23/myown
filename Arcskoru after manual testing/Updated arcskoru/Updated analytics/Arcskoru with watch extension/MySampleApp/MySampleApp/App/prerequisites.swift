//
//  prerequisites.swift
//  LEEDOn
//
//  Created by Group X on 16/11/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class prerequisites: UIViewController, UITableViewDataSource,UITableViewDelegate,UITabBarDelegate, UIPickerViewDelegate,UIPickerViewDataSource {
    @IBOutlet weak var actiontitle: UILabel!
    var uploadsdata = NSArray()
    var leedid = UserDefaults.standard.integer(forKey: "leed_id")
    
    @IBOutlet weak var statusswitch: UISwitch!
    @IBOutlet weak var feedstable: UITableView!
    var filescount = 1
    var download_requests = [URLSession]()
    var statusarr = ["Ready for Review"]
    var statusupdate = 0
    var currentfeeds = NSArray()
    var task = URLSessionTask()
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
    var fromnotification = UserDefaults.standard.integer(forKey: "fromnotification")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tempframe = self.actiontitle.frame
        fromnotification = UserDefaults.standard.integer(forKey: "fromnotification")
        self.feedstable.isScrollEnabled = false
            if(self.fromnotification == 1){
                self.prev.isHidden = true
                self.nxt.isHidden = true
            }else{
                self.prev.isHidden = false
                self.nxt.isHidden = false
            }
        self.titlefont()
        //self.prev.layer.frame.origin.x = 0.98 * (self.nxt.layer.frame.origin.x - self.prev.layer.frame.size.width)
        afriamtion1title.adjustsFontSizeToFitWidth = true
        affirmation1text.adjustsFontSizeToFitWidth = true
        affirmation2text2.font = affirmation1text.font
        affirmation2text1.font = affirmation1text.font
        affirmation2text1.adjustsFontSizeToFitWidth = true
        affirmation2text2.adjustsFontSizeToFitWidth = true
        affirmation2title.adjustsFontSizeToFitWidth = true
        
        if(UIDevice.current.orientation == .portrait){
        sview.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
        }else{
        //sview.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.height,UIScreen.mainScreen().bounds.size.width)
        }
        backbtn.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12)
        let notificationsarr = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "notifications") as! Data) as! NSArray
        let plaque = UIImage.init(named: "score")
        let credits = UIImage.init(named: "Menu_icon")
        let analytics = UIImage.init(named: "chart")
        let more = UIImage.init(named: "more")
        self.tabbar.setItems([UITabBarItem.init(title: "Score", image: plaque, tag: 0),UITabBarItem.init(title: "Credits/Actions", image: credits, tag: 1),UITabBarItem.init(title: "Analytics", image: analytics, tag: 2),UITabBarItem.init(title: "More", image: more, tag: 3)], animated: false)
        self.tabbar.selectedItem = self.tabbar.items![1]
        if(notificationsarr.count > 0 ){
            
        self.tabbar.items![3].badgeValue = "\(notificationsarr.count)"
        }else{
            self.tabbar.items![3].badgeValue = nil
        }        
        self.spinner.layer.cornerRadius = 5
        self.spinner.isHidden = true
        //self.view.userInteractionEnabled = true
        self.assigncontainer.addSubview(picker)
        self.assigncontainer.addSubview(pleasekindly)
        self.assigncontainer.addSubview(assignokbtn)
        self.assigncontainer.addSubview(assignclosebutton)
        assignokbtn.isEnabled = false
        picker.delegate = self
        picker.dataSource = self
        self.prev.layer.cornerRadius = 4
        self.nxt.layer.cornerRadius = 4
        self.tabbar.delegate = self
        self.tabbar.selectedItem = self.tabbar.items![1]
        tableview.register(UINib.init(nibName: "prerequisitescell1", bundle: nil), forCellReuseIdentifier: "cell1")
        tableview.register(UINib.init(nibName: "prerequisitescell2", bundle: nil), forCellReuseIdentifier: "cell2")
        actualtableframe = tableview.frame
        var datakeyed = Data()
        token = UserDefaults.standard.object(forKey: "token") as! String
        datakeyed = UserDefaults.standard.object(forKey: "currentcategory") as! Data
        currentcategory = (NSKeyedUnarchiver.unarchiveObject(with: datakeyed) as! NSArray).mutableCopy() as! NSMutableArray
        currentindex = UserDefaults.standard.integer(forKey: "selected_action")
        UserDefaults.standard.synchronize()
        //print("aarra", currentcategory)
        currentarr = (currentcategory[currentindex] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        category.text = checkcredit_type(currentarr as! NSMutableDictionary)
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
        let c = credentials()
        domain_url = c.domain_url
        let dict = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary
        assetname.text = dict["name"] as? String
        self.navigationItem.title = dict["name"] as? String
        let navItem = UINavigationItem(title: (dict["name"] as? String)!);
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
        ivupload1.addTarget(self, action: #selector(prerequisites.valuechanged(_:)), for: UIControlEvents.valueChanged)
        ivupload2.addTarget(self, action: #selector(prerequisites.valuechanged(_:)), for: UIControlEvents.valueChanged)
        ivattached2.addTarget(self, action: #selector(prerequisites.valuechanged(_:)), for: UIControlEvents.valueChanged)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(datainput.statusupdate(_:)))
        //self.creditstatus.userInteractionEnabled = true
        //self.creditstatus.addGestureRecognizer(tap)
        
        navigate()
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.shouldRotate = false
        
        // 2. Force the device in landscape mode when the view controller gets loaded
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /*self.affirmation1text.font = UIFont.init(name: "OpenSans", size: 0.05 * self.affirmation1text.layer.frame.size.width)
        self.affirmation2text1.font = UIFont.init(name: "OpenSans", size: 0.05 * self.affirmation2text1.layer.frame.size.width)
        self.affirmation2text2.font = UIFont.init(name: "OpenSans", size:0.05 * self.affirmation2text2.layer.frame.size.width)
        self.affirmation2title.font = UIFont.init(name: "OpenSans", size:0.05 * self.affirmation2title.layer.frame.size.width)
        self.afriamtion1title.font = UIFont.init(name: "OpenSans", size:0.05 * self.affirmation2title.layer.frame.size.width)
        self.actiontitle.font = UIFont.init(name: "OpenSans", size:0.041 * self.actiontitle.layer.frame.size.width)
        self.category.font = UIFont.init(name: "OpenSans-Semibold", size:0.05 * self.category.layer.frame.size.width)*/
        self.category.adjustsFontSizeToFitWidth = true
        feedstable.isScrollEnabled = true
        feedstable.bounces = true
        feedstable.frame = CGRect(x: feedstable.frame.origin.x, y: tableview.frame.origin.y + tableview.frame.size.height, width: feedstable.frame.size.width, height: feedstable.frame.size.height)
        if(fromnotification == 1){
            self.navigationController?.navigationBar.backItem?.title = "Notifications"
        }else{
            self.navigationController?.navigationBar.backItem?.title = "Credits/Actions"
        }
        if(UIDevice.current.orientation == .portrait){
            
        }else{
            //sview.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.height,UIScreen.mainScreen().bounds.size.width)
        }
        sview.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: CGFloat(1.0 + (Float(currentfeeds.count)/10.0)) * UIScreen.main.bounds.size.height)
        self.navigate()
    }
    
    func alignimageview (_ imageView: UIImageView, label : UILabel, superview : UIView){
        label.sizeToFit()
        imageView.frame = CGRect(x: (superview.frame.size.width - imageView.frame.size.width - label.frame.size.width)/2, y: imageView.frame.origin.y, width: imageView.frame.size.width, height: imageView.frame.size.height)
        label.frame = CGRect(x: imageView.frame.origin.x + imageView.frame.size.width, y: label.frame.origin.y, width: label.frame.size.width, height: label.frame.size.height)
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
            //self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as? String
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
                        //self.tableview.hidden = false
                        self.spinner.isHidden = true
                        self.tableview.frame = CGRect(x: self.tableview.layer.frame.origin.x, y: 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), width: self.tableview.layer.frame.size.width,  height: 50)
                        self.feedstable.frame = CGRect(x: self.feedstable.frame.origin.x, y: self.tableview.frame.origin.y + self.tableview.frame.size.height, width: self.feedstable.frame.size.width, height: CGFloat(self.currentfeeds.count+1) * 0.095 * UIScreen.main.bounds.size.height)
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
                        self.sview.isHidden = false
                        self.view.isUserInteractionEnabled = true
                        self.view.isUserInteractionEnabled = true
                        //self.performSegueWithIdentifier("gotofeeds", sender: nil)
                        if(self.currentfeeds.count > 0){
                            self.feedstable.isHidden = false
                        }else{
                            //self.feedstable.hidden = true
                        }
                        self.feedstable.frame = CGRect(x: self.feedstable.frame.origin.x, y: self.tableview.frame.origin.y + self.tableview.frame.size.height, width: self.feedstable.frame.size.width, height: CGFloat(self.currentfeeds.count+1) * 0.095 * UIScreen.main.bounds.size.height)
                        if(self.affirmationview1.isHidden == false){
                        self.sview.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: self.tableview.frame.size.height + self.affirmationview1.frame.size.height + self.feedstable.frame.size.height)
                        }else{
                        self.sview.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: self.tableview.frame.size.height + self.affirmationview2.frame.size.height + self.feedstable.frame.size.height)
                        }
                        self.feedstable.reloadData()
                        self.statusswitch.isHidden = false
                        self.creditstatus.isHidden = false
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
            self.sview.alpha = 1
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
    
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return teammembers.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(tableView == feedstable){
            if(currentfeeds.count > 0){
            return "Activities"
            }
            return "No activities present"
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(statusupdate == 1){
            return teammembers[row] as? String
        }
        if let teammember = teammembers[row] as? NSDictionary, let alias = teammember["Useralias"] as? String{
        return alias
        }
        return ""
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*if(section == 1){
            return 1
        }else if (section == 2){
            return uploadsdata.count+1
        }*/
        if(tableView == tableview){
        return 1
        }
        
        return currentfeeds.count
    }
    
    @IBOutlet weak var sview: UIScrollView!
    var tempframe = CGRect()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == tableview){
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
            //cell.assignedto.font = afriamtion1title.font
            cell.textLabel?.text = cell.assignedto.text
            cell.textLabel?.font = cell.assignedto.font
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            //cell.textLabel?.font = afriamtion1title.font
            self.affirmation1text.frame.origin.x = cell.textLabel!.frame.origin.x
            self.affirmation2text1.frame.origin.x = cell.textLabel!.frame.origin.x
            self.affirmation2text2.frame.origin.x = cell.textLabel!.frame.origin.x
            cell.assignedto.text = ""
                return cell
        }
        return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedcell")!
        
        var dict = (currentfeeds.object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        cell.textLabel?.text = dict["verb"] as? String
        var s = cell.textLabel?.text
        s = s?.replacingOccurrences(of: "for  ", with: "for ")
        cell.textLabel?.text = s
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        var str = dict["timestamp"] as! String
        let formatter = DateFormatter()
        
        //cell.textLabel?.font = UIFont.init(name: "OpenSans", size: 0.025 * UIScreen.mainScreen().bounds.size.height)
        //cell.detailTextLabel?.font = UIFont.init(name: "OpenSans", size: 0.021 * UIScreen.mainScreen().bounds.size.height)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
        //cell.textLabel?.font = afriamtion1title.font
        //cell.detailTextLabel?.font = affirmation1text.font
        formatter.dateFormat = credentials().micro_secs
        if(formatter.date(from: str) != nil){
            
        }else{
            formatter.dateFormat = credentials().milli_secs
        }
        
        let date = formatter.date(from: str)!
        //print(date)
        formatter.dateFormat = "MMM dd, yyyy"
        str = formatter.string(from: date)
        cell.detailTextLabel?.numberOfLines = 5
        cell.textLabel?.numberOfLines = 5
        var str1 = String()
        formatter.dateFormat = "hh:mm a"
        str1 = formatter.string(from: date)
        cell.detailTextLabel?.text = "on \(str) at \(str1)"
        return cell
        
    }

    func deleted(){
        //print("deleted")
    }
    

    func edited(){
            //print("edited")
            DispatchQueue.main.async(execute: {
                self.assignokbtn.isEnabled = false
                self.statusupdate = 0
                self.spinner.isHidden = false
                //self.view.userInteractionEnabled = false
                self.pleasekindly.text = "Please kindly the team member to assign this action"
                self.assignokbtn.setTitle("Assign", for: UIControlState())
                self.getteammembers(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"))
            })
    }

    func uploaded(){
        //print("uploaded")
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        assignokbtn.isEnabled = true
        if(statusupdate == 0){
        
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if(tableView == tableview){
        return 1
        }
        return 0.045 * UIScreen.main.bounds.size.height
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(tableView == tableview){
        return tableview.frame.size.height
        }
        return 0.096 * UIScreen.main.bounds.size.height
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
                        //self.tableview.hidden = false
                        self.spinner.isHidden = true
                        self.tableview.frame = CGRect(x: self.tableview.layer.frame.origin.x, y: 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), width: self.tableview.layer.frame.size.width,  height: 50)
                        self.feedstable.frame = CGRect(x: self.feedstable.frame.origin.x, y: self.tableview.frame.origin.y + self.tableview.frame.size.height, width: self.feedstable.frame.size.width, height: CGFloat(self.currentfeeds.count+1) * 0.095 * UIScreen.main.bounds.size.height)
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
                        var data = d as! NSDictionary
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
                        self.sview.alpha = 1
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
            self.tableview.frame = self.actualtableframe
            self.feedstable.frame = CGRect(x: self.feedstable.frame.origin.x, y: self.tableview.frame.origin.y + self.tableview.frame.size.height, width: self.feedstable.frame.size.width, height: CGFloat(self.currentfeeds.count+1) * 0.095 * UIScreen.main.bounds.size.height)
            self.affirmationview2.isHidden = true
            }, completion: { (finished: Bool) -> Void in
                
                // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
                
        })
    }
    
    @IBAction func previous(_ sender: AnyObject) {
        if(currentindex>0){
            /*if(task.currentRequest != nil){
            if (task.state == NSURLSessionTaskState.Running) {
            task.cancel()
            }
            }*/
            currentindex = currentindex-1
            UserDefaults.standard.set(currentindex, forKey: "selected_action")
            currentarr = (currentcategory[currentindex] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            if(checkcredit_type(currentarr as! NSMutableDictionary) == "Data input"){
                //self.performSegueWithIdentifier("datainput", sender: nil)
                let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                let listofactions = mainstoryboard.instantiateViewController(withIdentifier: "listofactions")
                var datainput = mainstoryboard.instantiateViewController(withIdentifier: "datainput")
                if((currentarr["CreditDescription"] as! String).lowercased() == "water" || (currentarr["CreditDescription"] as! String).lowercased() == "energy"){
                    datainput = mainstoryboard.instantiateViewController(withIdentifier: "datainput")
                }else{
                    datainput = mainstoryboard.instantiateViewController(withIdentifier: "waste")
                }
                let rootViewController = self.navigationController
                var controllers = (rootViewController!.viewControllers)
                controllers.removeAll()
                var v = UIViewController()
                var grid = 0
                grid = UserDefaults.standard.integer(forKey: "grid")
                if(UserDefaults.standard.integer(forKey: "grid") == 1){
                    v = mainstoryboard.instantiateViewController(withIdentifier: "grid") as! UINavigationController
                }else{
                    v = mainstoryboard.instantiateViewController(withIdentifier: "listofassets") as! UINavigationController
                }
                var listofassets = mainstoryboard.instantiateViewController(withIdentifier: "projectslist")
                if(grid == 1){
                    listofassets = mainstoryboard.instantiateViewController(withIdentifier: "gridvc")
                }else{
                    listofassets = mainstoryboard.instantiateViewController(withIdentifier: "projectslist")
                }
                let dict = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary
                listofassets.navigationItem.title = dict["name"] as? String
                controllers.append(listofassets)
                controllers.append(listofactions)
                controllers.append(datainput)
                //self.navigationController!.hidesBarsOnTap = false;
                //self.navigationController!.hidesBarsOnSwipe = false;
                //self.navigationController!.hidesBarsWhenVerticallyCompact = false;
                self.navigationController?.setViewControllers(controllers, animated: false)
                
            }else{
                DispatchQueue.main.async(execute: {
                self.spinner.isHidden = false
                UserDefaults.standard.set(1, forKey: "notoast")
                self.buildingactions(credentials().subscription_key, leedid: self.leedid)
                })
                //navigate()
            }
        }else{
            currentindex = currentcategory.count - 1
            currentarr = (currentcategory[currentindex] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            
            let datakeyed = NSKeyedArchiver.archivedData(withRootObject: currentcategory)
            UserDefaults.standard.set(datakeyed, forKey: "currentcategory")
            UserDefaults.standard.set(currentindex, forKey: "selected_action")            
            UserDefaults.standard.synchronize()
            if(checkcredit_type(currentarr as! NSMutableDictionary) == "Data input"){
                //self.performSegueWithIdentifier("datainput", sender: nil)
                let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                let listofactions = mainstoryboard.instantiateViewController(withIdentifier: "listofactions")
                var datainput = mainstoryboard.instantiateViewController(withIdentifier: "datainput")
                if((currentarr["CreditDescription"] as! String).lowercased() == "water" || (currentarr["CreditDescription"] as! String).lowercased() == "energy"){
                    datainput = mainstoryboard.instantiateViewController(withIdentifier: "datainput")
                }else{
                    datainput = mainstoryboard.instantiateViewController(withIdentifier: "waste")
                }
                let rootViewController = self.navigationController
                var controllers = (rootViewController!.viewControllers)
                controllers.removeAll()
                var v = UIViewController()
                var grid = 0
                grid = UserDefaults.standard.integer(forKey: "grid")
                if(UserDefaults.standard.integer(forKey: "grid") == 1){
                    v = mainstoryboard.instantiateViewController(withIdentifier: "grid") as! UINavigationController
                }else{
                    v = mainstoryboard.instantiateViewController(withIdentifier: "listofassets") as! UINavigationController
                }
                var listofassets = mainstoryboard.instantiateViewController(withIdentifier: "projectslist")
                if(grid == 1){
                    listofassets = mainstoryboard.instantiateViewController(withIdentifier: "gridvc")
                }else{
                    listofassets = mainstoryboard.instantiateViewController(withIdentifier: "projectslist")
                }
                let dict = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary
                listofassets.navigationItem.title = dict["name"] as? String
                controllers.append(listofassets)
                controllers.append(listofactions)
                controllers.append(datainput)
                //self.navigationController!.hidesBarsOnTap = false;
                //self.navigationController!.hidesBarsOnSwipe = false;
                //self.navigationController!.hidesBarsWhenVerticallyCompact = false;
                self.navigationController?.setViewControllers(controllers, animated: false)
            }else{
                DispatchQueue.main.async(execute: {
                self.spinner.isHidden = false
                UserDefaults.standard.set(1, forKey: "notoast")
                self.buildingactions(credentials().subscription_key, leedid: self.leedid)
                })
                //self.navigate()
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
    
    @IBOutlet weak var assignnav: UINavigationBar!
    
    @IBAction func assigneecancel(_ sender: Any) {
        self.assigncontainer.isHidden = true
        self.sview.alpha = 1
    }
    
    @IBAction func assigned(_ sender: Any) {
        DispatchQueue.main.async(execute: {
            self.view.isUserInteractionEnabled = false
            self.spinner.isHidden = false
            if let snapshotValue = self.teammembers[self.picker.selectedRow(inComponent: 0)] as? NSDictionary, let currentcountr = snapshotValue["Useralias"] as? String,let first_name = snapshotValue["Firstname"] as? String,let last_name = snapshotValue["Lastname"] as? String {
                if let creditDescription = self.currentarr["CreditStatus"] as? String{
                    if(creditDescription.lowercased() == "under review"){
                        self.showalert("Updation is not allowed when the credit is under review", title: "Error", action: "OK")
                    }else{
                self.assignnewmember(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"), actionID: self.currentarr["CreditId"] as! String, email:currentcountr,firstname:first_name,lastname: last_name)
                    }
                }
            }
        })
    }
    func navigate(){
        self.tableview.frame.size.height = 0.067 * UIScreen.main.bounds.size.height
        self.sview.scrollsToTop = true        
        self.sview.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        self.assigncontainer.isHidden = true
        self.sview.alpha = 1
        currentindex = UserDefaults.standard.integer(forKey: "selected_action")
        UserDefaults.standard.synchronize()
        currentarr = (currentcategory[currentindex] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        //feedstable.hidden = true
        
        category.text = checkcredit_type(currentarr as! NSMutableDictionary)
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
            self.actiontitle.text = "Innovation"
            self.category.text = "Base points"
            shortcredit.image = UIImage.init(named: "id-border")
        }
        self.shortcredit.frame.origin.y = 0.98 * self.actiontitle.frame.origin.y        
        self.actiontitle.frame = tempframe
        self.alignimageview(shortcredit, label: actiontitle, superview: self.view)
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
        
        if(self.actiontitle.text!.contains("Policy") && self.actiontitle.text != "Green Cleaning Policy"){
            if(currentarr["IvReqFileupload"] as! String == "X"){
            self.ivattached2.setOn(true, animated: false)
            }else{
                self.ivattached2.setOn(false, animated: false)
            }
            
            
            if(currentarr["IvAttchPolicy"] as! String == "X"){
                self.ivupload2.setOn(true, animated: false)
            }else{
                self.ivupload2.setOn(false, animated: false)
            }
            
            
        }

        
        
        
        
        let c = credentials()
        domain_url = c.domain_url
        self.affirmationsclick(self.activityfeedbutton)
        DispatchQueue.main.async(execute: {
            self.sview.isHidden = true            
            if(self.fromnotification == 1){
                self.prev.isHidden = true
                self.nxt.isHidden = true
            }else{
                self.prev.isHidden = false
                self.nxt.isHidden = false
            }
            self.tableview.reloadData()
        })
        DispatchQueue.main.async(execute: {
            self.category.text = ""
            /*self.affirmation1text.font = UIFont.init(name: "OpenSans", size: 0.05 * self.affirmation1text.layer.frame.size.width)
            self.affirmation2text1.font = UIFont.init(name: "OpenSans", size: 0.05 * self.affirmation2text1.layer.frame.size.width)
            self.affirmation2text2.font = UIFont.init(name: "OpenSans", size:0.05 * self.affirmation2text2.layer.frame.size.width)
            self.affirmation2title.font = UIFont.init(name: "OpenSans", size:0.05 * self.affirmation2title.layer.frame.size.width)
            self.afriamtion1title.font = UIFont.init(name: "OpenSans", size:0.05 * self.affirmation2title.layer.frame.size.width)
            self.actiontitle.font = UIFont.init(name: "OpenSans", size:0.041 * self.actiontitle.layer.frame.size.width)
            self.category.font = UIFont.init(name: "OpenSans-Semibold", size:0.05 * self.category.layer.frame.size.width)*/
            self.category.adjustsFontSizeToFitWidth = true
            self.actiontitle.adjustsFontSizeToFitWidth = true
            self.afriamtion1title.adjustsFontSizeToFitWidth = true
            self.affirmation2title.adjustsFontSizeToFitWidth = true
            self.affirmation1text.adjustsFontSizeToFitWidth = true
            self.affirmation2text2.adjustsFontSizeToFitWidth = true
            self.actiontitle.adjustsFontSizeToFitWidth = true
            self.affirmation2text1.isHidden = false
            self.statusswitch.isHidden = true
            self.creditstatus.isHidden = true
            for request in self.download_requests
            {
                request.invalidateAndCancel()
            }
            self.spinner.isHidden = false
            self.showactivityfeed(UserDefaults.standard.integer(forKey: "leed_id"), creditID: self.currentarr["CreditId"] as! String, shortcreditID: self.currentarr["CreditShortId"] as! String)
            
        })
        //self.getuploadsdata(c.subscription_key, leedid: 1000136954, actionID: currentarr["CreditId"] as! String)
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
            if(checkcredit_type(currentarr as! NSMutableDictionary) == "Data input"){
                //self.performSegueWithIdentifier("datainput", sender: nil)
                let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                let listofactions = mainstoryboard.instantiateViewController(withIdentifier: "listofactions")
                let datainput = mainstoryboard.instantiateViewController(withIdentifier: "datainput")
                let rootViewController = self.navigationController
                var controllers = (rootViewController!.viewControllers)
                controllers.removeAll()
                var v = UIViewController()
                var grid = 0
                grid = UserDefaults.standard.integer(forKey: "grid")
                if(UserDefaults.standard.integer(forKey: "grid") == 1){
                    v = mainstoryboard.instantiateViewController(withIdentifier: "grid") as! UINavigationController
                }else{
                    v = mainstoryboard.instantiateViewController(withIdentifier: "listofassets") as! UINavigationController
                }
                var listofassets = mainstoryboard.instantiateViewController(withIdentifier: "projectslist")
                if(grid == 1){
                    listofassets = mainstoryboard.instantiateViewController(withIdentifier: "gridvc")
                }else{
                    listofassets = mainstoryboard.instantiateViewController(withIdentifier: "projectslist") 
                }
                let dict = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary
                listofassets.navigationItem.title = dict["name"] as? String
                controllers.append(listofassets)
                controllers.append(listofactions)
                controllers.append(datainput)
                //self.navigationController!.hidesBarsOnTap = false;
                //self.navigationController!.hidesBarsOnSwipe = false;
                //self.navigationController!.hidesBarsWhenVerticallyCompact = false;
                self.navigationController?.setViewControllers(controllers, animated: false)
            
            }else{
                DispatchQueue.main.async(execute: {
                self.spinner.isHidden = false
                UserDefaults.standard.set(1, forKey: "notoast")
                self.buildingactions(credentials().subscription_key, leedid: self.leedid)
                })
            }
        }else{
            currentindex = 0
            UserDefaults.standard.set(currentindex, forKey: "selected_action")
            currentarr = (currentcategory[currentindex] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            if(checkcredit_type(currentarr as! NSMutableDictionary) != "Data input"){
            //self.navigate()
                DispatchQueue.main.async(execute: {
                self.spinner.isHidden = false
                UserDefaults.standard.set(1, forKey: "notoast")
                self.buildingactions(credentials().subscription_key, leedid: self.leedid)
                })
            }
        }
    }
    
    
    @IBAction func affirmationview1close(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.beginFromCurrentState, animations: { () -> Void in
            self.tableview.frame = self.actualtableframe
            self.feedstable.frame = CGRect(x: self.feedstable.frame.origin.x, y: self.tableview.frame.origin.y + self.tableview.frame.size.height, width: self.feedstable.frame.size.width, height: CGFloat(self.currentfeeds.count+1) * 0.095 * UIScreen.main.bounds.size.height)
            self.affirmationview1.isHidden = true
            }, completion: { (finished: Bool) -> Void in
                
                // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
                
        })
    }
  
    

    
    @IBOutlet weak var activityfeedbutton: UIButton!
    @IBOutlet weak var tabbar: UITabBar!
    @IBAction func affirmationsclick(_ sender: AnyObject) {
        
        if(self.actiontitle.text!.contains("Policy") && self.actiontitle.text != "Green Cleaning Policy"){
            self.affirmationview1.isHidden = true
            self.affirmationview2.isHidden = false
            let dict = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary
            if(dict["project_type"] as! String == "building"){
                self.affirmation2text1.text = "The policy on the resources page has been implemented for the project."
                self.affirmation2text2.text = "And/or a custom policy meeting the prerequisite requirements has been implemented for the project. A copy of the policy has been uploaded."
            }else if(dict["project_type"] as! String == "transit"){
                self.affirmation2text1.text = "The policy on the resources page has been implemented for the project."
                self.affirmation2text2.text = "And/or a custom policy meeting the prerequisite requirements has been implemented for the project. A copy of the policy has been uploaded."
            }
            self.affirmationview2.isHidden = false
            self.affirmationview2.transform = CGAffineTransform(scaleX: 1, y: 1);
            self.tableview.frame = CGRect(x: self.tableview.layer.frame.origin.x, y: 1.02 * (self.affirmationview2.layer.frame.origin.y + self.affirmationview2.layer.frame.size.height), width: self.tableview.layer.frame.size.width,  height: self.tableview.layer.frame.size.height)
            self.feedstable.frame = CGRect(x: self.feedstable.frame.origin.x, y: self.tableview.frame.origin.y + self.tableview.frame.size.height, width: self.feedstable.frame.size.width, height: CGFloat(self.currentfeeds.count+1) * 0.095 * UIScreen.main.bounds.size.height)
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
            self.affirmation1text.text = "All required files for the current performance period have been uploaded."
            self.affirmationview1.isHidden = false
            self.affirmationview2.isHidden = true
            self.affirmationview1.isHidden = false
            self.affirmationview1.transform = CGAffineTransform(scaleX: 1, y: 1);
           self.tableview.frame = CGRect(x: self.tableview.layer.frame.origin.x, y: 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), width: self.tableview.layer.frame.size.width,  height: self.tableview.layer.frame.size.height)
            self.feedstable.frame = CGRect(x: self.feedstable.frame.origin.x, y: self.tableview.frame.origin.y + self.tableview.frame.size.height, width: self.feedstable.frame.size.width, height: CGFloat(self.currentfeeds.count+1) * 0.095 * UIScreen.main.bounds.size.height)
            
            
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
                        //self.tableview.hidden = false
                        self.spinner.isHidden = true
                        self.tableview.frame = CGRect(x: self.tableview.layer.frame.origin.x, y: 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), width: self.tableview.layer.frame.size.width,  height: 50)
                        self.feedstable.frame = CGRect(x: self.feedstable.frame.origin.x, y: self.tableview.frame.origin.y + self.tableview.frame.size.height, width: self.feedstable.frame.size.width, height: CGFloat(self.currentfeeds.count+1) * 0.095 * UIScreen.main.bounds.size.height)
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
                   // self.buildingactions(subscription_key, leedid: leedid)
                    self.getcreditformsuploadsdata(subscription_key, leedid: leedid, actionID: actionID)
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
                        //self.tableview.hidden = false
                        self.spinner.isHidden = true
                        self.tableview.frame = CGRect(x: self.tableview.layer.frame.origin.x, y: 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), width: self.tableview.layer.frame.size.width,  height: 50)
                        self.feedstable.frame = CGRect(x: self.feedstable.frame.origin.x, y: self.tableview.frame.origin.y + self.tableview.frame.size.height, width: self.feedstable.frame.size.width, height: CGFloat(self.currentfeeds.count+1) * 0.095 * UIScreen.main.bounds.size.height)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "gotofeeds"){
            let vc = segue.destination as! feeds
            vc.currentfeeds = currentfeeds
        }
    }
    
    @IBAction func assignclose(_ sender: AnyObject) {
        self.assigncontainer.isHidden = true
        self.sview.alpha = 1
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
                        //self.tableview.hidden = false
                        self.spinner.isHidden = true
                        self.tableview.frame = CGRect(x: self.tableview.layer.frame.origin.x, y: 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), width: self.tableview.layer.frame.size.width,  height: 50)
                        self.feedstable.frame = CGRect(x: self.feedstable.frame.origin.x, y: self.tableview.frame.origin.y + self.tableview.frame.size.height, width: self.feedstable.frame.size.width, height: CGFloat(self.currentfeeds.count+1) * 0.095 * UIScreen.main.bounds.size.height)
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
                        self.sview.alpha = 1                        
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
                        //self.tableview.hidden = false
                        self.spinner.isHidden = true
                        self.tableview.frame = CGRect(x: self.tableview.layer.frame.origin.x, y: 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), width: self.tableview.layer.frame.size.width,  height: 50)
                        self.feedstable.frame = CGRect(x: self.feedstable.frame.origin.x, y: self.tableview.frame.origin.y + self.tableview.frame.size.height, width: self.feedstable.frame.size.width, height: CGFloat(self.currentfeeds.count+1) * 0.095 * UIScreen.main.bounds.size.height)
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
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            if(headerView.textLabel?.text?.lowercased() == "activities"){
            headerView.textLabel?.textAlignment = .left
            }else{
            headerView.textLabel?.textAlignment = .left
            }
        }
    }
    
    @IBAction func okassignthemember(_ sender: AnyObject) {
        if(statusupdate == 1){
            self.view.isUserInteractionEnabled = false
            self.spinner.isHidden = false
            savestatusupdate(currentarr["CreditId"] as! String, subscription_key: credentials().subscription_key)
            
        }else{
            self.view.isUserInteractionEnabled = false
            self.spinner.isHidden = false
            
            if let snapshotValue = teammembers[picker.selectedRow(inComponent: 0)] as? NSDictionary, let currentcountr = snapshotValue["Useralias"] as? String,let first_name = snapshotValue["Firstname"] as? String,let last_name = snapshotValue["Lastname"] as? String {
        assignnewmember(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"), actionID: currentarr["CreditId"] as! String, email:currentcountr,firstname:first_name,lastname: last_name)
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
        
        DispatchQueue.main.async(execute: {
        self.view.isUserInteractionEnabled = false
        })
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "PUT"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var httpbody = String()
        if(self.actiontitle.text!.contains("Policy") && self.actiontitle.text != "Green Cleaning Policy"){
            httpbody = String(format: "{\"IvReqFileupload\": %@, \"IvAttchPolicy\": %@}",self.ivattached2.isOn as CVarArg,ivupload2.isOn as CVarArg)
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
                        //self.tableview.hidden = false
                        self.spinner.isHidden = true
                        self.tableview.frame = CGRect(x: self.tableview.layer.frame.origin.x, y: 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), width: self.tableview.layer.frame.size.width,  height: 50)
                        self.feedstable.frame = CGRect(x: self.feedstable.frame.origin.x, y: self.tableview.frame.origin.y + self.tableview.frame.size.height, width: self.feedstable.frame.size.width, height: CGFloat(self.currentfeeds.count+1) * 0.095 * UIScreen.main.bounds.size.height)
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
                    if(self.actiontitle.text!.contains("Policy") && self.actiontitle.text != "Green Cleaning Policy"){
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
        if(sender.tag == 101 || sender.tag == 102 || sender.tag == 103){
        DispatchQueue.main.async(execute: {
            self.spinner.isHidden = false
            self.view.isUserInteractionEnabled = false
            if let creditDescription = self.currentarr["CreditStatus"] as? String{
                if(creditDescription.lowercased() == "under review"){
                    self.showalert("Updation is not allowed when the credit is under review", title: "Error", action: "OK")
                }else{
            self.affirmationupdate(self.currentarr["CreditId"] as! String, leedid: self.leedid, subscription_key: credentials().subscription_key)
                }
            }
        })
        
        
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
        DispatchQueue.main.async(execute: {
        self.view.isUserInteractionEnabled = false
        })
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "PUT"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var httpbody = String()
        let string = self.statusarr[self.picker.selectedRow(inComponent: 0)] as? String
        if(statusswitch.isOn == true){
            httpbody = String(format: "{\"is_readyForReview\": %@}",statusswitch.isOn as CVarArg)
        }else{
            httpbody = String(format: "{\"is_readyForReview\": %@}",statusswitch.isOn as CVarArg)
        }
        /*if(string == "Ready for review"){
            httpbody = String(format: "{\"is_readyForReview\": %@}",true)
        }else{
            httpbody = String(format: "{\"is_readyForReview\": %@}",false)
        }*/
        
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
                        //self.tableview.hidden = false
                        self.spinner.isHidden = true
                        self.tableview.frame = CGRect(x: self.tableview.layer.frame.origin.x, y: 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), width: self.tableview.layer.frame.size.width,  height: 50)
                        self.feedstable.frame = CGRect(x: self.feedstable.frame.origin.x, y: self.tableview.frame.origin.y + self.tableview.frame.size.height, width: self.feedstable.frame.size.width, height: CGFloat(self.currentfeeds.count+1) * 0.095 * UIScreen.main.bounds.size.height)
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
