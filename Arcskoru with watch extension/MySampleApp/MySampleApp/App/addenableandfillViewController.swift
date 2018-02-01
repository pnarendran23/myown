//
//  enableandfillViewController.swift
//  Arcskoru
//
//  Created by Group X on 08/02/17.
//
//

import UIKit

class addenableandfillViewController: UIViewController, UITextFieldDelegate, UITabBarDelegate {
    @IBOutlet weak var spinner: UIView!
    var download_requests = [NSURLSession]()
    var enabled = Bool()
    var context = String()
    var prodid = String()
    var data_dict = NSMutableDictionary()
    var leedid = NSUserDefaults.standardUserDefaults().integerForKey("leed_id")
    var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
    override func viewDidAppear(animated: Bool) {
        token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        self.navigationController?.navigationBar.backItem?.title = "Manage project"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
        txtfld.delegate = self
        lbl.text = context
        if(lbl.text == "Project affiliated?"){
            lbl.text = "Is project affiliated with a higher education institute?"
        }
        self.spinner.hidden = true
        self.spinner.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
        if(context == "Previously LEED Certified?"){
            txtfld.placeholder = "Enter your previous LEED ID"
            if(data_dict["ldp_old"] is NSNull){
                switchh.on = false
            }else{
                if(data_dict["ldp_old"] as! Int == 1){
                    switchh.on = true
                    if let s = data_dict["PrevCertProdId"] as? String{
                        txtfld.text = s
                    }else{
                    }
                }else{
                    switchh.on = false
                }
            }
        }else if(context == "Contains residential units?"){
            txtfld.placeholder = "Enter number of residential units"
            if(data_dict["IsResidential"] is NSNull){
                switchh.on = false
            }else{
                if(data_dict["IsResidential"] as! Int == 1){
                    switchh.on = true
                    if let s = data_dict["noOfResUnits"] as? String{
                        txtfld.text = s
                    }else{
                    }
                }else{
                    switchh.on = false
                }
            }
        }else if(context == "Project affiliated?"){
            txtfld.placeholder = "Enter name of the school"
            if(data_dict["AffiliatedHigherEduIns"] is NSNull){
                switchh.on = false
            }else{
                if(data_dict["AffiliatedHigherEduIns"] as! Int == 1){
                    switchh.on = true
                    if let s = data_dict["nameOfSchool"] as? String{
                        txtfld.text = s
                    }else{
                    }
                }else{
                    switchh.on = false
                }
            }
        }
        
        if(switchh.on){
            txtfld.enabled = true
            txtfld.text = prodid
            txtfld.becomeFirstResponder()
        }else{
            txtfld.enabled = false
        }
        let notificationsarr = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("notifications") as! NSData) as! NSArray
        if(notificationsarr.count > 0 ){
            self.tabbar.items![4].badgeValue = "\(notificationsarr.count)"
        }else{
            self.tabbar.items![4].badgeValue = nil
        }
        self.tabbar.selectedItem = self.tabbar.items![3]
    }
    @IBOutlet weak var lbl: UILabel!
    
    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var txtfld: UITextField!
    @IBOutlet weak var switchh: UISwitch!
    @IBAction func yesno(sender: AnyObject) {
        if(context == "Previously LEED Certified?"){
            if(switchh.on){
                txtfld.enabled = true
                txtfld.becomeFirstResponder()
                data_dict["ldp_old"] = 1
            }else{
                txtfld.resignFirstResponder()
                txtfld.enabled = false
                txtfld.text = ""
                data_dict["ldp_old"] = 0
                data_dict["PrevCertProdId"] = ""
                dispatch_async(dispatch_get_main_queue(), {
                    self.spinner.hidden = false
                    self.view.userInteractionEnabled = false
                    self.saveproject(0)
                })
            }
        }else if(context == "Contains residential units?"){
            if(switchh.on){
                txtfld.enabled = true
                txtfld.becomeFirstResponder()
                data_dict["IsResidential"] = 1
            }else{
                txtfld.resignFirstResponder()
                txtfld.enabled = false
                txtfld.text = ""
                data_dict["IsResidential"] = 0
                data_dict["noOfResUnits"] = ""
                dispatch_async(dispatch_get_main_queue(), {
                    self.spinner.hidden = false
                    self.view.userInteractionEnabled = false
                    self.saveproject(0)
                })
            }
        }else if(context == "Project affiliated?"){
            if(switchh.on){
                txtfld.enabled = true
                txtfld.becomeFirstResponder()
                data_dict["AffiliatedHigherEduIns"] = 1
            }else{
                txtfld.resignFirstResponder()
                txtfld.enabled = false
                txtfld.text = ""
                data_dict["AffiliatedHigherEduIns"] = 0
                data_dict["nameOfSchool"] = ""
                dispatch_async(dispatch_get_main_queue(), {
                    self.spinner.hidden = false
                    self.view.userInteractionEnabled = false
                    self.saveproject(0)
                })
            }
        }
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(context == "Previously LEED Certified?"){
            data_dict["PrevCertProdId"] = txtfld.text
        }else if(context == "Contains residential units?"){
            data_dict["noOfResUnits"] = txtfld.text
        }else if(context == "Project affiliated?"){
            data_dict["nameOfSchool"] = txtfld.text
        }
        
        
        dispatch_async(dispatch_get_main_queue(), {
            self.spinner.hidden = false
            self.view.userInteractionEnabled = false
            self.saveproject(0)
        })
        
        return true
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
    
    @IBAction func saveproject(selected: Int) {
        //{"name":"Test Auth","street":"2101 L Street NW","city":"Test city","state":"DC","country":"US","year_constructed":null,"gross_area":10000,"operating_hours":null,"occupancy":null,"confidential":false,"organization":null,"ownerType":null,"IsLovRecert":false,"PrevCertProdId":null,"OtherCertProg":null,"IsResidential":false,"noOfResUnits":null,"AffiliatedHigherEduIns":false,"nameOfSchool":null,"noOfFloors":null,"intentToPrecertify":false,"targetCertDate":null,"populationDayTime":null,"populationNightTime":null,"manageEntityName":null,"manageEntityAdd1":null,"managEntityAdd2":null,"manageEntityCity":null,"manageEntityState":null,"manageEntityCountry":null,"unitType":"IP"}
        
        
        print(data_dict)
        var payload = NSMutableString()
        payload.appendString("{")
        
        
        for (key, value) in data_dict {
            if(value is String){
                payload.appendString("\"\(key)\": \"\(value)\",")
            }else if(value is Int){
                payload.appendString("\"\(key)\": \(value),")
            }
        }
        var str = payload as! String
        payload.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
        payload.appendString("}")
        str = payload as! String
        print(str)
        
        
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/?recompute_score=1",credentials().domain_url, leedid))
        print(url?.absoluteURL)
        var subscription_key = credentials().subscription_key
        var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "PUT"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var httpbody = str
        request.HTTPBody = httpbody.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        var task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
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
                        self.spinner.hidden = true
                        self.view.userInteractionEnabled = true
                    })
                }else{
                    print(data)
                    var jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        print(jsonDictionary)
                        //self.tableview.reloadData()
                        // self.buildingactions(subscription_key, leedid: leedid)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.updateproject()
                        })
                    } catch {
                        print(error)
                    }
            }
            
        }
        task.resume()
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
    
    func updateproject(){
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/",credentials().domain_url,leedid))
        print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        var task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
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
                        self.spinner.hidden = true
                        self.view.userInteractionEnabled = true
                    })
                }else{
                    print(data)
                    var jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        print(jsonDictionary)
                        var datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                        NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "building_details")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "row")
                        dispatch_async(dispatch_get_main_queue(), {
                            self.spinner.hidden = true
                            self.view.userInteractionEnabled = true
                            self.navigationController?.popViewControllerAnimated(true)
                        })
                        //self.tableview.reloadData()
                        // self.buildingactions(subscription_key, leedid: leedid)
                    } catch {
                        print(error)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.spinner.hidden = true
                            self.view.userInteractionEnabled = true
                        })
                    }
            }
            
        }
        task.resume()
        
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
    
}
