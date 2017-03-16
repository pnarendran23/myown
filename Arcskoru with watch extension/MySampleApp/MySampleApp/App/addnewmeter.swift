//
//  addnewmeter.swift
//  LEEDOn
//
//  Created by Group X on 05/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class addnewmeter: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var assetname: UILabel!

    @IBOutlet weak var metertypepicker: UIPickerView!
    @IBOutlet weak var unitspicker: UIPickerView!
    @IBOutlet weak var units: UISegmentedControl!
    @IBOutlet weak var metername: UITextField!
    var leedid = NSUserDefaults.standardUserDefaults().integerForKey("leed_id")
    var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
    var currentmeterdata = [String:AnyObject]()
    var electricityarr = NSMutableArray()
    var waterarr = NSMutableArray()
    var othersarr = NSMutableArray()
    var metertype = NSArray()
    var currentunit = NSArray()
    var currentmetertype = NSArray()
    var unitsarr = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
        metername.delegate = self
        spinner.layer.cornerRadius = 5
        getmetercategories()
        metertype = [["Generated onsite - solar","Purchased from Grid"],["Municipality supplied potable water","Municipality supplied reclaimed water","reclaimed onsite"],["District Strem","District Hot water","District chilled water (Electric driven chiller)","District chilled water(Absorption chiller using natural gas)","District chilled water(Engine driven chiller using natural gas)","Natural gas","Fuel oil","Wood","Propane","Liquid propane","Kerosene","Fuel oil (No.1)","Fuel oil (No.5 & No.6)","Coal (anthracite)","Coal (bituminous)","Coke","Fuel oil","Diesel"]]
        
        unitsarr = [["kWh","MWh","MBtu","kBtu","Gj"],["gal","kGal","MGal","cf","ccf","kcf","mcf","I","cu m","gal(UK)","kGal(UK)","kGal(UK)","MGal(UK)"],["kBtu","MBtu","cf","kcf","mcf","therms","cu m","Gj","kWh","MWh"]]
        if(currentmeterdata.count == 0){
            currentunit = unitsarr[0] as! NSArray
            currentmetertype = metertype[0] as! NSArray
            unitschange(units)
        }
        // Do any additional setup after loading the view.
    }
    
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
   var download_requests = [NSURLSession]()
    
    func getmetercategories(){
        let url = NSURL.init(string:String(format: "%@fuel/category/?page_size=300",credentials().domain_url))
        print(url?.absoluteURL)
        var subscription_key = credentials().subscription_key
        var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
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
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
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
                    var jsonDictionary = NSArray()
                    do {
                        var dict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        if(dict["results"] != nil){
                            jsonDictionary = dict["results"] as! NSArray
                        }
                        
                        print(jsonDictionary)
                        for item in jsonDictionary{
                            if(item["kind"] != nil){
                                if(item["kind"]  as! String == "electricity"){
                                    self.electricityarr.addObject(item)
                                }
                                
                                if(item["kind"]  as! String == "water"){
                                    self.waterarr.addObject(item)
                                    
                                }
                                
                                if(item["kind"]  as! String == "fuel" || item["kind"]  as! String == "Other"){
                                     self.othersarr.addObject(item)
                                }
                            }
                        }
                        //self.tableview.reloadData()
                        // self.buildingactions(subscription_key, leedid: leedid)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.spinner.hidden = true
                        })
                    } catch {
                        print(error)
                    }
            }
            
        }
        task.resume()
  
    }
    @IBOutlet weak var spinner: UIView!
    
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
    
    @IBAction func unitschange(sender: AnyObject) {
        if(units.selectedSegmentIndex == 0){
            units.tintColor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
            currentunit = unitsarr[0] as! NSArray
            currentmetertype = electricityarr
            unitspicker.reloadAllComponents()
            metertypepicker.reloadAllComponents()
        }else if(units.selectedSegmentIndex == 1){
            units.tintColor = UIColor.init(red: 0.303, green: 0.751, blue: 0.94, alpha: 1)
            currentunit = unitsarr[1] as! NSArray
            //currentmetertype = metertype[1] as! NSArray
            currentmetertype = waterarr
            unitspicker.reloadAllComponents()
            metertypepicker.reloadAllComponents()
        }else{
            units.tintColor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
            currentunit = unitsarr[2] as! NSArray
            currentmetertype = metertype[2] as! NSArray
            currentmetertype = othersarr
            unitspicker.reloadAllComponents()
            metertypepicker.reloadAllComponents()
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == metertypepicker){
            return currentmetertype.count
        }else{
        return currentunit.count
        }
    }
    
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == metertypepicker){
            return currentmetertype[row]["type"] as? String
        }else{
        return currentunit[row] as? String
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
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
    @IBAction func addupdate(sender: AnyObject) {
     //{"name":"sample_meter","native_unit":"kWh","type":"25"}
        
        print(metername.text,currentunit[unitspicker.selectedRowInComponent(0)],currentmetertype[metertypepicker.selectedRowInComponent(0)]["type"],currentmetertype[metertypepicker.selectedRowInComponent(0)]["id"])
        updatemeter(metername.text!, unit: currentunit[unitspicker.selectedRowInComponent(0)] as! String, ID: currentmetertype[metertypepicker.selectedRowInComponent(0)]["id"] as! Int)
    }
    
    
    func updatemeter(name:String, unit: String, ID:Int){
        
        dispatch_async(dispatch_get_main_queue(), {
            self.spinner.hidden = false
            self.view.userInteractionEnabled = false
        })
        
        var payload = NSMutableString()
        payload.appendString("{")
        
                payload.appendString("\"name\": \"\(name)\",")
                payload.appendString("\"native_unit\": \"\(unit)\",")
        payload.appendString("\"type\": \(ID)}")
        print(payload)
        var str = payload as! String
        payload.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
        payload.appendString("}")
        str = payload as! String
        print(str)
        
        
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/meters/",credentials().domain_url, leedid))
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
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
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

}
