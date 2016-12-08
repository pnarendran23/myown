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
    var domain_url = ""
    @IBOutlet weak var enddate: UITextField!
    var date2:NSDate!
    var currentindex = 0
    var date1 : NSDate!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("datar %@", listall().dataarr)
        navigationController?.delegate = self
        domain_url = credentials().domain_url
        self.updatebtn.enabled = true
        if(addreading == 1){
            deletebtn.hidden = true
            updatebtn.setTitle("Create reading", forState: UIControlState.Normal)
        }else{
            deletebtn.hidden = false
            var dateFormat = NSDateFormatter()
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
    
    

    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? listall {
            var datarr = controller.dataarr.mutableCopy()
            if(addreading == 0){
            datarr.replaceObjectAtIndex(currentindex, withObject: dataarr)
            controller.dataarr = datarr as! NSMutableArray
            }else{
                datarr.addObject(dataarr)
                controller.dataarr = datarr as! NSMutableArray
            }
            print(datarr)
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
        
        var date = dateFormatter.dateFromString("01/01/2012")!
        datePickerView.minimumDate = date
        datePickerView.maximumDate = NSDate()
        sender.inputView = datePickerView
        if(date1 == nil){
            
        }else{
        datePickerView.date = date1
        }
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    
    
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
    
    @IBAction func dideditenddate(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        var date = dateFormatter.dateFromString("01/01/2012")!
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
        var consumption_ID = dataarr["id"] as! Int
        var meter_ID = dataarr["meter"]!["id"] as! Int
        var leedid = dataarr["building"]!["leed_id"] as! Int
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/meters/ID:%d/consumption/ID:%d/?recompute_score=1",domain_url, leedid,meter_ID, consumption_ID))
        print(url?.absoluteURL)
            var formatter = NSDateFormatter()
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
            var subscription_key = credentials().subscription_key
                var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "PUT"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var httpbody = String(format: "{\"start_date\":\"%@\",\"end_date\":\"%@\",\"reading\":%d}",startdatestr,enddatestr,Int(reading.text!)!)
        request.HTTPBody = httpbody.dataUsingEncoding(NSUTF8StringEncoding)
        
        var task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
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
                    self.navigationController?.popViewControllerAnimated(true)
                    
                    })
                } catch {
                    print(error)
                }
            }
            
        }
        task.resume()
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    @IBAction func editreadings(sender: AnyObject) {
        
        
    }
    @IBOutlet weak var deletebtn: UIButton!

    @IBAction func itisediting(sender: AnyObject) {
        
        
    }
    @IBAction func delbutton(sender: AnyObject) {
    }
    
    
    
}
