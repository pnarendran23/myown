//
//  readingvc.swift
//  LEEDOn
//
//  Created by Group X on 25/11/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class readingvc: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var startdate: UITextField!
    @IBOutlet weak var reading: UITextField!
    var dataarr = [String:AnyObject]()
    var addreading = 0
    var id = 0
    var domain_url = ""
    var listofreadings = NSMutableArray()
    @IBOutlet weak var enddate: UITextField!
    var date2:NSDate!
    var currentindex = 0
    var date1 : NSDate!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
        self.spinner.hidden = true
        self.spinner.layer.cornerRadius = 5
        print("datar %@", listofreadings,id)
        navigationController?.delegate = self
        domain_url = credentials().domain_url
        //listofreadings = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("selreading") as! NSData)?.mutableCopy() as! NSMutableArray
        //id = NSUserDefaults.standardUserDefaults().integerForKey("meterID")
        self.updatebtn.enabled = true
        if(addreading == 1){
            updatebtn.setTitle("Create reading", forState: UIControlState.Normal)
        }else{
            let dateFormat = NSDateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd"
            var str = dataarr["start_date"] as! String
            date1 = dateFormat.dateFromString(str)!
            dateFormat.dateFormat = "MMM dd,yyyy"
            str = dateFormat.stringFromDate(date1)
            startdate.text = str
            
            var str2 = dataarr["end_date"] as! String
            dateFormat.dateFormat = "yyyy-MM-dd"
            date2 = dateFormat.dateFromString(str2)!
            dateFormat.dateFormat = "MMM dd,yyyy"
            str2 = dateFormat.stringFromDate(date2)
            enddate.text = str2
            reading.text = String(format:"%d",dataarr["reading"] as! Int)
            updatebtn.setTitle("Update reading", forState: UIControlState.Normal)
        }
        //enddate.inputView = datepicker
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        var buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        self.navigationItem.title = buildingdetails["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as? String
    }
    
    func buildingactions(subscription_key:String, leedid: Int){
        let url = NSURL.init(string: String(format: "%@assets/LEED:%d/actions/",credentials().domain_url,leedid))
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
                        let jsonDictionary : NSDictionary
                        do {
                            jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                            if(jsonDictionary["error"] != nil){
                                if(jsonDictionary["error"]![0]!["message"] != nil){
                                    self.showalert(jsonDictionary["error"]![0]!["message"]!! as! String, title: "Error", action: "OK")
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
                    print(data)
                    let jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        print(jsonDictionary)
                        if(self.addreading == 1){
                        self.listofreadings.addObject(self.dataarr)
                        }
                        let datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                        NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "actions_data")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "row")
                        dispatch_async(dispatch_get_main_queue(), {
                            self.spinner.hidden = true
                            self.view.userInteractionEnabled = true
                            self.navigationController?.popViewControllerAnimated(true)
                        })
                        
                    } catch {
                        print(error)
                        dispatch_async(dispatch_get_main_queue(), {
                            let jsonDictionary : NSDictionary
                            do {
                                jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                                if(jsonDictionary["error"] != nil){
                                    if(jsonDictionary["error"]![0]!["message"] != nil){
                                        self.showalert(jsonDictionary["error"]![0]!["message"]!! as! String, title: "Error", action: "OK")
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
            
        }
        task.resume()
    }

    

    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? listall {
            let datarray = controller.dataarr.mutableCopy()
            if(addreading == 0){
                datarray.replaceObjectAtIndex(currentindex, withObject: dataarr)
                controller.dataarr = datarray as! NSMutableArray
            }else{
                controller.dataarr = listofreadings
            }
            print(datarray)
            // Here you pass the data back to your original view controller
        }
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
    @IBAction func startediting(sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let date = dateFormatter.dateFromString("01/01/2012")!
        datePickerView.minimumDate = date
        datePickerView.maximumDate = NSDate()
        sender.inputView = datePickerView
        if(date1 == nil){
            
        }else{
        datePickerView.date = date1
        }
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    @IBOutlet weak var spinner: UIView!
    
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        
        startdate.text = dateFormatter.stringFromDate(sender.date)
        
        
    }
    func datePickerValueChangedforenddate(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        enddate.text = dateFormatter.stringFromDate(sender.date)
        
        
    }

    @IBAction func startdateeditend(sender: AnyObject) {
        print("Finished")
    }
    let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
    
    @IBAction func dideditenddate(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.dateFromString("01/01/2012")!
        if(startdate.text != ""){
            if(date1 == nil){
        datePickerView.minimumDate = date
            }else{
        datePickerView.minimumDate = date1
            }
        }else{
        datePickerView.minimumDate = date
        }
        datePickerView.maximumDate = NSDate()
        if(date2 == nil){
            datePickerView.date = NSDate()
        }else{
            datePickerView.date = date2
        }
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChangedforenddate), forControlEvents: UIControlEvents.ValueChanged)
    }
    @IBOutlet weak var updatebtn: UIButton!
    
    @IBAction func updateit(sender: AnyObject) {
        // UIButton
        self.spinner.hidden = false
        self.view.userInteractionEnabled = false
        if(addreading == 0){
        let consumption_ID = dataarr["id"] as! Int
        let meter_ID = dataarr["meter"]!["id"] as! Int
        let leedid = dataarr["building"]!["leed_id"] as! Int
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/meters/ID:%d/consumption/ID:%d/?recompute_score=1",domain_url, leedid,meter_ID, consumption_ID))
        print(url?.absoluteURL)
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MMM dd,yyyy"
            var startdatestr = ""
            var enddatestr = ""
            var dated1 = NSDate()
            var dated2 = NSDate()
            dated1 = formatter.dateFromString(startdate.text!)!
            dated2 = formatter.dateFromString(enddate.text!)!
            formatter.dateFormat = "yyyy-MM-dd"
            startdatestr = formatter.stringFromDate(dated1)
            enddatestr = formatter.stringFromDate(dated2)
            dataarr["start_date"] = startdatestr
            dataarr["end_data"] = enddatestr
            dataarr["reading"] = Int(reading.text!)!
            let subscription_key = credentials().subscription_key
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "PUT"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var httpbody = String(format: "{\"start_date\":\"%@\",\"end_date\":\"%@\",\"reading\":%d}",startdatestr,enddatestr,Int(reading.text!)!)
        
        print(httpbody)
        request.HTTPBody = httpbody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
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
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                    dispatch_async(dispatch_get_main_queue(), {
                        if(jsonDictionary["non_field_errors"] != nil){
                            self.showalert(jsonDictionary["non_field_errors"] as! String, title: "Error", action: "OK")
                        }else{
                            self.showalert("Something went wrong. Please try again later", title: "Error", action: "OK")
                        }
                        
                    })
                }catch{
                    
                }
            }else{
                
                print(data)
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                    self.dataarr = jsonDictionary as! [String:AnyObject]
                    //self.tableview.reloadData()
                    // self.buildingactions(subscription_key, leedid: leedid)
                    dispatch_async(dispatch_get_main_queue(), {
                    self.buildingactions(subscription_key, leedid: leedid)
                    
                    })
                } catch {
                    print(error)
                }
            }
            
        }
        task.resume()
        }else{
            if(startdate.text?.characters.count > 0 && enddate.text?.characters.count > 0 && reading.text?.characters.count > 0) {
            let meter_ID = id
            print(id)
            let leedid = NSUserDefaults.standardUserDefaults().integerForKey("leed_id")
            let url = NSURL.init(string:String(format: "%@assets/LEED:%d/meters/ID:%d/consumption/?recompute_score=1",domain_url, leedid,meter_ID))
            print(url?.absoluteURL)
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MMM dd,yyyy"
            var startdatestr = ""
            var enddatestr = ""
            var dated1 = NSDate()
            var dated2 = NSDate()
            dated1 = formatter.dateFromString(startdate.text!)!
            dated2 = formatter.dateFromString(enddate.text!)!
            formatter.dateFormat = "yyyy-MM-dd"
            startdatestr = formatter.stringFromDate(dated1)
            enddatestr = formatter.stringFromDate(dated2)
                dataarr["start_date"] = startdatestr
                dataarr["end_data"] = enddatestr
                dataarr["reading"] = Int(reading.text!)!
            let subscription_key = credentials().subscription_key
            let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
            
            let request = NSMutableURLRequest.init(URL: url!)
            request.HTTPMethod = "POST"
            request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
            request.addValue("application/json", forHTTPHeaderField:"Content-type" )
            request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
            let httpbody = String(format: "{\"start_date\":\"%@\",\"end_date\":\"%@\",\"reading\":%d}",startdatestr,enddatestr,Int(reading.text!)!)
                print("HTTP body",httpbody,startdatestr,enddatestr)
            request.HTTPBody = httpbody.dataUsingEncoding(NSUTF8StringEncoding)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
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
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 && httpStatus.statusCode != 201 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    var jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()).mutableCopy() as! NSDictionary
                        print(jsonDictionary)
                        dispatch_async(dispatch_get_main_queue(), {
                            if(jsonDictionary["non_field_errors"] != nil){
                            self.showalert("Reading for the mentioned period already exists", title: "Error", action: "OK")
                            }else{
                                self.showalert("Something went wrong. Please try again later", title: "Error", action: "OK")
                            }
                            
                        })
                    }catch{
                        
                    }
                }else{
                    print(data)
                    var jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        print(jsonDictionary)
                        self.dataarr = jsonDictionary as! [String:AnyObject]
                        //self.tableview.reloadData()
                        // self.buildingactions(subscription_key, leedid: leedid)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.buildingactions(subscription_key, leedid: leedid)
                            
                        })
                    } catch {
                        print(error)
                    }
                }
                
            }
            task.resume()
        }
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

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    @IBAction func editreadings(sender: AnyObject) {
        
        
    }

    @IBAction func itisediting(sender: AnyObject) {
        
        
    }
    @IBAction func delbutton(sender: AnyObject) {
    }
    
    
    
}
