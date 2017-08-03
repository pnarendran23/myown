
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
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class listofassets: UIViewController, UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate, WCSessionDelegate {
    var assets = NSMutableDictionary()
    var token = ""
    var size = 0
    var tobefiltered = NSMutableArray()
    var task = URLSessionTask()
    var download_requests = [URLSession]()
    var listobuildings = NSMutableArray()
    var domain_url = ""
    var emptydict = ["count": 1,"created_at_max": "2016-12-30T14:02:41.260478Z","created_at_min": "2016-12-30T14:02:41.260478Z","energy_avg": 0,"water_avg": 0,"waste_avg": 0,"transport_avg": 0,"base_avg": 0,"human_experience_avg": 0] as [String : Any]
    var page = 2
    var timer = Timer()
    var isloading = false
    var tempfilter = NSMutableArray()
    var filterarr = ([["My cities"] ,["My communities"] ,["My Transit","My parking","My buildings"] ,["All"] ] as! NSArray).mutableCopy() as! NSMutableArray
    @IBOutlet weak var spinner: UIView!
    @IBOutlet weak var allprojectslbl: UILabel!
    
    @IBOutlet weak var segctrl: UISegmentedControl!
    
    
    @IBOutlet weak var globebtn: UIButton!
    @IBOutlet weak var logout: UIButton!
    var countries = NSMutableDictionary()
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    var buildingarr = NSMutableArray()
    var fullstatename = ""
    var fullcountryname = ""
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        
        return .lightContent
        
    }
    
    @available(iOS 9.3, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    @available(iOS 9.0, *)
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    var addbuttonsize = CGFloat(0)
    
    func viewswitch(_ sender: UISegmentedControl){
        if(sender.tag == 123){
            if(sender.selectedSegmentIndex == 1){
                customize(UIButton())
            }
        }
    }
    @IBOutlet weak var addbutton: UIButton!
    
    
    
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        //stop all download requests
        timer.invalidate()
        for request in download_requests
        {
            request.invalidateAndCancel()
        }
        if (WCSession.isSupported()) {
            watchsession.delegate = nil;
        }
    }
    
    @IBAction func globalsel(_ sender: AnyObject) {
        
        //<- change to where you want it to show.
        //Set the customView properties
        filterview.isHidden = false
        filterview.frame.origin.y = -1 * UIScreen.main.bounds.size.height
        //Add the customView to the current view
        //Display the customView with animation
        UIView.animate(withDuration: 0.7, animations: {() -> Void in
            self.filterview.frame.origin.y = 0
            }, completion: {(finished: Bool) -> Void in
        })

    }
    
    @IBAction func addproject(_ sender: AnyObject) {
        //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"addproject"])
        //
        var alertController = UIAlertController()
        let buildings = UIAlertAction(title: "Buildings", style: .default, handler: { action in
            self.type = "building"
            self.performSegue(withIdentifier: "addnewbuilding", sender: nil)
        })
        let cities = UIAlertAction(title: "Cities", style: .default, handler: {action in
            self.type = "cities"
            self.performSegue(withIdentifier: "managecities", sender: nil)
        
        })
        let communities = UIAlertAction(title: "Communities", style: .default, handler: {action in
            self.type = "communities"
            self.performSegue(withIdentifier: "managecities", sender: nil)            
        })
        
        let transportation = UIAlertAction(title: "Transportation", style: .default, handler: {action in
            self.type = "transit"
             self.performSegue(withIdentifier: "addnewbuilding", sender: nil)
        })
        
        let parksmart = UIAlertAction(title: "Parking", style: .default, handler: {action in
            self.type = "parksmart"
            self.performSegue(withIdentifier: "addnewbuilding", sender: nil)
        })
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad){
            alertController = UIAlertController(title: "Create a new project", message: "Please select the type of project you want to create", preferredStyle: .alert)
        }else{
            alertController = UIAlertController(title: "Create a new project", message: "Please select the type of project you want to create", preferredStyle: .actionSheet)
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alertController.addAction(buildings)
        alertController.addAction(cities)
        alertController.addAction(communities)
        alertController.addAction(transportation)
        alertController.addAction(parksmart)
        alertController.view.subviews.first?.backgroundColor = UIColor.white
        alertController.view.layer.cornerRadius = 10
        alertController.view.layer.masksToBounds = true
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func adjustit(){
        let segmentButton = self.view.viewWithTag(123) as! UISegmentedControl
        segmentButton.frame = segctrl.frame
        segmentButton.frame.size.height = searchbar.frame.size.height
        segmentButton.selectedSegmentIndex = 0
        segmentButton.tag = 123
    }
    
    @IBOutlet weak var filterbtn: UIButton!
    
    @IBAction func filter(_ sender: AnyObject) {
        //filterview.hidden = false
        self.performSegue(withIdentifier: "filterproj", sender: nil)
    }
    var type = ""
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(searchbar.becomeFirstResponder()){
            searchbar.resignFirstResponder()
        }
        if(segue.identifier == "gotologin"){
            
        }else{
            let d = NSKeyedArchiver.archivedData(withRootObject: tobefiltered)
            UserDefaults.standard.set(d, forKey: "tobefiltered")
            UserDefaults.standard.set(searchbar.text!, forKey: "searchtext")
        if(segue.identifier == "filterproj"){
            let v = segue.destination as! filterprojects
            v.filterarr = filterarr            
            v.tobefiltered = tobefiltered
        }else if(segue.identifier == "gotogrid"){
            let v = segue.destination as! UINavigationController
            let va = v.viewControllers[0] as! gridviewcontroller
            va.filterarr = filterarr
            va.tobefiltered = tobefiltered
        }else if(segue.identifier == "managecities"){
            let v = segue.destination as! managecity
            v.type = type
            
        }else if(segue.identifier == "addnewbuilding"){
            let v = segue.destination as! newproject
            v.type = type
            
            }}
        
    }
    
    
    @IBAction func donebutton(_ sender: UIBarButtonItem) {
        sayHello(sender)
    }
    @IBAction func filterbutton(_ sender: UIBarButtonItem) {
        filter(sender)
    }
    var humanexarray = NSMutableArray()
    var transportationarray = NSMutableArray()
    @IBOutlet weak var filtertable: UITableView!
    var watchsession = WCSession.default()
    
    
    var fontsize = CGFloat(0)
    var fontsize1 = CGFloat(0)
    override func viewDidLoad() {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            // It's an iPhone
            size = 7
            fontsize = 0.03
            fontsize1 = 0.05
            break
        case .pad:
            size = 12
            fontsize = 0.02
            fontsize1 = 0.03
            // It's an iPad
            
            break
        case .unspecified:
            size = 7
            fontsize = 0.03
            fontsize1 = 0.05
            break
            
        default :
            size = 5
            fontsize = 0.03
            fontsize1 = 0.05            
            // Uh, oh! What could it be?
        }
        self.titlefont()
        
        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.none
        //self.navigationController!.hidesBarsOnTap = false;
        //self.navigationController!.hidesBarsOnSwipe = false;
        //self.navigationController!.hidesBarsWhenVerticallyCompact = false;
        if(UserDefaults.standard.object(forKey: "humanexarray") != nil){
        humanexarray = (UserDefaults.standard.object(forKey: "humanexarray") as! NSArray).mutableCopy() as! NSMutableArray
        }
        if(UserDefaults.standard.object(forKey: "transportationarray") != nil){
            transportationarray = (UserDefaults.standard.object(forKey: "transportationarray") as! NSArray).mutableCopy() as! NSMutableArray
        }
        //segctrl.hidden = true
        if(tobefiltered.count == 0){
        filterview.isHidden = true
        var a = NSMutableArray()
        a.add("")
        tobefiltered.add(a)
        a = NSMutableArray()
        a.add("")
        tobefiltered.add(a)
        a = NSMutableArray()
        a.add("")
        a.add("")
        a.add("")
        tobefiltered.add(a)
        
        a = NSMutableArray()
        a.add("all")
        tobefiltered.add(a)
        }
        addbutton.layer.cornerRadius = (addbutton.layer.bounds.size.width)/2
                filterbtn.layer.cornerRadius = (filterbtn.layer.bounds.size.width)/2
        let segmentButton: UISegmentedControl!
        segmentButton = UISegmentedControl(items: [self.imageWithImage(UIImage(named: "List.png")!, scaledToSize: CGSize(width: 32, height: 32)), self.imageWithImage(UIImage(named: "grid.png")!, scaledToSize: CGSize(width: 32, height: 32))])
        
        segctrl.setImage(self.imageWithImage(UIImage(named: "List.png")!, scaledToSize: CGSize(width: 25, height: 25)), forSegmentAt: 0)
        segctrl.setImage(self.imageWithImage(UIImage(named: "grid.png")!, scaledToSize: CGSize(width: 25, height: 25)), forSegmentAt: 1)
        self.searchbar.frame.size.height = segctrl.frame.size.height
        self.searchbar.frame.origin.y = segctrl.frame.origin.y
        segctrl.frame.size.height = searchbar.frame.size.height
        segctrl.contentMode = .scaleToFill
        self.navigationItem.title = "Projects"
        let navItem = UINavigationItem(title: "All projects");        
        self.nav.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!]
        let doneItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(sayHello(_:)))
        let filteritem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(filter(_:)))
        navItem.leftBarButtonItem = doneItem;
        navItem.rightBarButtonItem = filteritem;
        self.navigationItem.leftBarButtonItem?.title = ""
        self.navigationItem.rightBarButtonItem?.title = ""
        self.navigationItem.leftBarButtonItem?.image = self.imageWithImage(UIImage(named: "signout.png")!, scaledToSize: CGSize(width: 35, height: 35))
        self.navigationItem.rightBarButtonItem?.image = self.imageWithImage(UIImage(named: "filtericon.png")!, scaledToSize: CGSize(width: 32, height: 32))
        self.navigationItem.leftBarButtonItem?.action = #selector(sayHello(_:))
        self.navigationItem.rightBarButtonItem?.action = #selector(filter(_:))

        nav.setItems([navItem], animated: false);
            
        segctrl.selectedSegmentIndex = 0
        segctrl.tag = 123
        segctrl.addTarget(self, action: #selector(self.viewswitch(_:)), for: UIControlEvents.valueChanged)
        //view.addSubview(segmentButton)

        
        
        self.spinner.layer.cornerRadius = 5
        self.spinner.isHidden = true        
                filterclose.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12)
        self.view.isUserInteractionEnabled = true
        tableview.register(UINib.init(nibName: "buildingcell", bundle: nil), forCellReuseIdentifier: "assetcell")
        var datakeyed = UserDefaults.standard.object(forKey: "assetdata") as! Data
        assets = (NSKeyedUnarchiver.unarchiveObject(with: datakeyed) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        buildingarr = (assets["results"]! as! NSArray).mutableCopy() as! NSMutableArray
        //print(buildingarr.count)
        listobuildings = buildingarr.mutableCopy() as! NSMutableArray
        //print("Buildings arr",buildingarr)
        token = UserDefaults.standard.object(forKey: "token") as! String
         datakeyed = UserDefaults.standard.object(forKey: "assetdata") as! Data
        assets = (NSKeyedUnarchiver.unarchiveObject(with: datakeyed) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        buildingarr = (assets["results"]! as! NSArray).mutableCopy() as! NSMutableArray
        filtertable.selectRow(at: IndexPath.init(row: 4, section: 0), animated: true, scrollPosition: UITableViewScrollPosition.none)
        
    }
    
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        self.tableview.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {     
        super.viewWillAppear(true)        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //plaque
        self.tableview.isUserInteractionEnabled = true
        self.navigationItem.leftBarButtonItem?.isEnabled = true        
        UserDefaults.standard.removeObject(forKey: "performance_data")
        UserDefaults.standard.removeObject(forKey: "comparable_data")
        UserDefaults.standard.removeObject(forKey: "local_comparable_data")
        UserDefaults.standard.removeObject(forKey: "inner_data")
        UserDefaults.standard.removeObject(forKey: "middle_data")
        UserDefaults.standard.removeObject(forKey: "notifications")
        UserDefaults.standard.removeObject(forKey: "building_details")
        UserDefaults.standard.removeObject(forKey: "certification_details")
        
        //actions
        UserDefaults.standard.removeObject(forKey: "actions_data")
        DispatchQueue.main.async(execute: {
            self.spinner.isHidden = true
            self.view.isUserInteractionEnabled = true
            if(UserDefaults.standard.object(forKey: "countries") == nil){
                self.spinner.isHidden = false
                self.view.isUserInteractionEnabled = false
                self.getstates(credentials().subscription_key)
            }
        })
        page = 2
        token = UserDefaults.standard.object(forKey: "token") as! String
        if (WCSession.isSupported()) {
            watchsession = WCSession.default()
            watchsession.delegate = self;
            watchsession.activate()
        }
        searchbar.text = ""
        if(UserDefaults.standard.object(forKey: "searchtext") != nil){
            searchbar.text = UserDefaults.standard.object(forKey: "searchtext") as! String
        }
        if(UserDefaults.standard.object(forKey: "tobefiltered") != nil){
        tobefiltered = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "tobefiltered") as! Data) as! NSMutableArray
        }else{
            
        }
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
            self.navigationItem.title = "My Buildings"
        }
        if(filteredobject == "my cities"){
            self.navigationItem.title = "My Cities"
        }
        
        if(filteredobject == "my communities"){
            self.navigationItem.title = "My Communities"
        }
        
        if(filteredobject == "my parking"){
            self.navigationItem.title = "My Parking"
        }
        
        if(filteredobject == "my transit"){
            self.navigationItem.title = "My Transit"
        }
        
        if(filteredobject == "my Portfolios"){
            self.navigationItem.title = "Portfolios"
        }
        
        if(filteredobject == "my portfolios"){
            buildingarr = (((NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "portfolios") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary)["results"]! as! NSArray).mutableCopy() as! NSMutableArray
        }
        
        if(filteredobject != "all"){
            page = 1
        }
        var datakeyed = UserDefaults.standard.object(forKey: "assetdata") as! Data
        assets = (NSKeyedUnarchiver.unarchiveObject(with: datakeyed) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        buildingarr = (assets["results"]! as! NSArray).mutableCopy() as! NSMutableArray
        
        if(searchbar.text?.characters.count > 0){
         //self.searchBar(searchbar, textDidChange: searchbar.text!)
            var str = searchbar.text! 
            let tempstring = str.replacingOccurrences(of: " ", with: "%20")
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
                self.navigationItem.title = "My Buildings"
            }
            if(filteredobject == "my cities"){
                self.navigationItem.title = "My Cities"
            }
            
            if(filteredobject == "my communities"){
                self.navigationItem.title = "My Communities"
            }
            
            if(filteredobject == "my parking"){
                self.navigationItem.title = "My Parking"
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
            DispatchQueue.main.async(execute: {
                self.tableview.isUserInteractionEnabled = false
        self.navigationItem.leftBarButtonItem?.isEnabled = false
                self.spinner.isHidden = false
            })
            if(timer.isValid){
                timer.invalidate()
            }
            
            urlstr = urlstring
            timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.getsearchbuilding), userInfo: nil, repeats: false)
            
            //timer = Timer.init(timeInterval: 1.5, target: self, selector: Selector(searchbuilding(urlstring)), userInfo: nil, repeats: false)
            
        }else{
        filterok(UIButton())
        }
        DispatchQueue.main.async(execute: {
            
        if(self.buildingarr.count < self.size){
            self.buildingarr = NSMutableArray()
            self.tableview.reloadData()
            self.page = 1
            if(self.isloading == false){
                let c = credentials()
                self.view.isUserInteractionEnabled = false
                self.spinner.isHidden = false
                self.project_type = self.filteredobject
                if(self.project_type == "my portfolios"){
                    self.project_type = "all"
                }else if(self.project_type == "my cities"){
                    self.project_type = "city"
                }else if(self.project_type == "my communities"){
                    self.project_type = "community"
                }else if(self.project_type == "my transit"){
                    self.project_type = "transit"
                }else if(self.project_type == "my parking"){
                    self.project_type = "parksmart"
                }else if(self.project_type == "my buildings"){
                    self.project_type = "building"
                }else{
                    self.project_type = "all"
                }
                
                self.tableview.isUserInteractionEnabled = false
        self.navigationItem.leftBarButtonItem?.isEnabled = false
                self.spinner.isHidden = false
                self.notfound.isHidden = true
                if(self.project_type == "all"){
                    self.loadMoreDataFromServer("\(credentials().domain_url)assets/?page=\(self.page)&page_size=30", subscription_key: c.subscription_key)
                }else{
                    if(self.project_type == "my portfolios"){
                        self.loadMoreDataFromServer("\(credentials().domain_url)portfolios/?&page=\(self.page)", subscription_key: c.subscription_key)
                    }else{
                        self.loadMoreDataFromServer("\(credentials().domain_url)assets/?project_type=\(self.project_type as String)&page=\(self.page)&page_size=30", subscription_key: c.subscription_key)
                    }
                }
            }
    
        }
    })
    
          }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.all
    }
    
    func sayHello(_ sender: UIBarButtonItem) {
        timer.invalidate()
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController(title: "Logout", message: "Would you like to logout from the current user?", preferredStyle: .alert)
            let callActionHandler = { (action:UIAlertAction!) -> Void in
                DispatchQueue.main.async(execute: {
                    UserDefaults.standard.removeObject(forKey: "token")
                    UserDefaults.standard.removeObject(forKey: "username")
                    UserDefaults.standard.removeObject(forKey: "password")
                    UserDefaults.standard.removeObject(forKey: "building_details")
                    let appDomain = Bundle.main.bundleIdentifier!
                    let noinstructions = UserDefaults.standard.integer(forKey: "noinstructions")
                    UserDefaults.standard.removePersistentDomain(forName: appDomain)
                    UserDefaults.standard.removeObject(forKey: "token")
                    UserDefaults.standard.removeObject(forKey: "username")
                    UserDefaults.standard.removeObject(forKey: "password")
                    UserDefaults.standard.removeObject(forKey: "tobefiltered")
                    if let bid = Bundle.main.bundleIdentifier {
                        UserDefaults.standard.removePersistentDomain(forName: bid)
                    }
                    UserDefaults.standard.set(noinstructions, forKey: "noinstructions")
                    UserDefaults.standard.synchronize()
                    self.performSegue(withIdentifier: "gotologin", sender: nil)
                    self.navigationController?.popViewController(animated: true)
                })
                
            }
            
            let cancelActionHandler = { (action:UIAlertAction!) -> Void in
                DispatchQueue.main.async(execute: {
                    self.navigationController?.popViewController(animated: true)
                })
                
            }
            let cancelAction = UIAlertAction(title: "No", style: .default, handler:cancelActionHandler)
            
            let defaultAction = UIAlertAction(title: "Yes", style: .default, handler:callActionHandler)
            
            alertController.addAction(cancelAction)
            alertController.addAction(defaultAction)
            
            alertController.view.subviews.first?.backgroundColor = UIColor.white
        alertController.view.layer.cornerRadius = 10
        alertController.view.layer.masksToBounds = true
            self.present(alertController, animated: true, completion: nil)
            
        })        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
       /* if(tableView == filtertable){
            return 1
        }
       
        if(buildingarr.count>0){
            self.notfound.hidden = true
            self.tableview.hidden = false
        }else{
            self.notfound.hidden = false
            self.tableview.hidden = true
        }
            return 1
        */
        
        
        if(searchbar.text?.characters.count == 0 || searcharr["building"] == nil || searcharr["portfolio"] == nil){
            if(buildingarr.count > 0){
                self.notfound.isHidden = true
            }else{
                self.notfound.isHidden = false
            }
            return buildingarr.count
        }else{
            if((searcharr["building"] as! NSArray).count == 0){
                self.notfound.isHidden = false
            }else{
                self.notfound.isHidden = true
            }
            return (searcharr["building"] as! NSArray).count
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == filtertable){
            return 5
        }
        return 1
    }
    
    var searcharr = NSMutableDictionary()
    
    func showalert(_ message:String, title:String, action:String){
        
        //let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        //let callActionHandler = { (action:UIAlertAction!) -> Void in
        DispatchQueue.main.async(execute: {
            
            self.tableview.isUserInteractionEnabled = true
        self.navigationItem.leftBarButtonItem?.isEnabled = true
            self.view.isUserInteractionEnabled = true
            self.spinner.isHidden = true
            self.view.isUserInteractionEnabled = true
            self.maketoast(message, type: "error")
            //self.navigationController?.popViewControllerAnimated(true)
        })
        
        //        }
        //      let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        //    alertController.addAction(defaultAction)
        
        //presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    
    func getstates(_ subscription_key:String){
        let url = URL.init(string:String(format: "%@country/states/",credentials().domain_url))
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
                //print("error=\(error)")
                //NSNotificationCenter.defaultCenter().postNotificationName("notifyclose", object: nil)
                if(error?._code == -999){
                    
                }else{
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                }
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
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
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
                        self.spinner.isHidden = true
                        self.view.isUserInteractionEnabled = true                        
                        let data = NSKeyedArchiver.archivedData(withRootObject: jsonDictionary)
                        UserDefaults.standard.set(data, forKey: "countries")
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
    var filteredobject = ""
    var project_type = ""
    @IBAction func filterok(_ sender: AnyObject) {
        //print("listofbuildings ",listobuildings)
        //print("Filter asv ",filteredobject)
        //print("Updated buildingarr count",buildingarr.count)
        filterview.isHidden = true
        var temparr = NSMutableArray()
        self.listobuildings = self.buildingarr
        if(searchbar.text?.characters.count > 0){
            if(filteredobject == "all"){
                self.navigationItem.title = "All projects"
            }
            if(filteredobject == "my buildings"){
                self.navigationItem.title = "My Buildings"
            }
            if(filteredobject == "my cities"){
                self.navigationItem.title = "My Cities"
            }
            
            if(filteredobject == "my communities"){
                self.navigationItem.title = "My Communities"
            }
            
            if(filteredobject == "my parking"){
                self.navigationItem.title = "My Parking"
            }
            
            if(filteredobject == "my transit"){
                self.navigationItem.title = "My Transit"
            }
            
            if(filteredobject == "my Portfolios"){
                self.navigationItem.title = "Portfolios"
            }

        }
        if(filteredobject == "my portfolios" || filteredobject == "all" || filteredobject == "my buildings"){
            temparr = self.buildingarr
                if(filteredobject == "all"){
                    self.navigationItem.title = "All projects"
                }
                if(filteredobject == "my buildings"){
                    self.navigationItem.title = "My Buildings"
                }
                if(filteredobject == "my cities"){
                    self.navigationItem.title = "My Cities"
                }
                
                if(filteredobject == "my communities"){
                    self.navigationItem.title = "My Communities"
                }
                
                if(filteredobject == "my parking"){
                    self.navigationItem.title = "My Parking"
                }
                
                if(filteredobject == "my transit"){
                    self.navigationItem.title = "My Transit"
                }
                
                if(filteredobject == "my Portfolios"){
                    self.navigationItem.title = "Portfolios"
                }
        }
        if(filteredobject == "my buildings"){
            temparr = NSMutableArray()
            project_type = "building"
            for index in 0..<listobuildings.count {
                let data = (listobuildings.object(at: index) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                if(data["project_type"] != nil){
                    if(data["project_type"] as! String == "building"){
                        temparr.add(data)
                    }
                }
            }
        }
        
        if(filteredobject == "my cities"){
            project_type = "city"
            for i in 0..<listobuildings.count{
                let data = (listobuildings.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                if(data["project_type"] != nil){
                    if(data["project_type"] as! String == "city"){
                        temparr.add(data)
                    }
                }
            }
        }else if(filteredobject == "my communities"){
            project_type = "community"
            for i in 0..<listobuildings.count{
                let data = (listobuildings.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                if(data["project_type"] != nil){
                    if(data["project_type"] as! String == "community"){
                        temparr.add(data)
                    }
                }
            }
        }else if(filteredobject == "my parking"){
            project_type = "parksmart"
            for i in 0..<listobuildings.count{
                let data = (listobuildings.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                if(data["project_type"] != nil){
                    if(data["project_type"] as! String == "parksmart"){
                        temparr.add(data)
                    }
                }
            }
        }else if(filteredobject == "my transit"){
            project_type = "transit"
            for i in 0..<listobuildings.count{
                let data = (listobuildings.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                if(data["project_type"] != nil){
                    if(data["project_type"] as! String == "transit"){
                        temparr.add(data)
                    }
                }
            }
        }else if(filteredobject == "all"){
            temparr = NSMutableArray()
            listobuildings = buildingarr
            for i in 0..<listobuildings.count{
                let data = (listobuildings.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                if(data["project_type"] != nil){
                        temparr.add(data)
                }
            }
            
        }
        
        let keys = NSMutableSet()
        let result = NSMutableArray()
        
        for d in temparr{
            let dict = d as! NSDictionary
            let key = "\(dict["leed_id"] as! Int)"
            if(keys.contains(key)){
                continue
            }
            keys.add(key)
            result.add(d)
        }
        print(result)
        temparr = NSMutableArray.init(array: result)
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
            //print("Count",listobuildings.count)
            //if(tobefiltered.containsObject("buildings")){
            if(filteredobject == "my buildings"){
                project_type = "building"
                for index in 0..<listobuildings.count {
                    let data = listobuildings.objectAtIndex(index) as! NSMutableDictionary
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
                    let data = listobuildings.objectAtIndex(i) as! NSMutableDictionary
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
                    let data = listobuildings.objectAtIndex(i) as! NSMutableDictionary
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
                    let data = listobuildings.objectAtIndex(i) as! NSMutableDictionary
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
                    let data = listobuildings.objectAtIndex(i) as! NSMutableDictionary
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
        DispatchQueue.main.async(execute: {
            self.buildingarr = temparr.mutableCopy() as! NSMutableArray
            self.tableview.reloadData()
        })
        
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == tableview){
        if(UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height){
        return 0.166 * UIScreen.main.bounds.size.height;
        }
        return 0.166 * UIScreen.main.bounds.size.width;
        }
        return 50
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if(tableView == filtertable){
            let cell = tableView.cellForRow(at: indexPath)!
                cell.accessoryType = UITableViewCellAccessoryType.none
                        tobefiltered.replaceObject(at: indexPath.section, with: "")
        }
        //print("To be filtered",tobefiltered)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchbar.resignFirstResponder()
            UserDefaults.standard.set(0, forKey: "grid")
            if(UserDefaults.standard.integer(forKey: "survey") == 1){
                UserDefaults.standard.removeObject(forKey: "building_details")
            }
            UserDefaults.standard.set(0, forKey: "survey")        
        tableView.deselectRow(at: indexPath, animated: true)
            
        let currentbuilding = (buildingarr[indexPath.section] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            var project_type = ""
            if(currentbuilding["project_type"] != nil){
                project_type = currentbuilding["project_type"] as! String
                typ = project_type
            }
            if let update = currentbuilding["building_status"] as? String {
                if(update == "activated_payment_done" || update == "activated_under_review"){
                    self.spinner.isHidden = false
                    self.view.isUserInteractionEnabled = false
            let currentleedid = currentbuilding["leed_id"] as! Int
            UserDefaults.standard.set(currentleedid, forKey: "leed_id")
            let c = credentials()
            domain_url = c.domain_url
            let dte = Date()
            var dateformat = DateFormatter()
            dateformat.dateFormat = "yyyy-MM-dd"
            let datee = dateformat.string(from: dte)
            //print(datee)
        countries = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "countries") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        
        var tempdict = (countries["countries"] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            if(currentbuilding["country"] != nil){
            if(tempdict[currentbuilding["country"] as! String] != nil){
        fullcountryname = tempdict[currentbuilding["country"] as! String]! as! String
            var divisions = (countries["divisions"] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            if(divisions[currentbuilding["country"] as! String] is NSMutableDictionary){
                let d = countries["divisions"] as! NSDictionary
        tempdict = (d[currentbuilding["country"] as! String] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            }
         for (i,value) in tempdict{
            let key = i as! String
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
            
                    UserDefaults.standard.set(0, forKey: "swindex")
                    let n = NSMutableArray()
                    UserDefaults.standard.set(1, forKey: "transithide")
                    UserDefaults.standard.set(1, forKey: "humanhide")
                    UserDefaults.standard.set(0, forKey: "index")
                    UserDefaults.standard.set(indexPath.section, forKey: "currentrow")
                    UserDefaults.standard.set(n, forKey: "mainarray")
                    
                    var notexists = 0
                    // New Logic for storing the route values
                    let leedid = "\(currentbuilding["leed_id"] as! Int)"
                    let lid = leedid
                    //print("Trans array is \(transportationarray)")
                    //print("Human array is \(humanexarray)")
                    for i in 0..<transportationarray.count {
                        let a = transportationarray[i] as! NSArray
                        if (a.count == 2) {
                            let leedid = a[0] as! String
                            if lid == leedid {
                                UserDefaults.standard.set((a[1] as! NSArray).mutableCopy() as! NSMutableArray, forKey: "mainarray")
                                UserDefaults.standard.set("\(leedid)", forKey: "transportbuildingid")
                                notexists = 1
                                UserDefaults.standard.set(0, forKey: "transithide")
                                break
                            }
                        }
                    }
                    if (transportationarray.count == 0) || (notexists != 1) {
                        UserDefaults.standard.set(leedid, forKey: "transportbuildingid")
                    }
                    notexists = 0
                    for i in 0..<humanexarray.count {
                        let a = humanexarray[i] as! NSArray
                        if a.count == 2 {
                            let leedid = a[0] as! String
                            if lid == leedid {
                                UserDefaults.standard.set(a[1], forKey: "experiencearr")
                                UserDefaults.standard.set("\(leedid)", forKey: "humanbuildingid")
                                notexists = 1
                                UserDefaults.standard.set(0, forKey: "humanhide")
                                break
                            }
                        }
                    }
                    if humanexarray.count == 0 {
                        var aa = [AnyObject]()
                        let x = [AnyObject]()
                        aa.append("5" as AnyObject)
                        aa.append(x as AnyObject)
                        UserDefaults.standard.set(aa, forKey: "experiencearr")
                        humanexarray.add(aa)
                        UserDefaults.standard.set(leedid, forKey: "humanbuildingid")
                    }
                    else if notexists != 1 {
                        var aa = [AnyObject]()
                        let x = [AnyObject]()
                        aa.append("5" as AnyObject)
                        aa.append(x as AnyObject)
                        UserDefaults.standard.set(aa, forKey: "experiencearr")
                        humanexarray.add(aa)
                        UserDefaults.standard.set(leedid, forKey: "humanbuildingid")
                    }
                    var array = NSMutableArray()
                    if(UserDefaults.standard.object(forKey: "temp") != nil){
                    array = NSMutableArray.init(array: (UserDefaults.standard.object(forKey: "temp") as! NSArray).mutableCopy() as! NSMutableArray)
                    }
                    UserDefaults.standard.set(array, forKey: "temp")
                    if(UserDefaults.standard.object(forKey: "image") != nil){
                    array = NSMutableArray.init(array: (UserDefaults.standard.object(forKey: "image") as! NSArray).mutableCopy() as! NSMutableArray)
                    }
                    array.removeAllObjects()
                    UserDefaults.standard.set(array, forKey: "image")
                    if(currentbuilding["key"] != nil){
                    let key = currentbuilding["key"] as! String
                    UserDefaults.standard.set(key, forKey: "key")
                    }
                    UserDefaults.standard.set("\(currentbuilding["leed_id"] as! Int)", forKey: "leed_id")
                    
                    let hot=0;
                    UserDefaults.standard.set(hot, forKey: "hot")
                    UserDefaults.standard.set(hot, forKey: "dirty")
                    UserDefaults.standard.set(hot, forKey: "dark")
                    UserDefaults.standard.set(hot, forKey: "loud")
                    UserDefaults.standard.set(hot, forKey: "smelly")
                    UserDefaults.standard.set(hot, forKey: "cold")
                    UserDefaults.standard.set(hot, forKey: "stuffy")
                    UserDefaults.standard.set(hot, forKey: "privacy")
                    UserDefaults.standard.set(hot, forKey: "other")
                    UserDefaults.standard.set(hot, forKey: "glare")
                    UserDefaults.standard.set("", forKey: "vvtext")
                    UserDefaults.standard.set(hot, forKey: "iteration")
                    UserDefaults.standard.set("", forKey: "smileyvalue")
                    if(UserDefaults.standard.object(forKey: "listofrowsforhuman") != nil){
                    let ar = NSMutableArray.init(array: (UserDefaults.standard.object(forKey: "listofrowsforhuman") as! NSArray).mutableCopy() as! NSMutableArray)
                    let current = UserDefaults.standard.integer(forKey: "humanbuildingid")
                    dateformat = DateFormatter()
                    dateformat.dateFormat = "dd/MM/YYYY"
                    let date_string = dateformat.string(from: Date())
                    for m in 0..<ar.count{
                        let a = (ar.object(at: m) as! NSArray).mutableCopy() as! NSMutableArray
                        let x = Int(a.object(at: 0) as! String)
                        let date = a.object(at: 1) as! String
                        if(x == current){
                            if(date_string == date){
                                UserDefaults.standard.set(0, forKey: "humanhide")
                                break
                            }else{
                                UserDefaults.standard.set(1, forKey: "humanhide")
                            }
                        }else{
                            UserDefaults.standard.set(1, forKey: "humanhide")
                        }
                        
                    }
                    }
                    
       
                    
                    
                    //NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "transithide")
                    //NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "humanhide")

                    
            DispatchQueue.main.async(execute: {
                let nsDict2 = currentbuilding as NSDictionary as! [AnyHashable: Any]
                if(UserDefaults.standard.object(forKey: "building_details") != nil){
                let current_dict = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary
                    if(current_dict["leed_id"] as! Int == nsDict2["leed_id"] as! Int){
                        let datakeyed = NSKeyedArchiver.archivedData(withRootObject: current_dict)
                        UserDefaults.standard.set(datakeyed, forKey: "building_details")
                        UserDefaults.standard.set(current_dict["leed_id"] as! Int, forKey: "leed_id")
                    let a = NSMutableArray()
                    let x = NSArray()
                    a.add("5")
                    a.add(x)
                    UserDefaults.standard.set(a, forKey: "experiencearr")
                    UserDefaults.standard.set("\(current_dict["leed_id"] as! Int)", forKey: "humanbuildingid")
                        //NSDictionary(dictionary: current_dict).isEqualToDictionary(nsDict2)){
                        
                        //Existing ARM APIs
                        self.buildingdetails(c.subscription_key, leedid: currentleedid)
                        //self.performSegueWithIdentifier("gotodashboard", sender: nil)
                    }else{
                        self.spinner.isHidden = false
                        self.view.isUserInteractionEnabled = false
                      //Existing ARM APIs
                        self.buildingdetails(c.subscription_key, leedid: currentleedid)
                        //self.getperformancedata(c.subscription_key, leedid: currentleedid, date: datee)
                    }
                }else{
                    self.spinner.isHidden = false
                    self.view.isUserInteractionEnabled = false
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
            }else if(project_type == "parksmart"){
                    //print("Parksmart")
                    self.spinner.isHidden = false
                    self.view.isUserInteractionEnabled = false
                    let datakeyed = NSKeyedArchiver.archivedData(withRootObject: currentbuilding)
                    //NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "building_details")
                    //NSUserDefaults.standardUserDefaults().synchronize()
                    //self.performSegueWithIdentifier("gotoparking", sender: nil)
                    DispatchQueue.main.async(execute: {
                        self.spinner.isHidden = false
                        self.view.isUserInteractionEnabled = false
                        UserDefaults.standard.set(currentbuilding["leed_id"] as! Int, forKey: "leed_id")
                        UserDefaults.standard.set(currentbuilding["key"], forKey: "key")
                        self.buildingdetails(credentials().subscription_key, leedid: currentbuilding["leed_id"] as! Int)
                    })
                }
            }
        //https://api.usgbc.org/leed/assets/LEED:1000137566/scores/?at=2016-11-07
    }
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        /*if(tableView == tableview){
            let favorite = UITableViewRowAction(style: .Destructive, title: "Delete") { action, index in
                //print("deleted")
            }
            favorite.backgroundColor = UIColor.redColor()
            
            let share = UITableViewRowAction(style: .Normal, title: "Share") { action, index in
                //print("Shared")
            }
            share.backgroundColor = UIColor.blueColor()
            
            return [share, favorite]
        }*/
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

        return false
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if(tableView == tableview){
            
        }
        // you need to implement this method too or you can't swipe to display the actions
    }
    
    
    
    func getperformancedata(_ subscription_key:String, leedid: Int, date : String){
        let url = URL.init(string: String(format: "%@assets/LEED:%d/scores/",domain_url,leedid))
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
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    if(error?._code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
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
                    UserDefaults.standard.set(datakeyed, forKey: "performance_data")
                    UserDefaults.standard.synchronize()
                    DispatchQueue.main.async(execute: {() -> Void in
                        if #available(iOS 9.0, *) {
                            if WCSession.isSupported() {
                                var dict = NSMutableDictionary()
                                if(jsonDictionary["scores"] == nil){
                                    dict["energy"] = 0
                                    dict["base"] = 0
                                    dict["water"] = 0
                                    dict["waste"] = 0
                                    dict["transport"] = 0
                                    dict["human_experience"] = 0
                                }else{
                                    var scores = (jsonDictionary["scores"] as! NSDictionary).mutableCopy() as! NSMutableDictionary
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
                                DispatchQueue.main.async(execute: {
                                    self.watchsession.sendMessage(dict as! [String : Any], replyHandler: nil, errorHandler: { (error) -> Void in
                                        
                                    })
                                    do{
                                        try self.watchsession.updateApplicationContext(dict as! [String : Any])
                                    }catch{
                                        
                                    }
                                    
                                    
                                })
                            }
                        } else {
                            // Fallback on earlier versions
                        }
                        self.getmiddledata(subscription_key, leedid: leedid, date: date)
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
    
    
    @available(iOS 9.0, *)
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        
    }

    func getmiddledata(_ subscription_key:String, leedid: Int, date : String){
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.long
        formatter.dateFormat = "yyyy-MM-01"
        let dateString = formatter.string(from: Date())
        //print(dateString)
        let url = URL.init(string: String(format: "%@assets/LEED:%d/scores/?at=%@&within=1",domain_url,leedid,dateString))
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
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    if(error?._code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                    
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
                        UserDefaults.standard.set(datakeyed, forKey: "middle_data")
                        UserDefaults.standard.synchronize()
                        self.getinnerdata(subscription_key, leedid: leedid, date: date)
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

    
    func getinnerdata(_ subscription_key:String, leedid: Int, date : String){
        let date = Date()
        let formatter = DateFormatter()
        let unitFlags: NSCalendar.Unit = [.hour, .day, .month, .year]
        var components = (Calendar.current as NSCalendar).components(unitFlags, from: date)
        components.year = components.year! - 1
        components.month = components.month! + 1
        let d = Calendar.current.date(from: components)
        formatter.dateFormat = "yyyy-MM-01"
        let datestring = formatter.string(from: d!)
        
        
        
        let url = URL.init(string: String(format: "%@assets/LEED:%d/scores/?at=%@&within=1",domain_url,leedid,datestring))
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
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    if(error?._code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                    
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
                        UserDefaults.standard.set(datakeyed, forKey: "inner_data")
                        UserDefaults.standard.synchronize()
                        self.buildingdetails(subscription_key, leedid: leedid)
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

    
    func getcomparablesdata(_ subscription_key:String, leedid: Int){
        let url = URL.init(string: String(format: "%@comparables/",domain_url))
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
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    if(error?._code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                    
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
                    UserDefaults.standard.set(datakeyed, forKey: "comparable_data")
                    UserDefaults.standard.synchronize()
                    DispatchQueue.main.async(execute: {
                        self.getnotifications(subscription_key,leedid: UserDefaults.standard.integer(forKey: "leed_id"),type:self.typ)
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
    var typ = ""
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(searchbar.text?.characters.count > 0){
        if(section == 0){
         //   return "Buildings"
        }
//        return "Portfolios"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(searchbar.text?.characters.count > 0){
        //return 35
        }
        return 1
    }
    
    func getlocalcomparablesdata(_ subscription_key:String, leedid: Int, state: String){
        //print(state)
        let url = URL.init(string:"\(credentials().domain_url as String)comparables/?state=\(state)")
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
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    if(error?._code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                    
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
                    UserDefaults.standard.set(datakeyed, forKey: "local_comparable_data")
                    UserDefaults.standard.synchronize()
                    DispatchQueue.main.async(execute: {
                        self.getcomparablesdata(subscription_key, leedid: leedid)
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
    
    
    
    func buildingdetails(_ subscription_key:String, leedid: Int){
        let url = URL.init(string: String(format: "%@assets/LEED:%d/",credentials().domain_url,leedid))
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
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    if(error?._code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                    
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
                    if(jsonDictionary["key"] != nil){
                        let key = jsonDictionary["key"] as! String
                        UserDefaults.standard.set(key, forKey: "key")
                    }
                    UserDefaults.standard.set(datakeyed, forKey: "building_details")
                    UserDefaults.standard.synchronize()
                    
                    if let s = jsonDictionary["state"] as? String{
                        DispatchQueue.main.async(execute: {
                            //print(s)
                            if(s != ""){
                                //print(String(format: "%@%@",jsonDictionary["country"] as! String,s))
                                let str = jsonDictionary["country"] as! String
                                let decimalCharacters = CharacterSet.decimalDigits
                                
                                let decimalRange = str.rangeOfCharacter(from: decimalCharacters, options: NSString.CompareOptions() , range: nil)
                                
                                if (decimalRange != nil){
                                    let datakeyed = NSKeyedArchiver.archivedData(withRootObject: self.emptydict)
                                    UserDefaults.standard.set(datakeyed, forKey: "local_comparable_data")
                                    UserDefaults.standard.synchronize()
                                    //self.getcomparablesdata(subscription_key, leedid: leedid)
                                    
                                    //Existing ARM APIs
                                    
                                }else{
                        //Existing ARM APIsself.getlocalcomparablesdata(subscription_key, leedid: leedid, state: String(format: "%@%@",jsonDictionary["country"] as! String,s))
                                    //self.performSegueWithIdentifier("gotodashboard", sender: nil)
                                    DispatchQueue.main.async(execute: {
                                        if(jsonDictionary["project_type"] as! String == "parksmart"){
                                            self.spinner.isHidden = true
                                            self.view.isUserInteractionEnabled = true
                                            self.performSegue(withIdentifier: "gotoparking", sender: nil)
                                        }else{
                                            self.getteamdata(leedid: leedid)
                                        }
                                    })
                                }
                            }else{
                                let datakeyed = NSKeyedArchiver.archivedData(withRootObject: self.emptydict)
                                UserDefaults.standard.set(datakeyed, forKey: "local_comparable_data")
                                UserDefaults.standard.synchronize()
                                //self.getcomparablesdata(subscription_key, leedid: leedid)
                                //Existing ARM APIs
                                //self.performSegueWithIdentifier("gotodashboard", sender: nil)
                                DispatchQueue.main.async(execute: {
                                    if(jsonDictionary["project_type"] as! String == "parksmart"){
                                        self.spinner.isHidden = true
                                        self.view.isUserInteractionEnabled = true
                                        self.performSegue(withIdentifier: "gotoparking", sender: nil)
                                    }else{
                                        self.getteamdata(leedid: leedid)
                                    }
                                })
                            }
                            
                            })
                            

                    }else{
                        let datakeyed = NSKeyedArchiver.archivedData(withRootObject: self.emptydict)
                        UserDefaults.standard.set(datakeyed, forKey: "local_comparable_data")
                        UserDefaults.standard.synchronize()
                        //self.getcomparablesdata(subscription_key, leedid: leedid)
                        //Existing ARM APIs
                        DispatchQueue.main.async(execute: {
                            if(jsonDictionary["project_type"] as! String == "parksmart"){
                                self.spinner.isHidden = true
                                self.view.isUserInteractionEnabled = true
                                self.performSegue(withIdentifier: "gotoparking", sender: nil)
                            }else{
                                self.spinner.isHidden = true
                                self.view.isUserInteractionEnabled = true
                                self.performSegue(withIdentifier: "gotodashboard", sender: nil)
                            }
                        })
                    }
                    
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

    
    func getteamdata(leedid:Int){
        //
        let url = URL.init(string:String(format: "%@assets/LEED:%d/teams/",credentials().domain_url,leedid))
        ////print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
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
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    self.maketoast("Sorry, You have no access to this project", type: "error")
                    })
                }else{
                    
                    var jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        //print(jsonDictionary)
                        DispatchQueue.main.async(execute: {
                            self.getnotifications(credentials().subscription_key, leedid: leedid, type: self.typ)
                        })
                        
                    } catch {
                        //print(error)
                    }
            }
            
        })
        task.resume()
    }

    
    
    
    func certdetails(_ subscription_key:String, leedid: Int){
        let url = URL.init(string: String(format: "%@assets/LEED:%d/certifications/",domain_url,leedid))
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
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    if(error?._code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                    
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
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for httCALayer * individualforiphone = [CALayer layer];
                    //[self.layer addSublayer:individualforiphone];
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    let jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        if(jsonDictionary["error"] != nil){
                            if let snapshotValue = jsonDictionary["error"] as? NSArray, let currentcountr = snapshotValue[0] as? NSDictionary, let currentstat = currentcountr["message"] as? String {
                                self.showalert(currentstat, title: "Error", action: "OK")
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
                
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print(jsonDictionary)
                    let datakeyed = NSKeyedArchiver.archivedData(withRootObject: jsonDictionary)
                    UserDefaults.standard.set(datakeyed, forKey: "certification_details")
                    
                    DispatchQueue.main.async(execute: {

                        self.spinner.isHidden = true
                        self.view.isUserInteractionEnabled = true
                    UserDefaults.standard.set(0, forKey: "grid")
                    self.performSegue(withIdentifier: "gotodashboard", sender: nil)
                    })
                    
                } catch {
                    DispatchQueue.main.async(execute: {
                        let jsonDictionary : NSDictionary
                        do {
                            jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                            if(jsonDictionary["error"] != nil){
                                if let snapshotValue = jsonDictionary["error"] as? NSArray, let currentcountr = snapshotValue[0] as? NSDictionary, let currentstat = currentcountr["message"] as? String {
                                    self.showalert(currentstat, title: "Error", action: "OK")
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
            
        }) 
        task.resume()
    }

    @IBOutlet weak var filterclose: UIButton!
    
    @IBAction func closefilter(_ sender: AnyObject) {
        filterview.isHidden = true
    }
    @IBOutlet weak var filterview: UIView!
    
    @IBOutlet weak var notfound: UILabel!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == filtertable){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            cell.tintColor = UIColor.blue
            if(tobefiltered.object(at: indexPath.section) as? String != ""){
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
                cell.selectionStyle = UITableViewCellSelectionStyle.none
            }else{
            cell.accessoryType = UITableViewCellAccessoryType.none
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            }
            //cell.textLabel?.text = filterarr[indexPath.section]
            return cell
        }
        //== 'activated_payment_done'
        let cell = tableView.dequeueReusableCell(withIdentifier: "assetcell", for: indexPath) as! buildingcell
        if(searchbar.text?.characters.count == 0 || searcharr["building"] == nil || searcharr["portfolio"] == nil){
        let arr = (buildingarr[indexPath.section] as! NSDictionary).mutableCopy() as! NSMutableDictionary
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
        tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Semibold", size: fontsize1 * UIScreen.main.bounds.size.width)!, range: NSMakeRange(0, tempostring.length))
        actualstring.append(tempostring.mutableCopy() as! NSAttributedString)
        tempostring.deleteCharacters(in: NSMakeRange(0, tempostring.length))
        tempostring = NSMutableAttributedString(string:"\n")
        actualstring.append(tempostring.mutableCopy() as! NSAttributedString)
        tempostring.deleteCharacters(in: NSMakeRange(0, tempostring.length))
        if(arr["street"] != nil){
        tempostring = NSMutableAttributedString(string:(arr["street"] as! String).capitalized)
        }
        tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: NSMakeRange(0, tempostring.length))
        tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans", size: fontsize * UIScreen.main.bounds.size.width)!, range: NSMakeRange(0, tempostring.length))
        actualstring.append(tempostring.mutableCopy() as! NSAttributedString)
        tempostring.deleteCharacters(in: NSMakeRange(0, tempostring.length))
        tempostring = NSMutableAttributedString(string:" ")
        actualstring.append(tempostring.mutableCopy() as! NSAttributedString)
        tempostring.deleteCharacters(in: NSMakeRange(0, tempostring.length))
        
        if(arr["city"] != nil){
        tempostring = NSMutableAttributedString(string:(arr["city"] as! String).capitalized)
        }
        tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: NSMakeRange(0, tempostring.length))
        tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans", size: fontsize * UIScreen.main.bounds.size.width)!, range: NSMakeRange(0, tempostring.length))
        actualstring.append(tempostring.mutableCopy() as! NSAttributedString)
        cell.namelbl.adjustsFontSizeToFitWidth = true
        cell.namelbl.attributedText = actualstring as NSAttributedString
        if(indexPath.section == 0){
            //print(actualstring)
        }
        //cell.namelbl.text =
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
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
            }else if(update == "activated_under_review"){
                cell.statuslbl.text = "Under review"
            }else{
                cell.statuslbl.text = ""
            }
            //  //print(dateFormat.stringFromDate(dte!))
            //cell.statuslbl.text =
            //lastupdatedlbl
            
        }else{
            cell.statuslbl.text = "Not available"
        }
        }else{
            if(indexPath.row == 0){
                buildingarr = (self.searcharr.object(forKey: "building") as! NSArray).mutableCopy() as! NSMutableArray
                let arr = (buildingarr[indexPath.section] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                cell.leedidlbl.text = String(format: "%d",arr["leed_id"] as! Int)
                let actualstring = NSMutableAttributedString()
                var tempostring = NSMutableAttributedString()
                if(arr["name"] != nil){
                    tempostring = NSMutableAttributedString(string:(arr["name"] as? String)!)
                }
                actualstring.append(tempostring.mutableCopy() as! NSAttributedString)
                tempostring.deleteCharacters(in: NSMakeRange(0, tempostring.length))
                tempostring = NSMutableAttributedString(string:"\n")
                actualstring.append(tempostring.mutableCopy() as! NSAttributedString)
                tempostring.deleteCharacters(in: NSMakeRange(0, tempostring.length))
                if(arr["street"] != nil){
                    tempostring = NSMutableAttributedString(string:(arr["street"] as! String).capitalized)
                }
                tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: NSMakeRange(0, tempostring.length))
                tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans", size: fontsize * UIScreen.main.bounds.size.width)!, range: NSMakeRange(0, tempostring.length))
                actualstring.append(tempostring.mutableCopy() as! NSAttributedString)
                tempostring.deleteCharacters(in: NSMakeRange(0, tempostring.length))
                tempostring = NSMutableAttributedString(string:" ")
                actualstring.append(tempostring.mutableCopy() as! NSAttributedString)
                tempostring.deleteCharacters(in: NSMakeRange(0, tempostring.length))
                
                if(arr["city"] != nil){
                    tempostring = NSMutableAttributedString(string:(arr["city"] as! String).capitalized)
                }
                tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: NSMakeRange(0, tempostring.length))
                tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans", size: fontsize * UIScreen.main.bounds.size.width)!, range: NSMakeRange(0, tempostring.length))
                actualstring.append(tempostring.mutableCopy() as! NSAttributedString)
                cell.namelbl.adjustsFontSizeToFitWidth = true
                cell.namelbl.attributedText = actualstring as NSAttributedString
                if(indexPath.section == 0){
                    //print(actualstring)
                }
                //cell.namelbl.text =
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
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
                    //  //print(dateFormat.stringFromDate(dte!))
                    //cell.statuslbl.text =
                    //lastupdatedlbl
                    
                }else{
                    cell.statuslbl.text = "Not available"
                }
            }else{
                buildingarr = (self.searcharr.object(forKey: "portfolio") as! NSArray).mutableCopy() as! NSMutableArray
                let arr = (buildingarr[indexPath.section] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                if(arr["pf_id"] != nil){
                cell.leedidlbl.text = String(format: "%d",arr["pf_id"] as! Int)
                }
                let actualstring = NSMutableAttributedString()
                var tempostring = NSMutableAttributedString()
                if(arr["name"] != nil){
                    tempostring = NSMutableAttributedString(string:(arr["name"] as? String)!)
                }
                actualstring.append(tempostring.mutableCopy() as! NSAttributedString)
                tempostring.deleteCharacters(in: NSMakeRange(0, tempostring.length))
                tempostring = NSMutableAttributedString(string:"\n")
                actualstring.append(tempostring.mutableCopy() as! NSAttributedString)
                tempostring.deleteCharacters(in: NSMakeRange(0, tempostring.length))
                if(arr["street"] != nil){
                    tempostring = NSMutableAttributedString(string:(arr["street"] as! String).capitalized)
                }
                tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: NSMakeRange(0, tempostring.length))
                tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans", size: fontsize * UIScreen.main.bounds.size.width)!, range: NSMakeRange(0, tempostring.length))
                actualstring.append(tempostring.mutableCopy() as! NSAttributedString)
                tempostring.deleteCharacters(in: NSMakeRange(0, tempostring.length))
                tempostring = NSMutableAttributedString(string:" ")
                actualstring.append(tempostring.mutableCopy() as! NSAttributedString)
                tempostring.deleteCharacters(in: NSMakeRange(0, tempostring.length))
                
                if(arr["city"] != nil){
                    tempostring = NSMutableAttributedString(string:(arr["city"] as! String).capitalized)
                }
                tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: NSMakeRange(0, tempostring.length))
                tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans", size: fontsize * UIScreen.main.bounds.size.width)!, range: NSMakeRange(0, tempostring.length))
                actualstring.append(tempostring.mutableCopy() as! NSAttributedString)
                cell.namelbl.adjustsFontSizeToFitWidth = true
                cell.namelbl.attributedText = actualstring as NSAttributedString
                if(indexPath.section == 0){
                    //print(actualstring)
                }
                //cell.namelbl.text =
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
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
                    //  //print(dateFormat.stringFromDate(dte!))
                    //cell.statuslbl.text =
                    //lastupdatedlbl
                    
                }else{
                    cell.statuslbl.text = "Not available"
                }
            }
        }
        return cell
    }
    
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.tableview.reloadData()
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var str = searchbar.text!
        for request in download_requests
        {
            request.invalidateAndCancel()
        }
        
        if(str.characters.count == 0){
            searchbar.resignFirstResponder()
            let datakeyed = UserDefaults.standard.object(forKey: "assetdata") as! Data
            assets = (NSKeyedUnarchiver.unarchiveObject(with: datakeyed) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            buildingarr = (assets["results"]! as! NSArray).mutableCopy() as! NSMutableArray
            if(filteredobject == "my portfolios"){
                buildingarr = (((NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "portfolios") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary)["results"]! as! NSArray).mutableCopy() as! NSMutableArray
            }
            if(tobefiltered.contains("all")){
                self.spinner.isHidden = true
                self.tableview.reloadData()
            }else{
                filterok(filterbtn)
            }
            self.tableview.isUserInteractionEnabled = true
        self.navigationItem.leftBarButtonItem?.isEnabled = true
            self.spinner.isHidden = true
            self.tableview.reloadData()
            
            
            DispatchQueue.main.async(execute: {
                if(self.buildingarr.count < self.size){
                    self.notfound.isHidden = true
                    self.buildingarr = NSMutableArray()
                    self.tableview.reloadData()
                    self.page = 1
                    if(self.isloading == false){
                        let c = credentials()
                        self.view.isUserInteractionEnabled = false
                        self.spinner.isHidden = false
                        self.project_type = self.filteredobject
                        if(self.project_type == "my portfolios"){
                            self.project_type = "all"
                        }else if(self.project_type == "my cities"){
                            self.project_type = "city"
                        }else if(self.project_type == "my communities"){
                            self.project_type = "community"
                        }else if(self.project_type == "my transit"){
                            self.project_type = "transit"
                        }else if(self.project_type == "my parking"){
                            self.project_type = "parksmart"
                        }else if(self.project_type == "my buildings"){
                            self.project_type = "building"
                        }else{
                            self.project_type = "all"
                        }
                        
                        self.tableview.isUserInteractionEnabled = false
        self.navigationItem.leftBarButtonItem?.isEnabled = false
                        self.spinner.isHidden = false
                        if(self.project_type == "all"){
                            self.loadMoreDataFromServer("\(credentials().domain_url)assets/?page=\(self.page)&page_size=30", subscription_key: c.subscription_key)
                        }else{
                            if(self.project_type == "my portfolios"){
                                self.loadMoreDataFromServer("\(credentials().domain_url)portfolios/?&page=\(self.page)", subscription_key: c.subscription_key)
                            }else{
                                self.loadMoreDataFromServer("\(credentials().domain_url)assets/?project_type=\(self.project_type as String)&page=\(self.page)&page_size=30", subscription_key: c.subscription_key)
                            }
                        }
                    }
                    
                }
            })

            
        }else{
            let tempstring = str.replacingOccurrences(of: " ", with: "%20")
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
                self.navigationItem.title = "My Buildings"
            }
            if(filteredobject == "my cities"){
                self.navigationItem.title = "My Cities"
            }
            
            if(filteredobject == "my communities"){
                self.navigationItem.title = "My Communities"
            }
            
            if(filteredobject == "my parking"){
                self.navigationItem.title = "My Parking"
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
            
            DispatchQueue.main.async(execute: {
                self.tableview.isUserInteractionEnabled = false
        self.navigationItem.leftBarButtonItem?.isEnabled = false
                self.spinner.isHidden = false
                self.notfound.isHidden = true
            })
            if(timer.isValid){
                timer.invalidate()
            }
            urlstr = urlstring
            
            timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.getsearchbuilding), userInfo: nil, repeats: false)
            
            
        }
        
    }
    
    
    
    var urlstr = ""
    
    @objc func getsearchbuilding(){
        var urlstring = urlstr
        let url = URL.init(string: urlstring)
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(session)
        self.task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if(self.filteredobject == "my portfolios"){
                    self.project_type = self.filteredobject
                }
                if(error?._code == -999){
                    
                }else{
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                })
                }
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
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    let jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        if(jsonDictionary["error"] != nil){
                            if let snapshotValue = jsonDictionary["error"] as? NSArray, let currentcountr = snapshotValue[0] as? NSDictionary, let currentstat = currentcountr["message"] as? String {
                                    self.showalert(currentstat, title: "Error", action: "OK")
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
                
                var jsonDictionary : NSMutableDictionary
                do {
                    jsonDictionary = try (JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    //print(jsonDictionary)
                    var building = NSMutableArray()
                    if let snapshotValue = (jsonDictionary["building"] as! NSArray).mutableCopy() as? NSMutableArray{
                       building = snapshotValue
                    }
                    
                    if(building.count > 0){
                    var temp = NSMutableArray()
                    for item in building{
                        var a = item as! NSDictionary
                        if(self.filteredobject == "my cities"){
                            if(a["project_type"] as! String == "city"){
                                temp.add(a)
                            }
                        }
                        
                        if(self.filteredobject == "my communities"){
                            if(a["project_type"] as! String == "community"){
                                temp.add(a)
                            }
                        }
                        
                        if(self.filteredobject == "my transit"){
                            if(a["project_type"] as! String == "transit"){
                                temp.add(a)
                            }
                        }
                        
                        if(self.filteredobject == "my parking"){
                            if(a["project_type"] as! String == "parksmart"){
                                temp.add(a)
                            }
                        }
                        
                        if(self.filteredobject == "my buildings"){
                            if(a["project_type"] as! String == "building"){
                                temp.add(a)
                            }
                        }
                        
                        if(self.filteredobject == "all"){
                                temp.add(a)
                        }
                    }
                    //print(jsonDictionary.allKeys)
                    jsonDictionary["building"] = temp
                    
                    self.searcharr = jsonDictionary.mutableCopy() as! NSMutableDictionary
                    //self.buildingarr = jsonDictionary.mutableCopy() as! NSMutableArray
                    DispatchQueue.main.async(execute: {
                        self.spinner.isHidden = true
                        self.tableview.isUserInteractionEnabled = true
        self.navigationItem.leftBarButtonItem?.isEnabled = true
                        self.view.isUserInteractionEnabled = true
                    })
                    DispatchQueue.main.async(execute: {
                        if(self.tobefiltered.contains("all")){
                            self.tableview.reloadData()
                        }else{
                            self.filterok(self.filterbtn)
                            self.tableview.reloadData()
                        }
                        self.tableview.isUserInteractionEnabled = true
        self.navigationItem.leftBarButtonItem?.isEnabled = true
                    })
                    }else{
                        DispatchQueue.main.async(execute: {
                        self.spinner.isHidden = true
                        self.view.isUserInteractionEnabled = true
                        self.buildingarr = building
                        self.searcharr = jsonDictionary.mutableCopy() as! NSMutableDictionary
                            self.tableview.isUserInteractionEnabled = true
        self.navigationItem.leftBarButtonItem?.isEnabled = true
                        self.tableview.reloadData()
                        })
                    }
                } catch {
                    //print(error)
                    DispatchQueue.main.async(execute: {
                        let jsonDictionary : NSDictionary
                        do {
                            jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                            if(jsonDictionary["error"] != nil){
                                if let snapshotValue = jsonDictionary["error"] as? NSArray, let currentcountr = snapshotValue[0] as? NSDictionary, let currentstat = currentcountr["message"] as? String {
                                    self.showalert(currentstat, title: "Error", action: "OK")
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
            
        }) 
        task.resume()
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView == tableview){
        searchbar.resignFirstResponder()
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            if(searchbar.text?.characters.count == 0 || searcharr["building"] == nil || searcharr["portfolio"] == nil){
            if (assets["next"] == nil || assets["next"] is NSNull){
                maketoast("That was all", type: "message")
            }else{
                if(isloading == false){
                    let c = credentials()
                    DispatchQueue.main.async(execute: {
                        self.view.isUserInteractionEnabled = false
                        self.spinner.isHidden = false
                    })
                    
                    project_type = filteredobject
                    if(project_type == "my portfolios"){
                        project_type = "all"
                    }else if(project_type == "my cities"){
                        project_type = "city"
                    }else if(project_type == "my communities"){
                        project_type = "community"
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
                    if(self.tobefiltered.contains("all")){
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
    
    
    
    
    func loadMoreDataFromServer(_ URL:String, subscription_key:String){
        let url = Foundation.URL.init(string: URL)
        let request = NSMutableURLRequest.init(url: url!)
        print(url?.absoluteURL)
        request.httpMethod = "GET"
        isloading = true
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(session)
        self.task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    self.isloading = false
                    if(error?._code == -999){
                        
                    }else{
                            self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                })
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401{
                DispatchQueue.main.async(execute: {
                    //self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    self.isloading = false
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
                return
            } else
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.isloading = false
                        let jsonDictionary : NSDictionary
                        do {
                            jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                            if(jsonDictionary["error"] != nil){
                                if let snapshotValue = jsonDictionary["error"] as? NSArray, let currentcountr = snapshotValue[0] as? NSDictionary, let currentstat = currentcountr["message"] as? String {
                                self.showalert(currentstat, title: "Error", action: "OK")
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
                
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    DispatchQueue.main.async(execute: {
                        if(jsonDictionary["results"] != nil){
                            self.assets = jsonDictionary.mutableCopy() as! NSMutableDictionary
                            let temparr = jsonDictionary["results"] as! NSArray
                            var tempbuilding = NSMutableArray()
                            if(self.tobefiltered.contains("all") && self.page == 1){
                                
                            }else{
                                for i in 0..<self.buildingarr.count {
                                    tempbuilding.add(self.buildingarr.object(at: i))
                                }
                            }
                            for i in 0..<temparr.count {
                                tempbuilding.add(temparr.object(at: i))
                            }
                            var withoutduplicates = NSMutableArray()
                            for i in tempbuilding{
                                let item = i as! NSDictionary
                                if(withoutduplicates.contains(item)){
                                    
                                }else{
                                    withoutduplicates.add(item)
                                }
                            }
                            tempbuilding = NSMutableArray()
                            tempbuilding = withoutduplicates
                            self.buildingarr = tempbuilding.mutableCopy() as! NSMutableArray
                            //print("Buildingarr count after load more ",self.buildingarr.count)
                            self.page = self.page + 1
                        }
                        self.isloading = false
                        self.view.isUserInteractionEnabled = true
                        self.spinner.isHidden = true
                        self.tableview.isUserInteractionEnabled = true
        self.navigationItem.leftBarButtonItem?.isEnabled = true
                        self.tableview.reloadData()
                    })
                    
                } catch {
                    //print(error)
                    DispatchQueue.main.async(execute: {
                        self.isloading = false
                            let jsonDictionary : NSDictionary
                            do {
                                jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                                if(jsonDictionary["error"] != nil){
                                    if let snapshotValue = jsonDictionary["error"] as? NSArray, let currentcountr = snapshotValue[0] as? NSDictionary, let currentstat = currentcountr["message"] as? String {
                                self.showalert(currentstat, title: "Error", action: "OK")
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
            
        }) 
        task.resume()
        
    }
    
    @IBOutlet weak var nav: UINavigationBar!
    
    
    func getnotifications(_ subscription_key:String, leedid:Int, type: String){
        let url = URL.init(string:String(format: "%@assets/LEED:%d/notifications/",credentials().domain_url,UserDefaults.standard.integer(forKey: "leed_id")))
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
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    if(error?._code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
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
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    let jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        if(jsonDictionary["error"] != nil){
                            if let snapshotValue = jsonDictionary["error"] as? NSArray, let currentcountr = snapshotValue[0] as? NSDictionary, let currentstat = currentcountr["message"] as? String {
                                self.showalert(currentstat, title: "Error", action: "OK")
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
                
                var jsonDictionary : NSArray
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSArray
                    DispatchQueue.main.async(execute: {
                        print(jsonDictionary)
                        let temparr = NSMutableArray()
                        for i in jsonDictionary{
                            let d = i as! NSDictionary
                        let foreign_id = d["foreign_id"] as! String
                            if (self.typ != "parksmart")
                            {
                                if (foreign_id == "registration_expired")
                                {
                                    // remove from array
                                }
                                if (foreign_id == "data_input_strategy_review")
                                {
                                    // remove from array
                                }
                                if (foreign_id == "data_input_strategy")
                                {
                                    // remove from array
                                }
                                if (foreign_id == "data_input_fuel")
                                {
                                    // remove from array
                                }
                                if (foreign_id == "data_input_operating_hours" && self.typ != "building" && self.typ != "transit")
                                {
                                    // remove from array
                                }
                                if (foreign_id == "data_input_density" && self.typ != "building" && self.typ != "transit")
                                {
                                    // remove from array
                                }
                                if (foreign_id == "data_input_occupancy" && self.typ != "building" && self.typ != "transit")
                                {
                                    // remove from array
                                }
                                if (foreign_id == "data_input_gfa" && self.typ != "building" && self.typ != "transit")
                                {
                                    // remove from array
                                }
                            }else{
                        if(foreign_id == "updated_userManual")
                        {
                            
                        }
                        else if(foreign_id == "data_input_human")
                        {
                            temparr.add(d)
                        }
                        else if(foreign_id == "data_input_transportation")
                        {
                            temparr.add(d)
                        }
                        else if(foreign_id == "data_input_waste")
                        {
                            temparr.add(d)
                        }
                        else if(foreign_id == "data_input_water")
                        {
                            temparr.add(d)
                        }
                        else if(foreign_id == "data_input_energy" || foreign_id == "data_input_electricity")
                        {
                            temparr.add(d)
                        }
                        else if(foreign_id == "data_input_operating_hours")
                        {
                            temparr.add(d)
                        }
                        else if(foreign_id == "data_input_density")
                        {
                            temparr.add(d)
                        }
                        else if(foreign_id == "data_input_occupancy")
                        {
                            temparr.add(d)
                        }
                        else if(foreign_id == "data_input_gfa")
                        {
                            temparr.add(d)
                        }
                        else if(foreign_id == "skipped_teamManagement")
                        {
                            
                        }
                        else if(foreign_id == "skipped_payment")
                        {
                            
                        }
                        else if(foreign_id == "skipped_agreement")
                        {
                            
                        }
                        else if(foreign_id == "score_computation")
                        {
                            
                        }
                        else if(foreign_id == "request_access")
                        {
                            
                        }
                        else if(foreign_id == "review_Completed")
                        {
                            
                        }
                        }
                        }
                        let data = NSKeyedArchiver.archivedData(withRootObject: temparr)
                        UserDefaults.standard.set(data, forKey: "notifications")
                        // Existing ARM APIs
                        //self.buildingactions(subscription_key, leedid: leedid)
                        self.performSegue(withIdentifier: "gotodashboard", sender: nil)
                    })
                    
                    //self.tableview.reloadData()
                    // self.buildingactions(subscription_key, leedid: leedid)
                } catch {
                    //print(error)
                    DispatchQueue.main.async(execute: {
                        let jsonDictionary : NSDictionary
                        do {
                            jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                            if(jsonDictionary["error"] != nil){
                                if let snapshotValue = jsonDictionary["error"] as? NSArray, let currentcountr = snapshotValue[0] as? NSDictionary, let currentstat = currentcountr["message"] as? String {
                                self.showalert(currentstat, title: "Error", action: "OK")
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
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    if(error?._code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
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
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    let jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        if(jsonDictionary["error"] != nil){
                            if let snapshotValue = jsonDictionary["error"] as? NSArray, let currentcountr = snapshotValue[0] as? NSDictionary, let currentstat = currentcountr["message"] as? String {
                                self.showalert(currentstat, title: "Error", action: "OK")
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
                
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print(jsonDictionary)
                    let datakeyed = NSKeyedArchiver.archivedData(withRootObject: jsonDictionary)
                    UserDefaults.standard.set(datakeyed, forKey: "actions_data")
                    UserDefaults.standard.synchronize()
                    DispatchQueue.main.async(execute: {
                        self.certdetails(subscription_key, leedid: leedid)
                    })
                    
                } catch {
                    //print(error)
                    DispatchQueue.main.async(execute: {
                        let jsonDictionary : NSDictionary
                        do {
                            jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                            if(jsonDictionary["error"] != nil){
                                if let snapshotValue = jsonDictionary["error"] as? NSArray, let currentcountr = snapshotValue[0] as? NSDictionary, let currentstat = currentcountr["message"] as? String {
                                self.showalert(currentstat, title: "Error", action: "OK")
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
            
        }) 
        task.resume()
    }
    
    
    func checktoken(){
        if(UserDefaults.standard.object(forKey: "username") != nil && UserDefaults.standard.object(forKey: "password") != nil){
            var username = UserDefaults.standard.object(forKey: "username")
            var password = UserDefaults.standard.object(forKey: "password")
            username = "testuser@gmail.com"
            password = "initpass"
            let credential = credentials()
            var domain_url = ""
            domain_url=credential.domain_url
            //print("subscription key of LEEDOn ",credential.subscription_key)
            let url = URL.init(string: String(format: "%@auth/login/",domain_url))
            let request = NSMutableURLRequest.init(url: url!)
            request.httpMethod = "POST"
            request.addValue(credential.subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
            request.addValue("application/json", forHTTPHeaderField:"Content-type" )
            let httpbody = String(format: "{\"username\":\"%@\",\"password\":\"%@\"}",username as! String,password as! String)
            request.httpBody = httpbody.data(using: String.Encoding.utf8)
            //print("HEadre is ",httpbody)
            //print(request.allHTTPHeaderFields)
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            download_requests.append(session)
            self.task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
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
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                    DispatchQueue.main.async(execute: {
                        let jsonDictionary : NSDictionary
                        do {
                            jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                            if(jsonDictionary["error"] != nil){
                                if let snapshotValue = jsonDictionary["error"] as? NSArray, let currentcountr = snapshotValue[0] as? NSDictionary, let currentstat = currentcountr["message"] as? String {
                                self.showalert(currentstat, title: "Error", action: "OK")
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
                    
                    let jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        //print("JSON data is",jsonDictionary)
                        if(jsonDictionary.value(forKey: "token_type") as! String == "Bearer"){
                            UserDefaults.standard.set(username, forKey: "username")
                            UserDefaults.standard.set(password, forKey: "password")
                            UserDefaults.standard.set(jsonDictionary.value(forKey: "authorization_token") as! String, forKey: "token")
                        }
                    } catch {
                        //print(error)
                        DispatchQueue.main.async(execute: {
                            let jsonDictionary : NSDictionary
                            do {
                                jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                                if(jsonDictionary["error"] != nil){
                                    if let snapshotValue = jsonDictionary["error"] as? NSArray, let currentcountr = snapshotValue[0] as? NSDictionary, let currentstat = currentcountr["message"] as? String {
                                self.showalert(currentstat, title: "Error", action: "OK")
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
                
            }) 
            task.resume()
        }else{
            timer.invalidate()
        }
    }
    
    
    func imageWithImage(_ image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
    
    
    @IBAction func customize(_ sender: AnyObject) {
        DispatchQueue.main.async(execute: {
            self.performSegue(withIdentifier: "gotogrid", sender: nil)            
            })
    }
    
}

extension UIViewController{
    func maketoast(_ message:String, type:String){
        var color = UIColor()
        if(type == "error"){
            color = UIColor.darkGray
        }else{
            color = UIColor.init(red: 0, green: 183/255, blue: 130/255, alpha: 1)
        }
           /* let toastLabel = UILabel(frame: CGRectMake(self.view.frame.size.width/2 - 150, self.view.frame.size.height-100, 300, 35))
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
            */
            if (self.navigationController != nil) {
                // being pushed
                
                AWBanner.showWithDuration(4.5, delay: 0.0, message: NSLocalizedString(message, comment: ""), backgroundColor: color, textColor: UIColor.white, originY: self.navigationController!.navigationBar.frame.size.height + self.navigationController!.navigationBar.frame.origin.y)
            }else{
                AWBanner.showWithDuration(4.5, delay: 0.0, message:  NSLocalizedString(message, comment: ""), backgroundColor: color, textColor: UIColor.white)
            }
            
        }
    
    
}



extension UIViewController{
    func titlefont(){
        if(self.navigationController != nil){
        self.navigationController!.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white,
             NSFontAttributeName: UIFont(name: "OpenSans", size: 17)!]
        }
    }
}
