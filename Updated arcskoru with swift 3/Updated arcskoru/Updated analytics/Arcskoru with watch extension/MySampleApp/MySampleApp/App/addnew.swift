//
//  ViewController.swift
//  LEEDOn
//
//  Created by Group X on 15/11/16.
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
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

class addnew: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    var bgcolor = UIColor()
    var years = NSMutableArray()
    var download_requests = [URLSession]()
    var listarray = NSArray()
    var sel_index = 0
    var currentyeararray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        bgcolor = self.addbtn.backgroundColor!
        self.addbtn.isEnabled = false
        self.addbtn.backgroundColor = UIColor.gray
        self.spinner.layer.cornerRadius = 5
        self.spinner.isHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        unit.delegate = self
        unit.tag = 2
        value.tag = 1
        value.delegate = self
        do {
            
            
            if let file = Bundle.main.url(forResource: "additional_data", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let name: AnyClass! = object_getClass(json)
                //print(name)
                if let object = json as? NSArray {
                    //print("json object ",object)
                    listarray = object
                }
                
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    //print(object)
                } else if let object = json as? [Any] {
                    // json is an array
                    //print(object)
                } else {
                    //print("JSON is invalid")
                }
            } else {
                //print("no file")
            }
        } catch {
            //print(error)
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let i2  = Int(formatter.string(from: Date()))!
        
        //Create Years Array from 1960 to This year
        years = NSMutableArray()
        for i in (1900 ... i2) .reversed(){
            years.add("\(i)")
        }
        
        var temp = 0
        if(edit == 1){
            let data = (listofdata[sel_index] as! NSArray).mutableCopy() as! NSMutableArray
            unit.text = "\(data[2] as! String)"
            value.text = "\(data[1] as! String)"
            //currentfield = data[0] as! String
            selected_field = currentfield
            for i in 0 ..< years.count{
                let str = years[i] as! String
                if(data[3] as! String == str){
                    temp = i
                    break
                }
            }
            selected_year = years[temp] as! String
            dpicker.selectRow(temp, inComponent: 0, animated: true)
        }else{
            currentfield = "2017"
            selected_field = currentfield
        }
        
        
    }
    var edit = 0
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backItem?.title = (currentarr["CreditDescription"] as! String).capitalized
        var buildingdetails = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.navigationItem.title = buildingdetails["name"] as? String
    }
    var selected_year = ""
    var currentfield = ""
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    @IBOutlet weak var spinner: UIView!
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected_year = years[row] as! String
        if(value.text?.characters.count > 0 && unit.text?.characters.count > 0 && selected_year != "" && currentfield != ""){
            self.addbtn.isEnabled = true
            self.addbtn.backgroundColor = bgcolor
        }else{
            self.addbtn.isEnabled = false
            self.addbtn.backgroundColor = UIColor.gray
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return years[row] as! String
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    @IBOutlet weak var addbtn: UIButton!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listarray.count
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(value.text,unit.text)
        if(value.text?.characters.count > 0 && unit.text?.characters.count > 0 && selected_year != "" && currentfield != ""){
            self.addbtn.isEnabled = true
            self.addbtn.backgroundColor = bgcolor
        }else{
            self.addbtn.isEnabled = false
            self.addbtn.backgroundColor = UIColor.gray
        }
        if(textField == value){
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered
        }
        return true
    }
    
    var currentarr = NSDictionary()
    var listofdata = NSArray()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.contentInset = UIEdgeInsets.zero
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        var dict = (listarray[indexPath.row] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        cell.textLabel?.text = "\(dict["name"] as! String)"
        cell.textLabel?.numberOfLines = 4
        cell.textLabel?.font = UIFont.init(name: "OpenSans", size: 13)
        if(cell.textLabel?.text == selected_field){
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        if(indexPath.row == 0){
            cell.selectionStyle = .none
        }else{
            cell.selectionStyle = .default
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    var currentval = ""
    var currentunit = ""
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField.tag == 1){
            currentval = textField.text!
        }else{
            currentunit = textField.text!
        }
        textField.resignFirstResponder()
        return true
    }
    
    var selected_field = ""
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row > 0){
            let cell = tableView.cellForRow(at: indexPath)
            selected_field = (cell?.textLabel?.text)!
        for i in listarray{
            let item = i as! NSDictionary
            var dict = item.mutableCopy() as! NSMutableDictionary
            if(dict["name"] as! String == selected_field){
                let tempstring = dict["field"] as! String
                let arr = tempstring.components(separatedBy: "_num")
                print(arr)
                currentfield = arr[0]
                //selected_field = currentfield
                break
            }
        }
        //print(currentfield,selected_field)
        tableView.reloadData()
            if(value.text?.characters.count > 0 && unit.text?.characters.count > 0 && selected_year != "" && currentfield != ""){
                self.addbtn.isEnabled = true
                self.addbtn.backgroundColor = bgcolor
            }else{
                self.addbtn.isEnabled = false
                self.addbtn.backgroundColor = UIColor.gray
            }
        }
        
    }
    
    
    
    
    @IBOutlet weak var value: UITextField!
    
    @IBAction func submit(_ sender: AnyObject) {
        if(value.text?.characters.count > 0 && unit.text?.characters.count > 0 && selected_year != "" && currentfield != ""){
        currentyeararray = NSMutableArray()
            print(listofdata)
            if(edit == 0){
                for i in listofdata{
                    let item = i as! NSArray
                    let dict = item.mutableCopy() as! NSMutableArray
                    if(dict[3] as! String == selected_year){
                        currentyeararray.add(dict)
                    }
                }
                let dict = NSMutableArray()
                dict.add(selected_field)
                dict.add(value.text!)
                dict.add(unit.text!)
                dict.add(selected_year)
                dict.add(currentfield)
                currentyeararray.add(dict)
            }else{
                let dict = NSMutableArray()
                dict.add(selected_field)
                dict.add(value.text!)
                dict.add(unit.text!)
                dict.add(selected_year)
                dict.add(currentfield)
                var t = NSMutableArray.init(array: listofdata)
                t.replaceObject(at: sel_index, with: dict)
                listofdata = NSArray.init(array: t)
                for i in listofdata{
                    let item = i as! NSArray
                    let dict = item.mutableCopy() as! NSMutableArray
                    if(dict[3] as! String == selected_year){
                        currentyeararray.add(dict)
                    }
                }
            }
        //print("Updated array",currentyeararray)
            addnewyearlydata(currentyeararray, actionID: currentarr["CreditShortId"] as! String)
        }else{
            //print("Missing fields")
            let temparr = NSMutableArray()
            if(value.text?.characters.count == 0){
               temparr.add("Value")
            }
            if(unit.text?.characters.count == 0){
                temparr.add("Unit")
            }
            if(selected_year == ""){
                temparr.add("Year to be selected")
            }
            if(currentfield == ""){
                temparr.add("Choose field which are applicable for your project")
            }
            
            let string = temparr.componentsJoined(by: "\n")
            //print(string)
            let alert = UIAlertController(title: "Required fields are found empty", message: "Please kindly fill out the below fields :- \n \(string)", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            alert.view.subviews.first?.backgroundColor = UIColor.white
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func addnewyearlydata(_ arr : NSMutableArray, actionID : String){
        //{"data":"{'emission_intensity_num':'12','emission_intensity_num_unit':'E','emission_intensity_num_name':'Emission Intensity'}"}
        self.spinner.isHidden = false
        var payload = NSMutableString()
        payload.append("{\"data\":\"{")
        
        for i in arr{
            let item = i as! NSArray
            var a = item.mutableCopy() as! NSMutableArray
            payload.append("'\(a[4] as! String)_num':'\(a[1] as! String)',")
            payload.append("'\(a[4] as! String)_num_unit':'\(a[2] as! String)',")
            payload.append("'\(a[4] as! String)_num_name':'\(a[0] as! String)',")
        }
        var str = payload as String
        payload.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
        payload.append("}\"}")
        str = payload as String
        print(str)
        var leedid = UserDefaults.standard.integer(forKey: "leed_id")
        
        let url = URL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@/data/%@/?recompute_score=1",credentials().domain_url, leedid,actionID,selected_year))
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
                    //self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                    
                })
                return
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
    
    
    
    @IBOutlet weak var unit: UITextField!
    @IBOutlet weak var dpicker: UIPickerView!
    
}

