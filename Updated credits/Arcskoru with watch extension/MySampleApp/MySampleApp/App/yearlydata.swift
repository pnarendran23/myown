//
//  datainputt.swift
//  Arcskoru
//
//  Created by Group X on 28/03/17.
//
//

import UIKit

class yearlydata: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    var dict = [String:AnyObject]()
    var currentdict = [String:AnyObject]()
    var index = 0
    var actiondata = NSMutableArray()
    var no_of_records = 0
    var download_requests = [NSURLSession]()
    var task = NSURLSessionTask()
    let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
    var currenttitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.layer.cornerRadius = 5
        self.spinner.hidden = false
        titlelbl.text = currenttitle.capitalizedString
        tableview.registerNib(UINib.init(nibName: "yearlycell", bundle: nil), forCellReuseIdentifier: "yearlycell")
        dict["energy"] = ["Enter tons of CO2 per year per capita"] as! NSArray
        dict["water"] = ["Enter gallons of water per year per person"] as! NSArray
        dict["waste"] = ["Enter solid waste generated per year per person","Enter solid waste diversion rate"] as! NSArray
        dict["transportation"] = ["Enter number of miles traveled per vehicle per person"] as! NSArray
        dict["water"] = ["Enter gallons of water per year per person"] as! NSArray
        dict["education"] = ["Population with (at least) High School degree (%)", "Population with (at least) Bachelor's degree (%)"] as! NSArray
        dict["equitablity"] = ["Median gross rent as % of household income","Gini coefficient (for income distribution)"] as! NSArray
        dict["prosperity"] = ["Median household income (USD per Year)","Unemployment rate (%)"] as! NSArray
        dict["health & safety"] = ["Median air quality index","Air quality days unhealthy for sensitive groups (Days/yr)","Violent Crime (per capita per year)"] as! NSArray
        getactiondata(credentials().subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), ID: currentdict["CreditShortId"] as! String)
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var titlelbl: UILabel!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = self.tableview.cellForRowAtIndexPath(indexPath)! as! yearlycell
        print(cell.detailTextLabel?.text)
        if(cell.detailTextLabel?.text == nil){
        var str = self.tableView(tableview, titleForHeaderInSection: indexPath.section)?.capitalizedString
        var year = (self.actiondata[indexPath.section] as! NSDictionary)["year"] as! String
        currentyear = year
        let alertController = UIAlertController(title: "Add new data", message: str, preferredStyle: UIAlertControllerStyle.Alert)
        
        let saveAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: {
            alert -> Void in
            var tempstring = NSMutableString()
            let firstTextField = alertController.textFields![0] as UITextField
            let secondTextField = alertController.textFields![1] as UITextField
            var dict = (self.actiondata.firstObject?.mutableCopy() as! NSMutableDictionary)
            var tempdata = dict["data"] as! String
            tempdata = tempdata.stringByReplacingOccurrencesOfString("'", withString: "\"")
            print(tempdata)
            dict["data"] = self.convertStringToDictionary(tempdata)
            if let json = try? NSJSONSerialization.dataWithJSONObject(dict, options: []) {
                // here `json` is your JSON data
                if let jsonDictionary = try? NSJSONSerialization.JSONObjectWithData(json, options: NSJSONReadingOptions()) {
                    //print(jsonDictionary["data"]!!["air_quality_index_num"])
                    dict = jsonDictionary.mutableCopy() as! NSMutableDictionary
                }
            }
            if(self.currentyear == dict["year"] as! String){
                tempstring.appendString("{\"data\":\"{")
                var data_dict = dict["data"] as! NSDictionary
                for (item,key) in data_dict{
                    tempstring.appendString("'\(item)':'\(key)',")
                }
                if(self.currenttitle == "health & safety"){
                    if(indexPath.section == 0){
                        tempstring.appendString("'air_quality_index_num':'\(secondTextField.text! as! String)',")
                        var str = tempstring as! String
                        tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                        tempstring.appendString("}\"}")
                        print(tempstring)
                 
                }else if(indexPath.section == 1){
                    tempstring.appendString("'unhealty_days_num':'\(secondTextField.text! as! String)',")
                    var str = tempstring as! String
                    tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                    tempstring.appendString("}\"}")
                    print(tempstring)
                    
                 }else if(indexPath.section == 2){
                        tempstring.appendString("'violent_crime_num':'\(secondTextField.text! as! String)',")
                        var str = tempstring as! String
                        tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                        tempstring.appendString("}\"}")
                    }
                }else if(self.currenttitle == "prosperity"){
                 if(indexPath.section == 1){
                    
                    tempstring.appendString("'unemployement_perc_num':'\(secondTextField.text! as! String)',")
                    var str = tempstring as! String
                    tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                    tempstring.appendString("}\"}")
                  
                 }else if(indexPath.section == 0){
                    tempstring.appendString("'median_income_num':'\(secondTextField.text! as! String)',")
                    var str = tempstring as! String
                    tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                    tempstring.appendString("}\"}")
                 }
                 }else if(self.currenttitle == "equitablity"){
                 if(indexPath.section == 1){
                    tempstring.appendString("'gini_coefficient_num':'\(secondTextField.text! as! String)',")
                    var str = tempstring as! String
                    tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                    tempstring.appendString("}\"}")
                    
                 }else if(indexPath.section == 0){
                    tempstring.appendString("'rent_income_perc_num':'\(secondTextField.text! as! String)',")
                    var str = tempstring as! String
                    tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                    tempstring.appendString("}\"}")
                 }
                 }else if(self.currenttitle == "education"){
                 if(indexPath.section == 1){
                    tempstring.appendString("'bachelor_degree_perc_num':'\(secondTextField.text! as! String)',")
                    var str = tempstring as! String
                    tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                    tempstring.appendString("}\"}")
                    
                 }else if(indexPath.section == 0){
                    
                    tempstring.appendString("'high_school_perc_num':'\(secondTextField.text! as! String)',")
                    var str = tempstring as! String
                    tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                    tempstring.appendString("}\"}")
                 }
                 }else if(self.currenttitle == "transportation"){
                 if(indexPath.section == 0){
                    tempstring.appendString("'vehicles_miles_num':'\(secondTextField.text! as! String)',")
                    var str = tempstring as! String
                    tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                    tempstring.appendString("}\"}")
                 }
                 }else if(self.currenttitle == "waste"){
                 if(indexPath.section == 0){
                    tempstring.appendString("'waste_generated_num':'\(secondTextField.text! as! String)',")
                    var str = tempstring as! String
                    tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                    tempstring.appendString("}\"}")
                 }else if(indexPath.section == 1){
                    tempstring.appendString("'waste_diversion_perc_num':'\(secondTextField.text! as! String)',")
                    var str = tempstring as! String
                    tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                    tempstring.appendString("}\"}")
                 }
                 }
                 else if(self.currenttitle == "water"){
                 if(indexPath.section == 0){
                    tempstring.appendString("'water_consumption_num':'\(secondTextField.text! as! String)',")
                    var str = tempstring as! String
                    tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                    tempstring.appendString("}\"}")
                 }
                 }else if(self.currenttitle == "energy"){
                 if(indexPath.section == 0){
                    tempstring.appendString("'ghg_emissions_num':'\(secondTextField.text! as! String)',")
                    var str = tempstring as! String
                    tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                    tempstring.appendString("}\"}")
                 }
                 }
                 //
            }
            self.spinner.hidden = false
            self.addactiondata(credentials().subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), ID: self.currentdict["CreditShortId"] as! String, payload: tempstring as String)
            print(tempstring)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            var dict = (self.actiondata[indexPath.row].mutableCopy() as! NSMutableDictionary)
            self.currentyear = dict["year"] as! String
            textField.text = self.currentyear
            textField.userInteractionEnabled = false
        }
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.userInteractionEnabled = true
            textField.placeholder = "Enter value"
            if(cell.detailTextLabel?.text?.characters.count > 0){
            textField.text = cell.detailTextLabel?.text!
            }
            textField.becomeFirstResponder()
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var arr = dict[currenttitle] as! NSArray
        return arr.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var arr = dict[currenttitle] as! NSArray
        return arr[section] as! String
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return no_of_records
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.contentInset = UIEdgeInsetsZero
        var cell = tableView.dequeueReusableCellWithIdentifier("yearlycell") as! yearlycell
        var dict = actiondata[indexPath.row] as! [String:AnyObject]
        if(dict["data"] != nil){
        var tempdata = dict["data"] as! String
        tempdata = tempdata.stringByReplacingOccurrencesOfString("'", withString: "\"")
        print(tempdata)
        dict["data"] = convertStringToDictionary(tempdata)
        if let json = try? NSJSONSerialization.dataWithJSONObject(dict, options: []) {
            // here `json` is your JSON data
            if let jsonDictionary = try? NSJSONSerialization.JSONObjectWithData(json, options: NSJSONReadingOptions()) {
            //print(jsonDictionary["data"]!!["air_quality_index_num"])
                dict = jsonDictionary as! [String:AnyObject]
            }
        }
        
        if(currenttitle == "health & safety"){
            if(indexPath.section == 0){
                cell.textLabel?.text = dict["year"] as? String
                if(dict["data"]!["air_quality_index_num"] != nil){
                cell.detailTextLabel?.text = dict["data"]!["air_quality_index_num"] as? String
                }
            }else if(indexPath.section == 1){
                cell.textLabel?.text = dict["year"] as? String
                if(dict["data"]!["unhealty_days_num"] != nil){
                cell.detailTextLabel?.text = dict["data"]!["unhealty_days_num"] as? String
                }
            }else if(indexPath.section == 2){
                cell.textLabel?.text = dict["year"] as? String
                if(dict["data"]!["violent_crime_num"] != nil){
                cell.detailTextLabel?.text = dict["data"]!["violent_crime_num"] as? String
                }
            }
        }else if(currenttitle == "prosperity"){
            if(indexPath.section == 1){
                cell.textLabel?.text = dict["year"] as? String
                if(dict["data"]!["unemployement_perc_num"] != nil){
                    cell.detailTextLabel?.text = dict["data"]!["unemployement_perc_num"] as? String
                }
            }else if(indexPath.section == 0){
                cell.textLabel?.text = dict["year"] as? String
                if(dict["data"]!["median_income_num"] != nil){
                    cell.detailTextLabel?.text = dict["data"]!["median_income_num"] as? String
                }
            }
        }else if(currenttitle == "equitablity"){
            if(indexPath.section == 1){
                cell.textLabel?.text = dict["year"] as? String
                if(dict["data"]!["gini_coefficient_num"] != nil){
                    cell.detailTextLabel?.text = dict["data"]!["gini_coefficient_num"] as? String
                }
            }else if(indexPath.section == 0){
                cell.textLabel?.text = dict["year"] as? String
                if(dict["data"]!["rent_income_perc_num"] != nil){
                    cell.detailTextLabel?.text = dict["data"]!["rent_income_perc_num"] as? String
                }
            }
        }else if(currenttitle == "education"){
            if(indexPath.section == 1){
                cell.textLabel?.text = dict["year"] as? String
                if(dict["data"]!["bachelor_degree_perc_num"] != nil){
                    cell.detailTextLabel?.text = dict["data"]!["bachelor_degree_perc_num"] as? String
                }
            }else if(indexPath.section == 0){
                cell.textLabel?.text = dict["year"] as? String
                if(dict["data"]!["high_school_perc_num"] != nil){
                    cell.detailTextLabel?.text = dict["data"]!["high_school_perc_num"] as? String
                }
            }
        }else if(currenttitle == "transportation"){
            if(indexPath.section == 0){
                cell.textLabel?.text = dict["year"] as? String
                if(dict["data"]!["vehicles_miles_num"] != nil){
                    cell.detailTextLabel?.text = dict["data"]!["vehicles_miles_num"] as? String
                }
            }
        }else if(currenttitle == "waste"){
            if(indexPath.section == 0){
                cell.textLabel?.text = dict["year"] as? String
                if(dict["data"]!["waste_generated_num"] != nil){
                    cell.detailTextLabel?.text = dict["data"]!["waste_generated_num"] as? String
                }
            }else if(indexPath.section == 1){
                cell.textLabel?.text = dict["year"] as? String
                if(dict["data"]!["waste_diversion_perc_num"] != nil){
                    cell.detailTextLabel?.text = dict["data"]!["waste_diversion_perc_num"] as? String
                }
            }
            }
        else if(currenttitle == "water"){
            if(indexPath.section == 0){
                cell.textLabel?.text = dict["year"] as? String
                if(dict["data"]!["water_consumption_num"] != nil){
                    cell.detailTextLabel?.text = dict["data"]!["water_consumption_num"] as? String
                }
            }
        }else if(currenttitle == "energy"){
            if(indexPath.section == 0){
                cell.textLabel?.text = dict["year"] as? String
                if(dict["data"]!["ghg_emissions_num"] != nil){
                    cell.detailTextLabel?.text = dict["data"]!["ghg_emissions_num"] as? String
                }
            }
            }
            //
            
        }
        return cell
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "adasd"
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var view = UIView()
        view.frame = CGRectMake(0, 40, tableview.layer.frame.size.width, 40)
        var prevbutton = UIButton.init(frame: CGRectMake(0.01 * tableview.layer.frame.size.width, 10, 0.24 * tableview.layer.frame.size.width, 30))
        var nextbutton = UIButton.init(frame: CGRectMake(0.75 * tableview.layer.frame.size.width, 10, 0.24 * tableview.layer.frame.size.width, 30))
        prevbutton.setTitle("Previous year", forState: UIControlState.Normal)
        nextbutton.setTitle("Next year", forState: UIControlState.Normal)
        prevbutton.titleLabel?.font = UIFont.init(name: "OpenSans", size: 11)
        nextbutton.titleLabel?.font = UIFont.init(name: "OpenSans", size: 11)
        prevbutton.layer.backgroundColor = UIColor.darkGrayColor().CGColor
        prevbutton.layer.cornerRadius = 5
        nextbutton.layer.backgroundColor = UIColor.darkGrayColor().CGColor
        nextbutton.layer.cornerRadius = 5
        prevbutton.tag = section
        nextbutton.tag = section
        prevbutton.addTarget(self, action: #selector(self.previous(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        nextbutton.addTarget(self, action: #selector(self.next(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(prevbutton)
        view.addSubview(nextbutton)
        return view
    }
    
    
    
    func previous(sender:UIButton){
        print(sender.tag)
        var str = self.tableView(tableview, titleForHeaderInSection: sender.tag)?.capitalizedString
        
        let alertController = UIAlertController(title: "Add new data", message: str, preferredStyle: UIAlertControllerStyle.Alert)
        
        let saveAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: {
            alert -> Void in
            var tempstring = NSMutableString()
            let firstTextField = alertController.textFields![0] as UITextField
            let secondTextField = alertController.textFields![1] as UITextField
            var dict = (self.actiondata.firstObject?.mutableCopy() as! NSMutableDictionary)
            var tempdata = dict["data"] as! String
            tempdata = tempdata.stringByReplacingOccurrencesOfString("'", withString: "\"")
            print(tempdata)
            dict["data"] = self.convertStringToDictionary(tempdata)
            if let json = try? NSJSONSerialization.dataWithJSONObject(dict, options: []) {
                // here `json` is your JSON data
                if let jsonDictionary = try? NSJSONSerialization.JSONObjectWithData(json, options: NSJSONReadingOptions()) {
                    //print(jsonDictionary["data"]!!["air_quality_index_num"])
                    dict = jsonDictionary.mutableCopy() as! NSMutableDictionary
                }
            }
            if(self.currentyear == dict["year"] as! String){
                //
            }else{
                tempstring.appendString("{\"data\":\"{")
                if(self.currenttitle == "health & safety"){
                    if(sender.tag == 0){
                        tempstring.appendString("'air_quality_index_num':'\(secondTextField.text! as! String)',")
                        var str = tempstring as! String
                        tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                        tempstring.appendString("}\"}")
                        print(tempstring)
                        
                    }else if(sender.tag == 1){
                        tempstring.appendString("'unhealty_days_num':'\(secondTextField.text! as! String)',")
                        var str = tempstring as! String
                        tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                        tempstring.appendString("}\"}")
                        print(tempstring)
                        
                    }else if(sender.tag == 2){
                        tempstring.appendString("'violent_crime_num':'\(secondTextField.text! as! String)',")
                        var str = tempstring as! String
                        tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                        tempstring.appendString("}\"}")
                    }
                }else if(self.currenttitle == "prosperity"){
                    if(sender.tag == 1){
                        
                        tempstring.appendString("'unemployement_perc_num':'\(secondTextField.text! as! String)',")
                        var str = tempstring as! String
                        tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                        tempstring.appendString("}\"}")
                        
                    }else if(sender.tag == 0){
                        tempstring.appendString("'median_income_num':'\(secondTextField.text! as! String)',")
                        var str = tempstring as! String
                        tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                        tempstring.appendString("}\"}")
                    }
                }else if(self.currenttitle == "equitablity"){
                    if(sender.tag == 1){
                        tempstring.appendString("'gini_coefficient_num':'\(secondTextField.text! as! String)',")
                        var str = tempstring as! String
                        tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                        tempstring.appendString("}\"}")
                        
                    }else if(sender.tag == 0){
                        tempstring.appendString("'rent_income_perc_num':'\(secondTextField.text! as! String)',")
                        var str = tempstring as! String
                        tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                        tempstring.appendString("}\"}")
                    }
                }else if(self.currenttitle == "education"){
                    if(sender.tag == 1){
                        tempstring.appendString("'bachelor_degree_perc_num':'\(secondTextField.text! as! String)',")
                        var str = tempstring as! String
                        tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                        tempstring.appendString("}\"}")
                        
                    }else if(sender.tag == 0){
                        
                        tempstring.appendString("'high_school_perc_num':'\(secondTextField.text! as! String)',")
                        var str = tempstring as! String
                        tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                        tempstring.appendString("}\"}")
                    }
                }else if(self.currenttitle == "transportation"){
                    if(sender.tag == 0){
                        tempstring.appendString("'vehicles_miles_num':'\(secondTextField.text! as! String)',")
                        var str = tempstring as! String
                        tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                        tempstring.appendString("}\"}")
                    }
                }else if(self.currenttitle == "waste"){
                    if(sender.tag == 0){
                        tempstring.appendString("'waste_generated_num':'\(secondTextField.text! as! String)',")
                        var str = tempstring as! String
                        tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                        tempstring.appendString("}\"}")
                    }else if(sender.tag == 1){
                        tempstring.appendString("'waste_diversion_perc_num':'\(secondTextField.text! as! String)',")
                        var str = tempstring as! String
                        tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                        tempstring.appendString("}\"}")
                    }
                }
                else if(self.currenttitle == "water"){
                    if(sender.tag == 0){
                        tempstring.appendString("'water_consumption_num':'\(secondTextField.text! as! String)',")
                        var str = tempstring as! String
                        tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                        tempstring.appendString("}\"}")
                    }
                }else if(self.currenttitle == "energy"){
                    if(sender.tag == 0){
                        tempstring.appendString("'ghg_emissions_num':'\(secondTextField.text! as! String)',")
                        var str = tempstring as! String
                        tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                        tempstring.appendString("}\"}")
                    }
                }
                
            }
            self.spinner.hidden = false
            self.addactiondata(credentials().subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), ID: self.currentdict["CreditShortId"] as! String, payload: tempstring as String)
            print(tempstring)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            var year = Int((self.actiondata.lastObject as! NSDictionary)["year"] as! String)!
            year = year - 1
            textField.text = "\(year as! Int)"
            self.currentyear = textField.text!
            textField.userInteractionEnabled = false
        }
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.userInteractionEnabled = true
            textField.placeholder = "Enter value"
            textField.becomeFirstResponder()
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)

    }
    
    var data_arr = NSMutableArray()
    func next(sender:UIButton){
        print(sender.tag)
        var str = self.tableView(tableview, titleForHeaderInSection: sender.tag)?.capitalizedString
        
        let alertController = UIAlertController(title: "Add new data", message: str, preferredStyle: UIAlertControllerStyle.Alert)
        
        let saveAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: {
            alert -> Void in
            var tempstring = NSMutableString()
            let firstTextField = alertController.textFields![0] as UITextField
            let secondTextField = alertController.textFields![1] as UITextField
            var dict = (self.actiondata.firstObject?.mutableCopy() as! NSMutableDictionary)
            var tempdata = dict["data"] as! String
            tempdata = tempdata.stringByReplacingOccurrencesOfString("'", withString: "\"")
            print(tempdata)
            dict["data"] = self.convertStringToDictionary(tempdata)
            if let json = try? NSJSONSerialization.dataWithJSONObject(dict, options: []) {
                // here `json` is your JSON data
                if let jsonDictionary = try? NSJSONSerialization.JSONObjectWithData(json, options: NSJSONReadingOptions()) {
                    //print(jsonDictionary["data"]!!["air_quality_index_num"])
                    dict = jsonDictionary.mutableCopy() as! NSMutableDictionary
                }
            }
            if(self.currentyear == dict["year"] as! String){
                                         //
            }else{
                tempstring.appendString("{\"data\":\"{")
                if(self.currenttitle == "health & safety"){
                    if(sender.tag == 0){
                        tempstring.appendString("'air_quality_index_num':'\(secondTextField.text! as! String)',")
                        var str = tempstring as! String
                        tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                        tempstring.appendString("}\"}")
                        print(tempstring)
                        
                    }else if(sender.tag == 1){
                        tempstring.appendString("'unhealty_days_num':'\(secondTextField.text! as! String)',")
                        var str = tempstring as! String
                        tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                        tempstring.appendString("}\"}")
                        print(tempstring)
                        
                    }else if(sender.tag == 2){
                        tempstring.appendString("'violent_crime_num':'\(secondTextField.text! as! String)',")
                        var str = tempstring as! String
                        tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                        tempstring.appendString("}\"}")
                    }
                }else if(self.currenttitle == "prosperity"){
                    if(sender.tag == 1){
                        
                        tempstring.appendString("'unemployement_perc_num':'\(secondTextField.text! as! String)',")
                        var str = tempstring as! String
                        tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                        tempstring.appendString("}\"}")
                        
                    }else if(sender.tag == 0){
                        tempstring.appendString("'median_income_num':'\(secondTextField.text! as! String)',")
                        var str = tempstring as! String
                        tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                        tempstring.appendString("}\"}")
                    }
                }else if(self.currenttitle == "equitablity"){
                    if(sender.tag == 1){
                        tempstring.appendString("'gini_coefficient_num':'\(secondTextField.text! as! String)',")
                        var str = tempstring as! String
                        tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                        tempstring.appendString("}\"}")
                        
                    }else if(sender.tag == 0){
                        tempstring.appendString("'rent_income_perc_num':'\(secondTextField.text! as! String)',")
                        var str = tempstring as! String
                        tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                        tempstring.appendString("}\"}")
                    }
                }else if(self.currenttitle == "education"){
                    if(sender.tag == 1){
                        tempstring.appendString("'bachelor_degree_perc_num':'\(secondTextField.text! as! String)',")
                        var str = tempstring as! String
                        tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                        tempstring.appendString("}\"}")
                        
                    }else if(sender.tag == 0){
                        
                        tempstring.appendString("'high_school_perc_num':'\(secondTextField.text! as! String)',")
                        var str = tempstring as! String
                        tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                        tempstring.appendString("}\"}")
                    }
                }else if(self.currenttitle == "transportation"){
                    if(sender.tag == 0){
                        tempstring.appendString("'vehicles_miles_num':'\(secondTextField.text! as! String)',")
                        var str = tempstring as! String
                        tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                        tempstring.appendString("}\"}")
                    }
                }else if(self.currenttitle == "waste"){
                    if(sender.tag == 0){
                        tempstring.appendString("'waste_generated_num':'\(secondTextField.text! as! String)',")
                        var str = tempstring as! String
                        tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                        tempstring.appendString("}\"}")
                    }else if(sender.tag == 1){
                        tempstring.appendString("'waste_diversion_perc_num':'\(secondTextField.text! as! String)',")
                        var str = tempstring as! String
                        tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                        tempstring.appendString("}\"}")
                    }
                }
                else if(self.currenttitle == "water"){
                    if(sender.tag == 0){
                        tempstring.appendString("'water_consumption_num':'\(secondTextField.text! as! String)',")
                        var str = tempstring as! String
                        tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                        tempstring.appendString("}\"}")
                    }
                }else if(self.currenttitle == "energy"){
                    if(sender.tag == 0){
                        tempstring.appendString("'ghg_emissions_num':'\(secondTextField.text! as! String)',")
                        var str = tempstring as! String
                        tempstring.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
                        tempstring.appendString("}\"}")
                    }
                }

            }
            self.spinner.hidden = false
            self.addactiondata(credentials().subscription_key, leedid: NSUserDefaults.standardUserDefaults().integerForKey("leed_id"), ID: self.currentdict["CreditShortId"] as! String, payload: tempstring as String)
            print(tempstring)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            var year = Int((self.actiondata.firstObject as! NSDictionary)["year"] as! String)!
            year = year + 1
            textField.text = "\(year as! Int)"
            self.currentyear = textField.text!
            textField.userInteractionEnabled = false
        }
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.userInteractionEnabled = true
            textField.placeholder = "Enter value"
            textField.becomeFirstResponder()
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func addactiondata(subscription_key:String, leedid: Int, ID : String, payload : String){
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/actions/ID:%@/data/%@/?recompute_score=1",credentials().domain_url, leedid,ID,self.currentyear))
        print(url?.absoluteURL)
        var subscription_key = credentials().subscription_key
        var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        var httpbody = payload
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
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 && httpStatus.statusCode != 201{           // check for http errors
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

    
    
    
    var currentyear = ""
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    
    var listdata = NSMutableArray()
    func getactiondata(subscription_key:String, leedid: Int, ID : String){
        let url = NSURL.init(string: String(format: "%@assets/LEED:%d/actions/ID:%@/data/",credentials().domain_url,leedid,ID))
        print(url?.absoluteURL)
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        download_requests.append(session)
        self.task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                if((error?.description.containsString("cancelled")) != nil){
                    if(error?.code == -999){
                        
                    }else{
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    }
                }else{
                    print("error=\(error?.description)")
                    print("response",response)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableview.hidden = false
                        self.spinner.hidden = true
                        //self.tableview.frame = CGRectMake(self.tableview.layer.frame.origin.x, 1.02 * (self.affirmationview1.layer.frame.origin.y + self.affirmationview1.layer.frame.size.height), self.tableview.layer.frame.size.width,  50)
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
                }
                
                return
            }
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401 {           // check for http errors
                dispatch_async(dispatch_get_main_queue(), {
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                })
            }
            else if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
            }else{
                
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                    print("action data xcv",jsonDictionary)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.actiondata = jsonDictionary["results"]?.mutableCopy() as! NSMutableArray
                        self.no_of_records = self.actiondata.count
                        self.listdata = self.actiondata
                        self.spinner.hidden = true
                        //self.view.userInteractionEnabled = true
                        NSUserDefaults.standardUserDefaults().synchronize()
                      //  self.navigate()
                        self.tableview.reloadData()
                        
                        return
                    })
                } catch {
                    print(error)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                        
                    })
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
            self.maketoast(message, type: "error")
            //self.navigationController?.popViewControllerAnimated(true)
        })
        
        //        }
        //      let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        //    alertController.addAction(defaultAction)
        
        //presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    @IBOutlet weak var spinner: UIView!
    
    //https://api.usgbc.org/stg/leed/
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
