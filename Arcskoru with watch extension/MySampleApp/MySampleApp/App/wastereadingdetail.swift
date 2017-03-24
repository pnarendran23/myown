//
//  wastereadingdetail.swift
//  Arcskoru
//
//  Created by Group X on 02/03/17.
//
//

import UIKit

class wastereadingdetail: UIViewController, UINavigationControllerDelegate {
var meters = NSMutableArray()
var row = 0
var adding = 0
    var dict = [String:AnyObject]()
    var tempdict = [String:AnyObject]()
    var leedid = NSUserDefaults.standardUserDefaults().integerForKey("leed_id")
    var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
    @IBOutlet weak var wastegeneratedtxt: UITextField!
    @IBOutlet weak var wastedivertedtxt: UITextField!
    @IBOutlet weak var startdatetxt: UITextField!
    
    @IBOutlet weak var enddatetxt: UITextField!
    
    @IBOutlet weak var spinner: UIView!
    @IBOutlet weak var ctrl: UISegmentedControl!
    @IBAction func segctrl(sender: AnyObject) {
        if(ctrl.selectedSegmentIndex == 0){
            tempdict["unit"] = "lbs"
        }else if(ctrl.selectedSegmentIndex == 1){
            tempdict["unit"] = "kgs"
        }else{
            tempdict["unit"] = "tons"
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
    }
    
    @IBAction func save(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            self.view.userInteractionEnabled = true
            self.spinner.hidden = false
            if(self.adding == 0){
                self.updatereading()
            }else{
                self.addreading()
            }
        })
        
    }
    @IBOutlet weak var savebtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
        self.spinner.hidden = true
        self.spinner.layer.cornerRadius = 5
        self.navigationController?.delegate = self
        if(adding == 0){
        dict = meters.objectAtIndex(row) as! [String:AnyObject]
        var format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        var str1 = format.dateFromString(dict["start_date"] as! String)
        var str2 = format.dateFromString(dict["end_date"] as! String)
        format.dateFormat = "MMM dd,yyyy"
        var startdate = format.stringFromDate(str1!)
        var enddate = format.stringFromDate(str2!)
        print(startdate,enddate)
        startdatetxt.text = "\(startdate)"
        enddatetxt.text = "\(enddate)"
        var diverted = 0
        var generated = 0
        
        if(dict["waste_diverted"] == nil || dict["waste_diverted"] is NSNull){
            
        }else{
            diverted = dict["waste_diverted"] as! Int
        }
        wastedivertedtxt.text = "\(diverted)"
        
        if(dict["waste_generated"] == nil || dict["waste_generated"] is NSNull){
            
        }else{
            generated = dict["waste_generated"] as! Int
        }
        
        if(dict["unit"] == nil || dict["unit"] is NSNull){
            
        }else{
            if(dict["unit"] as! String == "lbs"){
                ctrl.selectedSegmentIndex = 0
            }
            if(dict["unit"] as! String == "kgs"){
                ctrl.selectedSegmentIndex = 1
            }
            if(dict["unit"] as! String == "tons"){
                ctrl.selectedSegmentIndex = 2
            }
        }
        
        wastegeneratedtxt.text = "\(generated)"
        }
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let date = dateFormatter.dateFromString("01/01/2012")!
        datePickerView.minimumDate = date
        datePickerView.maximumDate = NSDate()
        startdatetxt.inputView = datePickerView
        datePickerView.date = date        
        datePickerView.addTarget(self, action: #selector(self.startdateValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
        
        let datePickerView1:UIDatePicker = UIDatePicker()
        
        datePickerView1.datePickerMode = UIDatePickerMode.Date
        datePickerView1.minimumDate = date
        datePickerView1.maximumDate = NSDate()
        enddatetxt.inputView = datePickerView1
        datePickerView1.date = date
        datePickerView1.addTarget(self, action: #selector(self.enddateValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
        tempdict = dict
        
        if(adding == 1){
            tempdict["unit"] = "lbs"
            ctrl.selectedSegmentIndex = 0
        }
        
        // Do any additional setup after loading the view.
    }
    
    func startdateValueChanged(sender:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        startdatetxt.text = dateFormatter.stringFromDate(sender.date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var str = dateFormatter.stringFromDate(sender.date)
        tempdict["start_date"] = str
    }
    
    func enddateValueChanged(sender:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        enddatetxt.text = dateFormatter.stringFromDate(sender.date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var str = dateFormatter.stringFromDate(sender.date)
        tempdict["end_date"] = str
    }

    
    func updatereading(){
        
        var generated = 0
        var diverted = 0
        if(wastegeneratedtxt.text != "" && wastedivertedtxt.text != ""){
                generated = Int(wastegeneratedtxt.text!)!
                diverted = Int(wastedivertedtxt.text!)!
            if(generated > diverted){
                //Yes
                var payload = NSMutableString()
                payload.appendString("{")
                var str = payload as! String
                payload.appendString("\"start_date\": \"\(tempdict["start_date"]!)\",")
                payload.appendString("\"end_date\":\"\(tempdict["end_date"]!)\",")
                payload.appendString("\"waste_generated\":\(generated),")
                payload.appendString("\"waste_diverted\":\(diverted),")
                payload.appendString("\"unit\": \"\(tempdict["unit"] as! String)\"")
                payload.appendString("}")
                str = payload as! String
                print(str,tempdict["id"])
                let url = NSURL.init(string:String(format: "%@assets/LEED:%d/waste/ID:%d/?recompute_score=1",credentials().domain_url, leedid, tempdict["id"] as! Int))
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
                //download_requests.append(session)
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
                                self.tempdict = jsonDictionary as! [String : AnyObject]
                                self.dict =  self.tempdict
                                
                                //self.tableview.reloadData()
                                // self.buildingactions(subscription_key, leedid: leedid)
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.spinner.hidden = true
                                    self.navigationController?.popViewControllerAnimated(true)
                                })
                            } catch {
                                print(error)
                            }
                    }
                    
                }
                task.resume()
            }else{
                dispatch_async(dispatch_get_main_queue(), {
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                self.maketoast("Generated waste shouldn't be lesser than the waste diverted")
                })
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), {
                self.spinner.hidden = true
                self.view.userInteractionEnabled = true
            self.maketoast("All fields are mandatory")
            })
        }
    }

    
    func addreading(){
        
        var generated = 0
        var diverted = 0
        if(wastegeneratedtxt.text != "" && wastedivertedtxt.text != "" && startdatetxt.text != "" && enddatetxt.text != ""){
            generated = Int(wastegeneratedtxt.text!)!
            diverted = Int(wastedivertedtxt.text!)!
            if(generated > diverted){
                //Yes
                var payload = NSMutableString()
                payload.appendString("{")
                var str = payload as! String
                payload.appendString("\"start_date\": \"\(tempdict["start_date"]!)\",")
                payload.appendString("\"end_date\":\"\(tempdict["end_date"]!)\",")
                payload.appendString("\"waste_generated\":\(generated),")
                payload.appendString("\"waste_diverted\":\(diverted),")
                payload.appendString("\"unit\": \"\(tempdict["unit"] as! String)\"")
                payload.appendString("}")
                str = payload as! String
                print(str,tempdict["id"])
                let url = NSURL.init(string:String(format: "%@assets/LEED:%d/waste/?recompute_score=1",credentials().domain_url, leedid))
                print(url?.absoluteURL)
                var subscription_key = credentials().subscription_key
                var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
                
                let request = NSMutableURLRequest.init(URL: url!)
                request.HTTPMethod = "POST"
                request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
                request.addValue("application/json", forHTTPHeaderField:"Content-type" )
                request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
                var httpbody = str
                request.HTTPBody = httpbody.dataUsingEncoding(NSUTF8StringEncoding)
                let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
                //download_requests.append(session)
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
                        if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 201 {           // check for http errors
                            print("statusCode should be 200, but is \(httpStatus.statusCode)")
                            print("response = \(response)")
                            print(data)
                            var jsonDictionary : NSDictionary
                            do {
                                jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                                print(jsonDictionary)
                                self.tempdict = jsonDictionary as! [String : AnyObject]
                                self.meters.addObject(self.tempdict)
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.navigationController?.popViewControllerAnimated(true)
                                })
                            } catch {
                                print(error)
                            }
                        }else{
                            dispatch_async(dispatch_get_main_queue(), {
                                self.spinner.hidden = true
                                self.view.userInteractionEnabled = true
                            })
                    }
                    
                }
                task.resume()
            }else{
                dispatch_async(dispatch_get_main_queue(), {
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    self.maketoast("Generated waste shouldn't be lesser than the waste diverted")
                })
                
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), {
            self.spinner.hidden = true
            self.view.userInteractionEnabled = true
            self.maketoast("All fields are mandatory")
            })
        }
    }

    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if(viewController is wastereadings){
            var v = viewController as! wastereadings
            if(adding == 0){
                self.meters.replaceObjectAtIndex(row, withObject: self.dict)
            }
            v.meters = self.meters
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
