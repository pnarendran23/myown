//
//  listofassets.swift
//  MySampleApp
//
//  Created by Group X on 03/11/16.
//
//

import Foundation
import UIKit
import WatchConnectivity

class listofassets: UIViewController, UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate, WCSessionDelegate {
    var assets = NSMutableDictionary()
    var token = ""
    var tobefiltered = NSMutableArray()
    var download_requests = [NSURLSession]()
    var listobuildings = NSMutableArray()
    var domain_url = ""
    var emptydict = ["count": 1,"created_at_max": "2016-12-30T14:02:41.260478Z","created_at_min": "2016-12-30T14:02:41.260478Z","energy_avg": 0,"water_avg": 0,"waste_avg": 0,"transport_avg": 0,"base_avg": 0,"human_experience_avg": 0]
    var page = 2
    var task = NSURLSessionTask()
    var timer = NSTimer()
    var isloading = false
    var tempfilter = NSMutableArray()
    var filterarr = [["My cities"] as! NSArray,["My communities"] as! NSArray,["My Transit","My parking"] as! NSArray,["My buildings","My portfolios"] as! NSArray,["All"] as! NSArray] as! NSMutableArray
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
    
    @available(iOS 9.3, *)
    func session(session: WCSession, activationDidCompleteWithState activationState: WCSessionActivationState, error: NSError?) {
        
    }
    
    func sessionDidBecomeInactive(session: WCSession) {
        
    }
    
    
    
    func sessionDidDeactivate(session: WCSession) {
        
    }
    
    var addbuttonsize = CGFloat(0)
    
