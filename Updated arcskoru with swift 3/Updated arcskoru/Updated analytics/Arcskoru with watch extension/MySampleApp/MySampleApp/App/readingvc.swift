//
//  readingvc.swift
//  LEEDOn
//
//  Created by Group X on 25/11/16.
//  Copyright © 2016 USGBC. All rights reserved.
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


class readingvc: UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var startdate: UITextField!
    @IBOutlet weak var reading: UITextField!
    var dataarr = NSMutableDictionary()
    var addreading = 0
    var id = 0
    var domain_url = ""
    var listofreadings = NSMutableArray()
    @IBOutlet weak var enddate: UITextField!
    var date2:Date!
    var currentindex = 0
    var date1 : Date!
    var currentarr = NSMutableDictionary()
    var bgcolor = UIColor()
    var iterate = 0
    var p = false
    override func viewDidLoad() {
        super.viewDidLoad()
        bgcolor = self.updatebtn.backgroundColor!
        self.updatebtn.isEnabled = false
        self.updatebtn.backgroundColor = UIColor.gray
        let datakeyed = UserDefaults.standard.object(forKey: "currentcategory") as! Data
        let currentcategory = (NSKeyedUnarchiver.unarchiveObject(with: datakeyed) as! NSArray).mutableCopy() as! NSMutableArray
        let current = UserDefaults.standard.integer(forKey: "selected_action")
        UserDefaults.standard.synchronize()
        //print("aarra", currentcategory)
        currentarr = (currentcategory[current] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        //print(listofreadings)
        self.startdateview.isHidden = true
        self.enddateview.isHidden = true
        self.navigationController?.navigationItem.leftBarButtonItem?.title = "Done"
        self.titlefont()
        self.spinner.isHidden = true
        self.spinner.layer.cornerRadius = 5
        //print("datar %@", listofreadings,id)
        navigationController?.delegate = self
        domain_url = credentials().domain_url
        //listofreadings = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("selreading") as! NSData)?.mutableCopy() as! NSMutableArray
        //id = NSUserDefaults.standardUserDefaults().integerForKey("meterID")
        self.updatebtn.isEnabled = true
        if(addreading == 1){
            updatebtn.setTitle("Create reading", for: UIControlState())
            let calendar = Calendar.current as! NSCalendar
            
            var recentdate = Date()
            var diffint = 0
            for i in listofreadings{
                let item = i as! NSDictionary
                let arr = item.mutableCopy() as! NSMutableDictionary
                let calendar = Calendar.current
                
                // Replace the hour (time) of both dates with 00:00
                let date1 = calendar.startOfDay(for: Date())
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = credentials().micro_secs
                let str = arr["end_date"] as! String
                let dat2 = calendar.startOfDay(for: dateFormat.date(from: str)!)
                let flags = NSCalendar.Unit.day
                let components = (calendar as NSCalendar).components(flags, from: date1, to: dat2, options: [])
                print(components.day)
                if(components.day > 0 && diffint < components.day){
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
            startdate.text = str
            
            dateFormat.dateFormat = "yyyy-MM-dd"
            str = dateFormat.string(from: newenddate!)
            newenddate = dateFormat.date(from: str)!
            dateFormat.dateFormat = "MMM dd,yyyy"
            date2 = newenddate!
            str = dateFormat.string(from: newenddate!)
            enddate.text = str
            }else{
                if(listofreadings.count > 0){
                    let dateFormat = DateFormatter()
                let item = listofreadings.lastObject as! NSDictionary
                    dateFormat.dateFormat = credentials().micro_secs
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
                    startdate.text = str
                    
                    dateFormat.dateFormat = "yyyy-MM-dd"
                    str = dateFormat.string(from: newenddate!)
                    newenddate = dateFormat.date(from: str)!
                    dateFormat.dateFormat = "MMM dd,yyyy"
                    date2 = newenddate!
                    str = dateFormat.string(from: newenddate!)
                    enddate.text = str
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
                    startdate.text = str
                    
                    dateFormat.dateFormat = "yyyy-MM-dd"
                    str = dateFormat.string(from: newenddate!)
                    newenddate = dateFormat.date(from: str)!
                    dateFormat.dateFormat = "MMM dd,yyyy"
                    date2 = newenddate!
                    str = dateFormat.string(from: newenddate!)
                    enddate.text = str
                }
            }
        }else{
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = credentials().micro_secs
            var str = dataarr["start_date"] as! String
            date1 = dateFormat.date(from: str)!
            dateFormat.dateFormat = "MMM dd,yyyy"
            str = dateFormat.string(from: date1)
            startdate.text = str
            
            var str2 = dataarr["end_date"] as! String
            dateFormat.dateFormat = credentials().micro_secs
            date2 = dateFormat.date(from: str2)!
            dateFormat.dateFormat = "MMM dd,yyyy"
            str2 = dateFormat.string(from: date2)
            let calendar = Calendar.current
            let twoDaysAgo = (calendar as NSCalendar).date(byAdding: .day, value: 0, to: date2, options: [])
            str2 = dateFormat.string(from: twoDaysAgo!)
            enddate.text = str2
            reading.text = String(format:"%d",dataarr["reading"] as! Int)
            updatebtn.setTitle("Update reading", for: UIControlState())
        }
        //enddate.inputView = datepicker
        
        // Do any additional setup after loading the view.
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = UIScreen.main.bounds.size.height
        self.tableview.frame.size.height = 3 * (0.075 * height)
        return 0.075 * height
    }
    
    
    func removeTextFieldObserver() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidChange, object: alert.textFields![0])
    }
    var alert = UIAlertController()
    weak var AddAlertSaveAction: UIAlertAction?
    
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
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField.tag == 2){
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered
        }
        return true
    }

    
    func showalert(_ index: Int, title : String, value : String){
        DispatchQueue.main.async(execute: {
            self.alert = UIAlertController(title: "", message: "Enter the \(title )", preferredStyle: UIAlertControllerStyle.alert)
            self.alert.addTextField(configurationHandler: self.configurationTextField)
            self.alert.textFields?[0].tag = index
            self.alert.textFields?[0].delegate = self
            let otherAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
                //print("User click Ok button")
                let txtfld = self.alert.textFields![0] 
                if(index == 2){
                    self.reading.text = txtfld.text! 
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
            self.alert.textFields![0].keyboardType = .numberPad
            self.startdateview.isHidden = true
            self.enddateview.isHidden = true
            self.alert.view.subviews.first?.backgroundColor = UIColor.white
        self.alert.view.layer.cornerRadius = 10
        self.alert.view.layer.masksToBounds = true
            self.present(self.alert, animated: true, completion: {
                //print("completion block")
            })
        })
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        p = true
        if(indexPath.row == 0){
            self.startdateview.isHidden = false
            self.enddateview.isHidden = true
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "MMM dd,yyyy"
            if(startdate.text?.characters.count > 0){
            startdatepicker.setDate(dateFormat.date(from: startdate.text!)!, animated: true)
            }
            date1 = startdatepicker.date
        }else if(indexPath.row == 1){
            self.startdateview.isHidden = true
            self.enddateview.isHidden = false
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "MMM dd,yyyy"
            if(enddate.text?.characters.count > 0){
            enddatepicker.setDate(dateFormat.date(from: enddate.text!)!, animated: true)
            }
            enddatepicker.minimumDate = date1
            
        }else if(indexPath.row == 2){
            //print("Meter reading")
            self.showalert(2, title: "Reading", value: self.reading.text!)
        }
    }
    
    
    @IBOutlet weak var startdatepicker: UIDatePicker!
    
    @IBAction func startdatecancel(_ sender: AnyObject) {
        self.startdateview.isHidden = true
    }
    @IBAction func startdatedone(_ sender: AnyObject) {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        var str = dateFormat.string(from: startdatepicker.date)
        date1 = dateFormat.date(from: str)!
        dateFormat.dateFormat = "MMM dd,yyyy"
        str = dateFormat.string(from: date1)
        startdate.text = str
        self.startdateview.isHidden = true
        self.iterate = 0
        self.tableview.reloadData()
    }
    @IBOutlet weak var startdateview: UIView!
    @IBOutlet weak var tableview: UITableView!
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    @IBAction func enddatedone(_ sender: AnyObject) {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        var str = dateFormat.string(from: enddatepicker.date)
        date2 = dateFormat.date(from: str)!
        dateFormat.dateFormat = "MMM dd,yyyy"
        str = dateFormat.string(from: date2)
        enddate.text = str
        self.enddateview.isHidden = true
        self.iterate = 0
        self.tableview.reloadData()
    }
    @IBOutlet weak var enddatepicker: UIDatePicker!
    
    @IBAction func enddatecancel(_ sender: AnyObject) {
        self.enddateview.isHidden = true
    }
    @IBOutlet weak var enddateview: UIView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        if(indexPath.row == 0){
            cell.textLabel?.text = "Start date"
            if(startdate.text?.characters.count > 0){
            cell.detailTextLabel?.text = startdate.text
                iterate = iterate  + 1
            }else{
                cell.detailTextLabel?.text = ""
            }
        }else if(indexPath.row == 1){
            cell.textLabel?.text = "End date"
            if(enddate.text?.characters.count > 0){
            cell.detailTextLabel?.text = enddate.text
                iterate = iterate + 1
            }else{
                cell.detailTextLabel?.text = ""
            }
        }else if(indexPath.row == 2){
            cell.textLabel?.text = "Reading"
            if(enddate.text?.characters.count > 0){
                cell.detailTextLabel?.text = self.reading.text
                iterate = iterate + 1
            }else{
                cell.detailTextLabel?.text = ""
            }
        }
        DispatchQueue.main.async(execute: {
        if(self.iterate == 3 || self.p == true){
            self.updatebtn.isEnabled = true
            self.updatebtn.backgroundColor = self.bgcolor
        }else{
            self.updatebtn.isEnabled = false
            self.updatebtn.backgroundColor = UIColor.gray
            }})
        
        return cell
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        var buildingdetails = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.navigationItem.title = buildingdetails["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as? String
    }
    
    func buildingactions(_ subscription_key:String, leedid: Int){
        let url = URL.init(string: String(format: "%@assets/LEED:%d/actions/",credentials().domain_url,leedid))
        ////print(url?.absoluteURL)
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
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
                        let jsonDictionary : NSDictionary
                        do {
                            jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                            if(jsonDictionary["error"] != nil){
                                if let snapshotValue = jsonDictionary["error"] as? NSArray, let currentcountr = snapshotValue[0] as? NSDictionary, let currentstat = currentcountr["message"] as? String {
                                self.showalert(currentstat, title: "Error", action: "OK")
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
                    
                    let jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        //print(jsonDictionary)
                        if(self.addreading == 1){
                        self.listofreadings.add(self.dataarr)
                        }
                        let datakeyed = NSKeyedArchiver.archivedData(withRootObject: jsonDictionary)
                        UserDefaults.standard.set(datakeyed, forKey: "actions_data")
                        UserDefaults.standard.synchronize()
                        UserDefaults.standard.set(0, forKey: "row")
                        DispatchQueue.main.async(execute: {
                            self.spinner.isHidden = true
                            self.view.isUserInteractionEnabled = true
                            self.navigationController?.popViewController(animated: true)
                        })
                        
                    } catch {
                        //print(error)
                        DispatchQueue.main.async(execute: {
                            let jsonDictionary : NSDictionary
                            do {
                                jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                                if(jsonDictionary["error"] != nil){
                                    if let snapshotValue = jsonDictionary["error"] as? NSArray, let currentcountr = snapshotValue[0] as? NSDictionary, let currentstat = currentcountr["message"] as? String {
                                self.showalert(currentstat, title: "Error", action: "OK")
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
            
        }) 
        task.resume()
    }

    

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? listall {
            let datarray = controller.dataarr.mutableCopy() as! NSMutableArray
            if(addreading == 0){
                (datarray as AnyObject).replaceObject(at: currentindex, with: dataarr)
                controller.dataarr = datarray
            }else{
                controller.dataarr = listofreadings
            }
            //print(datarray)
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
    @IBAction func startediting(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let date = dateFormatter.date(from: "01/01/2012")!
        datePickerView.minimumDate = date
        datePickerView.maximumDate = Date()
        sender.inputView = datePickerView
        if(date1 == nil){
            
        }else{
        datePickerView.date = date1
        }
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
    }
    
    @IBOutlet weak var spinner: UIView!
    
    
    func datePickerValueChanged(_ sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        
        startdate.text = dateFormatter.string(from: sender.date)
        
        
    }
    func datePickerValueChangedforenddate(_ sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        enddate.text = dateFormatter.string(from: sender.date)
        
        
    }

    @IBAction func startdateeditend(_ sender: AnyObject) {
        //print("Finished")
    }
    let token = UserDefaults.standard.object(forKey: "token") as! String
    
    @IBAction func dideditenddate(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from: "01/01/2012")!
        if(startdate.text != ""){
            if(date1 == nil){
        datePickerView.minimumDate = date
            }else{
        datePickerView.minimumDate = date1
            }
        }else{
        datePickerView.minimumDate = date
        }
        datePickerView.maximumDate = Date()
        if(date2 == nil){
            datePickerView.date = Date()
        }else{
            datePickerView.date = date2
        }
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChangedforenddate), for: UIControlEvents.valueChanged)
    }
    @IBOutlet weak var updatebtn: UIButton!
    
    @IBAction func updateit(_ sender: AnyObject) {
        // submit data
        if let creditDescription = self.currentarr["CreditStatus"] as? String{
            if(creditDescription.lowercased() == "under review"){
                self.showalert("Updation is not allowed when the credit is under review", title: "Error", action: "OK")
            }else{
        if(startdate.text?.characters.count > 0 && enddate.text?.characters.count > 0 && reading.text?.characters.count > 0){
        self.spinner.isHidden = false
        self.view.isUserInteractionEnabled = false
        if(addreading == 0){
        let consumption_ID = dataarr["id"] as! Int
        var d = dataarr["meter"] as! NSDictionary
        let meter_ID = d["id"] as! Int
        d = dataarr["building"] as! NSDictionary
        let leedid = d["leed_id"] as! Int
        let url = URL.init(string:String(format: "%@assets/LEED:%d/meters/ID:%d/consumption/ID:%d/?recompute_score=1",domain_url, leedid,meter_ID, consumption_ID))
        ////print(url?.absoluteURL)
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd,yyyy"
            var startdatestr = ""
            var enddatestr = ""
            var dated1 = Date()
            var dated2 = Date()
            dated1 = formatter.date(from: startdate.text!)!
            dated2 = formatter.date(from: enddate.text!)!
            formatter.dateFormat = "yyyy-MM-dd"
            startdatestr = formatter.string(from: dated1)
            enddatestr = formatter.string(from: dated2)
            dataarr["start_date"] = startdatestr
            dataarr["end_data"] = enddatestr
            dataarr["reading"] = Int(reading.text!)! 
            let subscription_key = credentials().subscription_key
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "PUT"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var httpbody = String(format: "{\"start_date\":\"%@\",\"end_date\":\"%@\",\"reading\":%d}",startdatestr,enddatestr,Int(reading.text!)!)
        
        //print(httpbody)
        request.httpBody = httpbody.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
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
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print(jsonDictionary)
                    DispatchQueue.main.async(execute: {
                        if(jsonDictionary["non_field_errors"] != nil){
                            if let arr = jsonDictionary["non_field_errors"] as? NSArray, let first = arr[0] as? String{
                            let alert = UIAlertController(title: "Error", message: first.replacingOccurrences(of: "00:00:00+00:00", with: ""), preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            self.spinner.isHidden = true
                            self.view.isUserInteractionEnabled = true
                            }
                        }else{
                            self.showalert("Something went wrong. Please try again later", title: "Error", action: "OK")
                        }
                        
                    })
                }catch{
                    
                }
            }else{
                
                
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print(jsonDictionary)
                    self.dataarr = jsonDictionary.mutableCopy() as! NSMutableDictionary as! NSMutableDictionary
                    //self.tableview.reloadData()
                    // self.buildingactions(subscription_key, leedid: leedid)
                    DispatchQueue.main.async(execute: {
                        self.maketoast("Reading successfully updated", type: "message")
                    self.buildingactions(subscription_key, leedid: leedid)
                    
                    })
                } catch {
                    //print(error)
                }
            }
            
        }) 
        task.resume()
        }else{
            if(startdate.text?.characters.count > 0 && enddate.text?.characters.count > 0 && reading.text?.characters.count > 0) {
            let meter_ID = id
            //print(id)
            let leedid = UserDefaults.standard.integer(forKey: "leed_id")
            let url = URL.init(string:String(format: "%@assets/LEED:%d/meters/ID:%d/consumption/?recompute_score=1",domain_url, leedid,meter_ID))
            ////print(url?.absoluteURL)
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd,yyyy"
            var startdatestr = ""
            var enddatestr = ""
            var dated1 = Date()
            var dated2 = Date()
            dated1 = formatter.date(from: startdate.text!)!
            dated2 = formatter.date(from: enddate.text!)!
            formatter.dateFormat = "yyyy-MM-dd"
            startdatestr = formatter.string(from: dated1)
            enddatestr = formatter.string(from: dated2)
                dataarr["start_date"] = startdatestr
                dataarr["end_data"] = enddatestr
                dataarr["reading"] = Int(reading.text!)! 
            let subscription_key = credentials().subscription_key
            let token = UserDefaults.standard.object(forKey: "token") as! String
            
            let request = NSMutableURLRequest.init(url: url!)
            request.httpMethod = "POST"
            request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
            request.addValue("application/json", forHTTPHeaderField:"Content-type" )
            request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
            let httpbody = String(format: "{\"start_date\":\"%@\",\"end_date\":\"%@\",\"reading\":%d}",startdatestr,enddatestr,Int(reading.text!)!)
                //print("HTTP body",httpbody,startdatestr,enddatestr)
            request.httpBody = httpbody.data(using: String.Encoding.utf8)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
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
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 && httpStatus.statusCode != 201 {           // check for http errors
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                    var jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        //print(jsonDictionary)
                        DispatchQueue.main.async(execute: {
                            if(jsonDictionary["non_field_errors"] != nil){
                            self.showalert("Reading for the mentioned period already exists", title: "Error", action: "OK")
                            }else{
                                self.showalert("Something went wrong. Please try again later", title: "Error", action: "OK")
                            }
                            
                        })
                    }catch{
                        
                    }
                }else{
                    
                    var jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        //print(jsonDictionary)
                        self.dataarr = jsonDictionary.mutableCopy() as! NSMutableDictionary
                        //self.tableview.reloadData()
                        // self.buildingactions(subscription_key, leedid: leedid)
                        DispatchQueue.main.async(execute: {
                            self.maketoast("Reading successfully added", type: "message")
                            self.buildingactions(subscription_key, leedid: leedid)
                            
                        })
                    } catch {
                        //print(error)
                    }
                }
                
            }) 
            task.resume()
        }
        }
        }else{
            var temparr = NSMutableArray()
            if(startdate.text?.characters.count == 0){
                temparr.add("Start date")
            }
            if(enddate.text?.characters.count == 0){
                temparr.add("End date")
            }
            if(reading.text?.characters.count == 0){
                temparr.add("Reading")
            }
            
            var string = temparr.componentsJoined(by: "\n")
            //print(string)
            let alert = UIAlertController(title: "Required fields are found empty", message: "Please kindly fill out the below fields :- \n \(string)", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            alert.view.subviews.first?.backgroundColor = UIColor.white
            alert.view.layer.cornerRadius = 10
            alert.view.layer.masksToBounds = true
            self.present(alert, animated: true, completion: nil)

        }
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

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    @IBAction func editreadings(_ sender: AnyObject) {
        
        
    }

    @IBAction func itisediting(_ sender: AnyObject) {
        
        
    }
    @IBAction func delbutton(_ sender: AnyObject) {
    }
    
    
    
}


extension Date {
    func isBetweeen(date date1: Date, andDate date2: Date) -> Bool {
        return date1.compare(self) == self.compare(date2)
    }
}
