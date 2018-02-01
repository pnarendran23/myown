//
//  ViewController.swift
//  LEEDOn
//
//  Created by Group X on 15/11/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit
class addnew: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    var years = NSMutableArray()
    var download_requests = [NSURLSession]()
    var listarray = NSArray()
    var currentyeararray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.layer.cornerRadius = 5
        self.spinner.hidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        unit.delegate = self
        unit.tag = 2
        value.tag = 1
        value.delegate = self
        do {
            
            
            if let file = NSBundle.mainBundle().URLForResource("additional_data", withExtension: "json") {
                let data = try NSData(contentsOfURL: file)
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                let name: AnyClass! = object_getClass(json)
                print(name)
                if let object = json as? NSArray {
                    print("json object ",object)
                    listarray = object
                }
                
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    print(object)
                } else if let object = json as? [Any] {
                    // json is an array
                    print(object)
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error)
        }
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy"
        var i2  = Int(formatter.stringFromDate(NSDate()))!
        
        //Create Years Array from 1960 to This year
        years = NSMutableArray()
        for i in (1900 ... i2) .reverse(){
            years.addObject("\(i)")
        }
        
        
        
    }
    var selected_year = ""
    var currentfield = ""
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    @IBOutlet weak var spinner: UIView!
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected_year = years[row] as! String
        
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return years[row] as! String
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        tableView.layer.backgroundColor = UIColor.clearColor().CGColor
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listarray.count
    }
    var currentarr = NSDictionary()
    var listofdata = NSArray()
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.contentInset = UIEdgeInsetsZero
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.backgroundColor = UIColor.clearColor()
        cell.contentView.backgroundColor = UIColor.clearColor()
        var dict = listarray[indexPath.row] as! [String:AnyObject]
        cell.textLabel?.text = "\(dict["name"] as! String)"
        cell.textLabel?.numberOfLines = 4
        cell.textLabel?.font = UIFont.init(name: "OpenSans", size: 13)
        if(cell.textLabel?.text == selected_field){
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    var currentval = ""
    var currentunit = ""
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField.tag == 1){
            currentval = textField.text!
        }else{
            currentunit = textField.text!
        }
        textField.resignFirstResponder()
        return true
    }
    
    var selected_field = ""
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            selected_field = (cell?.textLabel?.text)!
        for item in listarray{
            var dict = item as! [String:AnyObject]
            if(dict["name"] as! String == selected_field){
                let tempstring = dict["field"] as! String
                let arr = tempstring.componentsSeparatedByString("_num")
                currentfield = arr[0]
                break
            }
        }
        print(currentfield,selected_field)
        tableView.reloadData()
    }
    
    
    
    
    @IBOutlet weak var value: UITextField!
    
    @IBAction func submit(sender: AnyObject) {
        if(value.text?.characters.count > 0 && unit.text?.characters.count > 0 && selected_year != "" && currentfield != ""){
        currentyeararray = NSMutableArray()
        for item in listofdata{
            var dict = item as! NSArray
            if(dict[3] as! String == selected_year){
                currentyeararray.addObject(dict)
            }
        }
        var dict = NSMutableArray()
        dict.addObject(selected_field)
        dict.addObject(value.text!)
        dict.addObject(unit.text!)
        dict.addObject(selected_year)
        dict.addObject(currentfield)
        currentyeararray.addObject(dict)
        print("Updated array",currentyeararray)
            addnewyearlydata(currentyeararray, actionID: currentarr["CreditShortId"] as! String)
        }else{
            print("Missing fields")
            var temparr = NSMutableArray()
            if(value.text?.characters.count == 0){
               temparr.addObject("Value")
            }
            if(unit.text?.characters.count == 0){
                temparr.addObject("Unit")
            }
            if(selected_year == ""){
                temparr.addObject("Year to be selected")
            }
            if(currentfield == ""){
                temparr.addObject("Choose field which are applicable for your project")
            }
            
            var string = temparr.componentsJoinedByString("\n")
            print(string)
            let alert = UIAlertController(title: "Required fields are found empty", message: "Please kindly fill out the below fields :- \n \(string)", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    func addnewyearlydata(arr : NSMutableArray, actionID : String){
        //{"data":"{'emission_intensity_num':'12','emission_intensity_num_unit':'E','emission_intensity_num_name':'Emission Intensity'}"}
        self.spinner.hidden = false
        var payload = NSMutableString()
        payload.appendString("{\"data\":\"{")
        
        for item in arr{
            var a = item as! NSArray
            payload.appendString("'\(a[4] as! String)_num':'\(a[1] as! String)',")
            payload.appendString("'\(a[4] as! String)_num_unit':'\(a[2] as! String)',")
            payload.appendString("'\(a[4] as! String)_num_name':'\(a[0] as! String)',")
        }
        var str = payload as! String
        payload.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
        payload.appendString("}\"}")
        str = payload as! String
        
        var leedid = NSUserDefaults.standardUserDefaults().integerForKey("leed_id")
        
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@/data/%@/?recompute_score=1",credentials().domain_url, leedid,actionID,selected_year))
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
                            self.navigationController?.popViewControllerAnimated(true)
                        })
                    } catch {
                        print(error)
                    }
            }
            
        }
        task.resume()
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
    
    
    
    @IBOutlet weak var unit: UITextField!
    @IBOutlet weak var dpicker: UIPickerView!
    
}

