//
//  listofactions.swift
//  MySampleApp
//
//  Created by Group X on 08/11/16.
//
//

import UIKit

class listofactions: UIViewController,UITableViewDelegate,UITableViewDataSource, UITabBarDelegate {

    @IBOutlet weak var notfound: UILabel!
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if(UserDefaults.standard.object(forKey: "actions_data") != nil){
            var datakeyed = UserDefaults.standard.object(forKey: "actions_data") as! Data
            var assets = (NSKeyedUnarchiver.unarchiveObject(with: datakeyed) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            currentarr = (assets["EtScorecardList"]! as! NSArray).mutableCopy() as! NSMutableArray
            
            allactionsarr = currentarr
            //print("Action count ",currentarr)
            
            pre_requisitesactionsarr = NSMutableArray()
            data_input = NSMutableArray()
            base_scores = NSMutableArray()
            for i in 0 ..< currentarr.count {
                let tempdict = (currentarr[i] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                /*if(tempdict["CreditcategoryDescrption"] as! String == "Innovation"){
                 pre_requisitesactionsarr.addObject(tempdict)
                 }*/
                //if(tempdict["Mandatory"] as! String == "X" && tempdict["CreditcategoryDescrption"] as! String != "Performance" && tempdict["CreditcategoryDescrption"] as! String != "Performance Category"){
                if(tempdict["Mandatory"] as! String == "X"){
                    pre_requisitesactionsarr.add(tempdict)
                }else if ((tempdict["Mandatory"] as! String != "X") && (tempdict["CreditcategoryDescrption"] as! String != "Performance Category") && (tempdict["CreditcategoryDescrption"] as! String != "Performance")){
                    base_scores.add(tempdict)
                }
                else{//(tempdict["CreditcategoryDescrption"] as! String == "Performance" || (tempdict["CreditcategoryDescrption"] as! String == "Performance Category"))
                    data_input.add(tempdict)
                }
                
                
            }
            
            
            //print("BAse scre",base_scores)
            //print("data input",data_input)
            //print("pre_requisitesactionsarr",pre_requisitesactionsarr)
            if(filterarr.contains("All actions")){
                currentarr = allactionsarr
            }
            if (filterarr.contains("Pre-requisites")){
                currentarr = pre_requisitesactionsarr
            }
            if (filterarr.contains("Data input")){
                currentarr =  data_input
            }
            if(filterarr.contains("Base points")){
                currentarr = base_scores
            }
            
            var temparr = NSMutableArray()
            if(filterarr.contains("To me")){
                let me = UserDefaults.standard.object(forKey: "currentuser") as! String
                for i in 0 ..< currentarr.count {
                    let arr = (currentarr.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    if (arr["CreditDescription"] as? String) != nil{
                        if let assignedto = arr["PersonAssigned"] as? String{
                            if (assignedto == me){
                            temparr.add(arr)
                            }
                        }else{
                            //text += " None"
                        }
                    }
                }
                currentarr = temparr
            }
            
            temparr = NSMutableArray()
            
            if(filterarr.contains("To somebody")){
                let me = UserDefaults.standard.object(forKey: "currentuser") as! String
                for i in 0 ..< currentarr.count {
                    let arr = (currentarr.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    if (arr["CreditDescription"] as? String) != nil{
                        if let assignedto = arr["PersonAssigned"] as? String{
                            if (assignedto != me && assignedto != ""){
                                temparr.add(arr)
                            }
                        }else{
                            //text += " None"
                        }
                    }
                }
                currentarr = temparr
            }
            temparr = NSMutableArray()
            
            if(filterarr.contains("To None")){
                var me = UserDefaults.standard.object(forKey: "currentuser") as! String
                for i in 0 ..< currentarr.count {
                    let arr = (currentarr.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    if let assignedto = arr["PersonAssigned"] as? String{
                        if (assignedto == ""){
                            temparr.add(arr)
                        }
                    }else{
                        //text += " None"
                    }
                }
                currentarr = temparr
            }
            
            temparr = NSMutableArray()
            
            if(filterarr.contains("Attempted")){
                for i in 0 ..< currentarr.count {
                    let arr = (currentarr.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    if let creditDescription = arr["CreditStatus"] as? String{
                        if(creditDescription.lowercased() == "attempted"){
                            temparr.add(arr)
                        }
                        
                    }
                }
                currentarr = temparr
            }
            temparr = NSMutableArray()
            
            if(filterarr.contains("Under review")){
                for i in 0 ..< currentarr.count {
                    let arr = (currentarr.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    if let creditDescription = arr["CreditStatus"] as? String{
                        if(creditDescription.lowercased() == "under review"){
                            temparr.add(arr)
                        }
                        
                    }
                }
                currentarr = temparr
            }
            
            temparr = NSMutableArray()
            
            if(filterarr.contains("Ready for review")){
                for i in 0 ..< currentarr.count {
                    let arr = (currentarr.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    if let creditDescription = arr["CreditStatus"] as? String{
                        if(creditDescription.lowercased() == "ready for review"){
                            temparr.add(arr)
                        }
                        
                    }
                }
                currentarr = temparr
            }
            
            temparr = NSMutableArray()
            //print("currentarr ", currentarr)
            let or = NSOrderedSet.init(array: currentarr as [AnyObject])
            currentarr = (or.array as NSArray).mutableCopy() as! NSMutableArray
            datakeyed = UserDefaults.standard.object(forKey: "building_details") as! Data
            assets = (NSKeyedUnarchiver.unarchiveObject(with: datakeyed) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            //print(assets)
            if(assets["project_type"] as! String == "building" && assets["rating_system"] as! String != "LEED V4 O+M: EB WP"){
                currentarr = NSMutableArray()
                currentarr = data_input
            }
            if(currentarr.count > 0){
                notfound.isHidden = true
            }else{
                notfound.isHidden = false
            }
            tableview.reloadData()
        }else{
            DispatchQueue.main.async(execute: {
                self.spinner.isHidden = false
                self.buildingactions(credentials().subscription_key, leedid: self.building_dict["leed_id"] as! Int)
            })
        }

        UserDefaults.standard.set(0, forKey: "fromnotification")
        //print("Filter array is",filterarr)
        if(filterarr.count == 0){
            filterarr.add("All actions")
        }
        if(self.navigationController != nil){
        self.navigationController!.navigationBar.backItem!.title = "Projects"
        }
        self.spinner.layer.cornerRadius = 5
        self.spinner.isHidden = true
    }
    
    @IBAction func filterit(_ sender: UIBarButtonItem) {
        self.filter(sender)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        notfound.isHidden = true
        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.none
        building_dict = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary
        self.titlefont()
        backbtn.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12)
        tableview.backgroundColor = nav.backgroundColor
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
        let segmented_titles = ["All actions","Pre-requisites","Data input","Base scores"]
        
        for  i in 0  ..< segmented_titles.count {
            segmentedctrl.setTitle(segmented_titles[i], forSegmentAt: i)
        }
        
        let font = UIFont.boldSystemFont(ofSize: 9.0)
        let attributes = NSDictionary.init(object: font, forKey: NSFontAttributeName as NSCopying)
        segmentedctrl.setTitleTextAttributes(attributes as! [AnyHashable: Any], for: UIControlState() )
        
        
        self.tabbar.delegate = self
        self.tabbar.selectedItem = self.tabbar.items![1]
        self.tableview.register(UINib.init(nibName: "customcellTableViewCell", bundle: nil), forCellReuseIdentifier: "cell1")
        let datakeyed = UserDefaults.standard.object(forKey: "building_details") as! Data
        let assets = (NSKeyedUnarchiver.unarchiveObject(with: datakeyed) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        //print(assets)
        self.buildingname.text = String(format: "%@",(assets["name"] as? String)!)
        self.view.bringSubview(toFront: nav)
        let navItem = UINavigationItem(title: (assets["name"] as? String)!);
        self.navigationItem.title = assets["name"] as? String
        self.nav.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!]
        let doneItem = UIBarButtonItem(title: "< Projects", style: .plain, target: self, action: #selector(sayHello(_:)))
        let filteritem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(filter(_:)))
        navItem.leftBarButtonItem = doneItem;
        navItem.rightBarButtonItem = filteritem;
        navItem.rightBarButtonItem?.image = self.imageWithImage(UIImage(named: "filtericon.png")!, scaledToSize: CGSize(width: 32, height: 32))
        self.navigationItem.rightBarButtonItem?.image = self.imageWithImage(UIImage(named: "filtericon.png")!, scaledToSize: CGSize(width: 32, height: 32))
        nav.setItems([navItem], animated: false);
        self.navigationItem.rightBarButtonItem?.title = ""
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.shouldRotate = false
              // Do any additional setup after loading the view.
    }
    var task = URLSessionTask()
    var download_requests = [URLSession]()
    
    
    func showalert(_ message:String, title:String, action:String){
        
        //let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        //let callActionHandler = { (action:UIAlertAction!) -> Void in
        DispatchQueue.main.async(execute: {
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
    
    func buildingactions(_ subscription_key:String, leedid: Int){
        let url = URL.init(string: String(format: "%@assets/LEED:%d/actions/",credentials().domain_url,leedid))
        ////print(url?.absoluteURL)
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        var token = UserDefaults.standard.object(forKey: "token") as! String
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
                            self.tabbar.isUserInteractionEnabled = true
                            if(self.download_requests.count > 0 && self.disappear == 0){
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "performrootsegue"), object: nil, userInfo: ["seguename":"listofactions"])
                            }
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

    @IBOutlet weak var spinner: UIView!
    var disappear = 0
    override func viewWillDisappear(_ animated: Bool) {
        DispatchQueue.main.async(execute: {
            self.disappear = 1
            let t = self.download_requests
            for r in 0 ..< t.count
            {
                let request = t[r] as! URLSession
                request.invalidateAndCancel()                
            }
        })
    }

    
    
    
    func imageWithImage(_ image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    var building_dict = NSDictionary()
    
    func sayHello(_ sender: UIBarButtonItem) {
        //print("Projects clicked")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "performsegue"), object: nil, userInfo: ["seguename":"listofassets"])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotofilter" {
            let secondViewController = segue.destination as! filtercredits
            secondViewController.firstViewController = self
            secondViewController.filterarr = filterarr
        }
    }
    
    func filter(_ sender: UIBarButtonItem) {
        //print("Projects clicked")
        
        self.performSegue(withIdentifier: "gotofilter", sender: nil)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return currentarr.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    @IBOutlet weak var backbtn: UIButton!
    
    @IBAction func filterme(_ sender: AnyObject) {
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
        if(currentarr.count > 0){
            notfound.isHidden = true
        }else{
            notfound.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! customcellTableViewCell
        //CreditDescription, AssignedTo // first_name
        var linkTextWithColor = ""
        var text = ""
        let arr = (currentarr.object(at: indexPath.section) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        if let creditDescription = arr["CreditDescription"] as? String{
            cell.namelbl.text = creditDescription
            text  = "Assigned to"
            if let assignedto = arr["PersonAssigned"] as? String{
                let temp = assignedto
                    text += " " + temp.capitalized
                if(temp == "" || temp == ""){
                    text += "None"
                }
            }else{
                text += " None"
            }
            linkTextWithColor = "assigned to"
            let range = (text as NSString).range(of: linkTextWithColor)
            
            let attributedString = NSMutableAttributedString(string:text)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray , range: range)
            cell.assignee.attributedText = attributedString
            
        }
        
        
        
        if let creditstatus = arr["CreditStatus"] as? String{
            cell.creditstatus.text = String(format: "%@",creditstatus.capitalized)
            if(cell.creditstatus.text == "Attempted"){
                cell.creditstatus.text = ""
            }
            if(creditstatus == "Ready for Review"){
                cell.creditstatusimg.image = UIImage.init(named: "tick")
            }else{
                cell.creditstatusimg.image = UIImage.init(named: "circle")
            }
            
            if(cell.creditstatus.text == ""){
                cell.creditstatus.text = ""
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
            cell.shortcredit.image = self.imageWithImage(UIImage(named: "settings.png")!, scaledToSize: CGSize(width: 32, height: 32))
        }else{
            if((arr["CreditDescription"] as! String).lowercased() == "energy"){
                cell.shortcredit.image = UIImage.init(named: "energy-border")
            }else if((arr["CreditDescription"] as! String).lowercased() == "water"){
                cell.shortcredit.image = UIImage.init(named: "water-border")
            }else if((arr["CreditDescription"] as! String).lowercased() == "waste"){
                cell.shortcredit.image = UIImage.init(named: "waste-border")
            }
            else if((arr["CreditDescription"] as! String).lowercased() == "transportation"){
                cell.shortcredit.image = UIImage.init(named: "transport-border")
            }else if ((arr["CreditDescription"] as! String).lowercased() == "human experience"){
                cell.shortcredit.image = UIImage.init(named: "human-border")
            }else{
                cell.shortcredit.image = self.imageWithImage(UIImage(named: "settings.png")!, scaledToSize: CGSize(width: 32, height: 32))
            }
        }
        
        
        return cell
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
    
    @IBAction func goback(_ sender: AnyObject) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "performsegue"), object: nil, userInfo: ["seguename":"plaque"])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let arr = (currentarr.object(at: indexPath.section) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        //print("The category is", checkcredit_type(arr))
        if(checkcredit_type(arr) == "Pre-requisites" || checkcredit_type(arr) == "Base scores"){
            let data = NSKeyedArchiver.archivedData(withRootObject: currentarr)
            UserDefaults.standard.set(data, forKey: "currentcategory")
            
            UserDefaults.standard.set(indexPath.section, forKey: "selected_action")
            //self.performSegueWithIdentifier("prerequisites", sender: nil)
            let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            
            let listofactions = mainstoryboard.instantiateViewController(withIdentifier: "listofactions")
            var datainput = mainstoryboard.instantiateViewController(withIdentifier: "prerequisites")
            if(building_dict["project_type"] as! String == "city" || building_dict["project_type"] as! String == "community"){
                datainput = mainstoryboard.instantiateViewController(withIdentifier: "prerequisitess")
            }
            let rootViewController = self.navigationController
            var controllers = (rootViewController!.viewControllers)
            controllers.removeAll()
            var v = UIViewController()
            if(UserDefaults.standard.integer(forKey: "grid") == 1){
                v = mainstoryboard.instantiateViewController(withIdentifier: "grid") as! UINavigationController
            }else{
                v = mainstoryboard.instantiateViewController(withIdentifier: "listofassets") as! UINavigationController
            }
            var grid = 0
            grid = UserDefaults.standard.integer(forKey: "grid")
            var listofassets = mainstoryboard.instantiateViewController(withIdentifier: "projectslist")
            if(grid == 1){
                listofassets = mainstoryboard.instantiateViewController(withIdentifier: "gridvc")
            }else{
                listofassets = mainstoryboard.instantiateViewController(withIdentifier: "projectslist")
            }
            listofassets.navigationItem.title = "Projects"
            controllers.append(listofassets)
            controllers.append(listofactions)
            controllers.append(datainput)
            self.navigationController?.setViewControllers(controllers, animated: true)                        
        }else if(checkcredit_type(arr) == "Data input"){
            let data = NSKeyedArchiver.archivedData(withRootObject: currentarr)
            UserDefaults.standard.set(data, forKey: "currentcategory")
            
            UserDefaults.standard.set(indexPath.section, forKey: "selected_action")
                //self.performSegueWithIdentifier("datainput", sender: nil)
                let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                let listofactions = mainstoryboard.instantiateViewController(withIdentifier: "listofactions")
            var datainput = UIViewController()
            if((arr["CreditDescription"] as! String).lowercased() == "water" || (arr["CreditDescription"] as! String).lowercased() == "energy"){
             datainput = mainstoryboard.instantiateViewController(withIdentifier: "datainput")
            }else{
             datainput = mainstoryboard.instantiateViewController(withIdentifier: "waste")
            }
                if(building_dict["project_type"] as! String == "city" || building_dict["project_type"] as! String == "community"){
                    datainput = mainstoryboard.instantiateViewController(withIdentifier: "prerequisitess")
                }
                let rootViewController = self.navigationController
                var controllers = (rootViewController!.viewControllers)
                controllers.removeAll()
                var v = UIViewController()
                if(UserDefaults.standard.integer(forKey: "grid") == 1){
                    v = mainstoryboard.instantiateViewController(withIdentifier: "grid") as! UINavigationController
                }else{
                    v = mainstoryboard.instantiateViewController(withIdentifier: "listofassets") as! UINavigationController
                }
                var grid = 0
                grid = UserDefaults.standard.integer(forKey: "grid")
                var listofassets = mainstoryboard.instantiateViewController(withIdentifier: "projectslist")
                if(grid == 1){
                    listofassets = mainstoryboard.instantiateViewController(withIdentifier: "gridvc")
                }else{
                    listofassets = mainstoryboard.instantiateViewController(withIdentifier: "projectslist")
                }
                let dict = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary
                listofassets.navigationItem.title = "Projects"
                controllers.append(listofassets)
                controllers.append(listofactions)
                controllers.append(datainput)
                self.navigationController?.setViewControllers(controllers, animated: true)
            }
    }

    func sendValue(_ value: NSString) {
        
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


