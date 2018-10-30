
//
//  ViewController.swift
//  push_segue
//
//  Created by Group X on 21/02/17.
//  Copyright © 2017 USGBC. All rights reserved.
//

import UIKit
import AVFoundation

class addnewproject: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let synth = AVSpeechSynthesizer()
    
    @IBOutlet weak var spinner: UIView!
    var myUtterance = AVSpeechUtterance(string: "")
    var data_dict = NSMutableDictionary()
    var titlearr = NSArray()
    var contentarray = NSArray()
    var state = ""
    var pickerarr = NSArray()
    var selectedvalue = ""
    var name = ""
    var currentcontext = ""
    var download_requests = [URLSession]()
    var leedid = UserDefaults.standard.integer(forKey: "leed_id")
    var listarr = ["","","","","","","","","","","","","","","","","","","","","","","","",""] 
    var unitarr = ["SI","IP"]
    var sectionarr = NSMutableArray()
    
    @IBAction func textToSpeech(_ sender: UIButton)
    {
        /*myUtterance = AVSpeechUtterance(string: "New project named \"USGBC Headquarters\" saved sucessfully")
        var speechvoices = AVSpeechSynthesisVoice.speechVoices()
        //print(speechvoices.count, speechvoices)
        myUtterance.voice = AVSpeechSynthesisVoice.init(language: "en-US")
        myUtterance.rate = 0.485;
        myUtterance.pitchMultiplier = 0.85;
        synth.speakUtterance(myUtterance)*/
        let temparr = NSMutableArray()
        for i in contentarray{
            let item = i
            if((item as! String) != "OtherCertProg"){
            if(data_dict[item as! String] is String || data_dict[item as! String] == nil){
            if(data_dict[item as! String] == nil || data_dict[item as! String] as! String == ""){
                if((item as! String) == "PrevCertProdId"){
                    if(data_dict["ldp_old"] != nil){
                    if(data_dict["ldp_old"] as! Bool == true){
                        temparr.add(reasondict[item as! String]!)
                    }
                    }else{
                        temparr.add(reasondict[item as! String]!)
                    }
                }else if((item as! String) == "noOfResUnits"){
                    if(data_dict["IsResidential"] != nil){
                        if(data_dict["IsResidential"] as! Bool == true){
                            temparr.add(reasondict[item as! String]!)
                        }
                    }else{
                        temparr.add(reasondict[item as! String]!)
                    }
                }
                else{
                temparr.add(reasondict[item as! String]!)
                }
            }
            }
            }
        }
        //print(temparr)
        if(temparr.count == 0){
            //print("ok")
            validatepin()
        }else{
            let string = temparr.componentsJoined(by: "\n")
            //print(string)
            let alert = UIAlertController(title: "Required fields are found empty", message: "Please kindly fill out the below fields :- \n \(string)", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            alert.view.subviews.first?.backgroundColor = UIColor.white
            self.present(alert, animated: true, completion: nil)
        }
        //validatearea()
    }
    
    @IBOutlet weak var tableview: UITableView!
    var spacearr = ["Circulation space","Core learning space:College/University","Core learning space:K-12 Elementary/Middle school","Core learning space: K-12 High school","Core learning space:Other classroom education","Core learning space:Preschool/Daycare","Data Center","Healthcare: Clinic/Other outpatient","Healthcare:Inpatient","Healthcare:Nursing Home/Assisted living","Healthcare: Outpatient office(diagnostic)","Industrial manufacturing","Laboratory","Lodging: Dormitory","Lodging: Hotel/Motel/Report, Full service","Lodging: Hotel/Motel/Report, Limited service","Lodging: Hotel/Motel/Report, Select service","Lodging: Inn","Lodging: Other lodging","Multifamily residential: Apartment","Multifamily residential: Condomninum","Multifamily residential: Lowrise","Office: Administrative/Professional","Office: Financial","Office: Government","Office: Medical(non-diagnostic)","Office: Mixed use","Office: Other office","Public assembly: Convention Center","Public assembly: Recreation","Public assembly: Social/Meeting","Public assembly:Stadium/Arena","Public Order and safety:Fire/Police station","Public order and safety: Other public order","Religious worship","Retail: Bank branch","Retail: Convenience","Retail:Enclosed Mall","Fast Food","Grocery store/Food market","Retail: Open shopping center","Retail: Other Retail","Retail: Restaurant/cafeteria","Retail: Vehicle dealership","Service: Other service","Service: Post office/postal center","Service: Repair shop","Service: Vehicle service/repair","Service: Vehicle storage/maintanance","Single family home(attached)","Single family home(detached)","Warehouse: Nonrefridgerated distribution/shipping","Warehouse: Refridgerated","Warehouse: Self storage units","Warehouse:General","Other"]
    var currentarr = NSArray()
    var country = ""
    var titledict = NSDictionary()
    var pursedcertarr = NSArray()
    var reasondict = NSDictionary()
    var yesorno = ["Yes","No"] 
    var token = UserDefaults.standard.object(forKey: "token") as? String
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlefont()
        spinner.layer.cornerRadius = 5
        spinner.isHidden = true
           //data_dict = ["AffiliatedHigherEduIns":false,"IsLovRecert":false,"IsResidential":false,"affiliatedWithLeedLab":false,"building_status":"activated_payment_pending","city":"Pondicherry","confidential":false,"country":"IN","default_human_experience":50,"gross_area":"2322","manageEntityCountry":"US","name":"nbn","organization":"My org","override_valid":false,"ownerType":"Test Owner","owner_email":"dhiranontrack@gmail.com","project_type":"building","publish":true,"rating_system":"LEED V4 O+M: EB WP","spaceType":"Circulation space","state":"32","street":"29, V S Nagar, Teachers Qtrs St","survey_expire_date":"2017-02-24T05:27:24.677082Z","survey_with_dashboard":false,"trial_version_status":false,"unitType":"IP","updated_at":"2017-02-24T05:27:24.677604Z","zip_code":"605106"]
        //data_dict["plaque_public"] = true
        //data_dict["ldp_old"] = false
        //data_dict["affiliatedWithLeedLab"] = true
        //data_dict["AffiliatedHigherEduIns"] = true
        //data_dict["intentToPrecertify"] = true
        //data_dict["IsResidential"] = false
        
        
        tableview.register(UINib.init(nibName: "manageprojcellwithswitch", bundle: nil), forCellReuseIdentifier: "manageprojcellwithswitch")
        tableview.register(UINib.init(nibName: "manageprojcell", bundle: nil), forCellReuseIdentifier: "manageprojcell")
        pursedcertarr = ["WELL","Sustainable SITES", "PEER","Parksmart","GRESB","EDGE","Green Star","DGNB","BREEAM","Zero Waste","ENERGY STAR","Beam","CASBEE","Green Mark","Pearl","Other"]
        //titlearr = NSArray()
        contentarray = ["name","unitType","spaceType","street","city","state","country","plaque_public","ownerType","organization","owner_email","PrevCertProdId","ldp_old","OtherCertProg","IsResidential","noOfResUnits","AffiliatedHigherEduIns","affiliatedWithLeedLab","year_constructed","noOfFloors","intentToPrecertify","gross_area","targetCertDate","operating_hours","occupancy"]
        
        reasondict = ["name":"Project name","unitType":"Unit type","spaceType":"Space type","street":"Address","city":"City","state":"State","country":"Country","plaque_public":"Project is private","ownerType": "Owner type","organization":"Owner organization","owner_email":"Owner email","PrevCertProdId":"Previous LEED ID","ldp_old":"Previously LEED ertified","OtherCertProg":"Other certifications prusued","IsResidential":"Residential units","noOfResUnits":"Number of residential units","AffiliatedHigherEduIns":"Affiliated with higher education insititute","affiliatedWithLeedLab":"Affiliated with LEED lab","year_constructed":"Year contructed","noOfFloors":"Number of floors","intentToPrecertify":"Intented to Precertify","gross_area": "Gross floor area","targetCertDate":"Target certification date","operating_hours":"Operating hours","occupancy":"Occupancy"]
        
        sectionarr = ["Project details","Certification details","Other Project details"]
        titledict = [0:["Name","Unit Type","Space Type","Address","City","State","Country","Private","Owner type","Owner organization","Owner Email","Owner country"],
                     
                     1:["Previously LEED Certified?","Other certification programs pursued","Contains residential units?","Project affiliated?","Is project affiliated with a LEED Lab?"],
                     2:["Year built","Floors above grounds","Intend to precertify?","Gross floor area(square foot)","Target certification date","Operating hours","Occupancy"]
        ]
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        token = UserDefaults.standard.object(forKey: "token") as! String
        var countries = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "countries") as! Data) as! NSDictionary
        
        var currentcountry = ""
        if(data_dict["country"] != nil){
            currentcountry = data_dict["country"] as! String
            
            if let snapshotValue = countries["countries"] as? NSDictionary, let currentcountr = snapshotValue[currentcountry] as? String {
                self.country = currentcountr
            }
            
            
            
        }
        var currentstate = ""
        if(data_dict["state"] != nil){
            currentstate = data_dict["state"] as! String
            var temp = currentstate.replacingOccurrences(of: currentcountry, with: "")
            currentstate = temp
            var tempstring = ""//(countries["divisions"]![currentcountry] as! NSDictionary)[currentstate]! as? String
            
            if let snapshotValue = countries["divisions"] as? NSDictionary, let currentcountr = snapshotValue[currentcountry] as? NSDictionary, let currentstat = currentcountr[currentstate] as? String {
                tempstring = currentstat
            }
            
            ////print(tempstring)
            self.state =  tempstring
        }
        
        
        
        tableview.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionarr.count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionarr.object(at: section) as! String
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let temp = titledict[section] as! NSArray
        return temp.count
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
                if (data_dict["name"] != nil){
                cell.detailTextLabel!.text = data_dict["name"] as? String
                }else{
                cell.detailTextLabel!.text = ""    
                }
            }else if(indexPath.row == 1){
                if (data_dict["unitType"] != nil){
                cell.detailTextLabel!.text = data_dict["unitType"] as? String
                }else{
                    cell.detailTextLabel?.text = ""
                }
                //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
            }else if(indexPath.row == 2){
                //cell.valuetxtfld.keyboardType = UIKeyboardType.Alphabet
                if (data_dict["spaceType"] != nil){
                cell.detailTextLabel!.text = data_dict["spaceType"] as? String
                }else{
                    cell.detailTextLabel?.text = ""
                }
                //listarr.replaceObjectAtIndex(indexPath.row, withObject:cell.detailTextLabel!.text!)
                //cell.valuetxtfld.userInteractionEnabled = false
            }else if(indexPath.row == 3){
                //cell.valuetxtfld.keyboardType = UIKeyboardType.Default
                if (data_dict["street"] != nil){
                cell.detailTextLabel!.text = data_dict["street"] as? String
                }else{
                  cell.detailTextLabel?.text = ""  
                }
                //listarr.replaceObjectAtIndex(indexPath.row, withObject:cell.detailTextLabel!.text!)
                //cell.valuetxtfld.userInteractionEnabled = false
            }else if(indexPath.row == 4){
                //cell.valuetxtfld.keyboardType = UIKeyboardType.Alphabet
                if (data_dict["city"] != nil){
                cell.detailTextLabel!.text = data_dict["city"] as? String
                }else{
                    cell.detailTextLabel?.text = ""
                }
                //listarr.replaceObjectAtIndex(indexPath.row, withObject:cell.detailTextLabel!.text!)
                //cell.valuetxtfld.userInteractionEnabled = false
            }else if(indexPath.row == 5){
                //cell.valuetxtfld.keyboardType = UIKeyboardType.Alphabet
                cell.detailTextLabel!.text = state
                //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
                //cell.valuetxtfld.userInteractionEnabled = false
            }else if(indexPath.row == 6){
                //cell.valuetxtfld.keyboardType = UIKeyboardType.Alphabet
                cell.detailTextLabel!.text = country
                //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
                //cell.valuetxtfld.userInteractionEnabled = false
            }else if(indexPath.row == 7){
                var cell = tableView.dequeueReusableCell(withIdentifier: "manageprojcellwithswitch")! as! manageprojcellwithswitch
                if(data_dict["plaque_public"] != nil){
                cell.yesorno.isOn = Bool(data_dict["plaque_public"] as! NSNumber)
                }
                cell.yesorno.addTarget(self, action: #selector(self.plaquepublic(_:)), for: UIControlEvents.valueChanged)
                //cell.valuetxtfld.keyboardType = UIKeyboardType.Default
                //print(data_dict["plaque_public"])
                //cell.valuetxtfld.userInteractionEnabled = false
                //listarr.replaceObjectAtIndex(indexPath.row, withObject: "\(data_dict["plaque_public"] as! Int)")
                cell.lbl!.text = temp.object(at: indexPath.row) as! String
                cell.accessoryType = UITableViewCellAccessoryType.none
                return cell
            }else if(indexPath.row == 8){
                if(data_dict["ownerType"] != nil){
                cell.detailTextLabel!.text = data_dict["ownerType"] as? String
                }else{
                    cell.detailTextLabel?.text = ""
                }
                //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
            }else if(indexPath.row == 9){
                if(data_dict["organization"] != nil){
                cell.detailTextLabel!.text = data_dict["organization"] as? String
                }else{
                    cell.detailTextLabel?.text = ""
                }
                //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
            }else if(indexPath.row == 10){
                if(data_dict["owner_email"] != nil){
                cell.detailTextLabel!.text = data_dict["owner_email"] as? String
                }else{
                    cell.detailTextLabel?.text = ""
                }
                //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
            }
            else if(indexPath.row == 11){
                cell.detailTextLabel!.text = country
                //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
            }
        }
        if(indexPath.section == 1){
            if(indexPath.row == 0){
                cell.isUserInteractionEnabled = true
                if(data_dict["ldp_old"] is NSNull || data_dict["ldp_old"] == nil){
                    cell.detailTextLabel?.text = "No"
                    //cell.yesnoswitch.on = false
                    //cell.valuetxtfld.text = ""
                }else{
                    if(data_dict["ldp_old"] as! Bool == true){
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
                cell.isUserInteractionEnabled = true
                ////cell.valuetxtfld.enabled = true
                //cell.yesnoswitch.hidden = true
                if(data_dict["OtherCertProg"] is NSNull || data_dict["OtherCertProg"] == nil ){
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
                if(data_dict["IsResidential"] as! Bool == false){
                    ////cell.valuetxtfld.enabled = false
                    //cell.yesnoswitch.on = Bool(data_dict["IsResidential"] as! NSNumber)
                    //cell.valuetxtfld.text = ""
                    cell.detailTextLabel?.text = "No"
                }else{
                    //cell.yesnoswitch.on = Bool(data_dict["IsResidential"] as! NSNumber)
                    ////cell.valuetxtfld.enabled = true
                    cell.detailTextLabel?.text = "Yes"
                }
                }else{
                    cell.detailTextLabel?.text = "Not available"
                }
                //cell.yesnoswitch.hidden = false
                //cell.yesnoswitch.tag = 100+indexPath.row
                //cell.yesnoswitch.addTarget(self, action: "switchused:", forControlEvents:UIControlEvents.ValueChanged)
            }else if(indexPath.row == 3){
                cell.isUserInteractionEnabled = true
                ////cell.valuetxtfld.enabled = true
                //nameOfSchool
                if(data_dict["AffiliatedHigherEduIns"] != nil){
                if(data_dict["AffiliatedHigherEduIns"] as! Bool == false){
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
                }else{
                    
                }
                //cell.yesnoswitch.hidden = false
                //cell.yesnoswitch.tag = 100+indexPath.row
                //cell.yesnoswitch.addTarget(self, action: "switchused:", forControlEvents:UIControlEvents.ValueChanged)
                //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
            }else if(indexPath.row == 4){
                var cell = tableview.dequeueReusableCell(withIdentifier: "manageprojcellwithswitch")! as! manageprojcellwithswitch
                cell.yesorno.addTarget(self, action: #selector(self.affleedlab(_:)), for: UIControlEvents.valueChanged)
                //cell.valuetxtfld.keyboardType = UIKeyboardType.Default
                //print(data_dict["plaque_public"])
                //cell.valuetxtfld.userInteractionEnabled = false
                cell.lbl!.text = temp.object(at: indexPath.row) as! String
                cell.accessoryType = UITableViewCellAccessoryType.none
                ////cell.valuetxtfld.enabled = false
                //cell.valuetxtfld.text = ""
                if(data_dict["affiliatedWithLeedLab"] is NSNull || data_dict["affiliatedWithLeedLab"] == nil){
                    cell.yesorno.isOn = false
                }else{
                    if(data_dict["affiliatedWithLeedLab"] != nil){
                        cell.yesorno.isOn = Bool(data_dict["affiliatedWithLeedLab"] as! NSNumber)
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
                if(data_dict["noOfFloors"] is NSNull || data_dict["noOfFloors"] as? String == "" || data_dict["noOfFloors"] == nil){
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
                var cell = tableview.dequeueReusableCell(withIdentifier: "manageprojcellwithswitch")! as! manageprojcellwithswitch
                cell.yesorno.addTarget(self, action: #selector(self.intentedtocert(_:)), for: UIControlEvents.valueChanged)
                //cell.valuetxtfld.keyboardType = UIKeyboardType.Default
                //print(data_dict["plaque_public"])
                //cell.valuetxtfld.userInteractionEnabled = false
                cell.lbl!.text = temp.object(at: indexPath.row) as! String
                cell.accessoryType = UITableViewCellAccessoryType.none
                ////cell.valuetxtfld.enabled = false
                //cell.valuetxtfld.text = ""
                if(data_dict["intentToPrecertify"] is NSNull || data_dict["intentToPrecertify"] == nil){
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
                if(data_dict["gross_area"] is NSNull || data_dict["gross_area"] as? String == "" || data_dict["gross_area"] == nil){
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
                cell.isUserInteractionEnabled = true
                ////cell.valuetxtfld.enabled = true
                if(data_dict["targetCertDate"] is NSNull || data_dict["targetCertDate"] as? String == "" || data_dict["targetCertDate"] == nil){
                    //cell.valuetxtfld.text = ""
                    cell.detailTextLabel?.text = "Not available"
                }else{
                    let dateFormatter: DateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    var dt = dateFormatter.date(from: data_dict["targetCertDate"] as! String)
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    //print(dateFormatter.string(from: dt!))
                    var str = dateFormatter.string(from: dt!)
                    cell.detailTextLabel?.text = str
                    //cell.valuetxtfld.text = String(format:"%@",data_dict["targetCertDate"] as! String)
                }
                //cell.yesnoswitch.hidden = true
                //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
            }else if(indexPath.row == 5){
                ////cell.valuetxtfld.enabled = true
                if(data_dict["operating_hours"] is NSNull || data_dict["operating_hours"] as? String == "" || data_dict["operating_hours"] == nil){
                    //cell.valuetxtfld.text = ""
                    cell.detailTextLabel?.text = "Not available"
                    
                }else{
                    if(data_dict["occupancy"] is Int){
                    cell.detailTextLabel?.text = String(format:"%d",data_dict["operating_hours"] as! Int)
                    }else{
                    cell.detailTextLabel?.text = String(format:"%@",data_dict["operating_hours"] as! String)
                    }
                }
                //cell.yesnoswitch.hidden = true
                //cell.valuetxtfld.keyboardType = UIKeyboardType.NumberPad
                //listarr.replaceObjectAtIndex(indexPath.row, withObject: cell.detailTextLabel!.text!)
            }else if(indexPath.row == 6){
                cell.isUserInteractionEnabled = true
                ////cell.valuetxtfld.enabled = true
                if(data_dict["occupancy"] is NSNull || data_dict["occupancy"] as? String == "" || data_dict["occupancy"] == nil){
                    cell.detailTextLabel?.text = "Not available"
                }else{
                    //cell.valuetxtfld.text = String(format:"%d",data_dict["occupancy"] as! Int)
                    if(data_dict["occupancy"] is Int){
                    cell.detailTextLabel?.text = String(format:"%d",data_dict["occupancy"] as! Int)
                    }else{
                    cell.detailTextLabel?.text = String(format:"%@",data_dict["occupancy"] as! String)
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let temp = titledict[indexPath.section] as! NSArray
        if(indexPath.section == 0 && indexPath.row == 0){
            if(data_dict["name"] != nil){
            name = (data_dict["name"] as? String)!
            }else{
                name = ""
            }
            currentcontext = temp.object(at: indexPath.row) as! String
            self.performSegue(withIdentifier: "editname", sender: nil)
        }else if(indexPath.section == 0 && indexPath.row == 1){
            currentcontext = temp.object(at: indexPath.row) as! String
            pickerarr = unitarr as NSArray
            self.performSegue(withIdentifier: "gotolist", sender: nil)
        }else if(indexPath.section == 0 && indexPath.row == 2){
            currentcontext = temp.object(at: indexPath.row) as! String
            pickerarr = spacearr as NSArray
            self.performSegue(withIdentifier: "gotolist", sender: nil)
        }else if(indexPath.section == 0 && indexPath.row == 3){
            currentcontext = temp.object(at: indexPath.row) as! String
            if (data_dict["street"] != nil){
                name = data_dict["street"] as! String
            }else{
                name = ""
            }
            self.performSegue(withIdentifier: "editname", sender: nil)
        }else if(indexPath.section == 0 && indexPath.row == 4){
            currentcontext = temp.object(at: indexPath.row) as! String
            if (data_dict["city"] != nil){
                name = data_dict["city"] as! String
            }else{
                name = ""
            }
            self.performSegue(withIdentifier: "editname", sender: nil)
        }else if(indexPath.section == 0 && indexPath.row == 5){
            currentcontext = temp.object(at: indexPath.row) as! String
            if (data_dict["state"] != nil){
                name = data_dict["state"] as! String
            }else{
                name = ""
            }
            self.performSegue(withIdentifier: "gotopickerview", sender: nil)
        }else if(indexPath.section == 0 && indexPath.row == 6){
            currentcontext = temp.object(at: indexPath.row) as! String
            if (data_dict["country"] != nil){
                name = data_dict["country"] as! String
            }else{
                name = ""
            }
            self.performSegue(withIdentifier: "gotopickerview", sender: nil)
        }else if(indexPath.section == 0 && indexPath.row == 8){
            currentcontext = temp.object(at: indexPath.row) as! String
            if (data_dict["ownerType"] != nil){
                name = data_dict["ownerType"] as! String
            }else{
                name = ""
            }
            self.performSegue(withIdentifier: "editname", sender: nil)
        }else if(indexPath.section == 0 && indexPath.row == 9){
            currentcontext = temp.object(at: indexPath.row) as! String
            if (data_dict["organization"] != nil){
                name = data_dict["organization"] as! String
            }else{
                name = ""
            }
            self.performSegue(withIdentifier: "editname", sender: nil)
        }else if(indexPath.section == 0 && indexPath.row == 10){
            currentcontext = temp.object(at: indexPath.row) as! String
            if (data_dict["owner_email"] != nil){
                name = data_dict["owner_email"] as! String
            }else{
                name = ""
            }
            self.performSegue(withIdentifier: "editname", sender: nil)
        }else if(indexPath.section == 0 && indexPath.row == 11){
            currentcontext = temp.object(at: indexPath.row) as! String
            if (data_dict["country"] != nil){
                name = data_dict["country"] as! String
            }else{
                name = ""
            }
            self.performSegue(withIdentifier: "gotopickerview", sender: nil)
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
            if(data_dict["targetCertDate"] is NSNull || data_dict["targetCertDate"] as? String == "" || data_dict["targetCertDate"] == nil){
                //cell.valuetxtfld.text = ""
                selectedvalue = ""
            }else{
                selectedvalue =  data_dict["targetCertDate"] as! String
            }
            self.performSegue(withIdentifier: "gotodatechooser", sender: nil)
        }else if(indexPath.section == 2 && indexPath.row == 5){
            currentcontext = temp.object(at: indexPath.row) as! String
            pickerarr = pursedcertarr as NSArray
            if (data_dict["operating_hours"] != nil){
                name = data_dict["operating_hours"] as! String
            }else{
                name = ""
            }
            self.performSegue(withIdentifier: "editname", sender: nil)
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
            if(data_dict["occupancy"] is NSNull || data_dict["occupancy"] as? String == "" || data_dict["occupancy"] == nil){
                selectedvalue = ""
            }else{
                selectedvalue = String(format:"%d",data_dict["occupancy"] as! Int)
            }
            self.performSegue(withIdentifier: "editname", sender: nil)
        }
        
        
        //gotodatechooser
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editname"){
            let v = segue.destination as! nameedittoadd
            if(currentcontext == "Name"){
                v.name = name
            }else if(currentcontext == "Project ID"){
                v.name = name
            }else if(currentcontext == "Address"){
                v.name = name
            }else if(currentcontext == "City"){
                v.name = name
            }else if(currentcontext == "Owner type"){
                v.name = name
            }else if(currentcontext == "Owner country"){
                v.name = name
            }else if(currentcontext == "Owner organization"){
                v.name = name
            }else if(currentcontext == "Owner Email"){
                v.name = name
            }else if(currentcontext == "State"){
                v.name = name
            }else if(currentcontext == "Country"){
                v.name = name
            }else if(currentcontext == "Operating hours"){
                v.name = name
            }else if(currentcontext == "Occupancy"){
                v.name = selectedvalue
            }else{
                v.name = selectedvalue
            }
            v.data_dict = data_dict
            v.currenttitle = currentcontext
        }else if(segue.identifier == "gotolist"){
            let v = segue.destination as! choosefromlisttoadd
            //print(data_dict)
            v.data_dict = data_dict
            v.currentcontext = currentcontext
            v.pickerarr = pickerarr
        }else if(segue.identifier == "gotopickerview"){
            let v = segue.destination as! pickerviewcontroller            
            v.data_dict = data_dict
        }
        else if(segue.identifier == "gotoenableandfill"){
            let v = segue.destination as! enableandfillViewControllertoadd
            v.data_dict = data_dict
            if(currentcontext == "Yes"){
                v.enabled = true
            }else{
                v.enabled = false
            }
            v.context = currentcontext
            v.prodid = selectedvalue
            
        }else if(segue.identifier == "gotoselectedvalue"){
            let v = segue.destination as! selectvaluetoadd
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
            let v = segue.destination as! datechoosetoadd
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

    
    func intentedtocert(_ sender: UISwitch){
        if(sender.isOn){
            data_dict["intentToPrecertify"] = true
        }else{
            data_dict["intentToPrecertify"] = false
        }
        DispatchQueue.main.async(execute: {
            //self.spinner.hidden = false
            //self.saveproject(0)
        })
        
    }
    
    func plaquepublic(_ sender: UISwitch){
        if(sender.isOn){
            data_dict["plaque_public"] = true
        }else{
            data_dict["plaque_public"] = false
        }
        DispatchQueue.main.async(execute: {
            //self.spinner.hidden = false
            //self.saveproject(0)
        })
        
    }
    
    func affleedlab(_ sender: UISwitch){
        if(sender.isOn){
            data_dict["affiliatedWithLeedLab"] = true
        }else{
            data_dict["affiliatedWithLeedLab"] = false
        }
        DispatchQueue.main.async(execute: {
            //self.spinner.hidden = false
            //self.saveproject(0)
        })
        
    }
    
    
    func validatearea(){
        
        
        let payload = NSMutableString()
        //{"destination":"testuser@gmail.com","score_change_notification":false,"stype":"email"}
        
        
        
        payload.append("{")
        for (key, value) in data_dict {
         if(value is String){
         payload.append("\"\(key)\": \"\(value)\",")
         }else if(value is Bool){
            payload.append("\"\(key)\": \(value),")
         }
         else if(value is NSNumber){
         payload.append("\"\(key)\": \(value),")
         }
         }
        
        if(payload.length > 1){
            payload.replaceCharacters(in: NSMakeRange(payload.length-1, 1), with: "")
            payload.append("}")
        }
        
        //print(payload)
        
        
        
        //payload.appendString(String(format:"\"destination\": \"%@\",",tempsubscrptiondata["destination"] as! String))
        
        var str = payload as String
        str = payload as String
        //print(str)
        
        
        let url = URL.init(string:String(format: "%@assets/",credentials().domain_url))
        ////print(url?.absoluteURL)
        let subscription_key = credentials().subscription_key
        let token = UserDefaults.standard.object(forKey: "token") as! String
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "POST"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let httpbody = str
        request.httpBody = httpbody.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                self.view.isUserInteractionEnabled = true
                return
            }
            
            let httpStatus = response as? HTTPURLResponse
            
            if (httpStatus!.statusCode == 401) {
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            }
            else if (httpStatus!.statusCode != 200 && httpStatus!.statusCode != 201) {
                // check for http errors
                //print("statusCode should be 200, but is \(httpStatus!.statusCode)")
                //print("response = \(response)")
                do{
                    let jsonDictionary : NSDictionary
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print(jsonDictionary)
                }catch{}
                
                DispatchQueue.main.async(execute: {
                    self.view.isUserInteractionEnabled = true
                    self.tableview.reloadData()
                })
            }else{
                
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print(jsonDictionary)
                    //self.tableview.reloadData()
                    // self.buildingactions(subscription_key, leedid: leedid)
                    DispatchQueue.main.async(execute: {
                        self.getbuilding(token, subscription_key: subscription_key, token_type: "Bearer")
                    })
                } catch {
                    //print(error)
                }
            }
            
        }) 
        task.resume()
    }
    
    func getbuilding(_ token:String,subscription_key:String,token_type:String){
        let url = URL.init(string: String(format: "%@assets/?page=1",credentials().domain_url))
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
            }else if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            }else{
                
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    let datakeyed = NSKeyedArchiver.archivedData(withRootObject: jsonDictionary)
                    UserDefaults.standard.set(datakeyed, forKey: "assetdata")
                    UserDefaults.standard.synchronize()
                    //print("JSON data is",jsonDictionary)
                    DispatchQueue.main.async(execute: {
                        self.view.isUserInteractionEnabled = true
                        self.spinner.isHidden = true
                    })
                    DispatchQueue.main.async(execute: {
                        self.navigationController?.popViewController(animated: true)

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

    func validatepin(){
        
        
        let payload = NSMutableString()
        //{"destination":"testuser@gmail.com","score_change_notification":false,"stype":"email"}
        
        
        
        payload.append("{")
        for (key, value) in data_dict {
            if(key as! String == "country"){
                payload.append("\"\(key)\": \"\(value)\",")
            }else if(key as! String == "state"){
                payload.append("\"\(key)\": \(value),")
            }
            else if(key as! String == "zip_code"){
                payload.append("\"\(key)\": \(value),")
            }
        }
        
        if(payload.length > 1){
            payload.replaceCharacters(in: NSMakeRange(payload.length-1, 1), with: "")
            payload.append("}")
        }
        
        //print(payload)
        
        
        
        //payload.appendString(String(format:"\"destination\": \"%@\",",tempsubscrptiondata["destination"] as! String))
        
        var str = payload as String
        str = payload as String
        //print(str)
        
        
        let url = URL.init(string:String(format: "%@assets/validation/",credentials().domain_url))
        ////print(url?.absoluteURL)
        let subscription_key = credentials().subscription_key
        let token = UserDefaults.standard.object(forKey: "token") as! String
        
        let request = NSMutableURLRequest.init(url: url!)
        request.httpMethod = "POST"
        request.addValue(subscription_key, forHTTPHeaderField:"Ocp-Apim-Subscription-Key" )
        request.addValue("application/json", forHTTPHeaderField:"Content-type" )
        request.addValue(String(format:"Bearer %@",token), forHTTPHeaderField:"Authorization" )
        let httpbody = str
        request.httpBody = httpbody.data(using: String.Encoding.utf8)
        self.view.isUserInteractionEnabled = false
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                //print("error=\(error)")
                DispatchQueue.main.async(execute: {
                    self.showalert("Please check your internet connection or try again later", title: "Device in offline", action: "OK")
                    
                })
                self.view.isUserInteractionEnabled = true
                return
            }
            
            let httpStatus = response as? HTTPURLResponse
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 401 {           // check for http errors
                DispatchQueue.main.async(execute: {
                    self.spinner.isHidden = true
                    self.view.isUserInteractionEnabled = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "renewtoken"), object: nil, userInfo:nil)
                })
            }else if (httpStatus!.statusCode != 200 && httpStatus!.statusCode != 201) {
                // check for http errors
                //print("statusCode should be 200, but is \(httpStatus!.statusCode)")
                //print("response = \(response)")
                do{
                    let jsonDictionary : NSDictionary
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print(jsonDictionary)
                }catch{}
                self.view.isUserInteractionEnabled = true
                DispatchQueue.main.async(execute: {
                    self.view.isUserInteractionEnabled = true
                    self.tableview.reloadData()
                })
            }else{
                
                let jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    //print(jsonDictionary)
                    //self.tableview.reloadData()
                    // self.buildingactions(subscription_key, leedid: leedid)
                    DispatchQueue.main.async(execute: {
                        self.validatearea()
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

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

