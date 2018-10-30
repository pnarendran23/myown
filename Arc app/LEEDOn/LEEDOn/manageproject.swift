//
//  manageproject.swift
//  LEEDOn
//
//  Created by Group X on 07/12/16.
//  Copyright © 2016 USGBC. All rights reserved.
//

import UIKit

class manageproject: UIViewController,UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource, UITabBarDelegate {
    @IBOutlet weak var assetname: UILabel!

    @IBOutlet weak var spinner: UIView!
    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var tableview: UITableView!
    var titlearr = NSArray()
    var state = ""
    var data_dict = NSMutableDictionary()
            var leedid = NSUserDefaults.standardUserDefaults().integerForKey("leed_id")
    var listarr = ["","","","","","","","","","","","","","","","","","","","","","","","",""] as! NSMutableArray
    var unitarr = ["SI","IP"]
    var spacearr = ["Circulation space","Core learning space:College/University","Core learning space:K-12 Elementary/Middle school","Core learning space: K-12 High school","Core learning space:Other classroom education","Core learning space:Preschool/Daycare","Data Center","Healthcare: Clinic/Other outpatient","Healthcare:Inpatient","Healthcare:Nursing Home/Assisted living","Healthcare: Outpatient office(diagnostic)","Industrial manufacturing","Laboratory","Lodging: Dormitory","Lodging: Hotel/Motel/Report, Full service","Lodging: Hotel/Motel/Report, Limited service","Lodging: Hotel/Motel/Report, Select service","Lodging: Inn","Lodging: Other lodging","Multifamily residential: Apartment","Multifamily residential: Condomninum","Multifamily residential: Lowrise","Office: Administrative/Professional","Office: Financial","Office: Government","Office: Medical(non-diagnostic)","Office: Mixed use","Office: Other office","Public assembly: Convention Center","Public assembly: Recreation","Public assembly: Social/Meeting","Public assembly:Stadium/Arena","Public Order and safety:Fire/Police station","Public order and safety: Other public order","Religious worship","Retail: Bank branch","Retail: Convenience","Retail:Enclosed Mall","Fast Food","Grocery store/Food market","Retail: Open shopping center","Retail: Other Retail","Retail: Restaurant/cafeteria","Retail: Vehicle dealership","Service: Other service","Service: Post office/postal center","Service: Repair shop","Service: Vehicle service/repair","Service: Vehicle storage/maintanance","Single family home(attached)","Single family home(detached)","Warehouse: Nonrefridgerated distribution/shipping","Warehouse: Refridgerated","Warehouse: Self storage units","Warehouse:General","Other"]
    var currentarr = NSArray()
    var country = ""
    var pursedcertarr = NSArray()
    var yesorno = ["Yes","No"] as! NSArray
    var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String
    var dict = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.layer.cornerRadius = 5
        self.spinner.hidden = true
        self.view.userInteractionEnabled = true
        dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary
        print(dict)
        assetname.text = dict["name"] as! String
        tabbar.selectedItem = self.tabbar.items![3]
        data_dict = dict.mutableCopy() as! NSMutableDictionary
        pursedcertarr = ["WELL","Sustainable SITES", "PEER","Parksmart","GRESB","EDGE","Green Star","DGNB","BREEAM","Zero Waste","ENERGY STAR","Beam","CASBEE","Green Mark","Pearl","Other"]
        titlearr = ["Name","Project ID","Unit Type","Space type","Address","City","State","Country","Private","Owner type","Owner organization","Owner Email","Owner country","Previously LEED Certified?","Other certification programs pursued","Contains residential units?","Is project affiliated with a higher education institute?","Is project affiliated with a LEED Lab?","Year built","Floors above grounds","Intend to precertify?","Gross floor area(square foot)","Target certification date","Operating hours","Occupancy"]
        tableview.registerNib(UINib.init(nibName: "manageprojectcell", bundle: nil), forCellReuseIdentifier: "managecell")
        dispatch_async(dispatch_get_main_queue(), {
            self.spinner.hidden = false
            self.view.userInteractionEnabled = false
        })
        getstates(credentials().subscription_key)
        // Do any additional setup after loading the view.
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if(item.title == "Plaque"){
            self.performSegueWithIdentifier("gotoplaque", sender: nil)
        }else if(item.title == "Credits/Actions"){
            self.performSegueWithIdentifier("gotoactions", sender: nil)
        }else if(item.title == "Analytics"){
            self.performSegueWithIdentifier("gotoanalysis", sender: nil)
        }
    }
    
    
    func getstates(subscription_key:String){
        let url = NSURL.init(string:String(format: "%@country/states/",credentials().domain_url))
        print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token!), forHTTPHeaderField:"Authorization" )
        var task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            
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
                    //print(jsonDictionary)
                    dispatch_async(dispatch_get_main_queue(), {
                    
                    var currentcountry = self.dict["country"] as? String
                    var currentstate = self.dict["state"] as? String
                        var tempstring = jsonDictionary["divisions"]![currentcountry!]!![currentstate!]! as? String
                        print(tempstring)
                    self.state =  tempstring!
                    tempstring = jsonDictionary["countries"]![currentcountry!]! as? String
                    self.country = tempstring!
                        self.spinner.hidden = true
                        self.view.userInteractionEnabled = true
                    self.tableview.reloadData()
                    })
                    
                    //self.tableview.reloadData()
                    // self.buildingactions(subscription_key, leedid: leedid)
                } catch {
                    print(error)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.spinner.hidden = true
                        self.view.userInteractionEnabled = true
                    })
                }
            }
            
        }
        task.resume()
        
    }
    
    func showalert(message:String, title:String, action:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                self.spinner.hidden = true
                self.view.userInteractionEnabled = true
                self.navigationController?.popViewControllerAnimated(true)
                
            })
            
        }
        let defaultAction = UIAlertAction(title: action, style: .Default, handler:callActionHandler)
        
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
        
    }


    //https://api.usgbc.org/dev/leed/country/states/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return titlearr.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("managecell") as! manageprojectcell
        cell.titlelbl.text = titlearr.objectAtIndex(indexPath.section) as? String
        cell.valuetxtfld.delegate = self
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.valuetxtfld.tag = indexPath.section
        cell.contentView.alpha = 1
        cell.valuetxtfld.placeholder = ""
        if(indexPath.section == 0){
            cell.userInteractionEnabled = true
            cell.valuetxtfld.enabled = true
            cell.yesnoswitch.hidden = true
            cell.valuetxtfld.keyboardType = UIKeyboardType.Default
            cell.valuetxtfld.text = data_dict["name"] as? String
            listarr.replaceObjectAtIndex(indexPath.section, withObject: cell.valuetxtfld.text!)
        }else if(indexPath.section == 1){
            cell.userInteractionEnabled = false
            cell.contentView.alpha = 0.4
            cell.valuetxtfld.enabled = false
            cell.yesnoswitch.hidden = true
            cell.valuetxtfld.keyboardType = UIKeyboardType.NumberPad
            cell.valuetxtfld.text = String(format: "%d",dict["leed_id"] as! Int)
            listarr.replaceObjectAtIndex(indexPath.section, withObject: cell.valuetxtfld.text!)
        }else if(indexPath.section == 2){
            cell.userInteractionEnabled = true
            cell.valuetxtfld.enabled = true
            cell.yesnoswitch.hidden = true
            cell.valuetxtfld.keyboardType = UIKeyboardType.Alphabet
            cell.valuetxtfld.text = data_dict["unitType"] as? String
            listarr.replaceObjectAtIndex(indexPath.section, withObject: cell.valuetxtfld.text!)
        }else if(indexPath.section == 3){
            cell.userInteractionEnabled = true
            cell.valuetxtfld.enabled = true
            cell.yesnoswitch.hidden = true
            cell.valuetxtfld.keyboardType = UIKeyboardType.Alphabet
            cell.valuetxtfld.text = data_dict["spaceType"] as? String
            listarr.replaceObjectAtIndex(indexPath.section, withObject: cell.valuetxtfld.text!)
        }else if(indexPath.section == 4){
            cell.userInteractionEnabled = false
            cell.contentView.alpha = 0.4
            cell.valuetxtfld.enabled = false
            cell.yesnoswitch.hidden = true
            cell.valuetxtfld.keyboardType = UIKeyboardType.Default
            cell.valuetxtfld.text = data_dict["street"] as? String
            listarr.replaceObjectAtIndex(indexPath.section, withObject: cell.valuetxtfld.text!)
        }else if(indexPath.section == 5){
            cell.userInteractionEnabled = false
            cell.contentView.alpha = 0.4
            cell.valuetxtfld.enabled = false
            cell.yesnoswitch.hidden = true
            cell.valuetxtfld.keyboardType = UIKeyboardType.Alphabet
            cell.valuetxtfld.text = data_dict["city"] as? String
            listarr.replaceObjectAtIndex(indexPath.section, withObject: cell.valuetxtfld.text!)
        }else if(indexPath.section == 6){
            cell.userInteractionEnabled = false
            cell.contentView.alpha = 0.4
            cell.yesnoswitch.hidden = true
            cell.valuetxtfld.enabled = false
            cell.valuetxtfld.keyboardType = UIKeyboardType.Alphabet
            cell.valuetxtfld.text = state
            listarr.replaceObjectAtIndex(indexPath.section, withObject: cell.valuetxtfld.text!)
        }else if(indexPath.section == 7){
            cell.userInteractionEnabled = false
            cell.contentView.alpha = 0.4
            cell.valuetxtfld.enabled = false
            cell.yesnoswitch.hidden = true
            cell.valuetxtfld.keyboardType = UIKeyboardType.Alphabet
            cell.valuetxtfld.text = country
            listarr.replaceObjectAtIndex(indexPath.section, withObject: cell.valuetxtfld.text!)
        }else if(indexPath.section == 8){
            cell.userInteractionEnabled = true
            cell.valuetxtfld.enabled = false
            cell.yesnoswitch.hidden = false
            cell.valuetxtfld.text = ""
            cell.yesnoswitch.tag = 100+indexPath.section
            cell.yesnoswitch.addTarget(self, action: "switchused:", forControlEvents:UIControlEvents.ValueChanged)
            cell.valuetxtfld.keyboardType = UIKeyboardType.Default
            print(data_dict["plaque_public"])
            cell.yesnoswitch.on = !Bool(data_dict["plaque_public"] as! NSNumber)
            listarr.replaceObjectAtIndex(indexPath.section, withObject: cell.valuetxtfld.text!)
        }else if(indexPath.section == 9){
            cell.userInteractionEnabled = false
            cell.contentView.alpha = 0.4
            cell.valuetxtfld.enabled = false
            cell.yesnoswitch.hidden = true
            cell.valuetxtfld.text = data_dict["ownerType"] as? String
            listarr.replaceObjectAtIndex(indexPath.section, withObject: cell.valuetxtfld.text!)
        }else if(indexPath.section == 10){
            cell.userInteractionEnabled = false
            cell.contentView.alpha = 0.4
            cell.valuetxtfld.enabled = false
            cell.yesnoswitch.hidden = true
            cell.valuetxtfld.text = data_dict["organization"] as? String
            listarr.replaceObjectAtIndex(indexPath.section, withObject: cell.valuetxtfld.text!)
        }else if(indexPath.section == 11){
            cell.userInteractionEnabled = false
            cell.contentView.alpha = 0.4
            cell.valuetxtfld.enabled = false
            cell.valuetxtfld.text = data_dict["owner_email"] as? String
            cell.yesnoswitch.hidden = true
            listarr.replaceObjectAtIndex(indexPath.section, withObject: cell.valuetxtfld.text!)
        }else if(indexPath.section == 12){
            cell.userInteractionEnabled = false
            cell.contentView.alpha = 0.4
            cell.valuetxtfld.enabled = false
            cell.valuetxtfld.text = country
             cell.yesnoswitch.hidden = true
            listarr.replaceObjectAtIndex(indexPath.section, withObject: cell.valuetxtfld.text!)
        }else if(indexPath.section == 13){
            cell.userInteractionEnabled = true
            
            if(data_dict["ldp_old"] is NSNull){
                cell.yesnoswitch.on = false
            }else{
            if(data_dict["ldp_old"] as! Int == 1){
                cell.valuetxtfld.placeholder = "Enter your previous LEED ID"
                cell.yesnoswitch.on = Bool(data_dict["ldp_old"] as! NSNumber)
                if let s = data_dict["PrevCertProdId"] as? String{
                cell.valuetxtfld.text = s
                }else{
                cell.valuetxtfld.text = ""
                }
                cell.valuetxtfld.enabled = true
            }else{
              cell.yesnoswitch.on = false
                cell.valuetxtfld.enabled = false
                cell.valuetxtfld.text = ""
            }
            }
            
            cell.yesnoswitch.hidden = false
            cell.yesnoswitch.tag = 100+indexPath.section
            cell.yesnoswitch.addTarget(self, action: "switchused:", forControlEvents:UIControlEvents.ValueChanged)
            listarr.replaceObjectAtIndex(indexPath.section, withObject: cell.valuetxtfld.text!)
        }else if(indexPath.section == 14){
            cell.userInteractionEnabled = true
            cell.valuetxtfld.enabled = true
            cell.yesnoswitch.hidden = true
            var arr = data_dict["certifications"] as! NSArray
            if(arr.count>0){
                var str = arr.componentsJoinedByString(",")
                cell.valuetxtfld.text = str
            }else{
                cell.valuetxtfld.text = ""
            }
            listarr.replaceObjectAtIndex(indexPath.section, withObject: cell.valuetxtfld.text!)
        }else if(indexPath.section == 15){
            cell.userInteractionEnabled = true
            
            if(data_dict["IsResidential"] as! Int == 0){
                cell.valuetxtfld.enabled = false
                cell.yesnoswitch.on = Bool(data_dict["IsResidential"] as! NSNumber)
                cell.valuetxtfld.text = ""
            }else{
                cell.yesnoswitch.on = Bool(data_dict["IsResidential"] as! NSNumber)
                cell.valuetxtfld.enabled = true
                if(data_dict["noOfResUnits"] != nil){
                    cell.valuetxtfld.placeholder = "Number of resident units"
                    cell.valuetxtfld.text = String(format: "%d",data_dict["noOfResUnits"] as! Int)
                }
            }
            cell.yesnoswitch.hidden = false
            cell.yesnoswitch.tag = 100+indexPath.section
            cell.yesnoswitch.addTarget(self, action: "switchused:", forControlEvents:UIControlEvents.ValueChanged)
        }else if(indexPath.section == 16){
            cell.userInteractionEnabled = true
            cell.valuetxtfld.enabled = true
            //nameOfSchool
            if(data_dict["AffiliatedHigherEduIns"] as! Int == 0){
                cell.valuetxtfld.enabled = false
                cell.yesnoswitch.on = Bool(data_dict["AffiliatedHigherEduIns"] as! NSNumber)
                cell.valuetxtfld.text = ""
            }else{
                cell.yesnoswitch.on = Bool(data_dict["AffiliatedHigherEduIns"] as! NSNumber)
                cell.valuetxtfld.enabled = true
                if(data_dict["nameOfSchool"] != nil){
                    cell.valuetxtfld.placeholder = "Name of school"
                    cell.valuetxtfld.text = data_dict["nameOfSchool"] as! String
                }
            }
            cell.yesnoswitch.hidden = false
            cell.yesnoswitch.tag = 100+indexPath.section
            cell.yesnoswitch.addTarget(self, action: "switchused:", forControlEvents:UIControlEvents.ValueChanged)
            listarr.replaceObjectAtIndex(indexPath.section, withObject: cell.valuetxtfld.text!)
        }else if(indexPath.section == 17){
            cell.userInteractionEnabled = true
            cell.valuetxtfld.enabled = false
            cell.valuetxtfld.text = ""
            if(data_dict["affiliatedWithLeedLab"] != nil){
                cell.yesnoswitch.on = Bool(data_dict["affiliatedWithLeedLab"] as! NSNumber)
            }
            cell.yesnoswitch.hidden = false
            cell.yesnoswitch.tag = 100+indexPath.section
            cell.yesnoswitch.addTarget(self, action: "switchused:", forControlEvents:UIControlEvents.ValueChanged)
        }else if(indexPath.section == 18){
            cell.userInteractionEnabled = true
            cell.valuetxtfld.enabled = true
            if(data_dict["year_constructed"] is NSNull || data_dict["year_constructed"] as? String == ""){
                cell.valuetxtfld.text = ""
            }else{
                cell.valuetxtfld.text = String(format:"%d",data_dict["year_constructed"] as! Int)
            }
            cell.yesnoswitch.hidden = true
        }else if(indexPath.section == 19){
            cell.userInteractionEnabled = true
            cell.valuetxtfld.enabled = true
            if(data_dict["noOfFloors"] is NSNull || data_dict["noOfFloors"] as? String == ""){
                cell.valuetxtfld.text = ""
            }else{
                cell.valuetxtfld.text = String(format:"%d",data_dict["noOfFloors"] as! Int)
            }
            cell.yesnoswitch.hidden = true
            cell.valuetxtfld.keyboardType = UIKeyboardType.NumberPad
            listarr.replaceObjectAtIndex(indexPath.section, withObject: cell.valuetxtfld.text!)
        }else if(indexPath.section == 20){
            cell.userInteractionEnabled = true
            cell.valuetxtfld.enabled = true
            cell.valuetxtfld.text = ""
            if(data_dict["intentToPrecertify"] as! Int == 0){
                if(data_dict["intentToPrecertify"] != nil){
                    cell.yesnoswitch.on = Bool(data_dict["intentToPrecertify"] as! NSNumber)
                }
            }else{
                cell.valuetxtfld.text = "Yes"
            }
            cell.yesnoswitch.hidden = false
            cell.yesnoswitch.tag = 100+indexPath.section
            cell.yesnoswitch.addTarget(self, action: "switchused:", forControlEvents:UIControlEvents.ValueChanged)
        }else if(indexPath.section == 21){
            cell.userInteractionEnabled = true
            cell.valuetxtfld.enabled = true
            cell.valuetxtfld.text = String(format:"%d",data_dict["gross_area"] as! Int)
            cell.valuetxtfld.keyboardType = UIKeyboardType.NumberPad
            cell.yesnoswitch.hidden = true
        }else if(indexPath.section == 22){
            cell.userInteractionEnabled = true
            cell.valuetxtfld.enabled = true
            if(data_dict["targetCertDate"] is NSNull || data_dict["targetCertDate"] as? String == ""){
                cell.valuetxtfld.text = ""
            }else{
                cell.valuetxtfld.text = String(format:"%@",data_dict["targetCertDate"] as! String)
            }
            cell.yesnoswitch.hidden = true
            listarr.replaceObjectAtIndex(indexPath.section, withObject: cell.valuetxtfld.text!)
        }else if(indexPath.section == 23){
            cell.userInteractionEnabled = true
            cell.valuetxtfld.enabled = true
            if(data_dict["operating_hours"] is NSNull || data_dict["operating_hours"] as? String == ""){
                cell.valuetxtfld.text = ""
            }else{
                cell.valuetxtfld.text = String(format:"%d",data_dict["operating_hours"] as! Int)
            }
            cell.yesnoswitch.hidden = true
            cell.valuetxtfld.keyboardType = UIKeyboardType.NumberPad
            listarr.replaceObjectAtIndex(indexPath.section, withObject: cell.valuetxtfld.text!)
        }else if(indexPath.section == 24){
            cell.userInteractionEnabled = true
            cell.valuetxtfld.enabled = true
            if(data_dict["occupancy"] is NSNull || data_dict["occupancy"] as? String == ""){
                cell.valuetxtfld.text = ""
            }else{
                cell.valuetxtfld.text = String(format:"%d",data_dict["occupancy"] as! Int)
            }
            cell.yesnoswitch.hidden = true
            cell.valuetxtfld.keyboardType = UIKeyboardType.NumberPad
            listarr.replaceObjectAtIndex(indexPath.section, withObject: cell.valuetxtfld.text!)
        }
        return cell
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        print(textField.tag)
        var indexPath = NSIndexPath.init(forRow: 0, inSection: textField.tag)
        
        if(indexPath.section == 13){
            var cell = tableview.cellForRowAtIndexPath(indexPath) as! manageprojectcell
        data_dict["PrevCertProdId"] = cell.valuetxtfld.text
        }else if(indexPath.section == 14){
            var cell = tableview.cellForRowAtIndexPath(indexPath) as! manageprojectcell
            data_dict["OtherCertProg"] = cell.valuetxtfld.text
        }else if(indexPath.section == 15){
            var cell = tableview.cellForRowAtIndexPath(indexPath) as! manageprojectcell
            let a:Int? = Int(cell.valuetxtfld.text!)
            data_dict["noOfResUnits"] = a
        }else if(indexPath.section == 16){
            var cell = tableview.cellForRowAtIndexPath(indexPath) as! manageprojectcell
            data_dict["nameOfSchool"] = cell.valuetxtfld.text!
        }else if(indexPath.section == 18){
            var cell = tableview.cellForRowAtIndexPath(indexPath) as! manageprojectcell
            let a:Int? = Int(cell.valuetxtfld.text!)
            data_dict["year_constructed"] = a
        }
        else if(indexPath.section == 21){
            var cell = tableview.cellForRowAtIndexPath(indexPath) as! manageprojectcell
            let a:Int? = Int(cell.valuetxtfld.text!)
            data_dict["gross_area"] = cell.valuetxtfld.text!
        }
        else if(indexPath.section == 23){
            var cell = tableview.cellForRowAtIndexPath(indexPath) as! manageprojectcell
            let a:Int? = Int(cell.valuetxtfld.text!)
            data_dict["operating_hours"] = cell.valuetxtfld.text!
        }
        else if(indexPath.section == 24){
            var cell = tableview.cellForRowAtIndexPath(indexPath) as! manageprojectcell
            let a:Int? = Int(cell.valuetxtfld.text!)
            data_dict["occupancy"] = cell.valuetxtfld.text!
        }
        else if(indexPath.section == 22){
            var cell = tableview.cellForRowAtIndexPath(indexPath) as! manageprojectcell
            let a:Int? = Int(cell.valuetxtfld.text!)
            data_dict["targetCertDate"] = cell.valuetxtfld.text!
        }else if(indexPath.section == 19){
            var cell = tableview.cellForRowAtIndexPath(indexPath) as! manageprojectcell
            let a:Int? = Int(cell.valuetxtfld.text!)
            data_dict["noOfFloors"] = a
        }
        
        
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(currentarr[row] is String){
        return currentarr[row] as? String
        }else{
            return String(format:"%d",currentarr[row] as! Int)
        }
    }
    
    func switchused(sender:UISwitch){
        print("Changing..")
        var switchctrl = sender
        print(sender.tag)
        var indexPath = NSIndexPath.init(forRow: 0, inSection: sender.tag-100)
        var cell = tableview.cellForRowAtIndexPath(indexPath) as! manageprojectcell
        if(indexPath.section == 8){
        if(sender.on){
            data_dict["plaque_public"] = 0
        }else{
            data_dict["plaque_public"] = 1
            }
        }else if(indexPath.section == 13){
         //PrevCertProdId
            
        if(sender.on){
                cell.valuetxtfld.placeholder = "Enter your previous LEED ID"
                data_dict["ldp_old"] = 1
                cell.valuetxtfld.text = ""
                cell.valuetxtfld.enabled = true
                cell.valuetxtfld.becomeFirstResponder()
            }else{
                cell.valuetxtfld.placeholder = ""
                data_dict["ldp_old"] = 0
                cell.valuetxtfld.text = ""
                cell.valuetxtfld.enabled = false
                data_dict.setValue(NSNull(), forKey: "PrevCertProdId")
                cell.valuetxtfld.resignFirstResponder()
            }
        }else if(indexPath.section == 15){
            if(sender.on){
                cell.valuetxtfld.placeholder = "Number of resident units"
                data_dict["IsResidential"] = 1
                cell.valuetxtfld.text = ""
                cell.valuetxtfld.enabled = true
                cell.valuetxtfld.becomeFirstResponder()
            }else{
                cell.valuetxtfld.placeholder = ""
                data_dict["IsResidential"] = 0
                cell.valuetxtfld.text = ""
                cell.valuetxtfld.enabled = false
                data_dict.setValue(NSNull(),forKey:"noOfResUnits")
                cell.valuetxtfld.resignFirstResponder()
            }
   
        }else if(indexPath.section == 16){
        //
            if(sender.on){
                cell.valuetxtfld.placeholder = "Name of school"
                data_dict["AffiliatedHigherEduIns"] = 1
                cell.valuetxtfld.text = ""
                cell.valuetxtfld.enabled = true
                cell.valuetxtfld.becomeFirstResponder()
            }else{
                cell.valuetxtfld.placeholder = ""
                data_dict["AffiliatedHigherEduIns"] = 0
                cell.valuetxtfld.text = ""
                cell.valuetxtfld.enabled = false
                data_dict.setValue(NSNull(),forKey:"nameOfSchool")
                cell.valuetxtfld.resignFirstResponder()
            }
        }else if(indexPath.section == 17){
            if(sender.on){
                data_dict["affiliatedWithLeedLab"] = 1
            }else{
                data_dict["affiliatedWithLeedLab"] = 0
            }
        }
        else if(indexPath.section == 20){
            if(sender.on){
                data_dict["intentToPrecertify"] = 1
            }else{
                data_dict["intentToPrecertify"] = 0
            }
        }
        else{
        if(sender.on){
            cell.valuetxtfld.text = ""
        cell.valuetxtfld.enabled = true
        cell.valuetxtfld.becomeFirstResponder()
        }else{
            cell.valuetxtfld.text = ""
            cell.valuetxtfld.enabled = false
            cell.valuetxtfld.resignFirstResponder()
        }
        }
        print("Final data dict", data_dict)
    }
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currentarr.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        var pointInTable:CGPoint = textField.superview!.convertPoint(textField.frame.origin, toView:tableview)
        var contentOffset:CGPoint = tableview.contentOffset
        contentOffset.y  = pointInTable.y
        if let accessoryView = textField.inputAccessoryView {
            contentOffset.y -= accessoryView.frame.size.height
        }
        tableview.contentOffset = contentOffset
        return true;
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        var indexPath = NSIndexPath.init(forRow: 0, inSection: textField.tag)
        var cell = tableview.cellForRowAtIndexPath(indexPath) as! manageprojectcell
        if(indexPath.section == 17 || indexPath.section == 16 || indexPath.section == 15 || indexPath.section == 13 || indexPath.section == 20){
            cell.valuetxtfld.inputView = nil
        }else if(indexPath.section == 18){
            var formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy"
            var dte = NSDate()
            var str = formatter.stringFromDate(dte)
            var year = Int(str)!
            print(year)
            var yearsarr = NSMutableArray()
            var selectedindex = 0
            for i in 0..<25 {
                yearsarr.addObject(year-i)
                if(cell.valuetxtfld.text?.characters.count>0){
                    var s = String(format: "%d",year-i)
                    if(cell.valuetxtfld.text == s){
                        selectedindex = i
                    }
                }
            }
            var picker = UIPickerView()
            picker.delegate = self
            picker.dataSource = self
            currentarr = yearsarr
            picker.tag = 1000+indexPath.section
            cell.valuetxtfld.inputView = picker
            picker.selectRow(selectedindex, inComponent: 0, animated: true)
            picker.reloadAllComponents()
        }else if(indexPath.section == 14){
            var picker = UIPickerView()
            picker.delegate = self
            picker.dataSource = self
            var selectedindex = 0
            currentarr = pursedcertarr
            for i in 0..<pursedcertarr.count{
                var s = pursedcertarr.objectAtIndex(i) as! String
                if(cell.valuetxtfld.text == s){
                    selectedindex = i
                    break
                }
            }
            picker.reloadAllComponents()
            picker.selectRow(selectedindex, inComponent: 0, animated: true)
            picker.tag = 1000+indexPath.section
            cell.valuetxtfld.inputView = picker
        }else if(indexPath.section == 22){
            var picker = UIDatePicker()
            picker.datePickerMode = UIDatePickerMode.Date
            picker.tag = 1000+indexPath.section
            cell.valuetxtfld.inputView = picker
            if(cell.valuetxtfld.text?.characters.count > 0){
                var s = cell.valuetxtfld.text!
                var formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                var date = formatter.dateFromString(s)
                picker.date = date!
            }
            picker.addTarget(self, action: #selector(self.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        }else if(indexPath.section == 2){
            var picker = UIPickerView()
            picker.delegate = self
            picker.dataSource = self
            currentarr = unitarr
            var selectedindex = 0
            for i in 0..<currentarr.count{
                var s = currentarr.objectAtIndex(i) as! String
                if(cell.valuetxtfld.text == s){
                    selectedindex = i
                    break
                }
            }
            
            picker.selectRow(selectedindex, inComponent: 0, animated: true)
            picker.reloadAllComponents()
            picker.tag = 1000+indexPath.section
            cell.valuetxtfld.inputView = picker
        }else if(indexPath.section == 3){
            var picker = UIPickerView()
            picker.delegate = self
            picker.dataSource = self
            currentarr = spacearr
            var selectedindex = 0
            for i in 0..<currentarr.count{
                var s = currentarr.objectAtIndex(i) as! String
                if(cell.valuetxtfld.text == s){
                    selectedindex = i
                    break
                }
            }
            picker.selectRow(selectedindex, inComponent: 0, animated: true)
            picker.reloadAllComponents()
            picker.tag = 1000+indexPath.section
            cell.valuetxtfld.inputView = picker
        }
        
        cell.valuetxtfld.becomeFirstResponder()

    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Selected row ",indexPath.section)
        print(titlearr[indexPath.section])
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! manageprojectcell
        if(indexPath.section == 17 || indexPath.section == 16 || indexPath.section == 15 || indexPath.section == 13 || indexPath.section == 20){
            
            
            
        }else if(indexPath.section == 18){
            var formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy"
            var dte = NSDate()
            var str = formatter.stringFromDate(dte)
            var year = Int(str)!
            print(year)
            var yearsarr = NSMutableArray()
            var selectedindex = 0
            for i in 0..<25 {
                yearsarr.addObject(year-i)
                if(cell.valuetxtfld.text?.characters.count>0){
                    var s = String(format: "%d",year-i)
                    if(cell.valuetxtfld.text == s){
                        selectedindex = i
                    }
                }
            }
            var picker = UIPickerView()
            picker.delegate = self
            picker.dataSource = self
            currentarr = yearsarr
            picker.tag = 1000+indexPath.section
            cell.valuetxtfld.inputView = picker
            picker.selectRow(selectedindex, inComponent: 0, animated: true)
            picker.reloadAllComponents()
            cell.valuetxtfld.becomeFirstResponder()
        }else if(indexPath.section == 14){
            var picker = UIPickerView()
            picker.delegate = self
            picker.dataSource = self
            currentarr = pursedcertarr
            picker.reloadAllComponents()
            var selectedindex = 0
            for i in 0..<pursedcertarr.count{
                var s = pursedcertarr.objectAtIndex(i) as! String
                if(cell.valuetxtfld.text == s){
                    selectedindex = i
                    break
                }
            }
            picker.tag = 1000+indexPath.section
            cell.valuetxtfld.inputView = picker
            cell.valuetxtfld.becomeFirstResponder()
        }else if(indexPath.section == 22){
            var picker = UIDatePicker()
            picker.datePickerMode = UIDatePickerMode.Date
            picker.tag = 1000+indexPath.section
            cell.valuetxtfld.inputView = picker
            if(cell.valuetxtfld.text?.characters.count > 0){
                var s = cell.valuetxtfld.text!
                var formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                var date = formatter.dateFromString(s)
                picker.date = date!
            }
            picker.addTarget(self, action: #selector(self.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
             cell.valuetxtfld.becomeFirstResponder()
        }
            else if(indexPath.section == 18 || indexPath.section == 21 || indexPath.section == 23 || indexPath.section == 24){
                //cell.valuetxtfld.inputView = nil
                //cell.valuetxtfld.reloadInputViews()
            cell.valuetxtfld.becomeFirstResponder()
            }
        
        
        
        
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var textfld = self.view.viewWithTag(sender.tag-1000) as! UITextField
        textfld.text = dateFormatter.stringFromDate(sender.date)
        listarr.replaceObjectAtIndex(sender.tag-1000, withObject: textfld.text!)
        textfld.resignFirstResponder()
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var textfld = self.view.viewWithTag(pickerView.tag-1000) as! UITextField
        if(currentarr[row] is String){
        textfld.text = currentarr[row] as? String
        }else{
            textfld.text = String(format:"%d",currentarr[row] as! Int)
        }
        textfld.resignFirstResponder()
    }
    

    @IBAction func saveproject(sender: AnyObject) {
        //{"name":"Test Auth","street":"2101 L Street NW","city":"Test city","state":"DC","country":"US","year_constructed":null,"gross_area":10000,"operating_hours":null,"occupancy":null,"confidential":false,"organization":null,"ownerType":null,"IsLovRecert":false,"PrevCertProdId":null,"OtherCertProg":null,"IsResidential":false,"noOfResUnits":null,"AffiliatedHigherEduIns":false,"nameOfSchool":null,"noOfFloors":null,"intentToPrecertify":false,"targetCertDate":null,"populationDayTime":null,"populationNightTime":null,"manageEntityName":null,"manageEntityAdd1":null,"managEntityAdd2":null,"manageEntityCity":null,"manageEntityState":null,"manageEntityCountry":null,"unitType":"IP"}
        
        
        dispatch_async(dispatch_get_main_queue(), {
            self.spinner.hidden = false
            self.view.userInteractionEnabled = false
        })
        
        print(data_dict)
        var payload = NSMutableString()
        payload.appendString("{")
        
        
        for (key, value) in data_dict {
            if(value is String){
                payload.appendString("\"\(key)\": \"\(value)\",")
            }else if(value is Int){
            payload.appendString("\"\(key)\": \(value),")
            }
        }
        var str = payload as! String
        payload.deleteCharactersInRange(NSMakeRange(str.characters.count-1, 1))
        payload.appendString("}")
        str = payload as! String
        print(str)


        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/?recompute_score=1",credentials().domain_url, leedid))
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
        
        var task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            
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
                            self.spinner.hidden = true
                            self.view.userInteractionEnabled = true
                        self.updateproject()
                        
                    })
                } catch {
                    print(error)
                }
            }
            
        }
        task.resume()
    }
    
    
    func updateproject(){
        let url = NSURL.init(string:String(format: "%@assets/LEED:%d/",credentials().domain_url,leedid))
        print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token!), forHTTPHeaderField:"Authorization" )
        var task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                return
            }
            
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
                    var datakeyed = NSKeyedArchiver.archivedDataWithRootObject(jsonDictionary)
                    NSUserDefaults.standardUserDefaults().setObject(datakeyed, forKey: "building_details")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "row")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.spinner.hidden = true
                        self.view.userInteractionEnabled = true
                    })
                    //self.tableview.reloadData()
                    // self.buildingactions(subscription_key, leedid: leedid)
                } catch {
                    print(error)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.spinner.hidden = true
                        self.view.userInteractionEnabled = true
                    })
                }
            }
            
        }
        task.resume()
        
    }

    
    
    
    

}
