//
//  addnewmetervc.swift
//  Arcskoru
//
//  Created by Group X on 19/04/17.
//
//

import UIKit

class addnewmetervc: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    var electricityarr = NSMutableArray()
    var waterarr = NSMutableArray()
    var othersarr = NSMutableArray()
    var download_requests = [NSURLSession]()
    var task = NSURLSessionTask()
    var metertype = NSArray()
    var currentunit = NSArray()
    var currentmetertype = NSArray()
    var unitsarr = NSArray()
    var type = 0
    var otherfuelsarr = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        let height = UIScreen.mainScreen().bounds.size.height
        self.tableview.scrollEnabled = false
        self.tableview.bounds.size.height = 6 * (0.074 * height)
        self.submitbtn.frame.origin.y =  self.tableview.frame.origin.y + ( 1.2 * (4 * 0.074 * height))
        self.tableview.reloadData()
        self.spinner.layer.cornerRadius = 5
        self.spinner.layer.masksToBounds = true
        typeview.hidden = true
        unitview.hidden = true
        metertype = [["Generated onsite - solar","Purchased from Grid"],["Municipality supplied potable water","Municipality supplied reclaimed water","Reclaimed onsite"],["District Strem","District Hot water","District chilled water (Electric driven chiller)","District chilled water(Absorption chiller using natural gas)","District chilled water(Engine driven chiller using natural gas)","Natural gas","Fuel oil (No.2)","Wood","Propane","Liquid propane","Kerosene","Fuel oil (No.1)","Fuel oil (No.5 & No.6)","Coal (anthracite)","Coal (bituminous)","Coke","Fuel oil (No.4)","Diesel"]]
        
        unitsarr = [["kWh","MWh","MBtu","kBtu","Gj"],["gal","kGal","MGal","cf","ccf","kcf","mcf","I","cu m","gal(UK)","kGal(UK)","kGal(UK)","MGal(UK)"],["kWh","MWh","therms","kBtu","MBtu","Gj","cu m","I","gal","kGal","MGal","cf","ccf","kcf","mcf"]]
        otherfuelsarr = [["kWh","MWh","therms","kBtu","MBtu","GJ","Lbs","KLbs","MLbs","kg"],["kWh","MWh","therms","kBtu","MBtu","GJ"],
            ["kWh","MWh","therms","kBtu","MBtu","GJ","ton hours"],
            ["kWh","MWh","therms","kBtu","MBtu","GJ","ton hours"],
            ["kWh","MWh","therms","kBtu","MBtu","GJ","ton hours"],
            ["kWh","MWh","therms","kBtu","MBtu","Gj","cu m","I","gal","kGal","MGal","cf","ccf","kcf","mcf"],
            ["kWh","MWh","therms","kBtu","MBtu","Gj","cu m","I","gal","kGal","MGal","cf","ccf","kcf","mcf"],
            ["kWh","MWh","therms","kBtu","MBtu","GJ","tons","Tonnes (metric)"],
            ["kWh","MWh","therms","kBtu","MBtu","Gj","cu m","I","gal","kGal","MGal","cf","ccf","kcf","mcf"],
            ["kWh","MWh","therms","kBtu","MBtu","Gj","cu m","I","gal","kGal","MGal","cf","ccf","kcf","mcf"],
            ["kWh","MWh","therms","kBtu","MBtu","Gj","cu m","I","gal","kGal","MGal","cf","ccf","kcf","mcf"],
            ["kWh","MWh","therms","kBtu","MBtu","Gj","cu m","I","gal","kGal","MGal","cf","ccf","kcf","mcf"],
            ["kWh","MWh","therms","kBtu","MBtu","Gj","cu m","I","gal","kGal","MGal","cf","ccf","kcf","mcf"],
            ["kWh","MWh","therms","kBtu","MBtu","GJ","tons","Lbs","MLbs","Tonnes (metric)"],
            ["kWh","MWh","therms","kBtu","MBtu","GJ","tons","Lbs","MLbs","Tonnes (metric)"],
            ["kWh","MWh","therms","kBtu","MBtu","GJ","tons","Lbs","MLbs","Tonnes (metric)"],
            ["kWh","MWh","therms","kBtu","MBtu","Gj","cu m","I","gal","kGal","MGal","cf","ccf","kcf","mcf"],
            ["kWh","MWh","therms","kBtu","MBtu","Gj","cu m","I","gal","kGal","MGal","cf","ccf","kcf","mcf"]]
        
        if(type == 0){
            currentunit = unitsarr[0] as! NSArray
            currentmetertype = electricityarr
        }else if(type == 1){
            currentunit = unitsarr[1] as! NSArray
            currentmetertype = waterarr
        }else if(type == 2){
            if(edit == 1){
                
            }else{
            currentunit = otherfuelsarr[0] as! NSArray
            }
            currentmetertype = othersarr
        }
        // Do any additional setup after loading the view.
    }
    
    var edit = 0
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        dispatch_async(dispatch_get_main_queue(), {
        self.view.userInteractionEnabled = false
        self.getmetercategories()
        })
        
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == unitpicker){
            return currentunit.count
        }
        return currentmetertype.count
    }
    
    var currenttype = ""
    var currentmeter = NSDictionary()
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == unitpicker){
            return currentunit[row] as! String
        }
        var str = currentmetertype[row]["type"] as! String
        if(currentmetertype[row]["subtype"] as! String != ""){
            str =  "\(str) \(currentmetertype[row]["subtype"] as! String)"
        }
        return str
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func handleTextFieldTextDidChangeNotification(notification: NSNotification) {
        let textField = notification.object as! UITextField
        
        // Enforce a minimum length of >= 1 for secure text alerts.
        AddAlertSaveAction!.enabled = textField.text?.characters.count >= 1
    }
    
    func handleCancel(alertView: UIAlertAction!, index: Int)
    {
        
    }
    func configurationTextField(textField: UITextField!)
    {
        print("configurat hire the TextField")
        
        if let tField = textField {
            tField.enablesReturnKeyAutomatically = true
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(addnewmetervc.handleTextFieldTextDidChangeNotification(_:)), name: UITextFieldTextDidChangeNotification, object: textField)
            //self.textField = textField!        //Save reference to the UITextField
            //self.textField.text = "Hello world"
        }
    }
    
    @IBOutlet weak var submitbtn: UIButton!
    @IBAction func submit(sender: AnyObject) {
        if(edit == 0){
        if(name != "" && selected_unit != "" && currentmeter["id"] != nil){
        addmeter(name, unit: selected_unit, ID: currentmeter["id"] as! Int)
        }else{
            var str = ""
            if(name == ""){
                str = "\nMeter name"
            }
            if(selected_unit == ""){
                str = str.stringByAppendingString("\nMeter unit")
            }
            if(currentmeter["id"] == nil){
                str = str.stringByAppendingString("\nMeter type")
            }
            let parksmart = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            let alertController = UIAlertController(title: "Data missing", message: "Please enter the below detail:- \(str as! String)", preferredStyle: .Alert)
            alertController.addAction(parksmart)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        }else{
            if(name != "" && selected_unit != "" && currentmeter["id"] != nil){
                updatemeter(name, unit: selected_unit, ID: currentmeter["id"] as! Int)
            }else{
                var str = ""
                if(name == ""){
                    str = "\nMeter name"
                }
                if(selected_unit == ""){
                    str = str.stringByAppendingString("\nMeter unit")
                }
                if(currentmeter["id"] == nil){
                    str = str.stringByAppendingString("\nMeter type")
                }
                let parksmart = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                let alertController = UIAlertController(title: "Data missing", message: "Please enter the below detail:- \(str as! String)", preferredStyle: .Alert)
                alertController.addAction(parksmart)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
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

    @IBOutlet weak var spinner: UIView!
    func addmeter(name:String, unit: String, ID:Int){
        
        dispatch_async(dispatch_get_main_queue(), {
            //self.spinner.hidden = false
            self.view.userInteractionEnabled = false
        })
        var leedid = NSUserDefaults.standardUserDefaults().integerForKey("leed_id")
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
                    //self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                    
                })
                return
            } else
                if let httpStatus = response as? NSHTTPURLResponse where (httpStatus.statusCode != 200 && httpStatus.statusCode != 201){           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    dispatch_async(dispatch_get_main_queue(), {
                        //self.spinner.hidden = true
                        self.showalert("Something went wrong. Please try again later", title: "Error", action: "OK")
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
    var meterID = 0

    func updatemeter(name:String, unit: String, ID:Int){
        
        dispatch_async(dispatch_get_main_queue(), {
            //self.spinner.hidden = false
            self.view.userInteractionEnabled = false
        })
        var leedid = NSUserDefaults.standardUserDefaults().integerForKey("leed_id")
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
        
        
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/meters/ID:%d/",credentials().domain_url, leedid, meterID))
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
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    //self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                    
                })
                return
            } else
                if let httpStatus = response as? NSHTTPURLResponse where (httpStatus.statusCode != 200){           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    dispatch_async(dispatch_get_main_queue(), {
                        //self.spinner.hidden = true
                        self.showalert("Something went wrong. Please try again later", title: "Error", action: "OK")
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

    
    func removeTextFieldObserver() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidChangeNotification, object: alert.textFields![0])
    }
    var alert = UIAlertController()
    weak var AddAlertSaveAction: UIAlertAction?
    
    func showalert(index: Int, title : String, value : String){
        dispatch_async(dispatch_get_main_queue(), {
            self.alert = UIAlertController(title: "", message: "Enter the \(title as! String)", preferredStyle: UIAlertControllerStyle.Alert)
            self.alert.addTextFieldWithConfigurationHandler(self.configurationTextField)
            var otherAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
                print("User click Ok button")
                var txtfld = self.alert.textFields![0] as! UITextField
                if(index == 0){
                    self.name = txtfld.text! as! String
                }
                self.tableview.reloadData()
                //print(self.textField.text)
            })
            otherAction.enabled = false
            
            // save the other action to toggle the enabled/disabled state when the text changed.
            self.AddAlertSaveAction = otherAction
            
            
            
            self.alert.addAction(UIAlertAction(title: "cancel", style: UIAlertActionStyle.Cancel, handler:{ (UIAlertAction)in
                if(index == 15){
                    let cell = self.tableview.cellForRowAtIndexPath(NSIndexPath.init(forRow: 15, inSection: 0)) as! manageprojcellwithswitch
                    cell.yesorno.setOn(false, animated: true)
                }
            }))
            self.alert.addAction(otherAction)
            self.alert.textFields![0].text = value
            
            self.presentViewController(self.alert, animated: true, completion: {
                print("completion block")
            })
        })
    }
    
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
                    self.view.userInteractionEnabled = true
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401{
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    //self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                    
                })
                return
            } else
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    dispatch_async(dispatch_get_main_queue(), {
                        //self.spinner.hidden = true
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
                            if(self.type == 0){
                                self.currentunit = self.unitsarr[0] as! NSArray
                                self.currentmetertype = self.electricityarr
                                self.unitpicker.reloadComponent(0)
                                self.typepicker.reloadComponent(0)
                            }else if(self.type == 1){
                                self.currentunit = self.unitsarr[1] as! NSArray
                                self.currentmetertype = self.waterarr
                                self.unitpicker.reloadComponent(0)
                                self.typepicker.reloadComponent(0)
                            }else if(self.type == 2){
                                if(self.edit == 1){
                                    
                                }else{
                                    self.currentunit = self.unitsarr[2] as! NSArray
                                }
                                self.currentmetertype = self.othersarr
                                self.unitpicker.reloadComponent(0)
                                self.typepicker.reloadComponent(0)
                            }
                            self.view.userInteractionEnabled = true
                            self.spinner.hidden = true
                        })
                    } catch {
                        print(error)
                    }
            }
            
        }
        task.resume()
        
    }


    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        if(indexPath.row == 0){
            cell?.textLabel?.text = "Meter name"
            cell?.detailTextLabel?.text = name
        }else if(indexPath.row == 2){
            cell?.textLabel?.text = "Meter unit"
            var str = ""
            for i in 0 ..< currentunit.count{
            var sel = currentunit[i] as! String
            if(sel == selected_unit){
                str = sel
            }
            }
            cell?.detailTextLabel?.text = str
        }else if(indexPath.row == 1){
            cell?.textLabel?.text = "Type"
            
            var str  = ""
            if(currentmeter.count > 0){
                if(currentmeter["type"] as! String == "Electricity" && currentmeter["subtype"] as! String == "National Average"){
                    str = "Purchased from Grid"
                }else{
            str = currentmeter["type"] as! String
            print(currentmeter)
            if(currentmeter["subtype"] as? String != ""){
                str = "\(str) \(currentmeter["subtype"] as! String)"
            }
            }
            }
            cell?.detailTextLabel?.text = str
            
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let height = UIScreen.mainScreen().bounds.size.height
        
        return 0.074 * height
    }
    
    var name = ""
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 0){
            typeview.hidden = true
            unitview.hidden = true
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath.init(forRow: 0, inSection: 0))
            if(cell?.detailTextLabel?.text?.characters.count > 0){
          self.showalert(0, title: "Meter name", value: (cell?.detailTextLabel?.text)!)
            }else{
          self.showalert(0, title: "Meter name", value: "")
            }
        }else if(indexPath.row == 1){
            unitview.hidden = true
            typeview.hidden = false
            self.submitbtn.hidden = true
            var str  = ""
            if(currentmeter.count > 0){
                str = currentmeter["type"] as! String
                print(currentmeter)
                if(currentmeter["subtype"] as? String != ""){
                    str = "\(str) \(currentmeter["subtype"] as! String)"
                }
            }
            for i in 0 ..< currentmetertype.count{
                var str1 = currentmetertype[i]["type"] as! String
                if(currentmetertype[i]["subtype"] as! String != ""){
                    str1 =  "\(str1) \(currentmetertype[i]["subtype"] as! String)"
                }
                if(str == str1){
                    typepicker.selectRow(i, inComponent: 0, animated: true)
                    break
                }
            }
        }else{
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath.init(forRow: 1, inSection: 0))
            if(cell?.detailTextLabel?.text?.characters.count > 0){
                typeview.hidden = true
                unitview.hidden = false
                self.submitbtn.hidden = true
                
                var str  = selected_unit
                
                for i in 0 ..< currentunit.count{
                    var str1 = currentunit[i] as! String
                    if(str == str1){
                        unitpicker.selectRow(i, inComponent: 0, animated: true)
                        break
                    }
                }
                
            }else{
                dispatch_async(dispatch_get_main_queue(), {
                var alertController = UIAlertController()
                    alertController = UIAlertController(title: "Error", message: "Please select meter type and try again", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                })
            }
        }
    }
    var dict = NSMutableDictionary()
    @IBAction func typecancel(sender: AnyObject) {
        typeview.hidden = true
        self.submitbtn.hidden = false
    }
    @IBAction func typedone(sender: AnyObject) {
        //dict["type"] =  typepicker.selectedRowInComponent(0)
        self.submitbtn.hidden = false
        var str  = currentmetertype[typepicker.selectedRowInComponent(0)]["type"] as! String
        if(currentmetertype[typepicker.selectedRowInComponent(0)]["subtype"] as! String != ""){
            str = "\(str) (\(currentmetertype[typepicker.selectedRowInComponent(0)]["subtype"] as! String))"
        }
        currenttype = str
        currentmeter = currentmetertype[typepicker.selectedRowInComponent(0)] as! NSDictionary
        typeview.hidden = true
        
        
        
        self.tableview.reloadData()
        print(currentmetertype.count,typepicker.selectedRowInComponent(0))
        currentunit = otherfuelsarr[typepicker.selectedRowInComponent(0)] as! NSArray
        self.unitpicker.reloadComponent(0)
    }
    
    @IBAction func unitcancel(sender: AnyObject) {
        unitview.hidden = true
        self.submitbtn.hidden = false
    }
    
    
    @IBAction func unitdone(sender: AnyObject) {
        self.submitbtn.hidden = false
        dict["unit"] =  unitpicker.selectedRowInComponent(0)
        selected_unit = currentunit[unitpicker.selectedRowInComponent(0)] as! String
        unitview.hidden = true
        self.tableview.reloadData()
    }
    
    var selected_unit = ""
    
    @IBOutlet weak var unitnav: UINavigationBar!
    @IBOutlet weak var unitpicker: UIPickerView!
    
    @IBOutlet weak var unitview: UIView!
    
    @IBOutlet weak var typeview: UIView!

    @IBOutlet weak var typepicker: UIPickerView!
    
    @IBOutlet weak var typenav: UINavigationBar!
    
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
