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
            tempdict["unit"] = "kgs"
        }else{
            tempdict["unit"] = "tons"
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
            startdateview.isHidden = false
        }else if(textField == enddatetxt){
            enddateview.isHidden = false
        }
    }
    var currentarr = NSMutableDictionary()
    var enddatearr = NSMutableArray()
    @IBOutlet weak var savebtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let datakeyed = UserDefaults.standard.object(forKey: "currentcategory") as! Data
        let currentcategory = (NSKeyedUnarchiver.unarchiveObject(with: datakeyed) as! NSArray).mutableCopy() as! NSMutableArray
        let current = UserDefaults.standard.integer(forKey: "selected_action")
        UserDefaults.standard.synchronize()
        //print("aarra", currentcategory)
        currentarr = (currentcategory[current] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        tempdict = dict        
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
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if(adding == 1){
        if(enddatearr.count > 0){
        let date1 = dateFormatter.date(from: (enddatearr.lastObject as! NSDictionary)["end_date"] as! String)
        let today = date1
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today!)
        dateFormatter.dateFormat = "MMM dd,yyyy"
        
            
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day , .month , .year], from: tomorrow!)
        let year =  components.year
        let month = components.month
        let day = components.day
        let dateFormatter: DateFormatter = DateFormatter()
        let months = dateFormatter.shortMonthSymbols
        let monthSymbol = months?[month!+1]
        let nextmonth = months?[month!]
        dateFormatter.dateFormat = "MMM dd,yyyy"
        //var date = dateFormatter.date(from: String(format: "%d %@ to %d %@", day!,monthSymbol!, day!,nextmonth!))
        print(String(format: "%d %@ to %d %@", day!,monthSymbol!, day!,nextmonth!))
        var date = tomorrow
            var str = dateFormatter.string(from: tomorrow!)
            startdatetxt.text = str
            datePickerView.minimumDate = date
            //startdatetxt.inputView = datePickerView
            datePickerView.date = date!
            startdatepicker.date = date!
            datePickerView.addTarget(self, action: #selector(self.startdateValueChanged), for: UIControlEvents.valueChanged)
            
            dateFormatter.dateFormat = "MMM dd,yyyy"
            str = String(format: "%@ %02d,%d", nextmonth!,day!,year!)
            date = dateFormatter.date(from: str)
            date = Calendar.current.date(byAdding: .day, value: -1, to: date!)
            enddatetxt.text = dateFormatter.string(from: date!)
            dateFormatter.dateFormat = "MMM dd,yyyy"
            date = dateFormatter.date(from: enddatetxt.text!)
            enddatepicker.date = date!
            date = dateFormatter.date(from: startdatetxt.text!)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            tempdict["start_date"] = dateFormatter.string(from: date!)
            
            dateFormatter.dateFormat = "MMM dd,yyyy"
            date = dateFormatter.date(from: enddatetxt.text!)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            tempdict["end_date"] = dateFormatter.string(from: date!)
        }else{
            let tomorrow = Date()
            dateFormatter.dateFormat = "MMM dd,yyyy"
            
            
            let calendar = Calendar.current
            let components = (calendar as NSCalendar).components([.day , .month , .year], from: tomorrow)
            let year =  components.year
            let month = components.month
            let day = components.day
            let dateFormatter: DateFormatter = DateFormatter()
            let months = dateFormatter.shortMonthSymbols
            let monthSymbol = months?[month!+1]
            let nextmonth = months?[month!]
            dateFormatter.dateFormat = "MMM dd,yyyy"
            //var date = dateFormatter.date(from: String(format: "%d %@ to %d %@", day!,monthSymbol!, day!,nextmonth!))
            print(String(format: "%d %@ to %d %@", day!,monthSymbol!, day!,nextmonth!))
            var date = tomorrow
            var str = dateFormatter.string(from: tomorrow)
            startdatetxt.text = str
            datePickerView.minimumDate = date
            //startdatetxt.inputView = datePickerView
            datePickerView.date = date
            startdatepicker.date = date
            datePickerView.addTarget(self, action: #selector(self.startdateValueChanged), for: UIControlEvents.valueChanged)
            
            dateFormatter.dateFormat = "MMM dd,yyyy"
            str = String(format: "%@ %02d,%d", nextmonth!,day!,year!)
            date = dateFormatter.date(from: str)!
            date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
            enddatetxt.text = dateFormatter.string(from: date)
            dateFormatter.dateFormat = "MMM dd,yyyy"
            date = dateFormatter.date(from: enddatetxt.text!)!
            enddatepicker.date = date
            date = dateFormatter.date(from: startdatetxt.text!)!
            dateFormatter.dateFormat = "yyyy-MM-dd"
            tempdict["start_date"] = dateFormatter.string(from: date)
            
            dateFormatter.dateFormat = "MMM dd,yyyy"
            date = dateFormatter.date(from: enddatetxt.text!)!
            dateFormatter.dateFormat = "yyyy-MM-dd"
            tempdict["end_date"] = dateFormatter.string(from: date)

            
        }
        }else{
            var str1 = dict["start_date"] as! String
            dateFormatter.dateFormat = "yyyy-MM-dd"
            var date1 = dateFormatter.date(from: str1)
            dateFormatter.dateFormat = "MMM dd,yyyy"
            str1 = dateFormatter.string(from: date1!)
            
            var str2 = dict["end_date"] as! String
            dateFormatter.dateFormat = "yyyy-MM-dd"
            var date2 = dateFormatter.date(from: str2)
            dateFormatter.dateFormat = "MMM dd,yyyy"
            str2 = dateFormatter.string(from: date2!)
            enddatetxt.text = str2
            startdatetxt.text = str1
            var date = dateFormatter.date(from: startdatetxt.text!)!
            datePickerView.minimumDate = date
            datePickerView.maximumDate = Date()
            //startdatetxt.inputView = datePickerView
            datePickerView.date = date
            startdatepicker.date = date
            datePickerView.addTarget(self, action: #selector(self.startdateValueChanged), for: UIControlEvents.valueChanged)
            
            
            let datePickerView1:UIDatePicker = UIDatePicker()
            
            datePickerView1.datePickerMode = UIDatePickerMode.date
            dateFormatter.dateFormat = "MMM dd,yyyy"
            date = dateFormatter.date(from: enddatetxt.text!)!
            datePickerView1.minimumDate = date
            datePickerView1.maximumDate = Date()
            enddatetxt.inputView = UIView()
            datePickerView1.date = date
            enddatepicker.date = date
            datePickerView1.addTarget(self, action: #selector(self.enddateValueChanged), for: UIControlEvents.valueChanged)
            tempdict["start_date"] = dict["start_date"]
            tempdict["end_date"] = dict["end_date"]
        }
        if(adding == 1){
            tempdict["unit"] = "lbs"
            ctrl.selectedSegmentIndex = 0
        }
        
        // Do any additional setup after loading the view.
    }
    
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

    
    func updatereading(){
        
        var generated = 0
        var diverted = 0
        if(wastegeneratedtxt.text != "" && wastedivertedtxt.text != ""){
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
                                self.tempdict = jsonDictionary.mutableCopy() as! NSMutableDictionary
                                self.dict =  self.tempdict
                                self.meters.replaceObject(at: self.row, with: self.dict)
                                //self.tableview.reloadData()
                                // self.buildingactions(subscription_key, leedid: leedid)
                                DispatchQueue.main.async(execute: {
                                    self.spinner.isHidden = true
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
                                    self.navigationController?.popViewController(animated: true)
                                })
                            } catch {
                                //print(error)
                            }
                        }else{
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
