//
//  listofassets.swift
//  MySampleApp
//
//  Created by Group X on 03/11/16.
//
//

import Foundation
import UIKit

class listofassets: UIViewController, UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
    var assets = NSMutableDictionary()
    var token = ""
    var tobefiltered = NSMutableArray()
    var listobuildings = NSMutableArray()
    var domain_url = ""
    var page = 2
    var task = NSURLSessionTask()
    var timer = NSTimer()
    var isloading = false
    var tempfilter = NSMutableArray()
    var filterarr = ["Buildings","Cities","Communities","My projects","All"]
    @IBOutlet weak var spinner: UIView!
    @IBOutlet weak var allprojectslbl: UILabel!
    
    @IBOutlet weak var segctrl: UISegmentedControl!
    
    
    @IBOutlet weak var globebtn: UIButton!
    @IBOutlet weak var logout: UIButton!
    var countries = [String:AnyObject]()
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    var buildingarr = NSMutableArray()
    var fullstatename = ""
    var fullcountryname = ""
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return .LightContent
        
    }
    
    var addbuttonsize = 0.0 as! CGFloat
    
    func viewswitch(sender: UISegmentedControl){
        if(sender.tag == 123){
            if(sender.selectedSegmentIndex == 1){
                customize(UIButton())
            }
        }
    }
    @IBOutlet weak var addbutton: UIButton!
    
    
    func adjustit(){
        var segmentButton = self.view.viewWithTag(123) as! UISegmentedControl
        segmentButton.frame = segctrl.frame
        segmentButton.frame.size.height = searchbar.frame.size.height
        segmentButton.selectedSegmentIndex = 0
        segmentButton.tag = 123
    }
    
    @IBOutlet weak var filterbtn: UIButton!
    
    @IBAction func filter(sender: AnyObject) {
        filterview.hidden = false
    }
    
    @IBOutlet weak var filtertable: UITableView!
    
    override func viewDidLoad() {
        //segctrl.hidden = true
        filterview.hidden = true
        tobefiltered.addObject("")
        tobefiltered.addObject("")
        tobefiltered.addObject("")
        tobefiltered.addObject("")
        tobefiltered.addObject("")
        addbutton.layer.cornerRadius = (addbutton.layer.bounds.size.width)/2
                filterbtn.layer.cornerRadius = (filterbtn.layer.bounds.size.width)/2
        var segmentButton: UISegmentedControl!
        segmentButton = UISegmentedControl(items: [self.imageWithImage(UIImage(named: "List.png")!, scaledToSize: CGSizeMake(32, 32)), self.imageWithImage(UIImage(named: "grid.png")!, scaledToSize: CGSizeMake(32, 32))])
        
        segctrl.setImage(self.imageWithImage(UIImage(named: "List.png")!, scaledToSize: CGSizeMake(25, 25)), forSegmentAtIndex: 0)
        segctrl.setImage(self.imageWithImage(UIImage(named: "grid.png")!, scaledToSize: CGSizeMake(25, 25)), forSegmentAtIndex: 1)
        segctrl.frame.size.height = 0.75*searchbar.frame.size.height
        segctrl.contentMode = .ScaleToFill
        
        segctrl.selectedSegmentIndex = 0
        segctrl.tag = 123
        segctrl.addTarget(self, action: #selector(self.viewswitch(_:)), forControlEvents: UIControlEvents.ValueChanged)
        //view.addSubview(segmentButton)

        
        
        self.spinner.layer.cornerRadius = 5
        self.spinner.hidden = true        
                filterclose.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12)
        self.view.userInteractionEnabled = true
        tableview.registerNib(UINib.init(nibName: "buildingcell", bundle: nil), forCellReuseIdentifier: "assetcell")
        let datakeyed = NSUserDefaults.standardUserDefaults().objectForKey("assetdata") as! NSData
        assets = NSKeyedUnarchiver.unarchiveObjectWithData(datakeyed)?.mutableCopy() as! NSMutableDictionary
        buildingarr = assets["results"]!.mutableCopy() as! NSMutableArray
        listobuildings = buildingarr.mutableCopy() as! NSMutableArray
        print("Buildings arr",buildingarr)
        token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        dispatch_async(dispatch_get_main_queue(), {
            self.spinner.hidden = false
            self.view.userInteractionEnabled = false
            self.getstates(credentials().subscription_key)
        })
        
        filtertable.selectRowAtIndexPath(NSIndexPath.init(forRow: 4, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.None)        
        self.tableView(filtertable, didSelectRowAtIndexPath: NSIndexPath.init(forRow: 4, inSection: 0))
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(tableView == filtertable){
            return 1
        }
        
        if(buildingarr.count>0){
            self.notfound.hidden = true
            self.tableview.hidden = false
        }else{
            self.notfound.hidden = false
            self.tableview.hidden = true
        }
        return buildingarr.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == filtertable){
            return 5
        }
        return 1
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
    
    
    func getstates(subscription_key:String){
        let url = NSURL.init(string:String(format: "%@country/states/",credentials().domain_url))
        print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                NSNotificationCenter.defaultCenter().postNotificationName("notifyclose", object: nil)
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401{
                NSNotificationCenter.defaultCenter().postNotificationName("notifyclose", object: nil)
            } else
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
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
                        self.spinner.hidden = true
                        self.view.userInteractionEnabled = true                        
                        let data = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "countries")
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
    
    @IBAction func filterok(sender: AnyObject) {
        print("listofbuildings ",listobuildings)
        filterview.hidden = true
        if(tobefiltered.containsObject("all")){
            buildingarr = assets["results"]!.mutableCopy() as! NSMutableArray
            tableview.reloadData()
        }else{
            var temparr = NSMutableArray()
            print("Count",listobuildings.count)
            if(tobefiltered.containsObject("buildings")){
                for index in 0..<listobuildings.count {
                    let data = listobuildings.objectAtIndex(index) as! [String:AnyObject]
                    if(data["project_type"] != nil){
                        if(data["project_type"] as! String == "building"){
                            temparr.addObject(data)
                        }
                    }
                }
            }
            if(tobefiltered.containsObject("cities")){
                for i in 0..<listobuildings.count{
                    let data = listobuildings.objectAtIndex(i) as! [String:AnyObject]
                    if(data["project_type"] != nil){
                        if(data["project_type"] as! String == "city"){
                            temparr.addObject(data)
                        }
                    }
                }
            }
            
            if(tobefiltered.containsObject("communities")){
                for i in 0..<listobuildings.count{
                    let data = listobuildings.objectAtIndex(i) as! [String:AnyObject]
                    if(data["project_type"] != nil){
                        if(data["project_type"] as! String == "community"){
                            temparr.addObject(data)
                        }
                    }
                }
            }
            
            if(tobefiltered.containsObject("my projects")){
                for i in 0..<listobuildings.count{
                    let data = listobuildings.objectAtIndex(i) as! [String:AnyObject]
                    if(data["project_type"] != nil){
                        if(data["project_type"] as! String == "my project"){
                            temparr.addObject(data)
                        }
                    }
                }
            }
            buildingarr = temparr.mutableCopy() as! NSMutableArray
            
        }
        
        tableview.reloadData()
        
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView == filtertable){
            var cell = tableView.cellForRowAtIndexPath(indexPath)! as! UITableViewCell
                cell.accessoryType = UITableViewCellAccessoryType.None
                        tobefiltered.replaceObjectAtIndex(indexPath.row, withObject: "")
        }
        print("To be filtered",tobefiltered)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if(tableView == filtertable){
            var cell = tableView.cellForRowAtIndexPath(indexPath)! as! UITableViewCell
            if(cell.accessoryType == UITableViewCellAccessoryType.None){
         cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            tobefiltered.replaceObjectAtIndex(indexPath.row, withObject: (cell.textLabel?.text?.lowercaseString)!)
            }
            
            print("To be filtered",tobefiltered)
        }
        else{
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let currentbuilding = buildingarr[indexPath.section] as! [String:AnyObject]
        countries = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("countries") as! NSData) as! [String : AnyObject]
        
        var tempdict = countries["countries"] as! [String:AnyObject]
        fullcountryname = tempdict[currentbuilding["country"] as! String]! as! String
        tempdict = countries["divisions"]![currentbuilding["country"] as! String]! as! [String:AnyObject]
         for (key,value) in tempdict{
         if(key == currentbuilding["state"] as! String){
         fullstatename = value as! String
         break
         }
         }
        
        let dte = NSDate()
        let dateformat = NSDateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd"
        let datee = dateformat.stringFromDate(dte)
        print(datee)
        
        //https://api.usgbc.org/leed/assets/LEED:1000137566/scores/?at=2016-11-07
        let currentleedid = currentbuilding["leed_id"] as! Int
        NSUserDefaults.standardUserDefaults().setInteger(currentleedid, forKey: "leed_id")
        let c = credentials()
        domain_url = c.domain_url
        self.getperformancedata(c.subscription_key, leedid: currentleedid, date: datee)
        self.spinner.hidden = false
        self.view.userInteractionEnabled = false
        }
    }
    
    
    func getperformancedata(subscription_key:String, leedid: Int, date : String){
        let url = NSURL.init(string: String(format: "%@assets/LEED:%d/scores/",domain_url,leedid))
        print(url?.absoluteURL)
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
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
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401{
                NSNotificationCenter.defaultCenter().postNotificationName("notifyclose", object: nil)
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
                    NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "performance_data")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    self.buildingdetails(subscription_key, leedid: leedid)
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
    func getcomparablesdata(subscription_key:String, leedid: Int){
        let url = NSURL.init(string: String(format: "%@comparables/",domain_url))
        print(url?.absoluteURL)
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
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
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401{
                NSNotificationCenter.defaultCenter().postNotificationName("notifyclose", object: nil)
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
                    NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "comparable_data")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    dispatch_async(dispatch_get_main_queue(), {
                        self.getrequiredfields(subscription_key)
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
    
    func getlocalcomparablesdata(subscription_key:String, leedid: Int, state: String){
        let url = NSURL.init(string:String(format: "%@comparables/?state=%@",domain_url,state))
        print(url?.absoluteURL)
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
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
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401{
                NSNotificationCenter.defaultCenter().postNotificationName("notifyclose", object: nil)
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
                    NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "local_comparable_data")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    dispatch_async(dispatch_get_main_queue(), {
                        
                    })
                    self.getcomparablesdata(subscription_key, leedid: leedid)
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
    
    
    
    func buildingdetails(subscription_key:String, leedid: Int){
        let url = NSURL.init(string: String(format: "%@assets/LEED:%d/",domain_url,leedid))
        print(url?.absoluteURL)
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
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
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401{
                NSNotificationCenter.defaultCenter().postNotificationName("notifyclose", object: nil)
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
                    NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "building_details")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "row")
                    if let s = jsonDictionary["state"] as? String{
                        dispatch_async(dispatch_get_main_queue(), {
                            
                        })
                        self.getlocalcomparablesdata(subscription_key, leedid: leedid, state: String(format: "%@%@",jsonDictionary["country"] as! String,s))
                    }
                    
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

    
    func certdetails(subscription_key:String, leedid: Int){
        let url = NSURL.init(string: String(format: "%@assets/LEED:%d/certifications/",domain_url,leedid))
        print(url?.absoluteURL)
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
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
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401{
                NSNotificationCenter.defaultCenter().postNotificationName("notifyclose", object: nil)
            } else
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for httCALayer * individualforiphone = [CALayer layer];
                    //[self.layer addSublayer:individualforiphone];
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    let jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        if(jsonDictionary["error"] != nil){
                            if(jsonDictionary["error"]![0]!["message"] != nil){
                                self.showalert(jsonDictionary["error"]![0]!["message"]!! as! String, title: "Error", action: "OK")
                            }else{
                            self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                            }
                        }else{
                            self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        }
                    }catch{
                        
                    }
                    
                })
            }else{
                print(data)
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                    let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                    NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "certification_details")
                    
                    dispatch_async(dispatch_get_main_queue(), {

                        self.spinner.hidden = true
                        self.view.userInteractionEnabled = true
                    self.performSegueWithIdentifier("gotodashboard", sender: nil)
                    })
                    
                } catch {
                    dispatch_async(dispatch_get_main_queue(), {
                        let jsonDictionary : NSDictionary
                        do {
                            jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                            if(jsonDictionary["error"] != nil){
                                if(jsonDictionary["error"]![0]!["message"] != nil){
                                    self.showalert(jsonDictionary["error"]![0]!["message"]!! as! String, title: "Error", action: "OK")
                                }else{
                                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                                }
                            }else{
                                self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                            }
                        }catch{
                            
                        }
                        
                    })

                }
            }
            
        }
        task.resume()
    }

    @IBOutlet weak var filterclose: UIButton!
    
    @IBAction func closefilter(sender: AnyObject) {
        filterview.hidden = true
    }
    @IBOutlet weak var filterview: UIView!
    
    @IBOutlet weak var notfound: UILabel!
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(tableView == filtertable){
            var cell = tableView.dequeueReusableCellWithIdentifier("cell")! as! UITableViewCell
            cell.tintColor = UIColor.blueColor()
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.textLabel?.text = filterarr[indexPath.row]
            return cell
        }
        //== 'activated_payment_done'
        let cell = tableView.dequeueReusableCellWithIdentifier("assetcell", forIndexPath: indexPath) as! buildingcell
        let arr = buildingarr[indexPath.section] as! [String:AnyObject]
        cell.leedidlbl.text = String(format: "%d",arr["leed_id"] as! Int)
        cell.namelbl.text = String(format: "%@",arr["name"] as! String)
        
        if let update = arr["building_status"] as? String {
            if(update == "activated_payment_done"){
                cell.statuslbl.text = "Registered"
            }else if(update == "activated_payment_pending"){
                cell.statuslbl.text = "Make payment"
            }else if(update == "agreement_pending"){
                cell.statuslbl.text = "Sign Agreement"
            }
            else if(update == "activated_addendum_agreement_pending"){
                cell.statuslbl.text = "Agreement pending"
            }else{
                cell.statuslbl.text = ""
            }
            //  print(dateFormat.stringFromDate(dte!))
            //cell.statuslbl.text =
            //lastupdatedlbl
            
        }else{
            cell.statuslbl.text = "Not available"
        }
        return cell
    }
    
    
    
    
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        var str = searchbar.text!
        if(str.characters.count == 0){
            let datakeyed = NSUserDefaults.standardUserDefaults().objectForKey("assetdata") as! NSData
            assets = NSKeyedUnarchiver.unarchiveObjectWithData(datakeyed)?.mutableCopy() as! NSMutableDictionary
            buildingarr = assets["results"]!.mutableCopy() as! NSMutableArray
            if(tobefiltered.containsObject("all")){
                self.tableview.reloadData()
            }else{
                filterok(filterbtn)
            }
        }else{
            let tempstring = str.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            str = tempstring
            let urlstring = String(format: "%@assets/search/?q=%@",credentials().domain_url,str)
            dispatch_async(dispatch_get_main_queue(), {
                self.spinner.hidden = false
            })
            if(timer.valid){
                timer.invalidate()
            }
            timer = NSTimer.init(timeInterval: 3.5, target: self, selector: Selector(searchbuilding(urlstring)), userInfo: nil, repeats: false)
            
        }
        
    }
    
    
    
    
    func searchbuilding(urlstring:String){
        let url = NSURL.init(string: urlstring)
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
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401{
                NSNotificationCenter.defaultCenter().postNotificationName("notifyclose", object: nil)
            } else
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    let jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        if(jsonDictionary["error"] != nil){
                            if(jsonDictionary["error"]![0]!["message"] != nil){
                                self.showalert(jsonDictionary["error"]![0]!["message"]!! as! String, title: "Error", action: "OK")
                            }else{
                                self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                            }
                        }else{
                            self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        }
                    }catch{
                        
                    }
                    
                })

            }else{
                print(data)
                let jsonDictionary : NSArray
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSArray
                    self.buildingarr = jsonDictionary.mutableCopy() as! NSMutableArray
                    dispatch_async(dispatch_get_main_queue(), {
                        self.spinner.hidden = true
                        self.view.userInteractionEnabled = true
                    })
                    dispatch_async(dispatch_get_main_queue(), {
                        if(self.tobefiltered.containsObject("all")){
                            self.tableview.reloadData()
                        }else{
                            self.filterok(self.filterbtn)
                        }
                    })
                } catch {
                    print(error)
                    dispatch_async(dispatch_get_main_queue(), {
                        let jsonDictionary : NSDictionary
                        do {
                            jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                            if(jsonDictionary["error"] != nil){
                                if(jsonDictionary["error"]![0]!["message"] != nil){
                                    self.showalert(jsonDictionary["error"]![0]!["message"]!! as! String, title: "Error", action: "OK")
                                }else{
                                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                                }
                            }else{
                                self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                            }
                        }catch{
                            
                        }
                        
                    })

                }
            }
            
        }
        task.resume()
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if(scrollView == tableview){
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            if (assets["next"] as? String) != nil {
                if(isloading == false){
                    let c = credentials()
                    dispatch_async(dispatch_get_main_queue(), {
                        self.view.userInteractionEnabled = false
                        self.spinner.hidden = false
                    })
                    loadMoreDataFromServer("\(credentials().domain_url)assets/?page=\(page)", subscription_key: c.subscription_key)
                    if(self.tobefiltered.containsObject("all")){
                        self.tableview.reloadData()
                    }else{
                        self.filterok(self.filterbtn)
                    }
                }
            }
        }
        }
    }
    
    
    
    
    func loadMoreDataFromServer(URL:String, subscription_key:String){
        let url = NSURL.init(string: URL)
        let request = NSMutableURLRequest.init(URL: url!)
        print(url?.absoluteURL)
        request.HTTPMethod = "GET"
        isloading = true
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.isloading = false
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401{
                NSNotificationCenter.defaultCenter().postNotificationName("notifyclose", object: nil)
            } else
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.isloading = false
                        let jsonDictionary : NSDictionary
                        do {
                            jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                            if(jsonDictionary["error"] != nil){
                                if(jsonDictionary["error"]![0]!["message"] != nil){
                                    self.showalert(jsonDictionary["error"]![0]!["message"]!! as! String, title: "Error", action: "OK")
                                }else{
                                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                                }
                            }else{
                                self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                            }
                        }catch{
                            
                        }
                        
                    })

                
            }else{
                print(data)
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! [String:AnyObject]
                    if(jsonDictionary["results"] != nil){
                    self.assets = jsonDictionary.mutableCopy() as! NSMutableDictionary
                    let temparr = self.assets["results"] as! NSArray
                    let tempbuilding = NSMutableArray()
                    for i in 0..<self.buildingarr.count {
                        tempbuilding.addObject(self.buildingarr.objectAtIndex(i))
                    }
                    for i in 0..<temparr.count {
                        tempbuilding.addObject(temparr.objectAtIndex(i))
                    }
                    self.buildingarr = tempbuilding.mutableCopy() as! NSMutableArray
                        self.page = self.page + 1
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        self.isloading = false
                        self.view.userInteractionEnabled = true
                        self.spinner.hidden = true
                    })
                    
                } catch {
                    print(error)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.isloading = false
                            let jsonDictionary : NSDictionary
                            do {
                                jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                                if(jsonDictionary["error"] != nil){
                                    if(jsonDictionary["error"]![0]!["message"] != nil){
                                        self.showalert(jsonDictionary["error"]![0]!["message"]!! as! String, title: "Error", action: "OK")
                                    }else{
                                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                                    }
                                }else{
                                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                                }
                            }catch{
                                
                            }
                            
                        })

                    
                }
            }
            
        }
        task.resume()
        
    }
    
    func getrequiredfields(subscription_key:String){
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/requiredfields/?page=all",credentials().domain_url,NSUserDefaults.standardUserDefaults().integerForKey("leed_id")))
        print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                NSNotificationCenter.defaultCenter().postNotificationName("notifyclose", object: nil)
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401{
                NSNotificationCenter.defaultCenter().postNotificationName("notifyclose", object: nil)
            } else
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                })
            }else{
                print(data)
                var jsonDictionary : NSArray
                do {                    
                    self.getnotifications(subscription_key,leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"))
                    
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

    
    
    
    func getnotifications(subscription_key:String, leedid:Int){
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/notifications/",credentials().domain_url,NSUserDefaults.standardUserDefaults().integerForKey("leed_id")))
        print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                })
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401{
                NSNotificationCenter.defaultCenter().postNotificationName("notifyclose", object: nil)
            } else
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    let jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        if(jsonDictionary["error"] != nil){
                            if(jsonDictionary["error"]![0]!["message"] != nil){
                                self.showalert(jsonDictionary["error"]![0]!["message"]!! as! String, title: "Error", action: "OK")
                            }else{
                                self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                            }
                        }else{
                            self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        }
                    }catch{
                        
                    }
                    
                })

            }else{
                print(data)
                var jsonDictionary : NSArray
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSArray
                    print(jsonDictionary)
                    dispatch_async(dispatch_get_main_queue(), {
                        let data = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "notifications")
                        self.buildingactions(subscription_key, leedid: leedid)
                    })
                    
                    //self.tableview.reloadData()
                    // self.buildingactions(subscription_key, leedid: leedid)
                } catch {
                    print(error)
                    dispatch_async(dispatch_get_main_queue(), {
                        let jsonDictionary : NSDictionary
                        do {
                            jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                            if(jsonDictionary["error"] != nil){
                                if(jsonDictionary["error"]![0]!["message"] != nil){
                                    self.showalert(jsonDictionary["error"]![0]!["message"]!! as! String, title: "Error", action: "OK")
                                }else{
                                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                                }
                            }else{
                                self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                            }
                        }catch{
                            
                        }
                        
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
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                })
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401{
                NSNotificationCenter.defaultCenter().postNotificationName("notifyclose", object: nil)
            } else
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    let jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        if(jsonDictionary["error"] != nil){
                            if(jsonDictionary["error"]![0]!["message"] != nil){
                                self.showalert(jsonDictionary["error"]![0]!["message"]!! as! String, title: "Error", action: "OK")
                            }else{
                                self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                            }
                        }else{
                            self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        }
                    }catch{
                        
                    }
                    
                })

            }else{
                print(data)
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                    let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                    NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "actions_data")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "row")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.certdetails(subscription_key, leedid: leedid)
                    })
                    
                } catch {
                    print(error)
                    dispatch_async(dispatch_get_main_queue(), {
                        let jsonDictionary : NSDictionary
                        do {
                            jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                            if(jsonDictionary["error"] != nil){
                                if(jsonDictionary["error"]![0]!["message"] != nil){
                                    self.showalert(jsonDictionary["error"]![0]!["message"]!! as! String, title: "Error", action: "OK")
                                }else{
                                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                                }
                            }else{
                                self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                            }
                        }catch{
                            
                        }
                        
                    })

                }
            }
            
        }
        task.resume()
    }
    
    
    func checktoken(){
        if(NSUserDefaults.standardUserDefaults().objectForKey("username") != nil && NSUserDefaults.standardUserDefaults().objectForKey("password") != nil){
            var username = NSUserDefaults.standardUserDefaults().objectForKey("username")
            var password = NSUserDefaults.standardUserDefaults().objectForKey("password")
            username = "testuser@gmail.com"
            password = "initpass"
            let credential = credentials()
            var domain_url = ""
            domain_url=credential.domain_url
            print("subscription key of LEEDOn ",credential.subscription_key)
            let url = NSURL.init(string: String(format: "%@auth/login/",domain_url))
            let request = NSMutableURLRequest.init(URL: url!)
            request.HTTPMethod = "POST"
            request.addValue(credential.subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
            request.addValue("application/json", forHTTPHeaderField:"Content-type" )
            let httpbody = String(format: "{\"username\":\"%@\",\"password\":\"%@\"}",username as! String,password as! String)
            request.HTTPBody = httpbody.dataUsingEncoding(NSUTF8StringEncoding)
            print("HEadre is ",httpbody)
            print(request.allHTTPHeaderFields)
            
            task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    print("error=\(error)")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                    return
                }
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401{
                    NSNotificationCenter.defaultCenter().postNotificationName("notifyclose", object: nil)
                } else
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    dispatch_async(dispatch_get_main_queue(), {
                        let jsonDictionary : NSDictionary
                        do {
                            jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                            if(jsonDictionary["error"] != nil){
                                if(jsonDictionary["error"]![0]!["message"] != nil){
                                    self.showalert(jsonDictionary["error"]![0]!["message"]!! as! String, title: "Error", action: "OK")
                                }else{
                                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                                }
                            }else{
                                self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                            }
                        }catch{
                            
                        }
                        
                    })

                }else{
                    print(data)
                    let jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        print("JSON data is",jsonDictionary)
                        if(jsonDictionary.valueForKey("token_type") as! String == "Bearer"){
                            NSUserDefaults.standardUserDefaults().setObject(username, forKey: "username")
                            NSUserDefaults.standardUserDefaults().setObject(password, forKey: "password")
                            NSUserDefaults.standardUserDefaults().setObject(jsonDictionary.valueForKey("authorization_token") as! String, forKey: "token")
                        }
                    } catch {
                        print(error)
                        dispatch_async(dispatch_get_main_queue(), {
                            let jsonDictionary : NSDictionary
                            do {
                                jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                                if(jsonDictionary["error"] != nil){
                                    if(jsonDictionary["error"]![0]!["message"] != nil){
                                        self.showalert(jsonDictionary["error"]![0]!["message"]!! as! String, title: "Error", action: "OK")
                                    }else{
                                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                                    }
                                }else{
                                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                                }
                            }catch{
                                
                            }
                            
                        })

                    }
                }
                
            }
            task.resume()
        }else{
            timer.invalidate()
        }
    }
    
    @IBAction func logout(sender: AnyObject) {
        timer.invalidate()
        dispatch_async(dispatch_get_main_queue(), {
            let alertController = UIAlertController(title: "Logout", message: "Would you like to logout from the current user?", preferredStyle: .Alert)
            let callActionHandler = { (action:UIAlertAction!) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    NSUserDefaults.standardUserDefaults().removeObjectForKey("token")
                    NSUserDefaults.standardUserDefaults().removeObjectForKey("username")
                    NSUserDefaults.standardUserDefaults().removeObjectForKey("password")
                    self.performSegueWithIdentifier("gotologin", sender: nil)
                    self.navigationController?.popViewControllerAnimated(true)
                })
                
            }
            
            let cancelActionHandler = { (action:UIAlertAction!) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    self.navigationController?.popViewControllerAnimated(true)
                })
                
            }
            let cancelAction = UIAlertAction(title: "No", style: .Default, handler:cancelActionHandler)
            
            let defaultAction = UIAlertAction(title: "Yes", style: .Default, handler:callActionHandler)
            
            alertController.addAction(defaultAction)
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        })
        
    }
    
    
    
    func imageWithImage(image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
    
    
    @IBAction func customize(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            self.performSegueWithIdentifier("gotogrid", sender: nil)            
            })
    }
    
}

