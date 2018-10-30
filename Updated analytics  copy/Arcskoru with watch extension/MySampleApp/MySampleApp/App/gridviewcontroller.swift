//
//  gridviewcontroller.swift
//  Arcskoru
//
//  Created by Group X on 09/01/17.
//
//

import UIKit
import  WatchConnectivity

class gridviewcontroller: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource,WCSessionDelegate {
    @IBOutlet weak var tableview: UITableView!
    var tobefiltered = NSMutableArray()
    var filterarr = [["My cities"] as! NSArray,["My communities"] as! NSArray,["My Transit","My parking"] as! NSArray,["My buildings"] as! NSArray,["All"] as! NSArray] as! NSMutableArray
    var task = NSURLSessionTask()
    @IBAction func addbtn(sender: AnyObject) {
        let alertController = UIAlertController(title: "Create a new project", message: "Please select the type of project you want to create", preferredStyle: .ActionSheet)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        let buildings = UIAlertAction(title: "Buildings", style: .Default, handler: { action in
            self.type = "building"
            self.performSegueWithIdentifier("addnewbuilding", sender: nil)
        })
        let cities = UIAlertAction(title: "Cities", style: .Default, handler: {action in
            self.type = "cities"
            self.performSegueWithIdentifier("managecities", sender: nil)
            
        })
        let communities = UIAlertAction(title: "Communities", style: .Default, handler: {action in
            self.type = "communities"
            self.performSegueWithIdentifier("managecities", sender: nil)
        })
        
        let transportation = UIAlertAction(title: "Transportation", style: .Default, handler: {action in
            self.type = "transit"
            self.performSegueWithIdentifier("addnewbuilding", sender: nil)
        })
        
        let parksmart = UIAlertAction(title: "Parking", style: .Default, handler: {action in
            self.type = "parksmart"
            self.performSegueWithIdentifier("addnewbuilding", sender: nil)
        })
        
        alertController.addAction(buildings)
        alertController.addAction(cities)
        alertController.addAction(communities)
        alertController.addAction(transportation)
        alertController.addAction(parksmart)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    var type = ""
    var watchsession = WCSession.defaultSession()
    @IBOutlet weak var nav: UINavigationBar!
    @IBOutlet weak var gridview: UICollectionView!
    @IBOutlet weak var logout: UIButton!
    var token = NSUserDefaults.standardUserDefaults().objectForKey("token")
    var buildingarr = NSMutableArray()
    var humanexarray = NSMutableArray()
    var transportationarray = NSMutableArray()
    var isloading = false
    var toloadmore = 0
    var listobuildings = NSMutableArray()
    var timer = NSTimer()
    var domain_url = ""
    var download_requests = [NSURLSession]()
    var assets = NSMutableDictionary()    
    var countries = [String:AnyObject]()
    var fullstatename = ""
    var fullcountryname = ""
    var page = 2
    func viewswitch(sender: UISegmentedControl){
        if(sender.tag == 123){
            if(sender.selectedSegmentIndex == 0){
                customise(UIButton())
            }
        }
    }
    @IBOutlet weak var filterclosebtn: UIButton!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        //stop all download requests
        for request in download_requests
        {
            request.invalidateAndCancel()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    @IBAction func filterclose(sender: AnyObject) {
        filterview.hidden = true
    }
    
    @IBAction func donebutton(sender: UIBarButtonItem) {
        sayHello(sender)
    }
    @IBAction func filterbutton(sender: UIBarButtonItem) {
        filter(sender)
    }
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        
    }
    
    @available(iOS 9.3, *)
    func session(session: WCSession, activationDidCompleteWithState activationState: WCSessionActivationState, error: NSError?) {
        
    }
    
    func sessionDidBecomeInactive(session: WCSession) {
        
    }
    
    
    
    func sessionDidDeactivate(session: WCSession) {
        
    }

    
    @IBOutlet weak var filterview: UIView!
    
    @IBAction func filterok(sender: AnyObject) {
        print("listofbuildings ",listobuildings)
        print("Filter asv ",filteredobject)
        print("Updated buildingarr count",buildingarr.count)
        filterview.hidden = true
        var temparr = NSMutableArray()
        self.listobuildings = self.buildingarr
        if(searchbar.text?.characters.count > 0){
            self.navigationItem.title = "Search results"
        }
        if(filteredobject == "my portfolios" || filteredobject == "all" || filteredobject == "my buildings"){
            temparr = self.buildingarr
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
        gridview.reloadData()

    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
            cell.tintColor = UIColor.blueColor()
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            //cell.textLabel?.text = filterarr[indexPath.row]
            return cell
        }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
            let cell = tableView.cellForRowAtIndexPath(indexPath)!
            cell.accessoryType = UITableViewCellAccessoryType.None
            tobefiltered.replaceObjectAtIndex(indexPath.row, withObject: "")
        
        print("To be filtered",tobefiltered)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
            let cell = tableView.cellForRowAtIndexPath(indexPath)!
            if(cell.accessoryType == UITableViewCellAccessoryType.None){
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                tobefiltered.replaceObjectAtIndex(indexPath.row, withObject: (cell.textLabel?.text?.lowercaseString)!)
            }
            
            print("To be filtered",tobefiltered)
        
    }
    @IBOutlet weak var filterbtn: UIButton!
    
    @IBOutlet weak var nobuildingsfound: UILabel!
    @IBAction func showfilter(sender: AnyObject) {
        filterview.hidden = false
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchbar.frame.size.height = self.segctrl.frame.size.height
        self.searchbar.frame.origin.y = self.segctrl.frame.origin.y
        gridview.registerNib(UINib.init(nibName: "assetcollectionviewcell", bundle: nil), forCellWithReuseIdentifier: "assetcell")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        _ = UIScreen.mainScreen().bounds.size.width
        layout.sectionInset = UIEdgeInsets(top: 0.027 * UIScreen.mainScreen().bounds.size.width, left: (self.view.frame.size.width - (self.segctrl.frame.origin.x + self.segctrl.frame.size.width)), bottom: 0, right: (self.view.frame.size.width - (self.segctrl.frame.origin.x + self.segctrl.frame.size.width)))
        //layout.itemSize = CGSize(width: UIScreen.mainScreen().bounds.size.width/4.37,height:UIScreen.mainScreen().bounds.size.width/4.37)
        layout.itemSize = CGSize(width: UIScreen.mainScreen().bounds.size.height * 0.17,height:UIScreen.mainScreen().bounds.size.height  * 0.17)
        
        layout.minimumInteritemSpacing = 0//0.03 * UIScreen.mainScreen().bounds.size.width
        layout.minimumLineSpacing = (self.view.frame.size.width - (self.segctrl.frame.origin.x + self.segctrl.frame.size.width))
        gridview!.collectionViewLayout = layout
        self.automaticallyAdjustsScrollViewInsets = false
        if(NSUserDefaults.standardUserDefaults().objectForKey("humanexarray") != nil){
            humanexarray = NSUserDefaults.standardUserDefaults().objectForKey("humanexarray")?.mutableCopy() as! NSMutableArray
        }
        if(NSUserDefaults.standardUserDefaults().objectForKey("transportationarray") != nil){
            transportationarray = NSUserDefaults.standardUserDefaults().objectForKey("transportationarray")?.mutableCopy() as! NSMutableArray
        }
        //segctrl.hidden = true
        filterview.hidden = true
        if(tobefiltered.count == 0){
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
        tobefiltered.addObject(a)
        a = NSMutableArray()
        a.addObject("all")
        tobefiltered.addObject(a)
        }
        addbutton.layer.cornerRadius = (addbutton.layer.bounds.size.width)/2
        filterbtn.layer.cornerRadius = (filterbtn.layer.bounds.size.width)/2
        let segmentButton: UISegmentedControl!
        segmentButton = UISegmentedControl(items: [self.imageWithImage(UIImage(named: "List.png")!, scaledToSize: CGSizeMake(32, 32)), self.imageWithImage(UIImage(named: "grid.png")!, scaledToSize: CGSizeMake(32, 32))])
        
        segctrl.setImage(self.imageWithImage(UIImage(named: "List.png")!, scaledToSize: CGSizeMake(25, 25)), forSegmentAtIndex: 0)
        segctrl.setImage(self.imageWithImage(UIImage(named: "grid.png")!, scaledToSize: CGSizeMake(25, 25)), forSegmentAtIndex: 1)
        segctrl.frame.size.height = searchbar.frame.size.height
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
        
        segctrl.selectedSegmentIndex = 1
        segctrl.tag = 123
        segctrl.addTarget(self, action: #selector(self.viewswitch(_:)), forControlEvents: UIControlEvents.ValueChanged)
        //view.addSubview(segmentButton)
        
        
        
        self.spinner.layer.cornerRadius = 5
        self.spinner.hidden = true
        self.view.userInteractionEnabled = true
        tableview.registerNib(UINib.init(nibName: "buildingcell", bundle: nil), forCellReuseIdentifier: "assetcell")
        let datakeyed = NSUserDefaults.standardUserDefaults().objectForKey("assetdata") as! NSData
        assets = NSKeyedUnarchiver.unarchiveObjectWithData(datakeyed)?.mutableCopy() as! NSMutableDictionary
        buildingarr = assets["results"]!.mutableCopy() as! NSMutableArray
        print(buildingarr.count)
        listobuildings = buildingarr.mutableCopy() as! NSMutableArray
        print("Buildings arr",buildingarr)
        token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
 
    
    
    }
    
    
    func filter(sender:UIBarButtonItem){
            //showfilter(UIButton())
        self.performSegueWithIdentifier("filterproj", sender: nil)
    }
    
    func sayHello(sender:UIBarButtonItem){
        logout(UIButton())
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(searchbar.becomeFirstResponder()){
            searchbar.resignFirstResponder()
        }
        NSUserDefaults.standardUserDefaults().setObject(searchbar.text, forKey: "searchtext")
        if(segue.identifier == "filterproj"){
            let v = segue.destinationViewController as! filterprojects
            v.filterarr = filterarr
            v.tobefiltered = tobefiltered
        }else if(segue.identifier == "gotolist"){
            let v = segue.destinationViewController as! UINavigationController
            var va = v.viewControllers[0] as! listofassets
            va.filterarr = filterarr
            va.tobefiltered = tobefiltered
        }else if(segue.identifier == "managecities"){
            let v = segue.destinationViewController as! managecity
            v.type = type
            
        }else if(segue.identifier == "addnewbuilding"){
            let v = segue.destinationViewController as! newproject
            v.type = type
            
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        //plaque
        NSUserDefaults.standardUserDefaults().removeObjectForKey("performance_data")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("comparable_data")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("local_comparable_data")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("inner_data")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("middle_data")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("notifications")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("building_details")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("certification_details")
        
        //actions
        NSUserDefaults.standardUserDefaults().removeObjectForKey("actions_data")
        dispatch_async(dispatch_get_main_queue(), {
            self.spinner.hidden = true
            self.view.userInteractionEnabled = true
            if(NSUserDefaults.standardUserDefaults().objectForKey("countries") == nil){
                self.spinner.hidden = false
                self.view.userInteractionEnabled = false
                self.getstates(credentials().subscription_key)
            }
        })
        page = 2
        token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        if (WCSession.isSupported()) {
            watchsession = WCSession.defaultSession()
            watchsession.delegate = self;
            watchsession.activateSession()
        }
        searchbar.text = ""
        if(NSUserDefaults.standardUserDefaults().objectForKey("searchtext") != nil){
            searchbar.text = NSUserDefaults.standardUserDefaults().objectForKey("searchtext") as! String
        }
        
        let datakeyed = NSUserDefaults.standardUserDefaults().objectForKey("assetdata") as! NSData
        assets = NSKeyedUnarchiver.unarchiveObjectWithData(datakeyed)?.mutableCopy() as! NSMutableDictionary
        buildingarr = assets["results"]!.mutableCopy() as! NSMutableArray
        
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
        
        
        if(searchbar.text?.characters.count > 0){
            //self.searchBar(searchbar, textDidChange: searchbar.text!)
            var str = searchbar.text! as! String
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
                urlstring = String(format: "%@assets/search/?q=%@&page_size=30",credentials().domain_url,str)
            }else{
                urlstring = String(format: "%@assets/search/?q=%@&project_type=\(project_type as String)&page_size=30",credentials().domain_url,str)
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.spinner.hidden = false
            })
            if(timer.valid){
                timer.invalidate()
            }
            timer = NSTimer.init(timeInterval: 1.5, target: self, selector: Selector(searchbuilding(urlstring)), userInfo: nil, repeats: false)
            
        }else{
            
            filterok(UIButton())
        }

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
                self.gridview.reloadData()
            }else{
                filterok(filterbtn)
            }
            self.spinner.hidden = true
            self.gridview.reloadData()
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
                urlstring = String(format: "%@assets/search/?q=%@&page_size=30",credentials().domain_url,str)
            }else{
                urlstring = String(format: "%@assets/search/?q=%@&project_type=\(project_type as String)&page_size=30",credentials().domain_url,str)
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

    
    @IBOutlet weak var spinner: UIView!
    
    
    
    func searchbuilding(urlstring:String){
        let url = NSURL.init(string: urlstring)
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
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
                        if(building.count > 0){
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
                            self.buildingarr = jsonDictionary["building"] as! NSMutableArray
                            self.searcharr = jsonDictionary.mutableCopy() as! NSMutableDictionary
                            //self.buildingarr = jsonDictionary.mutableCopy() as! NSMutableArray
                            dispatch_async(dispatch_get_main_queue(), {
                                self.spinner.hidden = true
                                self.view.userInteractionEnabled = true
                            })
                            dispatch_async(dispatch_get_main_queue(), {
                                if(self.tobefiltered.containsObject("all")){
                                    self.gridview.reloadData()
                                }else{
                                    self.filterok(self.filterbtn)
                                    self.gridview.reloadData()
                                }
                            })
                        }else{
                            dispatch_async(dispatch_get_main_queue(), {
                                self.spinner.hidden = true
                                self.view.userInteractionEnabled = true
                                self.buildingarr = building
                                self.searcharr = jsonDictionary.mutableCopy() as! NSMutableDictionary
                                self.gridview.reloadData()
                            })
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
    }
    
    var filteredobject = ""
    
    @IBOutlet weak var segctrl: UISegmentedControl!
   
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        print(UIScreen.mainScreen().bounds.size.width)
        return CGSizeMake(UIScreen.mainScreen().bounds.size.height * 0.17,UIScreen.mainScreen().bounds.size.height * 0.17)
    }
    
    
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(buildingarr.count>0){
            self.nobuildingsfound.hidden = true
            self.gridview.hidden = false
        }else{
            self.nobuildingsfound.hidden = false
            self.gridview.hidden = true
        }
        return buildingarr.count
    }
    var searcharr = NSMutableDictionary()
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {        
        let currentbuilding = buildingarr[indexPath.row] as! [String:AnyObject]
        if(NSUserDefaults.standardUserDefaults().integerForKey("survey") == 1){
            NSUserDefaults.standardUserDefaults().removeObjectForKey("building_details")
        }
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "survey")
        if(searchbar.text?.characters.count > 0 ){
            if(indexPath.section == 0){
                buildingarr = self.searcharr.objectForKey("building")?.mutableCopy() as! NSMutableArray
            }else{
                buildingarr = self.searcharr.objectForKey("portfolio")?.mutableCopy() as! NSMutableArray
            }
        }        
        var project_type = ""
        if(currentbuilding["project_type"] != nil){
            project_type = currentbuilding["project_type"] as! String
        }
        if(project_type == "parksmart"){
            print("Parksmart")
            let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(currentbuilding)
            NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "building_details")
            NSUserDefaults.standardUserDefaults().synchronize()
            self.performSegueWithIdentifier("gotoparking", sender: nil)
        }else{
            NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "grid")
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
                                
                                //Existing ARM APIs
                                self.buildingdetails(c.subscription_key, leedid: currentleedid)
                                //self.performSegueWithIdentifier("gotodashboard", sender: nil)
                            }else{
                                self.spinner.hidden = false
                                self.view.userInteractionEnabled = false
                                //Existing ARM APIs
                                self.buildingdetails(c.subscription_key, leedid: currentleedid)
                                //self.getperformancedata(c.subscription_key, leedid: currentleedid, date: datee)
                            }
                        }else{
                            self.spinner.hidden = false
                            self.view.userInteractionEnabled = false
                            // Existing ARM APIs
                            self.buildingdetails(c.subscription_key, leedid: currentleedid)
                            //self.getperformancedata(c.subscription_key, leedid: currentleedid, date: datee)
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
        }
        
    }
    
    @IBOutlet weak var addbutton: UIButton!
    
    func getperformancedata(subscription_key:String, leedid: Int, date : String){
        let url = NSURL.init(string: String(format: "%@assets/LEED:%d/scores/",domain_url,leedid))
        print(url?.absoluteURL)
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token as! String), forHTTPHeaderField:"Authorization" )
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    if(error?.code == -999){
                        
                    }else{
                            self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
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
        request.addValue(String(format:"Bearer %@",token as! String), forHTTPHeaderField:"Authorization" )
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    if(error?.code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                    
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
        request.addValue(String(format:"Bearer %@",token as! String), forHTTPHeaderField:"Authorization" )
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    if(error?.code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                    
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
        request.addValue(String(format:"Bearer %@",token as! String), forHTTPHeaderField:"Authorization" )
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    if(error?.code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                    
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
                        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "row")
                        if let s = jsonDictionary["state"] as? String{
                            dispatch_async(dispatch_get_main_queue(), {
                                    self.getnotifications(subscription_key, leedid: leedid)
                            })
                       //     self.getlocalcomparablesdata(subscription_key, leedid: leedid, state: String(format: "%@%@",jsonDictionary["country"] as! String,s))
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

    
    func getstates(subscription_key:String){
        let url = NSURL.init(string:String(format: "%@country/states/",credentials().domain_url))
        print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token as! String), forHTTPHeaderField:"Authorization" )
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    if(error?.code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                    
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

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("assetcell", forIndexPath: indexPath) as! assetcollectionviewcell        
        let arr = buildingarr[indexPath.row] as! [String:AnyObject]
        cell.leedid.text = String(format: "%d",arr["leed_id"] as! Int)
        cell.assetname.text = String(format: "%@",(arr["name"] as? String)!)
        cell.assetname.font = UIFont.init(name: "OpenSans-Semibold", size: 0.045 * UIScreen.mainScreen().bounds.size.width)
        cell.status.font = UIFont.init(name: "OpenSans", size: 0.025 * UIScreen.mainScreen().bounds.size.width)
        cell.contentView.frame.size = collectionView.frame.size
        if let update = arr["building_status"] as? String {
            if(update == "activated_payment_done"){
                cell.status.text = "Registered"
            }else if(update == "activated_payment_pending"){
                cell.status.text = "Make payment"
            }else if(update == "agreement_pending"){
                cell.status.text = "Sign Agreement"
            }
            else if(update == "activated_addendum_agreement_pending"){
                cell.status.text = "Agreement pending"
            }else{
                cell.status.text = ""
            }
            
            //  print(dateFormat.stringFromDate(dte!))
            //cell.statuslbl.text =
            //lastupdatedlbl
            
        }else{
            cell.status.text = "Not available"
        }
        cell.contentView.layer.cornerRadius = 2.0
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        searchbar.resignFirstResponder()
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if(offsetY > 0){
        if offsetY > contentHeight - scrollView.frame.size.height {
            print(assets["next"])
            if (assets["next"] as? String) != nil {
                if(isloading == false){
                    let c = credentials()
                    dispatch_async(dispatch_get_main_queue(), {
                        self.view.userInteractionEnabled = false
                        self.spinner.hidden = false
                    })
                    self.toloadmore = 1
                    if(project_type == "all"){
                        loadMoreDataFromServer("\(credentials().domain_url)assets/?page=\(page)&page_size=30", subscription_key: c.subscription_key)
                    }else{
                        loadMoreDataFromServer("\(credentials().domain_url)assets/?project_type=\(project_type as! String)&page=\(page)&page_size=30", subscription_key: c.subscription_key)
                    }
                }
            }
            }}
    }
    var project_type = ""
    
    func loadMoreDataFromServer(URL:String, subscription_key:String){
        let url = NSURL.init(string: URL)
        let request = NSMutableURLRequest(URL:  url!, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 180.0)
        request.HTTPMethod = "GET"
        isloading = true
        print(url?.absoluteString)
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token as! String), forHTTPHeaderField:"Authorization" )
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.isloading = false
                    if(error?.code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                    
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
                        dispatch_async(dispatch_get_main_queue(), {
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
                            self.filterok(self.filterclosebtn)
                            //self.gridview.reloadData()
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
        request.addValue(String(format:"Bearer %@",token as! String), forHTTPHeaderField:"Authorization" )
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    if(error?.code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                    
                })
                return
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
                    var _ : NSArray
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
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func getnotifications(subscription_key:String, leedid:Int){
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/notifications/",credentials().domain_url,NSUserDefaults.standardUserDefaults().integerForKey("leed_id")))
        print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    if(error?.code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
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
                            // Existing ARM APIs
                            //self.buildingactions(subscription_key, leedid: leedid)
                            self.performSegueWithIdentifier("gotodashboard", sender: nil)
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
        request.addValue(String(format:"Bearer %@",token as! String), forHTTPHeaderField:"Authorization" )
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    if(error?.code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
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
    
    
    func certdetails(subscription_key:String, leedid: Int){
        let url = NSURL.init(string: String(format: "%@assets/LEED:%d/certifications/",domain_url,leedid))
        print(url?.absoluteURL)
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token as! String), forHTTPHeaderField:"Authorization" )
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    if(error?.code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                    
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
                            NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "grid")
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
    
    @IBAction func logout(sender: AnyObject) {
        timer.invalidate()
        dispatch_async(dispatch_get_main_queue(), {
            let alertController = UIAlertController(title: "Logout", message: "Would you like to logout from the current user?", preferredStyle: .Alert)
            let callActionHandler = { (action:UIAlertAction!) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    NSUserDefaults.standardUserDefaults().removeObjectForKey("token")
                    NSUserDefaults.standardUserDefaults().removeObjectForKey("username")
                    NSUserDefaults.standardUserDefaults().removeObjectForKey("password")
                    var noinstructions = NSUserDefaults.standardUserDefaults().integerForKey("noinstructions")
                    if let bid = NSBundle.mainBundle().bundleIdentifier {
                        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(bid)
                    }
                    NSUserDefaults.standardUserDefaults().setInteger(noinstructions, forKey: "noinstructions")
                    NSUserDefaults.standardUserDefaults().synchronize()
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

    @IBAction func customise(sender: AnyObject) {
            self.performSegueWithIdentifier("gotolist", sender: nil)

    }

}