    func viewswitch(sender: UISegmentedControl){
        if(sender.tag == 123){
            if(sender.selectedSegmentIndex == 1){
                customize(UIButton())
            }
        }
    }
    @IBOutlet weak var addbutton: UIButton!
    
    
    
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        //stop all download requests
        for request in download_requests
        {
            request.invalidateAndCancel()
        }
        if (WCSession.isSupported()) {
            watchsession.delegate = nil;
        }
    }
    
    @IBAction func globalsel(sender: AnyObject) {
        
        //<- change to where you want it to show.
        //Set the customView properties
        filterview.hidden = false
        filterview.frame.origin.y = -1 * UIScreen.mainScreen().bounds.size.height
        //Add the customView to the current view
        //Display the customView with animation
        UIView.animateWithDuration(0.7, animations: {() -> Void in
            self.filterview.frame.origin.y = 0
            }, completion: {(finished: Bool) -> Void in
        })

    }
    
    @IBAction func addproject(sender: AnyObject) {
        //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"addproject"])
        self.performSegueWithIdentifier("addnewproject", sender: nil)
    }
    
    func adjustit(){
        let segmentButton = self.view.viewWithTag(123) as! UISegmentedControl
        segmentButton.frame = segctrl.frame
        segmentButton.frame.size.height = searchbar.frame.size.height
        segmentButton.selectedSegmentIndex = 0
        segmentButton.tag = 123
    }
    
    @IBOutlet weak var filterbtn: UIButton!
    
    @IBAction func filter(sender: AnyObject) {
        //filterview.hidden = false
        self.performSegueWithIdentifier("filterproj", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "filterproj"){
            let v = segue.destinationViewController as! filterprojects
            v.filterarr = filterarr            
            v.tobefiltered = tobefiltered
        }
    }
    
    
    @IBAction func donebutton(sender: UIBarButtonItem) {
        sayHello(sender)
    }
    @IBAction func filterbutton(sender: UIBarButtonItem) {
        filter(sender)
    }
    var humanexarray = NSMutableArray()
    var transportationarray = NSMutableArray()
    @IBOutlet weak var filtertable: UITableView!
    var watchsession = WCSession.defaultSession()
    
    
    
    override func viewDidLoad() {        
        self.titlefont()        
        //self.navigationController!.hidesBarsOnTap = false;
        //self.navigationController!.hidesBarsOnSwipe = false;
        //self.navigationController!.hidesBarsWhenVerticallyCompact = false;
        if(NSUserDefaults.standardUserDefaults().objectForKey("humanexarray") != nil){
        humanexarray = NSUserDefaults.standardUserDefaults().objectForKey("humanexarray")?.mutableCopy() as! NSMutableArray
        }
        if(NSUserDefaults.standardUserDefaults().objectForKey("transportationarray") != nil){
            transportationarray = NSUserDefaults.standardUserDefaults().objectForKey("transportationarray")?.mutableCopy() as! NSMutableArray
        }
        //segctrl.hidden = true
        filterview.hidden = true
        var a = NSMutableArray()
        a.addObject("")
        tobefiltered.addObject(a)
        a = NSMutableArray()
        a.addObject("")
        tobefiltered.addObject(a)
        a = NSMutableArray()
        a.addObject("")
        a.addObject("")
        tobefiltered.addObject(a)
        a = NSMutableArray()
        a.addObject("")
        a.addObject("")
        tobefiltered.addObject(a)
        a = NSMutableArray()
        a.addObject("all")
        tobefiltered.addObject(a)
        addbutton.layer.cornerRadius = (addbutton.layer.bounds.size.width)/2
                filterbtn.layer.cornerRadius = (filterbtn.layer.bounds.size.width)/2
        let segmentButton: UISegmentedControl!
        segmentButton = UISegmentedControl(items: [self.imageWithImage(UIImage(named: "List.png")!, scaledToSize: CGSizeMake(32, 32)), self.imageWithImage(UIImage(named: "grid.png")!, scaledToSize: CGSizeMake(32, 32))])
        
        segctrl.setImage(self.imageWithImage(UIImage(named: "List.png")!, scaledToSize: CGSizeMake(25, 25)), forSegmentAtIndex: 0)
        segctrl.setImage(self.imageWithImage(UIImage(named: "grid.png")!, scaledToSize: CGSizeMake(25, 25)), forSegmentAtIndex: 1)
        segctrl.frame.size.height = 0.75*searchbar.frame.size.height
        segctrl.contentMode = .ScaleToFill
        self.navigationItem.title = "Projects"
        let navItem = UINavigationItem(title: "All projects");        
        self.nav.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!]
        let doneItem = UIBarButtonItem(title: "", style: .Plain, target: self, action: #selector(sayHello(_:)))
        let filteritem = UIBarButtonItem(title: "", style: .Plain, target: self, action: #selector(filter(_:)))
        navItem.leftBarButtonItem = doneItem;
        navItem.rightBarButtonItem = filteritem;
        self.navigationItem.leftBarButtonItem?.title = ""
        self.navigationItem.rightBarButtonItem?.title = ""
        self.navigationItem.leftBarButtonItem?.image = self.imageWithImage(UIImage(named: "signout.png")!, scaledToSize: CGSizeMake(35, 35))
        self.navigationItem.rightBarButtonItem?.image = self.imageWithImage(UIImage(named: "filtericon.png")!, scaledToSize: CGSizeMake(32, 32))
        self.navigationItem.leftBarButtonItem?.action = #selector(sayHello(_:))
        self.navigationItem.rightBarButtonItem?.action = #selector(filter(_:))

        nav.setItems([navItem], animated: false);
            
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
            self.spinner.hidden = true
            self.view.userInteractionEnabled = true
            if(NSUserDefaults.standardUserDefaults().objectForKey("building_details") == nil){
            self.spinner.hidden = false
            self.view.userInteractionEnabled = false
            self.getstates(credentials().subscription_key)
            }
        })
        
    }
    
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        self.tableview.reloadData()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tableview.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        page = 2
        token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        if(NSUserDefaults.standardUserDefaults().objectForKey("countries") == nil){
            dispatch_async(dispatch_get_main_queue(), {
                self.spinner.hidden = false
                self.view.userInteractionEnabled = false
                self.getstates(credentials().subscription_key)
            })
            
        }
        tableview.reloadData()
        if (WCSession.isSupported()) {
            watchsession = WCSession.defaultSession()
            watchsession.delegate = self;
            watchsession.activateSession()
        }
        searchbar.text = ""
        let datakeyed = NSUserDefaults.standardUserDefaults().objectForKey("assetdata") as! NSData
        assets = NSKeyedUnarchiver.unarchiveObjectWithData(datakeyed)?.mutableCopy() as! NSMutableDictionary
        buildingarr = assets["results"]!.mutableCopy() as! NSMutableArray
        filtertable.selectRowAtIndexPath(NSIndexPath.init(forRow: 4, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.None)
        for arr in tobefiltered{
            var a = arr as! NSArray
            for str in a{
                if(str as! String != ""){
                    filteredobject = str as! String
                    break
                }
            }
        }
        
        if(filteredobject == ""){
            filteredobject = "all"
        }
        
        project_type = filteredobject
        
        
        if(filteredobject == "all"){
            self.navigationItem.title = "All projects"
        }
        if(filteredobject == "my buildings"){
            self.navigationItem.title = "Buildings"
        }
        if(filteredobject == "my cities"){
            self.navigationItem.title = "Cities"
        }
        
        if(filteredobject == "my communities"){
            self.navigationItem.title = "Communities"
        }
        
        if(filteredobject == "my parking"){
            self.navigationItem.title = "Parksmart"
        }
        
        if(filteredobject == "my transit"){
            self.navigationItem.title = "My Transit"
        }
        
        if(filteredobject == "my Portfolios"){
            self.navigationItem.title = "Portfolios"
        }
        
        if(filteredobject == "my portfolios"){
            buildingarr = (NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("portfolios") as! NSData)?.mutableCopy() as! NSMutableDictionary)["results"]!.mutableCopy() as! NSMutableArray
        }
        
        self.tableView(filtertable, didSelectRowAtIndexPath: NSIndexPath.init(forRow: 4, inSection: 0))
        filterok(UIButton())
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
    
    func sayHello(sender: UIBarButtonItem) {
        timer.invalidate()
        dispatch_async(dispatch_get_main_queue(), {
            let alertController = UIAlertController(title: "Logout", message: "Would you like to logout from the current user?", preferredStyle: .Alert)
            let callActionHandler = { (action:UIAlertAction!) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    NSUserDefaults.standardUserDefaults().removeObjectForKey("token")
                    NSUserDefaults.standardUserDefaults().removeObjectForKey("username")
                    NSUserDefaults.standardUserDefaults().removeObjectForKey("password")
                    NSUserDefaults.standardUserDefaults().removeObjectForKey("building_details")
                    let appDomain = NSBundle.mainBundle().bundleIdentifier!
                    NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(tableView == filtertable){
            return 1
        }
        if(searchbar.text?.characters.count == 0 || searcharr["building"] == nil || searcharr["portfolio"] == nil){
        if(buildingarr.count>0){
            self.notfound.hidden = true
            self.tableview.hidden = false
        }else{
            self.notfound.hidden = false
            self.tableview.hidden = true
        }
            return 1
        }else{
            self.notfound.hidden = true
            self.tableview.hidden = false
            return 2
        }
        
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == filtertable){
            return 5
        }
        if(searchbar.text?.characters.count == 0 || searcharr["building"] == nil || searcharr["portfolio"] == nil){
        return buildingarr.count
        }else{
            if(section == 0){
                return (searcharr["building"] as! NSArray).count
            }else{
                return (searcharr["portfolio"] as! NSArray).count
            }
        }
    }
    
    var searcharr = NSMutableDictionary()
    
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
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                //NSNotificationCenter.defaultCenter().postNotificationName("notifyclose", object: nil)
                self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
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
    var filteredobject = ""
    var project_type = ""
    @IBAction func filterok(sender: AnyObject) {
        print("listofbuildings ",listobuildings)
        print("Filter asv ",filteredobject)
        print("Updated buildingarr count",buildingarr.count)
        filterview.hidden = true
        var temparr = NSMutableArray()
        self.listobuildings = self.buildingarr
        if(filteredobject == "my portfolios" || filteredobject == "all" || filteredobject == "my buildings" || searchbar.text?.characters.count > 0){
            temparr = self.buildingarr
            if(searchbar.text?.characters.count > 0){
                self.navigationItem.title = "Search results"
            }else{
                if(filteredobject == "all"){
                    self.navigationItem.title = "All projects"
                }
                if(filteredobject == "my buildings"){
                    self.navigationItem.title = "Buildings"
                }
                if(filteredobject == "my cities"){
                    self.navigationItem.title = "Cities"
                }
                
                if(filteredobject == "my communities"){
                    self.navigationItem.title = "Communities"
                }
                
                if(filteredobject == "my parking"){
                    self.navigationItem.title = "Parksmart"
                }
                
                if(filteredobject == "my transit"){
                    self.navigationItem.title = "My Transit"
                }
                
                if(filteredobject == "my Portfolios"){
                    self.navigationItem.title = "Portfolios"
                }
            }
        }
        else if(filteredobject == "my buildings"){
            project_type = "building"
            for index in 0..<listobuildings.count {
                let data = listobuildings.objectAtIndex(index) as! [String:AnyObject]
                if(data["project_type"] != nil){
                    if(data["project_type"] as! String == "building"){
                        temparr.addObject(data)
                    }
                }
            }
        }else if(filteredobject == "my cities"){
            project_type = "city"
            for i in 0..<listobuildings.count{
                let data = listobuildings.objectAtIndex(i) as! [String:AnyObject]
                if(data["project_type"] != nil){
                    if(data["project_type"] as! String == "city"){
                        temparr.addObject(data)
                    }
                }
            }
        }else if(filteredobject == "my communities"){
            project_type = "community"
            for i in 0..<listobuildings.count{
                let data = listobuildings.objectAtIndex(i) as! [String:AnyObject]
                if(data["project_type"] != nil){
                    if(data["project_type"] as! String == "community"){
                        temparr.addObject(data)
                    }
                }
            }
        }else if(filteredobject == "my parking"){
            project_type = "parksmart"
            for i in 0..<listobuildings.count{
                let data = listobuildings.objectAtIndex(i) as! [String:AnyObject]
                if(data["project_type"] != nil){
                    if(data["project_type"] as! String == "parksmart"){
                        temparr.addObject(data)
                    }
                }
            }
        }else if(filteredobject == "my transit"){
            project_type = "transit"
            for i in 0..<listobuildings.count{
                let data = listobuildings.objectAtIndex(i) as! [String:AnyObject]
                if(data["project_type"] != nil){
                    if(data["project_type"] as! String == "transit"){
                        temparr.addObject(data)
                    }
                }
            }
        }

        /*
        if(searchbar.text?.characters.count == 0){
            if(filteredobject == "my portfolios"){
                self.listobuildings = self.buildingarr
            }else{
            self.listobuildings = assets["results"]!.mutableCopy() as! NSMutableArray
            }
        }else{
            self.listobuildings = self.buildingarr
        }
        buildingarr = NSMutableArray()
        //if(tobefiltered.containsObject("all")){
        if(filteredobject == "all"){
            buildingarr = assets["results"]!.mutableCopy() as! NSMutableArray
            project_type = "all"
            tableview.reloadData()
        }else{
            let temparr = NSMutableArray()
            print("Count",listobuildings.count)
            //if(tobefiltered.containsObject("buildings")){
            if(filteredobject == "my buildings"){
                project_type = "building"
                for index in 0..<listobuildings.count {
                    let data = listobuildings.objectAtIndex(index) as! [String:AnyObject]
                    if(data["project_type"] != nil){
                        if(data["project_type"] as! String == "building"){
                            temparr.addObject(data)
                        }
                    }
                }
            }
            //if(tobefiltered.containsObject("cities")){
            if(filteredobject == "my cities"){
                project_type = "city"
                for i in 0..<listobuildings.count{
                    let data = listobuildings.objectAtIndex(i) as! [String:AnyObject]
                    if(data["project_type"] != nil){
                        if(data["project_type"] as! String == "city"){
                            temparr.addObject(data)
                        }
                    }
                }
            }
            
            //if(tobefiltered.containsObject("communities")){
            if(filteredobject == "my communities"){
                project_type = "community"
                for i in 0..<listobuildings.count{
                    let data = listobuildings.objectAtIndex(i) as! [String:AnyObject]
                    if(data["project_type"] != nil){
                        if(data["project_type"] as! String == "community"){
                            temparr.addObject(data)
                        }
                    }
                }
            }
            
            //if(tobefiltered.containsObject("my projects")){
            if(filteredobject == "my parking"){
                project_type = "parksmart"
                for i in 0..<listobuildings.count{
                    let data = listobuildings.objectAtIndex(i) as! [String:AnyObject]
                    if(data["project_type"] != nil){
                        if(data["project_type"] as! String == "parksmart"){
                            temparr.addObject(data)
                        }
                    }
                }
            }
            
            if(filteredobject == "my transit"){
                project_type = "transit"
                for i in 0..<listobuildings.count{
                    let data = listobuildings.objectAtIndex(i) as! [String:AnyObject]
                    if(data["project_type"] != nil){
                        if(data["project_type"] as! String == "transit"){
                            temparr.addObject(data)
                        }
                    }
                }
            }
            
            buildingarr = temparr.mutableCopy() as! NSMutableArray
            
        }
        
        
        //if(searchbar.text?.characters.count > 0){
            
        //}
 
    */
        buildingarr = temparr.mutableCopy() as! NSMutableArray
        tableview.reloadData()
        
    }
    
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(tableView == tableview){
        if(UIScreen.mainScreen().bounds.size.width < UIScreen.mainScreen().bounds.size.height){
        return 0.146 * UIScreen.mainScreen().bounds.size.height;
        }
        return 0.146 * UIScreen.mainScreen().bounds.size.width;
        }
        return 50
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView == filtertable){
            let cell = tableView.cellForRowAtIndexPath(indexPath)!
                cell.accessoryType = UITableViewCellAccessoryType.None
                        tobefiltered.replaceObjectAtIndex(indexPath.row, withObject: "")
        }
        print("To be filtered",tobefiltered)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        searchbar.resignFirstResponder()
        if(tableView == filtertable){
            
            let cell = tableView.cellForRowAtIndexPath(indexPath)!
            if(cell.accessoryType == UITableViewCellAccessoryType.None){
         cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            tobefiltered.replaceObjectAtIndex(indexPath.row, withObject: (cell.textLabel?.text?.lowercaseString)!)
            }
            
            print("To be filtered",tobefiltered)
        }
        else{
            if(NSUserDefaults.standardUserDefaults().integerForKey("survey") == 1){
                NSUserDefaults.standardUserDefaults().removeObjectForKey("building_details")
            }
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "survey")        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if(indexPath.section == 0){
            buildingarr = self.searcharr.objectForKey("building")?.mutableCopy() as! NSMutableArray
        }else{
            buildingarr = self.searcharr.objectForKey("portfolio")?.mutableCopy() as! NSMutableArray
        }
        let currentbuilding = buildingarr[indexPath.row] as! [String:AnyObject]
            if let update = currentbuilding["building_status"] as? String {
                if(update == "activated_payment_done"){
            let currentleedid = currentbuilding["leed_id"] as! Int
            NSUserDefaults.standardUserDefaults().setInteger(currentleedid, forKey: "leed_id")
            let c = credentials()
            domain_url = c.domain_url
            let dte = NSDate()
            var dateformat = NSDateFormatter()
            dateformat.dateFormat = "yyyy-MM-dd"
            let datee = dateformat.stringFromDate(dte)
            print(datee)
        countries = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("countries") as! NSData) as! [String : AnyObject]
        
        var tempdict = countries["countries"] as! [String:AnyObject]
            if(currentbuilding["country"] != nil){
            if(tempdict[currentbuilding["country"] as! String] != nil){
        fullcountryname = tempdict[currentbuilding["country"] as! String]! as! String
            var divisions = countries["divisions"] as! [String:AnyObject]            
            if(divisions[currentbuilding["country"] as! String] is [String:AnyObject]){
        tempdict = countries["divisions"]![currentbuilding["country"] as! String] as! [String:AnyObject]
            }
         for (key,value) in tempdict{
         if(key == currentbuilding["state"] as! String){
         fullstatename = value as! String
         break
         }
            }
            //self.getperformancedata(c.subscription_key, leedid: currentleedid, date: datee)
            }else{
                
            }
            }else{
                
            }
            
                    NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "swindex")
                    let n = NSMutableArray()
                    NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "transithide")
                    NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "humanhide")
                    NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "index")
                    NSUserDefaults.standardUserDefaults().setInteger(indexPath.row, forKey: "currentrow")
                    NSUserDefaults.standardUserDefaults().setObject(n, forKey: "mainarray")
                    
                    var notexists = 0
                    // New Logic for storing the route values
                    let leedid = "\(currentbuilding["leed_id"] as! Int)"
                    let lid = leedid
                    print("Trans array is \(transportationarray)")
                    print("Human array is \(humanexarray)")
                    for i in 0..<transportationarray.count {
                        let a = transportationarray[i] as! NSArray
                        if (a.count == 2) {
                            let leedid = a[0] as! String
                            if lid == leedid {
                                NSUserDefaults.standardUserDefaults().setObject(a[1].mutableCopy() as! NSMutableArray, forKey: "mainarray")
                                NSUserDefaults.standardUserDefaults().setObject("\(leedid)", forKey: "transportbuildingid")
                                notexists = 1
                                NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "transithide")
                                break
                            }
                        }
                    }
                    if (transportationarray.count == 0) || (notexists != 1) {
                        NSUserDefaults.standardUserDefaults().setObject(leedid, forKey: "transportbuildingid")
                    }
                    notexists = 0
                    for i in 0..<humanexarray.count {
                        let a = humanexarray[i] as! NSArray
                        if a.count == 2 {
                            let leedid = a[0] as! String
                            if lid == leedid {
                                NSUserDefaults.standardUserDefaults().setObject(a[1], forKey: "experiencearr")
                                NSUserDefaults.standardUserDefaults().setObject("\(leedid)", forKey: "humanbuildingid")
                                notexists = 1
                                NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "humanhide")
                                break
                            }
                        }
                    }
                    if humanexarray.count == 0 {
                        var aa = [AnyObject]()
                        let x = [AnyObject]()
                        aa.append("5")
                        aa.append(x)
                        NSUserDefaults.standardUserDefaults().setObject(aa, forKey: "experiencearr")
                        humanexarray.addObject(aa)
                        NSUserDefaults.standardUserDefaults().setObject(leedid, forKey: "humanbuildingid")
                    }
                    else if notexists != 1 {
                        var aa = [AnyObject]()
                        let x = [AnyObject]()
                        aa.append("5")
                        aa.append(x)
                        NSUserDefaults.standardUserDefaults().setObject(aa, forKey: "experiencearr")
                        humanexarray.addObject(aa)
                        NSUserDefaults.standardUserDefaults().setObject(leedid, forKey: "humanbuildingid")
                    }
                    var array = NSMutableArray()
                    if(NSUserDefaults.standardUserDefaults().objectForKey("temp") != nil){
                    array = NSMutableArray.init(array: NSUserDefaults.standardUserDefaults().objectForKey("temp")?.mutableCopy() as! NSMutableArray)
                    }
                    NSUserDefaults.standardUserDefaults().setObject(array, forKey: "temp")
                    if(NSUserDefaults.standardUserDefaults().objectForKey("image") != nil){
                    array = NSMutableArray.init(array: NSUserDefaults.standardUserDefaults().objectForKey("image")?.mutableCopy() as! NSMutableArray)
                    }
                    array.removeAllObjects()
                    NSUserDefaults.standardUserDefaults().setObject(array, forKey: "image")
                    if(currentbuilding["key"] != nil){
                    let key = currentbuilding["key"] as! String
                    NSUserDefaults.standardUserDefaults().setObject(key, forKey: "key")
                    }
                    NSUserDefaults.standardUserDefaults().setObject("\(currentbuilding["leed_id"] as! Int)", forKey: "leed_id")
                    
                    let hot=0;
                    NSUserDefaults.standardUserDefaults().setInteger(hot, forKey: "hot")
                    NSUserDefaults.standardUserDefaults().setInteger(hot, forKey: "dirty")
                    NSUserDefaults.standardUserDefaults().setInteger(hot, forKey: "dark")
                    NSUserDefaults.standardUserDefaults().setInteger(hot, forKey: "loud")
                    NSUserDefaults.standardUserDefaults().setInteger(hot, forKey: "smelly")
                    NSUserDefaults.standardUserDefaults().setInteger(hot, forKey: "cold")
                    NSUserDefaults.standardUserDefaults().setInteger(hot, forKey: "stuffy")
                    NSUserDefaults.standardUserDefaults().setInteger(hot, forKey: "privacy")
                    NSUserDefaults.standardUserDefaults().setInteger(hot, forKey: "other")
                    NSUserDefaults.standardUserDefaults().setInteger(hot, forKey: "glare")
                    NSUserDefaults.standardUserDefaults().setObject("", forKey: "vvtext")
                    NSUserDefaults.standardUserDefaults().setInteger(hot, forKey: "iteration")
                    NSUserDefaults.standardUserDefaults().setObject("", forKey: "smileyvalue")
                    if(NSUserDefaults.standardUserDefaults().objectForKey("listofrowsforhuman") != nil){
                    let ar = NSMutableArray.init(array: NSUserDefaults.standardUserDefaults().objectForKey("listofrowsforhuman")?.mutableCopy() as! NSMutableArray)
                    let current = NSUserDefaults.standardUserDefaults().integerForKey("humanbuildingid")
                    dateformat = NSDateFormatter()
                    dateformat.dateFormat = "dd/MM/YYYY"
                    let date_string = dateformat.stringFromDate(NSDate())
                    for m in 0..<ar.count{
                        let a = ar.objectAtIndex(m).mutableCopy() as! NSMutableArray
                        let x = Int(a.objectAtIndex(0) as! String)
                        let date = a.objectAtIndex(1) as! String
                        if(x == current){
                            if(date_string == date){
                                NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "humanhide")
                                break
                            }else{
                                NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "humanhide")
                            }
                        }else{
                            NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "humanhide")
                        }
                        
                    }
                    }
                    
       
                    
                    
                    //NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "transithide")
                    //NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "humanhide")

                    
            dispatch_async(dispatch_get_main_queue(), {
                let nsDict2 = currentbuilding as NSDictionary as [NSObject : AnyObject]
                if(NSUserDefaults.standardUserDefaults().objectForKey("building_details") != nil){
                let current_dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary
                    if(current_dict["leed_id"] as! Int == nsDict2["leed_id"] as! Int){
                        let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(current_dict)
                        NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "building_details")
                        NSUserDefaults.standardUserDefaults().setInteger(current_dict["leed_id"] as! Int, forKey: "leed_id")
                    let a = NSMutableArray()
                    let x = NSArray()
                    a.addObject("5")
                    a.addObject(x)
                    NSUserDefaults.standardUserDefaults().setObject(a, forKey: "experiencearr")
                    NSUserDefaults.standardUserDefaults().setObject("\(current_dict["leed_id"] as! Int)", forKey: "humanbuildingid")
                        //NSDictionary(dictionary: current_dict).isEqualToDictionary(nsDict2)){
                        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "grid")
                        self.performSegueWithIdentifier("gotodashboard", sender: nil)
                    }else{
                        self.spinner.hidden = false
                        self.view.userInteractionEnabled = false
                        self.getperformancedata(c.subscription_key, leedid: currentleedid, date: datee)
                    }
                }else{
                    self.spinner.hidden = false
                    self.view.userInteractionEnabled = false
                    self.getperformancedata(c.subscription_key, leedid: currentleedid, date: datee)
                }
            })
            }else if(update == "activated_payment_pending"){
               showalert("Please make the payment for this project to proceed", title: "Error", action: "OK")
            }else if(update == "agreement_pending"){
                    showalert("Please sign the agreement for this project to proceed", title: "Error", action: "OK")
            }
            else if(update == "activated_addendum_agreement_pending"){
                    showalert("Please sign the agreement for this project to proceed", title: "Error", action: "OK")
            }
            }
        
        //https://api.usgbc.org/leed/assets/LEED:1000137566/scores/?at=2016-11-07
        }
    }
    
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        /*if(tableView == tableview){
            let favorite = UITableViewRowAction(style: .Destructive, title: "Delete") { action, index in
                print("deleted")
            }
            favorite.backgroundColor = UIColor.redColor()
            
            let share = UITableViewRowAction(style: .Normal, title: "Share") { action, index in
                print("Shared")
            }
            share.backgroundColor = UIColor.blueColor()
            
            return [share, favorite]
        }*/
        
        return nil
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {

        return false
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(tableView == tableview){
            
        }
        // you need to implement this method too or you can't swipe to display the actions
    }
    
    
    
    func getperformancedata(subscription_key:String, leedid: Int, date : String){
        let url = NSURL.init(string: String(format: "%@assets/LEED:%d/scores/",domain_url,leedid))
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
                    dispatch_async(dispatch_get_main_queue(), {() -> Void in
                        if WCSession.isSupported() {
                            var dict = [String:AnyObject]()
                            if(jsonDictionary["scores"] == nil){
                                dict["energy"] = 0
                                dict["base"] = 0
                                dict["water"] = 0
                                dict["waste"] = 0
                                dict["transport"] = 0
                                dict["human_experience"] = 0
                            }else{
                                var scores = jsonDictionary["scores"] as! [String:AnyObject]
                                if(scores["energy"] == nil || scores["energy"] is NSNull){
                                    dict["energy"] = 0
                                }else{
                                    dict["energy"] = scores["energy"] as! Int
                                }
                                
                                if(scores["water"] == nil || scores["water"] is NSNull){
                                    dict["water"] = 0
                                }else{
                                    dict["water"] = scores["water"] as! Int
                                }
                                
                                if(scores["waste"] == nil || scores["waste"] is NSNull){
                                    dict["waste"] = 0
                                }else{
                                    dict["waste"] = scores["waste"] as! Int
                                }
                                
                                if(scores["transport"] == nil || scores["transport"] is NSNull){
                                    dict["transport"] = 0
                                }else{
                                    dict["transport"] = scores["transport"] as! Int
                                }
                                
                                if(scores["base"] == nil || scores["base"] is NSNull){
                                    dict["base"] = 0
                                }else{
                                    dict["base"] = scores["base"] as! Int
                                }
                                
                                if(scores["human_experience"] == nil || scores["human_experience"] is NSNull){
                                    dict["human_experience"] = 0
                                }else{
                                    dict["human_experience"] = scores["human_experience"] as! Int
                                }
                            }
                            dispatch_async(dispatch_get_main_queue(),{
                                self.watchsession.sendMessage(dict, replyHandler: nil, errorHandler: { (error) -> Void in
                                    
                                })
                                do{
                                    try self.watchsession.updateApplicationContext(dict)
                                }catch{
                                    
                                }
                                

                            })
                        }
                        self.getmiddledata(subscription_key, leedid: leedid, date: date)
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
    
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        
    }

    func getmiddledata(subscription_key:String, leedid: Int, date : String){
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.dateFormat = "yyyy-MM-01"
        let dateString = formatter.stringFromDate(NSDate())
        print(dateString)
        let url = NSURL.init(string: String(format: "%@assets/LEED:%d/scores/?at=%@&within=1",domain_url,leedid,dateString))
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
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    })
                }else{
                    print(data)
                    let jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        print(jsonDictionary)
                        let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                        NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "middle_data")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        self.getinnerdata(subscription_key, leedid: leedid, date: date)
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

    
    func getinnerdata(subscription_key:String, leedid: Int, date : String){
        let date = NSDate()
        let formatter = NSDateFormatter()
        let unitFlags: NSCalendarUnit = [.Hour, .Day, .Month, .Year]
        let components = NSCalendar.currentCalendar().components(unitFlags, fromDate: date)
        components.year = components.year - 1
        components.month = components.month + 1
        let d = NSCalendar.currentCalendar().dateFromComponents(components)
        formatter.dateFormat = "yyyy-MM-01"
        let datestring = formatter.stringFromDate(d!)
        
        
        
        let url = NSURL.init(string: String(format: "%@assets/LEED:%d/scores/?at=%@&within=1",domain_url,leedid,datestring))
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
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    })
                }else{
                    print(data)
                    let jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        print(jsonDictionary)
                        let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                        NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "inner_data")
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
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
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
                        self.getnotifications(subscription_key,leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"))
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
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(searchbar.text?.characters.count > 0){
        if(section == 0){
            return "Buildings"
        }
        return "Portfolios"
        }
        return ""
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(searchbar.text?.characters.count > 0){
        return 35
        }
        return 1
    }
    
    func getlocalcomparablesdata(subscription_key:String, leedid: Int, state: String){
        print(state)
        let url = NSURL.init(string:"\(credentials().domain_url as String)comparables/?state=\(state)")
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
                        self.getcomparablesdata(subscription_key, leedid: leedid)
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
    
    
    
    func buildingdetails(subscription_key:String, leedid: Int){
        let url = NSURL.init(string: String(format: "%@assets/LEED:%d/",domain_url,leedid))
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
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                print(data)
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                    let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                    if(jsonDictionary["key"] != nil){
                        let key = jsonDictionary["key"] as! String
                        NSUserDefaults.standardUserDefaults().setObject(key, forKey: "key")
                    }
                    NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "building_details")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    if let s = jsonDictionary["state"] as? String{
                        dispatch_async(dispatch_get_main_queue(), {
                            print(s)
                            if(s != ""){
                                print(String(format: "%@%@",jsonDictionary["country"] as! String,s))
                                let str = jsonDictionary["country"] as! String
                                let decimalCharacters = NSCharacterSet.decimalDigitCharacterSet()
                                
                                let decimalRange = str.rangeOfCharacterFromSet(decimalCharacters, options: NSStringCompareOptions() , range: nil)
                                
                                if (decimalRange != nil){
                                    let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(self.emptydict)
                                    NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "local_comparable_data")
                                    NSUserDefaults.standardUserDefaults().synchronize()
                                    self.getcomparablesdata(subscription_key, leedid: leedid)
                                }else{
                        self.getlocalcomparablesdata(subscription_key, leedid: leedid, state: String(format: "%@%@",jsonDictionary["country"] as! String,s))
                                }
                            }else{
                                let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(self.emptydict)
                                NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "local_comparable_data")
                                NSUserDefaults.standardUserDefaults().synchronize()
                                self.getcomparablesdata(subscription_key, leedid: leedid)
                            }
                            
                            })
                            

                    }else{
                        let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(self.emptydict)
                        NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "local_comparable_data")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        self.getcomparablesdata(subscription_key, leedid: leedid)
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
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
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
                    NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "grid")
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
            let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
            cell.tintColor = UIColor.blueColor()
            if(tobefiltered.objectAtIndex(indexPath.row) as? String != ""){
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            }else{
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            }
            //cell.textLabel?.text = filterarr[indexPath.row]
            return cell
        }
        //== 'activated_payment_done'
        let cell = tableView.dequeueReusableCellWithIdentifier("assetcell", forIndexPath: indexPath) as! buildingcell
        
        if(searchbar.text?.characters.count == 0 || searcharr["building"] == nil || searcharr["portfolio"] == nil){
        let arr = buildingarr[indexPath.row] as! [String:AnyObject]
            if(arr["leed_id"] != nil){
        cell.leedidlbl.text = String(format: "%d",arr["leed_id"] as! Int)
            }else{
                cell.leedidlbl.text = String(format: "%d",arr["pf_id"] as! Int)
            }
        let actualstring = NSMutableAttributedString()
        var tempostring = NSMutableAttributedString()
        if(arr["name"] != nil){
        tempostring = NSMutableAttributedString(string:(arr["name"] as? String)!)
        }
        actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
        tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
        tempostring = NSMutableAttributedString(string:"\n")
        actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
        tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
        if(arr["street"] != nil){
        tempostring = NSMutableAttributedString(string:(arr["street"] as! String).capitalizedString)
        }
        tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGrayColor(), range: NSMakeRange(0, tempostring.length))
        tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans", size: 14)!, range: NSMakeRange(0, tempostring.length))
        actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
        tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
        tempostring = NSMutableAttributedString(string:" ")
        actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
        tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
        
        if(arr["city"] != nil){
        tempostring = NSMutableAttributedString(string:(arr["city"] as! String).capitalizedString)
        }
        tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGrayColor(), range: NSMakeRange(0, tempostring.length))
        tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans", size: 14)!, range: NSMakeRange(0, tempostring.length))
        actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
        cell.namelbl.adjustsFontSizeToFitWidth = true
        cell.namelbl.attributedText = actualstring as NSAttributedString
        if(indexPath.row == 0){
            print(actualstring)
        }
        //cell.namelbl.text =
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
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
        }else{
            if(indexPath.section == 0){
                buildingarr = self.searcharr.objectForKey("building")?.mutableCopy() as! NSMutableArray
                let arr = buildingarr[indexPath.row] as! [String:AnyObject]
                cell.leedidlbl.text = String(format: "%d",arr["leed_id"] as! Int)
                let actualstring = NSMutableAttributedString()
                var tempostring = NSMutableAttributedString()
                if(arr["name"] != nil){
                    tempostring = NSMutableAttributedString(string:(arr["name"] as? String)!)
                }
                actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
                tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
                tempostring = NSMutableAttributedString(string:"\n")
                actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
                tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
                if(arr["street"] != nil){
                    tempostring = NSMutableAttributedString(string:(arr["street"] as! String).capitalizedString)
                }
                tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGrayColor(), range: NSMakeRange(0, tempostring.length))
                tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans", size: 14)!, range: NSMakeRange(0, tempostring.length))
                actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
                tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
                tempostring = NSMutableAttributedString(string:" ")
                actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
                tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
                
                if(arr["city"] != nil){
                    tempostring = NSMutableAttributedString(string:(arr["city"] as! String).capitalizedString)
                }
                tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGrayColor(), range: NSMakeRange(0, tempostring.length))
                tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans", size: 14)!, range: NSMakeRange(0, tempostring.length))
                actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
                cell.namelbl.adjustsFontSizeToFitWidth = true
                cell.namelbl.attributedText = actualstring as NSAttributedString
                if(indexPath.row == 0){
                    print(actualstring)
                }
                //cell.namelbl.text =
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
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
            }else{
                buildingarr = self.searcharr.objectForKey("portfolio")?.mutableCopy() as! NSMutableArray
                let arr = buildingarr[indexPath.row] as! [String:AnyObject]
                if(arr["pf_id"] != nil){
                cell.leedidlbl.text = String(format: "%d",arr["pf_id"] as! Int)
                }
                let actualstring = NSMutableAttributedString()
                var tempostring = NSMutableAttributedString()
                if(arr["name"] != nil){
                    tempostring = NSMutableAttributedString(string:(arr["name"] as? String)!)
                }
                actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
                tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
                tempostring = NSMutableAttributedString(string:"\n")
                actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
                tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
                if(arr["street"] != nil){
                    tempostring = NSMutableAttributedString(string:(arr["street"] as! String).capitalizedString)
                }
                tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGrayColor(), range: NSMakeRange(0, tempostring.length))
                tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans", size: 14)!, range: NSMakeRange(0, tempostring.length))
                actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
                tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
                tempostring = NSMutableAttributedString(string:" ")
                actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
                tempostring.deleteCharactersInRange(NSMakeRange(0, tempostring.length))
                
                if(arr["city"] != nil){
                    tempostring = NSMutableAttributedString(string:(arr["city"] as! String).capitalizedString)
                }
                tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGrayColor(), range: NSMakeRange(0, tempostring.length))
                tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans", size: 14)!, range: NSMakeRange(0, tempostring.length))
                actualstring.appendAttributedString(tempostring.mutableCopy() as! NSAttributedString)
                cell.namelbl.adjustsFontSizeToFitWidth = true
                cell.namelbl.attributedText = actualstring as NSAttributedString
                if(indexPath.row == 0){
                    print(actualstring)
                }
                //cell.namelbl.text =
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
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
            }
        }
        return cell
    }
    
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        self.tableview.reloadData()
    }
    
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        var str = searchbar.text!
        for request in download_requests
        {
            request.invalidateAndCancel()
        }
        
        if(str.characters.count == 0){
            searchbar.resignFirstResponder()
            let datakeyed = NSUserDefaults.standardUserDefaults().objectForKey("assetdata") as! NSData
            assets = NSKeyedUnarchiver.unarchiveObjectWithData(datakeyed)?.mutableCopy() as! NSMutableDictionary
            buildingarr = assets["results"]!.mutableCopy() as! NSMutableArray
            if(filteredobject == "my portfolios"){
                buildingarr = (NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("portfolios") as! NSData)?.mutableCopy() as! NSMutableDictionary)["results"]!.mutableCopy() as! NSMutableArray
            }
            if(tobefiltered.containsObject("all")){
                self.spinner.hidden = true
                self.tableview.reloadData()
            }else{
                filterok(filterbtn)
            }
            self.spinner.hidden = true
            self.tableview.reloadData()
        }else{
            let tempstring = str.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            str = tempstring
            var urlstring = ""
            if(project_type == "my portfolios"){
               project_type = "all"
            }else if(project_type == "my cities"){
                project_type = "cities"
            }else if(project_type == "my communities"){
                project_type = "communities"
            }else if(project_type == "my transit"){
                project_type = "transit"
            }else if(project_type == "my parking"){
                project_type = "parksmart"
            }else if(project_type == "my buildings"){
                project_type = "building"
            }else{
                project_type = "all"
            }
            
            if(filteredobject == "all"){
                self.navigationItem.title = "All projects"
            }
            if(filteredobject == "my buildings"){
                self.navigationItem.title = "Buildings"
            }
            if(filteredobject == "my cities"){
                self.navigationItem.title = "Cities"
            }
            
            if(filteredobject == "my communities"){
                self.navigationItem.title = "Communities"
            }
            
            if(filteredobject == "my parking"){
                self.navigationItem.title = "Parksmart"
            }
            
            if(filteredobject == "my transit"){
                self.navigationItem.title = "My Transit"
            }
            
            if(filteredobject == "my Portfolios"){
                self.navigationItem.title = "Portfolios"
            }

            
            if(project_type == "all"){
             //   loadMoreDataFromServer("\(credentials().domain_url)assets/?page=\(page)", subscription_key: c.subscription_key)
                urlstring = String(format: "%@assets/search/?q=%@",credentials().domain_url,str)
            }else{
            urlstring = String(format: "%@assets/search/?q=%@&project_type=\(project_type as String)",credentials().domain_url,str)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.spinner.hidden = false
            })
            if(timer.valid){
                timer.invalidate()
            }
            timer = NSTimer.init(timeInterval: 1.5, target: self, selector: Selector(searchbuilding(urlstring)), userInfo: nil, repeats: false)
            
        }
        
    }
    
    
    
    
    func searchbuilding(urlstring:String){
        let url = NSURL.init(string: urlstring)
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)",error?.code)
                if(self.filteredobject == "my portfolios"){
                    self.project_type = self.filteredobject
                }
                if(error?.code == -999){
                    
                }else{
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                })
                }
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
                var jsonDictionary : NSMutableDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()).mutableCopy() as! NSMutableDictionary
                    print(jsonDictionary)
                    
                    var building = jsonDictionary["building"]!.mutableCopy() as! NSMutableArray
                    var temp = NSMutableArray()
                    for item in building{
                        var a = item as! NSDictionary
                        if(self.filteredobject == "my cities"){
                            if(a["project_type"] as! String == "city"){
                                temp.addObject(a)
                            }
                        }
                        
                        if(self.filteredobject == "my communities"){
                            if(a["project_type"] as! String == "community"){
                                temp.addObject(a)
                            }
                        }
                        
                        if(self.filteredobject == "my transit"){
                            if(a["project_type"] as! String == "transit"){
                                temp.addObject(a)
                            }
                        }
                        
                        if(self.filteredobject == "my parking"){
                            if(a["project_type"] as! String == "parksmart"){
                                temp.addObject(a)
                            }
                        }
                        
                        if(self.filteredobject == "my buildings"){
                            if(a["project_type"] as! String == "building"){
                                temp.addObject(a)
                            }
                        }
                        
                        if(self.filteredobject == "all"){
                                temp.addObject(a)
                        }
                    }
                    print(jsonDictionary.allKeys)
                    jsonDictionary["building"] = temp
                    
                    self.searcharr = jsonDictionary.mutableCopy() as! NSMutableDictionary
                    //self.buildingarr = jsonDictionary.mutableCopy() as! NSMutableArray
                    dispatch_async(dispatch_get_main_queue(), {
                        self.spinner.hidden = true
                        self.view.userInteractionEnabled = true
                    })
                    dispatch_async(dispatch_get_main_queue(), {
                        if(self.tobefiltered.containsObject("all")){
                            self.tableview.reloadData()
                        }else{
                            self.filterok(self.filterbtn)
                            self.tableview.reloadData()
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
        searchbar.resignFirstResponder()
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            if(searchbar.text?.characters.count == 0 || searcharr["building"] == nil || searcharr["portfolio"] == nil){
            if (assets["next"] as? String) != nil {
                if(isloading == false){
                    let c = credentials()
                    dispatch_async(dispatch_get_main_queue(), {
                        self.view.userInteractionEnabled = false
                        self.spinner.hidden = false
                    })
                    if(project_type == "my portfolios"){
                        project_type = "all"
                    }else if(project_type == "my cities"){
                        project_type = "cities"
                    }else if(project_type == "my communities"){
                        project_type = "communities"
                    }else if(project_type == "my transit"){
                        project_type = "transit"
                    }else if(project_type == "my parking"){
                        project_type = "parksmart"
                    }else if(project_type == "my buildings"){
                        project_type = "building"
                    }else{
                        project_type = "all"
                    }
                    
                    if(project_type == "all"){
                    loadMoreDataFromServer("\(credentials().domain_url)assets/?page=\(page)", subscription_key: c.subscription_key)
                    }else{
                        if(project_type == "my portfolios"){
                        loadMoreDataFromServer("\(credentials().domain_url)portfolios/?&page=\(page)", subscription_key: c.subscription_key)
                        }else{
                        loadMoreDataFromServer("\(credentials().domain_url)assets/?project_type=\(project_type as String)&page=\(page)", subscription_key: c.subscription_key)
                        }
                    }
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
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.isloading = false
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401{
                dispatch_async(dispatch_get_main_queue(), {
                    //self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    self.isloading = false
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
                    //self.assets = jsonDictionary.mutableCopy() as! NSMutableDictionary
                    let temparr = jsonDictionary["results"] as! NSArray
                    let tempbuilding = NSMutableArray()
                    for i in 0..<self.buildingarr.count {
                        tempbuilding.addObject(self.buildingarr.objectAtIndex(i))
                    }
                    for i in 0..<temparr.count {
                        tempbuilding.addObject(temparr.objectAtIndex(i))
                    }
                    self.buildingarr = tempbuilding.mutableCopy() as! NSMutableArray
                    print("Buildingarr count after load more ",self.buildingarr.count)
                        self.page = self.page + 1
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        self.isloading = false
                        self.view.userInteractionEnabled = true
                        self.spinner.hidden = true
                        self.tableview.reloadData()
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
    
    @IBOutlet weak var nav: UINavigationBar!
    
    
    func getnotifications(subscription_key:String, leedid:Int){
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/notifications/",credentials().domain_url,NSUserDefaults.standardUserDefaults().integerForKey("leed_id")))
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
                    let jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()).mutableCopy() as! NSDictionary
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
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
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
            
            let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
            download_requests.append(session)
            self.task = session.dataTaskWithRequest(request) { data, response, error in
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
                    if let bid = NSBundle.mainBundle().bundleIdentifier {
                        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(bid)
                    }  
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
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
    
    
    @IBAction func customize(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            self.performSegueWithIdentifier("gotogrid", sender: nil)            
            })
    }
    
}

extension UIViewController{
        func maketoast(message:String){
            let toastLabel = UILabel(frame: CGRectMake(self.view.frame.size.width/2 - 150, self.view.frame.size.height-100, 300, 35))
            toastLabel.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)
            toastLabel.backgroundColor = UIColor.whiteColor()
            toastLabel.textColor = UIColor.blackColor()
            toastLabel.textAlignment = NSTextAlignment.Center;
            self.view.addSubview(toastLabel)
            //self.window?.rootViewController?.presentedViewController?.view.addSubview(toastLabel)
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.numberOfLines = 5
            toastLabel.textAlignment = NSTextAlignment.Center
            toastLabel.adjustsFontSizeToFitWidth = true
            toastLabel.layer.cornerRadius = 10;
            toastLabel.clipsToBounds  =  true
            UIView.animateWithDuration(3.0, delay: 0.1, options: .CurveEaseOut, animations: {
                
                toastLabel.alpha = 0.0
                
                }, completion: nil)
            
        }
    
    
}





extension UIViewController{
    func titlefont(){
        if(self.navigationController != nil){
        self.navigationController!.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor(),
             NSFontAttributeName: UIFont(name: "OpenSans", size: 17)!]
        }
    }
}
