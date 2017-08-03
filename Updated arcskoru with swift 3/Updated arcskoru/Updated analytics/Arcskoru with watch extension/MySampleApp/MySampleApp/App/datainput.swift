//
//  prerequisites.swift
//  LEEDOn
//
//  Created by Group X on 16/11/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class datainput: UIViewController, UITableViewDataSource,UITableViewDelegate,UITabBarDelegate,UIPickerViewDelegate, UIPickerViewDataSource {
    // water  - .801, .948, .952 and 0.303, 0.751, 0.94
    // energy - .860, .871, .734 and 0.776, 0.859, 0.122
    // waste  - .691, .789, .762 and 0.461, 0.76, 0.629
    //transport - .876, .858, .803 and 0.572, 0.556, 0.505
    //human - .901, .867, .603 and 0.92, 0.609, 0.236
    @IBOutlet weak var feedstable: UITableView!
    @IBOutlet weak var actiontitle: UILabel!
    var datesdict = NSMutableDictionary()
    var currentfeeds = NSArray()
    var readingsdict = NSMutableDictionary()
    var selectedreading = NSArray()
    var meterdates = NSMutableArray()
    var download_requests = [URLSession]()
    var uploadsdata = NSArray()
    var id = 0
    var arrayofreadings = NSMutableDictionary()
    var statusarr = ["Ready for Review"]
    var leedid = UserDefaults.standard.integer(forKey: "leed_id")
    var filescount = 1
    var entirereadingsarr = NSMutableArray()
    var data = [Int]()
    var data2 = [Int]()
    var teammembers = NSArray()
    var statusupdate = 0
    @IBOutlet weak var spinner: UIView!
    @IBOutlet weak var assignokbtn: UIButton!
    @IBOutlet weak var assignclosebutton: UIButton!
    @IBOutlet weak var pleasekindly: UILabel!
    @IBOutlet weak var assigncontainer: UIView!
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var shortcredit: UIImageView!
    
    
    
    @IBOutlet weak var addnew: UIButton!
    
    var task = URLSessionTask()
    @IBOutlet weak var nxt: UIButton!
    var meters = NSMutableArray()
    var isloading = false
    @IBOutlet weak var prev: UIButton!
    
    
    @IBOutlet weak var assetname: UILabel!
    var domain_url = ""
    @IBOutlet weak var creditstatusimg: UIImageView!
    @IBOutlet weak var creditstatus: UILabel!
    @IBOutlet weak var affirmationview1: UIView!
    @IBOutlet weak var affirmationview2: UIView!
    
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var affirmationtext: UILabel!
    @IBOutlet weak var affirmationtitle: UILabel!
    
    @IBOutlet weak var sview: UIScrollView!
    @IBOutlet weak var tableview: UITableView!
    var token = ""
    var actualtableframe = CGRect()
    var currentarr = NSMutableDictionary()
    var currentmetersdict = NSMutableDictionary()
    var currentcategory = NSMutableArray()
    var currentindex = 0
    var startdatearr = NSMutableArray()
    var enddatearr = NSMutableArray()
    var graphPoints = NSArray()
    var samplegraphdata = [Int]()
    var tempgraphdata = [Int]()
    var readingsarr = NSMutableArray()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        currentmeter = NSDictionary()
        if(fromnotification == 1){
            self.navigationController?.navigationBar.backItem?.title = "Notifications"
        }else{
            self.navigationController?.navigationBar.backItem?.title = "Credits/Actions"
        }
        let dict = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary        
        self.navigationItem.title = dict["name"] as? String
        navigate()
    }
    
    @IBAction func statuschange(_ sender: AnyObject) {
            statusupdate = 1
            self.okassignthemember(UIButton())        
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textAlignment = .left
        if(tableView == feedstable){
            if(section == 0){
                    headerView.textLabel?.textAlignment = .left
                    if(headerView.textLabel?.text?.lowercased() == "activities"){
                        headerView.textLabel?.textAlignment = .left
                    }else{
                        headerView.textLabel?.textAlignment = .left
                    }
                }
         
        }
        if((currentarr["CreditDescription"] as! String).lowercased() == "waste"){
            if(section == 1){
                    headerView.textLabel?.textAlignment = .left
                    if(headerView.textLabel?.text?.lowercased() == "activities"){
                        headerView.textLabel?.textAlignment = .left
                    }else{
                        headerView.textLabel?.textAlignment = .left
                    }
                }
        }
        if(section == meters.count+1){
                headerView.textLabel?.textAlignment = .left
                if(headerView.textLabel?.text?.lowercased() == "activities"){
                    headerView.textLabel?.textAlignment = .left
                }else{
                    headerView.textLabel?.textAlignment = .left
                }
            }
        }
    }
    
    @IBOutlet weak var statusswitch: UISwitch!
    func rotateme(){
        if(UIDevice.current.orientation == .portrait){
            //sview.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, 0.9 * UIScreen.mainScreen().bounds.size.height)
        }else{
            //sview.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.height, 0.9 * UIScreen.mainScreen().bounds.size.width)
        }
        //feedstable.frame.origin.y = tableview.frame.origin.y + tableview.frame.size.height
        navigate()
        tableview.reloadData()
    }
    
    var fromnotification = UserDefaults.standard.integer(forKey: "fromnotification")    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tempframe = self.actiontitle.frame
        self.tableview.frame = CGRect(x: self.tableview.layer.frame.origin.x, y: 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), width: self.tableview.layer.frame.size.width,  height: self.tableview.layer.frame.size.height)
        DispatchQueue.main.async(execute: {
            if(self.fromnotification == 1){
                self.prev.isHidden = true
                self.nxt.isHidden = true
            }else{
                self.prev.isHidden = false
                self.nxt.isHidden = false
            }
        })
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        //print("Suze is ",width,height)
        //self.prev.layer.frame.origin.x = 0.98 * (self.nxt.layer.frame.origin.x - self.prev.layer.frame.size.width)
        self.titlefont()
        //feedstable.frame.origin.y = tableview.frame.origin.y + tableview.frame.size.height
        tableview.backgroundColor = UIColor.clear
        //sview.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, 0.9 * UIScreen.mainScreen().bounds.size.height)
        affirmationtitle.adjustsFontSizeToFitWidth = true
        affirmationtext.adjustsFontSizeToFitWidth = true
        
        backbtn.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12)
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
        self.spinner.layer.cornerRadius = 5
        self.spinner.isHidden = true
        
        assignokbtn.isEnabled = false
        picker.delegate = self
        picker.dataSource = self
        
        tableview.register(UINib.init(nibName: "customcellwithgraph", bundle: nil), forCellReuseIdentifier: "cell")
       // graphPoints = [[4, 2, 6, 4, 5, 8, 3],[4, 2, 6, 4, 5, 8, 3],[4, 2, 6, 4, 5, 8, 3],[4, 2, 6, 4, 5, 8, 3],[4, 2, 6, 4, 5, 8, 3],[4, 2, 6, 4, 5, 8, 3],[11,6, 7, 11, 2 ,3 ,5 ,6 ,7 ,8 ,9, 4, 2, 6, 4, 5, 8, 3],[4, 2, 6, 4, 5, 8, 3],[0,2],[4, 2, 6, 4, 5, 8, 3,4, 2, 6, 4, 5, 8, 3,4, 2, 6, 4, 5, 8, 3,4, 2, 6, 4, 5, 8, 3,0]]
        samplegraphdata  = [0,0,0,0,0]
        //graphPoints = samplegraphdata
        addnew.layer.cornerRadius = addnew.frame.size.height/2.0
        self.prev.layer.cornerRadius = 4
        self.nxt.layer.cornerRadius = 4
        self.tabbar.delegate = self
        self.tabbar.selectedItem = self.tabbar.items![1]
        tableview.register(UINib.init(nibName: "prerequisitescell1", bundle: nil), forCellReuseIdentifier: "cell1")
        tableview.register(UINib.init(nibName: "prerequisitescell2", bundle: nil), forCellReuseIdentifier: "cell2")
        tableview.register(UINib.init(nibName: "wastecell", bundle: nil), forCellReuseIdentifier: "wastecell")
        actualtableframe = tableview.frame
        var datakeyed = Data()
        token = UserDefaults.standard.object(forKey: "token") as! String
        datakeyed = UserDefaults.standard.object(forKey: "currentcategory") as! Data
        currentcategory = (NSKeyedUnarchiver.unarchiveObject(with: datakeyed) as! NSArray).mutableCopy() as! NSMutableArray
        currentindex = UserDefaults.standard.integer(forKey: "selected_action")
        UserDefaults.standard.synchronize()
        //print("aarra", currentcategory)
        currentarr = (currentcategory[currentindex] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        category.text = ""
        self.actiontitle.text = currentarr["CreditDescription"] as? String
        let c = credentials()
        domain_url = c.domain_url
        let dict = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary
        assetname.text = dict["name"] as? String
        self.navigationItem.title = dict["name"] as? String
        self.nav.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!]
        let doneItem = UIBarButtonItem(title: "< Credits/Actions", style: .plain, target: self, action: #selector(sayHello(_:)))
        let navItem = UINavigationItem(title: (dict["name"] as? String)!);
        navItem.leftBarButtonItem = doneItem;
        nav.setItems([navItem], animated: false);

        self.affirmationsclick(self.activityfeedbutton)
        self.affirmationview1.layer.cornerRadius = 5
        self.affirmationview2.layer.cornerRadius = 5
        self.ivupload1.tag = 101
        self.ivupload2.tag = 102
        self.ivattached2.tag = 103
        ivupload1.addTarget(self, action: #selector(datainput.valuechanged(_:)), for: UIControlEvents.valueChanged)
        ivupload2.addTarget(self, action: #selector(datainput.valuechanged(_:)), for: UIControlEvents.valueChanged)
        ivattached2.addTarget(self, action: #selector(datainput.valuechanged(_:)), for: UIControlEvents.valueChanged)
        
        Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.refresh), userInfo: nil, repeats: false)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(datainput.statusupdate(_:)))
        //self.creditstatus.userInteractionEnabled = true
        //self.creditstatus.addGestureRecognizer(tap)
        navigate()
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.shouldRotate = true
        
        // 2. Force the device in landscape mode when the view controller gets loaded
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
    override var shouldAutorotate : Bool {
        // 3. Lock autorotate
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait]
    }
    
    
    func statusupdate(_ sender:UILabel){
        if(ivupload1.isOn == false){
            maketoast("Affirmation required before changing the status", type: "error")
        }else{
            self.teammembers = statusarr as NSArray
            DispatchQueue.main.async(execute: {
                self.assigncontainer.isHidden = false
        self.sview.alpha = 0.3
                self.spinner.isHidden = true
                self.statusupdate = 1
                
                self.pleasekindly.text = "Please kindly select the below status for the action"
                self.assignokbtn.setTitle("Save", for: UIControlState())
                self.picker.reloadAllComponents()
            })
        }
    }
    
    func sayHello(_ sender: UIBarButtonItem) {
        //print("Projects clicked")
        self.performSegue(withIdentifier: "gotoactions", sender: nil)
    }
    
    
    func refresh(){
        tableview.reloadData()
    }
    
    @IBOutlet weak var nav: UINavigationBar!
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(tableView == feedstable){
            return 1
        }
        if((currentarr["CreditDescription"] as! String).lowercased() == "waste"){
         return 2
        }
        return meters.count+2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(tableView == tableview){
            if(section == meters.count + 1){
                return currentfeeds.count
            }
            return 1
        }
        
        return currentfeeds.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if(section == 0){
            return 1
        }
        if(graphPoints.count > 0){
            if(section == 1){
                return 0.06 * UIScreen.main.bounds.size.height
            }else{
                return 0.01 * UIScreen.main.bounds.size.height
            }
        }
        return 0.08 * UIScreen.main.bounds.size.height
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(section == 0 || section == self.meters.count + 1){
            return 0
        }
        return 0.11 * UIScreen.main.bounds.size.height
    }
    

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(tableView == feedstable){
            if(currentfeeds.count > 0){
                if(meters.count == 0){
                return "No meters present \n Activities"
                }else{
                return "Activities"
                }
            }
            if(meters.count == 0){
                return "No meters present \n\n No activities present"
            }else{
                return "No activities present"
            }
            
        }
        if(section == 0){
            return ""//"    Assigned user"
        }
        if(section == meters.count + 1){
            if(currentfeeds.count > 0){
                if(meters.count == 0){
                    return "No meters present \n\n Activities"
                }else{
                    return "Activities"
                }
            }
            if(meters.count == 0){
                return "No meters present \n\n No activities present"
            }else{
                return "No activities present"
            }
        }
        else if (section == 1){
            if(graphPoints.count > 0 ){
                return "Meters(Please tap the below graph to add/edit a reading)"
            }else{
                return "No meters present"
            }
        }
        
        return ""
    }
    
    override func viewDidLayoutSubviews() {
        self.tableview.frame.size = self.tableview.contentSize
    }
    
    
    func showactivityfeed(_ leedid: Int, creditID : String, shortcreditID : String){
        let url = URL.init(string:String(format: "%@assets/activity/?type=credit&leed_id=%d&credit_id=%@&credit_short_id=%@",domain_url, leedid,creditID, shortcreditID))
        ////print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(session)
        self.task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.localizedDescription.contains("cancelled")) != nil){
                    if(error?._code == -999){
                        
                    }else{
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    //print("error=\(error?.localizedDescription)")
                                        DispatchQueue.main.async(execute: {
                        //self.tableview.hidden = false
                        self.spinner.isHidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            }else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                
                var jsonDictionary : NSArray
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSArray
                    //print(jsonDictionary)
                    self.currentfeeds = jsonDictionary
                    DispatchQueue.main.async(execute: {
                        self.spinner.isHidden = true
                        self.view.isUserInteractionEnabled = true
                        //self.performSegueWithIdentifier("gotofeeds", sender: nil)
                        if(self.currentfeeds.count > 0){
                            //self.feedstable.hidden = false
                        }else{
                            //self.feedstable.hidden = true
                        }
                        
                        let height = UIScreen.main.bounds.size.height
                        self.sview.contentSize = CGSize(width: UIScreen.main.bounds.size.width,height: CGFloat(1.0 + (Float(self.currentfeeds.count + self.meters.count)/20.0)) * UIScreen.main.bounds.size.height)
                        //self.tableview.scrollEnabled = false
                        var i = ((0.54 * height) * CGFloat(self.meters.count + 1)) + ((0.07 * height) * CGFloat(self.currentfeeds.count))
                        var h1 = CGFloat(0),h2 = CGFloat(0),h3 = CGFloat(0)
                        h1 = 0.054 * height
                        h2 = 0.096 * height
                        h3 = 0.54 * height
                        i = (h1) + ((h2) * CGFloat(self.currentfeeds.count)) + ((h3) * CGFloat(self.graphPoints.count))
                        i = i + 1
                        if(self.graphPoints.count > 0){
                            var t =  0.06 * height
                            i = i + CGFloat(t * CGFloat(self.graphPoints.count))                             
                        }else{
                            var t =  0.06 * height
                            i = i + CGFloat(t * CGFloat(1))
                        }
                        if(self.graphPoints.count > 0){
                            self.sview.isScrollEnabled = true
                            self.tableview.isScrollEnabled = true
                        }else{
                            self.sview.isScrollEnabled = false
                            self.tableview.isScrollEnabled = false
                        }
                        var t =  0.06 * height
                        i = i + CGFloat(t * CGFloat(self.currentfeeds.count))
                        
                        self.tableview.frame = CGRect(x: self.tableview.layer.frame.origin.x, y: 0, width: self.tableview.layer.frame.size.width,  height: self.tableview.layer.frame.size.height)
                        self.tableview.frame.size.height = i 
                        self.sview.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: (self.tableview.layer.frame.origin.y + self.tableview.layer.frame.size.height))
                        
                        
                        //print("Tableview height",self.tableview.frame.size.height)
                        self.tableview.reloadData()
                        //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                        self.spinner.isHidden = true
                        
                        //self.feedstable.hidden = false
                        self.feedstable.reloadData()
                        //self.tableview.hidden = false
                        self.spinner.isHidden = true
                        self.sview.isHidden = false
                        self.view.isUserInteractionEnabled = true
                        self.statusswitch.isHidden = false
                        self.addnew.isHidden = false
                        self.creditstatus.isHidden = false
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
    
    

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if(section == self.meters.count + 1 || section == 0){
            return UIView()
        }else{
        let view = UIView()
        view.frame = CGRect(x: 0, y: 40, width: tableview.layer.frame.size.width, height: 40)
        let prevbutton = UIButton.init(frame: CGRect(x: 0.01 * tableview.layer.frame.size.width, y: 10, width: 25, height: 25))
        let nextbutton = UIButton.init(frame: CGRect(x: 1.2 * (prevbutton.frame.size.width + prevbutton.frame.origin.x), y: 10, width: 25, height: 25))
        //prevbutton.setTitle("Edit above meter", forState: UIControlState.Normal)
        prevbutton.setImage(UIImage.init(named: "pencil.png"), for: UIControlState())
        //nextbutton.setTitle("Delete above meter", forState: UIControlState.Normal)
        nextbutton.setImage(UIImage.init(named: "trash.png"), for: UIControlState())
        prevbutton.titleLabel?.font = UIFont.init(name: "OpenSans", size: 11)
        nextbutton.titleLabel?.font = UIFont.init(name: "OpenSans", size: 11)
        //prevbutton.layer.backgroundColor = UIColor.darkGrayColor().CGColor
        prevbutton.layer.cornerRadius = 5
        //nextbutton.layer.backgroundColor = UIColor.darkGrayColor().CGColor
        nextbutton.layer.cornerRadius = 5
        prevbutton.tag = 10 + section - 1
        nextbutton.tag = 10 + section - 1
        prevbutton.addTarget(self, action: #selector(self.editcurrentmeter(_:)), for: UIControlEvents.touchUpInside)
        nextbutton.addTarget(self, action: #selector(self.delcurrentmeter(_:)), for: UIControlEvents.touchUpInside)
        view.addSubview(prevbutton)
        view.addSubview(nextbutton)
        return view
        }
    }
    var edit = 0
    func editcurrentmeter(_ sender:UIButton){
        self.edit = 1
        let t = [["Generated onsite - solar","Purchased from Grid"],["Municipality supplied potable water","Municipality supplied reclaimed water","Reclaimed onsite"],["District Strem","District Hot water","District chilled water (Electric driven chiller)","District chilled water(Absorption chiller using natural gas)","District chilled water(Engine driven chiller using natural gas)","Natural gas","Fuel oil (No.2)","Wood","Propane","Liquid propane","Kerosene","Fuel oil (No.1)","Fuel oil (No.5 & No.6)","Coal (anthracite)","Coal (bituminous)","Coke","Fuel oil (No.4)","Diesel"]]
        
        currentmeter = self.meters.object(at: sender.tag - 10) as! NSDictionary
        var n = ""
        for i in t{
            var v = i as! NSArray
            if let dict = currentmeter["fuel_type"] as? NSDictionary{
                if let type = currentmeter["subtype"] as? String{
                    if(v.contains(type)){
                        n = type
                        break
                    }
                }
            }
        }
        
        if(n == ""){
            currentmeter = ["id": 11156,
            "partner_details": NSNull(),
            "partner_meter_id": NSNull(),
            "name": "styuu",
            "included": true,
            "native_unit": "kWh",
            "type": 39,
            "updated_at": "2017-07-21T09:38:06.889853Z",
            "updated_by": NSNull(),
            "status": "synced",
            "area_choice": NSNull(),
            "responsibility": NSNull(),
            "data_coverage_area": NSNull(),
            "max_coverage_area": NSNull(),
            "fuel_type": [
                "id": 25,
                "type": "Purchased from Grid",
                "subtype": "",
                "kind": "electricity",
                "include_in_dropdown_list": true,
                "resource": "Non-Renewable",
                ],
            "area_unit": NSNull()] as! NSDictionary
                
        }
        
        
        self.performSegue(withIdentifier: "gotoaddmeter", sender: nil)
    }
    
    func delcurrentmeter(_ sender:UIButton){
        currentmeter = self.meters.object(at: sender.tag - 10) as! NSDictionary
        let alertController = UIAlertController(title: "Delete meter \(currentmeter["name"] as! String)", message: "Do you want to delete the meter and associated data associated with the meter ?", preferredStyle: .alert)
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            
            DispatchQueue.main.async(execute: {
                if let creditDescription = self.currentarr["CreditStatus"] as? String{
                    if(creditDescription.lowercased() == "under review"){
                        self.showalert("Updation is not allowed when the credit is under review", title: "Error", action: "OK")
                    }else{
                self.view.isUserInteractionEnabled = false
                self.spinner.isHidden = false
                self.view.isUserInteractionEnabled = false
                self.deletemeter(credentials().subscription_key, leedid: self.leedid, meterID: self.currentmeter["id"] as! Int)
                    }}
            })
            
                }
        let defaultAction = UIAlertAction(title: "Yes", style: .destructive , handler:callActionHandler)
        let cancelAction = UIAlertAction(title: "No", style: .default, handler:nil)
        alertController.addAction(cancelAction)
        alertController.addAction(defaultAction)
        alertController.view.subviews.first?.backgroundColor = UIColor.white
        alertController.view.layer.cornerRadius = 10
        alertController.view.layer.masksToBounds = true
        self.present(alertController, animated: true, completion: nil)
        
    }

    
    func tap(_ sender: UITapGestureRecognizer){
  //      print("Selected \(sender.view!.tag)")
        var dict = (self.meters.object(at: sender.view!.tag) as! NSDictionary).mutableCopy() as! NSMutableDictionary
//        print(selectedreading)
        id = dict["id"] as! Int
        selectedreading = self.arrayofreadings["\(id)"] as! NSArray
        
        //print("dict is selected ",dict["id"] as! Int, selectedreading)
        //  tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var tempdict = (graphPoints.object(at: sender.view!.tag) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        sel_title = tempdict["name"] as! String
        
       self.performSegue(withIdentifier: "gotoreadings", sender: nil)

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == tableview){
            if(indexPath.section == meters.count+1){
                let cell = tableView.dequeueReusableCell(withIdentifier: "feedscell")!
                //tableView.frame.origin.y = tableview.frame.origin.y + tableview.frame.size.height
                var dict = (currentfeeds.object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                cell.textLabel?.text = dict["verb"] as? String
                var s = cell.textLabel?.text
                s = s?.replacingOccurrences(of: "for  ", with: "for ")
                cell.textLabel?.text = s
                cell.textLabel?.adjustsFontSizeToFitWidth = true
                cell.detailTextLabel?.numberOfLines = 5
                cell.textLabel?.numberOfLines = 5
                cell.textLabel?.adjustsFontSizeToFitWidth = true
                cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                var str = dict["timestamp"] as! String
                let formatter = DateFormatter()
                formatter.dateFormat = credentials().micro_secs
                if(formatter.date(from: str) == nil){
                formatter.dateFormat = credentials().milli_secs
                }
                
                let date = formatter.date(from: str)!
                formatter.dateFormat = "MMM dd, yyyy"
                let temp = formatter.string(from: date)
                formatter.dateFormat = "hh:mm a"
                let time = formatter.string(from: date)
                cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
                cell.detailTextLabel?.text = "\(temp) at \(time)"
                
                return cell
            }
            
            
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! prerequisitescell2
            cell.fileuploaded.isHidden = true
            cell.uploadbutton.isHidden = true
            cell.uploadanewfile.isHidden = true
            cell.assignedto.isHidden = false
            cell.editbutton.isHidden = false
            cell.editbutton.addTarget(self, action: #selector(edited), for: UIControlEvents.touchUpInside)
            print("Current name is",currentarr["CreditDescription"] as? String)
            cell.assignedto.isHidden = false            
            if let assignedto = currentarr["PersonAssigned"] as? String{
                _ = assignedto
                if(assignedto == ""){
                    cell.assignedto.text = "Assigned to None"
                }else{
                    cell.assignedto.text = String(format:"Assigned to %@",assignedto)
                }
                cell.selectionStyle = UITableViewCellSelectionStyle.none
            }else{
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.assignedto.text = "Assigned to None"
            }
            cell.textLabel?.text = cell.assignedto.text
            cell.assignedto.text = ""
            cell.assignedto.numberOfLines = 5
            cell.textLabel?.font = cell.assignedto.font
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            return cell

        }else{
            
            if((currentarr["CreditDescription"] as! String).lowercased() == "waste"){
                let identifier = "wastecell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! wastecell
                //v.addBarchartAnimation()
                return cell
                
            }else{
         
            let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! customcellwithgraph

            var temp = [Int]()
                var dict = (self.meters.object(at: indexPath.section-1) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                //print("dict is is ",dict["id"] as! Int)
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
            
            var tempdict = (graphPoints.object(at: indexPath.section-1) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            temp = samplegraphdata
                if(readingsarr.count > 0){
            temp = readingsarr.object(at: indexPath.section-1) as! [Int]
            }
            temp = readingsdict["\(dict["id"] as! Int)"] as! [Int]
           let view = GraphView()
            cell.graphviews.isHidden = true
            view.frame = cell.graphviews.frame
                if(temp.count == 0){
                    temp  = [0,0,0,0,0]
                    view.maxscore = 10
                }else{
                    view.maxscore = temp.max()!
                }
            
            view.graphPoints = temp
            
            var label = UILabel()
            label.text = "asda"
            label.frame = cell.heading.frame
            label = cell.heading
            label.adjustsFontSizeToFitWidth = true
            view.addSubview(label)
                let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.tap(_:)))
                tap.numberOfTapsRequired = 1
                view.tag = indexPath.section - 1
                view.addGestureRecognizer(tap)
            var datelabel = UILabel()
            datelabel = cell.v1                
            datelabel.adjustsFontSizeToFitWidth = true
            //datelabel.center = CGPointMake(cell.contentView.center.x, 0.9 * cell.contentView.frame.size.height)
                if(self.meterdates.count>0){
                    let dateFormatter = DateFormatter()
                    
                    //ateFormatter.dateFormat = "d MMM yyyy"
                    //print("starting dates after array",self.datesdict)
                    if(datesdict.count > 0){
                        
                        //print("ENding dates after array",self.enddatearr)
                        //print(temp)
                        var dict = (datesdict["\(dict["id"] as! Int)"]as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        dateFormatter.dateFormat = "dd MMM yyyy"
                        var startdate = ""
                        var enddate = ""
                        datelabel.text = "Not available"
                        if(dict["start_date"] != nil){
                            let date1 =  dict["start_date"] as! Date
                            startdate = dateFormatter.string(from: date1)
                        }
                        if(dict["end_date"] != nil){
                            let date2 =  dict["end_date"] as! Date
                            enddate = dateFormatter.string(from: date2)
                        }
                        if(startdate != "" && enddate != ""){
                        datelabel.text = String(format: "%@ to %@", startdate, enddate)
                        }else{
                        datelabel.text = "Not available"
                        }
                    }else{
                    //print("ENding dates after array",self.enddatearr)
                    //print(temp)
                    var dict = (meterdates.object(at: indexPath.section-1) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    dateFormatter.dateFormat = "dd MMM yyyy"
                    var startdate = ""
                    var enddate = ""
                    datelabel.text = "Not available"
                    if(dict["start_date"] != nil){
                        let date1 =  dict["start_date"] as! Date
                    startdate = dateFormatter.string(from: date1)
                    }
                    if(dict["end_date"] != nil){
                        let date2 =  dict["end_date"] as! Date
                    enddate = dateFormatter.string(from: date2)
                    }
                    datelabel.text = String(format: "%@ to %@", startdate, enddate)
                    //print(startdate,enddate)
                    }
                    
                }else{
                    label.text = ""
                }
            cell.contentView.addSubview(datelabel)
            var startscore = UILabel()
            startscore = cell.startscore
            startscore.adjustsFontSizeToFitWidth = true
            //startscore.frame.origin.x = 0.94 * cell.contentView.frame.size.width
            view.addSubview(startscore)
                var maxscore = UILabel()
                maxscore = cell.maxscore
                //maxscore.frame.origin.x = startscore.frame.origin.x
                if(temp.count>0){
                    maxscore.text = String(format:"%d",temp.max()!)
                }else{
                    maxscore.text = "10"
                }
                if(maxscore.text == "0"){
                    maxscore.text = "10"
                }
                view.addSubview(maxscore)
                view.endColor = UIColor.white//UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
                cell.startColor = UIColor.white//UIColor.init(red: 0.860, green: 0.871, blue: 0.734, alpha: 1)
                cell.endColor = UIColor.white//UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
                view.startColor = UIColor.white
            if(currentarr["CreditDescription"] as! String == "Energy"){
                 cell.heading.text = String(format:"Meter %d", indexPath.section)
             view.startColorr =   UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
                view.endColorr = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
                view.endColor = UIColor.white//UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
                cell.startColor = UIColor.white//UIColor.init(red: 0.860, green: 0.871, blue: 0.734, alpha: 1)
                cell.endColor = UIColor.white//UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
                view.startColor = UIColor.white
            }else if(currentarr["CreditDescription"] as! String == "Water"){
                cell.heading.text = String(format:"Meter %d", indexPath.section)
                //view.startColor = UIColor.init(red: 0.801, green: 0.948, blue: 0.952, alpha: 1)
                //view.endColor = UIColor.init(red: 0.303, green: 0.751, blue: 0.94, alpha: 1)
                view.startColorr = UIColor.init(red: 0.303, green: 0.751, blue: 0.94, alpha: 1)
                view.endColorr = UIColor.init(red: 0.303, green: 0.751, blue: 0.94, alpha: 1)
                
            }else if(currentarr["CreditDescription"] as! String == "Waste"){
                
                view.startColorr = UIColor.init(red: 0.691, green: 0.789, blue: 0.762, alpha: 1)
                view.endColorr = UIColor.init(red: 0.691, green: 0.789, blue: 0.762, alpha: 1)
            }else if(currentarr["CreditDescription"] as! String == "Transportation"){
                
                view.startColorr = UIColor.init(red: 0.876, green: 0.858, blue: 0.803, alpha: 1)
                view.endColorr = UIColor.init(red: 0.876, green: 0.858, blue: 0.803, alpha: 1)
                
            }else if(currentarr["CreditDescription"] as! String == "Human Experience"){
                view.startColorr = UIColor.init(red: 0.901, green: 0.867, blue: 0.603, alpha: 1)
                view.endColorr = UIColor.init(red: 0.901, green: 0.867, blue: 0.603, alpha: 1)
                
            }
            let str = tempdict["name"] as! String
            let d = tempdict["fuel_type"] as! NSDictionary
            cell.heading.text =  str
                
                let actualstring = NSMutableAttributedString()
                var tempostring = NSMutableAttributedString()
                if(tempdict["name"] != nil){
                    tempostring = NSMutableAttributedString(string:(tempdict["name"] as? String)!)
                }
                tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans-Semibold", size: 0.048 * UIScreen.main.bounds.size.width)!, range: NSMakeRange(0, tempostring.length))
                actualstring.append(tempostring.mutableCopy() as! NSAttributedString)
                tempostring.deleteCharacters(in: NSMakeRange(0, tempostring.length))
                tempostring = NSMutableAttributedString(string:"\n")
                actualstring.append(tempostring.mutableCopy() as! NSAttributedString)
                tempostring.deleteCharacters(in: NSMakeRange(0, tempostring.length))
                if(d["type"] as! String == "Electricity" && d["subtype"] as! String == "National Average"){
                    tempostring = NSMutableAttributedString(string:("Purchased from Grid(\(tempdict["native_unit"] as! String))").capitalized)
                }else{
                if(d["type"] != nil || d["type"] as? String != ""){
                    if(d["subtype"] != nil || d["subtype"] as? String != ""){
                        tempostring = NSMutableAttributedString(string:("\(d["type"] as! String) \(d["subtype"] as! String)(\(tempdict["native_unit"] as! String))").capitalized)
                    }else{
                        tempostring = NSMutableAttributedString(string:("\(d["type"] as! String)(\(tempdict["native_unit"] as! String))").capitalized)
                    }
                }
                }
                
                tempostring.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: NSMakeRange(0, tempostring.length))
                tempostring.addAttribute(NSFontAttributeName, value: UIFont.init(name: "OpenSans", size: 0.033 * UIScreen.main.bounds.size.width)!, range: NSMakeRange(0, tempostring.length))
                actualstring.append(tempostring.mutableCopy() as! NSAttributedString)
                tempostring.deleteCharacters(in: NSMakeRange(0, tempostring.length))
                tempostring = NSMutableAttributedString(string:" ")
                actualstring.append(tempostring.mutableCopy() as! NSAttributedString)
                tempostring.deleteCharacters(in: NSMakeRange(0, tempostring.length))
                
                
                cell.heading.adjustsFontSizeToFitWidth = true
                cell.heading.attributedText = actualstring as NSAttributedString
                
                
            cell.heading.adjustsFontSizeToFitWidth = true
                if(datelabel.text == "Not available"){
            let date1 = Date()
            let calendar = Calendar.current
            let components = (calendar as NSCalendar).components([.day , .month , .year], from: date1)
            let year =  components.year
            let month = components.month
            let day = components.day
            let dateFormatter: DateFormatter = DateFormatter()
            let months = dateFormatter.shortMonthSymbols
            let monthSymbol = months?[month!-1]
            let nextmonth = months?[month!]
            datelabel.text = String(format: "%d %@ to %d %@", day!,monthSymbol!, day!,nextmonth!)
            }
            cell.contentView.addSubview(view)
            return cell
        }
        
        }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedcell")!
        tableView.frame.origin.y = tableview.frame.origin.y + tableview.frame.size.height
        var dict = (currentfeeds.object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        cell.textLabel?.text = dict["verb"] as? String
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        var str = dict["timestamp"] as! String
        let formatter = DateFormatter()
        formatter.dateFormat = credentials().micro_secs
    
        if(formatter.date(from: str) == nil){
            formatter.dateFormat = credentials().milli_secs
        }
        let date = formatter.date(from: str)!
        formatter.dateFormat = "MMM dd, yyyy"
        str = formatter.string(from: date)
        cell.detailTextLabel?.numberOfLines = 5
        cell.textLabel?.numberOfLines = 5
        var str1 = String()
        formatter.dateFormat = "hh:mm a"
        str1 = formatter.string(from: date)
        cell.detailTextLabel?.text = "on \(str) at \(str1)"
        return cell
        
    }
    
    func deleted(){
        //print("deleted")
    }
    
    
    func edited(){
        //print("edited")
        DispatchQueue.main.async(execute: {
            if let creditDescription = self.currentarr["CreditStatus"] as? String{
                if(creditDescription.lowercased() == "under review"){
                    self.showalert("Updation is not allowed when the credit is under review", title: "Error", action: "OK")
                }else{
            self.assignokbtn.isEnabled = false
            self.statusupdate = 0
            self.spinner.isHidden = false
            
            self.pleasekindly.text = "Please kindly the team member to assign this action"
            self.assignokbtn.setTitle("Assign", for: UIControlState())
            self.getteammembers(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"))
                }
            }
        })
    }
    
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

    
    func uploaded(){
        //print("uploaded")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableview.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = UIScreen.main.bounds.size.height
        if(tableView == feedstable){
            return 0.95 * height
        }
        if indexPath.section == 0 {
            return 0.054 * height
        }
        if(indexPath.section == meters.count + 1){
            return 0.096 * height
        }
        else if (indexPath.section == graphPoints.count+1){
            if((currentarr["CreditDescription"] as! String).lowercased() == "waste"){
                return 0.42 * height
            }
            return 0.54 * height
        }
        
        return 0.42 * height
    }
    @IBAction func affirmationview2close(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.beginFromCurrentState, animations: { () -> Void in
            ////self.tableview.frame = self.actualtableframe
            //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
            self.affirmationview2.isHidden = true
            }, completion: { (finished: Bool) -> Void in
                
                // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
                
        })
    }
    
    @IBAction func previous(_ sender: AnyObject) {
        if(currentindex>0){
            /*if(task.currentRequest != nil){
             if (task.state == NSURLSessionTaskState.Running) {
             task.cancel()
             }
             }*/
            currentindex = currentindex-1
            UserDefaults.standard.set(currentindex, forKey: "selected_action")
            currentarr = (currentcategory[currentindex] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            if(checkcredit_type(currentarr) == "Data input"){
                navigate()
            }else{
                //self.performSegueWithIdentifier("prerequisites", sender: nil)
                let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                let listofactions = mainstoryboard.instantiateViewController(withIdentifier: "listofactions")
                let datainput = mainstoryboard.instantiateViewController(withIdentifier: "prerequisites")
                let rootViewController = self.navigationController
                var controllers = (rootViewController!.viewControllers)
                controllers.removeAll()
                var v = UIViewController()
                var grid = 0
                grid = UserDefaults.standard.integer(forKey: "grid")
                if(UserDefaults.standard.integer(forKey: "grid") == 1){
                    v = mainstoryboard.instantiateViewController(withIdentifier: "grid") as! UINavigationController
                }else{
                    v = mainstoryboard.instantiateViewController(withIdentifier: "listofassets") as! UINavigationController
                }
                var listofassets = mainstoryboard.instantiateViewController(withIdentifier: "projectslist")
                if(grid == 1){
                    listofassets = mainstoryboard.instantiateViewController(withIdentifier: "gridvc")
                }else{
                    listofassets = mainstoryboard.instantiateViewController(withIdentifier: "projectslist")
                }
                let dict = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary
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
    
    func maketoasts(_ message:String, type:String){
        var color = UIColor()
        if(type == "error"){
            color = UIColor.blue
        }else{
            color = UIColor.blue
        }
        if self.navigationController != nil {
            // being pushed
            var vc = self
            AWBanner.showWithDuration(4.5, delay: 0.0, message: NSLocalizedString(message, comment: ""), backgroundColor: color, textColor: UIColor.white, originY: (vc.navigationController!.navigationBar.frame.size.height) + (vc.navigationController!.navigationBar.frame.origin.y))
        }else{
            AWBanner.showWithDuration(4.5, delay: 0.0, message:  NSLocalizedString(message, comment: ""), backgroundColor: color, textColor: UIColor.white)
        }
        
    }

    
    @IBOutlet weak var ivupload2: UISwitch!
    
    @IBOutlet weak var ivattached2: UISwitch!
    
    @IBOutlet weak var ivupload1: UISwitch!
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        for request in download_requests
        {
            request.invalidateAndCancel()
        }
        var buildingdetails = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.navigationItem.title = buildingdetails["name"] as? String
    }
    
    
    
    func navigate(){
        self.affirmationview1.isHidden = true
        self.affirmationview2.isHidden = true
        self.tableview.frame.origin.y = 0
        self.sview.scrollsToTop = true        
        self.sview.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        for request in download_requests
        {            
            request.invalidateAndCancel()
        }
        DispatchQueue.main.async(execute: {
            self.sview.isHidden = true
            self.statusswitch.isHidden = true
            self.addnew.isHidden = true
            self.creditstatus.isHidden = true
            if(self.fromnotification == 1){
                self.prev.isHidden = true
                self.nxt.isHidden = true
            }else{
                self.prev.isHidden = false
                self.nxt.isHidden = false
            }
            self.spinner.isHidden = true
            self.category.adjustsFontSizeToFitWidth = true
            self.actiontitle.adjustsFontSizeToFitWidth = true
            self.affirmationtext.adjustsFontSizeToFitWidth = true
            self.affirmationtitle.adjustsFontSizeToFitWidth = true
            self.actiontitle.adjustsFontSizeToFitWidth = true
            
        })
        currentarr = (currentcategory[currentindex] as! NSDictionary).mutableCopy() as! NSMutableDictionary        
        category.text = ""
        self.actiontitle.text = currentarr["CreditDescription"] as? String
        self.creditstatus.text = String(format: "%@ v",(currentarr["CreditStatus"] as? String)!)
        if(self.creditstatus.text == ""){
            self.creditstatus.text = "Not available"
            self.statusswitch.isOn = false
        }
        self.affirmationsclick(self.activityfeedbutton)
        if(self.creditstatus.text == ""){
            self.creditstatus.text = "Not available"
            self.statusswitch.isOn = false
        }else{
            if let creditstatus = currentarr["CreditStatus"] as? String{
                self.creditstatus.text = String(format: "%@",creditstatus.capitalized)
                if(creditstatus == "Ready for Review"){
                    creditstatusimg.image = UIImage.init(named: "tick")
                    self.statusswitch.isOn = true
                }else{
                    creditstatusimg.image = UIImage.init(named: "circle")
                    self.statusswitch.isOn = false
                }
                self.creditstatus.text = "Ready for Review"
                if(creditstatus.lowercased() == "under review"){
                    self.creditstatus.text = "Under review"
                    self.prev.isUserInteractionEnabled = true
                    self.nxt.isUserInteractionEnabled = true
                    self.statusswitch.isEnabled = false
                }else{
                    self.statusswitch.isEnabled = true
                }
                
            }
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
            if((currentarr["CreditDescription"] as! String).lowercased() == "energy"){
                shortcredit.image = UIImage.init(named: "energy-border")
            }else if((currentarr["CreditDescription"] as! String).lowercased() == "water"){
                shortcredit.image = UIImage.init(named: "water-border")
            }else if((currentarr["CreditDescription"] as! String).lowercased() == "waste"){
                shortcredit.image = UIImage.init(named: "waste-border")
            }
            else if((currentarr["CreditDescription"] as! String).lowercased() == "transportation"){
                shortcredit.image = UIImage.init(named: "transport-border")
            }else{
                    shortcredit.image = UIImage.init(named: "human-border")                
            }
        }
        self.actiontitle.text = currentarr["CreditDescription"] as? String
        self.shortcredit.frame.origin.y = 0.98 * self.actiontitle.frame.origin.y        
        self.actiontitle.frame = tempframe
        self.alignimageview(shortcredit, label: actiontitle, superview: self.view)
        
        let c = credentials()
        domain_url = c.domain_url
        _ = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary
        data.removeAll()
        data2.removeAll()
        self.startdatearr.removeAllObjects()
        self.enddatearr.removeAllObjects()
        meters.removeAllObjects()
        currentmetersdict.removeAllObjects()
        readingsarr.removeAllObjects()
        readingsdict.removeAllObjects()
        arrayofreadings.removeAllObjects()
        datesdict.removeAllObjects()
        graphPoints = meters
        self.entirereadingsarr.removeAllObjects()
        if(currentarr["IvReqFileupload"] is String){
            if(currentarr["IvReqFileupload"] as! String == ""){
                ivupload1.setOn(false, animated: false)
                ivupload2.setOn(false, animated: false)
            }else if(currentarr["IvReqFileupload"] as! String == "X"){
                ivupload1.setOn(true, animated: false)
                ivupload2.setOn(true, animated: false)
            }
        }else{
            ivupload1.setOn(currentarr["IvReqFileupload"] as! Bool, animated: false)
            ivupload2.setOn(currentarr["IvReqFileupload"] as! Bool, animated: false)
        }
        
        if(currentarr["IvAttchPolicy"] is String){
            if(currentarr["IvAttchPolicy"] as! String == ""){
                ivattached2.setOn(false, animated: false)
            }else if(currentarr["IvAttchPolicy"] as! String == "X"){
                ivattached2.setOn(true, animated: false)
            }
        }else{
            ivattached2.setOn(currentarr["IvAttchPolicy"] as! Bool, animated: false)
        }
        print(currentarr)
        if((currentarr["CreditDescription"] as! String).lowercased() == "water" || (currentarr["CreditDescription"] as! String).lowercased() == "energy"){
            DispatchQueue.main.async(execute: {
                self.spinner.isHidden = false
                
                self.shortcredit.frame.origin.y = 0.98 * self.actiontitle.frame.origin.y
                self.actiontitle.frame = self.tempframe
                self.alignimageview(self.shortcredit, label: self.actiontitle, superview: self.view)
              self.getmeters(c.subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"), kind: self.actiontitle.text!.lowercased())
            })
        }else if((currentarr["CreditDescription"] as! String).lowercased() == "waste"){
            self.performSegue(withIdentifier: "gotowaste", sender: nil)
        }
    }
    
    func alignimageview (_ imageView: UIImageView, label : UILabel, superview : UIView){
        label.sizeToFit()
        imageView.frame = CGRect(x: (superview.frame.size.width - imageView.frame.size.width - label.frame.size.width)/2, y: imageView.frame.origin.y, width: imageView.frame.size.width, height: imageView.frame.size.height)
        label.frame = CGRect(x: imageView.frame.origin.x + imageView.frame.size.width, y: label.frame.origin.y, width: label.frame.size.width, height: label.frame.size.height)
    }
    var tempframe = CGRect()
    
    func getallwastedata(_ subscription_key:String, leedid: Int){
        let url = URL.init(string:String(format: "%@assets/LEED:%d/waste/",domain_url, leedid))
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
                if((error?.localizedDescription.contains("cancelled")) != nil){
                    if(error?._code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    //print("error=\(error?.localizedDescription)")
                                        DispatchQueue.main.async(execute: {
                        //self.tableview.hidden = false
                        self.spinner.isHidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            }
            else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print("Meters are",jsonDictionary)
                    //self.graphPoints = jsonDictionary["results"] as! NSArray
                    self.currentmetersdict  = (jsonDictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    self.meters = (jsonDictionary["results"] as! NSDictionary).mutableCopy() as! NSMutableArray
                    self.graphPoints = self.meters
                    
                    for i in 0...self.meters.count-1{
                        var item = (self.meters.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        var f1 = 0.0234234
                        var f2 = 0.0
                        f1 = item["waste_diverted"] as! Double
                        f2 = item["waste_generated"] as! Double
                        self.data.append(Int(f1))
                        self.data2.append(Int(f2))
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        var tempdict = NSMutableDictionary()
                        var date = dateFormatter.date(from: item["start_date"] as! String)! 
                        tempdict["start_date"] = date
                        date = dateFormatter.date(from: item["end_date"] as! String)! 
                        tempdict["end_date"] = date
                        self.startdatearr.add(tempdict)
                        self.enddatearr.add(tempdict)
                        
                        var  sortDescriptor = NSSortDescriptor.init(key: "start_date", ascending: true)
                        self.startdatearr.sort(using: NSArray.init(object: sortDescriptor) as! [NSSortDescriptor])
                        sortDescriptor = NSSortDescriptor.init(key: "end_date", ascending: true)
                        self.enddatearr.sort(using: NSArray.init(object: sortDescriptor) as! [NSSortDescriptor])
                    }
                    var tempdict = NSMutableDictionary()
                    if(self.startdatearr.count > 0){
                        let d = self.startdatearr.firstObject as! NSDictionary
                        tempdict["start_date"] = d["start_date"] as! Date
                    }
                    if(self.enddatearr.count > 0){
                        let d = self.enddatearr.lastObject as! NSDictionary
                        tempdict["end_date"] = d["end_date"] as! Date
                    }
                    
                    self.meterdates.add(tempdict)
                    self.startdatearr.removeAllObjects()
                    self.enddatearr.removeAllObjects()
                    
                    //print(self.startdatearr.firstObject,self.enddatearr.lastObject)
                    UserDefaults.standard.set(self.data, forKey: "data")
                    UserDefaults.standard.set(self.data2, forKey: "data2")
                        DispatchQueue.main.async(execute: {
                            
                            
                            
                    })
                    
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
    
    
    func reloadtable(){
        self.tableview.reloadData()
    }
    
    @IBAction func next(_ sender: AnyObject) {
        if(currentindex<currentcategory.count-1){
            /*if(task.currentRequest != nil){
             if (task.state == NSURLSessionTaskState.Running) {
             task.cancel()
             }
             }*/
            currentindex = currentindex+1
            UserDefaults.standard.set(currentindex, forKey: "selected_action")
            currentarr = (currentcategory[currentindex] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            if(checkcredit_type(currentarr) == "Data input" && (currentarr["CreditDescription"] as! String).lowercased() != "waste"){
                navigate()
            }else if((currentarr["CreditDescription"] as! String).lowercased() == "waste"){
                let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                let listofactions = mainstoryboard.instantiateViewController(withIdentifier: "listofactions")
                let datainput = mainstoryboard.instantiateViewController(withIdentifier: "waste")
                let rootViewController = self.navigationController
                var controllers = (rootViewController!.viewControllers)
                controllers.removeAll()
                var v = UIViewController()
                var grid = 0
                grid = UserDefaults.standard.integer(forKey: "grid")
                if(UserDefaults.standard.integer(forKey: "grid") == 1){
                    v = mainstoryboard.instantiateViewController(withIdentifier: "grid") as! UINavigationController
                }else{
                    v = mainstoryboard.instantiateViewController(withIdentifier: "listofassets") as! UINavigationController
                }
                var listofassets = mainstoryboard.instantiateViewController(withIdentifier: "projectslist")
                if(grid == 1){
                    listofassets = mainstoryboard.instantiateViewController(withIdentifier: "gridvc")
                }else{
                    listofassets = mainstoryboard.instantiateViewController(withIdentifier: "projectslist")
                }
                let dict = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary
                listofassets.navigationItem.title = dict["name"] as? String
                controllers.append(listofassets)
                controllers.append(listofactions)
                controllers.append(datainput)
                //self.navigationController!.hidesBarsOnTap = false;
                //self.navigationController!.hidesBarsOnSwipe = false;
                //self.navigationController!.hidesBarsWhenVerticallyCompact = false;
                self.navigationController?.setViewControllers(controllers, animated: false)

            }else{
                //self.performSegueWithIdentifier("prerequisites", sender: nil)
                let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                let listofactions = mainstoryboard.instantiateViewController(withIdentifier: "listofactions")
                let datainput = mainstoryboard.instantiateViewController(withIdentifier: "prerequisites")
                let rootViewController = self.navigationController
                var controllers = (rootViewController!.viewControllers)
                controllers.removeAll()
                var v = UIViewController()
                var grid = 0
                grid = UserDefaults.standard.integer(forKey: "grid")
                if(UserDefaults.standard.integer(forKey: "grid") == 1){
                    v = mainstoryboard.instantiateViewController(withIdentifier: "grid") as! UINavigationController
                }else{
                    v = mainstoryboard.instantiateViewController(withIdentifier: "listofassets") as! UINavigationController
                }
                var listofassets = mainstoryboard.instantiateViewController(withIdentifier: "projectslist")
                if(grid == 1){
                    listofassets = mainstoryboard.instantiateViewController(withIdentifier: "gridvc")
                }else{
                    listofassets = mainstoryboard.instantiateViewController(withIdentifier: "projectslist")
                }
                let dict = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary
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
    
    
    @IBAction func affirmationview1close(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.beginFromCurrentState, animations: { () -> Void in
            ////self.tableview.frame = self.actualtableframe
            //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
            self.affirmationview1.isHidden = true
            }, completion: { (finished: Bool) -> Void in
                
                // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
                
        })
    }
    
    
    
    
    @IBOutlet weak var activityfeedbutton: UIButton!
    @IBOutlet weak var tabbar: UITabBar!
    @IBAction func affirmationsclick(_ sender: AnyObject) {
        
        if(self.actiontitle.text!.contains("Policy")){
            self.affirmationview1.isHidden = true
            //self.affirmationview2.hidden = false
            
            //self.affirmationview2.hidden = false
            self.affirmationview2.transform = CGAffineTransform(scaleX: 1, y: 1);
            ////self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview2.layer.frame.origin.y + self.affirmationview2.layer.frame.size.height), self.tableview.layer.frame.size.width,  self.tableview.layer.frame.size.height)
            //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
            /* UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
             self.affirmationview2.transform = CGAffineTransformMakeScale(1.3, 1.3);
             UIView.animateWithDuration(0.3, delay: 0.3, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
             self.affirmationview2.transform = CGAffineTransformMakeScale(1, 1);
             //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.1*self.affirmationview2.layer.frame.origin.y+self.affirmationview2.layer.frame.size.height, self.tableview.layer.frame.size.width, fabs(self.view.layer.frame.size.height-(self.activityfeedbutton.layer.frame.size.height+self.tabbar.layer.frame.size.height+(1.1*(self.affirmationview2.layer.frame.origin.y+self.affirmationview2.layer.frame.size.height)))))
             }, completion: { (finished: Bool) -> Void in
             
             // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
             
             })
             }, completion: { (finished: Bool) -> Void in
             
             // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
             
             })*/
            
        }else{
            //self.affirmationview1.hidden = false
            self.affirmationview2.isHidden = true
            //self.affirmationview1.hidden = false
            self.affirmationview1.transform = CGAffineTransform(scaleX: 1, y: 1);
           //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  self.tableview.layer.frame.size.height)
            //print("Tableview height",self.tableview.frame.size.height)
            //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
            /* UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
             self.affirmationview1.transform = CGAffineTransformMakeScale(1.3, 1.3);
             UIView.animateWithDuration(0.3, delay: 0.3, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
             self.affirmationview1.transform = CGAffineTransformMakeScale(1, 1);
             //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.1*self.affirmationview1.layer.frame.origin.y+self.affirmationview1.layer.frame.size.height, self.tableview.layer.frame.size.width, fabs(self.view.layer.frame.size.height-(self.activityfeedbutton.layer.frame.size.height+self.tabbar.layer.frame.size.height+(1.1*(self.affirmationview1.layer.frame.origin.y+self.affirmationview1.layer.frame.size.height)))))
             }, completion: { (finished: Bool) -> Void in
             
             // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
             
             })
             }, completion: { (finished: Bool) -> Void in
             
             // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
             
             })*/
            
        }
        
        
        
    }
    
    func getmeters(_ subscription_key:String, leedid: Int, kind: String){
        let url = URL.init(string:String(format: "%@assets/LEED:%d/meters/?kind=%@&page_size=10",domain_url, leedid,kind))
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
                if((error?.localizedDescription.contains("cancelled")) != nil){
                    if(error?._code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                //print("error=\(error?.localizedDescription)")
                                DispatchQueue.main.async(execute: {
                    //self.tableview.hidden = false
                    self.spinner.isHidden = true
                    //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                    //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                }
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            }
            else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    //self.tableview.hidden = false
                    //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                    //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print("Meters are",jsonDictionary)
                    //self.graphPoints = jsonDictionary["results"] as! NSArray
                    self.currentmetersdict  = (jsonDictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    self.meters = (jsonDictionary["results"] as! NSArray).mutableCopy() as! NSMutableArray
                    self.graphPoints = self.meters
                    if(self.meters.count == 0){
                    //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                    }else{
                    //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width, self.tableview.layer.frame.size.height)
                        //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                    }
                    DispatchQueue.main.async(execute: {
                    //self.getmeterdata()
                        self.getmeterreadings()
                        })
                    
                    // self.buildingactions(subscription_key, leedid: leedid)
                    
                } catch {
                    //print(error)
                    DispatchQueue.main.async(execute: {
                        //self.tableview.hidden = false
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
            }
            
        }) 
        task.resume()
    }
    
    func getcreditformsuploadsdata(_ subscription_key:String, leedid: Int, actionID: String){
        
        let url = URL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@/uploads/",domain_url, leedid, actionID))
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
                if((error?.localizedDescription.contains("cancelled")) != nil){
                    if(error?._code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    //print("error=\(error?.localizedDescription)")
                                        DispatchQueue.main.async(execute: {
                        //self.tableview.hidden = false
                        self.spinner.isHidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            }
            else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    self.uploadsdata = jsonDictionary["EtFile"] as! NSArray
                    //print(jsonDictionary)
                    DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                        
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
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            if (currentmetersdict["next"] as? String) != nil {
                if(isloading == false && meters.count <= 15){
                    let c = credentials()
                    loadMoreDataFromServer(currentmetersdict["next"] as! String, subscription_key: c.subscription_key)
                    self.tableview.reloadData()
                }
            }
        }
    }

    func loadMoreDataFromServer(_ URL: String, subscription_key:String){
        let url = Foundation.URL.init(string:URL)
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(session)
        self.task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.localizedDescription.contains("cancelled")) != nil){
                    if(error?._code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    //print("error=\(error?.localizedDescription)")
                                        DispatchQueue.main.async(execute: {
                        //self.tableview.hidden = false
                        self.spinner.isHidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            }
            else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print("Meters are",jsonDictionary)
                    //self.graphPoints = jsonDictionary["results"] as! NSArray
                    self.currentmetersdict  = jsonDictionary.mutableCopy() as! NSMutableDictionary
                    var temparr = NSMutableArray()
                    let tempmeters = NSMutableArray()
                    temparr = (jsonDictionary["results"] as! NSArray).mutableCopy() as! NSMutableArray
                    
                    for i in 0..<self.meters.count {
                        tempmeters.add(self.meters.object(at: i))
                    }
                    
                    for i in 0..<temparr.count {
                        tempmeters.add(temparr.object(at: i))
                    }
                    self.meters = tempmeters
                    
                    
                    self.graphPoints = self.meters
                    DispatchQueue.main.async(execute: {
                        self.spinner.isHidden = true
                        
                        self.tableview.reloadData()
                    })
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
    
    @IBAction func changestatus(_ sender: AnyObject) {
        self.statusupdate(UILabel())
    }
    
    func getmeterreadings(){//(subscription_key:String, leedid: Int, actionID: Int){
        if(meters.count == 0){
            self.meters = NSMutableArray()
            self.tableview.reloadData()
            //self.maketoast("No meters found",type: "error")
            self.spinner.isHidden = true
            self.tableview.reloadData()
            DispatchQueue.main.async(execute: {
                
                self.spinner.isHidden = false
                self.showactivityfeed(UserDefaults.standard.integer(forKey: "leed_id"), creditID: self.currentarr["CreditId"] as! String, shortcreditID: self.currentarr["CreditShortId"] as! String)
            })
        }
        
        for (index,i) in meters.enumerated()
        {
            var item = i as! NSDictionary
            let subscription_key = credentials().subscription_key
            let leedid = UserDefaults.standard.integer(forKey: "leed_id")
            let actionID = item["id"] as! Int
        let url = URL.init(string:String(format: "%@assets/LEED:%d/meters/ID:%d/consumption/",domain_url, leedid, actionID))
        ////print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
       let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.localizedDescription.contains("cancelled")) != nil){
                    if(error?._code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    //print("error=\(error?.localizedDescription)")
                                        DispatchQueue.main.async(execute: {
                        //self.tableview.hidden = false
                        self.spinner.isHidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  150)
                        //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                return
            }
        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
            DispatchQueue.main.async(execute: {
                self.spinner.isHidden = true
                self.view.isUserInteractionEnabled = true
                NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
            })
        }
            else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print("Meter readings ",jsonDictionary)
                    let arr = jsonDictionary["results"] as! NSArray
                    //print(arr,index)
                    self.arrayofreadings["\(actionID)"] = arr
                    self.entirereadingsarr.add(arr)
                    for i in 0..<arr.count {
                        var dict = (arr.object(at: i) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        self.tempgraphdata.append(Int(dict["reading"]as! Float))
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = credentials().micro_secs
                        if(dateFormatter.date(from: dict["start_date"] as! String) == nil){
                            dateFormatter.dateFormat = credentials().milli_secs
                        }
                            var tempdict = NSMutableDictionary()
                            print(dict["start_date"] as! String)
                            var date = dateFormatter.date(from: dict["start_date"] as! String)! 
                            tempdict["start_date"] = date
                            date = dateFormatter.date(from: dict["end_date"] as! String)! 
                            tempdict["end_date"] = date
                            self.startdatearr.add(tempdict)
                            self.enddatearr.add(tempdict)
                            var sortDescriptor = NSSortDescriptor.init(key: "start_date", ascending: true)
                            self.startdatearr.sort(using: NSArray.init(object: sortDescriptor) as! [NSSortDescriptor])
                            sortDescriptor = NSSortDescriptor.init(key: "end_date", ascending: true)
                            self.enddatearr.sort(using: NSArray.init(object: sortDescriptor) as! [NSSortDescriptor])
                    }
                    var tempdict = NSMutableDictionary()
                    if(self.startdatearr.count > 0){
                        let d = self.startdatearr.firstObject as! NSDictionary
                    tempdict["start_date"] = d["start_date"] as! Date
                    }
                    if(self.enddatearr.count > 0){
                        let d = self.enddatearr.lastObject as! NSDictionary
                    tempdict["end_date"] = d["end_date"] as! Date
                    }
                    self.meterdates.add(tempdict)
                    self.startdatearr.removeAllObjects()
                    self.enddatearr.removeAllObjects()
                    self.datesdict["\(actionID)"] = tempdict
                    self.readingsdict["\(actionID)"] = self.tempgraphdata
                    self.readingsarr.add(self.tempgraphdata)
                    self.tempgraphdata.removeAll()
                    //print("Actual reading is",self.readingsarr)
                    if(self.readingsarr.count == self.meters.count){
                        DispatchQueue.main.async(execute: {
                            
                            self.showactivityfeed(UserDefaults.standard.integer(forKey: "leed_id"), creditID: self.currentarr["CreditId"] as! String, shortcreditID: self.currentarr["CreditShortId"] as! String)
                        })
                    }
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

    func getmeterdata() {
        
        for i in 0..<self.meters.count {
            _ = credentials()
            var tempdict = meters.object(at: i) as! NSMutableDictionary
            if(self.meters.count == 1){
                self.id = tempdict["id"] as! Int
                //self.getmeterreadings(c.subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), actionID: tempdict["id"] as! Int)
            }else{
                DispatchQueue.main.asyncAfter(
                    deadline: DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
                    execute: {
                        self.id = tempdict["id"] as! Int
                       // self.getmeterreadings(c.subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), actionID: tempdict["id"] as! Int)
                    }
                )
            }
                // go to something on the main thread with the image like setting to UIImageView
        }
        
        
        if(self.meters.count == 0){
            DispatchQueue.main.async(execute: {
                self.spinner.isHidden = true
            })
        }
        
        
    }
    @IBOutlet weak var backbtn: UIButton!
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) is customcellwithgraph){
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! customcellwithgraph
                sel_title = cell.heading.text!
        }
        if(indexPath.section > 0){
            
        if(indexPath.section == meters.count+1){
            
        }
        }
    }
    func deletemeter(_ subscription_key:String, leedid: Int, meterID : Int){
        let url = URL.init(string: String(format: "%@assets/LEED:%d/meters/ID:%d/?recompute_score=1",domain_url,leedid, meterID))
        ////print(url?.absoluteURL)
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "DELETE"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.setValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let dict = NSArray()
        do{
        let postData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions())
            request.httpBody = postData
        }catch{
            
        }
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.localizedDescription.contains("cancelled")) != nil){
                    if(error?._code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    //print("error=\(error?.localizedDescription)")
                                        DispatchQueue.main.async(execute: {
                        //self.tableview.hidden = false
                        self.spinner.isHidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            }
            else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                
                DispatchQueue.main.async(execute: {
                    self.maketoast("Meter deleted successfully",type: "message")
                    UserDefaults.standard.synchronize()
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    self.navigate()
                })
            }
            
        }) 
        task.resume()
    }
    @IBOutlet weak var assignnav: UINavigationBar!

    @IBAction func assigneecancel(_ sender: Any) {
        self.assigncontainer.isHidden = true
        self.sview.alpha = 1
    }
    @IBAction func assigneesave(_ sender: Any) {
        DispatchQueue.main.async(execute: {
            if let creditDescription = self.currentarr["CreditStatus"] as? String{
                if(creditDescription.lowercased() == "under review"){
                    self.showalert("Updation is not allowed when the credit is under review", title: "Error", action: "OK")
                }else{
        self.view.isUserInteractionEnabled = false
        self.spinner.isHidden = false
        let d = self.teammembers[self.picker.selectedRow(inComponent: 0)] as! NSDictionary
        self.assignnewmember(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"), actionID: self.currentarr["CreditId"] as! String, email:d["Useralias"] as! String,firstname:d["Firstname"] as! String,lastname: d["Lastname"] as! String)
                }
            }
        })
    }
    var currentmeter = NSDictionary()
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation*/
    var sel_title = ""
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*if(segue.identifier == "gotoreadings"){
        NSUserDefaults.standardUserDefaults().setInteger(id, forKey: "meterID")
        NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(selectedreading), forKey: "selreading")
        }*/
        if(segue.identifier == "gotoreadings"){
            let vc = segue.destination  as! listall
            vc.dataarr = selectedreading.mutableCopy() as! NSMutableArray
            vc.id = id
            vc.meter_name = sel_title
        }else if(segue.identifier == "gotoaddmeter"){
            let vc = segue.destination as! addnewmetervc
            vc.type = self.type
            vc.s = self.s
            if(currentmeter.count > 0){
                vc.edit = self.edit
                vc.meterID = currentmeter["id"] as! Int
                vc.name = currentmeter["name"] as! String
            vc.selected_unit = currentmeter["native_unit"] as! String
            vc.currentmeter = currentmeter ["fuel_type"] as! NSDictionary
            let unitsarr = [["kWh","MWh","MBtu","kBtu","Gj"],["gal","kGal","MGal","cf","ccf","kcf","mcf","I","cu m","gal(UK)","kGal(UK)","kGal(UK)","MGal(UK)"],["kWh","MWh","therms","kBtu","MBtu","Gj","cu m","I","gal","kGal","MGal","cf","ccf","kcf","mcf"]]
            let otherfuelsarr = [["kWh","MWh","therms","kBtu","MBtu","GJ","Lbs","KLbs","MLbs","kg"],["kWh","MWh","therms","kBtu","MBtu","GJ"],
                                 ["kWh","MWh","therms","kBtu","MBtu","GJ","ton hours"],
                                 ["kWh","MWh","therms","kBtu","MBtu","GJ","ton hours"],
                                 ["kWh","MWh","therms","kBtu","MBtu","GJ","ton hours"],
                                 ["kWh","MWh","therms","kBtu","MBtu","Gj","cu m","I","gal","kGal","MGal","cf","ccf","kcf","mcf"],
                                 ["kWh","MWh","therms","kBtu","MBtu","Gj","cu m","I","gal","kGal","MGal","cf","ccf","kcf","mcf"],
                                 ["kWh","MWh","therms","kBtu","MBtu","GJ","tons","Tonnes (metric)"],
                                 ["kWh","MWh","therms","kBtu","MBtu","Gj","cu m","I","gal","kGal","MGal","cf","ccf","kcf","mcf"],
                                 ["kWh","MWh","therms","kBtu","MBtu","Gj","cu m","I","gal","kGal","MGal","cf","ccf","kcf","mcf"],
                                 ["kWh","MWh","therms","kBtu","MBtu","Gj","cu m","I","gal","kGal","MGal","cf","ccf","kcf","mcf"],
                                 ["kWh","MWh","therms","kBtu","MBtu","Gj","cu m","I","gal","kGal","MGal","cf","ccf","kcf","mcf"],
                                 ["kWh","MWh","therms","kBtu","MBtu","Gj","cu m","I","gal","kGal","MGal","cf","ccf","kcf","mcf"],
                                 ["kWh","MWh","therms","kBtu","MBtu","GJ","tons","Lbs","MLbs","Tonnes (metric)"],
                                 ["kWh","MWh","therms","kBtu","MBtu","GJ","tons","Lbs","MLbs","Tonnes (metric)"],
                                 ["kWh","MWh","therms","kBtu","MBtu","GJ","tons","Lbs","MLbs","Tonnes (metric)"],
                                 ["kWh","MWh","therms","kBtu","MBtu","Gj","cu m","I","gal","kGal","MGal","cf","ccf","kcf","mcf"],
                                 ["kWh","MWh","therms","kBtu","MBtu","Gj","cu m","I","gal","kGal","MGal","cf","ccf","kcf","mcf"]]

                for i in 0 ..< unitsarr.count {
                    let arr = unitsarr[i] as NSArray
                    if(arr.contains(currentmeter["native_unit"] as! String)){
                        vc.currentunit = arr
                        vc.type = i
                        break
                    }
                }
                
                for i in 0 ..< otherfuelsarr.count {
                    let arr = otherfuelsarr[i] as NSArray
                    if(arr.contains(currentmeter["native_unit"] as! String)){
                        vc.currentunit = arr
                        vc.type = 2
                        break
                    }
                }
                
                
                /*if(type == 0){
                    currentunit = unitsarr[0] as! NSArray
                    currentmetertype = electricityarr
                }else if(type == 1){
                    currentunit = unitsarr[1] as! NSArray
                    currentmetertype = waterarr
                }else if(type == 2){
                    currentunit = otherfuelsarr[0] as! NSArray
                    currentmetertype = othersarr
                }*/
            }
        }
    }
    
    
    func affirmationupdate(_ actionID:String, leedid: Int, subscription_key:String){
        //
        var url = URL.init(string:"")
        let s = String(format:"%d",leedid)
        if(actionID.contains(s)){
            url = URL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@/",domain_url, leedid, actionID))!
        }
        else{
            url = URL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@-%d/",domain_url, leedid, actionID,leedid))!
        }
        ////print(url.absoluteString)
        DispatchQueue.main.async(execute: {
            self.view.isUserInteractionEnabled = false
        })
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "PUT"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var httpbody = String()
        if(self.actiontitle.text!.contains("Policy")){
            httpbody = String(format: "{\"IvAttchPolicy\": %@, \"IvReqFileupload\": %@}",self.ivattached2.isOn as CVarArg,ivupload2.isOn as CVarArg)
        }else{
            httpbody = String(format: "{\"IvAttchPolicy\": %@, \"IvReqFileupload\": %@}",self.ivattached2.isOn as CVarArg,ivupload1.isOn as CVarArg)
        }
        request.httpBody = httpbody.data(using: String.Encoding.utf8)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(session)
        self.task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.localizedDescription.contains("cancelled")) != nil){
                    if(error?._code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    //print("error=\(error?.localizedDescription)")
                                        DispatchQueue.main.async(execute: {
                        //self.tableview.hidden = false
                        self.spinner.isHidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            }else
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 && httpStatus.statusCode != 201 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                
                var jsonDictionary : NSDictionary
                do {
                    if(self.actiontitle.text!.contains("Policy")){
                        if(self.ivattached2.isOn == true){
                            self.currentarr["IvAttchPolicy"] = "X"
                        }else{
                            self.currentarr["IvAttchPolicy"] = ""
                        }
                        
                        if(self.ivupload2.isOn == true){
                            self.currentarr["IvReqFileupload"] = "X"
                        }else{
                            self.currentarr["IvReqFileupload"] = ""
                        }
                    }else{
                        if(self.ivattached2.isOn == true){
                            self.currentarr["IvAttchPolicy"] = "X"
                        }else{
                            self.currentarr["IvAttchPolicy"] = ""
                        }
                        
                        if(self.ivupload1.isOn == true){
                            self.currentarr["IvReqFileupload"] = "X"
                        }else{
                            self.currentarr["IvReqFileupload"] = ""
                        }
                    }

                    self.currentcategory.replaceObject(at: UserDefaults.standard.integer(forKey: "selected_action"), with: self.currentarr)                    
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print(jsonDictionary)
                    self.updatebuildingactions(subscription_key, leedid: leedid)
                    //self.tableview.reloadData()
                    //
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

    
    

    
    
    
    @IBAction func assignclose(_ sender: AnyObject) {
        self.assigncontainer.isHidden = true
        self.sview.alpha = 1        
    }
    
    func assignnewmember(_ subscription_key:String, leedid: Int, actionID: String, email:String,firstname: String, lastname:String){
        //https://api.usgbc.org/dev/leed/assets/LEED:{leed_id}/actions/ID:{action_id}/teams/
        var url = URL.init(string:"")
        let s = String(format:"%d",leedid)
        if(actionID.contains(s)){
                url = URL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@/teams/",domain_url, leedid, actionID))!
        }
        else{
            url = URL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@-%d/teams/",domain_url, leedid, actionID,leedid))!
        }
        DispatchQueue.main.async(execute: {
            self.view.isUserInteractionEnabled = false
        })
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "POST"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let httpbody = String(format: "{\"emails\":\"%@\"}",email)
        request.httpBody = httpbody.data(using: String.Encoding.utf8)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(session)
        self.task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.localizedDescription.contains("cancelled")) != nil){
                    if(error?._code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    //print("error=\(error?.localizedDescription)")
                                        DispatchQueue.main.async(execute: {
                        //self.tableview.hidden = false
                        self.spinner.isHidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            }
            else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
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
                        self.currentarr["PersonAssigned"] = String(format: "%@ %@",firstname,lastname)
                        self.assigncontainer.isHidden = true
                        self.sview.alpha = 1
                        self.currentcategory.replaceObject(at: UserDefaults.standard.integer(forKey: "selected_action"), with: self.currentarr)
                        self.buildingactions(subscription_key, leedid: leedid)
                        
                    })
                    //self.tableview.reloadData()
                    //
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
    
    
    func buildingactions(_ subscription_key:String, leedid: Int){
        let url = URL.init(string: String(format: "%@assets/LEED:%d/actions/",domain_url,leedid))
        ////print(url?.absoluteURL)
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.localizedDescription.contains("cancelled")) != nil){
                    if(error?._code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    //print("error=\(error?.localizedDescription)")
                                        DispatchQueue.main.async(execute: {
                        //self.tableview.hidden = false
                        self.spinner.isHidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            }
            else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
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
                        print("response if ",jsonDictionary)
                        let datakeyed = NSKeyedArchiver.archivedData(withRootObject: jsonDictionary)
                        UserDefaults.standard.set(datakeyed, forKey: "actions_data")
                        UserDefaults.standard.synchronize()
                        self.spinner.isHidden = true
                        self.view.isUserInteractionEnabled = true
                        if(jsonDictionary["EtScorecardList"] != nil){
                        self.currentcategory = (jsonDictionary["EtScorecardList"] as! NSArray).mutableCopy() as! NSMutableArray
                        }
                        self.maketoast("Updated successfully",type: "message")
                        self.navigate()
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

    
    @IBAction func okassignthemember(_ sender: AnyObject) {
        if(statusupdate == 1){
            self.view.isUserInteractionEnabled = false
            self.spinner.isHidden = false
            savestatusupdate(currentarr["CreditId"] as! String, subscription_key: credentials().subscription_key)
            
        }else{
            self.view.isUserInteractionEnabled = false
            self.spinner.isHidden = false
            let d = teammembers[picker.selectedRow(inComponent: 0)] as! NSDictionary
            assignnewmember(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"), actionID: currentarr["CreditId"] as! String, email:d["Useralias"] as! String,firstname:d["Firstname"] as! String,lastname: d["Lastname"] as! String)
        }


    }
    
    @IBAction func closetheassigncontainer(_ sender: AnyObject) {
         self.assigncontainer.isHidden = true
        self.sview.alpha = 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return teammembers.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(statusupdate == 1){
            return teammembers[row] as? String
        }
        var d = teammembers[row] as! NSDictionary
        return d["Useralias"] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        assignokbtn.isEnabled = true
    }
    

    func getteammembers(_ subscription_key:String, leedid:Int){
        let url = URL.init(string:String(format: "%@assets/LEED:%d/teams/",domain_url, leedid))
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
                if((error?.localizedDescription.contains("cancelled")) != nil){
                    if(error?._code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    //print("error=\(error?.localizedDescription)")
                                        DispatchQueue.main.async(execute: {
                        //self.tableview.hidden = false
                        self.spinner.isHidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            }
            else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
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
                    let team_membersarray = jsonDictionary["EtTeamMembers"] as! NSArray
                    self.teammembers = team_membersarray
                    var temparr = NSMutableArray()
                    for i in self.teammembers{
                        let item = i as! NSDictionary
                        var arr = item
                        if(arr["Rolestatus"] as! String != "Deactivated Relationship"){
                            temparr.add(arr)
                        }
                    }
                    var currentar = NSMutableArray()
                    var keys = NSMutableSet()
                    var result = NSMutableArray()
                    
                    
                    for d in temparr{
                        let data = d as! NSDictionary
                        var key = data["email"] as! String
                        if(keys.contains(key)){
                            continue
                        }
                        keys.add(key)
                        result.add(data)
                        
                    }
                    
                    //print(result)
                    self.teammembers = result
                    DispatchQueue.main.async(execute: {
                        self.assigncontainer.isHidden = false
        self.sview.alpha = 0.3
                        self.spinner.isHidden = true
                        
                        self.picker.reloadAllComponents()
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
    
   
    
    
    
    func updatebuildingactions(_ subscription_key:String, leedid: Int){
        let url = URL.init(string: String(format: "%@assets/LEED:%d/actions/",domain_url,leedid))
        ////print(url?.absoluteURL)
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.localizedDescription.contains("cancelled")) != nil){
                    if(error?._code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    //print("error=\(error?.localizedDescription)")
                                        DispatchQueue.main.async(execute: {
                        //self.tableview.hidden = false
                        self.spinner.isHidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            }
            else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
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
                    let datakeyed = NSKeyedArchiver.archivedData(withRootObject: jsonDictionary)
                    UserDefaults.standard.set(datakeyed, forKey: "actions_data")
                    
                    UserDefaults.standard.synchronize()
                    UserDefaults.standard.set(0, forKey: "row")
                    DispatchQueue.main.async(execute: {
                        self.spinner.isHidden = true
                        
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

    
    func valuechanged(_ sender:UISwitch){
        if(sender.tag == 101 || sender.tag == 102 || sender.tag == 103){
        DispatchQueue.main.async(execute: {
            if let creditDescription = self.currentarr["CreditStatus"] as? String{
                if(creditDescription.lowercased() == "under review"){
                    self.showalert("Updation is not allowed when the credit is under review", title: "Error", action: "OK")
                }else{
            self.spinner.isHidden = false
            self.view.isUserInteractionEnabled = false
            self.affirmationupdate(self.currentarr["CreditId"] as! String, leedid: self.leedid, subscription_key: credentials().subscription_key)
                }
            }
        })
        
        }
    }
    var s = ""
    var type = 0
    @IBAction func addnewmeter(_ sender: AnyObject) {
        var alertController = UIAlertController()
        
        if(currentarr["CreditDescription"] as! String == "Water"){
            s = "Water"
            self.type = 0
        }else{
            s = "Energy"
            self.type = 0
        }
        let normal = UIAlertAction(title: s, style: .default, handler: { action in
            self.performSegue(withIdentifier: "gotoaddmeter", sender: nil)
        })
        let others = UIAlertAction(title: "Other fuels", style: .default, handler: {action in
            self.type = 1
            self.performSegue(withIdentifier: "gotoaddmeter", sender: nil)
            
        })
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad){
            alertController = UIAlertController(title: "Create a new meter", message: "Please select the type of meter you want to create", preferredStyle: .alert)
        }else{
            alertController = UIAlertController(title: "Create a new meter", message: "Please select the type of meter you want to create", preferredStyle: .actionSheet)
        }
        alertController.view.subviews.first?.backgroundColor = UIColor.white
        alertController.view.layer.cornerRadius = 10
        alertController.view.layer.masksToBounds = true
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alertController.addAction(normal)
        alertController.addAction(others)
        alertController.view.subviews.first?.backgroundColor = UIColor.white
        alertController.view.layer.cornerRadius = 10
        alertController.view.layer.masksToBounds = true
        self.present(alertController, animated: true, completion: nil)

        //
    }
    
    func savestatusupdate(_ actionID:String, subscription_key:String){
        //
        var url = URL.init(string:"")
        let s = String(format:"%d",leedid)
        if(actionID.contains(s)){
            url = URL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@/",domain_url, leedid, actionID))!
        }
        else{
            url = URL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@-%d/",domain_url, leedid, actionID,leedid))!
        }
        ////print(url.absoluteString)
        DispatchQueue.main.async(execute: {
            self.view.isUserInteractionEnabled = false
        })
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "PUT"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var httpbody = String()
        let string = self.statusarr[self.picker.selectedRow(inComponent: 0)] 
        if(statusswitch.isOn == true){
            httpbody = String(format: "{\"is_readyForReview\": %@}",statusswitch.isOn as CVarArg)
        }else{
            httpbody = String(format: "{\"is_readyForReview\": %@}",statusswitch.isOn as CVarArg)
        }
        /*if(string == "Ready for review"){
            httpbody = String(format: "{\"is_readyForReview\": %@}",true)
        }else{
            httpbody = String(format: "{\"is_readyForReview\": %@}",false)
        }*/
        request.httpBody = httpbody.data(using: String.Encoding.utf8)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(session)
        self.task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.localizedDescription.contains("cancelled")) != nil){
                    if(error?._code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    //print("error=\(error?.localizedDescription)")
                                        DispatchQueue.main.async(execute: {
                        //self.tableview.hidden = false
                        self.spinner.isHidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            } else
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 && httpStatus.statusCode != 201 {           // check for http errors
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
                        self.creditstatus.text = string
                        self.currentarr["CreditStatus"] = string
                        self.currentcategory.replaceObject(at: UserDefaults.standard.integer(forKey: "selected_action"), with: self.currentarr)
                        self.buildingactions(subscription_key, leedid: self.leedid)
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
}
