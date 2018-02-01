//
//  wastereadingdetail.swift
//  Arcskoru
//
//  Created by Group X on 02/03/17.
//
//

import UIKit

class wastereadingdetail: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {
var meters = NSMutableArray()
var row = 0
var adding = 0
    var dict = NSMutableDictionary()
    var tempdict = NSMutableDictionary()
    var leedid = UserDefaults.standard.integer(forKey: "leed_id")
    var token = UserDefaults.standard.object(forKey: "token") as! String
    @IBOutlet weak var wastegeneratedtxt: UITextField!
    @IBOutlet weak var wastedivertedtxt: UITextField!
    @IBOutlet weak var startdatetxt: UITextField!
    
    @IBOutlet weak var enddatetxt: UITextField!
    
    @IBOutlet weak var startdateview: UIView!
    @IBOutlet weak var enddateview: UIView!
    @IBOutlet weak var spinner: UIView!
    @IBOutlet weak var ctrl: UISegmentedControl!
    @IBAction func segctrl(_ sender: AnyObject) {
        if(ctrl.selectedSegmentIndex == 0){
            tempdict["unit"] = "lbs"
        }else if(ctrl.selectedSegmentIndex == 1){
            tempdict["unit"] = "kg"
        }else{
            tempdict["unit"] = "tons"
        }
        if(self.tempdict == self.dict){
            self.savebtn.isEnabled = false
            self.savebtn.backgroundColor = UIColor.gray
        }else{
            self.savebtn.isEnabled = true
            self.savebtn.backgroundColor = self.bgcolor
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        token = UserDefaults.standard.object(forKey: "token") as! String
    }
    
    @IBOutlet weak var enddatepicker: UIDatePicker!
    @IBOutlet weak var startdatepicker: UIDatePicker!
    
    @IBAction func startdatedone(_ sender: Any) {
        let date = startdatepicker.date
        let format = DateFormatter()
        format.dateFormat = "MMM dd,yyyy"
        startdatetxt.text = "\(format.string(from: date))"
        startdateview.isHidden = true
        let dat = format.date(from: startdatetxt.text!)
        format.dateFormat = "yyyy-MM-dd"
        tempdict["start_date"] = format.string(from: dat!)
        startdatetxt.resignFirstResponder()
        if(tempdict == dict){
            self.savebtn.isEnabled = false
            self.savebtn.backgroundColor = UIColor.gray
        }else{
            self.savebtn.isEnabled = true
            self.savebtn.backgroundColor = bgcolor
        }
    }
    @IBAction func startdatecancel(_ sender: Any) {
        startdateview.isHidden = true
        startdatetxt.resignFirstResponder()
    }
    @IBAction func enddatedone(_ sender: Any) {
        let date = enddatepicker.date
        let format = DateFormatter()
        format.dateFormat = "MMM dd,yyyy"
        enddatetxt.text = "\(format.string(from: date))"
        enddateview.isHidden = true
        let dat = format.date(from: enddatetxt.text!)
        format.dateFormat = "yyyy-MM-dd"
        tempdict["end_date"] = format.string(from: dat!)
        enddatetxt.resignFirstResponder()
        if(tempdict == dict){
            self.savebtn.isEnabled = false
            self.savebtn.backgroundColor = UIColor.gray
        }else{
            self.savebtn.isEnabled = true
            self.savebtn.backgroundColor = bgcolor
        }
    }
    @IBAction func enddatecancel(_ sender: Any) {
        enddateview.isHidden = true
        enddatetxt.resignFirstResponder()
    }
    @IBAction func save(_ sender: AnyObject) {
        DispatchQueue.main.async(execute: {
            self.view.isUserInteractionEnabled = true
            self.spinner.isHidden = false
            if(self.adding == 0){
                if let creditDescription = self.currentarr["CreditStatus"] as? String{
                    if(creditDescription.lowercased() == "under review"){
                        self.showalert("Updation is not allowed when the credit is under review", title: "Error", action: "OK")
                    }else{
                self.updatereading()
                    }
                }
            }else{
                if let creditDescription = self.currentarr["CreditStatus"] as? String{
                    if(creditDescription.lowercased() == "under review"){
                        self.showalert("Updation is not allowed when the credit is under review", title: "Error", action: "OK")
                    }else{
                self.addreading()
                    }
                }
            }
        })
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == startdatetxt){
            startdateview.isHidden = true
            startdatetxt.resignFirstResponder()
        }else if(textField == enddatetxt){
            enddateview.isHidden = true
            enddatetxt.resignFirstResponder()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == startdatetxt){
            self.startdateview.isHidden = false
            self.enddateview.isHidden = true
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "MMM dd,yyyy"
            if((startdatetxt.text?.characters.count)! > 0){
                startdatepicker.setDate(dateFormat.date(from: startdatetxt.text!)!, animated: true)
            }
            
            if((enddatetxt.text?.characters.count)! > 0){
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "MMM dd,yyyy"
                startdatepicker.maximumDate = dateFormat.date(from: enddatetxt.text!)//.setDate(dateFormat.date(from: enddate.text!)!, animated: true)
            }
        }else if(textField == enddatetxt){
            self.startdateview.isHidden = true
            self.enddateview.isHidden = false
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "MMM dd,yyyy"
            if((enddatetxt.text?.characters.count)! > 0){
                enddatepicker.setDate(dateFormat.date(from: enddatetxt.text!)!, animated: true)
            }
            
            enddatepicker.minimumDate = date1

            
        }
    }
    var currentarr = NSMutableDictionary()
    var enddatearr = NSMutableArray()
    @IBOutlet weak var savebtn: UIButton!
    
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(wastegeneratedtxt == textField || wastedivertedtxt == textField){
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            var c = textField.text
            c?.append(string)
            return (string == numberFiltered && c!.characters.count <= 9)
        }
        
        
        
