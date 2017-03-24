//
//  listofactions.swift
//  MySampleApp
//
//  Created by Group X on 08/11/16.
//
//

import UIKit

class listofactions: UIViewController,UITableViewDelegate,UITableViewDataSource, UITabBarDelegate {

    @IBOutlet weak var segmentedctrl: UISegmentedControl!
    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var buildingname: UILabel!
    @IBOutlet weak var tableview: UITableView!
    var currentarr = NSMutableArray()
    var allactionsarr = NSMutableArray()
    var pre_requisitesactionsarr = NSMutableArray()
    var data_input = NSMutableArray()
    var base_scores = NSMutableArray()
       var filterarr = NSMutableArray()
    @IBOutlet weak var nav: UINavigationBar!
    
    override func viewDidAppear(animated: Bool) {
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "fromnotification")
        self.navigationController?.navigationBar.backItem?.title = "Projects"
        print("Filter array is",filterarr)
        if(filterarr.count == 0){
            filterarr.addObject("All actions")
        }
        self.viewDidLoad()
    }
    
    @IBAction func filterit(sender: UIBarButtonItem) {
        self.filter(sender)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
        backbtn.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12)
        tableview.backgroundColor = nav.backgroundColor
        let notificationsarr = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("notifications") as! NSData) as! NSArray
        if(notificationsarr.count > 0 ){
            self.tabbar.items![4].badgeValue = "\(notificationsarr.count)"
        }else{
            self.tabbar.items![4].badgeValue = nil
        }
        let segmented_titles = ["All actions","Pre-requisites","Data input","Base scores"]
        
        for  i in 0  ..< segmented_titles.count {
            segmentedctrl.setTitle(segmented_titles[i], forSegmentAtIndex: i)
        }
        
        let font = UIFont.boldSystemFontOfSize(9.0)
        let attributes = NSDictionary.init(object: font, forKey: NSFontAttributeName)
        segmentedctrl.setTitleTextAttributes(attributes as [NSObject : AnyObject], forState: UIControlState.Normal )
        
        
        self.tabbar.delegate = self
        self.tabbar.selectedItem = self.tabbar.items![1]
        self.tableview.registerNib(UINib.init(nibName: "customcellTableViewCell", bundle: nil), forCellReuseIdentifier: "cell1")
        var datakeyed = NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData
        var assets = NSKeyedUnarchiver.unarchiveObjectWithData(datakeyed)?.mutableCopy() as! NSMutableDictionary
        print(assets)
        self.buildingname.text = String(format: "%@",(assets["name"] as? String)!)
        self.view.bringSubviewToFront(nav)
        let navItem = UINavigationItem(title: (assets["name"] as? String)!);
        self.navigationItem.title = assets["name"] as? String
        self.nav.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!]
        let doneItem = UIBarButtonItem(title: "< Projects", style: .Plain, target: self, action: #selector(sayHello(_:)))
        let filteritem = UIBarButtonItem(title: "", style: .Plain, target: self, action: #selector(filter(_:)))
        navItem.leftBarButtonItem = doneItem;
        navItem.rightBarButtonItem = filteritem;
        navItem.rightBarButtonItem?.image = self.imageWithImage(UIImage(named: "filtericon.png")!, scaledToSize: CGSizeMake(32, 32))
        self.navigationItem.rightBarButtonItem?.image = self.imageWithImage(UIImage(named: "filtericon.png")!, scaledToSize: CGSizeMake(32, 32))
        nav.setItems([navItem], animated: false);
        self.navigationItem.rightBarButtonItem?.title = ""
        
        datakeyed = NSUserDefaults.standardUserDefaults().objectForKey("actions_data") as! NSData
        assets = NSKeyedUnarchiver.unarchiveObjectWithData(datakeyed)?.mutableCopy() as! NSMutableDictionary
        currentarr = assets["EtScorecardList"]!.mutableCopy() as! NSMutableArray
        allactionsarr = currentarr
        print("Action count ",currentarr)
        
        pre_requisitesactionsarr = NSMutableArray()
        data_input = NSMutableArray()
        base_scores = NSMutableArray()
        for i in 0 ..< currentarr.count {
            let tempdict = currentarr[i] as! [String:AnyObject]
            if(tempdict["CreditcategoryDescrption"] as! String == "Innovation"){
                pre_requisitesactionsarr.addObject(tempdict)
            }
            if(tempdict["Mandatory"] as! String == "X" && tempdict["CreditcategoryDescrption"] as! String != "Performance" && tempdict["CreditcategoryDescrption"] as! String != "Performance Category"){
                pre_requisitesactionsarr.addObject(tempdict)
            }
        }
        for i in 0 ..< currentarr.count {
            let tempdict = currentarr[i] as! [String:AnyObject]
            if(tempdict["CreditcategoryDescrption"] as! String == "Performance" || (tempdict["CreditcategoryDescrption"] as! String == "Performance Category")){
                data_input.addObject(tempdict)
            }
        }
        for i in 0 ..< currentarr.count {
            let tempdict = currentarr[i] as! [String:AnyObject]
            if((tempdict["Mandatory"] as! String != "X") && (tempdict["CreditcategoryDescrption"] as! String != "Performance" || tempdict["CreditcategoryDescrption"] as! String != "Performance Category") && tempdict["CreditcategoryDescrption"] as! String != "Innovation"){
                base_scores.addObject(tempdict)
            }
        }
        
        
        print("BAse scre",base_scores)
        print("data input",data_input)
        print("pre_requisitesactionsarr",pre_requisitesactionsarr)
            if(filterarr.containsObject("All actions")){
                currentarr = allactionsarr
            }
            if (filterarr.containsObject("Pre-requisites")){
                currentarr = pre_requisitesactionsarr
            }
            if (filterarr.containsObject("Data input")){
                currentarr =  data_input
            }
            if(filterarr.containsObject("Base scores")){
                currentarr = base_scores
            }
        
        var temparr = NSMutableArray()
        if(filterarr.containsObject("To me")){
        for i in 0 ..< currentarr.count {
        let arr = currentarr.objectAtIndex(i) as! [String:AnyObject]
        if (arr["CreditDescription"] as? String) != nil{
            if let assignedto = arr["PersonAssigned"] as? String{
                _ = assignedto
                    temparr.addObject(arr)
                //if let firstname = temp["first_name"] as? String{
                    
                //}
            }else{
                //text += " None"
            }
            }
        }
            currentarr = temparr
        }
        
        temparr = NSMutableArray()
        
        if(filterarr.containsObject("To somebody")){
            for i in 0 ..< currentarr.count {
                let arr = currentarr.objectAtIndex(i) as! [String:AnyObject]
                if (arr["CreditDescription"] as? String) != nil{
                    if (arr["PersonAssigned"] as? String) != nil{
                               temparr.addObject(arr)
                    }else{
                        //text += " None"
                    }
                }
            }
            currentarr = temparr
        }
        temparr = NSMutableArray()
        
        if(filterarr.containsObject("To None")){
            for i in 0 ..< currentarr.count {
                let arr = currentarr.objectAtIndex(i) as! [String:AnyObject]
                    if let assignedto = arr["PersonAssigned"] as? String{
                        let temp = assignedto
                        print(temp)
                    }else{
                        temparr.addObject(arr)
                    }
            }
            currentarr = temparr
        }
        
        temparr = NSMutableArray()
        
        if(filterarr.containsObject("Attempted")){
            for i in 0 ..< currentarr.count {
                let arr = currentarr.objectAtIndex(i) as! [String:AnyObject]
                if let creditDescription = arr["CreditStatus"] as? String{
                    if(creditDescription == "Attempted"){
                        temparr.addObject(arr)
                    }
                    
                }
            }
            currentarr = temparr
        }
        temparr = NSMutableArray()
        
        if(filterarr.containsObject("Under review")){
            for i in 0 ..< currentarr.count {
                let arr = currentarr.objectAtIndex(i) as! [String:AnyObject]
                if let creditDescription = arr["CreditStatus"] as? String{
                    if(creditDescription == "Under review"){
                        temparr.addObject(arr)
                    }
                    
                }
            }
        currentarr = temparr
        }
        
        temparr = NSMutableArray()
        print("currentarr ", currentarr)
        let or = NSOrderedSet.init(array: currentarr as [AnyObject])
        currentarr = or.array as! NSMutableArray
        datakeyed = NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData
        assets = NSKeyedUnarchiver.unarchiveObjectWithData(datakeyed)?.mutableCopy() as! NSMutableDictionary
        print(assets)
        if(assets["project_type"] as! String == "building" && assets["rating_system"] as! String != "LEED V4 O+M: EB WP"){
            currentarr = NSMutableArray()
            currentarr = data_input
        }
        tableview.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    func imageWithImage(image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func sayHello(sender: UIBarButtonItem) {
        print("Projects clicked")
        NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"listofassets"])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gotofilter" {
            let secondViewController = segue.destinationViewController as! filtercredits
            secondViewController.firstViewController = self
            secondViewController.filterarr = filterarr
        }
    }
    
    func filter(sender: UIBarButtonItem) {
        print("Projects clicked")
        
        self.performSegueWithIdentifier("gotofilter", sender: nil)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return currentarr.count
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    @IBOutlet weak var backbtn: UIButton!
    
    @IBAction func filterme(sender: AnyObject) {
        let segmentedControl = sender as! UISegmentedControl
        let selectedsegment = segmentedControl.selectedSegmentIndex
        if(selectedsegment == 0 ){
            currentarr = allactionsarr
            tableview.reloadData()
        }else if (selectedsegment == 1){
            currentarr = pre_requisitesactionsarr
            tableview.reloadData()
        }else if (selectedsegment == 2){
            currentarr =  data_input
            tableview.reloadData()
        }else{
            currentarr = base_scores
            tableview.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as! customcellTableViewCell
        //CreditDescription, AssignedTo // first_name
        var linkTextWithColor = ""
        var text = ""
        let arr = currentarr.objectAtIndex(indexPath.section) as! [String:AnyObject]
        if let creditDescription = arr["CreditDescription"] as? String{
            cell.namelbl.text = creditDescription
            text  = "Assigned to"
            if let assignedto = arr["PersonAssigned"] as? String{
                let temp = assignedto
                    text += " " + temp.capitalizedString
                if(temp == "" || temp == ""){
                    text += "None"
                }
            }else{
                text += " None"
            }
            linkTextWithColor = "assigned to"
            let range = (text as NSString).rangeOfString(linkTextWithColor)
            
            let attributedString = NSMutableAttributedString(string:text)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGrayColor() , range: range)
            cell.assignee.attributedText = attributedString
            
        }
        
        
        
        if let creditstatus = arr["CreditStatus"] as? String{
            cell.creditstatus.text = String(format: "%@",creditstatus.capitalizedString)
            if(creditstatus == "Ready for Review"){
                cell.creditstatusimg.image = UIImage.init(named: "tick")
            }else{
                cell.creditstatusimg.image = UIImage.init(named: "circle")
            }
            
            if(cell.creditstatus.text == ""){
                cell.creditstatus.text = "Not available"
            }
        }
        
        
        if(arr["CreditcategoryDescrption"] as! String == "Indoor Environmental Quality"){
            cell.shortcredit.image = UIImage.init(named: "iq-border")
        }else if(arr["CreditcategoryDescrption"] as! String == "Materials and Resources"){
            cell.shortcredit.image = UIImage.init(named: "mr-border")
        }else if(arr["CreditcategoryDescrption"] as! String == "Energy and Atmosphere"){
            cell.shortcredit.image = UIImage.init(named: "ea-border")
        }else if(arr["CreditcategoryDescrption"] as! String == "Water Efficiency"){
            cell.shortcredit.image = UIImage.init(named: "we-border")
        }else if(arr["CreditcategoryDescrption"] as! String == "Sustainable Sites"){
            cell.shortcredit.image = UIImage.init(named: "ss-border")
        }else if(arr["CreditcategoryDescrption"] as! String == "Innovation"){
            cell.shortcredit.image = UIImage.init(named: "id-border")
        }else if(arr["CreditcategoryDescrption"] as! String == "Prerequiste"){
            cell.shortcredit.image = self.imageWithImage(UIImage(named: "settings.png")!, scaledToSize: CGSizeMake(32, 32))
        }else{
            if((arr["CreditDescription"] as! String).lowercaseString == "energy"){
                cell.shortcredit.image = UIImage.init(named: "energy-border")
            }else if((arr["CreditDescription"] as! String).lowercaseString == "water"){
                cell.shortcredit.image = UIImage.init(named: "water-border")
            }else if((arr["CreditDescription"] as! String).lowercaseString == "waste"){
                cell.shortcredit.image = UIImage.init(named: "waste-border")
            }
            else if((arr["CreditDescription"] as! String).lowercaseString == "transportation"){
                cell.shortcredit.image = UIImage.init(named: "transport-border")
            }else{
                cell.shortcredit.image = UIImage.init(named: "human-border")
            }
        }
        
        
        return cell
    }
    
    func checkcredit_type(tempdict:[String:AnyObject]) -> String {
        var temp = ""
        if(tempdict["CreditcategoryDescrption"] as! String == "Performance" || tempdict["CreditcategoryDescrption"] as! String == "Performance Category"){
            temp = "Data input"
        }
        else if((tempdict["Mandatory"] as! String != "X") && (tempdict["CreditcategoryDescrption"] as! String != "Performance" || tempdict["CreditcategoryDescrption"] as! String != "Performance Category") && tempdict["CreditcategoryDescrption"] as! String != "Innovation"){
            temp = "Base scores"
        }else if(tempdict["Mandatory"] as! String == "X" || tempdict["CreditcategoryDescrption"] as! String == "Innovation"){
            temp = "Pre-requisites"
        }
        
        return temp
    }
    
    @IBAction func goback(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"plaque"])
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let arr = currentarr.objectAtIndex(indexPath.section) as! [String:AnyObject]
        print("The category is", checkcredit_type(arr))
        if(checkcredit_type(arr) == "Pre-requisites" || checkcredit_type(arr) == "Base scores"){
            let data = NSKeyedArchiver.archivedDataWithRootObject(currentarr)
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: "currentcategory")
            
            NSUserDefaults.standardUserDefaults().setInteger(indexPath.section, forKey: "selected_action")
            //self.performSegueWithIdentifier("prerequisites", sender: nil)
            let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            
            let listofactions = mainstoryboard.instantiateViewControllerWithIdentifier("listofactions")
            let datainput = mainstoryboard.instantiateViewControllerWithIdentifier("prerequisites")
            let rootViewController = self.navigationController
            var controllers = (rootViewController!.viewControllers)
            controllers.removeAll()
            var v = UIViewController()
            if(NSUserDefaults.standardUserDefaults().integerForKey("grid") == 1){
                v = mainstoryboard.instantiateViewControllerWithIdentifier("grid") as! UINavigationController
            }else{
                v = mainstoryboard.instantiateViewControllerWithIdentifier("listofassets") as! UINavigationController
            }
            var grid = 0
            grid = NSUserDefaults.standardUserDefaults().integerForKey("grid")
            var listofassets = mainstoryboard.instantiateViewControllerWithIdentifier("projectslist")
            if(grid == 1){
                listofassets = mainstoryboard.instantiateViewControllerWithIdentifier("gridvc")
            }else{
                listofassets = mainstoryboard.instantiateViewControllerWithIdentifier("projectslist")
            }
            _ = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary
            listofassets.navigationItem.title = "Projects"
            controllers.append(listofassets)
            controllers.append(listofactions)
            controllers.append(datainput)
            self.navigationController?.setViewControllers(controllers, animated: true)
            
            
        }else if(checkcredit_type(arr) == "Data input"){
            let data = NSKeyedArchiver.archivedDataWithRootObject(currentarr)
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: "currentcategory")
            
            NSUserDefaults.standardUserDefaults().setInteger(indexPath.section, forKey: "selected_action")
            if((arr["CreditDescription"] as! String).lowercaseString == "energy" || (arr["CreditDescription"] as! String).lowercaseString == "water"){
                //self.performSegueWithIdentifier("datainput", sender: nil)
                let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                let listofactions = mainstoryboard.instantiateViewControllerWithIdentifier("listofactions")
                let datainput = mainstoryboard.instantiateViewControllerWithIdentifier("datainput")
                let rootViewController = self.navigationController
                var controllers = (rootViewController!.viewControllers)
                controllers.removeAll()
                var v = UIViewController()
                if(NSUserDefaults.standardUserDefaults().integerForKey("grid") == 1){
                    v = mainstoryboard.instantiateViewControllerWithIdentifier("grid") as! UINavigationController
                }else{
                    v = mainstoryboard.instantiateViewControllerWithIdentifier("listofassets") as! UINavigationController
                }
                var grid = 0
                grid = NSUserDefaults.standardUserDefaults().integerForKey("grid")
                var listofassets = mainstoryboard.instantiateViewControllerWithIdentifier("projectslist")
                if(grid == 1){
                    listofassets = mainstoryboard.instantiateViewControllerWithIdentifier("gridvc")
                }else{
                    listofassets = mainstoryboard.instantiateViewControllerWithIdentifier("projectslist")
                }
                let dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary
                listofassets.navigationItem.title = "Projects"
                controllers.append(listofassets)
                controllers.append(listofactions)
                controllers.append(datainput)
                self.navigationController?.setViewControllers(controllers, animated: true)
                
            }else if((arr["CreditDescription"] as! String).lowercaseString == "waste" || (arr["CreditDescription"] as! String).lowercaseString == "transportation" || (arr["CreditDescription"] as! String).lowercaseString == "human experience"){
                //self.performSegueWithIdentifier("gotowaste", sender: nil)
                let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                
                let listofactions = mainstoryboard.instantiateViewControllerWithIdentifier("listofactions")
                let datainput = mainstoryboard.instantiateViewControllerWithIdentifier("waste")
                let rootViewController = self.navigationController
                var controllers = (rootViewController!.viewControllers)
                controllers.removeAll()
                var v = UIViewController()
                if(NSUserDefaults.standardUserDefaults().integerForKey("grid") == 1){
                    v = mainstoryboard.instantiateViewControllerWithIdentifier("grid") as! UINavigationController
                }else{
                    v = mainstoryboard.instantiateViewControllerWithIdentifier("listofassets") as! UINavigationController
                }
                var grid = 0
                grid = NSUserDefaults.standardUserDefaults().integerForKey("grid")
                var listofassets = mainstoryboard.instantiateViewControllerWithIdentifier("projectslist")
                if(grid == 1){
                    listofassets = mainstoryboard.instantiateViewControllerWithIdentifier("gridvc")
                }else{
                    listofassets = mainstoryboard.instantiateViewControllerWithIdentifier("projectslist") 
                }
                _ = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary
                listofassets.navigationItem.title = "Projects"
                controllers.append(listofassets)
                controllers.append(listofactions)
                controllers.append(datainput)
                //self.navigationController!.hidesBarsOnTap = false;
                //self.navigationController!.hidesBarsOnSwipe = false;
                //self.navigationController!.hidesBarsWhenVerticallyCompact = false;
                self.navigationController?.setViewControllers(controllers, animated: true)
            }
        }
    }

    func sendValue(value: NSString) {
        
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


