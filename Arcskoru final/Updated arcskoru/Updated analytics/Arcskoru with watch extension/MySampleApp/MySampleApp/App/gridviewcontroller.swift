//
//  gridviewcontroller.swift
//  Arcskoru
//
//  Created by Group X on 09/01/17.
//
//

import UIKit
import  WatchConnectivity
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


class gridviewcontroller: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource,WCSessionDelegate {
    @IBOutlet weak var tableview: UITableView!
    var size = 0
    var tobefiltered = NSMutableArray()
    var filterarr = ([["My Cities"] ,["My Communities"] ,["My Transit","My Parking","My Buildings"] ,["All"] ] as! NSArray).mutableCopy() as! NSMutableArray
    var task = URLSessionTask()
    @IBAction func addbtn(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Create a new project", message: "Please select the type of project you want to create", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
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
        
        alertController.addAction(buildings)
        alertController.addAction(cities)
        alertController.addAction(communities)
        alertController.addAction(transportation)
        alertController.addAction(parksmart)
        alertController.view.subviews.first?.backgroundColor = UIColor.white
        alertController.view.layer.cornerRadius = 10
        alertController.view.layer.masksToBounds = true
        present(alertController, animated: true, completion: nil)
        
    }
    var emptydict = ["count": 1,"created_at_max": "2016-12-30T14:02:41.260478Z","created_at_min": "2016-12-30T14:02:41.260478Z","energy_avg": 0,"water_avg": 0,"waste_avg": 0,"transport_avg": 0,"base_avg": 0,"human_experience_avg": 0] as [String : Any]
    var type = ""
    var watchsession = WCSession.default()
    @IBOutlet weak var nav: UINavigationBar!
    @IBOutlet weak var gridview: UICollectionView!
    @IBOutlet weak var logout: UIButton!
    var token = UserDefaults.standard.object(forKey: "token") as! String
    var buildingarr = NSMutableArray()
    var humanexarray = NSMutableArray()
    var transportationarray = NSMutableArray()
    var isloading = false
    var toloadmore = 0
    var listobuildings = NSMutableArray()
    var timer = Timer()
    var domain_url = ""
    var download_requests = [URLSession]()
    var assets = NSMutableDictionary()    
    var countries = NSMutableDictionary()
    var fullstatename = ""
    var fullcountryname = ""
    var page = 2
    func viewswitch(_ sender: UISegmentedControl){
        if(sender.tag == 123){
            if(sender.selectedSegmentIndex == 0){
                customise(UIButton())
            }
        }
    }
    @IBOutlet weak var filterclosebtn: UIButton!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        //stop all download requests
        for request in download_requests
        {
            request.invalidateAndCancel()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    @IBAction func filterclose(_ sender: AnyObject) {
        filterview.isHidden = true
    }
    
    @IBAction func donebutton(_ sender: UIBarButtonItem) {
        sayHello(sender)
    }
    @IBAction func filterbutton(_ sender: UIBarButtonItem) {
        filter(sender)
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        
    }
    
    @available(iOS 9.3, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }

    
    @IBOutlet weak var filterview: UIView!
    
    @IBAction func filterok(_ sender: AnyObject) {
        //print("listofbuildings ",listobuildings)
        //print("Filter asv ",filteredobject)
        //print("Updated buildingarr count",buildingarr.count)
        filterview.isHidden = true
        var temparr = NSMutableArray()
        self.listobuildings = NSMutableArray()        
        self.listobuildings = self.buildingarr
        if(searchbar.text?.characters.count > 0){
            if(filteredobject == "All"){
                self.navigationItem.title = "All projects"
            }
            if(filteredobject == "My Buildings"){
                self.navigationItem.title = "My Buildings"
            }
            if(filteredobject == "My Cities"){
                self.navigationItem.title = "My Cities"
            }
            
            if(filteredobject == "My Communities"){
                self.navigationItem.title = "My Communities"
            }
            
            if(filteredobject == "My Parking"){
                self.navigationItem.title = "My Parking"
            }
            
            if(filteredobject == "My Transit"){
                self.navigationItem.title = "My Transit"
            }
            
            if(filteredobject == "My Portfolios"){
                self.navigationItem.title = "Portfolios"
            }

        }
        if(filteredobject == "My Portfolios" || filteredobject == "All" || filteredobject == "My Buildings"){
            temparr = self.buildingarr
            if(filteredobject == "All"){
                self.navigationItem.title = "All projects"
            }
            if(filteredobject == "My Buildings"){
                self.navigationItem.title = "My Buildings"
            }
            if(filteredobject == "My Cities"){
                self.navigationItem.title = "My Cities"
            }
            
            if(filteredobject == "My Communities"){
                self.navigationItem.title = "My Communities"
            }
            
            if(filteredobject == "My Parking"){
                self.navigationItem.title = "My Parking"
            }
            
            if(filteredobject == "My Transit"){
                self.navigationItem.title = "My Transit"
            }
            
            if(filteredobject == "My Portfolios"){
                self.navigationItem.title = "Portfolios"
            }
        }
        if(filteredobject == "My Buildings"){
            project_type = "building"
            temparr = NSMutableArray()
            for index in 0..<listobuildings.count {
                let data = (listobuildings.object(at: index) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                if(data["project_type"] != nil){
                    if(data["project_type"] as! String == "building"){
                        temparr.add(data)
                    }
                }
            }
        }else if(filteredobject == "My Cities"){
            project_type = "city"
            for i in 0..<listobuildings.count{
                let data = (listobuildings.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                if(data["project_type"] != nil){
                    if(data["project_type"] as! String == "city"){
                        temparr.add(data)
                    }
                }
            }
        }else if(filteredobject == "My Communities"){
            project_type = "community"
            for i in 0..<listobuildings.count{
                let data = (listobuildings.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                if(data["project_type"] != nil){
                    if(data["project_type"] as! String == "community"){
                        temparr.add(data)
                    }
                }
            }
        }else if(filteredobject == "My Parking"){
            project_type = "parksmart"
            for i in 0..<listobuildings.count{
                let data = (listobuildings.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                if(data["project_type"] != nil){
                    if(data["project_type"] as! String == "parksmart"){
                        temparr.add(data)
                    }
                }
            }
        }else if(filteredobject == "My Transit"){
            project_type = "transit"
            for i in 0..<listobuildings.count{
                let data = (listobuildings.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                if(data["project_type"] != nil){
                    if(data["project_type"] as! String == "transit"){
                        temparr.add(data)
                    }
                }
            }
        }else if(filteredobject == "All"){
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
         if(filteredobject == "My Portfolios"){
         self.listobuildings = self.buildingarr
         }else{
         self.listobuildings = assets["results"]!.mutableCopy() as! NSMutableArray
         }
         }else{
         self.listobuildings = self.buildingarr
         }
         buildingarr = NSMutableArray()
         //if(tobefiltered.containsObject("All")){
         if(filteredobject == "All"){
         buildingarr = assets["results"]!.mutableCopy() as! NSMutableArray
         project_type = "All"
         tableview.reloadData()
         }else{
         let temparr = NSMutableArray()
         //print("Count",listobuildings.count)
         //if(tobefiltered.containsObject("buildings")){
         if(filteredobject == "My Buildings"){
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
         if(filteredobject == "My Cities"){
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
         if(filteredobject == "My Communities"){
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
         if(filteredobject == "My Parking"){
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
         
         if(filteredobject == "My Transit"){
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
            self.gridview.reloadData()
        })

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            cell.tintColor = UIColor.blue
            cell.accessoryType = UITableViewCellAccessoryType.none
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            //cell.textLabel?.text = filterarr[indexPath.row]
            return cell
        }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
            let cell = tableView.cellForRow(at: indexPath)!
            cell.accessoryType = UITableViewCellAccessoryType.none
            tobefiltered.replaceObject(at: indexPath.row, with: "")
        
        //print("To be filtered",tobefiltered)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            let cell = tableView.cellForRow(at: indexPath)!
            if(cell.accessoryType == UITableViewCellAccessoryType.none){
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
                tobefiltered.replaceObject(at: indexPath.row, with: (cell.textLabel?.text?.lowercased())!)
            }
            
            //print("To be filtered",tobefiltered)
        
    }
    @IBOutlet weak var filterbtn: UIButton!
    
    @IBOutlet weak var nobuildingsfound: UILabel!
    @IBAction func showfilter(_ sender: AnyObject) {
        filterview.isHidden = false
    }
    

    var fontsize = CGFloat(0)
    var fontsize1 = CGFloat(0)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
        self.nobuildingsfound.isHidden = true
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
        // It's an iPhone
            size = 7
            fontsize = 0.025
            fontsize1 = 0.045
            break
        case .pad:
            size = 25
            fontsize = 0.015
            fontsize1 = 0.025
        // It's an iPad
            
            break
        case .unspecified:
            size = 7
            fontsize = 0.025
            fontsize1 = 0.045
            break
            
        default :
            size = 5
            fontsize = 0.025
            fontsize1 = 0.045
            // Uh, oh! What could it be?
        }
        self.searchbar.frame.size.height = self.segctrl.frame.size.height
        self.searchbar.frame.origin.y = self.segctrl.frame.origin.y
        gridview.register(UINib.init(nibName: "assetcollectionviewcell", bundle: nil), forCellWithReuseIdentifier: "assetcell")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        _ = UIScreen.main.bounds.size.width
        layout.sectionInset = UIEdgeInsets(top: 0.027 * UIScreen.main.bounds.size.width, left: (self.view.frame.size.width - (self.segctrl.frame.origin.x + self.segctrl.frame.size.width)), bottom: 0, right: (self.view.frame.size.width - (self.segctrl.frame.origin.x + self.segctrl.frame.size.width)))
        //layout.itemSize = CGSize(width: UIScreen.mainScreen().bounds.size.width/4.37,height:UIScreen.mainScreen().bounds.size.width/4.37)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.height * 0.17,height:UIScreen.main.bounds.size.height  * 0.17)
        
        layout.minimumInteritemSpacing = 0//0.03 * UIScreen.mainScreen().bounds.size.width
        layout.minimumLineSpacing = (self.view.frame.size.width - (self.segctrl.frame.origin.x + self.segctrl.frame.size.width))
        gridview!.collectionViewLayout = layout
        self.automaticallyAdjustsScrollViewInsets = false
        if(UserDefaults.standard.object(forKey: "humanexarray") != nil){
            humanexarray = (UserDefaults.standard.object(forKey: "humanexarray") as! NSArray).mutableCopy() as! NSMutableArray
        }
        if(UserDefaults.standard.object(forKey: "transportationarray") != nil){
            transportationarray = (UserDefaults.standard.object(forKey: "transportationarray") as! NSArray).mutableCopy() as! NSMutableArray
        }
        //segctrl.hidden = true
        filterview.isHidden = true
        if(tobefiltered.count == 0){
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
        a.add("All")
        tobefiltered.add(a)
        }
        addbutton.layer.cornerRadius = (addbutton.layer.bounds.size.width)/2
        filterbtn.layer.cornerRadius = (filterbtn.layer.bounds.size.width)/2
        let segmentButton: UISegmentedControl!
        segmentButton = UISegmentedControl(items: [self.imageWithImage(UIImage(named: "List.png")!, scaledToSize: CGSize(width: 32, height: 32)), self.imageWithImage(UIImage(named: "grid.png")!, scaledToSize: CGSize(width: 32, height: 32))])
        
        segctrl.setImage(self.imageWithImage(UIImage(named: "List.png")!, scaledToSize: CGSize(width: 25, height: 25)), forSegmentAt: 0)
        segctrl.setImage(self.imageWithImage(UIImage(named: "grid.png")!, scaledToSize: CGSize(width: 25, height: 25)), forSegmentAt: 1)
        segctrl.frame.size.height = searchbar.frame.size.height
        segctrl.contentMode = .scaleToFill
        self.navigationItem.title = "All projects"
        let navItem = UINavigationItem(title: "All projects");
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "OpenSans", size: 17)!, NSForegroundColorAttributeName : UIColor.white]
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
        
        segctrl.selectedSegmentIndex = 1
        segctrl.tag = 123
        segctrl.addTarget(self, action: #selector(self.viewswitch(_:)), for: UIControlEvents.valueChanged)
        //view.addSubview(segmentButton)
        
        
        
        self.spinner.layer.cornerRadius = 5
        self.spinner.isHidden = true
        self.view.isUserInteractionEnabled = true
        tableview.register(UINib.init(nibName: "buildingcell", bundle: nil), forCellReuseIdentifier: "assetcell")
        let datakeyed = UserDefaults.standard.object(forKey: "assetdata") as! Data
        assets = (NSKeyedUnarchiver.unarchiveObject(with: datakeyed) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        buildingarr = (assets["results"]! as! NSArray).mutableCopy() as! NSMutableArray
        //print(buildingarr.count)
        listobuildings = buildingarr.mutableCopy() as! NSMutableArray
        //print("Buildings arr",buildingarr)
        token = UserDefaults.standard.object(forKey: "token") as! String
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    
    
    }
    
    
    func filter(_ sender:UIBarButtonItem){
            //showfilter(UIButton())
        self.performSegue(withIdentifier: "filterproj", sender: nil)
    }
    
    func sayHello(_ sender:UIBarButtonItem){
        logout(UIButton())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let d = NSKeyedArchiver.archivedData(withRootObject: tobefiltered)
        UserDefaults.standard.set(d, forKey: "tobefiltered")
        if(searchbar.becomeFirstResponder()){
            searchbar.resignFirstResponder()
        }
        UserDefaults.standard.set(searchbar.text, forKey: "searchtext")
        if(segue.identifier == "filterproj"){
            let v = segue.destination as! filterprojects
            v.filterarr = filterarr
            v.tobefiltered = tobefiltered
        }else if(segue.identifier == "gotolist"){
            let v = segue.destination as! UINavigationController
            let va = v.viewControllers[0] as! listofassets
            va.filterarr = filterarr
            va.tobefiltered = tobefiltered
        }else if(segue.identifier == "managecities"){
            let v = segue.destination as! managecity
            v.type = type
            
        }else if(segue.identifier == "addnewbuilding"){
            let v = segue.destination as! newproject
            v.type = type
            
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //plaque
        self.gridview.isUserInteractionEnabled = true
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        UserDefaults.standard.removeObject(forKey: "performance_data")
        UserDefaults.standard.removeObject(forKey: "comparable_data")
        UserDefaults.standard.removeObject(forKey: "local_comparable_data")
        UserDefaults.standard.removeObject(forKey: "inner_data")
        UserDefaults.standard.removeObject(forKey: "middle_data")
        UserDefaults.standard.removeObject(forKey: "notifications")
        UserDefaults.standard.removeObject(forKey: "building_details")
        UserDefaults.standard.removeObject(forKey: "certification_details")
        UserDefaults.standard.removeObject(forKey: "humanexarray")
        UserDefaults.standard.removeObject(forKey: "transportationarray")
        UserDefaults.standard.removeObject(forKey: "experiencearr")
        UserDefaults.standard.set(1, forKey: "transithide")
        UserDefaults.standard.set(1, forKey: "humanhide")
        UserDefaults.standard.removeObject(forKey: "mainarray")
        UserDefaults.standard.removeObject(forKey: "index")
        UserDefaults.standard.removeObject(forKey: "currentrow")
        UserDefaults.standard.removeObject(forKey: "mainarray")
        UserDefaults.standard.removeObject(forKey: "transportbuildingid")
        UserDefaults.standard.removeObject(forKey: "humanbuildingid")
        
        let toke = UserDefaults.standard.object(forKey: "token")
        let currentuser = UserDefaults.standard.object(forKey: "currentuser")
        let uname = UserDefaults.standard.object(forKey: "username")
        var tobefilter = NSMutableArray()
        if(UserDefaults.standard.object(forKey: "tobefiltered") != nil){
            tobefilter = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "tobefiltered") as! Data) as! NSMutableArray
        }
        let pwd = UserDefaults.standard.object(forKey: "password")
        let appDomain = Bundle.main.bundleIdentifier!
        var datakey = UserDefaults.standard.object(forKey: "assetdata") as! Data
        var searchtxt = ""
        var countries = NSData()
        if(UserDefaults.standard.object(forKey: "countries") != nil){
            countries = UserDefaults.standard.object(forKey: "countries") as! Data as NSData
        }
        if(UserDefaults.standard.object(forKey: "searchtext") != nil){
            searchtxt = UserDefaults.standard.object(forKey: "searchtext") as! String
        }
        
        
        
        let noinstructions = UserDefaults.standard.integer(forKey: "noinstructions")
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.removeObject(forKey: "tobefiltered")
        if let bid = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bid)
        }
        if(countries.length > 0){
            UserDefaults.standard.set(countries, forKey: "countries")
        }
        
        if(tobefilter.count > 0){
            let d = NSKeyedArchiver.archivedData(withRootObject: tobefilter)
            UserDefaults.standard.set(d, forKey: "tobefiltered")
        }
        
        UserDefaults.standard.set(datakey, forKey: "assetdata")
        UserDefaults.standard.set(searchtxt, forKey: "searchtext")
        UserDefaults.standard.set(uname, forKey: "username")
        UserDefaults.standard.set(pwd, forKey: "password")
        UserDefaults.standard.set(toke, forKey: "token")
        UserDefaults.standard.set(currentuser, forKey: "currentuser")
        //actions
        UserDefaults.standard.removeObject(forKey: "actions_data")
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
        DispatchQueue.main.async(execute: {
            if(self.searchbar.text?.characters.count == 0){
                self.spinner.isHidden = false
                self.view.isUserInteractionEnabled = false
                self.getstates(credentials().subscription_key)
            }
        })
        var datakeyed = UserDefaults.standard.object(forKey: "assetdata") as! Data
        assets = (NSKeyedUnarchiver.unarchiveObject(with: datakeyed) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        buildingarr = (assets["results"]! as! NSArray).mutableCopy() as! NSMutableArray
        if(UserDefaults.standard.object(forKey: "tobefiltered") != nil){
            tobefiltered = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "tobefiltered") as! Data) as! NSMutableArray
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
            filteredobject = "All"
        }
        
        project_type = filteredobject
        
        
        if(filteredobject == "All"){
            self.navigationItem.title = "All projects"
        }
        if(filteredobject == "My Buildings"){
            self.navigationItem.title = "My Buildings"
        }
        if(filteredobject == "My Cities"){
            self.navigationItem.title = "My Cities"
        }
        
        if(filteredobject == "My Communities"){
            self.navigationItem.title = "My Communities"
        }
        
        if(filteredobject == "My Parking"){
            self.navigationItem.title = "My Parking"
        }
        
        if(filteredobject == "My Transit"){
            self.navigationItem.title = "My Transit"
        }
        
        if(filteredobject == "My Portfolios"){
            self.navigationItem.title = "Portfolios"
        }
        
        if(filteredobject == "My Portfolios"){
            buildingarr = (((NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "portfolios") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary)["results"]! as! NSArray).mutableCopy() as! NSMutableArray
        }
        
        datakeyed = UserDefaults.standard.object(forKey: "assetdata") as! Data
        assets = (NSKeyedUnarchiver.unarchiveObject(with: datakeyed) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        buildingarr = (assets["results"]! as! NSArray).mutableCopy() as! NSMutableArray
        
        
        if(searchbar.text?.characters.count > 0){
            //self.searchBar(searchbar, textDidChange: searchbar.text!)
            var str = searchbar.text! 
            let tempstring = str.replacingOccurrences(of: " ", with: "%20")
            str = tempstring
            var urlstring = ""
            if(project_type == "My Portfolios"){
                project_type = "All"
            }else if(project_type == "My Cities"){
                project_type = "cities"
            }else if(project_type == "My Communities"){
                project_type = "communities"
            }else if(project_type == "My Transit"){
                project_type = "transit"
            }else if(project_type == "My Parking"){
                project_type = "parksmart"
            }else if(project_type == "My Buildings"){
                project_type = "building"
            }else{
                project_type = "All"
            }
            
            if(filteredobject == "All"){
                self.navigationItem.title = "All projects"
            }
            if(filteredobject == "My Buildings"){
                self.navigationItem.title = "My Buildings"
            }
            if(filteredobject == "My Cities"){
                self.navigationItem.title = "My Cities"
            }
            
            if(filteredobject == "My Communities"){
                self.navigationItem.title = "My Communities"
            }
            
            if(filteredobject == "My Parking"){
                self.navigationItem.title = "My Parking"
            }
            
            if(filteredobject == "My Transit"){
                self.navigationItem.title = "My Transit"
            }
            
            if(filteredobject == "My Portfolios"){
                self.navigationItem.title = "Portfolios"
            }
            
            
            if(project_type == "All"){
                //   loadMoreDataFromServer("\(credentials().domain_url)assets/?page=\(page)", subscription_key: c.subscription_key)
                urlstring = String(format: "%@assets/search/?q=%@&page_size=30",credentials().domain_url,str)
            }else{
                urlstring = String(format: "%@assets/search/?q=%@&project_type=\(project_type as String)&page_size=30",credentials().domain_url,str)
            }
            DispatchQueue.main.async(execute: {
                self.spinner.isHidden = false
                self.nobuildingsfound.isHidden = true
            })
            if(timer.isValid){
                timer.invalidate()
            }
            
            searchurl = urlstring
            timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.getsearchbuilding), userInfo: nil, repeats: false)
            
        }else{
            
            filterok(UIButton())
        }
        
        DispatchQueue.main.async(execute: {
            if(self.buildingarr.count < self.size){
                self.buildingarr = NSMutableArray()
                self.gridview.reloadData()
                self.nobuildingsfound.text = ""
                self.page = 1
                if(self.isloading == false){
                    let c = credentials()
                    self.view.isUserInteractionEnabled = false
                    self.spinner.isHidden = false
                    self.project_type = self.filteredobject
                    if(self.project_type == "My Portfolios"){
                        self.project_type = "All"
                    }else if(self.project_type == "My Cities"){
                        self.project_type = "city"
                    }else if(self.project_type == "My Communities"){
                        self.project_type = "community"
                    }else if(self.project_type == "My Transit"){
                        self.project_type = "transit"
                    }else if(self.project_type == "My Parking"){
                        self.project_type = "parksmart"
                    }else if(self.project_type == "My Buildings"){
                        self.project_type = "building"
                    }else{
                        self.project_type = "All"
                    }
                    self.nobuildingsfound.isHidden = true
                    self.tableview.isUserInteractionEnabled = false
                    self.spinner.isHidden = false
                    if(self.project_type == "All"){
                        self.loadMoreDataFromServer("\(credentials().domain_url)assets/?page=\(self.page)&page_size=30", subscription_key: c.subscription_key)
                    }else{
                        if(self.project_type == "My Portfolios"){
                            self.loadMoreDataFromServer("\(credentials().domain_url)portfolios/?&page=\(self.page)&page_size=30", subscription_key: c.subscription_key)
                        }else{
                            self.loadMoreDataFromServer("\(credentials().domain_url)assets/?project_type=\(self.project_type as String)&page=\(self.page)&page_size=30", subscription_key: c.subscription_key)
                        }
                    }
                }
                
            }
        })

    }
    
    
    func getbuilding(_ token:String,subscription_key:String){
        let url = URL.init(string: String(format: "%@assets/?page_size=30&page=1",credentials().domain_url))
        print(url?.absoluteString)
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
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
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 400 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            }
            else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                })
            }else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                })
            }else{
                
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print("JSON data is",jsonDictionary)
                    DispatchQueue.main.async(execute: {
                        self.view.isUserInteractionEnabled = true
                        self.spinner.isHidden = true
                        
                        self.buildingarr = NSMutableArray.init(array: (jsonDictionary["results"]! as! NSArray).mutableCopy() as! NSMutableArray)
                        //print(buildingarr.count)
                        self.listobuildings = self.buildingarr.mutableCopy() as! NSMutableArray
                        //print("Buildings arr",buildingarr)
                        let datakeyed = NSKeyedArchiver.archivedData(withRootObject: jsonDictionary)
                        UserDefaults.standard.set(datakeyed, forKey: "assetdata")
                        UserDefaults.standard.synchronize()
                        self.gridview.reloadData()
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
            if(filteredobject == "My Portfolios"){
                buildingarr = (((NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "portfolios") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary)["results"]! as! NSArray).mutableCopy() as! NSMutableArray
            }
            if(tobefiltered.contains("All")){
                self.spinner.isHidden = true
                self.tableview.reloadData()
            }else{
                filterok(filterbtn)
            }
            self.tableview.isUserInteractionEnabled = true
            self.spinner.isHidden = true
            self.tableview.reloadData()
            
            
            DispatchQueue.main.async(execute: {
                if(self.buildingarr.count < self.size){
                    self.nobuildingsfound.isHidden = true
                    self.buildingarr = NSMutableArray()
                    self.nobuildingsfound.text = ""
                    self.tableview.reloadData()
                    self.page = 1
                    if(self.isloading == false){
                        let c = credentials()
                        self.view.isUserInteractionEnabled = false
                        self.spinner.isHidden = false
                        self.project_type = self.filteredobject
                        if(self.project_type == "My Portfolios"){
                            self.project_type = "All"
                        }else if(self.project_type == "My Cities"){
                            self.project_type = "city"
                        }else if(self.project_type == "My Communities"){
                            self.project_type = "community"
                        }else if(self.project_type == "My Transit"){
                            self.project_type = "transit"
                        }else if(self.project_type == "My Parking"){
                            self.project_type = "parksmart"
                        }else if(self.project_type == "My Buildings"){
                            self.project_type = "building"
                        }else{
                            self.project_type = "All"
                        }
                        
                        self.tableview.isUserInteractionEnabled = false
                        self.spinner.isHidden = false
                        if(self.project_type == "All"){
                            self.loadMoreDataFromServer("\(credentials().domain_url)assets/?page=\(self.page)&page_size=30", subscription_key: c.subscription_key)
                        }else{
                            if(self.project_type == "My Portfolios"){
                                self.loadMoreDataFromServer("\(credentials().domain_url)portfolios/?&page=\(self.page)", subscription_key: c.subscription_key)
                            }else{
                                self.loadMoreDataFromServer("\(credentials().domain_url)assets/?project_type=\(self.project_type as String)&page=\(self.page)&page_size=30", subscription_key: c.subscription_key)
                            }
                        }
                    }
                    
                }else{
                    if(self.project_type == "All"){
                        if(self.searchbar.text?.characters.count == 0){
                            self.spinner.isHidden = false
                            self.view.isUserInteractionEnabled = false
                            self.getstates(credentials().subscription_key)
                        }
                    }
                }
            })

        }else{
            let tempstring = str.replacingOccurrences(of: " ", with: "%20")
            str = tempstring
            var urlstring = ""
            if(project_type == "My Portfolios"){
                project_type = "All"
            }else if(project_type == "My Cities"){
                project_type = "cities"
            }else if(project_type == "My Communities"){
                project_type = "communities"
            }else if(project_type == "My Transit"){
                project_type = "transit"
            }else if(project_type == "My Parking"){
                project_type = "parksmart"
            }else if(project_type == "My Buildings"){
                project_type = "building"
            }else{
                project_type = "All"
            }
            
            if(filteredobject == "All"){
                self.navigationItem.title = "All projects"
            }
            if(filteredobject == "My Buildings"){
                self.navigationItem.title = "My Buildings"
            }
            if(filteredobject == "My Cities"){
                self.navigationItem.title = "My Cities"
            }
            
            if(filteredobject == "My Communities"){
                self.navigationItem.title = "My Communities"
            }
            
            if(filteredobject == "My Parking"){
                self.navigationItem.title = "My Parking"
            }
            
            if(filteredobject == "My Transit"){
                self.navigationItem.title = "My Transit"
            }
            
            if(filteredobject == "My Portfolios"){
                self.navigationItem.title = "Portfolios"
            }
            
            
            if(project_type == "All"){
                //   loadMoreDataFromServer("\(credentials().domain_url)assets/?page=\(page)", subscription_key: c.subscription_key)
                urlstring = String(format: "%@assets/search/?q=%@&page_size=30",credentials().domain_url,str)
            }else{
                urlstring = String(format: "%@assets/search/?q=%@&project_type=\(project_type as String)&page_size=30",credentials().domain_url,str)
            }
            
            DispatchQueue.main.async(execute: {
                self.spinner.isHidden = false
            })
            if(timer.isValid){
                timer.invalidate()
            }
            searchurl = urlstring
            timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.getsearchbuilding), userInfo: nil, repeats: false)
            
        }
        
    }
    
    
    func showalert(_ message:String, title:String, action:String){
        
        //let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        //let callActionHandler = { (action:UIAlertAction!) -> Void in
        DispatchQueue.main.async(execute: {
            self.gridview.isUserInteractionEnabled = true
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

    
    @IBOutlet weak var spinner: UIView!
    var searchurl = ""
    
    
    @objc func getsearchbuilding(){
        DispatchQueue.main.async(execute: {
          self.gridview.isUserInteractionEnabled = false
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        })
        var urlstring = searchurl
        let url = URL.init(string: urlstring)
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        var token = UserDefaults.standard.object(forKey: "token") as! String
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(session)
        self.task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                //print("error=\(error)",error?._code)
                if(self.filteredobject == "My Portfolios"){
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
            DispatchQueue.main.async(execute:{
                self.nobuildingsfound.text = "No projects found"
            })
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
                        
                        var building = (jsonDictionary["building"] as! NSArray).mutableCopy() as! NSMutableArray
                        if(building.count > 0){
                            var temp = NSMutableArray()
                            for item in building{
                                var a = item as! NSDictionary
                                if(self.filteredobject == "My Cities"){
                                    if(a["project_type"] as! String == "city"){
                                        temp.add(a)
                                    }
                                }
                                
                                if(self.filteredobject == "My Communities"){
                                    if(a["project_type"] as! String == "community"){
                                        temp.add(a)
                                    }
                                }
                                
                                if(self.filteredobject == "My Transit"){
                                    if(a["project_type"] as! String == "transit"){
                                        temp.add(a)
                                    }
                                }
                                
                                if(self.filteredobject == "My Parking"){
                                    if(a["project_type"] as! String == "parksmart"){
                                        temp.add(a)
                                    }
                                }
                                
                                if(self.filteredobject == "My Buildings"){
                                    if(a["project_type"] as! String == "building"){
                                        temp.add(a)
                                    }
                                }
                                
                                if(self.filteredobject == "All"){
                                    temp.add(a)
                                }
                            }
                            //print(jsonDictionary.allKeys)
                            jsonDictionary["building"] = temp
                            
                            self.searcharr = jsonDictionary.mutableCopy() as! NSMutableDictionary
                            self.buildingarr = (jsonDictionary["building"] as! NSArray).mutableCopy() as! NSMutableArray
                            self.searcharr = jsonDictionary.mutableCopy() as! NSMutableDictionary
                            //self.buildingarr = jsonDictionary.mutableCopy() as! NSMutableArray
                            DispatchQueue.main.async(execute: {
                                self.spinner.isHidden = true
                                self.view.isUserInteractionEnabled = true
                                self.gridview.isUserInteractionEnabled = true
        self.navigationItem.leftBarButtonItem?.isEnabled = true
                            })
                            DispatchQueue.main.async(execute: {
                                self.gridview.isUserInteractionEnabled = true
        self.navigationItem.leftBarButtonItem?.isEnabled = true
                                if(self.tobefiltered.contains("All")){
                                    self.gridview.reloadData()
                                }else{
                                    self.filterok(self.filterbtn)
                                    self.gridview.reloadData()
                                }
                                self.gridview.isUserInteractionEnabled = true
        self.navigationItem.leftBarButtonItem?.isEnabled = true
                            })
                        }else{
                            DispatchQueue.main.async(execute: {
                                self.spinner.isHidden = true
                                self.view.isUserInteractionEnabled = true
                                self.buildingarr = building
                                self.searcharr = jsonDictionary.mutableCopy() as! NSMutableDictionary
                                self.gridview.isUserInteractionEnabled = true
        self.navigationItem.leftBarButtonItem?.isEnabled = true
                                self.gridview.reloadData()
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
    
    var filteredobject = ""
    
    @IBOutlet weak var segctrl: UISegmentedControl!
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        //print(UIScreen.main.bounds.size.width)
        return CGSize(width: UIScreen.main.bounds.size.height * 0.17,height: UIScreen.main.bounds.size.height * 0.17)
    }
    
    
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(buildingarr.count>0){
            self.nobuildingsfound.isHidden = true
            self.gridview.isHidden = false
        }else{
            self.nobuildingsfound.isHidden = false
            self.gridview.isHidden = true
        }
        return buildingarr.count
    }
    var searcharr = NSMutableDictionary()
    var typ = ""
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UserDefaults.standard.set(0, forKey: "fromnotifications")
        searchbar.resignFirstResponder()
        UserDefaults.standard.set(0, forKey: "grid")
        if(UserDefaults.standard.integer(forKey: "survey") == 1){
            UserDefaults.standard.removeObject(forKey: "building_details")
        }
        UserDefaults.standard.set(0, forKey: "survey")
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let currentbuilding = (buildingarr[indexPath.row] as! NSDictionary).mutableCopy() as! NSMutableDictionary
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
                    /*for m in 0..<ar.count{
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
                     
                     }*/
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
        
    }
    
    @IBOutlet weak var addbutton: UIButton!
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "assetcell", for: indexPath) as! assetcollectionviewcell        
        let arr = (buildingarr[indexPath.row] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        cell.leedid.text = String(format: "%d",arr["leed_id"] as! Int)
        cell.assetname.text = String(format: "%@",(arr["name"] as? String)!)
        cell.assetname.font = UIFont.init(name: "OpenSans-Semibold", size: fontsize1 * UIScreen.main.bounds.size.width)
        cell.status.font = UIFont.init(name: "OpenSans", size: fontsize * UIScreen.main.bounds.size.width)
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
            }else if(update == "activated_under_review"){
                cell.status.text = "Under review"
            }else{
                cell.status.text = ""
            }
            
            //  //print(dateFormat.stringFromDate(dte!))
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchbar.resignFirstResponder()
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if(offsetY > 0){
        if offsetY > contentHeight - scrollView.frame.size.height {
            //print(assets["next"])
            if (assets["next"] as? String) != nil {
                if(isloading == false){
                    let c = credentials()
                    DispatchQueue.main.async(execute: {
                        self.view.isUserInteractionEnabled = false
                        self.spinner.isHidden = false
                    })
                    self.toloadmore = 1
                    if(project_type == "All"){
                        loadMoreDataFromServer("\(credentials().domain_url)assets/?page=\(page)&page_size=30", subscription_key: c.subscription_key)
                    }else{
                        loadMoreDataFromServer("\(credentials().domain_url)assets/?project_type=\(project_type )&page=\(page)&page_size=30", subscription_key: c.subscription_key)
                    }
                }
            }else{
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    self.gridview.isUserInteractionEnabled = true
        self.navigationItem.leftBarButtonItem?.isEnabled = true
                    self.maketoast("That was all", type: "message")
                  
                })
            }
            }}
    }
    var project_type = ""
    
    func loadMoreDataFromServer(_ URL:String, subscription_key:String){
        DispatchQueue.main.async(execute: {
        self.gridview.isUserInteractionEnabled = false
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        })
        let url = Foundation.URL.init(string: URL)
        let request = NSMutableURLRequest(url:  url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 180.0)
        request.httpMethod = "GET"
        isloading = true
        print(url?.absoluteString)
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token as! String), forHTTPHeaderField:"Authorization" )
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
            
            DispatchQueue.main.async(execute:{
                self.nobuildingsfound.text = "No projects found"
            })
            
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 404 {           // check for http
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    self.gridview.isUserInteractionEnabled = true
        self.navigationItem.leftBarButtonItem?.isEnabled = true
                self.maketoast("That was all", type: "message")
                    return
                })
            }
            else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
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
                        jsonDictionary = try (JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary).mutableCopy() as! NSMutableDictionary as NSDictionary
                        DispatchQueue.main.async(execute: {
                            
                            self.gridview.isUserInteractionEnabled = true
        self.navigationItem.leftBarButtonItem?.isEnabled = true
                            if(jsonDictionary["results"] != nil){
                                self.assets = jsonDictionary.mutableCopy() as! NSMutableDictionary
                                let temparr = self.assets["results"] as! NSArray
                                let tempbuilding = NSMutableArray()
                                for i in 0..<self.buildingarr.count {
                                    tempbuilding.add(self.buildingarr.object(at: i))
                                }
                                for i in 0..<temparr.count {
                                    tempbuilding.add(temparr.object(at: i))
                                }
                                self.buildingarr = tempbuilding.mutableCopy() as! NSMutableArray
                                self.page = self.page + 1
                                
                            }
                            self.filterok(self.filterclosebtn)
                            //self.gridview.reloadData()
                            self.isloading = false
                            self.view.isUserInteractionEnabled = true
                            self.spinner.isHidden = true
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
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    
    
    
    @IBAction func logout(_ sender: AnyObject) {
        timer.invalidate()
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController(title: "Logout", message: "Would you like to logout from the current user?", preferredStyle: .alert)
            let callActionHandler = { (action:UIAlertAction!) -> Void in
                    UserDefaults.standard.removeObject(forKey: "token")
                    UserDefaults.standard.removeObject(forKey: "username")
                    UserDefaults.standard.removeObject(forKey: "password")
                    let noinstructions = UserDefaults.standard.integer(forKey: "noinstructions")
                    if let bid = Bundle.main.bundleIdentifier {
                        UserDefaults.standard.removePersistentDomain(forName: bid)
                    }
                    UserDefaults.standard.set(noinstructions, forKey: "noinstructions")
                    if let bid = Bundle.main.bundleIdentifier {
                        UserDefaults.standard.removePersistentDomain(forName: bid)
                    }
                    UserDefaults.standard.set(noinstructions, forKey: "noinstructions")
                    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                    UserDefaults.standard.removeObject(forKey: "token")
                    UserDefaults.standard.removeObject(forKey: "username")
                    UserDefaults.standard.removeObject(forKey: "password")
                    UserDefaults.standard.removeObject(forKey: "tobefiltered")
                    if let bid = Bundle.main.bundleIdentifier {
                        UserDefaults.standard.removePersistentDomain(forName: bid)
                    }
                    UserDefaults.standard.synchronize()
                    UserDefaults.standard.synchronize()
                    self.performSegue(withIdentifier: "gotologin", sender: nil)
                    self.navigationController?.popViewController(animated: true)
                
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
    
    func imageWithImage(_ image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

    @IBAction func customise(_ sender: AnyObject) {
            self.performSegue(withIdentifier: "gotolist", sender: nil)

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
                            var temparr = NSMutableArray()
                            for i in jsonDictionary{
                                let d = i as! NSDictionary
                                let foreign_id = d["foreign_id"] as! String
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
                                if (self.typ == "building" || self.typ == "city" || self.typ == "community"){
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
                            
                            if(self.typ == "city" || self.typ == "community"){
                                temparr = NSMutableArray()
                                for i in jsonDictionary{
                                    let d = i as! NSDictionary
                                    let foreign_id = d["foreign_id"] as! String
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
                                    
                                    if (foreign_id == "review_recurring_payment")
                                    {
                                        // remove from array
                                    }
                                    
                                    if (foreign_id == "data_input_fuel")
                                    {
                                        // remove from array
                                    }
                                    if (foreign_id == "data_input_operating_hours")
                                    {
                                        // remove from array
                                    }
                                    if (foreign_id == "data_input_density")
                                    {
                                        // remove from array
                                    }
                                    if (foreign_id == "data_input_occupancy")
                                    {
                                        // remove from array
                                    }
                                    if (foreign_id == "data_input_gfa")
                                    {
                                        // remove from array
                                    }
                                    
                                    
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
                                        //temparr.add(d)
                                    }
                                    else if(foreign_id == "data_input_density")
                                    {
                                        //temparr.add(d)
                                    }
                                    else if(foreign_id == "data_input_occupancy")
                                    {
                                        //temparr.add(d)
                                    }
                                    else if(foreign_id == "data_input_gfa")
                                    {
                                        //temparr.add(d)
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
                            let data = NSKeyedArchiver.archivedData(withRootObject: jsonDictionary)
                            UserDefaults.standard.set(data, forKey: "countries")
                            self.getbuilding(self.token, subscription_key: subscription_key)
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

 
}



