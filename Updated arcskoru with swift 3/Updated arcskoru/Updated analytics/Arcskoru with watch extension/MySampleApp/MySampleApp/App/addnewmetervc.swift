//
//  addnewmetervc.swift
//  Arcskoru
//
//  Created by Group X on 19/04/17.
//
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class addnewmetervc: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    var electricityarr = NSMutableArray()
    var waterarr = NSMutableArray()
    var othersarr = NSMutableArray()
    var download_requests = [URLSession]()
    var task = URLSessionTask()
    var metertype = NSArray()
    var currentunit = NSArray()
    var currentmetertype = NSArray()
    var unitsarr = NSArray()
    var type = 0
    var s = ""
    var p = false
    var otherfuelsarr = NSArray()
    var iterate = 0
    var bgcolor = UIColor()
    override func viewDidLoad() {
        super.viewDidLoad()
        bgcolor = self.submitbtn.backgroundColor!
        self.submitbtn.isEnabled = false
        self.submitbtn.backgroundColor = UIColor.gray
        let height = UIScreen.main.bounds.size.height
        self.tableview.isScrollEnabled = false
        self.tableview.bounds.size.height = 6 * (0.074 * height)
        self.submitbtn.frame.origin.y =  self.tableview.frame.origin.y + ( 1.2 * (4 * 0.074 * height))
        self.iterate = 0
        self.tableview.reloadData()
        self.spinner.layer.cornerRadius = 5
        self.spinner.layer.masksToBounds = true
        typeview.isHidden = true
        unitview.isHidden = true
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
        
        if(type == 0 && s.lowercased() == "energy"){
            currentunit = unitsarr[0] as! NSArray
            currentmetertype = electricityarr
        }else if(type == 0 && s.lowercased() == "water"){
            currentunit = unitsarr[1] as! NSArray
            currentmetertype = waterarr
        }else if(type == 1){
            if(edit == 1){
                
            }else{
            currentunit = otherfuelsarr[0] as! NSArray
            }
            currentmetertype = othersarr
        }
        
        for  item in 0 ..< self.metertype.count {
            let a = self.metertype[item] as! NSArray
            var str  = ""
            if(currentmeter.count > 0){
                if(currentmeter["type"] as! String == "Electricity" && currentmeter["subtype"] as! String == "National Average"){
                    str = "Purchased from Grid"
                }else{
                    str = currentmeter["type"] as! String
                    //print(currentmeter)
                    if(currentmeter["subtype"] as? String != ""){
                        str = "\(str) \(currentmeter["subtype"] as! String)"
                    }
                }
            }
            if(a.contains(str)){
                self.currentmetertype = self.metertype[item] as! NSArray
                if(item == 0){
                    s = "energy"
                    type = 0
                }else if (item == 1){
                    s = "water"
                    type = 0
                }else{
                    type = 1
                }
                break
            }
        }
        
        print(currentunit)
        
        // Do any additional setup after loading the view.
    }
    
    var edit = 0
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        DispatchQueue.main.async(execute: {
        self.view.isUserInteractionEnabled = false
        self.getmetercategories()
        })
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == unitpicker){
            return currentunit.count
        }
        return currentmetertype.count
    }
    
    var currenttype = ""
    var currentmeter = NSDictionary()
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == unitpicker){
            return currentunit[row] as! String
        }
        if(currentmetertype[row] is String){
            return currentmetertype[row] as! String
        }
        var d = currentmetertype[row] as! NSDictionary
        var str = d["type"] as! String
        if(d["subtype"] as! String != ""){
            str =  "\(str) \(d["subtype"] as! String)"
        }
        return str
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func handleTextFieldTextDidChangeNotification(_ notification: Notification) {
        let textField = notification.object as! UITextField
        
        // Enforce a minimum length of >= 1 for secure text alerts.
        AddAlertSaveAction!.isEnabled = textField.text?.characters.count >= 1
    }
    
    func handleCancel(_ alertView: UIAlertAction!, index: Int)
    {
        
    }
    func configurationTextField(_ textField: UITextField!)
    {
        //print("configurat hire the TextField")
        
        if let tField = textField {
            tField.enablesReturnKeyAutomatically = true
            NotificationCenter.default.addObserver(self, selector: #selector(addnewmetervc.handleTextFieldTextDidChangeNotification(_:)), name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
            //self.textField = textField!        //Save reference to the UITextField
            //self.textField.text = "Hello world"
        }
    }
    
    @IBOutlet weak var submitbtn: UIButton!
    @IBAction func submit(_ sender: AnyObject) {
        if(edit == 0){
        if(name != "" && selected_unit != "" && currentmeter["id"] != nil){
            DispatchQueue.main.async(execute: {
                self.spinner.isHidden = false
                self.tableview.isUserInteractionEnabled = false
                self.addmeter(self.name, unit: self.selected_unit, ID: self.currentmeter["id"] as! Int)
            })
        }else{
            var str = ""
            if(name == ""){
                str = "\nMeter name"
            }
            if(selected_unit == ""){
                str = str + "\nMeter unit"
            }
            if(currentmeter["id"] == nil){
                str = str + "\nMeter type"
            }
            let parksmart = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            let alertController = UIAlertController(title: "Data missing", message: "Please enter the below detail:- \(str )", preferredStyle: .alert)
            alertController.addAction(parksmart)
            alertController.view.subviews.first?.backgroundColor = UIColor.white
        alertController.view.layer.cornerRadius = 10
        alertController.view.layer.masksToBounds = true
            self.present(alertController, animated: true, completion: nil)
        }
        }else{
            if(name != "" && selected_unit != "" && currentmeter["id"] != nil){
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = false
                    self.tableview.isUserInteractionEnabled = false
                self.updatemeter(self.name, unit: self.selected_unit, ID: self.currentmeter["id"] as! Int)
                })
            }else{
                var str = ""
                if(name == ""){
                    str = "\nMeter name"
                }
                if(selected_unit == ""){
                    str = str + "\nMeter unit"
                }
                if(currentmeter["id"] == nil){
                    str = str + "\nMeter type"
                }
                let parksmart = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                let alertController = UIAlertController(title: "Data missing", message: "Please enter the below detail:- \(str )", preferredStyle: .alert)
                alertController.addAction(parksmart)
                alertController.view.subviews.first?.backgroundColor = UIColor.white
        alertController.view.layer.cornerRadius = 10
        alertController.view.layer.masksToBounds = true
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func showalert(_ message:String, title:String, action:String){
        
        //let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        //let callActionHandler = { (action:UIAlertAction!) -> Void in
        DispatchQueue.main.async(execute: {
            self.view.isUserInteractionEnabled = true
            self.spinner.isHidden = true
            self.view.isUserInteractionEnabled = true
            self.maketoast(message, type: "error")
            //self.navigationController?.popViewControllerAnimated(true)
        })
        
        //        }
        //      let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        //    alertController.addAction(defaultAction)
        
        //presentViewController(alertController, animated: true, completion: nil)
        
        
    }

    @IBOutlet weak var spinner: UIView!
    func addmeter(_ name:String, unit: String, ID:Int){
        
        DispatchQueue.main.async(execute: {
            //self.spinner.hidden = false
            self.view.isUserInteractionEnabled = false
        })
        var leedid = UserDefaults.standard.integer(forKey: "leed_id")
        var payload = NSMutableString()
        payload.append("{")
        
        payload.append("\"name\": \"\(name)\",")
        payload.append("\"native_unit\": \"\(unit)\",")
        payload.append("\"type\": \(ID)}")
        //print(payload)
        var str = payload as String
        payload.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
        payload.append("}")
        str = payload as String
        //print(str)
        
        
        let url = URL.init(string:String(format: "%@assets/LEED:%d/meters/",credentials().domain_url, leedid))
        ////print(url?.absoluteURL)
        var subscription_key = credentials().subscription_key
        var token = UserDefaults.standard.object(forKey: "token") as! String
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "POST"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var httpbody = str
        request.httpBody = httpbody.data(using: String.Encoding.utf8)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(session)
        var task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401{
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    //self.spinner.hidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                    
                })
                return
            } else
                if let httpStatus = response as? HTTPURLResponse, (httpStatus.statusCode != 200 && httpStatus.statusCode != 201){           // check for http errors
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                    DispatchQueue.main.async(execute: {
                        //self.spinner.hidden = true
                        self.showalert("Something went wrong. Please try again later", title: "Error", action: "OK")
                        self.view.isUserInteractionEnabled = true
                    })
                }else{
                    
                    var jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        //print(jsonDictionary)
                        //self.tableview.reloadData()
                        // self.buildingactions(subscription_key, leedid: leedid)
                        DispatchQueue.main.async(execute: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    } catch {
                        //print(error)
                    }
            }
            
        }) 
        task.resume()
    }
    var meterID = 0

    func updatemeter(_ name:String, unit: String, ID:Int){
        
        DispatchQueue.main.async(execute: {
            //self.spinner.hidden = false
            self.view.isUserInteractionEnabled = false
        })
        var leedid = UserDefaults.standard.integer(forKey: "leed_id")
        var payload = NSMutableString()
        payload.append("{")
        
        payload.append("\"name\": \"\(name)\",")
        payload.append("\"native_unit\": \"\(unit)\",")
        payload.append("\"type\": \(ID)}")
        //print(payload)
        var str = payload as String
        payload.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
        payload.append("}")
        str = payload as String
        //print(str)
        
        
        let url = URL.init(string:String(format: "%@assets/LEED:%d/meters/ID:%d/",credentials().domain_url, leedid, meterID))
        ////print(url?.absoluteURL)
        var subscription_key = credentials().subscription_key
        var token = UserDefaults.standard.object(forKey: "token") as! String
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "PUT"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var httpbody = str
        request.httpBody = httpbody.data(using: String.Encoding.utf8)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(session)
        var task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401{
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    //self.spinner.hidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                    
                })
                return
            } else
                if let httpStatus = response as? HTTPURLResponse, (httpStatus.statusCode != 200){           // check for http errors
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                    DispatchQueue.main.async(execute: {
                        //self.spinner.hidden = true
                        self.showalert("Something went wrong. Please try again later", title: "Error", action: "OK")
                        self.view.isUserInteractionEnabled = true
                    })
                }else{
                    
                    var jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        //print(jsonDictionary)
                        //self.tableview.reloadData()
                        // self.buildingactions(subscription_key, leedid: leedid)
                        DispatchQueue.main.async(execute: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    } catch {
                        //print(error)
                    }
            }
            
        }) 
        task.resume()
    }

    
    func removeTextFieldObserver() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidChange, object: alert.textFields![0])
    }
    var alert = UIAlertController()
    weak var AddAlertSaveAction: UIAlertAction?
    
    func showalert(_ index: Int, title : String, value : String){
        DispatchQueue.main.async(execute: {
            self.alert = UIAlertController(title: "", message: "Enter the \(title )", preferredStyle: UIAlertControllerStyle.alert)
            self.alert.addTextField(configurationHandler: self.configurationTextField)
            let otherAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
                //print("User click Ok button")
                let txtfld = self.alert.textFields![0] 
                if(index == 0){
                    self.name = txtfld.text! 
                }
                self.iterate = 0
                self.tableview.reloadData()
                ////print(self.textField.text)
            })
            otherAction.isEnabled = false
            
            // save the other action to toggle the enabled/disabled state when the text changed.
            self.AddAlertSaveAction = otherAction
            
            
            
            self.alert.addAction(UIAlertAction(title: "cancel", style: UIAlertActionStyle.cancel, handler:{ (UIAlertAction)in
                if(index == 15){
                    let cell = self.tableview.cellForRow(at: IndexPath.init(row: 15, section: 0)) as! manageprojcellwithswitch
                    cell.yesorno.setOn(false, animated: true)
                }
            }))
            self.alert.addAction(otherAction)
            self.alert.textFields![0].text = value
            self.alert.view.subviews.first?.backgroundColor = UIColor.white
        self.alert.view.layer.cornerRadius = 10
        self.alert.view.layer.masksToBounds = true
            self.present(self.alert, animated: true, completion: {
                //print("completion block")
            })
        })
    }
    
    func getmetercategories(){
        let url = URL.init(string:String(format: "%@fuel/category/?page_size=300",credentials().domain_url))
        ////print(url?.absoluteURL)
        var subscription_key = credentials().subscription_key
        var token = UserDefaults.standard.object(forKey: "token") as! String
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(session)
        var task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    self.view.isUserInteractionEnabled = true
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401{
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    //self.spinner.hidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                    
                })
                return
            } else
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                    DispatchQueue.main.async(execute: {
                        //self.spinner.hidden = true
                        self.view.isUserInteractionEnabled = true
                    })
                }else{
                    
                    var jsonDictionary = NSArray()
                    do {
                        var dict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        if(dict["results"] != nil){
                            jsonDictionary = dict["results"] as! NSArray
                        }
                        
                        //print(jsonDictionary)
                        for i in jsonDictionary{
                            let item  = i as! NSDictionary
                            if(item["kind"] != nil){
                                if(item["kind"]  as! String == "electricity" && item["include_in_dropdown_list"]  as? Bool == true){
                                    self.electricityarr.add(item)
                                }
                                
                                if(item["kind"]  as! String == "water" && item["include_in_dropdown_list"]  as? Bool == true){
                                    self.waterarr.add(item)
                                    
                                }
                                
                                if((item["kind"]  as! String == "fuel" || item["kind"]  as! String == "Other") && item["include_in_dropdown_list"]  as? Bool == true){
                                    self.othersarr.add(item)
                                }
                            }
                        }
                        //self.tableview.reloadData()
                        // self.buildingactions(subscription_key, leedid: leedid)
                        DispatchQueue.main.async(execute: {
                            var tempdict = [
                                "id": 25,
                                "type": "Purchased from Grid",
                                "subtype": "",
                                "kind": "electricity",
                                "include_in_dropdown_list": true,
                                "resource": "Non-Renewable",
                            ] as! NSDictionary
                            self.electricityarr.insert(tempdict, at: 0)
                            if(self.type == 0 && self.s.lowercased() == "energy"){
                                self.currentunit = self.unitsarr[0] as! NSArray
                                self.currentmetertype = self.electricityarr
                                self.unitpicker.reloadComponent(0)
                                self.typepicker.reloadComponent(0)
                            }else if(self.type == 0 && self.s.lowercased() == "water"){
                                self.currentunit = self.unitsarr[1] as! NSArray
                                self.currentmetertype = self.waterarr
                                self.unitpicker.reloadComponent(0)
                                self.typepicker.reloadComponent(0)
                            }else if(self.type == 1){
                                if(self.edit == 1){
                                    
                                }else{
                                    self.currentunit = self.unitsarr[2] as! NSArray
                                }
                                self.currentmetertype = self.othersarr
                                self.unitpicker.reloadComponent(0)
                                self.typepicker.reloadComponent(0)
                            }
                            self.view.isUserInteractionEnabled = true
                            self.spinner.isHidden = true
                        })
                    } catch {
                        //print(error)
                    }
            }
            
        }) 
        task.resume()
        
    }


    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        if(indexPath.row == 0){
            cell?.textLabel?.text = "Meter name"
            cell?.detailTextLabel?.text = name
            if(cell?.detailTextLabel?.text?.characters.count > 0){
                iterate = iterate + 1
            }
        }else if(indexPath.row == 2){
            cell?.textLabel?.text = "Meter unit"
            var str = ""
            for i in 0 ..< currentunit.count{
            let sel = currentunit[i] as! String
            if(sel == selected_unit){
                str = sel
            }
            }
            cell?.detailTextLabel?.text = str
            if(cell?.detailTextLabel?.text?.characters.count > 0){
                iterate = iterate + 1
            }
        }else if(indexPath.row == 1){
            cell?.textLabel?.text = "Type"
            
            var str  = ""
            if(currentmeter.count > 0){
                if(currentmeter["type"] as! String == "Electricity" && currentmeter["subtype"] as! String == "National Average"){
                    str = "Purchased from Grid"
                }else{
            str = currentmeter["type"] as! String
            //print(currentmeter)
            if(currentmeter["subtype"] as? String != ""){
                str = "\(str) \(currentmeter["subtype"] as! String)"
            }
            }
            }
            cell?.detailTextLabel?.text = str
            if(cell?.detailTextLabel?.text?.characters.count > 0){
                iterate = iterate + 1
            }
            DispatchQueue.main.async(execute: {
            if(self.iterate == 3 && self.p == true){
                self.submitbtn.backgroundColor = self.bgcolor
                self.submitbtn.isEnabled = true
            }else{
                self.submitbtn.backgroundColor = UIColor.gray
                self.submitbtn.isEnabled = false
                }})
            
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = UIScreen.main.bounds.size.height
        
        return 0.074 * height
    }
    
    var name = ""
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        p = true
        if(indexPath.row == 0){
            typeview.isHidden = true
            unitview.isHidden = true
            let cell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0))
            if(cell?.detailTextLabel?.text?.characters.count > 0){
          self.showalert(0, title: "Meter name", value: (cell?.detailTextLabel?.text)!)
            }else{
          self.showalert(0, title: "Meter name", value: "")
            }
        }else if(indexPath.row == 1){
            unitview.isHidden = true
            typeview.isHidden = false
            self.submitbtn.isHidden = true
            var str  = ""
            if(currentmeter.count > 0){
                str = currentmeter["type"] as! String
                //print(currentmeter)
                if(currentmeter["subtype"] as? String != ""){
                    str = "\(str) \(currentmeter["subtype"] as! String)"
                }
            }
            for i in 0 ..< currentmetertype.count{
                let dict = currentmetertype[i] as! NSDictionary
                var str1 = dict["type"] as! String
                if(dict["subtype"] as! String != ""){
                    str1 =  "\(str1) \(dict["subtype"] as! String)"
                }
                if(str == str1){
                    typepicker.selectRow(i, inComponent: 0, animated: true)
                    break
                }
            }
        }else{
            let cell = tableView.cellForRow(at: IndexPath.init(row: 1, section: 0))
            if(cell?.detailTextLabel?.text?.characters.count > 0){
                typeview.isHidden = true
                unitview.isHidden = false
                self.submitbtn.isHidden = true
                
                var str  = selected_unit
                
                for i in 0 ..< currentunit.count{
                    var str1 = currentunit[i] as! String
                    if(str == str1){
                        unitpicker.selectRow(i, inComponent: 0, animated: true)
                        break
                    }
                }
                
            }else{
                DispatchQueue.main.async(execute: {
                var alertController = UIAlertController()
                    alertController = UIAlertController(title: "Error", message: "Please select meter type and try again", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                alertController.view.subviews.first?.backgroundColor = UIColor.white
        alertController.view.layer.cornerRadius = 10
        alertController.view.layer.masksToBounds = true
                self.present(alertController, animated: true, completion: nil)
                })
            }
        }
    }
    var dict = NSMutableDictionary()
    @IBAction func typecancel(_ sender: AnyObject) {
        typeview.isHidden = true
        self.submitbtn.isHidden = false
    }
    @IBAction func typedone(_ sender: AnyObject) {
        //dict["type"] =  typepicker.selectedRowInComponent(0)
        self.submitbtn.isHidden = false
        
        
               if let snapshotValue = currentmetertype[typepicker.selectedRow(inComponent: 0)] as? NSDictionary, let type = snapshotValue["type"] as? String {
        var str  = type
        if(snapshotValue["subtype"] as! String != ""){
            str = "\(str) (\(snapshotValue["subtype"] as! String))"
        }
                
        currenttype = str
        currentmeter = currentmetertype[typepicker.selectedRow(inComponent: 0)] as! NSDictionary
        typeview.isHidden = true
        
        
        self.iterate = 0
        self.tableview.reloadData()
        //print(currentmetertype.count,typepicker.selectedRow(inComponent: 0))
        currentunit = otherfuelsarr[typepicker.selectedRow(inComponent: 0)] as! NSArray
        self.unitpicker.reloadComponent(0)
        }
    }
    
    @IBAction func unitcancel(_ sender: AnyObject) {
        unitview.isHidden = true
        self.submitbtn.isHidden = false
    }
    
    
    @IBAction func unitdone(_ sender: AnyObject) {
        self.submitbtn.isHidden = false
        dict["unit"] =  unitpicker.selectedRow(inComponent: 0)
        selected_unit = currentunit[unitpicker.selectedRow(inComponent: 0)] as! String
        unitview.isHidden = true
        self.iterate = 0
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
