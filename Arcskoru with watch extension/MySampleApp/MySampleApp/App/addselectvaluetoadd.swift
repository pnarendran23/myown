//
//  selectvalue.swift
//  Arcskoru
//
//  Created by Group X on 08/02/17.
//
//

import UIKit

class addselectvaluetoadd: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITabBarDelegate, UINavigationControllerDelegate  {
    var PICKER_MAX = 2017
    var leedid = NSUserDefaults.standardUserDefaults().integerForKey("leed_id")
    var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
    var PICKER_MIN = 1900
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var spinner: UIView!
    @IBOutlet weak var switchh: UISwitch!
    var download_requests = [NSURLSession]()
    var currentvalue = ""
    var currenttitle = String()
    var data_dict = NSMutableDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
        self.spinner.layer.cornerRadius = 5
        self.spinner.hidden = true
        picker.delegate = self
        picker.dataSource = self
        let filteritem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(done(_:)))
        self.navigationItem.rightBarButtonItem = filteritem
        self.navigationItem.setRightBarButtonItem(filteritem, animated: true)
        lbl.text = currenttitle
        if(currenttitle == "Year built"){
            switchh.hidden = true
            print(currentvalue)
            if(currentvalue != ""){
                picker.selectRow((PICKER_MAX - PICKER_MIN) -  (PICKER_MAX - Int(currentvalue)!), inComponent: 0, animated: true)
            }else{
                picker.selectRow(0, inComponent: 0, animated: true)
            }
        }else if(currenttitle == "Floors above grounds"){
            switchh.hidden = true
            if(currentvalue != ""){
                picker.selectRow((PICKER_MAX - PICKER_MIN) -  (PICKER_MAX - Int(currentvalue)!), inComponent: 0, animated: true)
            }else{
                picker.selectRow(0, inComponent: 0, animated: true)
            }
        }
        let notificationsarr = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("notifications") as! NSData) as! NSArray
        if(notificationsarr.count > 0 ){
            self.tabbar.items![4].badgeValue = "\(notificationsarr.count)"
        }else{
            self.tabbar.items![4].badgeValue = nil
        }
        self.tabbar.selectedItem = self.tabbar.items![3]
        self.tabbar.hidden = true
        //nav.setItems([navItem], animated: false);
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var tabbar: UITabBar!
    
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
    @IBOutlet weak var picker: UIPickerView!
    
    func done(sender: UIBarButtonItem){
        dispatch_async(dispatch_get_main_queue(), {
            self.spinner.hidden = false
            self.view.userInteractionEnabled = false
            //self.saveproject(0)
            self.navigationController?.popViewControllerAnimated(true)
        })
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (PICKER_MAX - PICKER_MIN + 1)
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + PICKER_MIN)"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentvalue = "\(row + PICKER_MIN)"
        if(currenttitle == "Year built"){
            data_dict["year_constructed"] = currentvalue
        }else if(currenttitle == "Floors above grounds"){
            data_dict["noOfFloors"] = currentvalue
        }
        print(currentvalue)
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? addnewproject {
            controller.data_dict = data_dict    // Here you pass the data back to your original view controller
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        self.navigationController?.delegate = self
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        self.navigationController?.delegate = nil
    }
    
    @IBAction func saveproject(selected: Int) {
        //{"name":"Test Auth","street":"2101 L Street NW","city":"Test city","state":"DC","country":"US","year_constructed":null,"gross_area":10000,"operating_hours":null,"occupancy":null,"confidential":false,"organization":null,"ownerType":null,"IsLovRecert":false,"PrevCertProdId":null,"OtherCertProg":null,"IsResidential":false,"noOfResUnits":null,"AffiliatedHigherEduIns":false,"nameOfSchool":null,"noOfFloors":null,"intentToPrecertify":false,"targetCertDate":null,"populationDayTime":null,"populationNightTime":null,"manageEntityName":null,"manageEntityAdd1":null,"managEntityAdd2":null,"manageEntityCity":null,"manageEntityState":null,"manageEntityCountry":null,"unitType":"IP"}
        
        
        dispatch_async(dispatch_get_main_queue(), {
            self.spinner.hidden = false
            self.view.userInteractionEnabled = false
        })
        
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
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401 {           // check for http errors
                dispatch_async(dispatch_get_main_queue(), {
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                })
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
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401 {           // check for http errors
                dispatch_async(dispatch_get_main_queue(), {
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                })
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
    
    func showalert(message:String, title:String, action:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                self.spinner.hidden = true
                self.view.userInteractionEnabled = true
            })
            
        }
        let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
        
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
