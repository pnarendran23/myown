//
//  certifications.swift
//  LEEDOn
//
//  Created by Group X on 09/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class certifications: UIViewController,UITableViewDataSource,UITableViewDelegate, UITabBarDelegate {
var leedid = NSUserDefaults.standardUserDefaults().integerForKey("leed_id")
    var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
    var certarr = NSArray()
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var tabbar: UITabBar!
    
    @IBOutlet weak var spinner: UIView!
    
    @IBOutlet weak var assetname: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
        self.spinner.layer.cornerRadius = 5
        backbtn.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12)
        let notificationsarr = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("notifications") as! NSData) as! NSArray
        if(notificationsarr.count > 0 ){
            self.tabbar.items![4].badgeValue = "\(notificationsarr.count)"
        }else{
            self.tabbar.items![4].badgeValue = nil
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.view.userInteractionEnabled = false
            self.spinner.hidden = false
        })
        let dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary
        print(dict)
        assetname.text = dict["name"] as? String
        self.view.bringSubviewToFront(nav)
        let navItem = UINavigationItem(title: (dict["name"] as? String)!);
        self.nav.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!]
        let doneItem = UIBarButtonItem(title: "< Manage", style: .Plain, target: self, action: #selector(sayHello(_:)))
        navItem.leftBarButtonItem = doneItem;
        nav.setItems([navItem], animated: false);
        self.getcertifications()
        self.tabbar.selectedItem = self.tabbar.items![3]
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        var buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        self.navigationItem.title = buildingdetails["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = "Manage"
    }
    
    override func viewDidDisappear(animated: Bool) {

    }
    
    override func viewWillDisappear(animated: Bool) {
        var buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        self.navigationItem.title = buildingdetails["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as? String
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "Certifications"
        }        
        return ""
    }
    
    func sayHello(sender: UIBarButtonItem) {
        print("Projects clicked")
        NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"manage"])
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
    @IBOutlet weak var backbtn: UIButton!
    @IBOutlet weak var nav: UINavigationBar!
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if(item.title == "Score"){
            NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"plaque"])
        }else if(item.title == "Analytics"){
            NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"beforeanalytics"])
        }else if(item.title == "Manage"){
            NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"manage"])
        }else if(item.title == "More"){
            NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"more"])
        }else if(item.title == "Credits/Actions"){
            NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"listofactions"])
        }
    }
    
    func getcertifications(){
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/certifications/",credentials().domain_url,leedid))
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
                    if(try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) is NSDictionary){
                        var jsonDictionary : NSDictionary
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        let temp = NSArray.init(object: jsonDictionary)
                        self.certarr = temp
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                            self.view.userInteractionEnabled = true
                            self.spinner.hidden = true
                    self.tableview.reloadData()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return certarr.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let dict = (certarr.objectAtIndex(indexPath.section) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        if(indexPath.row == 0){
        cell.textLabel?.text = "Certification"
       cell.detailTextLabel?.text = dict["ERatingSys"] as? String
        }else if(indexPath.row == 1){
            cell.textLabel?.text = "Level"
            cell.detailTextLabel?.text = dict["EPrecertLevel"] as? String
        }else if(indexPath.row == 2){
            cell.textLabel?.text = "Points"
            cell.detailTextLabel?.text = dict["ECertPoints"] as? String
        }else if(indexPath.row == 3){
            cell.textLabel?.text = "Certified Date"
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            if(dict["EPrecertAcptdate"] != nil){
            let date = formatter.dateFromString(dict["EPrecertAcptdate"] as! String)
            if(date == nil){
            cell.detailTextLabel?.text = "Not Certified"
            }else{
                cell.detailTextLabel?.text = dict["EPrecertAcptdate"] as? String
            }
            }else{
                cell.detailTextLabel?.text = "Not Certified"
            }
        }
        
        
        return cell
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
