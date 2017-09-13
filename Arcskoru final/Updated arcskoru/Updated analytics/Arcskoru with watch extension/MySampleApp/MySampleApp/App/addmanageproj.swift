//
//  manageproj.swift
//  Arcskoru
//
//  Created by Group X on 07/02/17.
//
//

import UIKit

class addmanageproj: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate {
    var titlearr = NSArray()
    var state = ""
    var pickerarr = NSArray()
    var selectedvalue = ""
    var name = ""
    var currentcontext = ""
    var download_requests = [URLSession]()
    
    @IBOutlet weak var tabbar: UITabBar!
    override func viewDidAppear(_ animated: Bool) {
        token = UserDefaults.standard.object(forKey: "token") as! String
        self.navigationController?.navigationBar.backItem?.title = "Manage project"
    }
    var data_dict = NSMutableDictionary()
    var leedid = UserDefaults.standard.integer(forKey: "leed_id")
    var listarr = ["","","","","","","","","","","","","","","","","","","","","","","","",""] 
    var unitarr = ["SI","IP"]
    var sectionarr = NSArray()
    var spacearr = ["Circulation space","Core learning space:College/University","Core learning space:K-12 Elementary/Middle school","Core learning space: K-12 High school","Core learning space:Other classroom education","Core learning space:Preschool/Daycare","Data Center","Healthcare: Clinic/Other outpatient","Healthcare:Inpatient","Healthcare:Nursing Home/Assisted living","Healthcare: Outpatient office(diagnostic)","Industrial manufacturing","Laboratory","Lodging: Dormitory","Lodging: Hotel/Motel/Report, Full service","Lodging: Hotel/Motel/Report, Limited service","Lodging: Hotel/Motel/Report, Select service","Lodging: Inn","Lodging: Other lodging","Multifamily residential: Apartment","Multifamily residential: Condomninum","Multifamily residential: Lowrise","Office: Administrative/Professional","Office: Financial","Office: Government","Office: Medical(non-diagnostic)","Office: Mixed use","Office: Other office","Public assembly: Convention Center","Public assembly: Recreation","Public assembly: Social/Meeting","Public assembly:Stadium/Arena","Public Order and safety:Fire/Police station","Public order and safety: Other public order","Religious worship","Retail: Bank branch","Retail: Convenience","Retail:Enclosed Mall","Fast Food","Grocery store/Food market","Retail: Open shopping center","Retail: Other Retail","Retail: Restaurant/cafeteria","Retail: Vehicle dealership","Service: Other service","Service: Post office/postal center","Service: Repair shop","Service: Vehicle service/repair","Service: Vehicle storage/maintanance","Single family home(attached)","Single family home(detached)","Warehouse: Nonrefridgerated distribution/shipping","Warehouse: Refridgerated","Warehouse: Self storage units","Warehouse:General","Other"]
    var currentarr = NSArray()
    var country = ""
    var titledict = NSDictionary()
    var pursedcertarr = NSArray()
    var yesorno = ["Yes","No"] 
    var token = UserDefaults.standard.object(forKey: "token") as? String
    var dict = NSDictionary()
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
        self.spinner.layer.cornerRadius = 5
        self.spinner.isHidden = true
        pursedcertarr = ["WELL","Sustainable SITES", "PEER","Parksmart","GRESB","EDGE","Green Star","DGNB","BREEAM","Zero Waste","ENERGY STAR","Beam","CASBEE","Green Mark","Pearl","Other"]
        //titlearr = NSArray()
        sectionarr = ["Building details","Certification details","Other building details"]
        titledict = [0:["Name","Project ID","Unit Type","Space Type","Address","City","State","Country","Private","Owner type","Owner organization","Owner Email","Owner country"],
                     
                     1:["Previously LEED Certified?","Other certification programs pursued","Contains residential units?","Project affiliated?","Is project affiliated with a LEED Lab?"],
                     2:["Year built","Floors above grounds","Intend to precertify?","Gross floor area(square foot)","Target certification date","Operating hours","Occupancy"]
        ]
        
