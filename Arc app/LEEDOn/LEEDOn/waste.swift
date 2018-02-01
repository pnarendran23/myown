//
//  ViewController.swift
//  LEEDOn
//
//  Created by Group X on 15/11/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class waste: UIViewController,UITabBarDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var tabbar: UITabBar!
    
    @IBOutlet weak var creditstatusimg: UIImageView!
    @IBOutlet weak var shortcredit: UIImageView!
    @IBOutlet weak var spinner: UIView!
    @IBOutlet weak var assignedto: UILabel!
    @IBOutlet weak var actiontitle: UILabel!
    @IBOutlet weak var creditstatus: UILabel!
    @IBOutlet weak var assignedview: UIView!
    @IBOutlet weak var cc: UIView!
    var statusarr = ["Attempted","Ready for review"] as NSArray
    var statusupdate = 0
    let leedid = NSUserDefaults.standardUserDefaults().integerForKey("leed_id")
    @IBOutlet weak var assignokbtn: UIButton!
    @IBOutlet weak var assignclosebutton: UIButton!
    @IBOutlet weak var pleasekindly: UILabel!
    @IBOutlet weak var assigncontainer: UIView!
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var assetname: UILabel!
    var satisfactionarr = [Int]()
    var dissatisfactionarr = [Int]()
    var task = NSURLSessionTask()
    var currentcount = 0
    var currentindex = 0
    var data = [Int]()
    
    var meters = NSMutableArray()
    var teammembers = NSMutableArray()
    var data2 = [Int]()
    var currentarr = [String:AnyObject]()
    var currentmetersdict = [String:AnyObject]()
    var currentcategory = NSMutableArray()
    var domain_url = ""
    var token = ""
    @IBOutlet weak var vv: UIScrollView!
    @IBOutlet weak var btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.layer.cornerRadius = 5
        self.spinner.hidden = true
        self.view.userInteractionEnabled = true
        // 3
        // 4
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

        self.prev.layer.cornerRadius = 4
        self.next.layer.cornerRadius = 4
        self.tabbar.delegate = self
        self.tabbar.selectedItem = self.tabbar.items![1]
        var datakeyed = NSData()
        token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        datakeyed = NSUserDefaults.standardUserDefaults().objectForKey("currentcategory") as! NSData
        currentcategory = NSKeyedUnarchiver.unarchiveObjectWithData(datakeyed) as! NSMutableArray
        currentindex = NSUserDefaults.standardUserDefaults().integerForKey("selected_action")
        NSUserDefaults.standardUserDefaults().synchronize()
        print("aarra", currentcategory)
        currentarr = currentcategory[currentindex] as! [String:AnyObject]
        self.actiontitle.text = currentarr["CreditDescription"] as? String
        self.creditstatus.text = currentarr["CreditStatus"] as? String
        if(self.creditstatus.text == ""){
            self.creditstatus.text = "Not available"
        }
        let c = credentials()
        domain_url = c.domain_url
        let dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary
        actiontitle.text = dict["name"] as? String
        dispatch_async(dispatch_get_main_queue(), {
            if((self.currentarr["CreditDescription"] as! String).lowercaseString == "waste"){
                let rect = self.addnew.frame
                self.addnew.setImage(UIImage(named: "addnewdata.png") as UIImage?, forState: UIControlState.Normal)
                self.addnew.frame = rect
                self.addnew.layer.cornerRadius = rect.size.height/2.0
                //self.addnew.titleLabel?.text = "Add new reading"
            }else if((self.currentarr["CreditDescription"] as! String).lowercaseString == "transportation"){
                let rect = self.addnew.frame
                self.addnew.setImage(UIImage(named: "invitation_icon.png") as UIImage?, forState: UIControlState.Normal)
                self.addnew.frame = rect
                self.addnew.layer.cornerRadius = rect.size.height/2.0
                //self.addnew.titleLabel?.text = "Email survey"
            }
            self.ivupload1.tag = 101
            self.ivupload1.addTarget(self, action: #selector(waste.valuechanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
            
            //self.btn.addTarget(self, action: Selector(self.getteammembers(credentials().subscription_key, leedid: 1000136954)), forControlEvents: UIControlEvents.TouchUpInside)
            var tap = UITapGestureRecognizer.init(target: self, action: #selector(datainput.statusupdate(_:)))
            self.creditstatus.userInteractionEnabled = true
            self.creditstatus.addGestureRecognizer(tap)
            self.navigate()
            
        })
        
        }
        
        func statusupdate(sender:UILabel){
            self.teammembers = statusarr.mutableCopy() as! NSMutableArray
            dispatch_async(dispatch_get_main_queue(), {
                self.assigncontainer.hidden = false                
                self.statusupdate = 1
                self.pleasekindly.text = "Please kindly select the below status for the action"
                self.assignokbtn.setTitle("Save", forState: UIControlState.Normal)
                self.picker.reloadAllComponents()
            })
        }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    
    
    func valuechanged(sender:UISwitch){
        if(sender.tag == 101){
        dispatch_async(dispatch_get_main_queue(), {
            self.spinner.hidden = false
            self.view.userInteractionEnabled = false
        })
        affirmationupdate(currentarr["CreditId"] as! String, leedid: leedid, subscription_key: credentials().subscription_key)
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
            httpbody = String(format: "{\"IvAttchPolicy\": false, \"IvReqFileupload\": %@}",ivupload1.on)
        
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
                let jsonDictionary : NSDictionary
                do {
                            self.currentarr["IvAttchPolicy"] = ""
                        if(self.ivupload1.on == true){
                            self.currentarr["IvReqFileupload"] = "X"
                        }else{
                            self.currentarr["IvReqFileupload"] = ""
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
                let jsonDictionary : NSDictionary
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

    
    @IBOutlet weak var ivupload1: UISwitch!
    
    func navigate(){
        self.vv.hidden = true
        dispatch_async(dispatch_get_main_queue(), {
            self.spinner.hidden = true
            self.view.userInteractionEnabled = true
        })
        currentarr = currentcategory[currentindex] as! [String:AnyObject]
        self.actiontitle.text = currentarr["CreditDescription"] as? String
        self.creditstatus.text = currentarr["CreditStatus"] as? String
        if(self.creditstatus.text == ""){
            self.creditstatus.text = "Not available"
        }
        currentcount = 0
        let c = credentials()
        domain_url = c.domain_url
        let dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary
        assetname.text = dict["name"] as? String
        data.removeAll()
        data2.removeAll()
        meters.removeAllObjects()
        currentmetersdict.removeAll()
        NSUserDefaults.standardUserDefaults().removeObjectForKey("startdate")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("enddate")
        
        if(currentarr["IvReqFileupload"] is String){
            if(currentarr["IvReqFileupload"] as! String == ""){
                ivupload1.setOn(false, animated: false)
            }else if(currentarr["IvReqFileupload"] as! String == "X"){
                ivupload1.setOn(true, animated: false)
            }
        }else{
            ivupload1.setOn(currentarr["IvReqFileupload"] as! Bool, animated: false)            
        }
        
        
        if let creditstatus = currentarr["CreditStatus"] as? String{
            self.creditstatus.text = String(format: "%@",creditstatus.capitalizedString)
            if(creditstatus == "Ready for Review"){
                creditstatusimg.image = UIImage.init(named: "tick")
            }else{
                creditstatusimg.image = UIImage.init(named: "circle")
            }
        }else{
            creditstatus.text = "Not available"
        }

        
        
        if((self.currentarr["CreditDescription"] as! String).lowercaseString == "human experience"){
            let rect = self.addnew.frame
            self.addnew.setImage(UIImage(named: "invitation_icon.png") as UIImage?, forState: UIControlState.Normal)
            self.addnew.frame = rect
            self.addnew.layer.cornerRadius = rect.size.height/2.0
            //self.addnew.titleLabel?.text = "Email survey"
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

        
        if((currentarr["CreditDescription"] as! String).lowercaseString == "water" || (currentarr["CreditDescription"] as! String).lowercaseString == "energy"){
            self.performSegueWithIdentifier("gotodatainput", sender: nil)
        }else if((currentarr["CreditDescription"] as! String).lowercaseString == "waste"){
            let c = credentials()
            getallwastedata(c.subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"))
        }
        else if((currentarr["CreditDescription"] as! String).lowercaseString == "transportation"){
            let c = credentials()
            getalltransitdata(c.subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"))
        }else if((currentarr["CreditDescription"] as! String).lowercaseString == "human experience"){
            let c = credentials()
            //getalltransitdata(c.subscription_key, leedid: 1000137969)
            print("Human experience")
            getmeters(c.subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"))
        }
        else{
            self.performSegueWithIdentifier("gotodatainput", sender: nil)
        }
        
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
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print("Meter readings ",jsonDictionary)
                    let arr = jsonDictionary["results"] as! NSArray
                    let startdatearrforco2 = NSMutableArray()
                    let enddatearrforco2 = NSMutableArray()
                    let startdatearrforvoc = NSMutableArray()
                    let enddatearrforvoc = NSMutableArray()
                    for i in 0..<arr.count{
                        let dict = arr.objectAtIndex(i) as! [String:AnyObject]
                        print("Consumption",dict["meter"]!["fuel_type"]!!["kind"]!)
                        if(dict["meter"]!["fuel_type"]!!["kind"] as! String == "voc"){
                            self.data.append(dict["reading"] as! Int)
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            var tempdict = [String:AnyObject]()
                            var date = dateFormatter.dateFromString(dict["start_date"] as! String)!
                            tempdict["start_date"] = date
                            startdatearrforvoc.addObject(tempdict)
                            date = dateFormatter.dateFromString(dict["end_date"] as! String)! 
                            tempdict["end_date"] = date
                            startdatearrforvoc.addObject(tempdict)
                            enddatearrforvoc.addObject(tempdict)
                            let sortDescriptor = NSSortDescriptor.init(key: "start_date", ascending: true)
                            startdatearrforvoc.sortUsingDescriptors(NSArray.init(object: sortDescriptor) as! [NSSortDescriptor])
                            NSSortDescriptor.init(key: "end_date", ascending: true)
                            enddatearrforvoc.sortUsingDescriptors(NSArray.init(object: sortDescriptor) as! [NSSortDescriptor])
                            print("Date arr ",startdatearrforvoc.firstObject,enddatearrforvoc.lastObject)
                            NSUserDefaults.standardUserDefaults().setObject(startdatearrforvoc.firstObject!["start_date"], forKey: "startdateforvoc")
                            self.spinner.hidden = true
                            self.view.userInteractionEnabled = true
                            NSUserDefaults.standardUserDefaults().setObject(enddatearrforvoc.lastObject!["end_date"], forKey: "enddateforvoc")
                            
                        }else if(dict["meter"]!["fuel_type"]!!["kind"] as! String == "co2"){
                            self.data2.append(dict["reading"] as! Int)
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            var tempdict = [String:AnyObject]()
                            var date = dateFormatter.dateFromString(dict["start_date"] as! String)!
                            tempdict["start_date"] = date
                            startdatearrforco2.addObject(tempdict)
                            date = dateFormatter.dateFromString(dict["end_date"] as! String)!
                            tempdict["end_date"] = date
                            startdatearrforco2.addObject(tempdict)
                            enddatearrforco2.addObject(tempdict)
                            let sortDescriptor = NSSortDescriptor.init(key: "start_date", ascending: true)
                            self.spinner.hidden = true
                            self.view.userInteractionEnabled = true
                            startdatearrforco2.sortUsingDescriptors(NSArray.init(object: sortDescriptor) as! [NSSortDescriptor])
                            NSSortDescriptor.init(key: "end_date", ascending: true)
                            enddatearrforco2.sortUsingDescriptors(NSArray.init(object: sortDescriptor) as! [NSSortDescriptor])
                            print("Date arr ",startdatearrforco2.firstObject,enddatearrforco2.lastObject)
                            NSUserDefaults.standardUserDefaults().setObject(startdatearrforco2.firstObject!["start_date"], forKey: "startdateforco2")
                            NSUserDefaults.standardUserDefaults().setObject(enddatearrforco2.lastObject!["end_date"], forKey: "enddateforco2")
                        }
                    }
                    if(self.currentcount == self.meters.count){
                        self.gethumansurveydata(NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), subscription_key: credentials().subscription_key)
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

    
    
    func gethumansurveydata(leedid: Int, subscription_key: String){
        
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/survey/environment/",domain_url, leedid))
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
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print("Meters are",jsonDictionary)
                    //self.graphPoints = jsonDictionary["results"] as! NSArray
                    self.satisfactionarr = [0,0,0,0,0,0,0,0,0,0]
                    self.dissatisfactionarr = [0,0,0,0,0,0,0,0,0,0]
                    self.currentmetersdict  = jsonDictionary as! [String:AnyObject]
                    let temparr = jsonDictionary["results"]?.mutableCopy() as! NSMutableArray
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    for i in 0..<temparr.count{
                        let dict = temparr.objectAtIndex(i) as! [String:AnyObject]
                        let c = dict["complaints"] as! String
                        var complaints = NSMutableArray()
                        complaints = (c.componentsSeparatedByString(",") as NSArray).mutableCopy() as! NSMutableArray
                        if(complaints.count == 1){
                            complaints.removeAllObjects()
                        }
                        let satisfaction = dict["satisfaction"] as! Int
                        print("complaints ",complaints)
                        if(complaints.count == 0){
                        self.satisfactionarr[satisfaction-1] = self.satisfactionarr[satisfaction-1]+1
                        }else{
                            _ = 0
                            if(complaints.containsObject("dirty")){
                                self.dissatisfactionarr[0] = self.dissatisfactionarr[0]+1
                            }
                            if(complaints.containsObject("smelly")){
                                self.dissatisfactionarr[1] = self.dissatisfactionarr[1]+1
                            }
                            if(complaints.containsObject("stuffy")){
                                self.dissatisfactionarr[2] = self.dissatisfactionarr[2]+1
                            }
                            if(complaints.containsObject("loud")){
                                self.dissatisfactionarr[3] = self.dissatisfactionarr[3]+1
                            }
                            if(complaints.containsObject("hot")){
                                self.dissatisfactionarr[4] = self.dissatisfactionarr[4]+1
                            }
                            if(complaints.containsObject("cold")){
                                self.dissatisfactionarr[5] = self.dissatisfactionarr[5]+1
                            }
                            if(complaints.containsObject("dark")){
                                self.dissatisfactionarr[6] = self.dissatisfactionarr[6]+1
                            }
                            if(complaints.containsObject("glare")){
                                self.dissatisfactionarr[7] = self.dissatisfactionarr[7]+1
                            }
                            if(complaints.containsObject("privacy")){
                                self.dissatisfactionarr[8] = self.dissatisfactionarr[8]+1
                            }
                            if(complaints.containsObject("other")){
                                self.dissatisfactionarr[9] = self.dissatisfactionarr[9]+1
                            }
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                    print(self.satisfactionarr, self.dissatisfactionarr)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.vv.hidden = false
                            
                            NSUserDefaults.standardUserDefaults().setObject(self.data, forKey: "voc")
                            NSUserDefaults.standardUserDefaults().setObject(self.data2, forKey: "co2")
                            NSUserDefaults.standardUserDefaults().setObject(self.dissatisfactionarr, forKey: "dissatisfaction")
                            NSUserDefaults.standardUserDefaults().setObject(self.satisfactionarr, forKey: "satisfaction")
                            let view = satisfaction()
                            self.assignedview.frame = CGRect(x:0,y:0,width:self.vv.frame.size.width, height: 0.3*self.vv.frame.size.height)
                            self.cc.frame =  CGRect(x:0,y:0,width:self.vv.frame.size.width, height:self.vv.frame.size.width )
                            self.vv.contentSize = CGSize(width: self.vv.frame.size.width,height:self.cc.frame.size.height+self.cc.frame.size.height+self.cc.frame.size.height+self.cc.frame.size.height+self.assignedview.frame.size.height)
                            if(self.cc.viewWithTag(23) != nil){
                                self.cc.viewWithTag(23)?.removeFromSuperview()
                            }
                            view.frame = CGRect(x:0,y:self.assignedview.layer.frame.size.height,width:self.cc.frame.width, height: self.cc.frame.size.width)
                            view.tag = 23
                            self.cc.addSubview(view)
                            let view1 = dissatisfaction()
                            self.cc.frame =  CGRect(x:0,y:0,width:self.vv.frame.size.width, height:self.vv.frame.size.width )
                            if(self.cc.viewWithTag(24) != nil){
                                self.cc.viewWithTag(24)?.removeFromSuperview()
                            }
                            view1.frame = CGRect(x:0,y:view.layer.frame.origin.y+view.layer.frame.size.height,width:self.cc.frame.width, height: self.cc.frame.size.width)
                            view1.tag = 24
                            self.cc.addSubview(view1)
                            
                            
                            let view2 = voc()
                            self.cc.frame =  CGRect(x:0,y:0,width:self.vv.frame.size.width, height:self.vv.frame.size.width )
                            if(self.cc.viewWithTag(25) != nil){
                                self.cc.viewWithTag(25)?.removeFromSuperview()
                            }
                            view2.frame = CGRect(x:0,y:view1.layer.frame.origin.y+view1.layer.frame.size.height,width:self.cc.frame.width, height: self.cc.frame.size.width)
                            view2.tag = 25
                            self.cc.addSubview(view2)
                            
                            let view3 = co2()
                            self.cc.frame =  CGRect(x:0,y:0,width:self.vv.frame.size.width, height:self.vv.frame.size.width )
                            if(self.cc.viewWithTag(26) != nil){
                                self.cc.viewWithTag(26)?.removeFromSuperview()
                            }
                            view3.frame = CGRect(x:0,y:view2.layer.frame.origin.y+view2.layer.frame.size.height,width:self.cc.frame.width, height: self.cc.frame.size.width)
                            view3.tag = 26
                            self.cc.addSubview(view3)
                        })
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
    
    
    func getmeterdata() {
        
        for i in 0..<self.meters.count {
            let c = credentials()
            let tempdict = meters.objectAtIndex(i) as! [String:AnyObject]
            dispatch_after(
                dispatch_time(
                    DISPATCH_TIME_NOW,
                    Int64(1.5 * Double(NSEC_PER_SEC))
                ),
                dispatch_get_main_queue(),
                {
                    self.currentcount += 1
                    self.getmeterreadings(c.subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), actionID: tempdict["id"] as! Int)
                    
                }
            )
            
            
            // go to something on the main thread with the image like setting to UIImageView
            
            
            
        }
        print("Got date",NSUserDefaults.standardUserDefaults().objectForKey("startdateforco2"),NSUserDefaults.standardUserDefaults().objectForKey("startdateforvoc"),data,data2 )
        
    }
    func getmeters(subscription_key:String, leedid: Int){
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/meters/?kind=humanexperience",domain_url, leedid))
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
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print("Meters are",jsonDictionary)
                    //self.graphPoints = jsonDictionary["results"] as! NSArray
                    self.currentmetersdict  = jsonDictionary as! [String:AnyObject]
                    self.meters = jsonDictionary["results"]?.mutableCopy() as! NSMutableArray
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
    
    
    func getallwastedata(subscription_key:String, leedid: Int){
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/waste/",domain_url, leedid))
        print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
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
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print("Meters are",jsonDictionary)
                    //self.graphPoints = jsonDictionary["results"] as! NSArray
                    //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"beginDate" ascending:TRUE];
                    //[myMutableArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                    let startdatearr = NSMutableArray()
                    let enddatearr = NSMutableArray()
                    self.currentmetersdict  = jsonDictionary as! [String:AnyObject]
                    self.meters = jsonDictionary["results"]?.mutableCopy() as! NSMutableArray
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSUserDefaults.standardUserDefaults().removeObjectForKey("startdate")
                    NSUserDefaults.standardUserDefaults().removeObjectForKey("enddate")
                    if(self.meters.count>0){
                        for i in 0...self.meters.count-1{
                            let item = self.meters.objectAtIndex(i) as! [String:AnyObject]
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
                            startdatearr.addObject(tempdict)
                            date = dateFormatter.dateFromString(item["end_date"] as! String)! 
                            tempdict["end_date"] = date
                            startdatearr.addObject(tempdict)
                            enddatearr.addObject(tempdict)
                            let sortDescriptor = NSSortDescriptor.init(key: "start_date", ascending: true)
                            startdatearr.sortUsingDescriptors(NSArray.init(object: sortDescriptor) as! [NSSortDescriptor])
                            NSSortDescriptor.init(key: "end_date", ascending: true)
                            enddatearr.sortUsingDescriptors(NSArray.init(object: sortDescriptor) as! [NSSortDescriptor])
                            print("Date arr ",startdatearr.firstObject,enddatearr.lastObject)
                            NSUserDefaults.standardUserDefaults().setObject(startdatearr.firstObject!["start_date"], forKey: "startdate")
                            NSUserDefaults.standardUserDefaults().setObject(enddatearr.lastObject!["end_date"], forKey: "enddate")
                        }
                    }
                    
                    NSUserDefaults.standardUserDefaults().setObject(self.data, forKey: "data")
                    NSUserDefaults.standardUserDefaults().setObject(self.data2, forKey: "data2")
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        let view = chartview()
                        self.assignedview.frame = CGRect(x:0,y:0,width:self.vv.frame.size.width, height: 0.3*self.vv.frame.size.height)
                        self.cc.frame =  CGRect(x:0,y:0,width:self.vv.frame.size.width, height:self.vv.frame.size.width )
                        self.vv.contentSize = CGSize(width: self.vv.frame.size.width,height:self.cc.frame.size.height+self.assignedview.frame.size.height)
                        if(self.cc.viewWithTag(23) != nil){
                            self.cc.viewWithTag(23)?.removeFromSuperview()
                        }
                        if(self.cc.viewWithTag(24) != nil){
                            self.cc.viewWithTag(24)?.removeFromSuperview()
                        }
                        if(self.cc.viewWithTag(25) != nil){
                            self.cc.viewWithTag(25)?.removeFromSuperview()
                        }
                        if(self.cc.viewWithTag(26) != nil){
                            self.cc.viewWithTag(26)?.removeFromSuperview()
                        }
                        
                        view.frame = CGRect(x:0,y:self.assignedview.layer.frame.size.height,width:self.cc.frame.width, height: self.cc.frame.size.width)
                        view.tag = 23
                        self.cc.addSubview(view)
                        self.vv.hidden = false
                        if((self.currentarr["CreditDescription"] as! String).lowercaseString == "waste"){
                            let rect = self.addnew.frame
                            self.addnew.setImage(self.imageWithImage(UIImage(named:"addnewdata.png")!, scaledToSize: CGSize(width:70, height: 70)), forState: UIControlState.Normal)
                            self.addnew.frame = rect
                            self.addnew.layer.cornerRadius = rect.size.height/2.0
                            //self.addnew.titleLabel?.text = "Add new reading"
                        }else if((self.currentarr["CreditDescription"] as! String).lowercaseString == "transportation"){
                            let rect = self.addnew.frame
                            self.addnew.setImage(self.imageWithImage(UIImage(named:"invitation_icon.png")!, scaledToSize: CGSize(width:70, height: 70)), forState: UIControlState.Normal)
                            self.addnew.frame = rect
                            self.addnew.layer.cornerRadius = rect.size.height/2.0
                            //self.addnew.titleLabel?.text = "Email survey"
                        }                    })
                    
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

    
    func getalltransitdata(subscription_key:String, leedid: Int){
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/survey/transit/",domain_url, leedid))
        print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
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
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print("Meters are",jsonDictionary)
                    //self.graphPoints = jsonDictionary["results"] as! NSArray
                    
                    self.currentmetersdict  = jsonDictionary as! [String:AnyObject]
                    self.meters = jsonDictionary["results"]?.mutableCopy() as! NSMutableArray
                    if(self.meters.count>0){
                        for i in 0...self.meters.count-1{
                            let item = self.meters.objectAtIndex(i) as! [String:AnyObject]
                            var f1 = 0.0234234
                            var f2 = 0.0
                            f1 = item["waste_diverted"] as! Double
                            f2 = item["waste_generated"] as! Double
                            self.data.append(Int(f1))
                            self.data2.append(0)
                        }}
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSUserDefaults.standardUserDefaults().setObject(self.data, forKey: "data")
                    NSUserDefaults.standardUserDefaults().setObject(self.data2, forKey: "data2")
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        let view = chartview()
                        self.assignedview.frame = CGRect(x:0,y:0,width:self.vv.frame.size.width, height: 0.3*self.vv.frame.size.height)
                        self.cc.frame =  CGRect(x:0,y:0,width:self.vv.frame.size.width, height:self.vv.frame.size.width )
                        self.vv.contentSize = CGSize(width: self.vv.frame.size.width,height:self.cc.frame.size.height+self.assignedview.frame.size.height)
                        if(self.cc.viewWithTag(23) != nil){
                            self.cc.viewWithTag(23)?.removeFromSuperview()
                        }
                        if(self.cc.viewWithTag(24) != nil){
                            self.cc.viewWithTag(24)?.removeFromSuperview()
                        }
                        if(self.cc.viewWithTag(25) != nil){
                            self.cc.viewWithTag(25)?.removeFromSuperview()
                        }
                        if(self.cc.viewWithTag(26) != nil){
                            self.cc.viewWithTag(26)?.removeFromSuperview()
                        }
                        view.frame = CGRect(x:0,y:self.assignedview.layer.frame.size.height,width:self.cc.frame.width, height: self.cc.frame.size.width)
                        view.tag = 23
                        self.cc.addSubview(view)
                        self.vv.hidden = false
                        if((self.currentarr["CreditDescription"] as! String).lowercaseString == "waste"){
                            let rect = self.addnew.frame
                            self.addnew.setImage(UIImage(named: "addnewdata.png") as UIImage?, forState: UIControlState.Normal)
                            self.addnew.frame = rect
                            self.addnew.layer.cornerRadius = rect.size.height/2.0
                            //self.addnew.titleLabel?.text = "Add new reading"
                        }else if((self.currentarr["CreditDescription"] as! String).lowercaseString == "transportation"){
                            let rect = self.addnew.frame
                            self.addnew.setImage(UIImage(named: "invitation_icon.png") as UIImage?, forState: UIControlState.Normal)
                            self.addnew.frame = rect
                            self.addnew.layer.cornerRadius = rect.size.height/2.0
                            //self.addnew.titleLabel?.text = "Email survey"
                        }                    })
                    
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
    
    @IBOutlet weak var addnew: UIButton!
    @IBOutlet weak var prev: UIButton!
    
    @IBOutlet weak var next: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func gotonext(sender: AnyObject) {
        if(currentindex<currentcategory.count-1){
            /*if(task.currentRequest != nil){
             if (task.state == NSURLSessionTaskState.Running) {
             task.cancel()
             }
             }*/
            currentindex = currentindex+1
            NSUserDefaults.standardUserDefaults().setInteger(currentindex, forKey: "selected_action")
            currentarr = currentcategory[currentindex] as! [String:AnyObject]
            if((currentarr["CreditDescription"] as! String).lowercaseString == "human experience" || (currentarr["CreditDescription"] as! String).lowercaseString == "transportation" || (currentarr["CreditDescription"] as! String).lowercaseString == "waste"){
                if((self.currentarr["CreditDescription"] as! String).lowercaseString == "waste"){
                    let rect = self.addnew.frame
                    self.addnew.setImage(UIImage(named: "addnewdata.png") as UIImage?, forState: UIControlState.Normal)
                    self.addnew.frame = rect
                    self.addnew.layer.cornerRadius = rect.size.height/2.0
                    //self.addnew.titleLabel?.text = "Add new reading"
                }else if((self.currentarr["CreditDescription"] as! String).lowercaseString == "transportation" || (self.currentarr["CreditDescription"] as! String).lowercaseString == "human experience"){
                    let rect = self.addnew.frame
                    self.addnew.setImage(UIImage(named: "invitation_icon.png") as UIImage?, forState: UIControlState.Normal)
                    self.addnew.frame = rect
                    self.addnew.layer.cornerRadius = rect.size.height/2.0
                    //self.addnew.titleLabel?.text = "Email survey"
                }
                navigate()
            }else{
                self.performSegueWithIdentifier("gotodatainput", sender: nil)
            }
        }
    }
    
    @IBAction func gotoprevious(sender: AnyObject) {
        if(currentindex>0){
            /*if(task.currentRequest != nil){
             if (task.state == NSURLSessionTaskState.Running) {
             task.cancel()
             }
             }*/
            currentindex = currentindex-1
            NSUserDefaults.standardUserDefaults().setInteger(currentindex, forKey: "selected_action")
            currentarr = currentcategory[currentindex] as! [String:AnyObject]
            if((currentarr["CreditDescription"] as! String).lowercaseString == "human experience" || (currentarr["CreditDescription"] as! String).lowercaseString == "transportation" || (currentarr["CreditDescription"] as! String).lowercaseString == "waste"){
                if((self.currentarr["CreditDescription"] as! String).lowercaseString == "waste"){
                    let rect = self.addnew.frame
                    self.addnew.setImage(UIImage(named: "addnewdata.png") as UIImage?, forState: UIControlState.Normal)
                    self.addnew.frame = rect
                    self.addnew.layer.cornerRadius = rect.size.height/2.0
                    //self.addnew.titleLabel?.text = "Add new reading"
                }else if((self.currentarr["CreditDescription"] as! String).lowercaseString == "transportation" || (self.currentarr["CreditDescription"] as! String).lowercaseString == "human experience"){
                    let rect = self.addnew.frame
                    self.addnew.setImage(UIImage(named: "invitation_icon.png") as UIImage?, forState: UIControlState.Normal)
                    self.addnew.frame = rect
                    self.addnew.layer.cornerRadius = rect.size.height/2.0
                    //self.addnew.titleLabel?.text = "Email survey"
                }
                navigate()
            }else{
                self.performSegueWithIdentifier("gotodatainput", sender: nil)
            }
        }
    }
    func checkcredit_type(tempdict:[String:AnyObject]) -> String {
        var temp = ""
        if((tempdict["Mandatory"] as! String != "X") && (tempdict["CreditcategoryDescrption"] as! String != "Performance")){
            temp = "Base scores"
        }
        else if(tempdict["CreditcategoryDescrption"] as! String == "Performance"){
            temp = "Data input"
        }else if(tempdict["Mandatory"] as! String == "X"){
            temp = "Pre-requisites"
        }
        
        return temp
    }
    
    
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
                let jsonDictionary : NSDictionary
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
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                    dispatch_async(dispatch_get_main_queue(), {
                        let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                        NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "actions_data")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        self.spinner.hidden = true
                        self.view.userInteractionEnabled = true
                        self.assignedto.text = String(format:"%@",self.currentarr["PersonAssigned"] as! String)
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
    
    @IBAction func closetheassigneecontainer(sender: AnyObject) {
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
        return teammembers[row]["Useralias"] as! String
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        assignokbtn.enabled = true
        if(statusupdate == 0){
            print(teammembers[row]["Useralias"])
        }
    }
    @IBAction func dideditassignee(sender: AnyObject) {
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
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                    let team_membersarray = jsonDictionary["EtTeamMembers"] as! NSArray
                    self.teammembers = team_membersarray.mutableCopy() as! NSMutableArray
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


    @IBAction func editassignee(sender: AnyObject) {
        
    }
    
    @IBAction func assignthemember(sender: AnyObject) {
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

