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
    var download_requests = [NSURLSession]()
    var uploadsdata = NSArray()
    var id = 0
    var arrayofreadings = NSMutableDictionary()
    var statusarr = ["Attempted","Ready for review"]
    var leedid = NSUserDefaults.standardUserDefaults().integerForKey("leed_id")
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
    
    var task = NSURLSessionTask()
    @IBOutlet weak var next: UIButton!
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
    var currentarr = [String:AnyObject]()
    var currentmetersdict = [String:AnyObject]()
    var currentcategory = NSMutableArray()
    var currentindex = 0
    var startdatearr = NSMutableArray()
    var enddatearr = NSMutableArray()
    var graphPoints = NSArray()
    var samplegraphdata = [Int]()
    var tempgraphdata = [Int]()
    var readingsarr = NSMutableArray()
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if(fromnotification == 1){
            self.navigationController?.navigationBar.backItem?.title = "Notifications"
        }else{
            self.navigationController?.navigationBar.backItem?.title = "Credits/Actions"
        }
        navigate()
    }
    
    func rotateme(){
        if(UIDevice.currentDevice().orientation == .Portrait){
            //sview.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, 0.9 * UIScreen.mainScreen().bounds.size.height)
        }else{
            //sview.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.height, 0.9 * UIScreen.mainScreen().bounds.size.width)
        }
        //feedstable.frame.origin.y = tableview.frame.origin.y + tableview.frame.size.height
        navigate()
        tableview.reloadData()
    }
    
    var fromnotification = NSUserDefaults.standardUserDefaults().integerForKey("fromnotification")    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(fromnotification == 1){
            prev.hidden = true
            next.hidden = true
        }else{
            prev.hidden = false
            next.hidden = false
        }
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        print("Suze is ",width,height)
        self.prev.layer.frame.origin.x = 0.98 * (self.next.layer.frame.origin.x - self.prev.layer.frame.size.width)
        self.titlefont()
        //feedstable.frame.origin.y = tableview.frame.origin.y + tableview.frame.size.height
        tableview.backgroundColor = UIColor.clearColor()
        //sview.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, 0.9 * UIScreen.mainScreen().bounds.size.height)
        affirmationtitle.adjustsFontSizeToFitWidth = true
        affirmationtext.adjustsFontSizeToFitWidth = true
        //self.view.userInteractionEnabled = false
        backbtn.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12)
        let notificationsarr = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("notifications") as! NSData) as! NSArray
        if(notificationsarr.count > 0 ){
            self.tabbar.items![4].badgeValue = "\(notificationsarr.count)"
        }else{
            self.tabbar.items![4].badgeValue = nil
        }
        self.spinner.layer.cornerRadius = 5
        self.spinner.hidden = true
        //self.view.userInteractionEnabled = true
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.assigncontainer.backgroundColor = UIColor.clearColor()
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.rotateme), name: UIDeviceOrientationDidChangeNotification, object: nil)
            blurEffectView.autoresizingMask = [ UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
            self.assigncontainer.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        } else {
            self.assigncontainer.backgroundColor = UIColor.blackColor()
        }
        
        
        
        self.assigncontainer.addSubview(picker)
        self.assigncontainer.addSubview(pleasekindly)
        self.assigncontainer.addSubview(assignokbtn)
        self.assigncontainer.addSubview(assignclosebutton)
        assignokbtn.enabled = false
        picker.delegate = self
        picker.dataSource = self
        
        tableview.registerNib(UINib.init(nibName: "customcellwithgraph", bundle: nil), forCellReuseIdentifier: "cell")
       // graphPoints = [[4, 2, 6, 4, 5, 8, 3],[4, 2, 6, 4, 5, 8, 3],[4, 2, 6, 4, 5, 8, 3],[4, 2, 6, 4, 5, 8, 3],[4, 2, 6, 4, 5, 8, 3],[4, 2, 6, 4, 5, 8, 3],[11,6, 7, 11, 2 ,3 ,5 ,6 ,7 ,8 ,9, 4, 2, 6, 4, 5, 8, 3],[4, 2, 6, 4, 5, 8, 3],[0,2],[4, 2, 6, 4, 5, 8, 3,4, 2, 6, 4, 5, 8, 3,4, 2, 6, 4, 5, 8, 3,4, 2, 6, 4, 5, 8, 3,0]]
        samplegraphdata  = [0,0,0,0,0]
        //graphPoints = samplegraphdata
        addnew.layer.cornerRadius = addnew.frame.size.height/2.0
        self.prev.layer.cornerRadius = 4
        self.next.layer.cornerRadius = 4
        self.tabbar.delegate = self
        self.tabbar.selectedItem = self.tabbar.items![1]
        tableview.registerNib(UINib.init(nibName: "prerequisitescell1", bundle: nil), forCellReuseIdentifier: "cell1")
        tableview.registerNib(UINib.init(nibName: "prerequisitescell2", bundle: nil), forCellReuseIdentifier: "cell2")
        tableview.registerNib(UINib.init(nibName: "wastecell", bundle: nil), forCellReuseIdentifier: "wastecell")
        actualtableframe = tableview.frame
        var datakeyed = NSData()
        token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        datakeyed = NSUserDefaults.standardUserDefaults().objectForKey("currentcategory") as! NSData
        currentcategory = NSKeyedUnarchiver.unarchiveObjectWithData(datakeyed)?.mutableCopy() as! NSMutableArray
        currentindex = NSUserDefaults.standardUserDefaults().integerForKey("selected_action")
        NSUserDefaults.standardUserDefaults().synchronize()
        print("aarra", currentcategory)
        currentarr = currentcategory[currentindex] as! [String:AnyObject]
        category.text = checkcredit_type(currentarr)
        self.actiontitle.text = currentarr["CreditDescription"] as? String
        let c = credentials()
        domain_url = c.domain_url
        let dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary
        assetname.text = dict["name"] as? String
        self.navigationItem.title = dict["name"] as? String
        self.nav.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "OpenSans", size: 13)!]
        let doneItem = UIBarButtonItem(title: "< Credits/Actions", style: .Plain, target: self, action: #selector(sayHello(_:)))
        let navItem = UINavigationItem(title: (dict["name"] as? String)!);
        navItem.leftBarButtonItem = doneItem;
        nav.setItems([navItem], animated: false);

        self.affirmationsclick(self.activityfeedbutton)
        self.affirmationview1.layer.cornerRadius = 5
        self.affirmationview2.layer.cornerRadius = 5
        self.ivupload1.tag = 101
        self.ivupload2.tag = 102
        self.ivattached2.tag = 103
        ivupload1.addTarget(self, action: #selector(datainput.valuechanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        ivupload2.addTarget(self, action: #selector(datainput.valuechanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        ivattached2.addTarget(self, action: #selector(datainput.valuechanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(self.refresh), userInfo: nil, repeats: false)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(datainput.statusupdate(_:)))
        self.creditstatus.userInteractionEnabled = true
        self.creditstatus.addGestureRecognizer(tap)
        navigate()
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appdelegate.shouldRotate = false
        
        // 2. Force the device in landscape mode when the view controller gets loaded
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
    }
    
    override func shouldAutorotate() -> Bool {
        // 3. Lock autorotate
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait]
    }
    
    
    func statusupdate(sender:UILabel){
        if(ivupload1.on == false){
            maketoast("Affirmation required before changing the status", type: "error")
        }else{
            self.teammembers = statusarr
            dispatch_async(dispatch_get_main_queue(), {
                self.assigncontainer.hidden = false
                self.spinner.hidden = true
                self.statusupdate = 1
                //self.view.userInteractionEnabled = true
                self.pleasekindly.text = "Please kindly select the below status for the action"
                self.assignokbtn.setTitle("Save", forState: UIControlState.Normal)
                self.picker.reloadAllComponents()
            })
        }
    }
    
    func sayHello(sender: UIBarButtonItem) {
        print("Projects clicked")
        self.performSegueWithIdentifier("gotoactions", sender: nil)
    }
    
    
    func refresh(){
        tableview.reloadData()
    }
    
    @IBOutlet weak var nav: UINavigationBar!
    func checkcredit_type(tempdict:[String:AnyObject]) -> String {
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
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(tableView == feedstable){
            return 1
        }
        if((currentarr["CreditDescription"] as! String).lowercaseString == "waste"){
         return 2
        }
        return meters.count+2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(tableView == tableview){
            if(section == meters.count + 1){
                return currentfeeds.count
            }
            return 1
        }
        
        return currentfeeds.count
    }
    
    

    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(tableView == feedstable){
            return 20
        }
        if(section == 0){
            return 1
        }
        return 30
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(tableView == feedstable){
            if(currentfeeds.count > 0){
                return "Activity feeds"
            }
            return "No activities present"
        }
        if(section == 0){
            return ""//"    Assigned user"
        }
        if(section == meters.count + 1){
            if(currentfeeds.count > 0){
                return "Activity feeds"
            }
            return "No activities present"
        }
        else if (section == 1){
            if(graphPoints.count > 0 ){
                return "Meters"
            }
        }
        
        return ""
    }
    
    
    func showactivityfeed(leedid: Int, creditID : String, shortcreditID : String){
        let url = NSURL.init(string:String(format: "%@assets/activity/?type=credit&leed_id=%d&credit_id=%@&credit_short_id=%@",domain_url, leedid,creditID, shortcreditID))
        print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.description.containsString("cancelled")) != nil){
                    if(error?.code == -999){
                        
                    }else{
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    print("error=\(error?.description)")
                    print("response",response)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableview.hidden = false
                        self.spinner.hidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401 {           // check for http errors
                dispatch_async(dispatch_get_main_queue(), {
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                })
            }else if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                print(data)
                var jsonDictionary : NSArray
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSArray
                    print(jsonDictionary)
                    self.currentfeeds = jsonDictionary
                    dispatch_async(dispatch_get_main_queue(), {
                        self.spinner.hidden = true
                        //self.view.userInteractionEnabled = true
                        //self.performSegueWithIdentifier("gotofeeds", sender: nil)
                        if(self.currentfeeds.count > 0){
                            //self.feedstable.hidden = false
                        }else{
                            //self.feedstable.hidden = true
                        }
                        print("Tableview height",self.tableview.frame.size.height)
                        self.tableview.reloadData()
                        //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                        self.spinner.hidden = true
                        
                        //self.feedstable.hidden = false
                        self.feedstable.reloadData()
                        self.tableview.hidden = false
                        self.spinner.hidden = true
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

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(tableView == tableview){
            if(indexPath.section == meters.count+1){
                let cell = tableView.dequeueReusableCellWithIdentifier("feedscell")!
                //tableView.frame.origin.y = tableview.frame.origin.y + tableview.frame.size.height
                var dict = currentfeeds.objectAtIndex(indexPath.row) as! [String:AnyObject]
                cell.textLabel?.text = dict["verb"] as? String
                cell.textLabel?.adjustsFontSizeToFitWidth = true
                cell.detailTextLabel?.numberOfLines = 5
                cell.textLabel?.numberOfLines = 5
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                var str = dict["timestamp"] as! String
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
                let date = formatter.dateFromString(str)!
                formatter.dateFormat = "MMM dd, yyyy at HH:MM a"
                str = formatter.stringFromDate(date)
                cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
                cell.detailTextLabel?.text = "on \(str)"
                return cell
            }
            
            
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("cell2") as! prerequisitescell2
            cell.fileuploaded.hidden = true
            cell.uploadbutton.hidden = true
            cell.uploadanewfile.hidden = true
            cell.assignedto.hidden = false
            cell.editbutton.hidden = false
            cell.editbutton.addTarget(self, action: #selector(edited), forControlEvents: UIControlEvents.TouchUpInside)
            
            cell.assignedto.hidden = false
            if let assignedto = currentarr["PersonAssigned"] as? String{
                _ = assignedto
                if(assignedto == ""){
                    cell.assignedto.text = "Assigned to None"
                }else{
                    cell.assignedto.text = String(format:"Assigned to %@",assignedto)
                }
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            }else{
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.assignedto.text = "Assigned to None"
            }
            return cell

        }else{
            
            if((currentarr["CreditDescription"] as! String).lowercaseString == "waste"){
                let identifier = "wastecell"
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! wastecell
                //v.addBarchartAnimation()
                return cell
                
            }else{
         
            let cell = tableview.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! customcellwithgraph
                
            var temp = [Int]()
                var dict = self.meters.objectAtIndex(indexPath.section-1) as! [String:AnyObject]
                print("dict is is ",dict["id"] as! Int)
            cell.backgroundColor = UIColor.clearColor()
            cell.contentView.backgroundColor = UIColor.clearColor()
            
            var tempdict = graphPoints.objectAtIndex(indexPath.section-1) as! [String:AnyObject]
            temp = samplegraphdata
            temp = readingsarr.objectAtIndex(indexPath.section-1) as! [Int]
            temp = readingsdict["\(dict["id"] as! Int)"] as! [Int]
           let view = GraphView()
            cell.graphviews.hidden = true
            view.frame = cell.contentView.frame
                if(temp.count == 0){
                    temp  = [0,0,0,0,0]
                }
            view.graphPoints = temp
            var label = UILabel()
            label.text = "asda"
            label.frame = cell.heading.frame
            label = cell.heading
            label.adjustsFontSizeToFitWidth = true
            view.addSubview(label)
            var datelabel = UILabel()
            datelabel = cell.v1
            datelabel.adjustsFontSizeToFitWidth = true
            datelabel.center = CGPointMake(cell.contentView.center.x, 0.9 * cell.contentView.frame.size.height)
                if(self.meterdates.count>0){
                    let dateFormatter = NSDateFormatter()
                    
                    //ateFormatter.dateFormat = "d MMM yyyy"
                    print("starting dates after array",self.datesdict)
                    if(datesdict.count > 0){
                        
                        print("ENding dates after array",self.enddatearr)
                        print(temp)
                        var dict = datesdict["\(dict["id"] as! Int)"] as! [String:AnyObject]
                        dateFormatter.dateFormat = "dd MMM yyyy"
                        var startdate = ""
                        var enddate = ""
                        datelabel.text = "Not available"
                        if(dict["start_date"] != nil){
                            let date1 =  dict["start_date"] as! NSDate
                            startdate = dateFormatter.stringFromDate(date1)
                        }
                        if(dict["end_date"] != nil){
                            let date2 =  dict["end_date"] as! NSDate
                            enddate = dateFormatter.stringFromDate(date2)
                        }
                        if(startdate != "" && enddate != ""){
                        datelabel.text = String(format: "%@ to %@", startdate, enddate)
                        }else{
                        datelabel.text = "Not available"
                        }
                    }else{
                    print("ENding dates after array",self.enddatearr)
                    print(temp)
                    var dict = meterdates.objectAtIndex(indexPath.section-1) as! [String:AnyObject]
                    dateFormatter.dateFormat = "dd MMM yyyy"
                    var startdate = ""
                    var enddate = ""
                    datelabel.text = "Not available"
                    if(dict["start_date"] != nil){
                        let date1 =  dict["start_date"] as! NSDate
                    startdate = dateFormatter.stringFromDate(date1)
                    }
                    if(dict["end_date"] != nil){
                        let date2 =  dict["end_date"] as! NSDate
                    enddate = dateFormatter.stringFromDate(date2)
                    }
                    datelabel.text = String(format: "%@ to %@", startdate, enddate)
                    print(startdate,enddate)
                    }
                    
                }else{
                    label.text = ""
                }
            view.addSubview(datelabel)
            var startscore = UILabel()
            startscore = cell.startscore
            startscore.adjustsFontSizeToFitWidth = true
            //startscore.frame.origin.x = 0.94 * cell.contentView.frame.size.width
            view.addSubview(startscore)
                var maxscore = UILabel()
                maxscore = cell.maxscore
                //maxscore.frame.origin.x = startscore.frame.origin.x
                if(temp.count>0){
                    maxscore.text = String(format:"%d",temp.maxElement()!)
                }else{
                    maxscore.text = "0"
                }
                view.addSubview(maxscore)
            if(currentarr["CreditDescription"] as! String == "Energy"){
                 cell.heading.text = String(format:"Meter %d", indexPath.section)
             view.startColor = UIColor.init(red: 0.860, green: 0.871, blue: 0.734, alpha: 1)
                view.endColor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
                cell.startColor = UIColor.init(red: 0.860, green: 0.871, blue: 0.734, alpha: 1)
                cell.endColor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
               
            }else if(currentarr["CreditDescription"] as! String == "Water"){
                cell.heading.text = String(format:"Meter %d", indexPath.section)
                view.startColor = UIColor.init(red: 0.801, green: 0.948, blue: 0.952, alpha: 1)
                view.endColor = UIColor.init(red: 0.303, green: 0.751, blue: 0.94, alpha: 1)
                
                
            }else if(currentarr["CreditDescription"] as! String == "Waste"){
                
                view.startColor = UIColor.init(red: 0.461, green: 0.76, blue: 0.629, alpha: 1)
                view.endColor = UIColor.init(red: 0.691, green: 0.789, blue: 0.762, alpha: 1)
                
            }else if(currentarr["CreditDescription"] as! String == "Transportation"){
                
                view.startColor = UIColor.init(red: 0.572, green: 0.556, blue: 0.505, alpha: 1)
                view.endColor = UIColor.init(red: 0.876, green: 0.858, blue: 0.803, alpha: 1)
                
            }else if(currentarr["CreditDescription"] as! String == "Human Experience"){
                view.startColor = UIColor.init(red: 0.92, green: 0.609, blue: 0.236, alpha: 1)
                view.endColor = UIColor.init(red: 0.901, green: 0.867, blue: 0.603, alpha: 1)
                
            }
            cell.heading.text =  tempdict["name"] as? String
            cell.heading.adjustsFontSizeToFitWidth = true
            cell.contentView.addSubview(view)
            return cell
        }
        
        }
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("feedcell")!
        tableView.frame.origin.y = tableview.frame.origin.y + tableview.frame.size.height
        var dict = currentfeeds.objectAtIndex(indexPath.row) as! [String:AnyObject]
        cell.textLabel?.text = dict["verb"] as? String
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        var str = dict["timestamp"] as! String
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        let date = formatter.dateFromString(str)!
        formatter.dateFormat = "MMM dd, yyyy at HH:MM a"
        str = formatter.stringFromDate(date)
        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
        cell.detailTextLabel?.text = "on \(str)"
        return cell
        
    }
    
    func deleted(){
        print("deleted")
    }
    
    
    func edited(){
        print("edited")
        dispatch_async(dispatch_get_main_queue(), {
            self.assignokbtn.enabled = false
            self.statusupdate = 0
            self.spinner.hidden = false
            //self.view.userInteractionEnabled = false
            self.pleasekindly.text = "Please kindly the team member to assign this action"
            self.assignokbtn.setTitle("Assign", forState: UIControlState.Normal)
            self.getteammembers(credentials().subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"))
        })
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

    
    func uploaded(){
        print("uploaded")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tableview.reloadData()
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let height = UIScreen.mainScreen().bounds.size.height
        if(tableView == feedstable){
            return 70
        }
        if indexPath.section == 0 {
            return 0.06 * height
        }
        if(indexPath.section == meters.count + 1){
            return 0.07 * height
        }
        else if (indexPath.section == graphPoints.count+1){
            if((currentarr["CreditDescription"] as! String).lowercaseString == "waste"){
                return 0.42 * height
            }
            return 40
        }
        
        return 0.42 * height
    }
    @IBAction func affirmationview2close(sender: AnyObject) {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            ////self.tableview.frame = self.actualtableframe
            //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
            self.affirmationview2.hidden = true
            }, completion: { (finished: Bool) -> Void in
                
                // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
                
        })
    }
    
    @IBAction func previous(sender: AnyObject) {
        if(currentindex>0){
            /*if(task.currentRequest != nil){
             if (task.state == NSURLSessionTaskState.Running) {
             task.cancel()
             }
             }*/
            currentindex = currentindex-1
            NSUserDefaults.standardUserDefaults().setInteger(currentindex, forKey: "selected_action")
            currentarr = currentcategory[currentindex] as! [String:AnyObject]
            if(checkcredit_type(currentarr) == "Data input"){
                navigate()
            }else{
                //self.performSegueWithIdentifier("prerequisites", sender: nil)
                let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                let listofactions = mainstoryboard.instantiateViewControllerWithIdentifier("listofactions")
                let datainput = mainstoryboard.instantiateViewControllerWithIdentifier("prerequisites")
                let rootViewController = self.navigationController
                var controllers = (rootViewController!.viewControllers)
                controllers.removeAll()
                var v = UIViewController()
                var grid = 0
                grid = NSUserDefaults.standardUserDefaults().integerForKey("grid")
                if(NSUserDefaults.standardUserDefaults().integerForKey("grid") == 1){
                    v = mainstoryboard.instantiateViewControllerWithIdentifier("grid") as! UINavigationController
                }else{
                    v = mainstoryboard.instantiateViewControllerWithIdentifier("listofassets") as! UINavigationController
                }
                var listofassets = mainstoryboard.instantiateViewControllerWithIdentifier("projectslist")
                if(grid == 1){
                    listofassets = mainstoryboard.instantiateViewControllerWithIdentifier("gridvc")
                }else{
                    listofassets = mainstoryboard.instantiateViewControllerWithIdentifier("projectslist")
                }
                let dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary
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
    
    
    @IBOutlet weak var ivupload2: UISwitch!
    
    @IBOutlet weak var ivattached2: UISwitch!
    
    @IBOutlet weak var ivupload1: UISwitch!
    
    
    
    override func viewWillDisappear(animated: Bool) {
        for request in download_requests
        {
            request.invalidateAndCancel()
        }
        var buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        self.navigationItem.title = buildingdetails["name"] as? String
    }
    
    
    
    func navigate(){        
        for request in download_requests
        {            
            request.invalidateAndCancel()
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.spinner.hidden = true
            //self.view.userInteractionEnabled = true
        })
        currentarr = currentcategory[currentindex] as! [String:AnyObject]
        category.text = checkcredit_type(currentarr)
        self.actiontitle.text = currentarr["CreditDescription"] as? String
        self.creditstatus.text = String(format: "%@ v",(currentarr["CreditStatus"] as? String)!)
        if(self.creditstatus.text == ""){
            self.creditstatus.text = "Not available"
        }
        self.affirmationsclick(self.activityfeedbutton)
        if(self.creditstatus.text == ""){
            self.creditstatus.text = "Not available"
        }else{
            if let creditstatus = currentarr["CreditStatus"] as? String{
                self.creditstatus.text = String(format: "%@",creditstatus.capitalizedString)
                if(creditstatus == "Ready for Review"){
                    creditstatusimg.image = UIImage.init(named: "tick")
                }else{
                    creditstatusimg.image = UIImage.init(named: "circle")
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
            if((currentarr["CreditDescription"] as! String).lowercaseString == "energy"){
                shortcredit.image = UIImage.init(named: "energy-border")
            }else if((currentarr["CreditDescription"] as! String).lowercaseString == "water"){
                shortcredit.image = UIImage.init(named: "water-border")
            }else if((currentarr["CreditDescription"] as! String).lowercaseString == "waste"){
                shortcredit.image = UIImage.init(named: "waste-border")
            }
            else if((currentarr["CreditDescription"] as! String).lowercaseString == "transportation"){
                shortcredit.image = UIImage.init(named: "transport-border")
            }else{
                    shortcredit.image = UIImage.init(named: "human-border")                
            }
        }
        let c = credentials()
        domain_url = c.domain_url
        _ = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary
        data.removeAll()
        data2.removeAll()
        self.startdatearr.removeAllObjects()
        self.enddatearr.removeAllObjects()
        meters.removeAllObjects()
        currentmetersdict.removeAll()
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
        
        if((currentarr["CreditDescription"] as! String).lowercaseString == "water" || (currentarr["CreditDescription"] as! String).lowercaseString == "energy"){
            dispatch_async(dispatch_get_main_queue(), {
                self.spinner.hidden = false
                //self.view.userInteractionEnabled = false
                self.tableview.hidden = true
                //self.feedstable.hidden = true
              self.getmeters(c.subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), kind: self.actiontitle.text!.lowercaseString)
            })
        }else if((currentarr["CreditDescription"] as! String).lowercaseString == "waste"){
            self.performSegueWithIdentifier("gotowaste", sender: nil)
        }
    }
    
    
    
    func getallwastedata(subscription_key:String, leedid: Int){
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/waste/",domain_url, leedid))
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
                if((error?.description.containsString("cancelled")) != nil){
                    if(error?.code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    print("error=\(error?.description)")
                    print("response",response)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableview.hidden = false
                        self.spinner.hidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
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
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                print(data)
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print("Meters are",jsonDictionary)
                    //self.graphPoints = jsonDictionary["results"] as! NSArray
                    self.currentmetersdict  = jsonDictionary as! [String:AnyObject]
                    self.meters = jsonDictionary["results"]?.mutableCopy() as! NSMutableArray
                    self.graphPoints = self.meters
                    for i in 0...self.meters.count-1{
                        var item = self.meters.objectAtIndex(i) as! [String:AnyObject]
                        var f1 = 0.0234234
                        var f2 = 0.0
                        f1 = item["waste_diverted"] as! Double
                        f2 = item["waste_generated"] as! Double
                        self.data.append(Int(f1))
                        self.data2.append(Int(f2))
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        var tempdict = [String:AnyObject]()
                        print("starting dates before array",item["start_date"])
                        print("ENding dates before array",item["end_date"])
                        var date = dateFormatter.dateFromString(item["start_date"] as! String)! 
                        tempdict["start_date"] = date
                        date = dateFormatter.dateFromString(item["end_date"] as! String)! 
                        tempdict["end_date"] = date
                        self.startdatearr.addObject(tempdict)
                        self.enddatearr.addObject(tempdict)
                        
                        var  sortDescriptor = NSSortDescriptor.init(key: "start_date", ascending: true)
                        self.startdatearr.sortUsingDescriptors(NSArray.init(object: sortDescriptor) as! [NSSortDescriptor])
                        sortDescriptor = NSSortDescriptor.init(key: "end_date", ascending: true)
                        self.enddatearr.sortUsingDescriptors(NSArray.init(object: sortDescriptor) as! [NSSortDescriptor])
                    }
                    var tempdict = [String:AnyObject]()
                    if(self.startdatearr.count > 0){
                        tempdict["start_date"] = self.startdatearr.firstObject!["start_date"] as! NSDate
                    }
                    if(self.enddatearr.count > 0){
                        tempdict["end_date"] = self.enddatearr.lastObject!["end_date"] as! NSDate
                    }
                    
                    self.meterdates.addObject(tempdict)
                    self.startdatearr.removeAllObjects()
                    self.enddatearr.removeAllObjects()
                    
                    print(self.startdatearr.firstObject,self.enddatearr.lastObject)
                    NSUserDefaults.standardUserDefaults().setObject(self.data, forKey: "data")
                    NSUserDefaults.standardUserDefaults().setObject(self.data2, forKey: "data2")
                        dispatch_async(dispatch_get_main_queue(),
                        {
                            
                            //self.view.userInteractionEnabled = true
                            
                    })
                    
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
    
    
    func reloadtable(){
        self.tableview.reloadData()
    }
    
    @IBAction func next(sender: AnyObject) {
        if(currentindex<currentcategory.count-1){
            /*if(task.currentRequest != nil){
             if (task.state == NSURLSessionTaskState.Running) {
             task.cancel()
             }
             }*/
            currentindex = currentindex+1
            NSUserDefaults.standardUserDefaults().setInteger(currentindex, forKey: "selected_action")
            currentarr = currentcategory[currentindex] as! [String:AnyObject]
            if(checkcredit_type(currentarr) == "Data input"){
                navigate()
            }else{
                self.performSegueWithIdentifier("prerequisites", sender: nil)
            }
        }
    }
    
    
    @IBAction func affirmationview1close(sender: AnyObject) {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            ////self.tableview.frame = self.actualtableframe
            //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
            self.affirmationview1.hidden = true
            }, completion: { (finished: Bool) -> Void in
                
                // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
                
        })
    }
    
    
    
    
    @IBOutlet weak var activityfeedbutton: UIButton!
    @IBOutlet weak var tabbar: UITabBar!
    @IBAction func affirmationsclick(sender: AnyObject) {
        
        if(self.actiontitle.text!.containsString("Policy")){
            self.affirmationview1.hidden = true
            self.affirmationview2.hidden = false
            
            self.affirmationview2.hidden = false
            self.affirmationview2.transform = CGAffineTransformMakeScale(1, 1);
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
            self.affirmationview1.hidden = false
            self.affirmationview2.hidden = true
            self.affirmationview1.hidden = false
            self.affirmationview1.transform = CGAffineTransformMakeScale(1, 1);
           //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  self.tableview.layer.frame.size.height)
            print("Tableview height",self.tableview.frame.size.height)
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
    
    func getmeters(subscription_key:String, leedid: Int, kind: String){
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/meters/?kind=%@",domain_url, leedid,kind))
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
                if((error?.description.containsString("cancelled")) != nil){
                    if(error?.code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                print("error=\(error?.description)")
                print("response",response)
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableview.hidden = false
                    self.spinner.hidden = true
                    //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                    //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                }
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
                    self.tableview.hidden = false
                    //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                    //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                print(data)
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print("Meters are",jsonDictionary)
                    //self.graphPoints = jsonDictionary["results"] as! NSArray
                    self.currentmetersdict  = jsonDictionary as! [String:AnyObject]
                    self.meters = jsonDictionary["results"]?.mutableCopy() as! NSMutableArray
                    self.graphPoints = self.meters
                    if(self.meters.count == 0){
                    //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                    }else{
                    //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width, self.tableview.layer.frame.size.height)
                        //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                    }
                    dispatch_async(dispatch_get_main_queue(),{
                    //self.getmeterdata()
                        self.getmeterreadings()
                        })
                    
                    // self.buildingactions(subscription_key, leedid: leedid)
                    
                } catch {
                    print(error)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableview.hidden = false
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
            }
            
        }
        task.resume()
    }
    
    func getcreditformsuploadsdata(subscription_key:String, leedid: Int, actionID: String){
        
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@/uploads/",domain_url, leedid, actionID))
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
                if((error?.description.containsString("cancelled")) != nil){
                    if(error?.code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    print("error=\(error?.description)")
                    print("response",response)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableview.hidden = false
                        self.spinner.hidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
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
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                print(data)
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    self.uploadsdata = jsonDictionary["EtFile"] as! NSArray
                    print(jsonDictionary)
                    dispatch_async(dispatch_get_main_queue(), {
                    self.spinner.hidden = true
                        //self.view.userInteractionEnabled = true
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
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
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

    func loadMoreDataFromServer(URL: String, subscription_key:String){
        let url = NSURL.init(string:URL)
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.description.containsString("cancelled")) != nil){
                    if(error?.code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    print("error=\(error?.description)")
                    print("response",response)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableview.hidden = false
                        self.spinner.hidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
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
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                print(data)
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print("Meters are",jsonDictionary)
                    //self.graphPoints = jsonDictionary["results"] as! NSArray
                    self.currentmetersdict  = jsonDictionary as! [String:AnyObject]
                    var temparr = NSMutableArray()
                    let tempmeters = NSMutableArray()
                    temparr = jsonDictionary["results"]?.mutableCopy() as! NSMutableArray
                    
                    for i in 0..<self.meters.count {
                        tempmeters.addObject(self.meters.objectAtIndex(i))
                    }
                    
                    for i in 0..<temparr.count {
                        tempmeters.addObject(temparr.objectAtIndex(i))
                    }
                    self.meters = tempmeters
                    
                    
                    self.graphPoints = self.meters
                    dispatch_async(dispatch_get_main_queue(), {
                        self.spinner.hidden = true
                        //self.view.userInteractionEnabled = true
                        self.tableview.reloadData()
                    })
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
    
    
    func getmeterreadings(){//(subscription_key:String, leedid: Int, actionID: Int){
        if(meters.count == 0){
            self.maketoast("No meters found",type: "error")
            self.spinner.hidden = true
        }
        
        for (index,item) in meters.enumerate()
        {
            
            let subscription_key = credentials().subscription_key
            let leedid = NSUserDefaults.standardUserDefaults().integerForKey("leed_id")
            let actionID = item["id"] as! Int
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/meters/ID:%d/consumption/",domain_url, leedid, actionID))
        print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
       let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.description.containsString("cancelled")) != nil){
                    if(error?.code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    print("error=\(error?.description)")
                    print("response",response)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableview.hidden = false
                        self.spinner.hidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  150)
                        //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
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
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                print(data)
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print("Meter readings ",jsonDictionary)
                    let arr = jsonDictionary["results"] as! NSArray
                    print(arr,index)
                    self.arrayofreadings["\(actionID)"] = arr
                    self.entirereadingsarr.addObject(arr)
                    for i in 0..<arr.count {
                        var dict = arr.objectAtIndex(i) as! [String:AnyObject]
                        self.tempgraphdata.append(Int(dict["reading"]as! Float))
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            var tempdict = [String:AnyObject]()
                        print("starting dates before array",dict["start_date"])
                        print("ENding dates before array",dict["end_date"])
                            var date = dateFormatter.dateFromString(dict["start_date"] as! String)! 
                            tempdict["start_date"] = date
                            date = dateFormatter.dateFromString(dict["end_date"] as! String)! 
                            tempdict["end_date"] = date
                            self.startdatearr.addObject(tempdict)
                            self.enddatearr.addObject(tempdict)
                            var sortDescriptor = NSSortDescriptor.init(key: "start_date", ascending: true)
                            self.startdatearr.sortUsingDescriptors(NSArray.init(object: sortDescriptor) as! [NSSortDescriptor])
                            sortDescriptor = NSSortDescriptor.init(key: "end_date", ascending: true)
                            self.enddatearr.sortUsingDescriptors(NSArray.init(object: sortDescriptor) as! [NSSortDescriptor])
                    }
                    var tempdict = [String:AnyObject]()
                    if(self.startdatearr.count > 0){
                    tempdict["start_date"] = self.startdatearr.firstObject!["start_date"] as! NSDate
                    }
                    if(self.enddatearr.count > 0){
                    tempdict["end_date"] = self.enddatearr.lastObject!["end_date"] as! NSDate
                    }
                    self.meterdates.addObject(tempdict)
                    self.startdatearr.removeAllObjects()
                    self.enddatearr.removeAllObjects()
                    self.datesdict["\(actionID)"] = tempdict
                    self.readingsdict["\(actionID)"] = self.tempgraphdata
                    self.readingsarr.addObject(self.tempgraphdata)
                    self.tempgraphdata.removeAll()
                    print("Actual reading is",self.readingsarr)
                    if(self.readingsarr.count == self.meters.count){
                        dispatch_async(dispatch_get_main_queue(), {
                            //self.view.userInteractionEnabled = true
                            self.showactivityfeed(NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), creditID: self.currentarr["CreditId"] as! String, shortcreditID: self.currentarr["CreditShortId"] as! String)
                        })
                    }
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
    }

    func getmeterdata() {
        
        for i in 0..<self.meters.count {
            _ = credentials()
            var tempdict = meters.objectAtIndex(i) as! [String:AnyObject]
            if(self.meters.count == 1){
                self.id = tempdict["id"] as! Int
                //self.getmeterreadings(c.subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), actionID: tempdict["id"] as! Int)
            }else{
                dispatch_after(
                    dispatch_time(
                        DISPATCH_TIME_NOW,
                        Int64(1.5 * Double(NSEC_PER_SEC))
                    ),
                    dispatch_get_main_queue(),
                    {
                        self.id = tempdict["id"] as! Int
                       // self.getmeterreadings(c.subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), actionID: tempdict["id"] as! Int)
                    }
                )
            }
                // go to something on the main thread with the image like setting to UIImageView
        }
        
        
        if(self.meters.count == 0){
            dispatch_async(dispatch_get_main_queue(), {
                self.spinner.hidden = true
            })
        }
        
        
    }
    @IBOutlet weak var backbtn: UIButton!
    
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.section > 0){            
        if(indexPath.section == meters.count+1){
            
        }else{
        var dict = self.meters.objectAtIndex(indexPath.section-1) as! [String:AnyObject]
        print(selectedreading)
        id = dict["id"] as! Int
        selectedreading = self.arrayofreadings["\(id)"] as! NSArray

            print("dict is selected ",dict["id"] as! Int, selectedreading)
          //  tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("gotoreadings", sender: nil)
        }
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /*if(segue.identifier == "gotoreadings"){
        NSUserDefaults.standardUserDefaults().setInteger(id, forKey: "meterID")
        NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(selectedreading), forKey: "selreading")
        }*/
        if(segue.identifier == "gotoreadings"){
            let vc = segue.destinationViewController as! UINavigationController
            let addEventViewController = vc.topViewController as! listall
            addEventViewController.dataarr = selectedreading.mutableCopy() as! NSMutableArray
            addEventViewController.id = id
        }
        
    }
    
    
    func affirmationupdate(actionID:String, leedid: Int, subscription_key:String){
        //
        var url = NSURL()
        let s = String(format:"%d",leedid)
        if(actionID.containsString(s)){
            url = NSURL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@/",domain_url, leedid, actionID))!
        }
        else{
            url = NSURL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@-%d/",domain_url, leedid, actionID,leedid))!
        }
        print(url.absoluteString)
        
        let request = NSMutableURLRequest.init(URL: url)
        request.HTTPMethod = "PUT"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var httpbody = String()
        if(self.actiontitle.text!.containsString("Policy")){
            httpbody = String(format: "{\"IvAttchPolicy\": %@, \"IvReqFileupload\": %@}",self.ivattached2.on,ivupload2.on)
        }else{
            httpbody = String(format: "{\"IvAttchPolicy\": %@, \"IvReqFileupload\": %@}",self.ivattached2.on,ivupload1.on)
        }
        request.HTTPBody = httpbody.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.description.containsString("cancelled")) != nil){
                    if(error?.code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    print("error=\(error?.description)")
                    print("response",response)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableview.hidden = false
                        self.spinner.hidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401 {           // check for http errors
                dispatch_async(dispatch_get_main_queue(), {
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                })
            }else
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 && httpStatus.statusCode != 201 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                print(data)
                var jsonDictionary : NSDictionary
                do {
                    if(self.actiontitle.text!.containsString("Policy")){
                        if(self.ivattached2.on == true){
                            self.currentarr["IvAttchPolicy"] = "X"
                        }else{
                            self.currentarr["IvAttchPolicy"] = ""
                        }
                        
                        if(self.ivupload2.on == true){
                            self.currentarr["IvReqFileupload"] = "X"
                        }else{
                            self.currentarr["IvReqFileupload"] = ""
                        }
                    }else{
                        if(self.ivattached2.on == true){
                            self.currentarr["IvAttchPolicy"] = "X"
                        }else{
                            self.currentarr["IvAttchPolicy"] = ""
                        }
                        
                        if(self.ivupload1.on == true){
                            self.currentarr["IvReqFileupload"] = "X"
                        }else{
                            self.currentarr["IvReqFileupload"] = ""
                        }
                    }

                    self.currentcategory.replaceObjectAtIndex(NSUserDefaults.standardUserDefaults().integerForKey("selected_action"), withObject: self.currentarr)                    
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                    self.updatebuildingactions(subscription_key, leedid: leedid)
                    //self.tableview.reloadData()
                    //
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

    
    

    
    
    
    @IBAction func assignclose(sender: AnyObject) {
        self.assigncontainer.hidden = true
    }
    
    func assignnewmember(subscription_key:String, leedid: Int, actionID: String, email:String,firstname: String, lastname:String){
        //https://api.usgbc.org/dev/leed/assets/LEED:{leed_id}/actions/ID:{action_id}/teams/
        var url = NSURL()
        let s = String(format:"%d",leedid)
        if(actionID.containsString(s)){
                url = NSURL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@/teams/",domain_url, leedid, actionID))!
        }
        else{
            url = NSURL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@-%d/teams/",domain_url, leedid, actionID,leedid))!
        }
        
        let request = NSMutableURLRequest.init(URL: url)
        request.HTTPMethod = "POST"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let httpbody = String(format: "{\"emails\":\"%@\"}",email)
        request.HTTPBody = httpbody.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.description.containsString("cancelled")) != nil){
                    if(error?.code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    print("error=\(error?.description)")
                    print("response",response)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableview.hidden = false
                        self.spinner.hidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
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
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                print(data)
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.currentarr["PersonAssigned"] = String(format: "%@ %@",firstname,lastname)
                        self.assigncontainer.hidden = true
                        self.spinner.hidden = true
                        //self.view.userInteractionEnabled = true
                       self.buildingactions(subscription_key, leedid: leedid)
                        
                    })
                    //self.tableview.reloadData()
                    //
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
                if((error?.description.containsString("cancelled")) != nil){
                    if(error?.code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    print("error=\(error?.description)")
                    print("response",response)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableview.hidden = false
                        self.spinner.hidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
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
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                print(data)
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                    dispatch_async(dispatch_get_main_queue(), {
                        let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                        NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "actions_data")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        self.spinner.hidden = true
                        //self.view.userInteractionEnabled = true
                        self.tableview.reloadData()
                        self.maketoast("Updated successfully",type: "message")
                        
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

    
    @IBAction func okassignthemember(sender: AnyObject) {
        if(statusupdate == 1){
            //self.view.userInteractionEnabled = false
            self.spinner.hidden = false
            savestatusupdate(currentarr["CreditId"] as! String, subscription_key: credentials().subscription_key)
            
        }else{
            //self.view.userInteractionEnabled = false
            self.spinner.hidden = false
            assignnewmember(credentials().subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), actionID: currentarr["CreditId"] as! String, email:teammembers[picker.selectedRowInComponent(0)]["Useralias"] as! String,firstname:teammembers[picker.selectedRowInComponent(0)]["Firstname"] as! String,lastname: teammembers[picker.selectedRowInComponent(0)]["Lastname"] as! String)
        }


    }
    
    @IBAction func closetheassigncontainer(sender: AnyObject) {
         self.assigncontainer.hidden = true
    }
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return teammembers.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(statusupdate == 1){
            return teammembers[row] as? String
        }
        return teammembers[row]["Useralias"] as? String
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        assignokbtn.enabled = true
    }
    

    func getteammembers(subscription_key:String, leedid:Int){
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/teams/",domain_url, leedid))
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
                if((error?.description.containsString("cancelled")) != nil){
                    if(error?.code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    print("error=\(error?.description)")
                    print("response",response)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableview.hidden = false
                        self.spinner.hidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
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
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                print(data)
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                    let team_membersarray = jsonDictionary["EtTeamMembers"] as! NSArray
                    self.teammembers = team_membersarray
                    dispatch_async(dispatch_get_main_queue(), {
                        self.assigncontainer.hidden = false
                        self.spinner.hidden = true
                        //self.view.userInteractionEnabled = true
                        self.picker.reloadAllComponents()
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
    
   
    
    
    
    func updatebuildingactions(subscription_key:String, leedid: Int){
        let url = NSURL.init(string: String(format: "%@assets/LEED:%d/actions/",domain_url,leedid))
        print(url?.absoluteURL)
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.description.containsString("cancelled")) != nil){
                    if(error?.code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    print("error=\(error?.description)")
                    print("response",response)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableview.hidden = false
                        self.spinner.hidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
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
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                print(data)
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                    let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                    NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "actions_data")
                    //self.view.userInteractionEnabled = true
                    NSUserDefaults.standardUserDefaults().synchronize()
                    NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "row")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.spinner.hidden = true
                        //self.view.userInteractionEnabled = true
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

    
    func valuechanged(sender:UISwitch){
        if(sender.tag == 101 || sender.tag == 102 || sender.tag == 103){
        dispatch_async(dispatch_get_main_queue(), {
            self.spinner.hidden = false
            //self.view.userInteractionEnabled = false
        })
        affirmationupdate(currentarr["CreditId"] as! String, leedid: leedid, subscription_key: credentials().subscription_key)
        }
    }

    @IBAction func addnewmeter(sender: AnyObject) {
        self.performSegueWithIdentifier("gotoaddmeter", sender: nil)
    }
    
    func savestatusupdate(actionID:String, subscription_key:String){
        //
        var url = NSURL()
        let s = String(format:"%d",leedid)
        if(actionID.containsString(s)){
            url = NSURL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@/",domain_url, leedid, actionID))!
        }
        else{
            url = NSURL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@-%d/",domain_url, leedid, actionID,leedid))!
        }
        print(url.absoluteString)
        
        let request = NSMutableURLRequest.init(URL: url)
        request.HTTPMethod = "PUT"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var httpbody = String()
        let string = self.statusarr[self.picker.selectedRowInComponent(0)] as! String
        if(string == "Ready for review"){
            httpbody = String(format: "{\"is_readyForReview\": %@}",true)
        }else{
            httpbody = String(format: "{\"is_readyForReview\": %@}",false)
        }
        request.HTTPBody = httpbody.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.description.containsString("cancelled")) != nil){
                    if(error?.code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    print("error=\(error?.description)")
                    print("response",response)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableview.hidden = false
                        self.spinner.hidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        //self.feedstable.frame.origin.y = self.tableview.frame.origin.y + self.tableview.frame.size.height
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401 {           // check for http errors
                dispatch_async(dispatch_get_main_queue(), {
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                })
            } else
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 && httpStatus.statusCode != 201 {           // check for http errors
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
                        self.creditstatus.text = string
                        self.currentarr["CreditStatus"] = string
                        self.currentcategory.replaceObjectAtIndex(NSUserDefaults.standardUserDefaults().integerForKey("selected_action"), withObject: self.currentarr)
                        self.buildingactions(subscription_key, leedid: self.leedid)
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
}
