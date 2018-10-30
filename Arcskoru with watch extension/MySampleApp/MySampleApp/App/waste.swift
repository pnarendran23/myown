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
    var download_requests = [NSURLSession]()
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
    var statusarr = ["Attempted","Ready for review"] as NSArray
    var statusupdate = 0
    let leedid = NSUserDefaults.standardUserDefaults().integerForKey("leed_id")
    @IBOutlet weak var assignokbtn: UIButton!
    @IBOutlet weak var assignclosebutton: UIButton!
    @IBOutlet weak var pleasekindly: UILabel!
    @IBOutlet weak var assigncontainer: UIView!
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var assetname: UILabel!
    var satisfactionarr = [Int]()
    var dissatisfactionarr = [Int]()
    var task = NSURLSessionTask()
    var currentcount = 0
    var currentindex = 0
    var data = [Int]()
    
    var meters = NSMutableArray()
    var teammembers = NSMutableArray()
    var data2 = [Int]()
    var currentarr = [String:AnyObject]()
    var currentmetersdict = [String:AnyObject]()
    var currentcategory = NSMutableArray()
    var domain_url = ""
    var token = ""
    @IBOutlet weak var vv: UIScrollView!
    @IBOutlet weak var btn: UIButton!
    
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
                let dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary
        mailComposerVC.setToRecipients([emailID])
        let surveylink = "\(credentials().survey_url )\(dict["leed_id"] as! Int)/survey/?key=\(dict["key"] as! String)"
        mailComposerVC.setSubject("Survey submitting invitation for a project \(dict["name"] as? String)")
        mailComposerVC.setMessageBody("Please kindly spend your valuable time to submit your feedback for the project \(surveylink )", isHTML: true)        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let alert  = UIAlertController.init(title: "Could not send email", message: "You device could not send e-mail. Please check e-mail configuration and try again", preferredStyle: .Alert)
        
        let cancel = UIAlertAction(title: "OK", style: .Cancel) { (action) -> Void in
            
        }
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    @IBAction func sidebtnclick(sender: AnyObject) {
        if((self.currentarr["CreditDescription"] as! String).lowercaseString == "waste"){
                self.performSegueWithIdentifier("gotoreadings", sender: nil)
        }else{
            print("Mail")
            var loginTextField: UITextField?
            let alertController = UIAlertController(title: "Email ID", message: "Please provide a receipient's email ID", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "Send", style: .Default, handler: { (action) -> Void in
                self.emailID = (loginTextField?.text!)!
                let mailComposeViewController = self.configuredMailComposeViewController()
                if MFMailComposeViewController.canSendMail() {
                    self.presentViewController(mailComposeViewController, animated: true, completion: nil)
                } else {
                    self.showSendMailErrorAlert()
                }
            })
            let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
                print("Cancel Button Pressed")
            }
            alertController.addAction(ok)
            alertController.addAction(cancel)
            alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
                // Enter the textfiled customization code here.
                loginTextField = textField
                loginTextField?.placeholder = "Enter the email ID"
            }
            self.presentViewController(alertController, animated: true, completion: nil)
        }
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
   /* override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if(UIDevice.currentDevice().orientation == .Portrait){
            if(sview != nil){
           // sview.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width,UIScreen.mainScreen().bounds.size.height)
            }
        }else{
            if(sview != nil){
            //sview.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width)
            }
        }
        self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affview.layer.frame.origin.y + self.affview.layer.frame.size.height), self.tableview.layer.frame.size.width,  self.tableview.layer.frame.size.height)
        navigate()
        return [.Portrait]
    }*/
    var fromnotification = NSUserDefaults.standardUserDefaults().integerForKey("fromnotification")
    
    override func viewDidLoad() {
        super.viewDidLoad()
         building_dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary
        if(fromnotification == 1){
            prev.hidden = true
            next.hidden = true
        }else{
            prev.hidden = false
            next.hidden = false
        }
        self.titlefont()
        self.prev.layer.frame.size.width = self.next.layer.frame.size.width
        self.prev.layer.frame.size.height = self.next.layer.frame.size.height
        self.prev.layer.frame.origin.x = 0.98 * (self.next.layer.frame.origin.x - self.prev.layer.frame.size.width)
        tableview.registerNib(UINib.init(nibName: "prerequisitescell2", bundle: nil), forCellReuseIdentifier: "cell2")
        feedstable.registerNib(UINib.init(nibName: "progresscell", bundle: nil), forCellReuseIdentifier: "progresscell")
        vwidth = self.vv.frame.size.width
        vheight = self.vv.frame.size.height
        affirmationtext.adjustsFontSizeToFitWidth = true
        affirmationtitle.adjustsFontSizeToFitWidth = true
        let notificationsarr = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("notifications") as! NSData) as! NSArray
        if(notificationsarr.count > 0 ){
            self.tabbar.items![4].badgeValue = "\(notificationsarr.count)"
        }else{
            self.tabbar.items![4].badgeValue = nil
        }
        backbtn.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12)
        self.spinner.layer.cornerRadius = 5
        self.spinner.hidden = true
        //self.view.userInteractionEnabled = true
        // 3
        // 4
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.assigncontainer.backgroundColor = UIColor.clearColor()
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [ UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
            self.assigncontainer.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        } else {
            self.assigncontainer.backgroundColor = UIColor.blackColor()
        }
        self.assigncontainer.addSubview(picker)
        self.assigncontainer.addSubview(pleasekindly)
        self.assigncontainer.addSubview(assignokbtn)
        self.assigncontainer.addSubview(assignclosebutton)
        assignokbtn.enabled = false

        self.prev.layer.cornerRadius = 4
        self.next.layer.cornerRadius = 4
        self.tabbar.delegate = self
        self.tabbar.selectedItem = self.tabbar.items![1]
        var datakeyed = NSData()
        token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        datakeyed = NSUserDefaults.standardUserDefaults().objectForKey("currentcategory") as! NSData
        currentcategory = NSKeyedUnarchiver.unarchiveObjectWithData(datakeyed)?.mutableCopy() as! NSMutableArray
        currentindex = NSUserDefaults.standardUserDefaults().integerForKey("selected_action")
        NSUserDefaults.standardUserDefaults().synchronize()
        print("aarra", currentcategory)
        currentarr = currentcategory[currentindex] as! [String:AnyObject]
        self.actiontitle.text = currentarr["CreditDescription"] as? String
        self.creditstatus.text = currentarr["CreditStatus"] as? String
        if(self.creditstatus.text == ""){
            self.creditstatus.text = "Not available"
        }
        let c = credentials()
        domain_url = c.domain_url
        let dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary
        actiontitle.text = dict["name"] as? String
        self.navigationItem.title = dict["name"] as? String
        let navItem = UINavigationItem(title: (dict["name"] as? String)!);
        self.nav.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!]
        let doneItem = UIBarButtonItem(title: "< Projects", style: .Plain, target: self, action: #selector(sayHello(_:)))
        navItem.leftBarButtonItem = doneItem;
        nav.setItems([navItem], animated: false);
        dispatch_async(dispatch_get_main_queue(), {
            if((self.currentarr["CreditDescription"] as! String).lowercaseString == "waste"){
                let rect = self.addnew.frame
                self.addnew.setImage(UIImage(named: "addnewdata.png") as UIImage?, forState: UIControlState.Normal)
                self.addnew.frame = rect
                self.addnew.layer.cornerRadius = rect.size.height/2.0
                //self.addnew.titleLabel?.text = "Add new reading"
            }else if((self.currentarr["CreditDescription"] as! String).lowercaseString == "transportation"){
                let rect = self.addnew.frame
                self.addnew.setImage(UIImage(named: "invitation_icon.png") as UIImage?, forState: UIControlState.Normal)
                self.addnew.frame = rect
                self.addnew.layer.cornerRadius = rect.size.height/2.0
                //self.addnew.titleLabel?.text = "Email survey"
            }
            self.ivupload1.tag = 101
            self.ivupload1.addTarget(self, action: #selector(waste.valuechanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
            
            //self.btn.addTarget(self, action: Selector(self.getteammembers(credentials().subscription_key, leedid: 1000136954)), forControlEvents: UIControlEvents.TouchUpInside)
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(datainput.statusupdate(_:)))
            self.creditstatus.userInteractionEnabled = true
            self.creditstatus.addGestureRecognizer(tap)
            //self.navigate()
        })
        
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.shouldRotate = false
        
        // 2. Force the device in landscape mode when the view controller gets loaded
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
    }
    
    override func shouldAutorotate() -> Bool {
        // 3. Lock autorotate
        return false
    }
    
        func statusupdate(sender:UILabel){            
            if(ivupload1.on == false){
                maketoast("Affirmation required before changing the status", type: "error")
            }else{
            self.teammembers = statusarr.mutableCopy() as! NSMutableArray
            dispatch_async(dispatch_get_main_queue(), {
                self.assigncontainer.hidden = false                
                self.statusupdate = 1
                self.pleasekindly.text = "Please kindly select the below status for the action"
                self.assignokbtn.setTitle("Save", forState: UIControlState.Normal)
                self.picker.reloadAllComponents()
            })
            }
        }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    
    
    func valuechanged(sender:UISwitch){
        if(sender.tag == 101){
        dispatch_async(dispatch_get_main_queue(), {
            self.spinner.hidden = false
            //self.view.userInteractionEnabled = false
        })
        affirmationupdate(currentarr["CreditId"] as! String, leedid: leedid, subscription_key: credentials().subscription_key)
        }
    }
    @IBOutlet weak var affirmationtitle: UILabel!
    
    @IBOutlet weak var affirmationtext: UILabel!
    func sayHello(sender: UIBarButtonItem) {
        print("Projects clicked")
        self.performSegueWithIdentifier("gotoactions", sender: nil)
    }
    
    @IBOutlet weak var sview: UIScrollView!
    
    @IBOutlet weak var nav: UINavigationBar!
    
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
        
        let request = NSMutableURLRequest.init(URL: url)
        request.HTTPMethod = "PUT"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var httpbody = String()
            httpbody = String(format: "{\"IvAttchPolicy\": false, \"IvReqFileupload\": %@}",ivupload1.on)
        
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
                        self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affview.layer.frame.origin.y + self.affview.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
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
            } else
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 && httpStatus.statusCode != 201 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                print(data)
                let jsonDictionary : NSDictionary
                do {
                            self.currentarr["IvAttchPolicy"] = ""
                        if(self.ivupload1.on == true){
                            self.currentarr["IvReqFileupload"] = "X"
                        }else{
                            self.currentarr["IvReqFileupload"] = ""
                        }
                    

                    self.currentcategory.replaceObjectAtIndex(NSUserDefaults.standardUserDefaults().integerForKey("selected_action"), withObject: self.currentarr)                    
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                    self.updatebuildingactions(subscription_key, leedid: leedid)
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

    
    func showactivityfeed(leedid: Int, creditID : String, shortcreditID : String){
        let url = NSURL.init(string:String(format: "%@assets/activity/?type=credit&leed_id=%d&credit_short_id=%@",domain_url, leedid, shortcreditID))
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
                        self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affview.layer.frame.origin.y + self.affview.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
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
                        //self.view.userInteractionEnabled = true
                        //self.performSegueWithIdentifier("gotofeeds", sender: nil)
                        if(self.currentfeeds.count > 0){
                            self.feedstable.hidden = false
                            //self.sview.contentSize = CGSizeMake(self.vv.frame.size.width, 1.1 * CGRectGetMaxY(self.feedstable.frame))
                        }else{
                            //self.feedstable.hidden = true
                        }
                        self.feedstable.reloadData()
                        self.spinner.hidden = true
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

    
    func updatebuildingactions(subscription_key:String, leedid: Int){
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
                        self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affview.layer.frame.origin.y + self.affview.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
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
            } else
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                print(data)
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                    let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                    NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "actions_data")
                    self.spinner.hidden = true
                    //self.view.userInteractionEnabled = true
                    NSUserDefaults.standardUserDefaults().synchronize()
                    NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "row")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.spinner.hidden = true
                        //self.view.userInteractionEnabled = true
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

    
    @IBOutlet weak var ivupload1: UISwitch!
    
    func navigate(){
        self.data.removeAll()
        self.data2.removeAll()
        NSUserDefaults.standardUserDefaults().removeObjectForKey("data")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("data2")
        for request in download_requests
        {
            request.invalidateAndCancel()
        }
        self.vv.hidden = true
        dispatch_async(dispatch_get_main_queue(), {
            self.spinner.hidden = true
            //self.view.userInteractionEnabled = true
        })
        currentarr = currentcategory[currentindex] as! [String:AnyObject]
        self.actiontitle.text = currentarr["CreditDescription"] as? String
        self.creditstatus.text = currentarr["CreditStatus"] as? String
        if(self.creditstatus.text == ""){
            self.creditstatus.text = "Not available"
        }
        currentcount = 0
        let c = credentials()
        domain_url = c.domain_url
        let dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary
        assetname.text = dict["name"] as? String
        data.removeAll()
        data2.removeAll()
        meters.removeAllObjects()
        currentmetersdict.removeAll()
        NSUserDefaults.standardUserDefaults().removeObjectForKey("startdate")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("enddate")
        
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
            self.creditstatus.text = String(format: "%@",creditstatus.capitalizedString)
            if(creditstatus == "Ready for Review"){
                creditstatusimg.image = UIImage.init(named: "tick")
            }else{
                creditstatusimg.image = UIImage.init(named: "circle")
            }
        }else{
            creditstatus.text = "Not available"
        }

        
        
        if((self.currentarr["CreditDescription"] as! String).lowercaseString == "human experience"){
            let rect = self.addnew.frame
            self.addnew.setImage(UIImage(named: "invitation_icon.png") as UIImage?, forState: UIControlState.Normal)
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
            if((currentarr["CreditDescription"] as! String).lowercaseString == "energy"){
                shortcredit.image = UIImage.init(named: "energy-border")
            }else if((currentarr["CreditDescription"] as! String).lowercaseString == "water"){
                shortcredit.image = UIImage.init(named: "water-border")
            }else if((currentarr["CreditDescription"] as! String).lowercaseString == "waste"){
                shortcredit.image = UIImage.init(named: "waste-border")
            }
            else if((currentarr["CreditDescription"] as! String).lowercaseString == "transportation"){
                shortcredit.image = UIImage.init(named: "transport-border")
            }else{
                shortcredit.image = UIImage.init(named: "human-border")
            }
        }

        
        if((currentarr["CreditDescription"] as! String).lowercaseString == "water" || (currentarr["CreditDescription"] as! String).lowercaseString == "energy"){
            //self.performSegueWithIdentifier("gotodatainput", sender: nil)
            let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let listofactions = mainstoryboard.instantiateViewControllerWithIdentifier("listofactions")
            let datainput = mainstoryboard.instantiateViewControllerWithIdentifier("datainput")
            let rootViewController = self.navigationController
            var controllers = (rootViewController!.viewControllers)
            controllers.removeAll()
            var v = UIViewController()
            var grid = 0
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
            self.navigationController?.setViewControllers(controllers, animated: false)
        }else if((currentarr["CreditDescription"] as! String).lowercaseString == "waste"){
            let c = credentials()
            //self.feedstable.hidden = true
            dispatch_async(dispatch_get_main_queue(), {
                self.spinner.hidden = false
                //self.view.userInteractionEnabled = true
                self.getallwastedata(c.subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"))
            })

        }
        else if((currentarr["CreditDescription"] as! String).lowercaseString == "transportation"){
            let c = credentials()
            //self.feedstable.hidden = true
            dispatch_async(dispatch_get_main_queue(), {
                self.spinner.hidden = false
                //self.view.userInteractionEnabled = true
                self.getalltransitdata(c.subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"))
            })
        }else if((currentarr["CreditDescription"] as! String).lowercaseString == "human experience"){
            let c = credentials()
            //getalltransitdata(c.subscription_key, leedid: 1000137969)
            print("Human experience")
            //self.feedstable.hidden = true
            dispatch_async(dispatch_get_main_queue(), {
                self.spinner.hidden = false
                //self.view.userInteractionEnabled = true
                self.getmeters(c.subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"))
            })

        }
        else{
            //self.performSegueWithIdentifier("gotodatainput", sender: nil)
            let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let v = mainstoryboard.instantiateViewControllerWithIdentifier("listofassets")
            let listofactions = mainstoryboard.instantiateViewControllerWithIdentifier("listofactions")
            let datainput = mainstoryboard.instantiateViewControllerWithIdentifier("datainput")
            var rootViewController = self.navigationController
            var controllers = (rootViewController!.viewControllers)
            controllers.removeAll()
            let listofassets = mainstoryboard.instantiateViewControllerWithIdentifier("projectslist")
            let dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary
            listofassets.navigationItem.title = dict["name"] as? String
            controllers.append(listofassets)
            controllers.append(listofactions)
            controllers.append(datainput)
            self.navigationController?.setViewControllers(controllers, animated: false)
        }
        
    }
    
    
    func getmeterreadings(subscription_key:String, leedid: Int, actionID: Int){
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/meters/ID:%d/consumption/",domain_url, leedid, actionID))
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
                        self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affview.layer.frame.origin.y + self.affview.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
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
            } else
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                print(data)
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print("Meter readings ",jsonDictionary)
                    let arr = jsonDictionary["results"] as! NSArray
                    let startdatearrforco2 = NSMutableArray()
                    let enddatearrforco2 = NSMutableArray()
                    let startdatearrforvoc = NSMutableArray()
                    let enddatearrforvoc = NSMutableArray()
                    for i in 0..<arr.count{
                        let dict = arr.objectAtIndex(i) as! [String:AnyObject]
                        print("Consumption",dict["meter"]!["fuel_type"]!!["kind"]!)
                        if(dict["meter"]!["fuel_type"]!!["kind"] as! String == "voc"){
                            self.data.append(dict["reading"] as! Int)
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            var tempdict = [String:AnyObject]()
                            var date = dateFormatter.dateFromString(dict["start_date"] as! String)!
                            tempdict["start_date"] = date
                            startdatearrforvoc.addObject(tempdict)
                            date = dateFormatter.dateFromString(dict["end_date"] as! String)! 
                            tempdict["end_date"] = date
                            startdatearrforvoc.addObject(tempdict)
                            enddatearrforvoc.addObject(tempdict)
                            let sortDescriptor = NSSortDescriptor.init(key: "start_date", ascending: true)
                            startdatearrforvoc.sortUsingDescriptors(NSArray.init(object: sortDescriptor) as! [NSSortDescriptor])
                            NSSortDescriptor.init(key: "end_date", ascending: true)
                            enddatearrforvoc.sortUsingDescriptors(NSArray.init(object: sortDescriptor) as! [NSSortDescriptor])
                            print("Date arr ",startdatearrforvoc.firstObject,enddatearrforvoc.lastObject)
                            NSUserDefaults.standardUserDefaults().setObject(startdatearrforvoc.firstObject!["start_date"], forKey: "startdateforvoc")
                            //self.view.userInteractionEnabled = true
                            NSUserDefaults.standardUserDefaults().setObject(enddatearrforvoc.lastObject!["end_date"], forKey: "enddateforvoc")
                            
                        }else if(dict["meter"]!["fuel_type"]!!["kind"] as! String == "co2"){
                            self.data2.append(dict["reading"] as! Int)
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            var tempdict = [String:AnyObject]()
                            var date = dateFormatter.dateFromString(dict["start_date"] as! String)!
                            tempdict["start_date"] = date
                            startdatearrforco2.addObject(tempdict)
                            date = dateFormatter.dateFromString(dict["end_date"] as! String)!
                            tempdict["end_date"] = date
                            startdatearrforco2.addObject(tempdict)
                            enddatearrforco2.addObject(tempdict)
                            let sortDescriptor = NSSortDescriptor.init(key: "start_date", ascending: true)
                            //self.view.userInteractionEnabled = true
                            startdatearrforco2.sortUsingDescriptors(NSArray.init(object: sortDescriptor) as! [NSSortDescriptor])
                            NSSortDescriptor.init(key: "end_date", ascending: true)
                            enddatearrforco2.sortUsingDescriptors(NSArray.init(object: sortDescriptor) as! [NSSortDescriptor])
                            print("Date arr ",startdatearrforco2.firstObject,enddatearrforco2.lastObject)
                            NSUserDefaults.standardUserDefaults().setObject(startdatearrforco2.firstObject!["start_date"], forKey: "startdateforco2")
                            NSUserDefaults.standardUserDefaults().setObject(enddatearrforco2.lastObject!["end_date"], forKey: "enddateforco2")
                        }
                    }
                    if(self.currentcount == self.meters.count){
                        dispatch_async(dispatch_get_main_queue(), {
                        self.gethumansurveydata(NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), subscription_key: credentials().subscription_key)
                        })
                    }
                    
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if(fromnotification == 1){
            self.navigationController?.navigationBar.backItem?.title = "Notifications"
        }else{
        self.navigationController?.navigationBar.backItem?.title = "Credits/Actions"
        }
        navigate()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "gotoreadings"){
            let v = segue.destinationViewController as! wastereadings
            print(self.meters)
            v.meters = self.meters
        }
    }
    
    func gethumansurveydata(leedid: Int, subscription_key: String){
        
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/survey/environment/summarize/",domain_url, leedid))
        print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let s = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(s)
        self.task = s.dataTaskWithRequest(request) { data, response, error in
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
                        self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affview.layer.frame.origin.y + self.affview.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
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
            } else
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                print(data)
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print("Meters are",jsonDictionary)
                    //self.graphPoints = jsonDictionary["results"] as! NSArray
                    self.satisfactionarr = [0,0,0,0,0,0,0,0,0,0]
                    self.dissatisfactionarr = [0,0,0,0,0,0,0,0,0,0]
                    self.currentmetersdict  = jsonDictionary as! [String:AnyObject]
                    
                    self.spinner.hidden = true
                    //self.view.userInteractionEnabled = true
                    self.satisfactionarr = jsonDictionary["satisfaction"] as! [Int]
                    dispatch_async(dispatch_get_main_queue(), {
                        NSUserDefaults.standardUserDefaults().setObject(self.satisfactionarr, forKey: "satisfaction")
                    print(self.satisfactionarr, self.dissatisfactionarr)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.vv.hidden = false
                            //self.spinner.hidden = false
                            self.getsummarizedata(subscription_key, leedid: leedid)
                        })
                        
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tableview.reloadData()
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(UIScreen.mainScreen().bounds.size.width < UIScreen.mainScreen().bounds.size.height){
            if(tableView == feedstable){
                if(indexPath.section == 0){
                    if((self.currentarr["CreditDescription"] as! String).lowercaseString == "waste"){
                    return 0.107 * UIScreen.mainScreen().bounds.size.height;
                    }else{
                    return 0.197 * UIScreen.mainScreen().bounds.size.height;
                    }
                }else{
                    
                    return 0.107 * UIScreen.mainScreen().bounds.size.height;
                }
            }
            return 0.067 * UIScreen.mainScreen().bounds.size.height;
        }
        return 0.067 * UIScreen.mainScreen().bounds.size.width;
    }
    
    func getmeterdata() {
        if(self.meters.count == 0){
                self.maketoast("No data found",type: "error")
            self.spinner.hidden = true
        }
        for i in 0..<self.meters.count {
            let c = credentials()
            let tempdict = meters.objectAtIndex(i) as! [String:AnyObject]
            dispatch_after(
                dispatch_time(
                    DISPATCH_TIME_NOW,
                    Int64(1.5 * Double(NSEC_PER_SEC))
                ),
                dispatch_get_main_queue(),
                {
                    self.currentcount += 1
                    self.getmeterreadings(c.subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), actionID: tempdict["id"] as! Int)
                }
            )
            
            
            // go to something on the main thread with the image like setting to UIImageView
        }
        print("Got date",NSUserDefaults.standardUserDefaults().objectForKey("startdateforco2"),NSUserDefaults.standardUserDefaults().objectForKey("startdateforvoc"),data,data2 )
        
    }
    func getmeters(subscription_key:String, leedid: Int){
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/meters/?kind=humanexperience",domain_url, leedid))
        print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let s = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(s)
        self.task = s.dataTaskWithRequest(request) { data, response, error in
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
                        self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affview.layer.frame.origin.y + self.affview.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
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
            } else
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                print(data)
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print("Meters are",jsonDictionary)
                    //self.graphPoints = jsonDictionary["results"] as! NSArray
                    self.currentmetersdict  = jsonDictionary as! [String:AnyObject]
                    self.meters = jsonDictionary["results"]?.mutableCopy() as! NSMutableArray
                    
                    //self.view.userInteractionEnabled = true
                    dispatch_async(dispatch_get_main_queue(), {
                    self.getmeterdata()
                    })
                    
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
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(tableView == feedstable){
            if(section == 0){
                if((self.currentarr["CreditDescription"] as! String).lowercaseString != "waste"){
                return "SURVEYS(% OF PEOPLE RESPONDED)"
                }
                
            }
            if(currentfeeds.count > 0){
                return "Activity feeds"
            }
            return "No activities present"
        }
        
        return ""
    }
    
    
    func getallwastedata(subscription_key:String, leedid: Int){
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/waste/",domain_url, leedid))
        print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let s = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(s)
        self.task = s.dataTaskWithRequest(request) { data, response, error in
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
                        self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affview.layer.frame.origin.y + self.affview.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
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
            } else
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                dispatch_async(dispatch_get_main_queue(),{
                print(data)
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print("Meters are",jsonDictionary)
                    //self.graphPoints = jsonDictionary["results"] as! NSArray
                    //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"beginDate" ascending:TRUE];
                    //[myMutableArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                        self.cc.frame =  CGRect(x:0,y:0,width:self.vv.frame.size.width, height:self.vv.frame.size.width )
                        self.vv.contentSize = CGSize(width: self.vv.frame.size.width,height:1.2 * (self.cc.frame.size.height+self.tableview.frame.size.height + self.feedstable.frame.size.height))
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
                    self.currentmetersdict  = jsonDictionary as! [String:AnyObject]
                    self.meters = jsonDictionary["results"]?.mutableCopy() as! NSMutableArray
                    //self.view.userInteractionEnabled = true
                    NSUserDefaults.standardUserDefaults().removeObjectForKey("startdate")
                    NSUserDefaults.standardUserDefaults().removeObjectForKey("enddate")
                    if(self.meters.count>0){
                        for i in 0...self.meters.count-1{
                            let item = self.meters.objectAtIndex(i) as! [String:AnyObject]
                            var f1 = 0.0234234
                            var f2 = 0.0
                            f1 = item["waste_diverted"] as! Double
                            f2 = item["waste_generated"] as! Double
                            self.data.append(Int(f1))
                            self.data2.append(Int(f2))
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            var tempdict = [String:AnyObject]()
                            var date = dateFormatter.dateFromString(item["start_date"] as! String)!
                            tempdict["start_date"] = date
                            startdatearr.addObject(tempdict)
                            date = dateFormatter.dateFromString(item["end_date"] as! String)! 
                            tempdict["end_date"] = date
                            startdatearr.addObject(tempdict)
                            enddatearr.addObject(tempdict)
                            let sortDescriptor = NSSortDescriptor.init(key: "start_date", ascending: true)
                            startdatearr.sortUsingDescriptors(NSArray.init(object: sortDescriptor) as! [NSSortDescriptor])
                            NSSortDescriptor.init(key: "end_date", ascending: true)
                            enddatearr.sortUsingDescriptors(NSArray.init(object: sortDescriptor) as! [NSSortDescriptor])
                            print("Date arr ",startdatearr.firstObject,enddatearr.lastObject)
                            NSUserDefaults.standardUserDefaults().setObject(startdatearr.firstObject!["start_date"], forKey: "startdate")
                            NSUserDefaults.standardUserDefaults().setObject(enddatearr.lastObject!["end_date"], forKey: "enddate")
                        }
                    }
                        NSUserDefaults.standardUserDefaults().setObject(self.data, forKey: "data")
                        NSUserDefaults.standardUserDefaults().setObject(self.data2, forKey: "data2")           
                        if(UIDevice.currentDevice().orientation == .Portrait){
                            self.vv.frame =  CGRect(x:self.affview.layer.frame.origin.x,y:self.vv.frame.origin.y,width:self.affview.frame.size.width, height:self.affview.frame.size.width )
                        }else{
                            self.vv.frame =  CGRect(x:self.affview.layer.frame.origin.x,y:self.vv.frame.origin.y,width:self.affview.frame.size.width, height:self.affview.frame.size.width )
                        }
                        let view = chartview()
                        self.cc.frame =  CGRect(x:0,y:0,width:self.vv.frame.size.width, height:self.vv.frame.size.width )
                        self.vv.contentSize = CGSize(width: self.vv.frame.size.width,height:1.2 * (self.cc.frame.size.height+self.tableview.frame.size.height + self.feedstable.frame.size.height))
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
                        
                        view.frame = CGRect(x:0,y:0,width:self.cc.frame.width, height: self.cc.frame.size.width)
                        view.tag = 23
                        self.cc.addSubview(view)
                        self.vv.hidden = false
                        if((self.currentarr["CreditDescription"] as! String).lowercaseString == "waste"){
                            let rect = self.addnew.frame
                            self.addnew.setImage(self.imageWithImage(UIImage(named:"addnewdata.png")!, scaledToSize: CGSize(width:70, height: 70)), forState: UIControlState.Normal)
                            self.addnew.frame = rect
                            self.addnew.layer.cornerRadius = rect.size.height/2.0
                            //self.addnew.titleLabel?.text = "Add new reading"
                        }else if((self.currentarr["CreditDescription"] as! String).lowercaseString == "transportation"){
                            let rect = self.addnew.frame
                            self.addnew.setImage(self.imageWithImage(UIImage(named:"invitation_icon.png")!, scaledToSize: CGSize(width:70, height: 70)), forState: UIControlState.Normal)
                            self.addnew.frame = rect
                            self.addnew.layer.cornerRadius = rect.size.height/2.0
                            //self.addnew.titleLabel?.text = "Email survey"
                        }
                        
                        if(self.meters.count == 0){
                            self.maketoast("No data found",type: "error")
                        }
                self.feedstable.frame = CGRect(x:0,y:view.frame.origin.y+view.frame.size.height,width:self.feedstable.frame.width, height: self.feedstable.layer.frame.size.height)
                        print(self.feedstable.frame.size.height,self.sview.contentSize.height)
                        self.showactivityfeed(NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), creditID: self.currentarr["CreditId"] as! String, shortcreditID: self.currentarr["CreditShortId"] as! String)
                        return
                    // self.buildingactions(subscription_key, leedid: leedid)
                    
                } catch {
                    print(error)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                    })
            }
            
        }
        task.resume()
    }
    
    
    
    
    
    @IBOutlet weak var backbtn: UIButton!
    func showalert(message:String, title:String, action:String){
        
        //let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        //let callActionHandler = { (action:UIAlertAction!) -> Void in
        dispatch_async(dispatch_get_main_queue(), {
            self.view.userInteractionEnabled = true
            self.spinner.hidden = true
            self.maketoast(message, type: "error")
            //self.navigationController?.popViewControllerAnimated(true)
        })
        
        //        }
        //      let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        //    alertController.addAction(defaultAction)
        
        //presentViewController(alertController, animated: true, completion: nil)
        
        
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(tableView == tableview){
            let cell = tableView.dequeueReusableCellWithIdentifier("cell2") as! prerequisitescell2
            cell.fileuploaded.hidden = true
            cell.uploadbutton.hidden = true
            cell.uploadanewfile.hidden = true
            cell.assignedto.hidden = false
            cell.editbutton.hidden = false
            cell.editbutton.addTarget(self, action: #selector(edited), forControlEvents: UIControlEvents.TouchUpInside)
            var text = ""
            cell.assignedto.hidden = false
            if let assignedto = currentarr["PersonAssigned"] as? String{
                var temp = assignedto
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
            return cell
        }else{
        
            if(indexPath.section == 0){
                if((self.currentarr["CreditDescription"] as! String).lowercaseString != "waste"){
                var cell = tableView.dequeueReusableCellWithIdentifier("progresscell")! as! progresscell
                var occupancy = 1
                if let occ = building_dict["occupancy"] as? Int{
                    occupancy = occ
                }
                    
                    if((self.currentarr["CreditDescription"] as! String).lowercaseString == "transportation"){
                        cell.vv.strokecolor = UIColor.lightGrayColor()
                    }else{
                        cell.vv.strokecolor = UIColor.init(red: 0.92, green: 0.609, blue: 0.236, alpha: 1)
                    }
                if let response = summarized_data["responses"] as? Int{
                cell.vv.strokevalue = Double(response)/Double(occupancy)
                    cell.percentagelbl.text = String(format: "%.2f%%",100 * Double(response)/Double(occupancy))
                    if(occupancy < 500){
                        cell.contextlbl.text = "A response rate of 25.00% for your project, will generate a score"
                    }else{
                        cell.contextlbl.text = "A response rate of \((0.25/sqrt(Double(occupancy)/500.0)) * 100) for your project, will generate a score"
                    }
                }
                
                cell.vv.addUntitled1Animation()
                return cell
                }
            }
        
        var cell = tableView.dequeueReusableCellWithIdentifier("feedcell")! as! UITableViewCell
        
        var dict = currentfeeds.objectAtIndex(indexPath.row) as! [String:AnyObject]
        cell.textLabel?.text = dict["verb"] as! String
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        var str = dict["timestamp"] as! String
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        var date = formatter.dateFromString(str)! as! NSDate
        formatter.dateFormat = "MMM dd, yyyy at HH:MM a"
        str = formatter.stringFromDate(date)
        cell.detailTextLabel?.numberOfLines = 5
        cell.textLabel?.numberOfLines = 5
        cell.detailTextLabel?.text = "on \(str)"
        return cell
            
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(tableView == feedstable){
            if((self.currentarr["CreditDescription"] as! String).lowercaseString == "waste"){
             return 1
            }
         return 2
        }
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == feedstable){
            if(section == 0){
                if((self.currentarr["CreditDescription"] as! String).lowercaseString != "waste"){
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
    
    func getalltransitdata(subscription_key:String, leedid: Int){
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/survey/transit/summarize/",domain_url, leedid))
        print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let s = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(s)
        self.task = s.dataTaskWithRequest(request) { data, response, error in
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
                        self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affview.layer.frame.origin.y + self.affview.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
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
            } else
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                print(data)
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print("Meters are",jsonDictionary)
                    //self.graphPoints = jsonDictionary["results"] as! NSArray
                    
                        dispatch_async(dispatch_get_main_queue(),{
                            var arr = [0,0,0,0,0,0,0,0]
                            var modes = jsonDictionary["modes"] as! NSDictionary
                            
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
                            NSUserDefaults.standardUserDefaults().setObject(arr, forKey: "data")
                            NSUserDefaults.standardUserDefaults().setObject(d, forKey: "data2")
                            
                        let view = chartview()
                        if(UIDevice.currentDevice().orientation == .Portrait){
                            self.vv.frame =  CGRect(x:self.affview.layer.frame.origin.x,y:self.vv.frame.origin.y,width:self.affview.frame.size.width, height:self.affview.frame.size.width )
                        }else{
                            self.vv.frame =  CGRect(x:self.affview.layer.frame.origin.x,y:self.vv.frame.origin.y,width:self.affview.frame.size.width, height:self.affview.frame.size.width )
                        }
                        self.vv.contentSize = CGSize(width: self.vv.frame.size.width,height:1.2 * (self.cc.frame.size.height+self.tableview.frame.size.height + self.feedstable.frame.size.height ))
                        self.cc.frame =  CGRect(x:0,y:0,width:self.vv.frame.size.width, height:self.vv.frame.size.width)
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
                        view.frame = CGRect(x:0,y:0,width:self.cc.frame.width, height: self.cc.frame.size.width)
                        view.tag = 23
                        self.cc.addSubview(view)
                        self.vv.hidden = false
                        if((self.currentarr["CreditDescription"] as! String).lowercaseString == "waste"){
                            let rect = self.addnew.frame
                            self.addnew.setImage(UIImage(named: "addnewdata.png") as UIImage?, forState: UIControlState.Normal)
                            self.addnew.frame = rect
                            self.addnew.layer.cornerRadius = rect.size.height/2.0
                            //self.addnew.titleLabel?.text = "Add new reading"
                        }else if((self.currentarr["CreditDescription"] as! String).lowercaseString == "transportation"){
                            let rect = self.addnew.frame
                            self.addnew.setImage(UIImage(named: "invitation_icon.png") as UIImage?, forState: UIControlState.Normal)
                            self.addnew.frame = rect
                            self.addnew.layer.cornerRadius = rect.size.height/2.0
                            //self.addnew.titleLabel?.text = "Email survey"
                        }
                    
                    self.feedstable.frame = CGRect(x:0,y:view.frame.origin.y+view.frame.size.height,width:self.feedstable.frame.width, height: self.feedstable.frame.size.height)
                    self.getsummarizedata(subscription_key, leedid: leedid)
                    })

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
    
    @IBOutlet weak var addnew: UIButton!
    @IBOutlet weak var prev: UIButton!
    
    @IBOutlet weak var next: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func gotonext(sender: AnyObject) {
        if(currentindex<currentcategory.count-1){
            /*if(task.currentRequest != nil){
             if (task.state == NSURLSessionTaskState.Running) {
             task.cancel()
             }
             }*/
            currentindex = currentindex+1
            NSUserDefaults.standardUserDefaults().setInteger(currentindex, forKey: "selected_action")
            currentarr = currentcategory[currentindex] as! [String:AnyObject]
            if((currentarr["CreditDescription"] as! String).lowercaseString == "human experience" || (currentarr["CreditDescription"] as! String).lowercaseString == "transportation" || (currentarr["CreditDescription"] as! String).lowercaseString == "waste"){
                if((self.currentarr["CreditDescription"] as! String).lowercaseString == "waste"){
                    let rect = self.addnew.frame
                    self.addnew.setImage(UIImage(named: "addnewdata.png") as UIImage?, forState: UIControlState.Normal)
                    self.addnew.frame = rect
                    self.addnew.layer.cornerRadius = rect.size.height/2.0
                    //self.addnew.titleLabel?.text = "Add new reading"
                }else if((self.currentarr["CreditDescription"] as! String).lowercaseString == "transportation" || (self.currentarr["CreditDescription"] as! String).lowercaseString == "human experience"){
                    let rect = self.addnew.frame
                    self.addnew.setImage(UIImage(named: "invitation_icon.png") as UIImage?, forState: UIControlState.Normal)
                    self.addnew.frame = rect
                    self.addnew.layer.cornerRadius = rect.size.height/2.0
                    //self.addnew.titleLabel?.text = "Email survey"
                }
                navigate()
            }else{
                //self.performSegueWithIdentifier("gotodatainput", sender: nil)
                let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                let v = mainstoryboard.instantiateViewControllerWithIdentifier("listofassets")
                let listofactions = mainstoryboard.instantiateViewControllerWithIdentifier("listofactions")
                var datainput = mainstoryboard.instantiateViewControllerWithIdentifier("datainput")
                if(currentarr["CreditcategoryDescrption"] as! String == "Innovation"){
                    datainput = mainstoryboard.instantiateViewControllerWithIdentifier("prerequisites")
                }else{
                    datainput = mainstoryboard.instantiateViewControllerWithIdentifier("datainput")
                }
                
                var rootViewController = self.navigationController
                var controllers = (rootViewController!.viewControllers)
                controllers.removeAll()
                var listofassets = mainstoryboard.instantiateViewControllerWithIdentifier("projectslist")
                var grid = 0
                if(grid == 1){
                    listofassets = mainstoryboard.instantiateViewControllerWithIdentifier("gridvc")
                }else{
                    listofassets = mainstoryboard.instantiateViewControllerWithIdentifier("projectslist")
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
    
    @IBAction func gotoprevious(sender: AnyObject) {
        if(currentindex>0){
            /*if(task.currentRequest != nil){
             if (task.state == NSURLSessionTaskState.Running) {
             task.cancel()
             }
             }*/
            currentindex = currentindex-1
            NSUserDefaults.standardUserDefaults().setInteger(currentindex, forKey: "selected_action")
            currentarr = currentcategory[currentindex] as! [String:AnyObject]
            if((currentarr["CreditDescription"] as! String).lowercaseString == "human experience" || (currentarr["CreditDescription"] as! String).lowercaseString == "transportation" || (currentarr["CreditDescription"] as! String).lowercaseString == "waste"){
                if((self.currentarr["CreditDescription"] as! String).lowercaseString == "waste"){
                    let rect = self.addnew.frame
                    self.addnew.setImage(UIImage(named: "addnewdata.png") as UIImage?, forState: UIControlState.Normal)
                    self.addnew.frame = rect
                    self.addnew.layer.cornerRadius = rect.size.height/2.0
                    //self.addnew.titleLabel?.text = "Add new reading"
                }else if((self.currentarr["CreditDescription"] as! String).lowercaseString == "transportation" || (self.currentarr["CreditDescription"] as! String).lowercaseString == "human experience"){
                    let rect = self.addnew.frame
                    self.addnew.setImage(UIImage(named: "invitation_icon.png") as UIImage?, forState: UIControlState.Normal)
                    self.addnew.frame = rect
                    self.addnew.layer.cornerRadius = rect.size.height/2.0
                    //self.addnew.titleLabel?.text = "Email survey"
                }
                navigate()
            }else{
                //self.performSegueWithIdentifier("gotodatainput", sender: nil)
                let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                let v = mainstoryboard.instantiateViewControllerWithIdentifier("listofassets")
                let listofactions = mainstoryboard.instantiateViewControllerWithIdentifier("listofactions")
                let datainput = mainstoryboard.instantiateViewControllerWithIdentifier("datainput")
                var rootViewController = self.navigationController
                var controllers = (rootViewController!.viewControllers)
                controllers.removeAll()
                var grid = 0
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
                //self.navigationController!.hidesBarsOnTap = false;
                //self.navigationController!.hidesBarsOnSwipe = false;
                //self.navigationController!.hidesBarsWhenVerticallyCompact = false;
                self.navigationController?.setViewControllers(controllers, animated: false)
            }
        }
    }
    func checkcredit_type(tempdict:[String:AnyObject]) -> String {
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
    
    
    @IBAction func assignclose(sender: AnyObject) {
        self.assigncontainer.hidden = true
        
    }
    
    func assignnewmember(subscription_key:String, leedid: Int, actionID: String, email:String,firstname: String, lastname:String){
        //https://api.usgbc.org/dev/leed/assets/LEED:{leed_id}/actions/ID:{action_id}/teams/
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@/teams/",domain_url, leedid, actionID))
        print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let httpbody = String(format: "{\"emails\":\"%@\"}",email)
        request.HTTPBody = httpbody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let s = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(s)
        self.task = s.dataTaskWithRequest(request) { data, response, error in
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
                        self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affview.layer.frame.origin.y + self.affview.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
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
            } else
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                print(data)
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.currentarr["PersonAssigned"] = String(format: "%@ %@",firstname,lastname)
                        self.assigncontainer.hidden = true                        
                        //self.view.userInteractionEnabled = true
                        self.buildingactions(subscription_key, leedid: leedid)
                        
                    })
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
    
    func getsummarizedata(subscription_key:String, leedid: Int){
        var url = NSURL()
        if(actiontitle.text?.lowercaseString == "transportation"){
        url = NSURL.init(string: String(format: "%@assets/LEED:%d/survey/transit/summarize/",domain_url,leedid))!
        }else{
            url = NSURL.init(string: String(format: "%@assets/LEED:%d/survey/environment/summarize/",domain_url,leedid))!
        }
        print(url.absoluteURL)
        let request = NSMutableURLRequest.init(URL: url)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let s = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(s)
        self.task = s.dataTaskWithRequest(request) { data, response, error in
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
                        self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affview.layer.frame.origin.y + self.affview.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
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
            } else
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }else{
                    print(data)
                    let jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        self.summarized_data = jsonDictionary
                        print(jsonDictionary)
                        dispatch_async(dispatch_get_main_queue(), {
                            if(self.actiontitle.text?.lowercaseString != "transportation"){
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
                                NSUserDefaults.standardUserDefaults().setObject(self.dissatisfactionarr, forKey: "dissatisfaction")
                                NSUserDefaults.standardUserDefaults().setObject(self.data, forKey: "voc")
                                NSUserDefaults.standardUserDefaults().setObject(self.data2, forKey: "co2")
                                    if(UIDevice.currentDevice().orientation == .Portrait){
                                        self.vv.frame =  CGRect(x:self.affview.layer.frame.origin.x,y:self.vv.frame.origin.y,width:self.affview.frame.size.width, height:self.affview.frame.size.width )
                                    }else{
                                        self.vv.frame =  CGRect(x:self.affview.layer.frame.origin.x,y:self.vv.frame.origin.y,width:self.affview.frame.size.width, height:self.affview.frame.size.width )
                                    }
                                    let view = satisfaction()
                                    
                                    self.vv.contentSize = CGSize(width: self.vv.frame.size.width,height:1.1 * (self.cc.frame.size.height+self.cc.frame.size.height+self.cc.frame.size.height+self.cc.frame.size.height+self.tableview.frame.size.height + self.feedstable.frame.size.height))
                                    self.cc.frame =  CGRect(x:0,y:0,width:self.vv.frame.size.width, height:self.vv.frame.size.width )
                                    
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
                                    self.cc.addSubview(view3)
                                    self.feedstable.frame = CGRect(x:0,y:view3.frame.origin.y+view3.frame.size.height,width:self.feedstable.frame.width, height: self.feedstable.frame.size.height)
                                
                                }

                            self.showactivityfeed(NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), creditID: self.currentarr["CreditId"] as! String, shortcreditID: self.currentarr["CreditShortId"] as! String)
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
    
    var summarized_data = NSDictionary()
    
    
    func buildingactions(subscription_key:String, leedid: Int){
        let url = NSURL.init(string: String(format: "%@assets/LEED:%d/actions/",domain_url,leedid))
        print(url?.absoluteURL)
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let s = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(s)
        self.task = s.dataTaskWithRequest(request) { data, response, error in
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
                        self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affview.layer.frame.origin.y + self.affview.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
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
            } else
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                print(data)
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                    dispatch_async(dispatch_get_main_queue(), {
                        let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                        NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "actions_data")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        self.spinner.hidden = true
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
    
    @IBAction func closetheassigneecontainer(sender: AnyObject) {
        self.assigncontainer.hidden = true
    }
    
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return teammembers.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(statusupdate == 1){
            return teammembers[row] as? String
        }
        return teammembers[row]["Useralias"] as! String
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        assignokbtn.enabled = true
        if(statusupdate == 0){
            print(teammembers[row]["Useralias"])
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
        let s = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(s)
        self.task = s.dataTaskWithRequest(request) { data, response, error in
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
                        self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affview.layer.frame.origin.y + self.affview.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
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
            } else
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                print(data)
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                    let team_membersarray = jsonDictionary["EtTeamMembers"] as! NSArray
                    self.teammembers = team_membersarray.mutableCopy() as! NSMutableArray
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


    @IBAction func editassignee(sender: AnyObject) {


    }
    @IBOutlet weak var tableview: UITableView!
    
    @IBAction func assignthemember(sender: AnyObject) {
        if(statusupdate == 1){
            //self.view.userInteractionEnabled = false
            self.spinner.hidden = false
            savestatusupdate(currentarr["CreditId"] as! String, subscription_key: credentials().subscription_key)
            
        }else{
            //self.view.userInteractionEnabled = false
            self.spinner.hidden = false
            assignnewmember(credentials().subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), actionID: currentarr["CreditId"] as! String, email:teammembers[picker.selectedRowInComponent(0)]["Useralias"] as! String,firstname:teammembers[picker.selectedRowInComponent(0)]["Firstname"] as! String,lastname: teammembers[picker.selectedRowInComponent(0)]["Lastname"] as! String)
        }

    }
    
    func savestatusupdate(actionID:String, subscription_key:String){
        //
        var url = NSURL()
        var s = String(format:"%d",leedid)
        if(actionID.containsString(s)){
            url = NSURL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@/",domain_url, leedid, actionID))!
        }
        else{
            url = NSURL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@-%d/",domain_url, leedid, actionID,leedid))!
        }
        print(url.absoluteString)
        
        let request = NSMutableURLRequest.init(URL: url)
        request.HTTPMethod = "PUT"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var httpbody = String()
        var string = self.statusarr[self.picker.selectedRowInComponent(0)] as! String
        if(string == "Ready for review"){
            httpbody = String(format: "{\"is_readyForReview\": %@}",true)
        }else{
            httpbody = String(format: "{\"is_readyForReview\": %@}",false)
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
                        self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affview.layer.frame.origin.y + self.affview.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
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
    
}

