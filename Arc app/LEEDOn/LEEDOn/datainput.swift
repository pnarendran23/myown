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
    @IBOutlet weak var actiontitle: UILabel!
    var selectedreading = NSArray()
    var uploadsdata = NSArray()
    var id = 0
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
    override func viewDidLoad() {
        self.view.userInteractionEnabled = false
        super.viewDidLoad()
        self.spinner.layer.cornerRadius = 5
        self.spinner.hidden = true
        self.view.userInteractionEnabled = true
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.assigncontainer.backgroundColor = UIColor.clearColor()
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
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
        currentcategory = NSKeyedUnarchiver.unarchiveObjectWithData(datakeyed) as! NSMutableArray
        currentindex = NSUserDefaults.standardUserDefaults().integerForKey("selected_action")
        NSUserDefaults.standardUserDefaults().synchronize()
        print("aarra", currentcategory)
        currentarr = currentcategory[currentindex] as! [String:AnyObject]
        category.text = checkcredit_type(currentarr)
        self.actiontitle.text = currentarr["CreditDescription"] as? String
        self.creditstatus.text = currentarr["CreditStatus"] as? String
        if(self.creditstatus.text == ""){
            self.creditstatus.text = "Not available"
        }
        let c = credentials()
        domain_url = c.domain_url
        let dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary
        assetname.text = dict["name"] as? String
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
        var tap = UITapGestureRecognizer.init(target: self, action: #selector(datainput.statusupdate(_:)))
        self.creditstatus.userInteractionEnabled = true
        self.creditstatus.addGestureRecognizer(tap)
        navigate()
        // Do any additional setup after loading the view.
    }
    
    func statusupdate(sender:UILabel){
            self.teammembers = statusarr
            dispatch_async(dispatch_get_main_queue(), {
                self.assigncontainer.hidden = false
                self.spinner.hidden = true
                self.statusupdate = 1
                self.view.userInteractionEnabled = true
                self.pleasekindly.text = "Please kindly select the below status for the action"
                self.assignokbtn.setTitle("Save", forState: UIControlState.Normal)
                self.picker.reloadAllComponents()
            })
    }
    
    func refresh(){
        tableview.reloadData()
    }
    
    func checkcredit_type(tempdict:[String:AnyObject]) -> String {
        var temp = ""
        if(tempdict["CreditcategoryDescrption"] as! String == "Performance" || tempdict["CreditcategoryDescrption"] as! String == "Performance Category"){
            temp = "Data input"
        }
        else if((tempdict["Mandatory"] as! String != "X") && (tempdict["CreditcategoryDescrption"] as! String != "Performance" || tempdict["CreditcategoryDescrption"] as! String != "Performance Category")){
            temp = "Base scores"
        }else if(tempdict["Mandatory"] as! String == "X"){
            temp = "Pre-requisites"
        }
        
        return temp
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if((currentarr["CreditDescription"] as! String).lowercaseString == "waste"){
         return 2
        }
        return meters.count+1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "    Assigned user"
        }
        else if (section == 1){
            if(graphPoints.count > 0 ){
                return "    Meters"
            }
        }
        
        return ""
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
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
            
            
            var tempdict = graphPoints.objectAtIndex(indexPath.section-1) as! [String:AnyObject]
            temp = samplegraphdata
            temp = readingsarr.objectAtIndex(indexPath.section-1) as! [Int]
           let view = GraphView()
            view.frame = cell.graphviews.frame
                if(temp.count == 0){
                    temp  = [0,0,0,0,0]
                }
            view.graphPoints = temp
            var label = UILabel()
            label.text = "asda"
            label.frame = cell.heading.frame
            label = cell.heading
            view.addSubview(label)
            label = cell.v1
                if(self.startdatearr.count>0 && self.enddatearr.count>0){
                    let dateFormatter = NSDateFormatter()
                    
                    dateFormatter.dateFormat = "d MMM yyyy"
                    let str = dateFormatter.stringFromDate(self.startdatearr.firstObject!["start_date"] as! NSDate)
                    let str1 = dateFormatter.stringFromDate(self.enddatearr.lastObject!["end_date"] as! NSDate)
                    print(str,str1)
                    print(self.startdatearr.firstObject,self.enddatearr.lastObject)
                    label.text = String(format: "%@ to %@", str, str1)
                }else{
                    label.text = ""
                }
            view.addSubview(label)
            /*label = cell.v2
            view.addSubview(label)
            label = cell.v3
            view.addSubview(label)
            label = cell.v4
            view.addSubview(label)
            label = cell.v5
            view.addSubview(label)
            label = cell.v6
            view.addSubview(label)
            label = cell.v7
            view.addSubview(label)*/
            label = cell.startscore
            view.addSubview(label)
            label = cell.maxscore
                if(temp.count>0){
            label.text = String(format:"%d",temp.maxElement()!)
                }else{
            label.text = "0"        
                }
            view.addSubview(label)
                
            
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
            cell.contentView.addSubview(view)
            return cell
        }
        
        }
        
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
            self.view.userInteractionEnabled = false
            self.pleasekindly.text = "Please kindly the team member to assign this action"
            self.assignokbtn.setTitle("Assign", forState: UIControlState.Normal)
            self.getteammembers(credentials().subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"))
        })
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

    
    func uploaded(){
        print("uploaded")
    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        }
        else if (indexPath.section == graphPoints.count+1){
            if((currentarr["CreditDescription"] as! String).lowercaseString == "waste"){
                return 185
            }
            return 40
        }
        
        return 185
    }
    @IBAction func affirmationview2close(sender: AnyObject) {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            self.tableview.frame = self.actualtableframe
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
                self.performSegueWithIdentifier("prerequisites", sender: nil)
            }
        }
    }
    
    
    @IBOutlet weak var ivupload2: UISwitch!
    
    @IBOutlet weak var ivattached2: UISwitch!
    
    @IBOutlet weak var ivupload1: UISwitch!
    
    func navigate(){
        dispatch_async(dispatch_get_main_queue(), {
            self.spinner.hidden = true
            self.view.userInteractionEnabled = true
        })
        currentarr = currentcategory[currentindex] as! [String:AnyObject]
        category.text = checkcredit_type(currentarr)
        self.actiontitle.text = currentarr["CreditDescription"] as? String
        self.creditstatus.text = String(format: "%@ v",(currentarr["CreditStatus"] as? String)!)
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
        self.getmeters(c.subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), kind: self.actiontitle.text!.lowercaseString)
            dispatch_async(dispatch_get_main_queue(), {
                self.tableview.reloadData()
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
        self.task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            
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
                        var date = dateFormatter.dateFromString(item["start_date"] as! String)! 
                        tempdict["start_date"] = date
                        self.startdatearr.addObject(tempdict)
                        date = dateFormatter.dateFromString(item["end_date"] as! String)! 
                        tempdict["end_date"] = date
                        self.startdatearr.addObject(tempdict)
                        self.enddatearr.addObject(tempdict)
                        let sortDescriptor = NSSortDescriptor.init(key: "start_date", ascending: true)
                        self.startdatearr.sortUsingDescriptors(NSArray.init(object: sortDescriptor) as! [NSSortDescriptor])
                        //NSSortDescriptor.init(key: "end_date", ascending: true)
                        self.enddatearr.sortUsingDescriptors(NSArray.init(object: sortDescriptor) as! [NSSortDescriptor])
                    }
                    
                    NSUserDefaults.standardUserDefaults().setObject(self.data, forKey: "data")
                    NSUserDefaults.standardUserDefaults().setObject(self.data2, forKey: "data2")
                        dispatch_async(dispatch_get_main_queue(),
                        {
                            self.spinner.hidden = true
                            self.view.userInteractionEnabled = true
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
            self.tableview.frame = self.actualtableframe
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
            self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.1*self.affirmationview2.layer.frame.origin.y+self.affirmationview2.layer.frame.size.height, self.tableview.layer.frame.size.width, fabs(self.view.layer.frame.size.height-(self.activityfeedbutton.layer.frame.size.height+self.tabbar.layer.frame.size.height+(1.1*(self.affirmationview2.layer.frame.origin.y+self.affirmationview2.layer.frame.size.height)))))
            /* UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
             self.affirmationview2.transform = CGAffineTransformMakeScale(1.3, 1.3);
             UIView.animateWithDuration(0.3, delay: 0.3, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
             self.affirmationview2.transform = CGAffineTransformMakeScale(1, 1);
             self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.1*self.affirmationview2.layer.frame.origin.y+self.affirmationview2.layer.frame.size.height, self.tableview.layer.frame.size.width, fabs(self.view.layer.frame.size.height-(self.activityfeedbutton.layer.frame.size.height+self.tabbar.layer.frame.size.height+(1.1*(self.affirmationview2.layer.frame.origin.y+self.affirmationview2.layer.frame.size.height)))))
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
            self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.1*self.affirmationview1.layer.frame.origin.y+self.affirmationview1.layer.frame.size.height, self.tableview.layer.frame.size.width, fabs(self.view.layer.frame.size.height-(self.activityfeedbutton.layer.frame.size.height+self.tabbar.layer.frame.size.height+(1.1*(self.affirmationview1.layer.frame.origin.y+self.affirmationview1.layer.frame.size.height)))))
            /* UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
             self.affirmationview1.transform = CGAffineTransformMakeScale(1.3, 1.3);
             UIView.animateWithDuration(0.3, delay: 0.3, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
             self.affirmationview1.transform = CGAffineTransformMakeScale(1, 1);
             self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.1*self.affirmationview1.layer.frame.origin.y+self.affirmationview1.layer.frame.size.height, self.tableview.layer.frame.size.width, fabs(self.view.layer.frame.size.height-(self.activityfeedbutton.layer.frame.size.height+self.tabbar.layer.frame.size.height+(1.1*(self.affirmationview1.layer.frame.origin.y+self.affirmationview1.layer.frame.size.height)))))
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
        self.task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            
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
                    print("Meters are",jsonDictionary)
                    //self.graphPoints = jsonDictionary["results"] as! NSArray
                    self.currentmetersdict  = jsonDictionary as! [String:AnyObject]
                    self.meters = jsonDictionary["results"]?.mutableCopy() as! NSMutableArray
                    self.graphPoints = self.meters
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    self.getmeterdata()
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
    
    func getcreditformsuploadsdata(subscription_key:String, leedid: Int, actionID: String){
        
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@/uploads/",domain_url, leedid, actionID))
        print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        self.task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            
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
                    self.uploadsdata = jsonDictionary["EtFile"] as! NSArray
                    print(jsonDictionary)
                    dispatch_async(dispatch_get_main_queue(), {
                    self.spinner.hidden = true
                        self.view.userInteractionEnabled = true
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
        self.task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            
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
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    self.meters = tempmeters
                    
                    
                    self.graphPoints = self.meters
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableview.reloadData()
                            self.spinner.hidden = true
                        self.view.userInteractionEnabled = true
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
    
    
    func getmeterreadings(subscription_key:String, leedid: Int, actionID: Int){
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/meters/ID:%d/consumption/",domain_url, leedid, actionID))
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
                    print("Meter readings ",jsonDictionary)
                    let arr = jsonDictionary["results"] as! NSArray
                    print(arr.count)
                    self.entirereadingsarr.addObject(arr)
                    for i in 0..<arr.count {
                        var dict = arr.objectAtIndex(i) as! [String:AnyObject]
                        self.tempgraphdata.append(Int(dict["reading"]as! Float))
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            var tempdict = [String:AnyObject]()
                            var date = dateFormatter.dateFromString(dict["start_date"] as! String)! 
                            tempdict["start_date"] = date
                            self.startdatearr.addObject(tempdict)
                            date = dateFormatter.dateFromString(dict["end_date"] as! String)! 
                            tempdict["end_date"] = date
                            self.startdatearr.addObject(tempdict)
                            self.enddatearr.addObject(tempdict)
                            let sortDescriptor = NSSortDescriptor.init(key: "start_date", ascending: true)
                            self.startdatearr.sortUsingDescriptors(NSArray.init(object: sortDescriptor) as! [NSSortDescriptor])
                            //NSSortDescriptor.init(key: "end_date", ascending: true)
                            self.enddatearr.sortUsingDescriptors(NSArray.init(object: sortDescriptor) as! [NSSortDescriptor])
                    }
                    self.readingsarr.addObject(self.tempgraphdata)
                    self.tempgraphdata.removeAll()
                    print("Actual reading is",self.readingsarr)
                    if(self.readingsarr.count == self.meters.count){
                    dispatch_async(dispatch_get_main_queue(), {
                        self.spinner.hidden = true
                        self.view.userInteractionEnabled = true
                        self.tableview.reloadData()
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
    
    
    func getmeterdata() {
        
        for i in 0..<self.meters.count {
            let c = credentials()
            var tempdict = meters.objectAtIndex(i) as! [String:AnyObject]
                dispatch_after(
                    dispatch_time(
                        DISPATCH_TIME_NOW,
                        Int64(1.5 * Double(NSEC_PER_SEC))
                    ),
                    dispatch_get_main_queue(),
                    {
                        self.id = tempdict["id"] as! Int
                        self.getmeterreadings(c.subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), actionID: tempdict["id"] as! Int)
                        
                    }
                )
                // go to something on the main thread with the image like setting to UIImageView
                
            
            
        }
        
        
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if(item.title == "Plaque"){
            self.performSegueWithIdentifier("gotoplaque", sender: nil)
        }else if(item.title == "Analytics"){
            self.performSegueWithIdentifier("gotoanalysis", sender: nil)
        }else if(item.title == "Manage"){
            self.performSegueWithIdentifier("gotomanage", sender: nil)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.section > 0){
        selectedreading = self.entirereadingsarr.objectAtIndex(indexPath.section-1) as! NSArray
        var dict = self.meters.objectAtIndex(indexPath.section-1) as! [String:AnyObject]
        print("dict is is ",dict["id"] as! Int)
        id = dict["id"] as! Int
        self.performSegueWithIdentifier("gotoreadings", sender: nil)
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
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
        
        self.task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            
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
        
        self.task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            
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
                        self.currentarr["PersonAssigned"] = String(format: "%@ %@",firstname,lastname)
                        self.assigncontainer.hidden = true
                        self.spinner.hidden = true
                        self.view.userInteractionEnabled = true
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
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            
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
                        let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                        NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "actions_data")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        self.spinner.hidden = true
                        self.view.userInteractionEnabled = true
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

    
    @IBAction func okassignthemember(sender: AnyObject) {
        if(statusupdate == 1){
            self.view.userInteractionEnabled = false
            self.spinner.hidden = false
            savestatusupdate(currentarr["CreditId"] as! String, subscription_key: credentials().subscription_key)
            
        }else{
            self.view.userInteractionEnabled = false
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
            return teammembers[row] as! String
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
        self.task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            
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
                    let team_membersarray = jsonDictionary["EtTeamMembers"] as! NSArray
                    self.teammembers = team_membersarray
                    dispatch_async(dispatch_get_main_queue(), {
                        self.assigncontainer.hidden = false
                        self.spinner.hidden = true
                        self.view.userInteractionEnabled = true
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
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            
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
                    let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                    NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "actions_data")
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSUserDefaults.standardUserDefaults().synchronize()
                    NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "row")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.spinner.hidden = true
                        self.view.userInteractionEnabled = true
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
            self.view.userInteractionEnabled = false
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
        var s = String(format:"%d",leedid)
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
        var string = self.statusarr[self.picker.selectedRowInComponent(0)] as! String
        if(string == "Ready for review"){
            httpbody = String(format: "{\"is_readyForReview\": %@}",true)
        }else{
            httpbody = String(format: "{\"is_readyForReview\": %@}",false)
        }
        request.HTTPBody = httpbody.dataUsingEncoding(NSUTF8StringEncoding)
        
        self.task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            
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