        //print("DDX",(titledict[0] as AnyObject).count,(titledict[1] as AnyObject).count,(titledict[2] as AnyObject).count)
        //Is project affiliated with a higher education institute?
        tableview.register(UINib.init(nibName: "manageprojcellwithswitch", bundle: nil), forCellReuseIdentifier: "manageprojcellwithswitch")
        tableview.register(UINib.init(nibName: "manageprojcell", bundle: nil), forCellReuseIdentifier: "manageprojcell")
        data_dict = (dict.mutableCopy() as! NSDictionary).mutableCopy() as! NSMutableDictionary
        //print(data_dict)
        var countries = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "countries") as! Data) as! NSDictionary
        // Do any additional setup after loading the view.
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.title == "Score"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"plaque"])
            NotificationCenter.default.post(name: Notification.Name(rawValue: "performrootsegue"), object: nil, userInfo: ["seguename":"plaque"])
        }else if(item.title == "Analytics"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"beforeanalytics"])
            NotificationCenter.default.post(name: Notification.Name(rawValue: "performrootsegue"), object: nil, userInfo: ["seguename":"totalanalysis"])
        }else if(item.title == "Manage"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"manage"])
            NotificationCenter.default.post(name: Notification.Name(rawValue: "performrootsegue"), object: nil, userInfo: ["seguename":"manage"])
        }else if(item.title == "More"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"more"])
            NotificationCenter.default.post(name: Notification.Name(rawValue: "performrootsegue"), object: nil, userInfo: ["seguename":"more"])
        }else if(item.title == "Credits/Actions"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"listofactions"])
            NotificationCenter.default.post(name: Notification.Name(rawValue: "performrootsegue"), object: nil, userInfo: ["seguename":"listofactions"])
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionarr.count
    }
    
    
    func back(_ sender:UIBarButtonItem){
        NotificationCenter.default.post(name: Notification.Name(rawValue: "performsegue"), object: nil, userInfo: ["seguename":"manage"])
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionarr.object(at: section) as! String
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let temp = titledict[section] as! NSArray
        return temp.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let temp = titledict[indexPath.section] as! NSArray
        if(indexPath.section == 0 && indexPath.row == 0){
            name = (data_dict["name"] as? String)!
            currentcontext = temp.object(at: indexPath.row) as! String
            self.performSegue(withIdentifier: "editname", sender: nil)
        }else if(indexPath.section == 0 && indexPath.row == 2){
            currentcontext = temp.object(at: indexPath.row) as! String
            pickerarr = unitarr as NSArray
            self.performSegue(withIdentifier: "gotolist", sender: nil)
        }else if(indexPath.section == 0 && indexPath.row == 3){
            currentcontext = temp.object(at: indexPath.row) as! String
            pickerarr = spacearr as NSArray
            self.performSegue(withIdentifier: "gotolist", sender: nil)
        }
        else if(indexPath.section == 1 && indexPath.row == 0){
            currentcontext = temp.object(at: indexPath.row) as! String
            pickerarr = spacearr as NSArray
            if let s = data_dict["PrevCertProdId"] as? String{
                selectedvalue = s
            }
            self.performSegue(withIdentifier: "gotoenableandfill", sender: nil)
        }else if(indexPath.section == 1 && indexPath.row == 1){
            currentcontext = temp.object(at: indexPath.row) as! String
            pickerarr = pursedcertarr as NSArray
            self.performSegue(withIdentifier: "gotolist", sender: nil)
        }else if(indexPath.section == 1 && indexPath.row == 2){
            currentcontext = temp.object(at: indexPath.row) as! String
            pickerarr = pursedcertarr as NSArray
            if let s = data_dict["noOfResUnits"] as? String{
                selectedvalue = s
            }
            self.performSegue(withIdentifier: "gotoenableandfill", sender: nil)
        }else if(indexPath.section == 1 && indexPath.row == 3){
            currentcontext = temp.object(at: indexPath.row) as! String
            pickerarr = pursedcertarr as NSArray
            if let s = data_dict["nameOfSchool"] as? String{
                selectedvalue = s
            }
            self.performSegue(withIdentifier: "gotoenableandfill", sender: nil)
        }else if(indexPath.section == 2 && indexPath.row == 0){
            currentcontext = temp.object(at: indexPath.row) as! String
            pickerarr = pursedcertarr as NSArray
            if let s = data_dict["year_constructed"] as? Int{
                selectedvalue = "\(s)"
            }else{
                selectedvalue = ""
            }
            self.performSegue(withIdentifier: "gotoselectedvalue", sender: nil)
        }else if(indexPath.section == 2 && indexPath.row == 1){
            currentcontext = temp.object(at: indexPath.row) as! String
            pickerarr = pursedcertarr as NSArray
            if let s = data_dict["noOfFloors"] as? Int{
                selectedvalue = "\(s)"
            }else{
                selectedvalue = ""
            }
            self.performSegue(withIdentifier: "gotoselectedvalue", sender: nil)
        }else if(indexPath.section == 2 && indexPath.row == 3){
            currentcontext = temp.object(at: indexPath.row) as! String
            pickerarr = pursedcertarr as NSArray
            if let s = data_dict["gross_area"] as? Int{
                selectedvalue = "\(s)"
            }else{
                selectedvalue = ""
            }
            self.performSegue(withIdentifier: "editname", sender: nil)
        }else if(indexPath.section == 2 && indexPath.row == 4){
            currentcontext = temp.object(at: indexPath.row) as! String
            pickerarr = pursedcertarr as NSArray
            if(data_dict["targetCertDate"] is NSNull || data_dict["targetCertDate"] as? String == ""){
                //cell.valuetxtfld.text = ""
                selectedvalue = ""
            }else{
                selectedvalue =  data_dict["targetCertDate"] as! String
            }
            self.performSegue(withIdentifier: "gotodatechooser", sender: nil)
        }else if(indexPath.section == 2 && indexPath.row == 6){
            currentcontext = temp.object(at: indexPath.row) as! String
            pickerarr = pursedcertarr as NSArray
            
            currentcontext = temp.object(at: indexPath.row) as! String
            pickerarr = pursedcertarr as NSArray
            if let s = data_dict["gross_area"] as? Int{
                selectedvalue = "\(s)"
            }else{
                selectedvalue = ""
            }
            if(data_dict["occupancy"] is NSNull || data_dict["occupancy"] as? String == ""){
                selectedvalue = ""
            }else{
                if(data_dict["occupancy"] != nil){
                selectedvalue = String(format:"%d",data_dict["occupancy"] as! Int)
                }
            }
            self.performSegue(withIdentifier: "editname", sender: nil)
        }
        
        
        //gotodatechooser
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editname"){
            let v = segue.destination as! nameedit
            if(currentcontext == "Name"){
                v.name = name
            }else if(currentcontext == "Occupancy"){
                v.name = selectedvalue
            }else{
                v.name = selectedvalue
            }
            v.data_dict = data_dict
            v.currenttitle = currentcontext
        }else if(segue.identifier == "gotolist"){
            let v = segue.destination as! choosefromlist
            //print(data_dict)
            v.data_dict = data_dict
            v.currentcontext = currentcontext
            v.pickerarr = pickerarr
        }else if(segue.identifier == "gotoenableandfill"){
            let v = segue.destination as! enableandfillViewController
            v.data_dict = data_dict
            if(currentcontext == "Yes"){
                v.enabled = true
            }else{
                v.enabled = false
            }
            v.context = currentcontext
            v.prodid = selectedvalue
            
        }else if(segue.identifier == "gotoselectedvalue"){
            let v = segue.destination as! selectvalue
            v.data_dict = data_dict
            if(currentcontext == "Year built"){
                if let s = data_dict["year_constructed"] as? Int{
                    v.currentvalue = "\(s)"
                }else{
                    v.currentvalue = ""
                }
                v.PICKER_MIN = 1900
                v.currenttitle = currentcontext
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy"
                let date = formatter.string(from: Date())
                v.PICKER_MAX = Int(date as String)!
            }
            if(currentcontext == "Floors above grounds"){
                if let s = data_dict["noOfFloors"] as? Int{
                    v.currentvalue = "\(s)"
                }else{
                    v.currentvalue = ""
                }
                v.PICKER_MIN = 0
                v.currenttitle = currentcontext
                v.PICKER_MAX = 200
            }
            
        }else if(segue.identifier == "gotodatechooser"){
            let v = segue.destination as! datechoose
            v.data_dict = data_dict
            v.context = currentcontext
            if(currentcontext == "Target certification date"){
                if(selectedvalue == ""){
                    let datef = DateFormatter()
                    datef.dateFormat = "yyyy-MM-dd"
                    let d = datef.string(from: Date())
                    v.currentdate = datef.date(from: d)!
                }else{
                    let datef = DateFormatter()
                    datef.dateFormat = "yyyy-MM-dd"
                    let d = datef.date(from: data_dict["targetCertDate"] as! String)
                    v.currentdate = d!
                }
                let datef = DateFormatter()
                datef.dateFormat = "yyyy-MM-dd"
                let d = datef.date(from: "1900-01-01")
                v.startdate = d!
                datef.dateFormat = "yyyy-MM-dd"
                let e = datef.string(from: Date())
                v.enddate = datef.date(from: e)!
                v.data_dict = data_dict
            }
            
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data_dict = dict.mutableCopy() as! NSMutableDictionary
        tableview.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "manageprojcell") as! manageprojcell
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        //cell.titlelbl.text = titlearr.objectAtIndex(indexPath.row) as? String
        //cell.selectionStyle = UITableViewCellSelectionStyle.None
        ////cell.valuetxtfld.tag = indexPath.row
        cell.contentView.alpha = 1
        ////cell.valuetxtfld.placeholder = ""
        var temp = titledict[indexPath.section] as! NSArray
        cell.textLabel!.text = temp.object(at: indexPath.row) as! String
        if(indexPath.section == 0){
            if(indexPath.row == 0){
                if(dict["name"] != nil){
                cell.detailTextLabel!.text = data_dict["name"] as? String
                }
            }else if(indexPath.row == 1){
                ////cell.valuetxtfld.enabled = false
                if(dict["leed_id"] != nil){
                cell.detailTextLabel!.text = String(format: "%d",dict["leed_id"] as! Int)
                //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
                cell.accessoryType = UITableViewCellAccessoryType.none
                }
            }else if(indexPath.row == 2){
                if(dict["leed_id"] != nil){
                cell.detailTextLabel!.text = data_dict["unitType"] as? String
                //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
                }
            }else if(indexPath.row == 3){
                //cell.valuetxtfld.keyboardType = UIKeyboardType.Alphabet
                cell.detailTextLabel!.text = data_dict["spaceType"] as? String
                //listarr.replaceObjectAtIndex(indexPath.row, withObject:cell.detailTextLabel!.text!)
                //cell.valuetxtfld.userInteractionEnabled = false
            }else if(indexPath.row == 4){
                //cell.valuetxtfld.keyboardType = UIKeyboardType.Default
                cell.detailTextLabel!.text = data_dict["street"] as? String
                //listarr.replaceObjectAtIndex(indexPath.row, withObject:cell.detailTextLabel!.text!)
                cell.accessoryType = UITableViewCellAccessoryType.none
                //cell.valuetxtfld.userInteractionEnabled = false
            }else if(indexPath.row == 5){
                //cell.valuetxtfld.keyboardType = UIKeyboardType.Alphabet
                cell.detailTextLabel!.text = data_dict["city"] as? String
                //listarr.replaceObjectAtIndex(indexPath.row, withObject:cell.detailTextLabel!.text!)
                cell.accessoryType = UITableViewCellAccessoryType.none
                //cell.valuetxtfld.userInteractionEnabled = false
            }else if(indexPath.row == 6){
                //cell.valuetxtfld.keyboardType = UIKeyboardType.Alphabet
                cell.detailTextLabel!.text = state
                //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
                cell.accessoryType = UITableViewCellAccessoryType.none
                //cell.valuetxtfld.userInteractionEnabled = false
            }else if(indexPath.row == 7){
                //cell.valuetxtfld.keyboardType = UIKeyboardType.Alphabet
                cell.detailTextLabel!.text = country
                //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
                cell.accessoryType = UITableViewCellAccessoryType.none
                //cell.valuetxtfld.userInteractionEnabled = false
            }else if(indexPath.row == 8){
                var cell = tableview.dequeueReusableCell(withIdentifier: "manageprojcellwithswitch")! as! manageprojcellwithswitch
                if(data_dict["confidential"] != nil){
                cell.yesorno.isOn = Bool(data_dict["confidential"] as! NSNumber)
                }
                cell.yesorno.addTarget(self, action: #selector(self.plaquepublic(_:)), for: UIControlEvents.valueChanged)
                //cell.valuetxtfld.keyboardType = UIKeyboardType.Default
                //print(data_dict["confidential"])
                //cell.valuetxtfld.userInteractionEnabled = false
                //listarr.replaceObjectAtIndex(indexPath.row, withObject: "\(data_dict["confidential"] as! Int)")
                cell.lbl!.text = temp.object(at: indexPath.row) as! String
                cell.accessoryType = UITableViewCellAccessoryType.none
                return cell
            }else if(indexPath.row == 9){
                cell.accessoryType = UITableViewCellAccessoryType.none
                cell.detailTextLabel!.text = data_dict["ownerType"] as? String
                //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
            }else if(indexPath.row == 10){
                cell.accessoryType = UITableViewCellAccessoryType.none
                cell.detailTextLabel!.text = data_dict["organization"] as? String
                //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
            }else if(indexPath.row == 11){
                cell.accessoryType = UITableViewCellAccessoryType.none
                cell.detailTextLabel!.text = data_dict["owner_email"] as? String
                //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
            }
            else if(indexPath.row == 12){
                cell.accessoryType = UITableViewCellAccessoryType.none
                cell.detailTextLabel!.text = country
                //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
            }
        }
        if(indexPath.section == 1){
            if(indexPath.row == 0){
                cell.isUserInteractionEnabled = true
                if(data_dict["ldp_old"] is NSNull){
                    cell.detailTextLabel?.text = "No"
                    //cell.yesnoswitch.on = false
                    //cell.valuetxtfld.text = ""
                }else{
                    if(data_dict["ldp_old"] != nil){
                    if(data_dict["ldp_old"] as! Int == 1){
                        //cell.valuetxtfld.placeholder = "Enter your previous LEED ID"
                        //cell.yesnoswitch.on = Bool(data_dict["ldp_old"] as! NSNumber)
                        if let s = data_dict["PrevCertProdId"] as? String{
                            //cell.valuetxtfld.text = s
                            cell.detailTextLabel?.text = s
                        }else{
                            //cell.valuetxtfld.text = ""
                            cell.detailTextLabel?.text = "Not available"
                        }
                        ////cell.valuetxtfld.enabled = true
                    }else{
                        cell.detailTextLabel?.text = "No"
                        //cell.yesnoswitch.on = false
                        ////cell.valuetxtfld.enabled = false
                        //cell.valuetxtfld.text = ""
                    }
                    }
                }
                
                //cell.yesnoswitch.hidden = false
                //cell.yesnoswitch.tag = 100+indexPath.row
                //cell.yesnoswitch.addTarget(self, action: #selector(manageproject.switchused(_:)), forControlEvents:UIControlEvents.ValueChanged)
                //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
            }else if(indexPath.row == 1){
                cell.isUserInteractionEnabled = true
                ////cell.valuetxtfld.enabled = true
                //cell.yesnoswitch.hidden = true
                if(data_dict["OtherCertProg"] is NSNull){
                    cell.detailTextLabel!.text = "None"
                }else{
                    if(data_dict["OtherCertProg"] != nil){
                        cell.detailTextLabel!.text = data_dict["OtherCertProg"] as! String
                    }else{
                        cell.detailTextLabel!.text = "None"
                    }
                }
                //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
            }else if(indexPath.row == 2){
                cell.isUserInteractionEnabled = true
                if(data_dict["IsResidential"] != nil){
                if(data_dict["IsResidential"] as! Int == 0){
                    ////cell.valuetxtfld.enabled = false
                    //cell.yesnoswitch.on = Bool(data_dict["IsResidential"] as! NSNumber)
                    //cell.valuetxtfld.text = ""
                    cell.detailTextLabel?.text = "No"
                }else{
                    //cell.yesnoswitch.on = Bool(data_dict["IsResidential"] as! NSNumber)
                    ////cell.valuetxtfld.enabled = true
                    cell.detailTextLabel?.text = "Yes"
                }
                }
                //cell.yesnoswitch.hidden = false
                //cell.yesnoswitch.tag = 100+indexPath.row
                //cell.yesnoswitch.addTarget(self, action: "switchused:", forControlEvents:UIControlEvents.ValueChanged)
            }else if(indexPath.row == 3){
                cell.isUserInteractionEnabled = true
                ////cell.valuetxtfld.enabled = true
                //nameOfSchool
                if(data_dict["AffiliatedHigherEduIns"] != nil){
                if(data_dict["AffiliatedHigherEduIns"] as! Int == 0){
                    cell.detailTextLabel?.text = "No"
                    ////cell.valuetxtfld.enabled = false
                    //cell.yesnoswitch.on = Bool(data_dict["AffiliatedHigherEduIns"] as! NSNumber)
                    //cell.valuetxtfld.text = ""
                }else{
                    //cell.yesnoswitch.on = Bool(data_dict["AffiliatedHigherEduIns"] as! NSNumber)
                    ////cell.valuetxtfld.enabled = true
                    cell.detailTextLabel?.text = "Yes"
                    if(data_dict["nameOfSchool"] != nil){
                        
                        //cell.valuetxtfld.placeholder = "Name of school"
                        //cell.valuetxtfld.text = data_dict["nameOfSchool"] as! String
                    }
                }
                }
                //cell.yesnoswitch.hidden = false
                //cell.yesnoswitch.tag = 100+indexPath.row
                //cell.yesnoswitch.addTarget(self, action: "switchused:", forControlEvents:UIControlEvents.ValueChanged)
                //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
            }else if(indexPath.row == 4){
                var cell = tableview.dequeueReusableCell(withIdentifier: "manageprojcellwithswitch")! as! manageprojcellwithswitch
                cell.yesorno.addTarget(self, action: #selector(self.affleedlab(_:)), for: UIControlEvents.valueChanged)
                //cell.valuetxtfld.keyboardType = UIKeyboardType.Default
                //print(data_dict["confidential"])
                //cell.valuetxtfld.userInteractionEnabled = false
                cell.lbl!.text = temp.object(at: indexPath.row) as! String
                cell.accessoryType = UITableViewCellAccessoryType.none
                ////cell.valuetxtfld.enabled = false
                //cell.valuetxtfld.text = ""
                if(data_dict["affiliatedWithLeedLab"] is NSNull){
                    cell.yesorno.isOn = false
                }else{
                    if(data_dict["affiliatedWithLeedLab"] != nil){
                        cell.yesorno.isOn = Bool(data_dict["confidential"] as! NSNumber)
                        //cell.yesnoswitch.on = Bool(data_dict["affiliatedWithLeedLab"] as! NSNumber)
                    }
                    //cell.yesnoswitch.hidden = false
                    //cell.yesnoswitch.tag = 100+indexPath.row
                    //cell.yesnoswitch.addTarget(self, action: "switchused:", forControlEvents:UIControlEvents.ValueChanged)
                }
                return cell
                
            }
        }
        if(indexPath.section == 2){
            if(indexPath.row == 0){
                cell.isUserInteractionEnabled = true
                ////cell.valuetxtfld.enabled = true
                if(data_dict["year_constructed"] is NSNull || data_dict["year_constructed"] as? String == "" || data_dict["year_constructed"] == nil){
                    //cell.valuetxtfld.text = ""
                    cell.detailTextLabel?.text = "Not available"
                }else{
                    //cell.valuetxtfld.text = String(format:"%d",data_dict["year_constructed"] as! Int)
                    cell.detailTextLabel?.text = "\(data_dict["year_constructed"]!)"
                    
                }
                //cell.yesnoswitch.hidden = true
            }else if(indexPath.row == 1){
                cell.isUserInteractionEnabled = true
                ////cell.valuetxtfld.enabled = true
                if(data_dict["noOfFloors"] is NSNull || data_dict["noOfFloors"] as? String == ""){
                    //cell.valuetxtfld.text = ""
                    cell.detailTextLabel?.text = "Not available"
                }else{
                    if(data_dict["noOfFloors"] != nil){
                    cell.detailTextLabel?.text = "\(data_dict["noOfFloors"]!)"
                    }
                    //cell.valuetxtfld.text = String(format:"%d",data_dict["noOfFloors"] as! Int)
                }
                //cell.yesnoswitch.hidden = true
                //cell.valuetxtfld.keyboardType = UIKeyboardType.NumberPad
                //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
            }else if(indexPath.row == 2){
                var cell = tableview.dequeueReusableCell(withIdentifier: "manageprojcellwithswitch")! as! manageprojcellwithswitch
                cell.yesorno.addTarget(self, action: #selector(self.intentedtocert(_:)), for: UIControlEvents.valueChanged)
                //cell.valuetxtfld.keyboardType = UIKeyboardType.Default
                //print(data_dict["confidential"])
                //cell.valuetxtfld.userInteractionEnabled = false
                cell.lbl!.text = temp.object(at: indexPath.row) as! String
                cell.accessoryType = UITableViewCellAccessoryType.none
                ////cell.valuetxtfld.enabled = false
                //cell.valuetxtfld.text = ""
                if(data_dict["intentToPrecertify"] is NSNull){
                    cell.yesorno.isOn = false
                }else{
                    if(data_dict["intentToPrecertify"] != nil){
                        cell.yesorno.isOn = Bool(data_dict["intentToPrecertify"] as! NSNumber)
                        //cell.yesnoswitch.on = Bool(data_dict["affiliatedWithLeedLab"] as! NSNumber)
                    }
                    //cell.yesnoswitch.hidden = false
                    //cell.yesnoswitch.tag = 100+indexPath.row
                    //cell.yesnoswitch.addTarget(self, action: "switchused:", forControlEvents:UIControlEvents.ValueChanged)
                }
                return cell
                
                
                //cell.yesnoswitch.hidden = false
                //cell.yesnoswitch.tag = 100+indexPath.row
                //cell.yesnoswitch.addTarget(self, action: "switchused:", forControlEvents:UIControlEvents.ValueChanged)
            }else if(indexPath.row == 3){
                cell.isUserInteractionEnabled = true
                if(data_dict["gross_area"] is NSNull || data_dict["gross_area"] as? String == ""){
                    //cell.valuetxtfld.text = ""
                    cell.detailTextLabel?.text = "Not available"
                }else{
                    if(data_dict["gross_area"] != nil){
                    cell.detailTextLabel?.text = "\(data_dict["gross_area"]!)"
                    }
                    //cell.valuetxtfld.text = String(format:"%d",data_dict["noOfFloors"] as! Int)
                }
                ////cell.valuetxtfld.enabled = true
                //cell.valuetxtfld.text = String(format:"%d",data_dict["gross_area"] as! Int)
                //cell.valuetxtfld.keyboardType = UIKeyboardType.NumberPad
                //cell.yesnoswitch.hidden = true
            }else if(indexPath.row == 4){
                cell.isUserInteractionEnabled = true
                ////cell.valuetxtfld.enabled = true
                if(data_dict["targetCertDate"] is NSNull || data_dict["targetCertDate"] as? String == ""){
                    //cell.valuetxtfld.text = ""
                    cell.detailTextLabel?.text = "Not available"
                }else{
                    if(data_dict["targetCertDate"] != nil){
                    let dateFormatter: DateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    var dt = dateFormatter.date(from: data_dict["targetCertDate"] as! String)
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    //print(dateFormatter.string(from: dt!))
                    var str = dateFormatter.string(from: dt!)
                    cell.detailTextLabel?.text = str
                    }
                    //cell.valuetxtfld.text = String(format:"%@",data_dict["targetCertDate"] as! String)
                }
                //cell.yesnoswitch.hidden = true
                //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
            }else if(indexPath.row == 5){
                cell.accessoryType = UITableViewCellAccessoryType.none
                ////cell.valuetxtfld.enabled = true
                if(data_dict["operating_hours"] is NSNull || data_dict["operating_hours"] as? String == ""){
                    //cell.valuetxtfld.text = ""
                    cell.detailTextLabel?.text = "Not available"
                    
                }else{
                    if(data_dict["operating_hours"] != nil){
                    cell.detailTextLabel?.text = String(format:"%d",data_dict["operating_hours"] as! Int)
                    }
                }
                //cell.yesnoswitch.hidden = true
                //cell.valuetxtfld.keyboardType = UIKeyboardType.NumberPad
                //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
            }else if(indexPath.row == 6){
                cell.isUserInteractionEnabled = true
                ////cell.valuetxtfld.enabled = true
                if(data_dict["occupancy"] is NSNull || data_dict["occupancy"] as? String == ""){
                    cell.detailTextLabel?.text = "Not available"
                }else{
                    //cell.valuetxtfld.text = String(format:"%d",data_dict["occupancy"] as! Int)
                    if(data_dict["occupancy"] != nil){
                    cell.detailTextLabel?.text = String(format:"%d",data_dict["occupancy"] as! Int)
                    }
                }
                //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
                //cell.yesnoswitch.hidden = true
                //cell.valuetxtfld.keyboardType = UIKeyboardType.NumberPad
                
            }
        }
        /*if(//cell.yesnoswitch.hidden == true){
         //cell.valuetxtfld.frame.size.width = 0.95 * abs(cell.contentView.frame.size.width - //cell.valuetxtfld.frame.origin.x)
         //cell.valuetxtfld.backgroundColor = UIColor.clearColor()
         }else{
         //cell.valuetxtfld.frame.size.width = 0.5 * //cell.yesnoswitch.frame.origin.x
         
         //cell.valuetxtfld.backgroundColor = UIColor.clearColor()
         }*/
        
        //cell.valuetxtfld.backgroundColor = UIColor.lightGrayColor()
        
        return cell
        
    }
    
    @IBAction func saveproject(_ selected: Int) {
        
        
        
        DispatchQueue.main.async(execute: {
            self.spinner.isHidden = false
            self.view.isUserInteractionEnabled = false
        })
        
        //print(data_dict)
        var payload = NSMutableString()
        payload.append("{")
        
        
        for (key, value) in data_dict {
            if(value is String){
                payload.append("\"\(key)\": \"\(value)\",")
            }else if(value is Int){
                payload.append("\"\(key)\": \(value),")
            }
        }
        var str = payload as String
        payload.deleteCharacters(in: NSMakeRange(str.characters.count-1, 1))
        payload.append("}")
        str = payload as String
        //print(str)
        
        
        let url = URL.init(string:String(format: "%@assets/LEED:%d/?recompute_score=1",credentials().domain_url, leedid))
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
                            self.updateproject()
                        })
                    } catch {
                        //print(error)
                    }
            }
            
        }) 
        task.resume()
    }
    
    
    func updateproject(){
        let url = URL.init(string:String(format: "%@assets/LEED:%d/",credentials().domain_url,leedid))
        ////print(url?.absoluteURL)
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "GET"
        request.addValue(credentials().subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token!), forHTTPHeaderField:"Authorization" )
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
                        var datakeyed = NSKeyedArchiver.archivedData(withRootObject: jsonDictionary)
                        UserDefaults.standard.set(datakeyed, forKey: "building_details")
                        UserDefaults.standard.synchronize()
                        UserDefaults.standard.set(0, forKey: "row")
                        DispatchQueue.main.async(execute: {
                            self.spinner.isHidden = true
                            self.view.isUserInteractionEnabled = true
                        })
                        //self.tableview.reloadData()
                        // self.buildingactions(subscription_key, leedid: leedid)
                    } catch {
                        //print(error)
                        DispatchQueue.main.async(execute: {
                            self.spinner.isHidden = true
                            self.view.isUserInteractionEnabled = true
                        })
                    }
            }
            
        }) 
        task.resume()
        
    }
    
    @IBOutlet weak var spinner: UIView!
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
    func intentedtocert(_ sender: UISwitch){
        if(sender.isOn){
            data_dict["intentToPrecertify"] = 1
        }else{
            data_dict["intentToPrecertify"] = 0
        }
        DispatchQueue.main.async(execute: {
            self.spinner.isHidden = false
            self.saveproject(0)
        })
        
    }
    
    func plaquepublic(_ sender: UISwitch){
        if(sender.isOn){
            data_dict["confidential"] = 1
        }else{
            data_dict["confidential"] = 0
        }
        DispatchQueue.main.async(execute: {
            self.spinner.isHidden = false
            self.saveproject(0)
        })
        
    }
    
    func affleedlab(_ sender: UISwitch){
        if(sender.isOn){
            data_dict["affiliatedWithLeedLab"] = 1
        }else{
            data_dict["affiliatedWithLeedLab"] = 0
        }
        DispatchQueue.main.async(execute: {
            self.spinner.isHidden = false
            self.saveproject(0)
        })
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return 60
        if(UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height){
            return 0.081 * UIScreen.main.bounds.size.height;
        }
        return 0.081 * UIScreen.main.bounds.size.width;
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
    
}
