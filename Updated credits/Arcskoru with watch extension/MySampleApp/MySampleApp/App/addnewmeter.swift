//
//  addnewmeter.swift
//  LEEDOn
//
//  Created by Group X on 05/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class addnewmeter: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource, UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var assetname: UILabel!

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var collview: UICollectionView!
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
    override func viewDidAppear(animated: Bool) {
        token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentmetertype.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.textLabel?.text = currentmetertype[indexPath.row]["type"] as! String
        if(currentmetertype[indexPath.row]["subtype"] as! String != ""){
            cell.textLabel?.text =  "\(cell.textLabel?.text) (\(currentmetertype[indexPath.row]["subtype"] as! String))"
        }
        cell.accessoryType = UITableViewCellAccessoryType.None
        if(cell.textLabel?.text == currenttype){
        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentunit.count
    }
    var selected_unit = ""
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collcell", forIndexPath: indexPath) as! collcell
        cell.lbl.text = currentunit[indexPath.row] as? String
        cell.img.hidden = true
        if(cell.lbl.text == selected_unit){
        cell.img.hidden = false
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var view1 = typeview
        var view2 = unitview
        var picker1 = typepicker
        var picker2 = unitpicker
        self.typeview.removeFromSuperview()
        self.unitview.removeFromSuperview()
        var vieww = UIView()
        vieww.frame = view1.frame
        vieww.addSubview(picker1)
        typetxtfld.inputView = view1
        vieww = UIView()
        vieww.frame = view2.frame
        vieww.addSubview(picker2)
        unittype.inputView = vieww
        typepicker = picker1
        unitpicker = picker2
        collview.backgroundColor = UIColor.clearColor()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        //layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //layout.sectionHeadersPinToVisibleBounds = true
        layout.itemSize = CGSize(width: UIScreen.mainScreen().bounds.size.width/4.37,height:UIScreen.mainScreen().bounds.size.width/4.37)
        layout.minimumInteritemSpacing = 0//0.03 * UIScreen.mainScreen().bounds.size.width
        layout.minimumLineSpacing = 0.02 * UIScreen.mainScreen().bounds.size.width
        collview!.collectionViewLayout = layout
        layout.scrollDirection = .Horizontal
        collview.layer.frame.size.height = layout.itemSize.height
        collview.registerNib(UINib.init(nibName: "collcell", bundle: nil), forCellWithReuseIdentifier: "collcell")
        self.titlefont()
        metername.delegate = self
        spinner.layer.cornerRadius = 5
        getmetercategories()
        metertype = [["Generated onsite - solar","Purchased from Grid"],["Municipality supplied potable water","Municipality supplied reclaimed water","Reclaimed onsite"],["District Strem","District Hot water","District chilled water (Electric driven chiller)","District chilled water(Absorption chiller using natural gas)","District chilled water(Engine driven chiller using natural gas)","Natural gas","Fuel oil (No.2)","Wood","Propane","Liquid propane","Kerosene","Fuel oil (No.1)","Fuel oil (No.5 & No.6)","Coal (anthracite)","Coal (bituminous)","Coke","Fuel oil (No.4)","Diesel"]]
        
        unitsarr = [["kWh","MWh","MBtu","kBtu","Gj"],["gal","kGal","MGal","cf","ccf","kcf","mcf","I","cu m","gal(UK)","kGal(UK)","kGal(UK)","MGal(UK)"],["kWh","MWh","therms","kBtu","MBtu","Gj","cu m","I","gal","kGal","MGal","cf","ccf","kcf","mcf"]]
        if(currentmeterdata.count == 0){
            currentunit = unitsarr[0] as! NSArray
            currentmetertype = metertype[0] as! NSArray
            unitschange(units)
        }
        // Do any additional setup after loading the view.
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selected_unit = currentunit[indexPath.row] as! String
        collview.reloadData()
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
                    var jsonDictionary = NSArray()
                    do {
                        var dict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        if(dict["results"] != nil){
                            jsonDictionary = dict["results"] as! NSArray
                        }
                        
                        print(jsonDictionary)
                        for item in jsonDictionary{
                            if(item["kind"] != nil){
                                if(item["kind"]  as! String == "electricity" && item["include_in_dropdown_list"]  as? Bool == true){
                                    self.electricityarr.addObject(item)
                                }
                                
                                if(item["kind"]  as! String == "water" && item["include_in_dropdown_list"]  as? Bool == true){
                                    self.waterarr.addObject(item)
                                    
                                }
                                
                                if((item["kind"]  as! String == "fuel" || item["kind"]  as! String == "Other") && item["include_in_dropdown_list"]  as? Bool == true){
                                     self.othersarr.addObject(item)
                                }
                            }
                        }
                        //self.tableview.reloadData()
                        // self.buildingactions(subscription_key, leedid: leedid)
                        dispatch_async(dispatch_get_main_queue(), {
                            var tempdict = [
                                "id": 25,
                                "type": "Purchased from Grid",
                                "subtype": "",
                                "kind": "electricity",
                                "include_in_dropdown_list": true,
                                "resource": "Non-Renewable",
                            ]
                            self.electricityarr.insertObject(tempdict, atIndex: 0)
                            self.spinner.hidden = true
                            self.units.selectedSegmentIndex = 0
                            self.unitschange(self.units)
                        })
                    } catch {
                        print(error)
                    }
            }
            
        }
        task.resume()
  
    }
    @IBOutlet weak var spinner: UIView!
    
    @IBOutlet weak var typeview: UIView!
    @IBOutlet weak var unitview: UIView!
    @IBOutlet weak var typetxtfld: UITextField!
    @IBOutlet weak var unittype: UITextField!
    @IBOutlet weak var typepicker: UIPickerView!
    @IBOutlet weak var unitpicker: UIPickerView!
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
    
    @IBAction func unitschange(sender: AnyObject) {
        currentmetertype = NSArray()
        currentunit = NSArray()
        if(units.selectedSegmentIndex == 0){
            units.tintColor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
            currentunit = unitsarr[0] as! NSArray
            currentmetertype = metertype[0] as! NSArray
            currentmetertype = electricityarr
            unitspicker.reloadAllComponents()
            //metertypepicker.reloadAllComponents()
            collview.reloadData()
            self.tableview.reloadData()
        }else if(units.selectedSegmentIndex == 1){
            units.tintColor = UIColor.init(red: 0.303, green: 0.751, blue: 0.94, alpha: 1)
            currentunit = unitsarr[1] as! NSArray
            currentmetertype = metertype[1] as! NSArray
            currentmetertype = waterarr
            unitspicker.reloadAllComponents()
            metertypepicker.reloadAllComponents()
            collview.reloadData()
            self.tableview.reloadData()
        }else{
            units.tintColor = UIColor.init(red: 0.776, green: 0.859, blue: 0.122, alpha: 1)
            currentunit = unitsarr[2] as! NSArray
            currentmetertype = metertype[2] as! NSArray
            currentmetertype = othersarr
            unitspicker.reloadAllComponents()
            metertypepicker.reloadAllComponents()
            collview.reloadData()
            self.tableview.reloadData()
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == typepicker){
            return currentmetertype.count
        }else{
        return currentunit.count
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var str  = currentmetertype[indexPath.row]["type"] as! String
        if(currentmetertype[indexPath.row]["subtype"] as! String != ""){
            str = "\(str) (\(currentmetertype[indexPath.row]["subtype"] as! String))"
        }
        currenttype = str
        currentmeter = currentmetertype[indexPath.row] as! NSDictionary
        self.tableview.reloadData()
    }
    
    var currenttype = ""
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == typepicker){
            //return currentmetertype[row]["type"] as? String
            var str  = currentmetertype[row]["type"] as! String
            if(currentmetertype[row]["subtype"] as! String != ""){
                return "\(str) (\(currentmetertype[row]["subtype"] as! String))"
            }
            return str
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
        
        
        if(currentmeter["id"] != nil && metername.text?.characters.count > 0 && selected_unit != ""){
        updatemeter(metername.text!, unit: selected_unit, ID: currentmeter["id"] as! Int)
        }else{
            if(currentmeter["id"] == nil){
                dispatch_async(dispatch_get_main_queue(), {
                    //self.navigationController?.popViewControllerAnimated(true)
                    
                    let alertController = UIAlertController(title: "Error", message: "Plesae select a valid meter category", preferredStyle: .Alert)
                    let action = UIAlertAction.init(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(action)
                    self.presentViewController(alertController, animated: true, completion: nil)
                })
            }else if(metername.text?.characters.count == 0){
                dispatch_async(dispatch_get_main_queue(), {
                    //self.navigationController?.popViewControllerAnimated(true)
                    
                    let alertController = UIAlertController(title: "Error", message: "Plesae enter a valid meter name", preferredStyle: .Alert)
                    let action = UIAlertAction.init(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(action)
                    self.presentViewController(alertController, animated: true, completion: nil)
                })
            }else if(selected_unit == ""){
                
                
                dispatch_async(dispatch_get_main_queue(), {
                    //self.navigationController?.popViewControllerAnimated(true)
                    
                    let alertController = UIAlertController(title: "Error", message: "Plesae select a unit", preferredStyle: .Alert)
                    let action = UIAlertAction.init(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(action)
                    self.presentViewController(alertController, animated: true, completion: nil)
                })
                
                    
                

            }
        }
        
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Categories"
    }
    
    var currentmeter = NSDictionary()
    
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
                    //self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                    
                })
                return
            } else
                if let httpStatus = response as? NSHTTPURLResponse where (httpStatus.statusCode != 200 && httpStatus.statusCode != 201){           // check for http errors
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
