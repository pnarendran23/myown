//  ViewController.swift
//  LEEDOn
//
//  Created by Group X on 15/11/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit
import  MessageUI

class waste: UIViewController,UITabBarDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var tabbar: UITabBar!
    var vwidth : CGFloat = 0.0
    var download_requests = [URLSession]()
    var vheight : CGFloat = 0.0
    var emailID = ""
    @IBOutlet weak var creditstatusimg: UIImageView!
    var currentfeeds = NSArray()
    @IBOutlet weak var feedstable: UITableView!
    @IBOutlet weak var affview: UIView!
    @IBOutlet weak var shortcredit: UIImageView!
    @IBOutlet weak var spinner: UIView!
    @IBOutlet weak var assignedto: UILabel!
    @IBOutlet weak var actiontitle: UILabel!
    @IBOutlet weak var creditstatus: UILabel!
    @IBOutlet weak var cc: UIView!
    var statusarr = ["Ready for Review"] as NSArray
    var statusupdate = 0
    let leedid = UserDefaults.standard.integer(forKey: "leed_id")
    @IBOutlet weak var assignokbtn: UIButton!
    @IBOutlet weak var assignclosebutton: UIButton!
    @IBOutlet weak var pleasekindly: UILabel!
    @IBOutlet weak var assigncontainer: UIView!
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var assetname: UILabel!
    var satisfactionarr = [Int]()
    var dissatisfactionarr = [Int]()
    var task = URLSessionTask()
    var currentcount = 0
    var currentindex = 0
    var data = [Int]()
    
    @IBAction func assigneesave(_ sender: Any) {
        DispatchQueue.main.async(execute: {
            self.view.isUserInteractionEnabled = false
            self.spinner.isHidden = false
            if let snapshotValue = self.teammembers[self.picker.selectedRow(inComponent: 0)] as? NSDictionary, let currentcountr = snapshotValue["Useralias"] as? String,let first_name = snapshotValue["Firstname"] as? String,let last_name = snapshotValue["Lastname"] as? String {
                self.assignnewmember(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"), actionID: self.currentarr["CreditId"] as! String, email:currentcountr,firstname:first_name,lastname: last_name)
            }
        })
    }
    @IBAction func assigneecancel(_ sender: Any) {
        self.assigncontainer.isHidden = true
        self.sview.alpha = 1        
    }
    @IBOutlet weak var assignnav: UINavigationBar!
    var meters = NSMutableArray()
    var teammembers = NSMutableArray()
    var data2 = [Int]()
    var currentarr = NSMutableDictionary()
    var currentmetersdict = NSMutableDictionary()
    var currentcategory = NSMutableArray()
    var domain_url = ""
    var token = ""
    @IBOutlet weak var vv: UIScrollView!
    @IBOutlet weak var btn: UIButton!
    
    @IBOutlet weak var statusswitch: UISwitch!
    
    @IBAction func statuschange(_ sender: AnyObject) {
            statusupdate = 1
            self.assignthemember(UIButton())        
    }
    
    @IBOutlet weak var pleasetap: UILabel!
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textAlignment = .left
            if(tableView == feedstable){
                if((self.currentarr["CreditDescription"] as! String).lowercased() == "waste"){
                    if(section == 0){
                        if(headerView.textLabel?.text?.lowercased() == "activities"){
                            
                        }else{
                            headerView.textLabel?.textAlignment = .left
                        }
                    }
                }
                if(section == 1){
                    if(headerView.textLabel?.text?.lowercased() == "activities"){
                        
                    }else{
                        headerView.textLabel?.textAlignment = .left
                    }
                }
            }
            if(section == 0){
                if(headerView.textLabel?.text?.lowercased() == "activities"){
                    
                }else{
                    headerView.textLabel?.textAlignment = .left
                }
            }
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
                let dict = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary
        mailComposerVC.setToRecipients([emailID])
        let surveylink = "\(credentials().survey_url )\(dict["leed_id"] as! Int)/survey/?key=\(dict["key"] as! String)"
        mailComposerVC.setSubject("Arc - Survey Link")
        mailComposerVC.setMessageBody("Please kindly spend your valuable time to submit your feedback for the project \(surveylink )", isHTML: true)
        
        let str = "Hi there,\n" +
        "Please fill out this quick survey to help us better understand our building performance and to make you as comfortable as possible. Click below to begin.\n" +
            "\(surveylink )\n" +
        "Thank you for your important contributions to our Arc data!\n" +
            "Want to learn more about how we use the Arc Platform to track building performance? Visit arcskoru.com.\n"
        mailComposerVC.setMessageBody(str, isHTML: true)
        
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let alert  = UIAlertController.init(title: "Could not send email", message: "You device could not send e-mail. Please check e-mail configuration and try again", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "OK", style: .cancel) { (action) -> Void in
            
        }
        alert.addAction(cancel)
        alert.view.subviews.first?.backgroundColor = UIColor.white
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func sidebtnclick(_ sender: AnyObject) {
        if((self.currentarr["CreditDescription"] as! String).lowercased() == "waste"){
            
                self.performSegue(withIdentifier: "gotoreadings", sender: nil)
        }else{
            //print("Mail")
            var loginTextField: UITextField?
            let alertController = UIAlertController(title: "Email ID", message: "Please provide a receipient's email ID", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Send", style: .default, handler: { (action) -> Void in
                self.emailID = (loginTextField?.text!)!
                let mailComposeViewController = self.configuredMailComposeViewController()
                if MFMailComposeViewController.canSendMail() {
                    self.present(mailComposeViewController, animated: true, completion: nil)
                } else {
                    self.showSendMailErrorAlert()
                }
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                //print("Cancel Button Pressed")
            }
            alertController.addAction(ok)
            alertController.addAction(cancel)
            alertController.addTextField { (textField) -> Void in
                // Enter the textfiled customization code here.
                loginTextField = textField
                loginTextField?.placeholder = "Enter the email ID"
            }
            self.present(alertController, animated: true, completion: nil)
        }
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
   /* override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if(UIDevice.currentDevice().orientation == .Portrait){
            if(sview != nil){
            sview.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width,UIScreen.mainScreen().bounds.size.height)
            }
        }else{
            if(sview != nil){
            //sview.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width)
            }
        }
        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affview.layer.frame.origin.y + self.affview.layer.frame.size.height), self.tableview.layer.frame.size.width,  self.tableview.layer.frame.size.height)
        navigate()
        return [.Portrait]
    }*/
    var fromnotification = UserDefaults.standard.integer(forKey: "fromnotification")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sview.frame = CGRect(x: self.sview.layer.frame.origin.x, y: 1.02 * (self.prev.layer.frame.origin.y + self.prev.layer.frame.size.height), width: self.sview.layer.frame.size.width,  height: self.tabbar.frame.origin.y - self.tabbar.frame.size.height)
        self.shortcredit.isHidden = true
        self.creditstatus.isHidden = true
        self.statusswitch.isHidden = true
        self.addnew.isHidden = true
        self.sview.isHidden = true
        self.assigncontainer.bringSubview(toFront: self.assignnav)
        self.tableview.isScrollEnabled = false
        self.tempframe = self.actiontitle.frame
        self.affview.frame.size.height = 0
        self.affview.isHidden = true
        fromnotification = UserDefaults.standard.integer(forKey: "fromnotification")
        DispatchQueue.main.async(execute: {
            if(self.fromnotification == 1){
                self.prev.isHidden = true
                self.nxt.isHidden = true
            }else{
                self.prev.isHidden = false
                self.nxt.isHidden = false
            }
        })
        self.tableview.frame = CGRect(x: self.tableview.layer.frame.origin.x, y: 0, width: self.tableview.layer.frame.size.width,  height: self.tableview.layer.frame.size.height)
        tableview.frame.size.height = 0.06 * UIScreen.main.bounds.size.height
        //self.vv.frame.origin.y = 1.1 * (tableview.frame.size.height + tableview.frame.origin.y)
        self.tableview.isHidden = false
        self.feedstable.isHidden = false
         building_dict = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary
        self.titlefont()
        self.prev.layer.frame.size.width = self.nxt.layer.frame.size.width
        self.prev.layer.frame.size.height = self.nxt.layer.frame.size.height
        //self.prev.layer.frame.origin.x = 0.98 * (self.next.layer.frame.origin.x - self.prev.layer.frame.size.width)
        tableview.register(UINib.init(nibName: "prerequisitescell2", bundle: nil), forCellReuseIdentifier: "cell2")
        feedstable.register(UINib.init(nibName: "progresscell", bundle: nil), forCellReuseIdentifier: "progresscell")
        vwidth = self.vv.frame.size.width
        vheight = self.vv.frame.size.height
        affirmationtext.adjustsFontSizeToFitWidth = true
        affirmationtitle.adjustsFontSizeToFitWidth = true
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
        backbtn.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12)
        self.spinner.layer.cornerRadius = 5
        self.spinner.isHidden = true
        //self.view.userInteractionEnabled = true
        // 3
     
        assignokbtn.isEnabled = false

        self.prev.layer.cornerRadius = 4
        self.nxt.layer.cornerRadius = 4
        self.tabbar.delegate = self
        self.tabbar.selectedItem = self.tabbar.items![1]
        var datakeyed = Data()
        token = UserDefaults.standard.object(forKey: "token") as! String
        datakeyed = UserDefaults.standard.object(forKey: "currentcategory") as! Data
        currentcategory = (NSKeyedUnarchiver.unarchiveObject(with: datakeyed) as! NSArray).mutableCopy() as! NSMutableArray
        currentindex = UserDefaults.standard.integer(forKey: "selected_action")
        UserDefaults.standard.synchronize()
        //print("aarra", currentcategory)
        currentarr = (currentcategory[currentindex] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.actiontitle.text = currentarr["CreditDescription"] as? String
        self.creditstatus.text = currentarr["CreditStatus"] as? String
        if(self.creditstatus.text == ""){
            self.creditstatus.text = "Not available"
        }
        
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
        actiontitle.text = dict["name"] as? String
        self.navigationItem.title = dict["name"] as? String
        let navItem = UINavigationItem(title: (dict["name"] as? String)!);
        self.nav.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!]
        let doneItem = UIBarButtonItem(title: "< Projects", style: .plain, target: self, action: #selector(sayHello(_:)))
        navItem.leftBarButtonItem = doneItem;
        nav.setItems([navItem], animated: false);
        DispatchQueue.main.async(execute: {
            if((self.currentarr["CreditDescription"] as! String).lowercased() == "waste"){
                let rect = self.addnew.frame
                self.addnew.setImage(UIImage(named: "addnewdata.png") as UIImage?, for: UIControlState())
                self.addnew.frame = rect
                self.addnew.layer.cornerRadius = rect.size.height/2.0
                //self.addnew.titleLabel?.text = "Add new reading"
            }else if((self.currentarr["CreditDescription"] as! String).lowercased() == "transportation"){
                let rect = self.addnew.frame
                self.addnew.setImage(UIImage(named: "invitation_icon.png") as UIImage?, for: UIControlState())
                self.addnew.frame = rect
                self.addnew.layer.cornerRadius = rect.size.height/2.0
                //self.addnew.titleLabel?.text = "Email survey"
            }
            self.ivupload1.tag = 101
            self.ivupload1.addTarget(self, action: #selector(waste.valuechanged(_:)), for: UIControlEvents.valueChanged)
            
            //self.btn.addTarget(self, action: Selector(self.getteammembers(credentials().subscription_key, leedid: 1000136954)), forControlEvents: UIControlEvents.TouchUpInside)
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(datainput.statusupdate(_:)))
            //self.creditstatus.userInteractionEnabled = true
            //self.creditstatus.addGestureRecognizer(tap)
            //self.navigate()
        })
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.shouldRotate = false
        // 2. Force the device in landscape mode when the view controller gets loaded
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
    override var shouldAutorotate : Bool {
        // 3. Lock autorotate
        return false
    }
    func alignimageview (_ imageView: UIImageView, label : UILabel, superview : UIView){
        label.sizeToFit()
        imageView.frame = CGRect(x: (superview.frame.size.width - imageView.frame.size.width - label.frame.size.width)/2, y: imageView.frame.origin.y, width: imageView.frame.size.width, height: imageView.frame.size.height)
        label.frame = CGRect(x: imageView.frame.origin.x + imageView.frame.size.width, y: label.frame.origin.y, width: label.frame.size.width, height: label.frame.size.height)
    }
    var tempframe = CGRect()
    
        func statusupdate(_ sender:UILabel){            
            if(ivupload1.isOn == false){
                maketoast("Affirmation required before changing the status", type: "error")
            }else{
            self.teammembers = statusarr.mutableCopy() as! NSMutableArray
            DispatchQueue.main.async(execute: {
                self.assigncontainer.isHidden = false
                self.sview.alpha = 1
                self.statusupdate = 1
                self.pleasekindly.text = "Please kindly select the below status for the action"
                self.assignokbtn.setTitle("Save", for: UIControlState())
                self.picker.reloadAllComponents()
            })
            }
        }
    
    func imageWithImage(_ image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    
    
    func valuechanged(_ sender:UISwitch){
        if(sender.tag == 101){
        DispatchQueue.main.async(execute: {
            self.spinner.isHidden = false
            self.view.isUserInteractionEnabled = false
            self.affirmationupdate(self.currentarr["CreditId"] as! String, leedid: self.leedid, subscription_key: credentials().subscription_key)
        })
        
        }
    }
    @IBOutlet weak var affirmationtitle: UILabel!
    
    @IBOutlet weak var affirmationtext: UILabel!
    func sayHello(_ sender: UIBarButtonItem) {
        //print("Projects clicked")
        self.performSegue(withIdentifier: "gotoactions", sender: nil)
    }
    
    @IBOutlet weak var sview: UIScrollView!
    
    @IBOutlet weak var nav: UINavigationBar!
    
    func affirmationupdate(_ actionID:String, leedid: Int, subscription_key:String){
        //
        var url = URL.init(string: "")
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
            httpbody = String(format: "{\"IvAttchPolicy\": false, \"IvReqFileupload\": %@}",ivupload1.isOn as CVarArg)
        
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
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affview.layer.frame.origin.y + self.affview.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
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
            } else
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 && httpStatus.statusCode != 201 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                
                let jsonDictionary : NSDictionary
                do {
                            self.currentarr["IvAttchPolicy"] = "" 
                        if(self.ivupload1.isOn == true){
                            self.currentarr["IvReqFileupload"] = "X" 
                        }else{
                            self.currentarr["IvReqFileupload"] = "" 
                        }
                    

                    self.currentcategory.replaceObject(at: UserDefaults.standard.integer(forKey: "selected_action"), with: self.currentarr)                    
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print(jsonDictionary)
                    self.updatebuildingactions(subscription_key, leedid: leedid)
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

    
    func showactivityfeed(_ leedid: Int, creditID : String, shortcreditID : String){
        let url = URL.init(string:String(format: "%@assets/activity/?type=credit&leed_id=%d&credit_short_id=%@",domain_url, leedid, shortcreditID))
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
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affview.layer.frame.origin.y + self.affview.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
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
                        self.creditstatus.isHidden = true
                        self.affview.isHidden = true
                        self.statusswitch.isHidden = true
                        self.spinner.isHidden = true
                        //self.view.userInteractionEnabled = true
                        //self.performSegueWithIdentifier("gotofeeds", sender: nil)
                        if(self.currentfeeds.count > 0){
                            //self.feedstable.hidden = false
                            //self.sview.contentSize = CGSizeMake(self.vv.frame.size.width, 1.1 * CGRectGetMaxY(self.feedstable.frame))
                        }else{
                            //self.feedstable.hidden = true
                        }
                        self.feedstable.reloadData()
                        if(self.currentfeeds.count > 0){
                        self.feedstable.frame = CGRect(x:self.feedstable.frame.origin.x,y:self.feedstable.frame.origin.y,width:self.feedstable.frame.width, height: CGFloat(self.currentfeeds.count) * (0.197 * UIScreen.main.bounds.size.height))
                        }else{
                        self.feedstable.frame = CGRect(x:self.feedstable.frame.origin.x,y:self.feedstable.frame.origin.y,width:self.feedstable.frame.width, height: CGFloat(2.5) * (0.197 * UIScreen.main.bounds.size.height))
                        }
                        var i = CGFloat(0)
                        if((self.currentarr["CreditDescription"] as! String).lowercased() == "waste"){
                            i = i + ((0.054 * UIScreen.main.bounds.size.height) * CGFloat(self.currentfeeds.count))
                                }else{
                                    i = i + (0.197 * UIScreen.main.bounds.size.height)
                                    i = i + ((0.107 * UIScreen.main.bounds.size.height) * CGFloat(self.currentfeeds.count))
                                }
                        if(self.currentfeeds.count > 0){
                        i = i + CGFloat(self.currentfeeds.count + 2)
                        i = i + ((0.035 * UIScreen.main.bounds.size.height) * CGFloat(self.currentfeeds.count + 2))
                        i = i + ((0.017 * UIScreen.main.bounds.size.height) * CGFloat(self.currentfeeds.count + 2))
                        }else{
                        i = i + CGFloat(2)
                        i = i + ((0.035 * UIScreen.main.bounds.size.height) * CGFloat(2))
                        i = i + ((0.017 * UIScreen.main.bounds.size.height) * CGFloat(2))
                        }
                        self.feedstable.frame.size.height = i
                        //print(i,self.sview.contentSize.height)
                        self.spinner.isHidden = true
                        var s = self.sview.contentSize.height + self.feedstable.layer.frame.size.height //+ self.feedstable.layer.frame.origin.y
                        //print("max Y is",s)
                        self.sview.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: s)
                        self.sview.isHidden = false
                        self.view.isUserInteractionEnabled = true
                        //self.statusswitch.isHidden = false                        
                    if((self.currentarr["CreditDescription"] as! String).lowercased() == "waste"){
                        self.addnew.isHidden = true
                        self.pleasetap.isHidden = false
                        self.gesture = UITapGestureRecognizer(target: self, action: #selector(self.touched(_:)))
                        self.gesture.cancelsTouchesInView = false
                        self.pleasetap.numberOfLines = 4
                        self.pleasetap.adjustsFontSizeToFitWidth = true
                        if(self.meters.count == 0){
                            self.pleasetap.text = "No readings entered so far. Please tap the below graph to explore data."
                        }else{
                            self.pleasetap.text = "Please tap the below graph to explore data."
                        }
                        self.gesture.numberOfTapsRequired = 1
                        self.cc.addGestureRecognizer(self.gesture)
                    }else{
                        self.addnew.isHidden = false
                        self.pleasetap.isHidden = true
                    }
                        //self.creditstatus.isHidden = false
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

    
    func updatebuildingactions(_ subscription_key:String, leedid: Int){
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
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affview.layer.frame.origin.y + self.affview.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
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
            } else
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print(jsonDictionary)
                    let datakeyed = NSKeyedArchiver.archivedData(withRootObject: jsonDictionary)
                    UserDefaults.standard.set(datakeyed, forKey: "actions_data")
                    //self.view.userInteractionEnabled = true
                    UserDefaults.standard.synchronize()
                    UserDefaults.standard.set(0, forKey: "row")
                    DispatchQueue.main.async(execute: {
                        self.spinner.isHidden = true
                        //self.view.userInteractionEnabled = true
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
    
    @IBOutlet weak var ivupload1: UISwitch!
    var gesture = UITapGestureRecognizer()
    func navigate(){
        gesture = UITapGestureRecognizer.init(target: self, action: #selector(self.touched(_:)))
        self.cc.removeGestureRecognizer(gesture)
        self.view.bringSubview(toFront: self.feedstable)
        self.tableview.frame.origin.y = 0
        self.sview.scrollsToTop = true
        self.sview.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        self.data.removeAll()
        //self.assigncontainer.backgroundColor = UIColor.white
        self.data2.removeAll()
        UserDefaults.standard.removeObject(forKey: "data")
        UserDefaults.standard.removeObject(forKey: "data2")
        for request in download_requests
        {
            request.invalidateAndCancel()
        }
        self.vv.isHidden = true
        DispatchQueue.main.async(execute: {
            self.sview.isHidden = true
            self.sview.isHidden = true
            //self.view.userInteractionEnabled = false
            self.statusswitch.isHidden = true
            self.addnew.isHidden = true
            self.creditstatus.isHidden = true
            if(self.fromnotification == 1){
                self.prev.isHidden = true
                self.nxt.isHidden = true
            }else{
                self.prev.isHidden = false
                self.nxt.isHidden = false
            }
            self.spinner.isHidden = true          
        })
        currentarr = (currentcategory[currentindex] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.actiontitle.text = currentarr["CreditDescription"] as? String
        self.creditstatus.text = currentarr["CreditStatus"] as? String
        currentcount = 0
        let c = credentials()
        domain_url = c.domain_url
        let dict = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary
        assetname.text = dict["name"] as? String
        data.removeAll()
        data2.removeAll()
        meters.removeAllObjects()
        currentmetersdict.removeAllObjects()
        UserDefaults.standard.removeObject(forKey: "startdate")
        UserDefaults.standard.removeObject(forKey: "enddate")
        
        if(currentarr["IvReqFileupload"] is String){
            if(currentarr["IvReqFileupload"] as! String == ""){
                ivupload1.setOn(false, animated: false)
            }else if(currentarr["IvReqFileupload"] as! String == "X"){
                ivupload1.setOn(true, animated: false)
            }
        }else{
            ivupload1.setOn(currentarr["IvReqFileupload"] as! Bool, animated: false)            
        }
        
        
        if let creditstatus = currentarr["CreditStatus"] as? String{
            self.creditstatus.text = String(format: "%@",creditstatus.capitalized)
            if(creditstatus == "Ready for Review"){
                creditstatusimg.image = UIImage.init(named: "tick")
            }else{
                creditstatusimg.image = UIImage.init(named: "circle")
            }
        }else{
            creditstatus.text = "Not available"
        }

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
        if((self.currentarr["CreditDescription"] as! String).lowercased() == "human experience"){
            let rect = self.addnew.frame
            self.addnew.setImage(UIImage(named: "invitation_icon.png") as UIImage?, for: UIControlState())
            self.addnew.frame = rect
            self.addnew.layer.cornerRadius = rect.size.height/2.0
            //self.addnew.titleLabel?.text = "Email survey"
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
        }else{
            if((currentarr["CreditDescription"] as! String).lowercased() == "energy"){
                shortcredit.image = UIImage.init(named: "energy-border")
            }else if((currentarr["CreditDescription"] as! String).lowercased() == "water"){
                shortcredit.image = UIImage.init(named: "water-border")
            }else if((currentarr["CreditDescription"] as! String).lowercased() == "waste"){
                self.addnew.isHidden = true
                self.cc.addGestureRecognizer(gesture)
                shortcredit.image = UIImage.init(named: "waste-border")
            }
            else if((currentarr["CreditDescription"] as! String).lowercased() == "transportation"){
                shortcredit.image = UIImage.init(named: "transport-border")
            }else{
                shortcredit.image = UIImage.init(named: "human-border")
            }
        }
        self.shortcredit.isHidden = false
        self.shortcredit.frame.origin.y = 0.98 * self.actiontitle.frame.origin.y        
        self.actiontitle.frame = tempframe
        self.alignimageview(shortcredit, label: actiontitle, superview: self.view)
        
        if((currentarr["CreditDescription"] as! String).lowercased() == "water" || (currentarr["CreditDescription"] as! String).lowercased() == "energy"){
            //self.performSegueWithIdentifier("gotodatainput", sender: nil)
            let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let listofactions = mainstoryboard.instantiateViewController(withIdentifier: "listofactions")
            let datainput = mainstoryboard.instantiateViewController(withIdentifier: "datainput")
            let rootViewController = self.navigationController
            var controllers = (rootViewController!.viewControllers)
            controllers.removeAll()
            var v = UIViewController()
            let grid = 0
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
            self.navigationController?.setViewControllers(controllers, animated: false)
        }else if((currentarr["CreditDescription"] as! String).lowercased() == "waste"){
            let c = credentials()
            //self.feedstable.hidden = true
            DispatchQueue.main.async(execute: {
                self.spinner.isHidden = false
                //self.view.userInteractionEnabled = true
                self.getallwastedata(c.subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"))
            })

        }
        else if((currentarr["CreditDescription"] as! String).lowercased() == "transportation"){
            let c = credentials()
            //self.feedstable.hidden = true
            DispatchQueue.main.async(execute: {
                self.spinner.isHidden = false
                //self.view.userInteractionEnabled = true
                self.getalltransitdata(c.subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"))
            })
        }else if((currentarr["CreditDescription"] as! String).lowercased() == "human experience"){
            let c = credentials()
            //getalltransitdata(c.subscription_key, leedid: 1000137969)
            //print("Human experience")
            //self.feedstable.hidden = true
            DispatchQueue.main.async(execute: {
                self.spinner.isHidden = false
                //self.view.userInteractionEnabled = true
                self.getmeters(c.subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"))
            })

        }
        else{
            //self.performSegueWithIdentifier("gotodatainput", sender: nil)
            let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let v = mainstoryboard.instantiateViewController(withIdentifier: "listofassets")
            let listofactions = mainstoryboard.instantiateViewController(withIdentifier: "listofactions")
            let datainput = mainstoryboard.instantiateViewController(withIdentifier: "datainput")
            let rootViewController = self.navigationController
            var controllers = (rootViewController!.viewControllers)
            controllers.removeAll()
            let listofassets = mainstoryboard.instantiateViewController(withIdentifier: "projectslist")
            let dict = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary
            listofassets.navigationItem.title = dict["name"] as? String
            controllers.append(listofassets)
            controllers.append(listofactions)
            controllers.append(datainput)
            self.navigationController?.setViewControllers(controllers, animated: false)
        }
        
    }
    
    
    func touched(_ sender: UIGestureRecognizer){
        if((self.currentarr["CreditDescription"] as! String).lowercased() == "waste"){
        self.sidebtnclick(UIButton())
        }
    }
    
    func getmeterreadings(_ subscription_key:String, leedid: Int, actionID: Int){
        let url = URL.init(string:String(format: "%@assets/LEED:%d/meters/ID:%d/consumption/",domain_url, leedid, actionID))
        print(url?.absoluteURL)
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
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affview.layer.frame.origin.y + self.affview.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
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
            } else
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print("Meter readings ",jsonDictionary)
                    let arr = jsonDictionary["results"] as! NSArray
                    let startdatearrforco2 = NSMutableArray()
                    let enddatearrforco2 = NSMutableArray()
                    let startdatearrforvoc = NSMutableArray()
                    let enddatearrforvoc = NSMutableArray()
                    if(arr.count > 0){
                    for i in 0..<arr.count{
                        let dict = (arr.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        
                        if let meter = dict["meter"] as? NSDictionary, let fuel_type = meter["fuel_type"] as? NSDictionary, let kind = fuel_type["kind"] as? String{
                        if(kind == "voc"){
                            self.data.append(dict["reading"] as! Int)
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = credentials().micro_secs//"yyyy-MM-dd"
                            var tempdict = NSMutableDictionary()
                            var date = dateFormatter.date(from: dict["start_date"] as! String)!
                            tempdict["start_date"] = date 
                            startdatearrforvoc.add(tempdict)
                            date = dateFormatter.date(from: dict["end_date"] as! String)! 
                            tempdict["end_date"] = date 
                            startdatearrforvoc.add(tempdict)
                            enddatearrforvoc.add(tempdict)
                            let sortDescriptor = NSSortDescriptor.init(key: "start_date", ascending: true)
                            startdatearrforvoc.sort(using: NSArray.init(object: sortDescriptor) as! [NSSortDescriptor])
                            NSSortDescriptor.init(key: "end_date", ascending: true)
                            enddatearrforvoc.sort(using: NSArray.init(object: sortDescriptor) as! [NSSortDescriptor])
                            //print("Date arr ",startdatearrforvoc.firstObject,enddatearrforvoc.lastObject)
                            UserDefaults.standard.set((startdatearrforvoc.firstObject as? NSDictionary)?["start_date"], forKey: "startdateforvoc")
                            //self.view.userInteractionEnabled = true
                            UserDefaults.standard.set((enddatearrforvoc.lastObject as? NSDictionary)?["end_date"], forKey: "enddateforvoc")
                            
                        }else if(kind == "co2"){
                            self.data2.append(dict["reading"] as! Int)
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = credentials().micro_secs//"yyyy-MM-dd"
                            var tempdict = NSMutableDictionary()
                            var date = dateFormatter.date(from: dict["start_date"] as! String)!
                            tempdict["start_date"] = date 
                            startdatearrforco2.add(tempdict)
                            date = dateFormatter.date(from: dict["end_date"] as! String)!
                            tempdict["end_date"] = date 
                            startdatearrforco2.add(tempdict)
                            enddatearrforco2.add(tempdict)
                            let sortDescriptor = NSSortDescriptor.init(key: "start_date", ascending: true)
                            //self.view.userInteractionEnabled = true
                            startdatearrforco2.sort(using: NSArray.init(object: sortDescriptor) as! [NSSortDescriptor])
                            NSSortDescriptor.init(key: "end_date", ascending: true)
                            enddatearrforco2.sort(using: NSArray.init(object: sortDescriptor) as! [NSSortDescriptor])
                            //print("Date arr ",startdatearrforco2.firstObject,enddatearrforco2.lastObject)
                            UserDefaults.standard.set((startdatearrforco2.firstObject as? NSDictionary)?["start_date"], forKey: "startdateforco2")
                            UserDefaults.standard.set((enddatearrforco2.lastObject as? NSDictionary)?["end_date"], forKey: "enddateforco2")
                        }
                    }
                        if(self.currentcount == self.meters.count){
                            DispatchQueue.main.async(execute: {
                                self.gethumansurveydata(UserDefaults.standard.integer(forKey: "leed_id"), subscription_key: credentials().subscription_key)
                            })
                        }
                        
                    }
                    }else{
                        DispatchQueue.main.async(execute: {
                            self.gethumansurveydata(UserDefaults.standard.integer(forKey: "leed_id"), subscription_key: credentials().subscription_key)
                        })
                    }
                    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if(fromnotification == 1){
            self.navigationController?.navigationBar.backItem?.title = "Notifications"
        }else{
        self.navigationController?.navigationBar.backItem?.title = "Credits/Actions"
        }
        let dict = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary
        self.navigationItem.title = dict["name"] as? String
        navigate()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "gotoreadings"){
            let v = segue.destination as! wastereadings
            //print(self.meters)
            v.meters = self.meters
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(tableView == feedstable){
        let height = UIScreen.main.bounds.size.height
            
        return 0.017 * height
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height = UIScreen.main.bounds.size.height
        if(tableView == feedstable){
            return 0.035 * height
        }
        if(section == 0){
            return 1
        }
        return 1
    }

    func gethumansurveydata(_ leedid: Int, subscription_key: String){
        
        let url = URL.init(string:String(format: "%@assets/LEED:%d/survey/environment/summarize/",domain_url, leedid))
        ////print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let s = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(s)
        self.task = s.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
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
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affview.layer.frame.origin.y + self.affview.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
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
            } else
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print("Meters are",jsonDictionary)
                    //self.graphPoints = jsonDictionary["results"] as! NSArray
                    self.satisfactionarr = [0,0,0,0,0,0,0,0,0,0]
                    self.dissatisfactionarr = [0,0,0,0,0,0,0,0,0,0]
                    self.currentmetersdict  = (jsonDictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    //self.sview.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, 2.1 * UIScreen.mainScreen().bounds.size.height)                    
                    //self.view.userInteractionEnabled = true
                    self.satisfactionarr = jsonDictionary["satisfaction"] as! [Int]
                    DispatchQueue.main.async(execute: {
                        UserDefaults.standard.set(self.satisfactionarr, forKey: "satisfaction")
                    //print(self.satisfactionarr, self.dissatisfactionarr)
                        DispatchQueue.main.async(execute: {
                            //self.vv.hidden = false
                            //self.spinner.hidden = false
                            self.getsummarizedata(subscription_key, leedid: leedid)
                        })
                        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableview.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height){
            if(tableView == feedstable){
                if(indexPath.section == 0){
                    if((self.currentarr["CreditDescription"] as! String).lowercased() == "transportation" || (self.currentarr["CreditDescription"] as! String).lowercased() == "human experience"){
                        return 0.058 * UIScreen.main.bounds.size.height;
                    }else if((self.currentarr["CreditDescription"] as! String).lowercased() == "waste"){
                    return 0.107 * UIScreen.main.bounds.size.height;
                    }else{
                    return 0.197 * UIScreen.main.bounds.size.height;
                    }
                }else{
                    
                    return 0.107 * UIScreen.main.bounds.size.height;
                }
            }
            return 0.055 * UIScreen.main.bounds.size.height;
        }
        return 0.067 * UIScreen.main.bounds.size.width;
    }
    
    
    
    func getmeterdata() {
        if(self.meters.count == 0){
            //self.maketoast("No data found",type: "error")
            self.spinner.isHidden = true
            DispatchQueue.main.async(execute: {
                //self.view.userInteractionEnabled = true
                self.spinner.isHidden = false
                self.gethumansurveydata(UserDefaults.standard.integer(forKey: "leed_id"), subscription_key: credentials().subscription_key)
                //self.showactivityfeed(NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), creditID: self.currentarr["CreditId"] as! String, shortcreditID: self.currentarr["CreditShortId"] as! String)
            })
        }
        for i in 0..<self.meters.count {
            let c = credentials()
            let tempdict = (meters.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            DispatchQueue.main.asyncAfter(
                deadline: DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
                execute: {
                    self.currentcount += 1
                    self.getmeterreadings(c.subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"), actionID: tempdict["id"] as! Int)
                }
            )
            
            
            // go to something on the main thread with the image like setting to UIImageView
        }
        //print("Got date",UserDefaults.standard.object(forKey: "startdateforco2"),UserDefaults.standard.object(forKey: "startdateforvoc"),data,data2 )
        
    }
    func getmeters(_ subscription_key:String, leedid: Int){
        let url = URL.init(string:String(format: "%@assets/LEED:%d/meters/?kind=humanexperience",domain_url, leedid))
        ////print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let s = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(s)
        self.task = s.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
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
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affview.layer.frame.origin.y + self.affview.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
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
            } else
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print("Meters are",jsonDictionary)
                    //self.graphPoints = jsonDictionary["results"] as! NSArray
                    self.currentmetersdict  = (jsonDictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    self.meters = (jsonDictionary["results"] as! NSArray).mutableCopy() as! NSMutableArray
                    
                    //self.view.userInteractionEnabled = true
                    DispatchQueue.main.async(execute: {
                    self.getmeterdata()
                    })
                    
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
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(tableView == feedstable){
            if(section == 0){
                if((self.currentarr["CreditDescription"] as! String).lowercased() != "waste"){
                return "SURVEYS(% OF PEOPLE RESPONDED)"
                }
                
            }
            if(currentfeeds.count > 0){
                return "Activities"
            }
            return "No activities present"
        }
        
        return ""
    }
    
    
    func getallwastedata(_ subscription_key:String, leedid: Int){
        let url = URL.init(string:String(format: "%@assets/LEED:%d/waste/",domain_url, leedid))
        ////print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let s = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(s)
        self.task = s.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
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
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affview.layer.frame.origin.y + self.affview.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
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
            } else
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                DispatchQueue.main.async(execute: {
                
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print("Meters are",jsonDictionary)
                    //self.graphPoints = jsonDictionary["results"] as! NSArray
                    //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"beginDate" ascending:TRUE];
                    //[myMutableArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                    
                        self.cc.frame =  CGRect(x:self.tableview.frame.origin.x ,y:0,width:self.tableview.frame.size.width, height:self.vv.frame.size.width )
                        self.vv.contentSize = CGSize(width: self.vv.frame.size.width,height:1.2 * (self.cc.frame.size.height+self.tableview.frame.size.height + self.feedstable.frame.size.height))
                    
                    self.vv.frame.size.height = self.vv.contentSize.height
                    if(UIDevice.current.orientation == .portrait){
                            self.sview.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 1.6 * UIScreen.main.bounds.size.height)
                    }else{
                        
                    }
                        if(self.cc.viewWithTag(23) != nil){
                            self.cc.viewWithTag(23)?.removeFromSuperview()
                        }
                        if(self.cc.viewWithTag(24) != nil){
                            self.cc.viewWithTag(24)?.removeFromSuperview()
                        }
                        if(self.cc.viewWithTag(25) != nil){
                            self.cc.viewWithTag(25)?.removeFromSuperview()
                        }
                        if(self.cc.viewWithTag(26) != nil){
                            self.cc.viewWithTag(26)?.removeFromSuperview()
                        }
                        
                        self.data2.removeAll()
                        self.data.removeAll()
                        
                    let startdatearr = NSMutableArray()
                    let enddatearr = NSMutableArray()
                    self.currentmetersdict  = (jsonDictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    self.meters = (jsonDictionary["results"] as! NSArray).mutableCopy() as! NSMutableArray
                    //self.view.userInteractionEnabled = true
                    UserDefaults.standard.removeObject(forKey: "startdate")
                    UserDefaults.standard.removeObject(forKey: "enddate")
                    if(self.meters.count>0){
                        for i in 0...self.meters.count-1{
                            let item = (self.meters.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                            var f1 = 0.0234234
                            var f2 = 0.0
                            f1 = item["waste_diverted"] as! Double
                            f2 = item["waste_generated"] as! Double
                            self.data.append(Int(f1))
                            self.data2.append(Int(f2))
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            var tempdict = NSMutableDictionary()
                            var date = dateFormatter.date(from: item["start_date"] as! String)!
                            tempdict["start_date"] = date 
                            startdatearr.add(tempdict)
                            date = dateFormatter.date(from: item["end_date"] as! String)! 
                            tempdict["end_date"] = date 
                            startdatearr.add(tempdict)
                            enddatearr.add(tempdict)
                            let sortDescriptor = NSSortDescriptor.init(key: "start_date", ascending: true)
                            startdatearr.sort(using: NSArray.init(object: sortDescriptor) as! [NSSortDescriptor])
                            NSSortDescriptor.init(key: "end_date", ascending: true)
                            enddatearr.sort(using: NSArray.init(object: sortDescriptor) as! [NSSortDescriptor])
                            //print("Date arr ",startdatearr.firstObject,enddatearr.lastObject)
                            UserDefaults.standard.set((startdatearr.firstObject as? NSDictionary)?["start_date"] , forKey: "startdate")
                            UserDefaults.standard.set((enddatearr.lastObject as? NSDictionary)?["end_date"], forKey: "enddate")
                        }
                    }
                    
                        self.data = self.data.reversed()
                        self.data2 = self.data2.reversed()
                        UserDefaults.standard.set(self.data, forKey: "data")
                        UserDefaults.standard.set(self.data2, forKey: "data2")           
                        if(UIDevice.current.orientation == .portrait){
                            self.vv.frame =  CGRect(x:self.affview.layer.frame.origin.x,y:self.vv.frame.origin.y,width:self.affview.frame.size.width, height:self.affview.frame.size.width )
                        }else{
                            self.vv.frame =  CGRect(x:self.affview.layer.frame.origin.x,y:self.vv.frame.origin.y,width:self.affview.frame.size.width, height:self.affview.frame.size.width )
                        }
                    self.cc.isHidden = false
                        let view = chartview()
                        self.cc.frame =  CGRect(x:self.tableview.frame.origin.x ,y:0,width:self.tableview.frame.size.width, height:self.vv.frame.size.width )
                        self.vv.contentSize = CGSize(width: self.vv.frame.size.width,height:1.2 * (self.cc.frame.size.height+self.tableview.frame.size.height + self.feedstable.frame.size.height))
                    self.vv.frame.size.height = self.vv.contentSize.height
                        if(self.cc.viewWithTag(23) != nil){
                            self.cc.viewWithTag(23)?.removeFromSuperview()
                        }
                        if(self.cc.viewWithTag(24) != nil){
                            self.cc.viewWithTag(24)?.removeFromSuperview()
                        }
                        if(self.cc.viewWithTag(25) != nil){
                            self.cc.viewWithTag(25)?.removeFromSuperview()
                        }
                        if(self.cc.viewWithTag(26) != nil){
                            self.cc.viewWithTag(26)?.removeFromSuperview()
                        }
                        
                        view.frame = CGRect(x:0,y:1.02 * self.tableview.frame.origin.y + self.tableview.frame.size.height,width:self.cc.frame.width, height: self.cc.frame.size.width)
                        view.tag = 23
                        self.cc.addSubview(view)
                        //self.vv.hidden = false
                        if((self.currentarr["CreditDescription"] as! String).lowercased() == "waste"){
                            let rect = self.addnew.frame
                            self.addnew.setImage(self.imageWithImage(UIImage(named:"addnewdata.png")!, scaledToSize: CGSize(width:70, height: 70)), for: UIControlState())
                            self.addnew.frame = rect
                            self.addnew.layer.cornerRadius = rect.size.height/2.0
                            //self.addnew.titleLabel?.text = "Add new reading"
                        }else if((self.currentarr["CreditDescription"] as! String).lowercased() == "transportation"){
                            let rect = self.addnew.frame
                            self.addnew.setImage(self.imageWithImage(UIImage(named:"invitation_icon.png")!, scaledToSize: CGSize(width:70, height: 70)), for: UIControlState())
                            self.addnew.frame = rect
                            self.addnew.layer.cornerRadius = rect.size.height/2.0
                            //self.addnew.titleLabel?.text = "Email survey"
                        }
                        
                        if(self.meters.count == 0){
                            //self.maketoast("No data found",type: "error")
                            self.cc.isHidden = false
                            self.vv.isHidden = false
                            DispatchQueue.main.async(execute: {
                                //self.view.userInteractionEnabled = true
                                self.spinner.isHidden = false
                                self.showactivityfeed(UserDefaults.standard.integer(forKey: "leed_id"), creditID: self.currentarr["CreditId"] as! String, shortcreditID: self.currentarr["CreditShortId"] as! String)
                            })
                        }
                self.feedstable.frame = CGRect(x:self.feedstable.frame.origin.x,y:view.frame.origin.y+view.frame.size.height,width:self.feedstable.frame.width, height: self.feedstable.layer.frame.size.height)
                        //print(self.feedstable.frame.size.height,self.sview.contentSize.height)
                    
                    var totaly = view.frame.size.height + self.tableview.frame.size.height
                    
                    self.sview.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: totaly)
                    
                    self.feedstable.frame = CGRect(x:self.feedstable.frame.origin.x,y:view.frame.origin.y+view.frame.size.height,width:self.feedstable.frame.width, height: self.feedstable.frame.size.height)
                    
                    
                    self.vv.frame.size.height = self.vv.contentSize.height
                    self.feedstable.frame = CGRect(x:self.feedstable.frame.origin.x,y:view.frame.origin.y+view.frame.size.height,width:self.feedstable.frame.width, height: self.feedstable.frame.size.height)
                    
                    
                        self.showactivityfeed(UserDefaults.standard.integer(forKey: "leed_id"), creditID: self.currentarr["CreditId"] as! String, shortcreditID: self.currentarr["CreditShortId"] as! String)
                        return
                    // self.buildingactions(subscription_key, leedid: leedid)
                    
                } catch {
                    //print(error)
                    DispatchQueue.main.async(execute: {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                    })
            }
            
        }) 
        task.resume()
    }
    
    
    
    
    
    @IBOutlet weak var backbtn: UIButton!
    func showalert(_ message:String, title:String, action:String){
        
        //let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        //let callActionHandler = { (action:UIAlertAction!) -> Void in
        DispatchQueue.main.async(execute: {
            self.view.isUserInteractionEnabled = true
            self.spinner.isHidden = true
            self.maketoast(message, type: "error")
            //self.navigationController?.popViewControllerAnimated(true)
        })
        
        //        }
        //      let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        //    alertController.addAction(defaultAction)
        
        //presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == tableview){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! prerequisitescell2
            cell.fileuploaded.isHidden = true
            cell.uploadbutton.isHidden = true
            cell.uploadanewfile.isHidden = true
            cell.assignedto.isHidden = false
            cell.editbutton.isHidden = false
            cell.editbutton.addTarget(self, action: #selector(edited), for: UIControlEvents.touchUpInside)
            var text = ""
            cell.assignedto.isHidden = false
            if let assignedto = currentarr["PersonAssigned"] as? String{
                var temp = assignedto
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
            cell.textLabel?.text = cell.assignedto.text
            cell.textLabel?.font = cell.assignedto.font
            cell.assignedto.text = ""
            
            return cell
        }else{
        
            if(indexPath.section == 0){
                if((self.currentarr["CreditDescription"] as! String).lowercased() != "waste"){
                var cell = tableView.dequeueReusableCell(withIdentifier: "progresscell")! as! progresscell
                
                    switch UIDevice.current.userInterfaceIdiom {
                    case .phone:
                        // It's an iPhone
                        cell.percentagelbl.frame.origin.y = cell.contextlbl.frame.origin.y
                        cell.img.frame.origin.y = 0.2 * cell.contextlbl.frame.size.height
                        cell.img.frame.size.width = 0.6 * cell.contextlbl.frame.size.height
                        cell.img.frame.size.height = 0.6 * cell.contextlbl.frame.size.height
                        break
                    case .pad:
                        cell.percentagelbl.frame.origin.y = cell.contextlbl.frame.origin.y
                        cell.img.frame.origin.y = 0.3 * cell.contextlbl.frame.size.height
                        cell.img.frame.size.width = 0.45 * cell.contextlbl.frame.size.height
                        cell.img.frame.size.height = 0.45 * cell.contextlbl.frame.size.height
                        cell.img.frame.origin.x = 0.04 * cell.contentView.frame.size.width
                        cell.contextlbl.frame.origin.x = (cell.img.frame.origin.x + cell.img.frame.size.width)
                        // It's an iPad
                        
                        break
                    case .unspecified:
                        cell.percentagelbl.frame.origin.y = cell.contextlbl.frame.origin.y
                        cell.img.frame.origin.y = 0.2 * cell.contextlbl.frame.size.height
                        cell.img.frame.size.width = 0.6 * cell.contextlbl.frame.size.height
                        cell.img.frame.size.height = 0.6 * cell.contextlbl.frame.size.height
                        break
                        
                    default :
                        cell.percentagelbl.frame.origin.y = cell.contextlbl.frame.origin.y
                        cell.img.frame.origin.y = 0.2 * cell.contextlbl.frame.size.height
                        cell.img.frame.size.width = 0.6 * cell.contextlbl.frame.size.height
                        cell.img.frame.size.height = 0.6 * cell.contextlbl.frame.size.height
                        // Uh, oh! What could it be?
                    }
                    cell.percentagelbl.isHidden = true
                    cell.img.isHidden = true
                    cell.contextlbl.frame.origin.x = cell.img.frame.origin.x
                    cell.contextlbl.frame.size.width = cell.percentagelbl.frame.origin.x + cell.percentagelbl.frame.size.width
                var occupancy = 1
                if let occ = building_dict["occupancy"] as? Int{
                    occupancy = occ
                }
                    
                    if((self.currentarr["CreditDescription"] as! String).lowercased() == "transportation"){
                        cell.vv.strokecolor = UIColor.lightGray
                    }else{
                        cell.vv.strokecolor = UIColor.init(red: 0.92, green: 0.609, blue: 0.236, alpha: 1)
                    }
                if let response = summarized_data["responses"] as? Int{
                cell.vv.strokevalue = Double(response)/Double(occupancy)                    
                    cell.percentagelbl.text = String(format: "%.2f%%",100 * Double(response)/Double(occupancy))
                    cell.contextlbl.numberOfLines = 3
                    if(occupancy < 500){
                        cell.contextlbl.text = "A response rate of 25.00% for your project, will generate a score"
                    }else{
                        cell.contextlbl.text = String(format:"A response rate of %.2f%% for your project, will generate a score",(0.25/sqrt(Double(occupancy)/500.0)) * 100)
                    }
                    cell.selectionStyle = .none
                    
                }
                
                cell.vv.addUntitled1Animation()
                return cell
                }
            }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "feedcell")! 
        
        var dict = (currentfeeds.object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        cell.textLabel?.text = dict["verb"] as! String
            var s = cell.textLabel?.text
            s = s?.replacingOccurrences(of: "for  ", with: "for ")
            cell.textLabel?.text = s
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        var str = dict["timestamp"] as! String
        var formatter = DateFormatter()
            formatter.dateFormat = credentials().micro_secs
            if(formatter.date(from: str) != nil){
                
            }else{
            formatter.dateFormat = credentials().milli_secs
            }
            let date = formatter.date(from: str)!
            formatter.dateFormat = "MMM dd, yyyy"
            let temp = formatter.string(from: date)
            formatter.dateFormat = "hh:mm a"
            let time = formatter.string(from: date)
            cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
            cell.detailTextLabel?.text = "\(temp) at \(time)"
        return cell
            
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(tableView == feedstable){
            if((self.currentarr["CreditDescription"] as! String).lowercased() == "waste"){
             return 1
            }
         return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == feedstable){
            if(section == 0){
                if((self.currentarr["CreditDescription"] as! String).lowercased() != "waste"){
                    return 1
                }else{
                    return currentfeeds.count
                }
            }
            return currentfeeds.count
        }
        return 1
    }
    
    
    func edited(){
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
    
    func getalltransitdata(_ subscription_key:String, leedid: Int){
        let url = URL.init(string:String(format: "%@assets/LEED:%d/survey/transit/summarize/",domain_url, leedid))
        ////print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let s = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(s)
        self.task = s.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
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
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affview.layer.frame.origin.y + self.affview.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
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
            } else
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print("Meters are",jsonDictionary)
                    //self.graphPoints = jsonDictionary["results"] as! NSArray
                    
                    DispatchQueue.main.async(execute: {
                        var arr = [0,0,0,0,0,0,0,0]
                        var modes = jsonDictionary["modes"] as! NSDictionary
                        self.sview.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 1.6 * UIScreen.main.bounds.size.height)
                        self.cc.isHidden = false
                        self.vv.isHidden = false
                        
                        for (item,value) in modes{
                            var str = item as! String
                            if(str == "car23"){
                                arr[0] = Int(value as! NSNumber)
                            }else if(str == "light_rail"){
                                arr[1] = Int(value as! NSNumber)
                            }else if(str == "motorcycle"){
                                arr[2] = Int(value as! NSNumber)
                            }else if(str == "cars4"){
                                arr[3] = Int(value as! NSNumber)
                            }else if(str == "car"){
                                arr[4] = Int(value as! NSNumber)
                            }else if(str == "bus"){
                                arr[5] = Int(value as! NSNumber)
                            }else if(str == "heavy_rail"){
                                arr[6] = Int(value as! NSNumber)
                            }else if(str == "walk"){
                                arr[7] = Int(value as! NSNumber)
                            }
                        }
                        var d = [0,0,0,0,0,0,0,0]
                        UserDefaults.standard.set(d, forKey: "data")
                        UserDefaults.standard.set(arr, forKey: "data2")
                        
                        let view = chartview()
                        if(UIDevice.current.orientation == .portrait){
                            self.vv.frame =  CGRect(x:self.affview.layer.frame.origin.x,y:self.vv.frame.origin.y,width:self.affview.frame.size.width, height:self.affview.frame.size.width )
                        }else{
                            self.vv.frame =  CGRect(x:self.affview.layer.frame.origin.x,y:self.vv.frame.origin.y,width:self.affview.frame.size.width, height:self.affview.frame.size.width )
                        }
                        self.vv.contentSize = CGSize(width: self.vv.frame.size.width,height:1.2 * (self.cc.frame.size.height+self.tableview.frame.size.height + self.feedstable.frame.size.height ))
                        self.vv.frame.size.height = self.vv.contentSize.height
                        self.cc.frame =  CGRect(x:0,y:0,width:self.vv.frame.size.width, height:self.vv.frame.size.width)
                        self.cc.frame.size.width = 0.42 * UIScreen.main.bounds.size.height
                        self.cc.center.x = self.view.frame.size.width/2
                        if(self.cc.viewWithTag(23) != nil){
                            self.cc.viewWithTag(23)?.removeFromSuperview()
                        }
                        if(self.cc.viewWithTag(24) != nil){
                            self.cc.viewWithTag(24)?.removeFromSuperview()
                        }
                        if(self.cc.viewWithTag(25) != nil){
                            self.cc.viewWithTag(25)?.removeFromSuperview()
                        }
                        if(self.cc.viewWithTag(26) != nil){
                            self.cc.viewWithTag(26)?.removeFromSuperview()
                        }
                        view.frame = CGRect(x:0,y:1.02 * self.tableview.frame.origin.y + self.tableview.frame.size.height,width:self.cc.frame.width, height: self.cc.frame.size.width)
                        view.tag = 23
                        self.cc.addSubview(view)
                        self.vv.isHidden = false
                        if((self.currentarr["CreditDescription"] as! String).lowercased() == "waste"){
                            let rect = self.addnew.frame
                            self.addnew.setImage(UIImage(named: "addnewdata.png") as UIImage?, for: UIControlState())
                            self.addnew.frame = rect
                            self.addnew.layer.cornerRadius = rect.size.height/2.0
                            //self.addnew.titleLabel?.text = "Add new reading"
                        }else if((self.currentarr["CreditDescription"] as! String).lowercased() == "transportation"){
                            let rect = self.addnew.frame
                            self.addnew.setImage(UIImage(named: "invitation_icon.png") as UIImage?, for: UIControlState())
                            self.addnew.frame = rect
                            self.addnew.layer.cornerRadius = rect.size.height/2.0
                            //self.addnew.titleLabel?.text = "Email survey"
                        }
                        var totaly = view.frame.origin.y + view.frame.size.height + self.tableview.frame.origin.y + self.tableview.frame.size.height //+ self.affview.frame.origin.y + self.affview.frame.size.height
                        
                        self.sview.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: totaly)
                        
                        self.feedstable.frame = CGRect(x:self.feedstable.frame.origin.x,y:view.frame.origin.y+view.frame.size.height,width:self.feedstable.frame.width, height: self.feedstable.frame.size.height)
                        
                        
                        self.vv.frame.size.height = self.vv.contentSize.height
                        self.feedstable.frame = CGRect(x:self.feedstable.frame.origin.x,y:view.frame.origin.y+view.frame.size.height,width:self.feedstable.frame.width, height: self.feedstable.frame.size.height)
                        
                        self.getsummarizedata(subscription_key, leedid: leedid)
                    })

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
    
    @IBOutlet weak var addnew: UIButton!
    @IBOutlet weak var prev: UIButton!
    
    @IBOutlet weak var nxt: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func gotonext(_ sender: AnyObject) {
        if(currentindex<currentcategory.count-1){
            /*if(task.currentRequest != nil){
             if (task.state == NSURLSessionTaskState.Running) {
             task.cancel()
             }
             }*/
            currentindex = currentindex+1
            UserDefaults.standard.set(currentindex, forKey: "selected_action")
            currentarr = (currentcategory[currentindex] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            if((currentarr["CreditDescription"] as! String).lowercased() == "human experience" || (currentarr["CreditDescription"] as! String).lowercased() == "transportation" || (currentarr["CreditDescription"] as! String).lowercased() == "waste"){
                if((self.currentarr["CreditDescription"] as! String).lowercased() == "waste"){
                    let rect = self.addnew.frame
                    self.addnew.setImage(UIImage(named: "addnewdata.png") as UIImage?, for: UIControlState())
                    self.addnew.frame = rect
                    self.addnew.layer.cornerRadius = rect.size.height/2.0
                    //self.addnew.titleLabel?.text = "Add new reading"
                }else if((self.currentarr["CreditDescription"] as! String).lowercased() == "transportation" || (self.currentarr["CreditDescription"] as! String).lowercased() == "human experience"){
                    let rect = self.addnew.frame
                    self.addnew.setImage(UIImage(named: "invitation_icon.png") as UIImage?, for: UIControlState())
                    self.addnew.frame = rect
                    self.addnew.layer.cornerRadius = rect.size.height/2.0
                    //self.addnew.titleLabel?.text = "Email survey"
                }
                //navigate()
                DispatchQueue.main.async(execute: {
                self.spinner.isHidden = false
                UserDefaults.standard.set(1, forKey: "notoast")
                self.buildingactions(credentials().subscription_key, leedid: self.leedid)
                })
            }else{
                //self.performSegueWithIdentifier("gotodatainput", sender: nil)
                let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                let v = mainstoryboard.instantiateViewController(withIdentifier: "listofassets")
                let listofactions = mainstoryboard.instantiateViewController(withIdentifier: "listofactions")
                var datainput = mainstoryboard.instantiateViewController(withIdentifier: "datainput")
                if(currentarr["CreditcategoryDescrption"] as! String == "Innovation"){
                    datainput = mainstoryboard.instantiateViewController(withIdentifier: "prerequisites")
                }else{
                    datainput = mainstoryboard.instantiateViewController(withIdentifier: "datainput")
                }
                
                let rootViewController = self.navigationController
                var controllers = (rootViewController!.viewControllers)
                controllers.removeAll()
                var listofassets = mainstoryboard.instantiateViewController(withIdentifier: "projectslist")
                let grid = 0
                if(grid == 1){
                    listofassets = mainstoryboard.instantiateViewController(withIdentifier: "gridvc")
                }else{
                    listofassets = mainstoryboard.instantiateViewController(withIdentifier: "projectslist")
                }
                listofassets.navigationItem.title = building_dict["name"] as? String
                controllers.append(listofassets)
                controllers.append(listofactions)
                controllers.append(datainput)
                self.navigationController?.setViewControllers(controllers, animated: false)
            }
        }else{
            currentindex = 0
            UserDefaults.standard.set(currentindex, forKey: "selected_action")
            currentarr = (currentcategory[currentindex] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            let datakeyed = NSKeyedArchiver.archivedData(withRootObject: currentcategory)
            UserDefaults.standard.set(datakeyed, forKey: "currentcategory")
            UserDefaults.standard.set(currentindex, forKey: "selected_action")
            
            if((currentarr["CreditDescription"] as! String).lowercased() == "human experience" || (currentarr["CreditDescription"] as! String).lowercased() == "transportation" || (currentarr["CreditDescription"] as! String).lowercased() == "waste"){
                if((self.currentarr["CreditDescription"] as! String).lowercased() == "waste"){
                    let rect = self.addnew.frame
                    self.addnew.setImage(UIImage(named: "addnewdata.png") as UIImage?, for: UIControlState())
                    self.addnew.frame = rect
                    self.addnew.layer.cornerRadius = rect.size.height/2.0
                    //self.addnew.titleLabel?.text = "Add new reading"
                }else if((self.currentarr["CreditDescription"] as! String).lowercased() == "transportation" || (self.currentarr["CreditDescription"] as! String).lowercased() == "human experience"){
                    let rect = self.addnew.frame
                    self.addnew.setImage(UIImage(named: "invitation_icon.png") as UIImage?, for: UIControlState())
                    self.addnew.frame = rect
                    self.addnew.layer.cornerRadius = rect.size.height/2.0
                    //self.addnew.titleLabel?.text = "Email survey"
                }
                //navigate()
                DispatchQueue.main.async(execute: {
                self.spinner.isHidden = false
                UserDefaults.standard.set(1, forKey: "notoast")
                self.buildingactions(credentials().subscription_key, leedid: self.leedid)
                })
            }else{
                //self.performSegueWithIdentifier("gotodatainput", sender: nil)
                let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                let v = mainstoryboard.instantiateViewController(withIdentifier: "listofassets")
                let listofactions = mainstoryboard.instantiateViewController(withIdentifier: "listofactions")
                var datainput = mainstoryboard.instantiateViewController(withIdentifier: "datainput")
                if(currentarr["CreditcategoryDescrption"] as! String == "Innovation"){
                    datainput = mainstoryboard.instantiateViewController(withIdentifier: "prerequisites")
                }else{
                    datainput = mainstoryboard.instantiateViewController(withIdentifier: "prerequisites")
                }
                
                let rootViewController = self.navigationController
                var controllers = (rootViewController!.viewControllers)
                controllers.removeAll()
                var listofassets = mainstoryboard.instantiateViewController(withIdentifier: "projectslist")
                let grid = 0
                if(grid == 1){
                    listofassets = mainstoryboard.instantiateViewController(withIdentifier: "gridvc")
                }else{
                    listofassets = mainstoryboard.instantiateViewController(withIdentifier: "projectslist")
                }
                listofassets.navigationItem.title = building_dict["name"] as? String
                controllers.append(listofassets)
                controllers.append(listofactions)
                controllers.append(datainput)
                self.navigationController?.setViewControllers(controllers, animated: false)
            }

        }
    }
    
    var building_dict = NSDictionary()
    
    @IBAction func gotoprevious(_ sender: AnyObject) {
        if(currentindex>0){
            /*if(task.currentRequest != nil){
             if (task.state == NSURLSessionTaskState.Running) {
             task.cancel()
             }
             }*/
            currentindex = currentindex-1
            UserDefaults.standard.set(currentindex, forKey: "selected_action")
            currentarr = (currentcategory[currentindex] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            if((currentarr["CreditDescription"] as! String).lowercased() == "human experience" || (currentarr["CreditDescription"] as! String).lowercased() == "transportation" || (currentarr["CreditDescription"] as! String).lowercased() == "waste"){
                if((self.currentarr["CreditDescription"] as! String).lowercased() == "waste"){
                    let rect = self.addnew.frame
                    self.addnew.setImage(UIImage(named: "addnewdata.png") as UIImage?, for: UIControlState())
                    self.addnew.frame = rect
                    self.addnew.layer.cornerRadius = rect.size.height/2.0
                    //self.addnew.titleLabel?.text = "Add new reading"
                }else if((self.currentarr["CreditDescription"] as! String).lowercased() == "transportation" || (self.currentarr["CreditDescription"] as! String).lowercased() == "human experience"){
                    let rect = self.addnew.frame
                    self.addnew.setImage(UIImage(named: "invitation_icon.png") as UIImage?, for: UIControlState())
                    self.addnew.frame = rect
                    self.addnew.layer.cornerRadius = rect.size.height/2.0
                    //self.addnew.titleLabel?.text = "Email survey"
                }
                //navigate()
                DispatchQueue.main.async(execute: {
                self.spinner.isHidden = false
                UserDefaults.standard.set(1, forKey: "notoast")
                self.buildingactions(credentials().subscription_key, leedid: self.leedid)
                })
            }else{
                //self.performSegueWithIdentifier("gotodatainput", sender: nil)
                let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                let v = mainstoryboard.instantiateViewController(withIdentifier: "listofassets")
                let listofactions = mainstoryboard.instantiateViewController(withIdentifier: "listofactions")
                let datainput = mainstoryboard.instantiateViewController(withIdentifier: "datainput")
                let rootViewController = self.navigationController
                var controllers = (rootViewController!.viewControllers)
                controllers.removeAll()
                let grid = 0
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
            }
        }
    }
    func checkcredit_type(_ tempdict:NSMutableDictionary) -> String {
        var temp = ""
        if(tempdict["Mandatory"] as! String == "X"){
            temp = "Pre-requisites"
        }else if ((tempdict["Mandatory"] as! String != "X") && (tempdict["CreditcategoryDescrption"] as! String != "Performance Category") && (tempdict["CreditcategoryDescrption"] as! String != "Performance")){
            temp = "Base scores"
        }
        else{
            temp = "Data input"
        }        
        return temp
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
        
        let s = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(s)
        self.task = s.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
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
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affview.layer.frame.origin.y + self.affview.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
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
            } else
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print(jsonDictionary)
                    DispatchQueue.main.async(execute: {
                        self.currentarr["PersonAssigned"] = String(format: "%@ %@",firstname,lastname) 
                        self.assigncontainer.isHidden = true
                        self.sview.alpha = 1
                        self.currentcategory.replaceObject(at: UserDefaults.standard.integer(forKey: "selected_action"), with: self.currentarr)
                        //self.view.userInteractionEnabled = true
                        UserDefaults.standard.set(0, forKey: "notoast")
                        self.buildingactions(credentials().subscription_key, leedid: leedid)
                        
                    })
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
    
    func getsummarizedata(_ subscription_key:String, leedid: Int){
        var url = URL.init(string:"")
        if(actiontitle.text?.lowercased() == "transportation"){
        url = URL.init(string: String(format: "%@assets/LEED:%d/survey/transit/summarize/",domain_url,leedid))!
        }else{
            url = URL.init(string: String(format: "%@assets/LEED:%d/survey/environment/summarize/",domain_url,leedid))!
        }
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let s = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(s)
        self.task = s.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
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
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affview.layer.frame.origin.y + self.affview.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
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
            } else
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                    DispatchQueue.main.async(execute: {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }else{
                    
                    let jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        self.summarized_data = jsonDictionary
                        //print(jsonDictionary)
                        DispatchQueue.main.async(execute: {
                            if(self.actiontitle.text?.lowercased() != "transportation"){
                                self.dissatisfactionarr.removeAll()
                                var complaints = jsonDictionary["complaints"] as! NSDictionary
                                self.dissatisfactionarr = [0,0,0,0,0,0,0,0,0,0]
                                for (item,value) in complaints{
                                    var str = item as! String
                                    if(str == "dirty"){
                                        self.dissatisfactionarr[0] = Int(value as! NSNumber)
                                    }else if(str == "smelly"){
                                        self.dissatisfactionarr[1] = Int(value as! NSNumber)
                                    }else if(str == "stuffy"){
                                        self.dissatisfactionarr[2] = Int(value as! NSNumber)
                                    }else if(str == "loud"){
                                        self.dissatisfactionarr[3] = Int(value as! NSNumber)
                                    }else if(str == "hot"){
                                        self.dissatisfactionarr[4] = Int(value as! NSNumber)
                                    }else if(str == "cold"){
                                        self.dissatisfactionarr[5] = Int(value as! NSNumber)
                                    }else if(str == "dark"){
                                        self.dissatisfactionarr[6] = Int(value as! NSNumber)
                                    }else if(str == "glare"){
                                        self.dissatisfactionarr[7] = Int(value as! NSNumber)
                                    }else if(str == "privacy"){
                                        self.dissatisfactionarr[8] = Int(value as! NSNumber)
                                    }else if(str == "other"){
                                        self.dissatisfactionarr[9] = Int(value as! NSNumber)
                                    }
                                }
                                UserDefaults.standard.set(self.dissatisfactionarr, forKey: "dissatisfaction")
                                UserDefaults.standard.set(self.data, forKey: "voc")
                                UserDefaults.standard.set(self.data2, forKey: "co2")
                                    if(UIDevice.current.orientation == .portrait){
                                        self.vv.frame =  CGRect(x:self.affview.layer.frame.origin.x,y:self.vv.frame.origin.y,width:self.affview.frame.size.width, height:self.affview.frame.size.width )
                                    }else{
                                        self.vv.frame =  CGRect(x:self.affview.layer.frame.origin.x,y:self.vv.frame.origin.y,width:self.affview.frame.size.width, height:self.affview.frame.size.width )
                                    }
                                    let view = satisfaction()
                                    
                                    self.vv.contentSize = CGSize(width: self.vv.frame.size.width,height:1.1 * (self.cc.frame.size.height+self.cc.frame.size.height+self.cc.frame.size.height+self.cc.frame.size.height+self.tableview.frame.size.height + self.feedstable.frame.size.height))
                                
                                self.cc.frame =  CGRect(x:self.tableview.frame.origin.x ,y:0,width:self.tableview.frame.size.width, height:self.vv.frame.size.width)
                                self.cc.frame.size.width = 0.42 * UIScreen.main.bounds.size.height
                                self.cc.center.x = self.view.frame.size.width/2
                                if(self.cc.viewWithTag(23) != nil){
                                    self.cc.viewWithTag(23)?.removeFromSuperview()
                                }
                                view.frame = CGRect(x:0,y:1.02 * self.tableview.frame.origin.y + self.tableview.frame.size.height,width:self.cc.frame.width, height: self.cc.frame.size.width)
                                view.tag = 23
                                self.cc.addSubview(view)
                                let view1 = dissatisfaction()
                                if(self.cc.viewWithTag(24) != nil){
                                    self.cc.viewWithTag(24)?.removeFromSuperview()
                                }
                                view1.frame = CGRect(x:0,y:view.layer.frame.origin.y+view.layer.frame.size.height,width:self.cc.frame.width, height: self.cc.frame.size.width)
                                view1.tag = 24
                                self.cc.addSubview(view1)
                                
                                
                                let view2 = voc()
                                if(self.cc.viewWithTag(25) != nil){
                                    self.cc.viewWithTag(25)?.removeFromSuperview()
                                }
                                view2.frame = CGRect(x:0,y:view1.layer.frame.origin.y+view1.layer.frame.size.height,width:self.cc.frame.width, height: self.cc.frame.size.width)
                                view2.tag = 25
                                self.cc.addSubview(view2)
                                let view3 = co2()
                                if(self.cc.viewWithTag(26) != nil){
                                    self.cc.viewWithTag(26)?.removeFromSuperview()
                                }
                                view3.frame = CGRect(x:0,y:view2.layer.frame.origin.y+view2.layer.frame.size.height,width:self.cc.frame.width, height: self.cc.frame.size.width)
                                view3.tag = 26
                                self.cc.addSubview(view3)
                                
                                var totaly = view.frame.size.height + view1.frame.size.height + view2.frame.size.height + view3.frame.size.height  + self.tableview.frame.size.height //+ self.affview.frame.origin.y + self.affview.frame.size.height
                                
                                self.sview.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: totaly)                                
                                    /*self.cc.frame =  CGRect(x:0,y:0,width:self.vv.frame.size.width, height:self.vv.frame.size.width )
                                    
                                    if(self.cc.viewWithTag(23) != nil){
                                        self.cc.viewWithTag(23)?.removeFromSuperview()
                                    }
                                    view.frame = CGRect(x:0,y:0,width:self.cc.frame.width, height: self.cc.frame.size.width)
                                    view.tag = 23
                                    self.cc.addSubview(view)
                                    let view1 = dissatisfaction()
                                    if(self.cc.viewWithTag(24) != nil){
                                        self.cc.viewWithTag(24)?.removeFromSuperview()
                                    }
                                    view1.frame = CGRect(x:0,y:view.layer.frame.origin.y+view.layer.frame.size.height,width:self.cc.frame.width, height: self.cc.frame.size.width)
                                    view1.tag = 24
                                    self.cc.addSubview(view1)
                                    
                                    
                                    let view2 = voc()
                                    if(self.cc.viewWithTag(25) != nil){
                                        self.cc.viewWithTag(25)?.removeFromSuperview()
                                    }
                                    view2.frame = CGRect(x:0,y:view1.layer.frame.origin.y+view1.layer.frame.size.height,width:self.cc.frame.width, height: self.cc.frame.size.width)
                                    view2.tag = 25
                                    self.cc.addSubview(view2)
                                    let view3 = co2()
                                    if(self.cc.viewWithTag(26) != nil){
                                        self.cc.viewWithTag(26)?.removeFromSuperview()
                                    }
                                    view3.frame = CGRect(x:0,y:view2.layer.frame.origin.y+view2.layer.frame.size.height,width:self.cc.frame.width, height: self.cc.frame.size.width)
                                    view3.tag = 26
                                    self.cc.addSubview(view3)*/
                                
                                
                                self.vv.frame.size.height = self.vv.contentSize.height
                                self.feedstable.frame = CGRect(x:self.feedstable.frame.origin.x,y:view3.frame.origin.y+view3.frame.size.height,width:self.feedstable.frame.width, height: self.feedstable.frame.size.height)
                                
                                }

                            self.showactivityfeed(UserDefaults.standard.integer(forKey: "leed_id"), creditID: self.currentarr["CreditId"] as! String, shortcreditID: self.currentarr["CreditShortId"] as! String)
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
    
    var summarized_data = NSDictionary()
    
    
    func buildingactions(_ subscription_key:String, leedid: Int){
        let url = URL.init(string: String(format: "%@assets/LEED:%d/actions/",domain_url,leedid))
        ////print(url?.absoluteURL)
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let s = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(s)
        self.task = s.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
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
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affview.layer.frame.origin.y + self.affview.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
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
            } else
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print(jsonDictionary)
                    DispatchQueue.main.async(execute: {
                        let datakeyed = NSKeyedArchiver.archivedData(withRootObject: jsonDictionary)
                        self.view.isUserInteractionEnabled = true
                        UserDefaults.standard.set(datakeyed, forKey: "actions_data")
                        UserDefaults.standard.synchronize()
                        self.spinner.isHidden = true
                        if(UserDefaults.standard.integer(forKey: "notoast") == 0){
                            self.maketoast("Updated successfully", type: "message")
                        }
                        self.navigate()
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
    
    @IBAction func closetheassigneecontainer(_ sender: AnyObject) {
        self.assigncontainer.isHidden = true
        self.sview.alpha = 1
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return teammembers.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(statusupdate == 1){
            return teammembers[row] as? String
        }

        if let calias = teammembers[row] as? NSDictionary, let useralias = calias["Useralias"] as? String {
            return useralias
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        assignokbtn.isEnabled = true
        if(statusupdate == 0){
        
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
        let s = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(s)
        self.task = s.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
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
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affview.layer.frame.origin.y + self.affview.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
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
            } else
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print(jsonDictionary)
                    let team_membersarray = jsonDictionary["EtTeamMembers"] as! NSArray
                    self.teammembers = team_membersarray.mutableCopy() as! NSMutableArray
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


    @IBAction func editassignee(_ sender: AnyObject) {


    }
    @IBOutlet weak var tableview: UITableView!
    
    @IBAction func assignthemember(_ sender: UIButton) {
        if(statusupdate == 1){
            self.view.isUserInteractionEnabled = false
            self.spinner.isHidden = false
            savestatusupdate(currentarr["CreditId"] as! String, subscription_key: credentials().subscription_key)
            
        }else{
            self.view.isUserInteractionEnabled = false
            self.spinner.isHidden = false
            
            if let snapshotValue = teammembers[picker.selectedRow(inComponent: 0)] as? NSDictionary, let currentcountr = snapshotValue["Useralias"] as? String,let first_name = snapshotValue["Firstname"] as? String,let last_name = snapshotValue["Lastname"] as? String {
                assignnewmember(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"), actionID: currentarr["CreditId"] as! String, email:currentcountr,firstname:first_name,lastname:last_name)
            }
            
            
            
        }

    }
    
    func savestatusupdate(_ actionID:String, subscription_key:String){
        //
        var url = URL.init(string:"")
        var s = String(format:"%d",leedid)
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
        var string = self.statusarr[self.picker.selectedRow(inComponent: 0)] as! String
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
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affview.layer.frame.origin.y + self.affview.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
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
                        self.buildingactions(credentials().subscription_key, leedid: self.leedid)
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
    
}

