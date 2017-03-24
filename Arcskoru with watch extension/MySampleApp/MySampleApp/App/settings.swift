//
//  settings.swift
//  LEEDOn
//
//  Created by Group X on 09/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class settings: UIViewController,UITableViewDelegate,UITableViewDataSource,UITabBarDelegate {
    @IBOutlet weak var tableview: UITableView!
    var leedid = NSUserDefaults.standardUserDefaults().integerForKey("leed_id")
    var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
    
    @IBOutlet weak var tabbar: UITabBar!
    
    @IBOutlet weak var assetname: UILabel!
    
    @IBOutlet weak var spinner: UIView!
    
    var sectiontitles = NSArray()
    var valuearr = NSArray()
    var dict = NSDictionary()
    var tempdict = NSMutableDictionary()
    var email_subscription = false 
    var tempsubscrptiondata = NSMutableDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
        let notificationsarr = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("notifications") as! NSData) as! NSArray
        if(notificationsarr.count > 0 ){
            self.tabbar.items![4].badgeValue = "\(notificationsarr.count)"
        }else{
            self.tabbar.items![4].badgeValue = nil
        }
        self.spinner.layer.cornerRadius = 5
        self.spinner.hidden = true
        self.view.userInteractionEnabled = true
        valuearr = ["Lobby survey","Make LEED score public", "Receive email only when your score changes."]
        sectiontitles = ["Conduct a Lobby survey to gather Human experience data from people in your building","Selecting 'Yes' will show the plaque animation on the LEED Dynamic Plaque app. By selecting 'No,' the plaque animation will not be visible on the LEED Dynamic Plaque app.","Get a detailed report on every score change."]
        self.tableview.registerNib(UINib.init(nibName: "settingscell", bundle: nil), forCellReuseIdentifier: "cell")
        
        dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary
        assetname.text = dict["name"] as? String
        self.navigationItem.title = dict["name"] as? String
        tempdict = dict.mutableCopy() as! NSMutableDictionary
        dispatch_async(dispatch_get_main_queue(), {
            self.view.userInteractionEnabled = false
            self.spinner.hidden = false
            self.updateproject()
            self.getemailsubscriptionstatus()
        })        
        self.tabbar.selectedItem = self.tabbar.items![3]
        self.view.bringSubviewToFront(nav)
        let navItem = UINavigationItem(title: (dict["name"] as? String)!);
        self.nav.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!]
        let doneItem = UIBarButtonItem(title: "< Manage", style: .Plain, target: self, action: #selector(sayHello(_:)))
        navItem.leftBarButtonItem = doneItem;
        nav.setItems([navItem], animated: false);
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        self.navigationController?.navigationBar.backItem?.title = "Manage"
    }
    
    func sayHello(sender: UIBarButtonItem) {
        print("Projects clicked")
        NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"manage"])
    }
    
    
    
    @IBOutlet weak var nav: UINavigationBar!
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
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Project settings"
    }
    
    func showalert(message:String, title:String, action:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                self.spinner.hidden = true
                self.view.userInteractionEnabled = true
                self.navigationController?.popViewControllerAnimated(true)
                
            })
            
        }
        let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
        
    }

    
    func getemailsubscriptionstatus(){
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/subscriptions/",credentials().domain_url,leedid))
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
            }
            else if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.view.userInteractionEnabled = true
                    self.spinner.hidden = true
                })
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                })
            }else{
                print(data)
                
                do {
                        var jsonDictionary : NSDictionary
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    self.tempsubscrptiondata = jsonDictionary.mutableCopy() as! NSMutableDictionary
                    print(self.tempsubscrptiondata)
                    if(jsonDictionary["score_change_notification"] is Bool){
                        self.email_subscription = jsonDictionary["score_change_notification"] as! Bool
                    }else if(jsonDictionary["score_change_notification"] is NSNull){
                        self.email_subscription = false
                    }else if(jsonDictionary["score_change_notification"] is Int){
                        self.email_subscription = Bool(jsonDictionary["score_change_notification"] as! NSNumber)
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        self.view.userInteractionEnabled = true
                        self.spinner.hidden = true
                    })
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableview.reloadData()
                    })
                    
                    
                } catch {
                    print(error)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.view.userInteractionEnabled = true
                        self.spinner.hidden = true
                    })
                }
            }
            
        }
        task.resume()

    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tableview.reloadData()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(UIScreen.mainScreen().bounds.size.width < UIScreen.mainScreen().bounds.size.height){
            return 0.081 * UIScreen.mainScreen().bounds.size.height;
        }
        return 0.081 * UIScreen.mainScreen().bounds.size.width;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! settingscell
        cell.lbl.text = valuearr.objectAtIndex(indexPath.row) as? String
        cell.enableswitch.tag = indexPath.row
        cell.enableswitch.addTarget(self, action: #selector(settings.switchused(_:)), forControlEvents: UIControlEvents.ValueChanged)
        if(indexPath.row == 0){
        cell.enableswitch.on = tempdict["lobby_survey_status"] as! Bool
        }else if(indexPath.row == 1){
        cell.enableswitch.on = tempdict["leed_score_public"] as! Bool
        }else{
        cell.enableswitch.on = email_subscription
        }
        return cell
    }
    
    func switchused(sender:UISwitch){
        _ = sender
        let indexPath = NSIndexPath.init(forRow: sender.tag, inSection: 0)
        let cell = tableview.cellForRowAtIndexPath(indexPath) as! settingscell
        if(indexPath.row == 0){
            dispatch_async(dispatch_get_main_queue(), {
                self.spinner.hidden = false
            })
                tempdict.setValue(cell.enableswitch.on, forKey: "lobby_survey_status")
            saveproject()
        }else if(indexPath.row == 1){
            dispatch_async(dispatch_get_main_queue(), {
                self.spinner.hidden = false
            })
                tempdict.setValue(cell.enableswitch.on, forKey: "leed_score_public")
            saveproject()
        }else{
            dispatch_async(dispatch_get_main_queue(), {
            self.spinner.hidden = false              
            })
            
            if(cell.enableswitch.on == true){
            email_subscription = true
            }else{
                email_subscription = false
            }
            if(email_subscription == false){
            }else{
                tempsubscrptiondata.setValue("email", forKey: "stype")
            }
            tempsubscrptiondata.setValue(email_subscription, forKey: "score_change_notification")
            print(tempsubscrptiondata)
            updatesubscription()
        }        
        
    }
    
    
    
    func saveproject(){
        let payload = NSMutableString()
        payload.appendString("{")
        for (key, value) in tempdict {
            if(value is String){
                payload.appendString("\"\(key)\": \"\(value)\",")
            }else if(value is Int){
                payload.appendString("\"\(key)\": \(value),")
            }
        }
        var str = payload as String
        payload.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
        payload.appendString("}")
        str = payload as String
        print(str)
        
        
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/?recompute_score=1",credentials().domain_url, leedid))
        print(url?.absoluteURL)
        let subscription_key = credentials().subscription_key
        let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "PUT"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let httpbody = str
        request.HTTPBody = httpbody.dataUsingEncoding(NSUTF8StringEncoding)
        self.view.userInteractionEnabled = false
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                self.view.userInteractionEnabled = true
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
                self.view.userInteractionEnabled = true
            }else{
                print(data)
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                    //self.tableview.reloadData()
                    // self.buildingactions(subscription_key, leedid: leedid)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.view.userInteractionEnabled = true
                        self.updateproject()
                        
                    })
                } catch {
                    print(error)
                }
            }
            
        }
        task.resume()
        
    }
    
    
    func updatesubscription(){
        
        
        let payload = NSMutableString()
        //{"destination":"testuser@gmail.com","score_change_notification":false,"stype":"email"}
        
        
        
        payload.appendString("{")
        /*for (key, value) in tempsubscrptiondata {
         if(value is String){
         payload.appendString("\"\(key)\": \"\(value)\",")
         }else if(value is Int){
         payload.appendString("\"\(key)\": \(value),")
         }
         }*/
        
        
        //payload.appendString(String(format:"\"destination\": \"%@\",",tempsubscrptiondata["destination"] as! String))
        payload.appendString(String(format:"\"destination\": \"testuser@gmail.com\","))
        payload.appendString("\"score_change_notification\": \"\(tempsubscrptiondata["score_change_notification"] as! Bool)\",")
        payload.appendString("\"stype\": \"email\"}")
        
        
        var str = payload as String
        str = payload as String
        print(str)
        
        
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/subscriptions/",credentials().domain_url, leedid))
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
        self.view.userInteractionEnabled = false
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                self.view.userInteractionEnabled = true
                return
            }
            
            let httpStatus = response as? NSHTTPURLResponse
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401 {           // check for http errors
                dispatch_async(dispatch_get_main_queue(), {
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                })
            }
            else if (httpStatus!.statusCode != 200 && httpStatus!.statusCode != 201) {
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus!.statusCode)")
                print("response = \(response)")
                do{
                    let jsonDictionary : NSDictionary
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                }catch{}
                self.view.userInteractionEnabled = true
                dispatch_async(dispatch_get_main_queue(), {
                    self.view.userInteractionEnabled = true
                    self.tableview.reloadData()
                })
            }else{
                print(data)
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                    //self.tableview.reloadData()
                    // self.buildingactions(subscription_key, leedid: leedid)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableview.reloadData()
                        self.view.userInteractionEnabled = true
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
        self.view.userInteractionEnabled = false
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                self.view.userInteractionEnabled = true
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
            }else{
                print(data)
                self.view.userInteractionEnabled = true
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                    let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                    NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "building_details")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "row")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableview.reloadData()
                        self.spinner.hidden = true
                    })
                    //self.tableview.reloadData()
                    // self.buildingactions(subscription_key, leedid: leedid)
                } catch {
                    print(error)
                }
            }
            
        }
        task.resume()
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*UILabel *lblSectionName = [[UILabel alloc] init];
    lblSectionName.text = [self.rowNames objectAtIndex:section];
    lblSectionName.textColor = [UIColor lightGrayColor];
    lblSectionName.numberOfLines = 0;
    lblSectionName.lineBreakMode = NSLineBreakByWordWrapping;
    lblSectionName.backgroundColor = [UIColor grayColor];
    
    [lblSectionName sizeToFit];*/
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