        return false
    }
    
    
    func textchange(_ sender : UITextField){
        if((startdatetxt.text?.characters.count)! > 0 && (enddatetxt.text?.characters.count)! > 0 && (wastedivertedtxt.text?.characters.count)! > 0 && (wastegeneratedtxt.text?.characters.count)! > 0){
            self.savebtn.isEnabled = true
            self.savebtn.backgroundColor = bgcolor
        }else{
            
            self.savebtn.isEnabled = false
            self.savebtn.backgroundColor = UIColor.gray
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ctrl.setTitle("kg", forSegmentAt: 1)
        wastegeneratedtxt.addTarget(self, action: #selector(self.textchange(_:)), for: .editingChanged)
        wastedivertedtxt.addTarget(self, action: #selector(self.textchange(_:)), for: .editingChanged)
        dict = NSMutableDictionary.init(dictionary: dataarr)
        tempdict = NSMutableDictionary.init(dictionary: dataarr)
        print("Init",tempdict["id"])
        let datakeyed = UserDefaults.standard.object(forKey: "currentcategory") as! Data
        let currentcategory = (NSKeyedUnarchiver.unarchiveObject(with: datakeyed) as! NSArray).mutableCopy() as! NSMutableArray
        let current = UserDefaults.standard.integer(forKey: "selected_action")
        UserDefaults.standard.synchronize()
        //print("aarra", currentcategory)
        currentarr = (currentcategory[current] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        var  sortDescriptor = NSSortDescriptor.init(key: "start_date", ascending: true)
        if(self.meters.count > 0){
        for i in self.meters{
            let item = i as! NSDictionary
            enddatearr.add(item)
        }
        sortDescriptor = NSSortDescriptor.init(key: "end_date", ascending: true)
        enddatearr.sort(using: NSArray.init(object: sortDescriptor) as! [NSSortDescriptor])
        
        }
        
        self.titlefont()
        startdatetxt.delegate = self
        enddatetxt.delegate = self
        wastedivertedtxt.delegate = self
        wastegeneratedtxt.delegate = self
        startdatetxt.keyboardType = .numberPad
        enddatetxt.keyboardType = .numberPad
        startdatetxt.inputView = UIView()
        startdateview.isHidden = true
        enddateview.isHidden = true
        self.spinner.isHidden = true
        self.spinner.layer.cornerRadius = 5
        
        self.navigationController?.delegate = self
        if(adding == 0){
        dict = (meters.object(at: row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        tempdict = NSMutableDictionary.init(dictionary: dict)
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let str1 = format.date(from: dict["start_date"] as! String)
        let str2 = format.date(from: dict["end_date"] as! String)
        format.dateFormat = "MMM dd,yyyy"
        let startdate = format.string(from: str1!)
        let enddate = format.string(from: str2!)
        //print(startdate,enddate)
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
            if(dict["unit"] as! String == "kgs" || dict["unit"] as! String == "kg"){
                ctrl.selectedSegmentIndex = 1
            }
            if(dict["unit"] as! String == "tons"){
                ctrl.selectedSegmentIndex = 2
            }
        }
        
        wastegeneratedtxt.text = "\(generated)"
        }
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if(self.adding == 1){
            self.savebtn.setTitle("Create reading", for: UIControlState())
            let calendar = Calendar.current as! NSCalendar
            
            var recentdate = Date()
            var diffint = 0
            for i in meters{
                let item = i as! NSDictionary
                let arr = item.mutableCopy() as! NSMutableDictionary
                let calendar = Calendar.current
                
                // Replace the hour (time) of both dates with 00:00
                let date1 = calendar.startOfDay(for: Date())
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = credentials().micro_secs
                dateFormat.dateFormat = "yyyy-MM-dd"
                let str = arr["end_date"] as! String
                let dat2 = calendar.startOfDay(for: dateFormat.date(from: str)!)
                let flags = NSCalendar.Unit.day
                let components = (calendar as NSCalendar).components(flags, from: date1, to: dat2, options: [])
                
                if(components.day! > 0 && diffint < components.day!){
                    diffint = components.day!
                    recentdate = dat2
                    date2 = dat2
                }
            }
            
            if(date2 != nil){
                var newstartdate = Calendar.current.date(byAdding: .day, value: 1, to: date2)
                var newenddate = Calendar.current.date(byAdding: .month, value: 1, to: newstartdate!)
                newenddate = Calendar.current.date(byAdding: .day, value: -1, to: newenddate!)
                //print(newstartdate,newenddate)
                
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd"
                var str = dateFormat.string(from: newstartdate!)
                newstartdate = dateFormat.date(from: str)!
                date1 = newstartdate!
                dateFormat.dateFormat = "MMM dd,yyyy"
                str = dateFormat.string(from: newstartdate!)
                startdatetxt.text = str
                
                dateFormat.dateFormat = "yyyy-MM-dd"
                str = dateFormat.string(from: newenddate!)
                newenddate = dateFormat.date(from: str)!
                dateFormat.dateFormat = "MMM dd,yyyy"
                date2 = newenddate!
                str = dateFormat.string(from: newenddate!)
                
                enddatetxt.text = str
            }else{
                if(meters.count > 0){
                    let dateFormat = DateFormatter()
                    let item = meters.lastObject as! NSDictionary
                    dateFormat.dateFormat = credentials().micro_secs
                    dateFormat.dateFormat = "yyyy-MM-dd"
                    date2 = dateFormat.date(from: item["end_date"] as! String)
                    var newstartdate = Calendar.current.date(byAdding: .day, value: 1, to: date2)
                    var newenddate = Calendar.current.date(byAdding: .month, value: 1, to: newstartdate!)
                    newenddate = Calendar.current.date(byAdding: .day, value: -1, to: newenddate!)
                    //print(newstartdate,newenddate)
                    
                    dateFormat.dateFormat = "yyyy-MM-dd"
                    var str = dateFormat.string(from: newstartdate!)
                    newstartdate = dateFormat.date(from: str)!
                    date1 = newstartdate!
                    dateFormat.dateFormat = "MMM dd,yyyy"
                    str = dateFormat.string(from: newstartdate!)
                    startdatetxt.text = str
                    
                    dateFormat.dateFormat = "yyyy-MM-dd"
                    str = dateFormat.string(from: newenddate!)
                    newenddate = dateFormat.date(from: str)!
                    dateFormat.dateFormat = "MMM dd,yyyy"
                    date2 = newenddate!
                    str = dateFormat.string(from: newenddate!)
                    enddatetxt.text = str
                }else{
                    let dateFormat = DateFormatter()
                    
                    dateFormat.dateFormat = "yyyy-MM-dd"
                    date2 = Date()
                    var newstartdate = Calendar.current.date(byAdding: .day, value: 0, to: date2)
                    var newenddate = Calendar.current.date(byAdding: .month, value: 1, to: newstartdate!)
                    newenddate = Calendar.current.date(byAdding: .day, value: -1, to: newenddate!)
                    //print(newstartdate,newenddate)
                    
                    dateFormat.dateFormat = "yyyy-MM-dd"
                    var str = dateFormat.string(from: newstartdate!)
                    newstartdate = dateFormat.date(from: str)!
                    date1 = newstartdate!
                    dateFormat.dateFormat = "MMM dd,yyyy"
                    str = dateFormat.string(from: newstartdate!)
                    startdatetxt.text = str
                    
                    dateFormat.dateFormat = "yyyy-MM-dd"
                    str = dateFormat.string(from: newenddate!)
                    newenddate = dateFormat.date(from: str)!
                    dateFormat.dateFormat = "MMM dd,yyyy"
                    date2 = newenddate!
                    str = dateFormat.string(from: newenddate!)
                    enddatetxt.text = str
                }
            }
        }else{
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = credentials().micro_secs
            dateFormat.dateFormat = "yyyy-MM-dd"
            var str = dataarr["start_date"] as! String
            date1 = dateFormat.date(from: str)!
            dateFormat.dateFormat = "MMM dd,yyyy"
            str = dateFormat.string(from: date1)
            startdatetxt.text = str
            
            var str2 = dataarr["end_date"] as! String
            dateFormat.dateFormat = credentials().micro_secs
            dateFormat.dateFormat = "yyyy-MM-dd"
            date2 = dateFormat.date(from: str2)!
            dateFormat.dateFormat = "MMM dd,yyyy"
            str2 = dateFormat.string(from: date2)
            let calendar = Calendar.current
            let twoDaysAgo = (calendar as NSCalendar).date(byAdding: .day, value: 0, to: date2, options: [])
            str2 = dateFormat.string(from: twoDaysAgo!)
            enddatetxt.text = str2
            wastegeneratedtxt.text = String(format:"%d",dataarr["waste_generated"] as! Int)
            wastedivertedtxt.text = String(format:"%d",dataarr["waste_diverted"] as! Int)
            savebtn.setTitle("Update reading", for: UIControlState())
        }
        if(adding == 1){
            tempdict["unit"] = "lbs"
            ctrl.selectedSegmentIndex = 0
        }
        bgcolor = self.savebtn.backgroundColor!
        
            self.savebtn.isEnabled = false
            self.savebtn.backgroundColor = UIColor.gray
        
        var dateFormat = DateFormatter()
        dateFormat.dateFormat = "MMM dd,yyyy"
        date2 = dateFormat.date(from: startdatetxt.text!)!
        dateFormat.dateFormat = "yyyy-MM-dd"
        tempdict["start_date"] = dateFormat.string(from: date2)
        
        dateFormat.dateFormat = "MMM dd,yyyy"
        date2 = dateFormat.date(from: enddatetxt.text!)!
        dateFormat.dateFormat = "yyyy-MM-dd"
        tempdict["end_date"] = dateFormat.string(from: date2)
        
        // Do any additional setup after loading the view.
    }
    var bgcolor = UIColor()
    func startdateValueChanged(_ sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        startdatetxt.text = dateFormatter.string(from: sender.date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let str = dateFormatter.string(from: sender.date)
        tempdict["start_date"] = str
    }
    
    func enddateValueChanged(_ sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        enddatetxt.text = dateFormatter.string(from: sender.date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let str = dateFormatter.string(from: sender.date)
        tempdict["end_date"] = str
    }
var date2:Date!
var date1:Date!
var dataarr = NSMutableDictionary()
    func updatereading(){
        
        var generated = 0
        var diverted = 0
        if(wastegeneratedtxt.text != "" && wastedivertedtxt.text != ""){
                generated = Int(wastegeneratedtxt.text!)!
                diverted = Int(wastedivertedtxt.text!)!
            print(tempdict)
            
            if(tempdict["unit"] == nil){
                tempdict["unit"] = ctrl.titleForSegment(at: 0)
            }
            
            if(generated > diverted){
                //Yes
                var payload = NSMutableString()
                payload.append("{")
                var str = payload as String
                payload.append("\"start_date\": \"\(tempdict["start_date"]!)\",")
                payload.append("\"end_date\":\"\(tempdict["end_date"]!)\",")
                payload.append("\"waste_generated\":\(generated),")
                payload.append("\"waste_diverted\":\(diverted),")
                payload.append("\"unit\": \"\(tempdict["unit"] as! String)\"")
                payload.append("}")
                str = payload as String
                print("end",tempdict["id"])
                print(str,tempdict["id"])
                let url = URL.init(string:String(format: "%@assets/LEED:%d/waste/ID:%d/?recompute_score=1",credentials().domain_url, leedid, tempdict["id"] as! Int))
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
                //download_requests.append(session)
                var task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                    guard error == nil && data != nil else {                                                          // check for fundamental networking error
                        //print("error=\(error)")
                        DispatchQueue.main.async(execute: {
                            self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                            
                        })
                        return
                    }
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                        DispatchQueue.main.async(execute: {
                            self.spinner.isHidden = true
                            self.view.isUserInteractionEnabled = true
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                        })
                    } else
                        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                            //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                            //print("response = \(response)")
                            DispatchQueue.main.async(execute: {
                                self.spinner.isHidden = true
                                self.view.isUserInteractionEnabled = true
                            })
                        }else{
                            
                            var jsonDictionary : NSDictionary
                            do {
                                jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                                //print(jsonDictionary)
                                self.tempdict = NSMutableDictionary.init(dictionary: jsonDictionary.mutableCopy() as! NSMutableDictionary)
                                self.dict =  NSMutableDictionary.init(dictionary: self.tempdict)
                                self.meters.replaceObject(at: self.row, with: self.dict)
                                if(self.tempdict == self.dict){
                                    self.savebtn.isEnabled = false
                                    self.savebtn.backgroundColor = UIColor.gray
                                }else{
                                    self.savebtn.isEnabled = true
                                    self.savebtn.backgroundColor = self.bgcolor
                                }
                                //self.tableview.reloadData()
                                // self.buildingactions(subscription_key, leedid: leedid)
                                DispatchQueue.main.async(execute: {
                                    self.spinner.isHidden = true
                                    self.maketoast("Reading updated successfully", type: "message")
                                    self.navigationController?.popViewController(animated: true)
                                })
                            } catch {
                                //print(error)
                            }
                    }
                    
                }) 
                task.resume()
            }else{
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                self.maketoast("Generated waste shouldn't be lesser than the waste diverted",type: "error")
                })
            }
        }else{
            DispatchQueue.main.async(execute: {
                self.spinner.isHidden = true
                self.view.isUserInteractionEnabled = true
            self.maketoast("All fields are mandatory",type: "error")
            })
        }
    }

    
    func addreading(){
        
        var generated = 0
        var diverted = 0
        if(wastegeneratedtxt.text != "" && wastedivertedtxt.text != "" && startdatetxt.text != "" && enddatetxt.text != ""){
            generated = Int(wastegeneratedtxt.text!)!
            diverted = Int(wastedivertedtxt.text!)!
            print(tempdict)
            if(generated > diverted){
                //Yes
                var payload = NSMutableString()
                payload.append("{")
                var str = payload as String
                payload.append("\"start_date\": \"\(tempdict["start_date"]!)\",")
                payload.append("\"end_date\":\"\(tempdict["end_date"]!)\",")
                payload.append("\"waste_generated\":\(generated),")
                payload.append("\"waste_diverted\":\(diverted),")
                payload.append("\"unit\": \"\(tempdict["unit"] as! String)\"")
                payload.append("}")
                str = payload as String
                //print(str,tempdict["id"])
                let url = URL.init(string:String(format: "%@assets/LEED:%d/waste/?recompute_score=1",credentials().domain_url, leedid))
                ////print(url?.absoluteURL)
                var subscription_key = credentials().subscription_key
                var token = UserDefaults.standard.object(forKey: "token") as! String
                
                let request = NSMutableURLRequest.init(url: url!)
                request.httpMethod = "POST"
                request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
                request.addValue("application/json", forHTTPHeaderField:"Content-type" )
                request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
                var httpbody = str
                print(str)
                request.httpBody = httpbody.data(using: String.Encoding.utf8)
                let session = URLSession(configuration: URLSessionConfiguration.default)
                //download_requests.append(session)
                var task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                    guard error == nil && data != nil else {                                                          // check for fundamental networking error
                        //print("error=\(error)")
                        DispatchQueue.main.async(execute: {
                            self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                            
                        })
                        return
                    }
                    if let httpStatus = response as? HTTPURLResponse{
                        print(httpStatus.statusCode)
                    }
                
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                        DispatchQueue.main.async(execute: {
                            self.spinner.isHidden = true
                            self.view.isUserInteractionEnabled = true
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                        })
                    } else
                        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 201 {           // check for http errors
                            //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                            //print("response = \(response)")
                            
                            var jsonDictionary : NSDictionary
                            do {
                                jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                                //print(jsonDictionary)
                                self.tempdict = jsonDictionary.mutableCopy() as! NSMutableDictionary
                                self.meters.add(self.tempdict)
                                DispatchQueue.main.async(execute: {
                                    self.maketoast("Reading added successfully", type: "message")
                                    self.navigationController?.popViewController(animated: true)
                                })
                            } catch {
                                //print(error)
                            }
                        }else{
                            var jsonDictionary : NSDictionary
                            do {
                                jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                                print(jsonDictionary)
                                DispatchQueue.main.async(execute: {
                                if let s = jsonDictionary["non_field_errors"] as? String{                                    
                                self.maketoast(s, type: "error")
                                }else if let s = jsonDictionary["non_field_errors"] as? NSArray{
                                    self.maketoast(s[0] as! String, type: "error")
                                }
                                    self.spinner.isHidden = true
                                    self.view.isUserInteractionEnabled = true
                                })
                            } catch {
                                //print(error)
                            }
                            DispatchQueue.main.async(execute: {
                                self.spinner.isHidden = true
                                self.view.isUserInteractionEnabled = true
                            })
                    }
                    
                }) 
                task.resume()
            }else{
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    self.maketoast("Generated waste shouldn't be lesser than the waste diverted",type: "error")
                })
                
            }
        }else{
            DispatchQueue.main.async(execute: {
            self.spinner.isHidden = true
            self.view.isUserInteractionEnabled = true
            self.maketoast("All fields are mandatory",type: "error")
            })
        }
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if(viewController is wastereadings){
            let v = viewController as! wastereadings
            if(adding == 0){
                self.meters.replaceObject(at: row, with: self.dict)
            }
            v.meters = self.meters
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        //self.navigationController?.delegate = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showalert(_ message:String, title:String, action:String){
        
        //let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        //let callActionHandler = { (action:UIAlertAction!) -> Void in
        DispatchQueue.main.async(execute: {
            self.view.isUserInteractionEnabled = true
            self.spinner.isHidden = true
            self.view.isUserInteractionEnabled = true
            self.maketoast(message, type: "error")
            // self.navigationController?.popViewControllerAnimated(true)
        })
        
        //        }
        //      let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        //    alertController.addAction(defaultAction)
        
        //presentViewController(alertController, animated: true, completion: nil)
        
        
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
