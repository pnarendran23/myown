//
//  prerequisites.swift
//  LEEDOn
//
//  Created by Group X on 16/11/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class prerequisites: UIViewController, UITableViewDataSource,UITableViewDelegate,UITabBarDelegate, UIPickerViewDelegate,UIPickerViewDataSource {
    @IBOutlet weak var actiontitle: UILabel!
    var uploadsdata = NSArray()
    var leedid = NSUserDefaults.standardUserDefaults().integerForKey("leed_id")
    var filescount = 1
    var statusarr = ["Attempted","Ready for review"]
    var statusupdate = 0
    var task = NSURLSessionTask()
    @IBOutlet weak var next: UIButton!
    var teammembers = NSArray()
    @IBOutlet weak var prev: UIButton!
    @IBOutlet weak var spinner: UIView!
    
    @IBOutlet weak var shortcredit: UIImageView!
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
    var currentcategory = NSMutableArray()
    var currentindex = 0
    override func viewDidLoad() {
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
        self.prev.layer.cornerRadius = 4
        self.next.layer.cornerRadius = 4
        self.tabbar.delegate = self
        self.tabbar.selectedItem = self.tabbar.items![1]
        tableview.registerNib(UINib.init(nibName: "prerequisitescell1", bundle: nil), forCellReuseIdentifier: "cell1")
        tableview.registerNib(UINib.init(nibName: "prerequisitescell2", bundle: nil), forCellReuseIdentifier: "cell2")
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
        ivupload1.tag = 101
        ivupload2.tag = 102
        ivattached2.tag = 103
        
        ivupload1.addTarget(self, action: #selector(prerequisites.valuechanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        ivupload2.addTarget(self, action: #selector(prerequisites.valuechanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        ivattached2.addTarget(self, action: #selector(prerequisites.valuechanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        var tap = UITapGestureRecognizer.init(target: self, action: #selector(datainput.statusupdate(_:)))
        self.creditstatus.userInteractionEnabled = true
        self.creditstatus.addGestureRecognizer(tap)
        
        navigate()
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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*if(section == 1){
            return 1
        }else if (section == 2){
            return uploadsdata.count+1
        }*/
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        /*if(section == 0){
            return "    Credit Forms"
        }else if(section == 1 ){
            return "    Assigned user"
        }else if (section == 2){
            return "    Files uploaded"
        }*/
        if(section == 0){
            return "    Assigned user"
        }
        
        return ""
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        if(indexPath.section == 0){
            var cell = tableView.dequeueReusableCellWithIdentifier("cell2") as! prerequisitescell2
            cell.fileuploaded.hidden = true
            cell.uploadbutton.hidden = true
            cell.uploadanewfile.hidden = true
            cell.assignedto.hidden = false
            cell.editbutton.hidden = false
            cell.editbutton.addTarget(self, action: #selector(edited), forControlEvents: UIControlEvents.TouchUpInside)
            var text = "" as! String
            cell.assignedto.hidden = false
            if let assignedto = currentarr["PersonAssigned"] as? String{
                var temp = assignedto
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
            
        /*var cell = tableView.dequeueReusableCellWithIdentifier("cell1") as! prerequisitescell1
            if (cell.respondsToSelector("setPreservesSuperviewLayoutMargins:")){
                cell.layoutMargins = UIEdgeInsetsZero
                cell.preservesSuperviewLayoutMargins = false
            }
            cell.uploadnew.hidden = true
            cell.uploadedfile.hidden = false
            cell.uploadheading.hidden = false
            cell.delfile.hidden = true
            if (indexPath.row == 0 ){
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            }else if(indexPath.row == 1){
                cell.uploadnew.hidden = false
                cell.uploadedfile.hidden = true
                cell.uploadheading.hidden = true
                cell.delfile.hidden = true
            }
        cell.delfile.addTarget(self, action: #selector(deleted), forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
        }
        else if(indexPath.section == 1){
            if (cell.respondsToSelector("setPreservesSuperviewLayoutMargins:")){
                cell.layoutMargins = UIEdgeInsetsZero
                cell.preservesSuperviewLayoutMargins = false
            }
            var cell = tableView.dequeueReusableCellWithIdentifier("cell2") as! prerequisitescell2
            cell.editbutton.addTarget(self, action: #selector(edited), forControlEvents: UIControlEvents.TouchUpInside)
            if(indexPath.row == 0){
                cell.fileuploaded.hidden = true
                cell.uploadbutton.hidden = true
                cell.uploadanewfile.hidden = true
                cell.assignedto.hidden = false
                cell.editbutton.hidden = false
                var text = "" as! String
                if let assignedto = currentarr["AssignedTo"] as? [String:AnyObject]{
                    var temp = assignedto
                    if let firstname = temp["first_name"] as? String{
                        text = "Assigned to "+firstname.capitalizedString
                        
                    }else{
                        text = "Assigned to None"
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.assignedto.text = text
                }else{
                    cell.selectionStyle = UITableViewCellSelectionStyle.None
                    cell.assignedto.text = "Assigned to None"
                }
            }
            else if(indexPath.row == 1){
                cell.fileuploaded.hidden = false
                cell.uploadbutton.hidden = false
                cell.assignedto.hidden = true
                cell.editbutton.hidden = true
            }
            return cell
        }else if(indexPath.section == 2){
            var cell = tableView.dequeueReusableCellWithIdentifier("cell2") as! prerequisitescell2
            cell.uploadbutton.addTarget(self, action: #selector(uploaded), forControlEvents: UIControlEvents.TouchUpInside)
            if(indexPath.row <= uploadsdata.count - 1){
                cell.fileuploaded.hidden = false
                cell.uploadbutton.hidden = false
                cell.assignedto.hidden = true
                cell.uploadanewfile.hidden = true
                cell.editbutton.hidden = true
                var dict = uploadsdata.objectAtIndex(indexPath.row) as! [String:AnyObject]
                var linkTextWithColor = "File uploaded"
                var text = ""
                text = String(format: "File uploaded: %@",dict["Docfile"] as! NSString)
                let range = (text as NSString).rangeOfString(linkTextWithColor)
                let attributedString = NSMutableAttributedString(string:text)
                attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGrayColor() , range: range)
                cell.fileuploaded.attributedText = attributedString
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell

                
                
            }
            else{
                cell.selectionStyle = UITableViewCellSelectionStyle.Default
                cell.uploadanewfile.hidden = false
                cell.assignedto.hidden = true
                cell.fileuploaded.hidden = true
                cell.uploadbutton.hidden = true
                cell.assignedto.hidden = true
                cell.editbutton.hidden = true
                return cell
            }
            */
        }
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
                self.view.userInteractionEnabled = false
                self.pleasekindly.text = "Please kindly the team member to assign this action"
                self.assignokbtn.setTitle("Assign", forState: UIControlState.Normal)
                self.getteammembers(credentials().subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"))
            })
    }

    func uploaded(){
        print("uploaded")
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        assignokbtn.enabled = true
        if(statusupdate == 0){
        print(teammembers[row]["Useralias"])
        }
    }
    
    
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if(self.actiontitle.text!.containsString("Policy")){
             return 10
        }
        return 5
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                 return 50
            }
        }else{
            if indexPath.row == 1 {
                return 80
            }
        }
        
        return 70
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
                    var team_membersarray = jsonDictionary["EtTeamMembers"] as! NSArray
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
                self.performSegueWithIdentifier("datainput", sender: nil)
            }else{
                navigate()
            }
        }
    }
    @IBOutlet weak var ivupload2: UISwitch!
    
    @IBOutlet weak var assignokbtn: UIButton!
    @IBOutlet weak var assignclosebutton: UIButton!
    @IBOutlet weak var pleasekindly: UILabel!
    @IBOutlet weak var assigncontainer: UIView!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var ivattached2: UISwitch!
    
    @IBOutlet weak var ivupload1: UISwitch!
    func navigate(){
        dispatch_async(dispatch_get_main_queue(), {
            self.spinner.hidden = true
            self.view.userInteractionEnabled = true
        })
        self.assigncontainer.hidden = true
        currentindex = NSUserDefaults.standardUserDefaults().integerForKey("selected_action")
        NSUserDefaults.standardUserDefaults().synchronize()
        currentarr = currentcategory[currentindex] as! [String:AnyObject]
        category.text = checkcredit_type(currentarr)
        self.actiontitle.text = currentarr["CreditDescription"] as? String
        self.creditstatus.text = currentarr["CreditStatus"] as? String
        self.affirmationsclick(self.activityfeedbutton)
        if(self.creditstatus.text == ""){
            self.creditstatus.text = "Not available"
        }
            if let creditstatus = currentarr["CreditStatus"] as? String{
                self.creditstatus.text = String(format: "%@",creditstatus.capitalizedString)
                if(creditstatus == "Ready for Review"){
                    creditstatusimg.image = UIImage.init(named: "tick")
                }else{
                    creditstatusimg.image = UIImage.init(named: "circle")
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
        }
        
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
        
        var c = credentials()
        domain_url = c.domain_url
        var dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary
        dispatch_async(dispatch_get_main_queue(), {
            self.tableview.reloadData()
        })
        //self.getuploadsdata(c.subscription_key, leedid: 1000136954, actionID: currentarr["CreditId"] as! String)
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
                self.performSegueWithIdentifier("datainput", sender: nil)
            }else{
                navigate()
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
            self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.1*self.affirmationview2.layer.frame.origin.y+self.affirmationview2.layer.frame.size.height, self.tableview.layer.frame.size.width, fabs(self.view.layer.frame.size.height-(self.activityfeedbutton.layer.frame.size.height+self.tabbar.layer.frame.size.height+(1.0*(self.affirmationview2.layer.frame.origin.y+self.affirmationview2.layer.frame.size.height)))))
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
    
    func getuploadsdata(subscription_key:String, leedid: Int, actionID: String){
        
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
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                   // self.buildingactions(subscription_key, leedid: leedid)
                    self.getcreditformsuploadsdata(subscription_key, leedid: leedid, actionID: actionID)
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
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
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
        print("Selected")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func assignclose(sender: AnyObject) {
        self.assigncontainer.hidden = true
    }
    
    func assignnewmember(subscription_key:String, leedid: Int, actionID: String, email:String,firstname: String, lastname:String){
        //https://api.usgbc.org/dev/leed/assets/LEED:{leed_id}/actions/ID:{action_id}/teams/
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@/teams/",domain_url, leedid, actionID))
        print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var httpbody = String(format: "{\"emails\":\"%@\"}",email)
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
                        self.currentcategory.replaceObjectAtIndex(self.currentindex, withObject: self.currentarr)
                        self.assigncontainer.hidden = true
                        self.spinner.hidden = true
                        self.view.userInteractionEnabled = true
                        self.buildingactions(subscription_key, leedid: leedid)
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
    
    
    func buildingactions(subscription_key:String, leedid: Int){
        var url = NSURL.init(string: String(format: "%@assets/LEED:%d/actions/",domain_url,leedid))
        print(url?.absoluteURL)
        var request = NSMutableURLRequest.init(URL: url!)
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
                
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print("Building xcv",jsonDictionary)
                    dispatch_async(dispatch_get_main_queue(), {
                    var datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                    NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "actions_data")
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSUserDefaults.standardUserDefaults().synchronize()
                    self.navigate()
                    self.tableview.reloadData()
                        return
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
    
    func affirmationupdate(actionID:String, leedid: Int, subscription_key:String){
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
                        self.buildingactions(subscription_key, leedid: leedid)
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

    
    
    
    func selectedaction(){
        
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
