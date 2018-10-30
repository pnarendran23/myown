//
//  datainputt.swift
//  Arcskoru
//
//  Created by Group X on 28/03/17.
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
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class yearlydata: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    var dict = NSMutableDictionary()
    var currentdict = NSMutableDictionary()
    var index = 0
    var actiondata = NSMutableArray()
    var no_of_records = 0
    var download_requests = [URLSession]()
    var task = URLSessionTask()
    let token = UserDefaults.standard.object(forKey: "token") as! String
    var currenttitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.backgroundColor = self.tableview.tableHeaderView?.backgroundColor
        self.tableview.isHidden = true
        self.spinner.layer.cornerRadius = 5
        self.spinner.isHidden = false
        titlelbl.text = currenttitle.capitalized
        tableview.register(UINib.init(nibName: "yearlycell", bundle: nil), forCellReuseIdentifier: "yearlycell")
        dict["energy"] = ["Enter tons of CO2 per year per capita"]
        dict["water"] = ["Enter gallons of water per year per person"] 
        dict["waste"] = ["Enter solid waste generated per year per person","Enter solid waste diversion rate"]
        dict["transportation"] = ["Enter number of miles traveled per vehicle per person"] 
        dict["water"] = ["Water consumption per person (Please swipe left the below data to edit duration and unit. Please tap the below data to edit the reading)"]
        dict["education"] = ["Population with (at least) High School degree (%)", "Population with (at least) Bachelor's degree (%)"] 
        dict["equitablity"] = ["Median gross rent as % of household income","Gini coefficient (for income distribution)"]
        dict["prosperity"] = ["Median household income (USD per Year)","Unemployment rate (%)"]
        dict["health & safety"] = ["Median air quality index","Air quality days unhealthy for sensitive groups (Days/yr)","Violent Crime (per capita per year)"] 
        getactiondata(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"), ID: currentdict["CreditShortId"] as! String)
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var titlelbl: UILabel!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let aSet = NSCharacterSet(charactersIn:"0123456789.").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        var c = textField.text
        c?.append(string)
        let arr = c?.components(separatedBy: ".") as! NSArray
        
        return (string == numberFiltered && arr.count <= 2 && (c?.characters.count)! <= 10)
    }
    
    var sel_year = ""
    var sel_reading = ""
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dd = Float(1)
        if(currenttitle == "education"){
            dd = 100.0
        }
        else if(currenttitle == "equitablity"){
            if(indexPath.section == 1){
                dd = 1.0
            }else{
                dd = 100.0
            }
        }else if(currenttitle == "prosperity"){
            if(indexPath.section == 0){
                dd = 1.0
            }else{
                dd = 100.0
            }
        }
        else if(currenttitle == "health & safety"){
            dd = 1.0
        }

        let cell = self.tableview.cellForRow(at: indexPath)! as! yearlycell
        //print(cell.detailTextLabel?.text)
        if(cell.detailTextLabel?.text == nil || cell.detailTextLabel?.text != nil){
        var str = self.tableView(tableview, titleForHeaderInSection: indexPath.section)?.capitalized
        let year = (self.actiondata[indexPath.row] as! NSDictionary)["year"] as! String
        self.currentyear = year
        if(self.currenttitle == "water"){
                str = "Water consumption per person. Please note that this will consider the reading in an existing duration and unit. In order to change this, please swipe left the data and edit it after updation."
        }
        let alertController = UIAlertController(title: "Update data", message: str, preferredStyle: UIAlertControllerStyle.alert)
        let saveAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            let tempstring = NSMutableString()
            let firstTextField = alertController.textFields![0] as UITextField
            let secondTextField = alertController.textFields![1] as UITextField
            if(secondTextField.text?.characters.count > 0){
                if(secondTextField.text == "."){
                    self.maketoast("Enter a valid reading", type: "error")
                }else{
            var dict = ((self.actiondata[indexPath.row] as! NSDictionary).mutableCopy() as! NSMutableDictionary)
            var tempdata = dict["data"] as! String
            tempdata = tempdata.replacingOccurrences(of: "'", with: "\"")
            //print(tempdata)
            dict["data"] = self.convertStringToDictionary(tempdata)
            if let json = try? JSONSerialization.data(withJSONObject: dict, options: []) {
                // here `json` is your JSON data
                if let jsonDictionary = try? JSONSerialization.jsonObject(with: json, options: JSONSerialization.ReadingOptions()) {
                    ////print(jsonDictionary["data"]!!["air_quality_index_num"])
                    dict = (jsonDictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
                }
            }
            if(self.currentyear == dict["year"] as! String){
                tempstring.append("{\"data\":\"{")
                let data_dict = dict["data"] as! NSDictionary
                for (item,key) in data_dict{
                    tempstring.append("'\(item)':'\(key)',")
                }
                if(self.currenttitle == "health & safety"){
                    if(indexPath.section == 0){
                        tempstring.append("'air_quality_index_num':'\(Float(secondTextField.text!)!/dd )',")
                        var str = tempstring as String
                        tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                        tempstring.append("}\"}")
                        //print(tempstring)
                 
                }else if(indexPath.section == 1){
                    tempstring.append("'unhealty_days_num':'\(Float(secondTextField.text!)!/dd )',")
                    var str = tempstring as String
                    tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                    tempstring.append("}\"}")
                    //print(tempstring)
                    
                 }else if(indexPath.section == 2){
                        tempstring.append("'violent_crime_num':'\(Float(secondTextField.text!)!/dd )',")
                        var str = tempstring as String
                        tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                        tempstring.append("}\"}")
                    }
                }else if(self.currenttitle == "prosperity"){
                 if(indexPath.section == 1){
                    dd = 100.0
                    tempstring.append("'unemployement_perc_num':'\(Float(secondTextField.text!)!/dd )',")
                    var str = tempstring as String
                    tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                    tempstring.append("}\"}")
                  
                 }else if(indexPath.section == 0){
                    dd = 1.0
                    tempstring.append("'median_income_num':'\(Float(secondTextField.text!)!/dd )',")
                    var str = tempstring as String
                    tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                    tempstring.append("}\"}")
                 }
                 }else if(self.currenttitle == "equitablity"){
                 if(indexPath.section == 1){
                    tempstring.append("'gini_coefficient_num':'\(Float(secondTextField.text!)!/dd )',")
                    var str = tempstring as String
                    tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                    tempstring.append("}\"}")
                    
                 }else if(indexPath.section == 0){
                    tempstring.append("'rent_income_perc_num':'\(Float(secondTextField.text!)!/dd)',")
                    var str = tempstring as String
                    tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                    tempstring.append("}\"}")
                 }
                 }else if(self.currenttitle == "education"){
                 if(indexPath.section == 1){
                    tempstring.append("'bachelor_degree_perc_num':'\(Float(secondTextField.text!)!/dd)',")
                    var str = tempstring as String
                    tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                    tempstring.append("}\"}")
                    
                 }else if(indexPath.section == 0){
                    
                    tempstring.append("'high_school_perc_num':'\(Float(secondTextField.text!)!/dd)',")
                    var str = tempstring as String
                    tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                    tempstring.append("}\"}")
                 }
                 }else if(self.currenttitle == "transportation"){
                 if(indexPath.section == 0){
                    tempstring.append("'vehicles_miles_num':'\(secondTextField.text! )',")
                    var str = tempstring as String
                    tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                    tempstring.append("}\"}")
                 }
                 }else if(self.currenttitle == "waste"){
                 if(indexPath.section == 0){
                    tempstring.append("'waste_generated_num':'\(secondTextField.text! )',")
                    var str = tempstring as String
                    tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                    tempstring.append("}\"}")
                 }else if(indexPath.section == 1){
                    tempstring.append("'waste_diversion_perc_num':'\(secondTextField.text!)',")
                    var str = tempstring as String
                    tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                    tempstring.append("}\"}")
                 }
                }else if(self.currenttitle == "water"){
                    if(indexPath.section == 0){
                        
                        var value = Double(secondTextField.text!)!
                        
                        var dict = (self.actiondata[indexPath.row] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        if(dict["data"] != nil){
                            var tempdata = dict["data"] as! String
                            tempdata = tempdata.replacingOccurrences(of: "'", with: "\"")
                            //print(tempdata)
                            dict["data"] = self.convertStringToDictionary(tempdata)
                            if let json = try? JSONSerialization.data(withJSONObject: dict, options: []) {
                                // here `json` is your JSON data
                                if let jsonDictionary = try? JSONSerialization.jsonObject(with: json, options: JSONSerialization.ReadingOptions()) as? NSDictionary {
                                    ////print(jsonDictionary["data"]!!["air_quality_index_num"])
                                    dict = jsonDictionary?.mutableCopy() as! NSMutableDictionary
                                }
                            }
                            let d = NSMutableDictionary.init(dictionary: dict["data"] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                            if(d["duration"] == nil){
                                d["duration"] = "Per Year"
                            }
                            if(d["unit"] == nil){
                                d["unit"] = "Gallon"
                            }
                        if(d["unit"] as! String == "Gallons")
                        {
                            //no conversion for unit
                        }
                        if(d["duration"] as! String == "Per Day")
                        {
                            //no conversion for duration
                        }
                        
                        if(d["unit"] as! String == "Litres")
                        {
                            value = value * 0.264172;
                        }
                        
                        if(d["duration"] as! String == "Per Year")
                        {
                            value = value / Double(365.0);
                        }
                        else if(d["duration"] as! String == "Per Week")
                        {
                            value = value / Double(7.0)
                        }
                        else if(d["duration"] as! String == "Per Month")
                        {
                            value = value / 31.0
                        }
                        value = value / Double(1000.0)
                        
                        
                            tempstring.append("'water_consumption_num':'\(String(format:"%f",value))',")
                            tempstring.append("'duration':'\(d["duration"] as! String)',")
                            tempstring.append("'unit':'\(d["unit"] as! String)',")
                     var str = tempstring as String
                     tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                     tempstring.append("}\"}")
                     }
                    }
                }else if(self.currenttitle == "energy"){
                 if(indexPath.section == 0){
                    tempstring.append("'ghg_emissions_num':'\(secondTextField.text!)',")
                    var str = tempstring as String
                    tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                    tempstring.append("}\"}")
                 }
                 }
                 //
            }
            
            self.spinner.isHidden = false
            self.addactiondata(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"), ID: self.currentdict["CreditShortId"] as! String, payload: tempstring as String)
            //print(tempstring)
                }}else{
                self.maketoast("Enter a valid reading", type: "error")
            }
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            self.tableview.reloadData()
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            let dict = ((self.actiondata[indexPath.row] as! NSDictionary).mutableCopy() as! NSMutableDictionary)
            self.currentyear = dict["year"] as! String
            textField.text = self.currentyear
            textField.isUserInteractionEnabled = false
            textField.keyboardType = .decimalPad
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.isUserInteractionEnabled = true
            textField.placeholder = "Enter value"
            textField.keyboardType = .decimalPad
            if(cell.detailTextLabel?.text?.characters.count > 0){
            textField.text = cell.detailTextLabel?.text!
            }
            if(cell.detailTextLabel?.text == "0.00"){
            textField.text = ""
            }
            textField.becomeFirstResponder()
        }
        alertController.textFields?[1].delegate = self
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        alertController.view.subviews.first?.backgroundColor = UIColor.white
        alertController.view.layer.cornerRadius = 10
        alertController.view.layer.masksToBounds = true
        self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let arr = dict[currenttitle] as! NSArray
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let arr = dict[currenttitle] as! NSArray
        return arr[section] as! String
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return no_of_records
    }
    
    func convertStringToDictionary(_ text: String) -> NSMutableDictionary? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                let json = (try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary).mutableCopy() as! NSMutableDictionary
                return json
            } catch {
                //print("Something went wrong")
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.contentInset = UIEdgeInsets.zero        
        let cell = tableView.dequeueReusableCell(withIdentifier: "yearlycell", for: indexPath) as! yearlycell
        var dict = NSMutableDictionary.init(dictionary: (actiondata[indexPath.row] as! NSDictionary))
        if(dict["data"] != nil){
        var tempdata = dict["data"] as! String
        tempdata = tempdata.replacingOccurrences(of: "'", with: "\"")
        //print(tempdata)
        dict["data"] = convertStringToDictionary(tempdata)
        if let json = try? JSONSerialization.data(withJSONObject: dict, options: []) {
            // here `json` is your JSON data
            if let jsonDictionary = try? JSONSerialization.jsonObject(with: json, options: JSONSerialization.ReadingOptions()) as? NSDictionary {
            ////print(jsonDictionary["data"]!!["air_quality_index_num"])
                dict = jsonDictionary?.mutableCopy() as! NSMutableDictionary
            }
        }
        var d = NSMutableDictionary.init(dictionary: dict["data"] as! NSDictionary)
        print(d)
        if(currenttitle == "health & safety"){
            if(indexPath.section == 0){
                cell.textLabel?.text = dict["year"] as? String
                cell.detailTextLabel?.text = "0.00"
                if(d["air_quality_index_num"] != nil){
                cell.detailTextLabel?.text = self.getvalue(key: "air_quality_index_num", d: d, section: indexPath.section)
                }
            }else if(indexPath.section == 1){
                cell.detailTextLabel?.text = "0.00"
                cell.textLabel?.text = dict["year"] as? String
                if(d["unhealty_days_num"] != nil){
                cell.detailTextLabel?.text = self.getvalue(key: "unhealty_days_num", d: d, section: indexPath.section)
                }
            }else if(indexPath.section == 2){
                cell.textLabel?.text = dict["year"] as? String
                if(d["violent_crime_num"] != nil){
                cell.detailTextLabel?.text = self.getvalue(key: "violent_crime_num", d: d, section: indexPath.section)
                }
            }
        }else if(currenttitle == "prosperity"){
            if(indexPath.section == 1){
                cell.detailTextLabel?.text = "0.00"
                cell.textLabel?.text = dict["year"] as? String
                if(d["unemployement_perc_num"] != nil){
                    cell.detailTextLabel?.text = self.getvalue(key: "unemployement_perc_num", d: d, section: indexPath.section)
                }
            }else if(indexPath.section == 0){
                cell.detailTextLabel?.text = "0.00"
                cell.textLabel?.text = dict["year"] as? String
                if(d["median_income_num"] != nil){
                    cell.detailTextLabel?.text = self.getvalue(key: "median_income_num", d: d, section: indexPath.section)
                }
            }
        }else if(currenttitle == "equitablity"){
            if(indexPath.section == 1){
                cell.detailTextLabel?.text = "0.00"
                cell.textLabel?.text = dict["year"] as? String
                if(d["gini_coefficient_num"] != nil){
                    cell.detailTextLabel?.text = self.getvalue(key: "gini_coefficient_num", d: d, section: indexPath.section)
                }
            }else if(indexPath.section == 0){
                cell.detailTextLabel?.text = "0.00"
                cell.textLabel?.text = dict["year"] as? String
                if(d["rent_income_perc_num"] != nil){
                    cell.detailTextLabel?.text = self.getvalue(key: "rent_income_perc_num", d: d, section: indexPath.section)
                }
            }
        }else if(currenttitle == "education"){
            if(indexPath.section == 1){
                cell.detailTextLabel?.text = "0.00"
                cell.textLabel?.text = dict["year"] as? String
                if(d["bachelor_degree_perc_num"] != nil){
                    cell.detailTextLabel?.text = self.getvalue(key: "bachelor_degree_perc_num", d: d, section: indexPath.section)
                }
            }else if(indexPath.section == 0){
                cell.detailTextLabel?.text = "0.00"
                cell.textLabel?.text = dict["year"] as? String
                if(d["high_school_perc_num"] != nil){
                    cell.detailTextLabel?.text = self.getvalue(key: "high_school_perc_num", d: d, section: indexPath.section)
                }
            }
        }else if(currenttitle == "transportation"){
            if(indexPath.section == 0){
                cell.detailTextLabel?.text = "0.00"
                cell.textLabel?.text = dict["year"] as? String
                if(d["vehicles_miles_num"] != nil){
                    cell.detailTextLabel?.text = self.getvalue(key: "vehicles_miles_num", d: d, section: indexPath.section)
                }
            }
        }else if(currenttitle == "waste"){
            if(indexPath.section == 0){
                cell.detailTextLabel?.text = "0.00"
                cell.textLabel?.text = dict["year"] as? String
                if(d["waste_generated_num"] != nil){
                    cell.detailTextLabel?.text = self.getvalue(key: "waste_generated_num", d: d, section: indexPath.section)
                }
                
            }else if(indexPath.section == 1){
                cell.detailTextLabel?.text = "0.00"
                cell.textLabel?.text = dict["year"] as? String
                cell.detailTextLabel?.text = self.getvalue(key: "waste_diversion_perc_num", d: d, section: indexPath.section)
                
            }
            }
        else if(currenttitle == "water"){
            if(indexPath.section == 0){
                cell.detailTextLabel?.text = "0.00"
                dict = NSMutableDictionary.init(dictionary: (actiondata[indexPath.row] as! NSDictionary))
                if(dict["data"] != nil){
                    var tempdata = dict["data"] as! String
                    tempdata = tempdata.replacingOccurrences(of: "'", with: "\"")
                    //print(tempdata)
                    dict["data"] = convertStringToDictionary(tempdata)
                    if let json = try? JSONSerialization.data(withJSONObject: dict, options: []) {
                        // here `json` is your JSON data
                        if let jsonDictionary = try? JSONSerialization.jsonObject(with: json, options: JSONSerialization.ReadingOptions()) as? NSDictionary {
                            ////print(jsonDictionary["data"]!!["air_quality_index_num"])
                            dict = jsonDictionary?.mutableCopy() as! NSMutableDictionary
                        }
                    }
                }
                d = NSMutableDictionary.init(dictionary: dict["data"] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                if(d["duration"] == nil){
                    d["duration"] = "Per Year"
                }
                if(d["unit"] == nil){
                    d["unit"] = "Gallon"
                }
                
                if(dict["year"] != nil && d["duration"] != nil && d["unit"] != nil){
                cell.textLabel?.text = "\(dict["year"] as! String) (\(d["duration"] as! String)|\(d["unit"] as! String))"
                if(d["water_consumption_num"] != nil){
                    cell.detailTextLabel?.text = self.getvalue(key: "water_consumption_num", d: d, section: indexPath.section)
                }
                }
            }
        }else if(currenttitle == "energy"){
            if(indexPath.section == 0){
                cell.detailTextLabel?.text = "0.00"
                cell.textLabel?.text = dict["year"] as? String
                if(d["ghg_emissions_num"] != nil){
                    cell.detailTextLabel?.text = self.getvalue(key: "ghg_emissions_num", d: d, section: indexPath.section)
                }
            }
            }
        }
        if(cell.detailTextLabel?.text == "Detail" || cell.detailTextLabel?.text == "" || cell.detailTextLabel?.text == " "){
            cell.detailTextLabel?.text = "0.00"
        }
        print(cell.detailTextLabel?.text)
        
        
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(listdata == actiondata){
            self.tableview.reloadData()
        }else{
            DispatchQueue.main.async(execute: {
            self.spinner.isHidden = false
            self.listdata.removeAllObjects()
            self.actiondata.removeAllObjects()
            self.tableview.reloadData()
            self.getactiondata(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"), ID: self.currentdict["CreditShortId"] as! String)
            })
        }
        var buildingdetails = (NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "building_details") as! Data) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.navigationItem.title = buildingdetails["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = (currentdict["CreditDescription"] as! String).capitalized
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let shareAction  = UITableViewRowAction(style: .normal, title: "Edit") { (rowAction, indexPath) in
            self.selected = indexPath.row
            self.performSegue(withIdentifier: "gotoedit", sender: nil)
        }
        let deleteAction  = UITableViewRowAction(style: .default, title: "Delete") { (rowAction, indexPath) in                        
            DispatchQueue.main.async(execute: {
             
                
            })
        }
        deleteAction.backgroundColor = UIColor.init(red: 0.858, green: 0.211, blue: 0.196, alpha: 1)
        shareAction.backgroundColor = UIColor.init(red: 0.756, green: 0.756, blue: 0.756, alpha: 1)
        return [deleteAction,shareAction]
    }
    var sel_field = ""
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if ((currentdict["CreditDescription"] as! String).lowercased() == "water"){
            if(indexPath.section == 0){
                return indexPath.row >= 0 ? true : false
            }
        }
        return false
    }
    
    func getvalue(key:String,d:NSDictionary, section : Int) -> String{
        var str = "0.00"
        if(currenttitle == "water"){
            print(d["duration"])
            if let s = d[key] as? Double{
                var value = s
                
                value *= 1000.0
                if(d["unit"] as! String == "Litres")
                {
                    value /= 0.264172;
                }
                
                if(d["duration"] as! String == "Per Year")
                {
                    value *= 365.0;
                }
                if(d["duration"] as! String == "Per Week")
                {
                    value *= 7.0
                }
                if(d["duration"] as! String == "Per Month")
                {
                    value *= 31.0
                }
                str = String(format:"%.2f",value.roundToPlaces(places: 3))
            }else if let s = d[key] as? Int{
                var value = Double(s)
                value *= Double(1000)
                if(d["unit"] as! String == "Litres")
                {
                    value /= 0.264172;
                }
                
                if(d["duration"] as! String == "Per Year")
                {
                    value *= Double(365);
                }
                else if(d["duration"] as! String == "Per Week")
                {
                    value *= Double(7)
                }
                else if(d["duration"] as! String == "Per Month")
                {
                    value *= 31.0
                }
                str = String(format:"%.2f",value.roundToPlaces(places: 3))
            }else if let s = d[key] as? Double{
                var value = s
                value *= 1000.0
                if(d["unit"] as! String == "Litres")
                {
                    value /= 0.264172;
                }
                
                if(d["duration"] as! String == "Per Year")
                {
                    value *= 365.0;
                }
                else if(d["duration"] as! String == "Per Week")
                {
                    value *= 7.0
                }
                else if(d["duration"] as! String == "Per Month")
                {
                    value *= 31.0
                }
                str = String(format:"%.2f",value.roundToPlaces(places: 3))
            }else if let s = d[key] as? String{
                print(s)
                if(Double(s) != nil){
                    if(Double(s)! >= 0){
                        var value = Double(s)!
                        value *= Double(1000)
                        if(d["unit"] as! String == "Litres")
                        {
                            value /= 0.264172;
                        }
                        
                        if(d["duration"] as! String == "Per Year")
                        {
                            value *= Double(365);
                        }
                        else if(d["duration"] as! String == "Per Week")
                        {
                            value *= Double(7)
                        }
                        else if(d["duration"] as! String == "Per Month")
                        {
                            value *= Double(31)
                        }
                        str = String(format:"%.2f",value.roundToPlaces(places: 3))
                    }
                }
            }
            return str
        }else if (currenttitle == "education" || currenttitle == "health & safety" || currenttitle == "prosperity" || currenttitle == "equitablity"){
            var dd = Double(1)
            if(currenttitle == "education"){
                dd = 100.0
            }
            else if(currenttitle == "equitablity"){
                if(section == 1){
                    dd = 1.0
                }else{
                    dd = 100.0
                }
            }else if(currenttitle == "prosperity"){
                if(section == 0){
                    dd = 1.0
                }else{
                    dd = 100.0
                }
            }
            else if(currenttitle == "health & safety"){
                    dd = 1.0
            }
            
            if let s = d[key] as? Double{
                str = "\(Double(dd) * s)"
            }else if let s = d[key] as? Int{
                str = String(format:"%.2f",dd * Double(s))
            }else if let s = d[key] as? Float{
                str = String(format:"%.2f",dd * Double(s))
            }else if let s = d[key] as? String{
                print(s)
                if(Float(s) != nil){
                    if(Float(s)! >= 0){
                        str = String(format:"%.2f",(dd * Double(s)!).roundToPlaces(places: 3))
                    }
                }
            }
            return str
        }else{
            print(d)
    if let s = d[key] as? Double{
        str = "\(s)"
    }else if let s = d[key] as? Int{
            str = String(format:"%.2f",Float(s))
        }else if let s = d[key] as? Float{
            str = String(format:"%.2f",s)
        }else if let s = d[key] as? String{
            print(s)
            if(Float(s) != nil){
                if(Float(s)! >= 0){
                    str = String(format:"%.2f",(Double(s)!).roundToPlaces(places: 3))
                }
            }
        }
        return str
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "adasd"
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 40, width: tableview.layer.frame.size.width, height: 40)
        let prevbutton = UIButton.init(frame: CGRect(x: 0.01 * tableview.layer.frame.size.width, y: 10, width: 0.24 * tableview.layer.frame.size.width, height: 30))
        let nextbutton = UIButton.init(frame: CGRect(x: 0.75 * tableview.layer.frame.size.width, y: 10, width: 0.24 * tableview.layer.frame.size.width, height: 30))
        prevbutton.setTitle("Previous year", for: UIControlState())
        nextbutton.setTitle("Next year", for: UIControlState())
        prevbutton.titleLabel?.font = UIFont.init(name: "OpenSans", size: 11)
        nextbutton.titleLabel?.font = UIFont.init(name: "OpenSans", size: 11)
        prevbutton.layer.backgroundColor = UIColor.darkGray.cgColor
        prevbutton.layer.cornerRadius = 5
        nextbutton.layer.backgroundColor = UIColor.darkGray.cgColor
        nextbutton.layer.cornerRadius = 5
        prevbutton.tag = section
        nextbutton.tag = section
        prevbutton.addTarget(self, action: #selector(self.previous(_:)), for: UIControlEvents.touchUpInside)
        nextbutton.addTarget(self, action: #selector(self.next(_:)), for: UIControlEvents.touchUpInside)
        view.addSubview(prevbutton)
        view.addSubview(nextbutton)
        return view
    }
    
    
    
    func previous(_ sender:UIButton){
        //print(sender.tag)
        var str = self.tableView(tableview, titleForHeaderInSection: sender.tag)?.capitalized
        if(self.currenttitle == "water"){
         str = "Water consumption per person. Please note that the default duration is Per Year and unit is Gallons. So, enter the data accordingly. In order to change this, please swipe left the data and edit it after creation."
        }
        let alertController = UIAlertController(title: "Add new data", message: str, preferredStyle: UIAlertControllerStyle.alert)
        
        let saveAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            let tempstring = NSMutableString()
            let firstTextField = alertController.textFields![0] as UITextField
            let secondTextField = alertController.textFields![1] as UITextField
            
            if(secondTextField.text?.characters.count > 0){
                if(secondTextField.text == "."){
                    self.maketoast("Enter a valid reading", type: "error")
                }else{
            var dict = NSMutableDictionary()
            if(self.actiondata.count > 0){
            dict = ((self.actiondata.firstObject as! NSDictionary).mutableCopy() as! NSMutableDictionary)
            }
            var temp = NSMutableDictionary()
            if(self.currenttitle == "health & safety"){
                temp["air_quality_index_num"] = ""
                temp["unhealty_days_num"] = ""
                temp["violent_crime_num"] = ""
                
            }else if(self.currenttitle == "prosperity"){
                if(sender.tag == 1){
                    temp["unemployement_perc_num"] = ""
                }else if(sender.tag == 0){
                    temp["median_income_num"] = ""
                }
            }else if(self.currenttitle == "equitablity"){
                if(sender.tag == 1){
                    temp["gini_coefficient_num"] = ""
                }else if(sender.tag == 0){
                    temp["rent_income_perc_num"] = ""
                }
            }else if(self.currenttitle == "education"){
                if(sender.tag == 1){
                    temp["bachelor_degree_perc_num"] = ""
                }else if(sender.tag == 0){
                    temp["high_school_perc_num"] = ""
                }
            }else if(self.currenttitle == "transportation"){
                if(sender.tag == 0){
                    temp["vehicles_miles_num"] = ""
                }
            }else if(self.currenttitle == "waste"){
                if(sender.tag == 0){
                    temp["waste_generated_num"] = ""
                }else if(sender.tag == 1){
                    temp["waste_diversion_perc_num"] = ""
                }
            }
            else if(self.currenttitle == "water"){
                if(sender.tag == 0){
                    temp["water_consumption_num"] = ""
                }
            }else if(self.currenttitle == "energy"){
                if(sender.tag == 0){
                    temp["ghg_emissions_num"] = ""
                }
            }
            
            dict["data"] = temp
                tempstring.append("{\"data\":\"{")
                if(self.currenttitle == "health & safety"){
                    if(sender.tag == 0){
                        tempstring.append("'air_quality_index_num':'\(secondTextField.text! )',")
                        var str = tempstring as String
                        tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                        tempstring.append("}\"}")
                        //print(tempstring)
                        
                    }else if(sender.tag == 1){
                        tempstring.append("'unhealty_days_num':'\(secondTextField.text! )',")
                        var str = tempstring as String
                        tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                        tempstring.append("}\"}")
                        //print(tempstring)
                        
                    }else if(sender.tag == 2){
                        tempstring.append("'violent_crime_num':'\(secondTextField.text! )',")
                        var str = tempstring as String
                        tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                        tempstring.append("}\"}")
                    }
                }else if(self.currenttitle == "prosperity"){
                    if(sender.tag == 1){
                        
                        tempstring.append("'unemployement_perc_num':'\(Float(secondTextField.text!)!/100.0 )',")
                        var str = tempstring as String
                        tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                        tempstring.append("}\"}")
                        
                    }else if(sender.tag == 0){
                        tempstring.append("'median_income_num':'\(secondTextField.text! )',")
                        var str = tempstring as String
                        tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                        tempstring.append("}\"}")
                    }
                }else if(self.currenttitle == "equitablity"){
                    if(sender.tag == 1){
                        tempstring.append("'gini_coefficient_num':'\(secondTextField.text! )',")
                        var str = tempstring as String
                        tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                        tempstring.append("}\"}")
                        
                    }else if(sender.tag == 0){
                        tempstring.append("'rent_income_perc_num':'\(Float(secondTextField.text!)!/100.0 )',")
                        var str = tempstring as String
                        tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                        tempstring.append("}\"}")
                    }
                }else if(self.currenttitle == "education"){
                    if(sender.tag == 1){
                        tempstring.append("'bachelor_degree_perc_num':'\(Float(secondTextField.text!)!/100.0 )',")
                        var str = tempstring as String
                        tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                        tempstring.append("}\"}")
                        
                    }else if(sender.tag == 0){
                        
                        tempstring.append("'high_school_perc_num':'\(Float(secondTextField.text!)!/100.0 )',")
                        var str = tempstring as String
                        tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                        tempstring.append("}\"}")
                    }
                }else if(self.currenttitle == "transportation"){
                    if(sender.tag == 0){
                        tempstring.append("'vehicles_miles_num':'\(secondTextField.text! )',")
                        var str = tempstring as String
                        tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                        tempstring.append("}\"}")
                    }
                }else if(self.currenttitle == "waste"){
                    if(sender.tag == 0){
                        tempstring.append("'waste_generated_num':'\(secondTextField.text! )',")
                        var str = tempstring as String
                        tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                        tempstring.append("}\"}")
                    }else if(sender.tag == 1){
                        tempstring.append("'waste_diversion_perc_num':'\(secondTextField.text! )',")
                        var str = tempstring as String
                        tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                        tempstring.append("}\"}")
                    }
                }
                else if(self.currenttitle == "water"){
                    if(sender.tag == 0){
                        var value = Double(secondTextField.text!)!
                            value = value / Double(365); // Per Year
                        value = value / Double(1000)
                        tempstring.append("'water_consumption_num':'\(value)',")
                        tempstring.append("'duration':'Per Year',")
                        tempstring.append("'unit':'Gallons',")
                        var str = tempstring as String
                        tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                        tempstring.append("}\"}")
                    }
                }else if(self.currenttitle == "energy"){
                    if(sender.tag == 0){
                        tempstring.append("'ghg_emissions_num':'\(secondTextField.text!)',")
                        var str = tempstring as String
                        tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                        tempstring.append("}\"}")
                    }
                }
            
            self.spinner.isHidden = false
            self.addactiondata(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"), ID: self.currentdict["CreditShortId"] as! String, payload: tempstring as String)
                }
            //print(tempstring)
            }else{
                self.maketoast("Enter a valid reading", type: "error")
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            self.tableview.reloadData()
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            if(self.actiondata.count > 0 ){
            var year = Int((self.actiondata.lastObject as! NSDictionary)["year"] as! String)!
            year = year - 1
            textField.text = "\(year )"
            self.currentyear = textField.text!
            }else{
                let date = Date()
                let calendar = Calendar.current                
                var year = calendar.component(.year, from: date)
                year = year - 1
                textField.text = "\(year )"
                self.currentyear = textField.text!
            }
            textField.isUserInteractionEnabled = false
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.keyboardType = .decimalPad
            textField.isUserInteractionEnabled = true
            textField.placeholder = "Enter value"
            textField.becomeFirstResponder()
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        alertController.textFields?[1].delegate = self
        alertController.view.subviews.first?.backgroundColor = UIColor.white
        alertController.view.layer.cornerRadius = 10
        alertController.view.layer.masksToBounds = true
        self.present(alertController, animated: true, completion: nil)

    }
    
    var data_arr = NSMutableArray()
    func next(_ sender:UIButton){
        //print(sender.tag)
        var str = self.tableView(tableview, titleForHeaderInSection: sender.tag)?.capitalized
        if(self.currenttitle == "water"){
            str = "Water consumption per person. Please note that the default duration is Per Year and unit is Gallons. So, enter the data accordingly. In order to change this, please swipe left the data and edit it after creation."
        }
        let alertController = UIAlertController(title: "Add new data", message: str, preferredStyle: UIAlertControllerStyle.alert)
        let saveAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            let tempstring = NSMutableString()
            let firstTextField = alertController.textFields![0] as UITextField
            let secondTextField = alertController.textFields![1] as UITextField
            var dict = NSMutableDictionary()
            if(self.actiondata.count > 0){
                dict = ((self.actiondata.firstObject as! NSDictionary).mutableCopy() as! NSMutableDictionary)
            }
            if(secondTextField.text?.characters.count > 0){
                if(secondTextField.text == "."){
                    self.maketoast("Enter a valid reading", type: "error")
                }else{
            var temp = NSMutableDictionary()
            if(self.currenttitle == "health & safety"){
                temp["air_quality_index_num"] = ""
                temp["unhealty_days_num"] = ""
                temp["violent_crime_num"] = ""
                
            }else if(self.currenttitle == "prosperity"){
                if(sender.tag == 1){
                    temp["unemployement_perc_num"] = ""
                }else if(sender.tag == 0){
                    temp["median_income_num"] = ""
                }
            }else if(self.currenttitle == "equitablity"){
                if(sender.tag == 1){
                    temp["gini_coefficient_num"] = ""
                }else if(sender.tag == 0){
                    temp["rent_income_perc_num"] = ""
                }
            }else if(self.currenttitle == "education"){
                if(sender.tag == 1){
                    temp["bachelor_degree_perc_num"] = ""
                }else if(sender.tag == 0){
                    temp["high_school_perc_num"] = ""
                }
            }else if(self.currenttitle == "transportation"){
                if(sender.tag == 0){
                    temp["vehicles_miles_num"] = ""
                }
            }else if(self.currenttitle == "waste"){
                if(sender.tag == 0){
                    temp["waste_generated_num"] = ""
                }else if(sender.tag == 1){
                    temp["waste_diversion_perc_num"] = ""
                }
            }
            else if(self.currenttitle == "water"){
                if(sender.tag == 0){
                    temp["water_consumption_num"] = ""
                }
            }else if(self.currenttitle == "energy"){
                if(sender.tag == 0){
                    temp["ghg_emissions_num"] = ""
                }
            }
            
            dict["data"] = temp

                tempstring.append("{\"data\":\"{")
                if(self.currenttitle == "health & safety"){
                    if(sender.tag == 0){
                        tempstring.append("'air_quality_index_num':'\(secondTextField.text! )',")
                        var str = tempstring as String
                        tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                        tempstring.append("}\"}")
                        //print(tempstring)
                        
                    }else if(sender.tag == 1){
                        tempstring.append("'unhealty_days_num':'\(secondTextField.text! )',")
                        var str = tempstring as String
                        tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                        tempstring.append("}\"}")
                        //print(tempstring)
                        
                    }else if(sender.tag == 2){
                        tempstring.append("'violent_crime_num':'\(secondTextField.text! )',")
                        var str = tempstring as String
                        tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                        tempstring.append("}\"}")
                    }
                }else if(self.currenttitle == "prosperity"){
                    if(sender.tag == 1){
                        
                        tempstring.append("'unemployement_perc_num':'\(Float(secondTextField.text!)!/100.0 )',")
                        var str = tempstring as String
                        tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                        tempstring.append("}\"}")
                        
                    }else if(sender.tag == 0){
                        tempstring.append("'median_income_num':'\(secondTextField.text! )',")
                        var str = tempstring as String
                        tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                        tempstring.append("}\"}")
                    }
                }else if(self.currenttitle == "equitablity"){
                    if(sender.tag == 1){
                        tempstring.append("'gini_coefficient_num':'\(secondTextField.text! )',")
                        var str = tempstring as String
                        tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                        tempstring.append("}\"}")
                        
                    }else if(sender.tag == 0){
                        tempstring.append("'rent_income_perc_num':'\(Float(secondTextField.text!)!/100.0 )',")
                        var str = tempstring as String
                        tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                        tempstring.append("}\"}")
                    }
                }else if(self.currenttitle == "education"){
                    if(sender.tag == 1){
                        tempstring.append("'bachelor_degree_perc_num':'\(Float(secondTextField.text!)!/100.0 )',")
                        var str = tempstring as String
                        tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                        tempstring.append("}\"}")
                        
                    }else if(sender.tag == 0){
                        
                        tempstring.append("'high_school_perc_num':'\(Float(secondTextField.text!)!/100.0 )',")
                        var str = tempstring as String
                        tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                        tempstring.append("}\"}")
                    }
                }else if(self.currenttitle == "transportation"){
                    if(sender.tag == 0){
                        tempstring.append("'vehicles_miles_num':'\(secondTextField.text! )',")
                        var str = tempstring as String
                        tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                        tempstring.append("}\"}")
                    }
                }else if(self.currenttitle == "waste"){
                    if(sender.tag == 0){
                        tempstring.append("'waste_generated_num':'\(secondTextField.text! )',")
                        var str = tempstring as String
                        tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                        tempstring.append("}\"}")
                    }else if(sender.tag == 1){
                        tempstring.append("'waste_diversion_perc_num':'\(secondTextField.text! )',")
                        var str = tempstring as String
                        tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                        tempstring.append("}\"}")
                    }
                }
                else if(self.currenttitle == "water"){
                    if(sender.tag == 0){
                        var value = Double(secondTextField.text!)!
                        value = value / Double(365); // Per Year
                        value = value / Double(1000)
                        tempstring.append("'water_consumption_num':'\(value)',")
                        tempstring.append("'duration':'Per Year',")
                        tempstring.append("'unit':'Gallons',")
                        var str = tempstring as String
                        tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                        tempstring.append("}\"}")
                    }
                }else if(self.currenttitle == "energy"){
                    if(sender.tag == 0){
                        tempstring.append("'ghg_emissions_num':'\(String(format:"%@",secondTextField.text!))',")
                        var str = tempstring as String
                        tempstring.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
                        tempstring.append("}\"}")
                    }
                }
            self.spinner.isHidden = false
            self.addactiondata(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"), ID: self.currentdict["CreditShortId"] as! String, payload: tempstring as String)
            print(tempstring)
                }
            }else{
                self.maketoast("Enter a valid reading", type: "error")
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            self.tableview.reloadData()
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            if(self.actiondata.count > 0 ){
                var year = Int((self.actiondata.firstObject as! NSDictionary)["year"] as! String)!
                year = year + 1
                textField.text = "\(year )"
                self.currentyear = textField.text!
            }else{
                let date = Date()
                let calendar = Calendar.current
                var year = calendar.component(.year, from: date)
                year = year + 1
                textField.text = "\(year )"
                self.currentyear = textField.text!
            }
            textField.isUserInteractionEnabled = false
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.keyboardType = .decimalPad
            textField.isUserInteractionEnabled = true
            textField.placeholder = "Enter value"
            textField.becomeFirstResponder()
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        alertController.textFields?[1].delegate = self
        alertController.view.subviews.first?.backgroundColor = UIColor.white
        alertController.view.layer.cornerRadius = 10
        alertController.view.layer.masksToBounds = true        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func addactiondata(_ subscription_key:String, leedid: Int, ID : String, payload : String){
        let url = URL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@/data/%@/?recompute_score=1",credentials().domain_url, leedid,ID,self.currentyear))
        ////print(url?.absoluteURL)
        var subscription_key = credentials().subscription_key
        var token = UserDefaults.standard.object(forKey: "token") as! String
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "POST"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var httpbody = payload
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
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 && httpStatus.statusCode != 201{           // check for http errors
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
                            self.tableview.isHidden = false
                            self.maketoast("Reading added successfully", type: "message")
                            self.getactiondata(credentials().subscription_key, leedid: UserDefaults.standard.integer(forKey: "leed_id"), ID: self.currentdict["CreditShortId"] as! String)
                        })
                    } catch {
                        //print(error)
                    }
            }
            
        }) 
        task.resume()


    }

    
    
    
    var currentyear = ""
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.091 * UIScreen.main.bounds.size.height
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            if(currenttitle == "water" || currenttitle == "transportation"){
                if(UIDevice.current.userInterfaceIdiom == .phone){
                return 0.087 * UIScreen.main.bounds.size.height
                }
                return 0.074 * UIScreen.main.bounds.size.height
            }
            return 0.054 * UIScreen.main.bounds.size.height
        }
        
        return 0.057 * UIScreen.main.bounds.size.height
    }
    
    var listdata = NSMutableArray()
    func getactiondata(_ subscription_key:String, leedid: Int, ID : String){
        let url = URL.init(string: String(format: "%@assets/LEED:%d/actions/ID:%@/data/",credentials().domain_url,leedid,ID))
        print(url?.absoluteURL)
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = URLSession(configuration: URLSessionConfiguration.default)
        download_requests.append(session)
        self.task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.localizedDescription.contains("cancelled")) != nil){
                    if(error?._code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    //print("error=\(error?.localizedDescription)")
                                        DispatchQueue.main.async(execute: {
                        self.tableview.isHidden = false
                        self.spinner.isHidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            }
            else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print("action data xcv",jsonDictionary)
                    DispatchQueue.main.async(execute: {
                        self.actiondata = (jsonDictionary["results"] as! NSArray).mutableCopy() as! NSMutableArray
                        self.no_of_records = self.actiondata.count
                        self.listdata = self.actiondata
                        self.spinner.isHidden = true
                        self.tableview.isHidden = false
                        //self.view.userInteractionEnabled = true
                        UserDefaults.standard.synchronize()
                      //  self.navigate()
                        self.tableview.reloadData()
                        
                        return
                    })
                } catch {
                    //print(error)
                    DispatchQueue.main.async(execute: {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
            }
            
        }) 
        task.resume()
    }
    
    func showalert(_ message:String, title:String, action:String){        
        DispatchQueue.main.async(execute: {
            self.tableview.isHidden = false
            self.view.isUserInteractionEnabled = true
            self.spinner.isHidden = true
            self.maketoast(message, type: "error")
        })
        
    }
    @IBOutlet weak var spinner: UIView!
    
    //https://api.usgbc.org/stg/leed/
    var selected = 0
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "gotoedit"){
            let v = segue.destination as! editwater            
            v.d = (self.actiondata[selected] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            v.selected = selected
            v.shortID = self.currentdict["CreditShortId"] as! String
        }
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
