//
//  manageproj.swift
//  Arcskoru
//
//  Created by Group X on 07/02/17.
//
//

import UIKit

class manageproj: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate {
    var titlearr = NSArray()
    var state = ""
    var pickerarr = NSArray()
    var selectedvalue = ""
    var name = ""
    var currentcontext = ""
    var download_requests = [NSURLSession]()
    
    @IBOutlet weak var tabbar: UITabBar!
    
    var data_dict = NSMutableDictionary()
    var leedid = NSUserDefaults.standardUserDefaults().integerForKey("leed_id")
    var unitarr = ["SI","IP"]
    var sectionarr = []
    var spacearr = ["Circulation space","Core learning space:College/University","Core learning space:K-12 Elementary/Middle school","Core learning space: K-12 High school","Core learning space:Other classroom education","Core learning space:Preschool/Daycare","Data Center","Healthcare: Clinic/Other outpatient","Healthcare:Inpatient","Healthcare:Nursing Home/Assisted living","Healthcare: Outpatient office(diagnostic)","Industrial manufacturing","Laboratory","Lodging: Dormitory","Lodging: Hotel/Motel/Report, Full service","Lodging: Hotel/Motel/Report, Limited service","Lodging: Hotel/Motel/Report, Select service","Lodging: Inn","Lodging: Other lodging","Multifamily residential: Apartment","Multifamily residential: Condomninum","Multifamily residential: Lowrise","Office: Administrative/Professional","Office: Financial","Office: Government","Office: Medical(non-diagnostic)","Office: Mixed use","Office: Other office","Public assembly: Convention Center","Public assembly: Recreation","Public assembly: Social/Meeting","Public assembly:Stadium/Arena","Public Order and safety:Fire/Police station","Public order and safety: Other public order","Religious worship","Retail: Bank branch","Retail: Convenience","Retail:Enclosed Mall","Fast Food","Grocery store/Food market","Retail: Open shopping center","Retail: Other Retail","Retail: Restaurant/cafeteria","Retail: Vehicle dealership","Service: Other service","Service: Post office/postal center","Service: Repair shop","Service: Vehicle service/repair","Service: Vehicle storage/maintanance","Single family home(attached)","Single family home(detached)","Warehouse: Nonrefridgerated distribution/shipping","Warehouse: Refridgerated","Warehouse: Self storage units","Warehouse:General","Other"]
    var currentarr = NSArray()
    var country = ""
    var titledict = NSDictionary()
    var pursedcertarr = NSArray()
    var yesorno = ["Yes","No"] as! NSArray
    var token = NSUserDefaults.standardUserDefaults().objectForKey("token") as? String
    var dict = NSDictionary()
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
        var buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        self.navigationItem.title = buildingdetails["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = "Manage"
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        var buildingdetails = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! [String : AnyObject]
        self.navigationItem.title = buildingdetails["name"] as? String
        self.navigationController?.navigationBar.backItem?.title = buildingdetails["name"] as? String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
        self.spinner.layer.cornerRadius = 5
        self.spinner.hidden = true
        pursedcertarr = ["WELL","Sustainable SITES", "PEER","Parksmart","GRESB","EDGE","Green Star","DGNB","BREEAM","Zero Waste","ENERGY STAR","Beam","CASBEE","Green Mark","Pearl","Other"]
        //titlearr = NSArray()
        sectionarr = ["Building details","Certification details","Other building details"]
       titledict = [0:["Name","Project ID","Unit Type","Space Type","Address","City","State","Country","Private","Owner type","Owner organization","Owner Email","Owner country"],
                    
                    1:["Previously LEED Certified?","Other certification programs pursued","Contains residential units?","Project affiliated?","Is project affiliated with a LEED Lab?"],
                    2:["Year built","Floors above grounds","Intend to precertify?","Gross floor area(square foot)","Target certification date","Operating hours","Occupancy"]
        ]
        
        print("DDX",titledict[0]?.count,titledict[1]?.count,titledict[2]?.count)        
        //Is project affiliated with a higher education institute?
        tableview.registerNib(UINib.init(nibName: "manageprojcellwithswitch", bundle: nil), forCellReuseIdentifier: "manageprojcellwithswitch")
        tableview.registerNib(UINib.init(nibName: "manageprojcell", bundle: nil), forCellReuseIdentifier: "manageprojcell")
                dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary
        data_dict = dict.mutableCopy() as! NSMutableDictionary
        print(data_dict)
        var countries = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("countries") as! NSData) as! NSDictionary
        var currentcountry = self.dict["country"] as? String
        var currentstate = self.dict["state"] as? String
        if(countries["countries"]![currentcountry!]! != nil){
        var tempstring = countries["divisions"]![currentcountry!]!![currentstate!]! as? String
        print(tempstring)
        self.state =  tempstring!
        tempstring = countries["countries"]![currentcountry!]! as? String
        self.country = tempstring!
        }else{
            self.state = ""
            self.country = ""
        }
        self.navigationController?.navigationBar.topItem?.title = data_dict["name"] as? String
                let notificationsarr = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("notifications") as! NSData) as! NSArray
        if(notificationsarr.count > 0 ){
            self.tabbar.items![4].badgeValue = "\(notificationsarr.count)"
        }else{
            self.tabbar.items![4].badgeValue = nil
        }
        self.tabbar.selectedItem = self.tabbar.items![3]
        // Do any additional setup after loading the view.
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if(item.title == "Score"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"plaque"])
            NSNotificationCenter.defaultCenter().postNotificationName("performrootsegue", object: nil, userInfo: ["seguename":"plaque"])
        }else if(item.title == "Analytics"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"beforeanalytics"])
            NSNotificationCenter.defaultCenter().postNotificationName("performrootsegue", object: nil, userInfo: ["seguename":"totalanalysis"])
        }else if(item.title == "Manage"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"manage"])
            NSNotificationCenter.defaultCenter().postNotificationName("performrootsegue", object: nil, userInfo: ["seguename":"manage"])
        }else if(item.title == "More"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"more"])
            NSNotificationCenter.defaultCenter().postNotificationName("performrootsegue", object: nil, userInfo: ["seguename":"more"])
        }else if(item.title == "Credits/Actions"){
            //NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"listofactions"])
            NSNotificationCenter.defaultCenter().postNotificationName("performrootsegue", object: nil, userInfo: ["seguename":"listofactions"])
        }

    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionarr.count
    }
    
   
    func back(sender:UIBarButtonItem){
        NSNotificationCenter.defaultCenter().postNotificationName("performsegue", object: nil, userInfo: ["seguename":"manage"])
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionarr.objectAtIndex(section) as! String
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var temp = titledict[section] as! NSArray
        return temp.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var temp = titledict[indexPath.section] as! NSArray
        if(indexPath.section == 0 && indexPath.row == 0){
            name = (data_dict["name"] as? String)!
            currentcontext = temp.objectAtIndex(indexPath.row) as! String
        self.performSegueWithIdentifier("editname", sender: nil)
        }else if(indexPath.section == 0 && indexPath.row == 2){
            currentcontext = temp.objectAtIndex(indexPath.row) as! String
            pickerarr = unitarr as NSArray
            self.performSegueWithIdentifier("gotolist", sender: nil)
        }else if(indexPath.section == 0 && indexPath.row == 3){
            currentcontext = temp.objectAtIndex(indexPath.row) as! String
            pickerarr = spacearr as NSArray
            self.performSegueWithIdentifier("gotolist", sender: nil)
        }
        else if(indexPath.section == 1 && indexPath.row == 0){
            currentcontext = temp.objectAtIndex(indexPath.row) as! String
            pickerarr = spacearr as NSArray
             if let s = data_dict["PrevCertProdId"] as? String{
                selectedvalue = s
            }
            self.performSegueWithIdentifier("gotoenableandfill", sender: nil)
        }else if(indexPath.section == 1 && indexPath.row == 1){
            currentcontext = temp.objectAtIndex(indexPath.row) as! String
            pickerarr = pursedcertarr as NSArray
            self.performSegueWithIdentifier("gotolist", sender: nil)
        }else if(indexPath.section == 1 && indexPath.row == 2){
            currentcontext = temp.objectAtIndex(indexPath.row) as! String
            pickerarr = pursedcertarr as NSArray
            if let s = data_dict["noOfResUnits"] as? String{
                selectedvalue = s
            }
            self.performSegueWithIdentifier("gotoenableandfill", sender: nil)
        }else if(indexPath.section == 1 && indexPath.row == 3){
            currentcontext = temp.objectAtIndex(indexPath.row) as! String
            pickerarr = pursedcertarr as NSArray
            if let s = data_dict["nameOfSchool"] as? String{
                selectedvalue = s
            }
            self.performSegueWithIdentifier("gotoenableandfill", sender: nil)
        }else if(indexPath.section == 2 && indexPath.row == 0){
            currentcontext = temp.objectAtIndex(indexPath.row) as! String
            pickerarr = pursedcertarr as NSArray
            if let s = data_dict["year_constructed"] as? Int{
                selectedvalue = "\(s)"
            }else{
                selectedvalue = ""
            }
            self.performSegueWithIdentifier("gotoselectedvalue", sender: nil)
        }else if(indexPath.section == 2 && indexPath.row == 1){
            currentcontext = temp.objectAtIndex(indexPath.row) as! String
            pickerarr = pursedcertarr as NSArray
            if let s = data_dict["noOfFloors"] as? Int{
                selectedvalue = "\(s)"
            }else{
                selectedvalue = ""
            }
            self.performSegueWithIdentifier("gotoselectedvalue", sender: nil)
        }else if(indexPath.section == 2 && indexPath.row == 3){
            currentcontext = temp.objectAtIndex(indexPath.row) as! String
            pickerarr = pursedcertarr as NSArray
            if let s = data_dict["gross_area"] as? Int{
                selectedvalue = "\(s)"
            }else{
                selectedvalue = ""
            }
            self.performSegueWithIdentifier("editname", sender: nil)
        }else if(indexPath.section == 2 && indexPath.row == 4){
            currentcontext = temp.objectAtIndex(indexPath.row) as! String
            pickerarr = pursedcertarr as NSArray
            if(data_dict["targetCertDate"] is NSNull || data_dict["targetCertDate"] as? String == ""){
                //cell.valuetxtfld.text = ""
                selectedvalue = ""
            }else{
                selectedvalue =  data_dict["targetCertDate"] as! String
            }
            self.performSegueWithIdentifier("gotodatechooser", sender: nil)
        }else if(indexPath.section == 2 && indexPath.row == 6){
            currentcontext = temp.objectAtIndex(indexPath.row) as! String
            pickerarr = pursedcertarr as NSArray
  
            currentcontext = temp.objectAtIndex(indexPath.row) as! String
            pickerarr = pursedcertarr as NSArray
            if let s = data_dict["gross_area"] as? Int{
                selectedvalue = "\(s)"
            }else{
                selectedvalue = ""
            }
            if(data_dict["occupancy"] is NSNull || data_dict["occupancy"] as? String == ""){
                selectedvalue = ""
            }else{
                selectedvalue = String(format:"%d",data_dict["occupancy"] as! Int)
            }
            self.performSegueWithIdentifier("editname", sender: nil)
        }
        
        
        //gotodatechooser
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "editname"){
            var v = segue.destinationViewController as! nameedit
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
            var v = segue.destinationViewController as! choosefromlist
            print(data_dict)
            v.data_dict = data_dict
            v.currentcontext = currentcontext
            v.pickerarr = pickerarr 
        }else if(segue.identifier == "gotoenableandfill"){
            var v = segue.destinationViewController as! enableandfillViewController
            v.data_dict = data_dict
            if(currentcontext == "Yes"){
            v.enabled = true
            }else{
            v.enabled = false
            }
            v.context = currentcontext
            v.prodid = selectedvalue
            
        }else if(segue.identifier == "gotoselectedvalue"){
            var v = segue.destinationViewController as! selectvalue
            v.data_dict = data_dict
            if(currentcontext == "Year built"){
                if let s = data_dict["year_constructed"] as? Int{
                    v.currentvalue = "\(s)"
                }else{
                    v.currentvalue = ""
                }
                v.PICKER_MIN = 1900
                v.currenttitle = currentcontext
                var formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy"
                var date = formatter.stringFromDate(NSDate())
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
            var v = segue.destinationViewController as! datechoose
            v.data_dict = data_dict
            v.context = currentcontext
            if(currentcontext == "Target certification date"){
                if(selectedvalue == ""){
                    var datef = NSDateFormatter()
                    datef.dateFormat = "yyyy-MM-dd"
                    var d = datef.stringFromDate(NSDate())
                    v.currentdate = datef.dateFromString(d)!
                }else{
                    var datef = NSDateFormatter()
                    datef.dateFormat = "yyyy-MM-dd"
                    var d = datef.dateFromString(data_dict["targetCertDate"] as! String)
                v.currentdate = d!
                }
                var datef = NSDateFormatter()
                datef.dateFormat = "yyyy-MM-dd"
                var d = datef.dateFromString("1900-01-01")
                v.startdate = d!
                datef.dateFormat = "yyyy-MM-dd"
                var e = datef.stringFromDate(NSDate())
                v.enddate = datef.dateFromString(e)!
                v.data_dict = data_dict
            }
            
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        dict = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("building_details") as! NSData) as! NSDictionary
        data_dict = dict.mutableCopy() as! NSMutableDictionary
        tableview.reloadData()
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("manageprojcell") as! manageprojcell
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        //cell.titlelbl.text = titlearr.objectAtIndex(indexPath.row) as? String
        //cell.selectionStyle = UITableViewCellSelectionStyle.None
        ////cell.valuetxtfld.tag = indexPath.row
        cell.contentView.alpha = 1
        ////cell.valuetxtfld.placeholder = ""
        var temp = titledict[indexPath.section] as! NSArray
        cell.textLabel!.text = temp.objectAtIndex(indexPath.row) as! String
        if(indexPath.section == 0){
        if(indexPath.row == 0){
            cell.detailTextLabel!.text = data_dict["name"] as? String
        }else if(indexPath.row == 1){
            ////cell.valuetxtfld.enabled = false
            cell.detailTextLabel!.text = String(format: "%d",dict["leed_id"] as! Int)
          
            cell.accessoryType = UITableViewCellAccessoryType.None
        }else if(indexPath.row == 2){
            cell.detailTextLabel!.text = data_dict["unitType"] as? String
           
        }else if(indexPath.row == 3){
            //cell.valuetxtfld.keyboardType = UIKeyboardType.Alphabet
            cell.detailTextLabel!.text = data_dict["spaceType"] as? String
           
            //cell.valuetxtfld.userInteractionEnabled = false
        }else if(indexPath.row == 4){
            //cell.valuetxtfld.keyboardType = UIKeyboardType.Default
            cell.detailTextLabel!.text = data_dict["street"] as? String
           
            cell.accessoryType = UITableViewCellAccessoryType.None
            //cell.valuetxtfld.userInteractionEnabled = false
        }else if(indexPath.row == 5){
            //cell.valuetxtfld.keyboardType = UIKeyboardType.Alphabet
            cell.detailTextLabel!.text = data_dict["city"] as? String
           
            cell.accessoryType = UITableViewCellAccessoryType.None
            //cell.valuetxtfld.userInteractionEnabled = false
        }else if(indexPath.row == 6){
            //cell.valuetxtfld.keyboardType = UIKeyboardType.Alphabet
            cell.detailTextLabel!.text = state
           
            cell.accessoryType = UITableViewCellAccessoryType.None
            //cell.valuetxtfld.userInteractionEnabled = false
        }else if(indexPath.row == 7){
            //cell.valuetxtfld.keyboardType = UIKeyboardType.Alphabet
            cell.detailTextLabel!.text = country
           
            cell.accessoryType = UITableViewCellAccessoryType.None
            //cell.valuetxtfld.userInteractionEnabled = false
        }else if(indexPath.row == 8){
            var cell = tableview.dequeueReusableCellWithIdentifier("manageprojcellwithswitch")! as! manageprojcellwithswitch
            cell.yesorno.on = Bool(data_dict["plaque_public"] as! Int)
            cell.yesorno.addTarget(self, action: #selector(self.plaquepublic(_:)), forControlEvents: UIControlEvents.ValueChanged)
            //cell.valuetxtfld.keyboardType = UIKeyboardType.Default
            print(data_dict["plaque_public"])
            //cell.valuetxtfld.userInteractionEnabled = false
          
            cell.lbl!.text = temp.objectAtIndex(indexPath.row) as! String
            cell.accessoryType = UITableViewCellAccessoryType.None            
            return cell
        }else if(indexPath.row == 9){
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.detailTextLabel!.text = data_dict["ownerType"] as? String
            //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
        }else if(indexPath.row == 10){
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.detailTextLabel!.text = data_dict["organization"] as? String
            //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
        }else if(indexPath.row == 11){
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.detailTextLabel!.text = data_dict["owner_email"] as? String
            //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
            }
        else if(indexPath.row == 12){
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.detailTextLabel!.text = country
            //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
        }
    }
        if(indexPath.section == 1){
       if(indexPath.row == 0){
            cell.userInteractionEnabled = true
            if(data_dict["ldp_old"] is NSNull){
                cell.detailTextLabel?.text = "No"
                //cell.yesnoswitch.on = false
                //cell.valuetxtfld.text = ""
            }else{
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
            
            //cell.yesnoswitch.hidden = false
            //cell.yesnoswitch.tag = 100+indexPath.row
            //cell.yesnoswitch.addTarget(self, action: #selector(manageproject.switchused(_:)), forControlEvents:UIControlEvents.ValueChanged)
            //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
        }else if(indexPath.row == 1){
            cell.userInteractionEnabled = true
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
            cell.userInteractionEnabled = true
            
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
            //cell.yesnoswitch.hidden = false
            //cell.yesnoswitch.tag = 100+indexPath.row
            //cell.yesnoswitch.addTarget(self, action: "switchused:", forControlEvents:UIControlEvents.ValueChanged)
        }else if(indexPath.row == 3){
            cell.userInteractionEnabled = true
            ////cell.valuetxtfld.enabled = true
            //nameOfSchool
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
            //cell.yesnoswitch.hidden = false
            //cell.yesnoswitch.tag = 100+indexPath.row
            //cell.yesnoswitch.addTarget(self, action: "switchused:", forControlEvents:UIControlEvents.ValueChanged)
            //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
        }else if(indexPath.row == 4){
        var cell = tableview.dequeueReusableCellWithIdentifier("manageprojcellwithswitch")! as! manageprojcellwithswitch
        cell.yesorno.addTarget(self, action: #selector(self.affleedlab(_:)), forControlEvents: UIControlEvents.ValueChanged)
        //cell.valuetxtfld.keyboardType = UIKeyboardType.Default
        print(data_dict["plaque_public"])
        //cell.valuetxtfld.userInteractionEnabled = false
        cell.lbl!.text = temp.objectAtIndex(indexPath.row) as! String
        cell.accessoryType = UITableViewCellAccessoryType.None
            ////cell.valuetxtfld.enabled = false
            //cell.valuetxtfld.text = ""
        if(data_dict["affiliatedWithLeedLab"] is NSNull){
            cell.yesorno.on = false
        }else{
            if(data_dict["affiliatedWithLeedLab"] != nil){
                cell.yesorno.on = Bool(data_dict["plaque_public"] as! Int)
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
            cell.userInteractionEnabled = true
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
            cell.userInteractionEnabled = true
            ////cell.valuetxtfld.enabled = true
            if(data_dict["noOfFloors"] is NSNull || data_dict["noOfFloors"] as? String == ""){
                //cell.valuetxtfld.text = ""
                cell.detailTextLabel?.text = "Not available"
            }else{
                cell.detailTextLabel?.text = "\(data_dict["noOfFloors"]!)"
                //cell.valuetxtfld.text = String(format:"%d",data_dict["noOfFloors"] as! Int)
            }
            //cell.yesnoswitch.hidden = true
            //cell.valuetxtfld.keyboardType = UIKeyboardType.NumberPad
            //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
        }else if(indexPath.row == 2){
            var cell = tableview.dequeueReusableCellWithIdentifier("manageprojcellwithswitch")! as! manageprojcellwithswitch
            cell.yesorno.addTarget(self, action: #selector(self.intentedtocert(_:)), forControlEvents: UIControlEvents.ValueChanged)
            //cell.valuetxtfld.keyboardType = UIKeyboardType.Default
            print(data_dict["plaque_public"])
            //cell.valuetxtfld.userInteractionEnabled = false
            cell.lbl!.text = temp.objectAtIndex(indexPath.row) as! String
            cell.accessoryType = UITableViewCellAccessoryType.None
            ////cell.valuetxtfld.enabled = false
            //cell.valuetxtfld.text = ""
            if(data_dict["intentToPrecertify"] is NSNull){
                cell.yesorno.on = false
            }else{
                if(data_dict["intentToPrecertify"] != nil){
                    cell.yesorno.on = Bool(data_dict["intentToPrecertify"] as! Int)
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
            cell.userInteractionEnabled = true
            if(data_dict["gross_area"] is NSNull || data_dict["gross_area"] as? String == ""){
                //cell.valuetxtfld.text = ""
                cell.detailTextLabel?.text = "Not available"
            }else{
                cell.detailTextLabel?.text = "\(data_dict["gross_area"]!)"
                //cell.valuetxtfld.text = String(format:"%d",data_dict["noOfFloors"] as! Int)
            }
            ////cell.valuetxtfld.enabled = true
            //cell.valuetxtfld.text = String(format:"%d",data_dict["gross_area"] as! Int)
            //cell.valuetxtfld.keyboardType = UIKeyboardType.NumberPad
            //cell.yesnoswitch.hidden = true
        }else if(indexPath.row == 4){
            cell.userInteractionEnabled = true
            ////cell.valuetxtfld.enabled = true            
            if(data_dict["targetCertDate"] is NSNull || data_dict["targetCertDate"] as? String == ""){
                //cell.valuetxtfld.text = ""
                cell.detailTextLabel?.text = "Not available"
            }else{
                let dateFormatter: NSDateFormatter = NSDateFormatter()                
                dateFormatter.dateFormat = "yyyy-MM-dd"
                var dt = dateFormatter.dateFromString(data_dict["targetCertDate"] as! String)
                dateFormatter.dateFormat = "dd/MM/yyyy"
                print(dateFormatter.stringFromDate(dt!))
                var str = dateFormatter.stringFromDate(dt!)
                cell.detailTextLabel?.text = str
                //cell.valuetxtfld.text = String(format:"%@",data_dict["targetCertDate"] as! String)
            }
            //cell.yesnoswitch.hidden = true
            //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
        }else if(indexPath.row == 5){
            cell.accessoryType = UITableViewCellAccessoryType.None
            ////cell.valuetxtfld.enabled = true
            if(data_dict["operating_hours"] is NSNull || data_dict["operating_hours"] as? String == ""){
                //cell.valuetxtfld.text = ""
                cell.detailTextLabel?.text = "Not available"
                
            }else{
                cell.detailTextLabel?.text = String(format:"%d",data_dict["operating_hours"] as! Int)
            }
            //cell.yesnoswitch.hidden = true
            //cell.valuetxtfld.keyboardType = UIKeyboardType.NumberPad
            //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
        }else if(indexPath.row == 6){
            cell.userInteractionEnabled = true
            ////cell.valuetxtfld.enabled = true
            if(data_dict["occupancy"] is NSNull || data_dict["occupancy"] as? String == ""){
                cell.detailTextLabel?.text = "Not available"
            }else{
                //cell.valuetxtfld.text = String(format:"%d",data_dict["occupancy"] as! Int)
                cell.detailTextLabel?.text = String(format:"%d",data_dict["occupancy"] as! Int)
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
    
    @IBAction func saveproject(selected: Int) {
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
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401 {           // check for http errors
                dispatch_async(dispatch_get_main_queue(), {
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                })
            } else
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
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode == 401 {           // check for http errors
                dispatch_async(dispatch_get_main_queue(), {
                    self.spinner.hidden = true
                    self.view.userInteractionEnabled = true
                    NSNotificationCenter.defaultCenter().postNotificationName("renewtoken", object: nil, userInfo:nil)
                })
            } else
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
    
    @IBOutlet weak var spinner: UIView!
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
    
    func intentedtocert(sender: UISwitch){
        if(sender.on){
            data_dict["intentToPrecertify"] = 1
        }else{
            data_dict["intentToPrecertify"] = 0
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.spinner.hidden = false
            self.saveproject(0)
        })
        
    }
    
    func plaquepublic(sender: UISwitch){
            if(sender.on){
                data_dict["plaque_public"] = 1
            }else{
                data_dict["plaque_public"] = 0
            }
        dispatch_async(dispatch_get_main_queue(), {
        self.spinner.hidden = false
        self.saveproject(0)
        })
        
    }
    
    func affleedlab(sender: UISwitch){
        if(sender.on){
            data_dict["affiliatedWithLeedLab"] = 1
        }else{
            data_dict["affiliatedWithLeedLab"] = 0
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.spinner.hidden = false
            self.saveproject(0)
        })
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {        
        if(UIScreen.mainScreen().bounds.size.width < UIScreen.mainScreen().bounds.size.height){
            return 0.082 * UIScreen.mainScreen().bounds.size.height;
        }
        return 0.082 * UIScreen.mainScreen().bounds.size.width;
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
