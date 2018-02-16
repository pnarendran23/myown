//
//  parallax.swift
//  labelhighlight
//
//  Created by Group X on 22/01/18.
//  Copyright © 2018 USGBC. All rights reserved.
//

import UIKit
import ParallaxHeader
import SimpleImageViewer
import SwiftyPickerPopover
import SwiftyJSON

class accsettings: UIViewController, UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitbtn: UIButton!
    var countries = [String : Any]()
    var states = [String : Any]()
    var countryjson = [String : Any]()
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var accountInfoList : [AccountInfo] = []
    var defaultbtn = UIBarButtonItem()
    var profile: PersonalProfile!
    var singleTap: UITapGestureRecognizer!
    var accountdict : NSMutableDictionary!
    var tempaccountdict : NSMutableDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()
                let path = Bundle.main.path(forResource: "countries", ofType: "json")
                let jsonData = NSData(contentsOfFile:path!)
                var publications: [Publication] = []
                var localPublications: [Publication] = []
                let json = JSON(data: jsonData! as Data)
                print("Countries are", json["countries"])
        countryjson = json.dictionaryObject!
        countries = countryjson["countries"] as! [String : Any]
        self.spinner.center = CGPoint(x: self.view.frame.size.width/2,y:self.view.frame.size.height/2)
        self.submitbtn.isEnabled = false
        self.submitbtn.frame = CGRect(x:self.submitbtn.frame.origin.x,y:self.tableView.frame.origin.y + self.tableView.frame.size.height,width:self.submitbtn.frame.size.width,height:(self.view.frame.size.height - (self.tableView.frame.origin.y + self.tableView.frame.size.height)))
        self.submitbtn.alpha = 0.3
        self.tableView.register(UINib.init(nibName: "TextwithLabel", bundle: nil), forCellReuseIdentifier: "cell")
        self.initviews()
        AppUtility.lockOrientation(.portrait)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let acc = self.navigationController
        let viewController = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 1]
        defaultbtn = (viewController?.navigationItem.backBarButtonItem!)!
        
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
  
    
    func initviews(){
        if(tableView != nil){
        tableView.register(UINib.init(nibName: "accountcell", bundle: nil), forCellReuseIdentifier: "accountcell")
        }
        self.tempaccountdict = NSMutableDictionary()
    
        DispatchQueue.main.async( execute: {
        self.navigationItem.title = "Account settings"
        self.spinner.isHidden = false
        self.loadPersonalProfile()
    
        })
    }
    
    func loadPersonalProfile(){
        ApiManager.shared.getPersonalProfile(callback: {(profile, error) in
            if(error == nil && profile != nil){
                DispatchQueue.main.async( execute: {
                  self.spinner.isHidden = true
                })
                self.profile = profile!
                let imageView = UIImageView()
                //imageView.image = UIImage(named: "h")
                imageView.contentMode = .scaleAspectFill
                let image = UIImage(named: "usgbc")
                imageView.image = image
                if(self.profile.image != ""){
                imageView.kf.setImage(with: URL(string: "https://dev.usgbc.org/\(self.profile.image)"), placeholder: image)
                }
                
                /*//self.tableView.parallaxHeader.view = imageView
                self.tableView.parallaxHeader.height = 400
                self.tableView.parallaxHeader.minimumHeight = 0
                self.tableView.parallaxHeader.mode = .topFill*/
                var label = UILabel.init(frame: CGRect(x:0,y:0.8 * 400, width : self.view.bounds.width,height:400-(0.8 * 400)))
                label.numberOfLines = 3
                label.text = "\(self.profile.fname) \(self.profile.lname) | \(self.profile.jobtitle) \n \(self.profile.department) | \(self.profile.company)"
                
                label.backgroundColor = UIColor.black
                label.textColor = UIColor.white
                label.font = UIFont.gothamBook(size: 15)
                self.accountdict = NSMutableDictionary()
                self.tempaccountdict = NSMutableDictionary()
                //self.tableView.parallaxHeader.view.addSubview(label)
                self.accountdict["email"] = Utility().getUserDetail()
                var dict = NSMutableDictionary()
                dict["mailingaddressstreet"] = (self.profile.mailingaddressstreet.isEmpty) ? "" : self.profile.mailingaddressstreet
                dict["mailingaddresscity"] = (self.profile.mailingaddresscity.isEmpty) ? "" : self.profile.mailingaddresscity
                dict["mailingaddressprovince"] = (self.profile.mailingaddressprovince.isEmpty) ? "" : self.profile.mailingaddressprovince
                dict["mailingaddresscountry"] = (self.profile.mailingaddresscountry.isEmpty) ? "" : self.profile.mailingaddresscountry
                dict["mailingaddresspostalcode"] = (self.profile.mailingaddresspostalcode.isEmpty) ? "" : self.profile.mailingaddresspostalcode
                
                self.accountdict["mailingaddressstreet"] = (self.profile.mailingaddressstreet.isEmpty) ? "" : self.profile.mailingaddressstreet
                self.accountdict["mailingaddresscity"] = (self.profile.mailingaddresscity.isEmpty) ? "" : self.profile.mailingaddresscity
                self.accountdict["mailingaddressprovince"] = (self.profile.mailingaddressprovince.isEmpty) ? "" : self.profile.mailingaddressprovince
                self.accountdict["mailingaddresscountry"] = (self.profile.mailingaddresscountry.isEmpty) ? "" : self.profile.mailingaddresscountry
                self.accountdict["mailingaddresspostalcode"] = (self.profile.mailingaddresspostalcode.isEmpty) ? "" : self.profile.mailingaddresspostalcode
                
                
                
                self.accountdict["mailingaddress"] = dict
                self.accountdict["gender"] = (self.profile.gender.isEmpty) ? "" : self.profile.gender
                dict = NSMutableDictionary()
                dict["billingaddressstreet"] = (self.profile.billingaddressstreet.isEmpty) ? "" : self.profile.billingaddressstreet
                dict["billingaddresscity"] = (self.profile.billingaddresscity.isEmpty) ? "" : self.profile.billingaddresscity
                dict["billingaddressprovince"] = (self.profile.billingaddressprovince.isEmpty) ? "" : self.profile.billingaddressprovince
                dict["billingaddresscountry"] = (self.profile.billingaddresscountry.isEmpty) ? "" : self.profile.billingaddresscountry
                dict["billingaddresspostalcode"] = (self.profile.billingaddresspostalcode.isEmpty) ? "" : self.profile.billingaddresspostalcode
                
                self.accountdict["billingaddressstreet"] = (self.profile.billingaddressstreet.isEmpty) ? "" : self.profile.billingaddressstreet
                self.accountdict["billingaddresscity"] = (self.profile.billingaddresscity.isEmpty) ? "" : self.profile.billingaddresscity
                self.accountdict["billingaddressprovince"] = (self.profile.billingaddressprovince.isEmpty) ? "" : self.profile.billingaddressprovince
                self.accountdict["billingaddresscountry"] = (self.profile.billingaddresscountry.isEmpty) ? "" : self.profile.billingaddresscountry
                self.accountdict["billingaddresspostalcode"] = (self.profile.billingaddresspostalcode.isEmpty) ? "" : self.profile.billingaddresspostalcode
                self.accountdict["billingaddress"] = dict
                
                
                
                self.accountdict["aianumber"] = (self.profile.aia.isEmpty) ? "AIA# " : self.profile.aia
                self.accountdict["aslanumber"] = (self.profile.aslanumber.isEmpty) ? "" : self.profile.aslanumber
                self.accountdict["publicdirectory"] = self.profile.publicdirectory
                self.accountdict["bio"] = self.profile.bio
                self.accountdict["website"] = self.profile.website
                self.accountdict["location"] = self.profile.location
                self.accountdict["linkedinlink"] = self.profile.linkedin
                self.accountdict["facebooklink"] = self.profile.facebook
                self.accountdict["twitterlink"] = self.profile.twitter
                self.accountdict["dob"] = self.profile.dob
                self.accountdict["department"] = self.profile.department
                self.accountdict["firstname"] = self.profile.fname
                self.accountdict["lastname"] = self.profile.lname
                self.accountdict["jobtitle"] = self.profile.jobtitle
                self.accountdict["company"] = self.profile.company
                self.tempaccountdict = NSMutableDictionary()
                for (key,value) in self.accountdict{
                    self.tempaccountdict[key] = value
                }
                self.tableView.reloadData()
                
            }else{
                var statuscode = error?._code as! Int
                if(statuscode != -999){
                    self.spinner.isHidden = true
                    Utility.showToast(message: "Something went wrong, try again later!")
                }
                
            }
            
        })
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //self.tableView.parallaxHeader.view.subviews[0].isHidden = true
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("completed")
        //self.tableView.parallaxHeader.view.subviews[0].isHidden = false
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(self.tempaccountdict.allKeys.count > 0){
        return 4
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 2){
            return "Billing Address"
        }else if(section == 1){
            return "Mailing Address"
        }
        
        return ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.tempaccountdict.allKeys.count > 0){
        if(section == 1){
            return (tempaccountdict["mailingaddress"] == nil) ? 0 : (tempaccountdict["mailingaddress"] as! NSDictionary).allKeys.count
        }else if(section == 2){
            return (tempaccountdict["billingaddress"] == nil) ? 0 : (tempaccountdict["billingaddress"] as! NSDictionary).allKeys.count
        }else if(section == 3){
            return 1
            }
        return 9
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 1
        }
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0 && indexPath.row == 0){
            return 0.37 * UIScreen.main.bounds.size.width
        }
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 3){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1")
            cell?.textLabel?.text = "About me"
            cell?.accessoryType = .disclosureIndicator
            return cell!
        }
        
        if(indexPath.section == 0 && indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "accountcell") as! accountcell
            cell.selectionStyle = .none
            let image = UIImage(named: "usgbc")
            if(singleTap == nil){
                cell.imgview.isUserInteractionEnabled = true
                singleTap = UITapGestureRecognizer(target: self, action: #selector(self.singleTapping))
                singleTap.numberOfTapsRequired = 1;
                cell.imgview.addGestureRecognizer(singleTap)
            }
            if(self.profile.gender.lowercased() == "male"){
                cell.imgview.image = UIImage.init(named: "male")
            }
            if(self.profile.gender.lowercased() == "female"){
                cell.imgview.image = UIImage.init(named: "female")
            }
            cell.switchh.isOn = false
            if(self.tempaccountdict["publicdirectory"] != nil){
            if(self.tempaccountdict["publicdirectory"] as! String == "61"){
                cell.switchh.isOn = true
            }
            }
            if(!self.profile.image.isEmpty){
                cell.imgview.kf.setImage(with: URL(string: "https://dev.usgbc.org/\(self.profile.image)"), placeholder: image)
            }
            cell.switchh.addTarget(self, action: #selector(self.switchchanged(sender:)), for: .valueChanged)
            
            /*//self.tableView.parallaxHeader.view = imageView
             self.tableView.parallaxHeader.height = 400
             self.tableView.parallaxHeader.minimumHeight = 0
             self.tableView.parallaxHeader.mode = .topFill*/
            var label = UILabel.init(frame: CGRect(x:0,y:0.8 * 400, width : self.view.bounds.width,height:400-(0.8 * 400)))
            cell.label.text = "\(self.profile.fname) \(self.profile.lname) | \(self.profile.jobtitle) \n \(self.profile.department) | \(self.profile.company)"
            return cell
        }
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TextwithLabel
        cell.txtfield.delegate = self
        cell.txtfield.isUserInteractionEnabled = true
        cell.txtfield.keyboardType = .default
        cell.txtfield.tag = ( 1000 * indexPath.section) + indexPath.row
        if(indexPath.row == 1){
            cell.lbl.text = "First Name"
            cell.txtfield.text = self.tempaccountdict["firstname"] as! String
        }else if(indexPath.row == 2){
            cell.lbl.text = "Last Name"
            cell.txtfield.text = self.tempaccountdict["lastname"] as! String
        }else if(indexPath.row == 4){
            cell.lbl.text = "Department"
            cell.txtfield.text = self.tempaccountdict["department"] as! String
        }else if(indexPath.row == 3){
            cell.lbl.text = "Job Title"
            cell.txtfield.text = self.tempaccountdict["jobtitle"] as! String
        }else if(indexPath.row == 5){
            cell.lbl.text = "Company"
            cell.txtfield.text = self.tempaccountdict["company"] as! String
        }else if(indexPath.row == 6){
            cell.lbl.text = "Email"
            cell.txtfield.keyboardType = .emailAddress
            cell.txtfield.text = self.tempaccountdict["email"] as! String
        }
        else if(indexPath.row == 7){
            cell.lbl.text = "AIA#"
            cell.txtfield.keyboardType = .numberPad
            cell.txtfield.text = self.tempaccountdict["aianumber"] as! String
        }
        else if(indexPath.row == 8){
            cell.lbl.text = "ASLA number"
            cell.txtfield.keyboardType = .numberPad
            cell.txtfield.text = self.tempaccountdict["aslanumber"] as! String
        }
        if(indexPath.section == 1){
            
            var dict = self.tempaccountdict["mailingaddress"] as! NSMutableDictionary
            if(indexPath.row == 0){
                cell.lbl.text = "Street"
                cell.txtfield.text = dict["mailingaddressstreet"] as! String
            }else if(indexPath.row == 1){
                cell.lbl.text = "City"
                cell.txtfield.text = dict["mailingaddresscity"] as! String
            }else if(indexPath.row == 3){
                cell.txtfield.isUserInteractionEnabled = false
                cell.lbl.text = "Province"
                cell.txtfield.text = dict["mailingaddressprovince"] as! String
            }else if(indexPath.row == 2){
                cell.lbl.text = "Country"
                cell.txtfield.isUserInteractionEnabled = false
                cell.txtfield.text = dict["mailingaddresscountry"] as! String
            }else if(indexPath.row == 4){
                cell.lbl.text = "Postal code"
                cell.txtfield.keyboardType = .numberPad
                cell.txtfield.text = dict["mailingaddresspostalcode"] as! String
            }
        }else if(indexPath.section == 2){
           var dict = self.tempaccountdict["billingaddress"] as! NSMutableDictionary
            if(indexPath.row == 0){
                cell.lbl.text = "Street"
                cell.txtfield.text = dict["billingaddressstreet"] as! String
            }else if(indexPath.row == 1){
                cell.lbl.text = "City"
                cell.txtfield.text = dict["billingaddresscity"] as! String
            }else if(indexPath.row == 3){
                cell.lbl.text = "Province"
                cell.txtfield.isUserInteractionEnabled = false
                cell.txtfield.text = dict["billingaddressprovince"] as! String
            }else if(indexPath.row == 2){
                cell.txtfield.isUserInteractionEnabled = false
                cell.lbl.text = "Country"
                cell.txtfield.text = dict["billingaddresscountry"] as! String
            }else if(indexPath.row == 4){
                cell.lbl.text = "Postal code"
                cell.txtfield.text = dict["billingaddresspostalcode"] as! String
            }
        }
        
        
        return cell
        
    }
    
    func someSelector() {
        DispatchQueue.main.async( execute: {
            //ApiManager.shared.stopAllSessions()
            self.spinner.isHidden = false
            //self.view.isUserInteractionEnabled = false
            self.updateData()
        })
        // Something after a delay
    }
    
    func switchchanged(sender : UISwitch){
        print(sender.isOn)
        if(sender.isOn){
            self.tempaccountdict["publicdirectory"] = "61"
        }else{
            self.tempaccountdict["publicdirectory"] = "62"
        }
        if(self.accountdict == self.tempaccountdict){
            self.submitbtn.isEnabled = false
            self.tableView.alpha = 1
        }else{
            DispatchQueue.main.async( execute: {
                self.spinner.isHidden = false
                self.view.isUserInteractionEnabled = false
                self.tableView.alpha = 0.3
                self.updateData()
            })
        }
        //let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(someSelector), userInfo: nil, repeats: false)
    }
    
    
    func updateData(){

        ApiManager.shared.updatePersonalProfile(firstname : self.tempaccountdict["firstname"] as! String,lastname : self.tempaccountdict["lastname"] as! String,jobtitle : self.tempaccountdict["jobtitle"] as! String,department : self.tempaccountdict["department"] as! String, company :self.tempaccountdict["company"] as! String, email : self.tempaccountdict["email"] as! String, aia : self.tempaccountdict["aianumber"] as! String, aslanumber: self.tempaccountdict["aslanumber"] as! String, phone : self.profile.phone, address1 : self.profile.address1, address2 : self.profile.address2, city : self.profile.city, province : self.profile.province, country : self.profile.country, postal_code : self.profile.postal_code,mailstreet : self.tempaccountdict["mailingaddressstreet"] as! String, mailcity : self.tempaccountdict["mailingaddresscity"] as! String, mailprovince : self.tempaccountdict["mailingaddressprovince"] as! String, mailcountry : self.tempaccountdict["mailingaddresscountry"] as! String, mailpostalcode : self.tempaccountdict["mailingaddresspostalcode"] as! String, billstreet : self.tempaccountdict["billingaddressstreet"] as! String,billcity : self.tempaccountdict["billingaddresscity"] as! String, billprovince : self.tempaccountdict["billingaddressprovince"] as! String, billcountry : self.tempaccountdict["billingaddresscountry"] as! String, billpostalcode : self.tempaccountdict["billingaddresspostalcode"] as! String, bio : self.profile.bio, dob : self.profile.dob, gender : self.profile.gender, website : self.profile.website, facebook : self.profile.facebook, linkedin : self.profile.linkedin, twitter : self.profile.twitter, publicdirectory : self.tempaccountdict["publicdirectory"] as! String,callback: { (profile, error) in
            if(error == nil && profile != nil){
                //self.view.isUserInteractionEnabled = true
                //self.loadPersonalProfile()
                //self.profile = profile!
                DispatchQueue.main.async( execute: {
                self.profile = profile!
                let imageView = UIImageView()
                //imageView.image = UIImage(named: "h")
                imageView.contentMode = .scaleAspectFill
                let image = UIImage(named: "usgbc")
                imageView.kf.setImage(with: URL(string: "https://dev.usgbc.org/\(self.profile.image)"), placeholder: image)
                /*//self.tableView.parallaxHeader.view = imageView
                 self.tableView.parallaxHeader.height = 400
                 self.tableView.parallaxHeader.minimumHeight = 0
                 self.tableView.parallaxHeader.mode = .topFill*/
                var label = UILabel.init(frame: CGRect(x:0,y:0.8 * 400, width : self.view.bounds.width,height:400-(0.8 * 400)))
                label.numberOfLines = 3
                label.text = "\(self.profile.fname) \(self.profile.lname) | \(self.profile.jobtitle) \n \(self.profile.department) | \(self.profile.company)"
                
                label.backgroundColor = UIColor.black
                label.textColor = UIColor.white
                label.font = UIFont.gothamBook(size: 15)
                self.accountdict = NSMutableDictionary()
                self.tempaccountdict = NSMutableDictionary()
                //self.tableView.parallaxHeader.view.addSubview(label)
                self.accountdict["email"] = Utility().getUserDetail()
                var dict = NSMutableDictionary()
                dict["mailingaddressstreet"] = (self.profile.mailingaddressstreet.isEmpty) ? "" : self.profile.mailingaddressstreet
                dict["mailingaddresscity"] = (self.profile.mailingaddresscity.isEmpty) ? "" : self.profile.mailingaddresscity
                dict["mailingaddressprovince"] = (self.profile.mailingaddressprovince.isEmpty) ? "" : self.profile.mailingaddressprovince
                dict["mailingaddresscountry"] = (self.profile.mailingaddresscountry.isEmpty) ? "" : self.profile.mailingaddresscountry
                dict["mailingaddresspostalcode"] = (self.profile.mailingaddresspostalcode.isEmpty) ? "" : self.profile.mailingaddresspostalcode
                
                self.accountdict["mailingaddressstreet"] = (self.profile.mailingaddressstreet.isEmpty) ? "" : self.profile.mailingaddressstreet
                self.accountdict["mailingaddresscity"] = (self.profile.mailingaddresscity.isEmpty) ? "" : self.profile.mailingaddresscity
                self.accountdict["mailingaddressprovince"] = (self.profile.mailingaddressprovince.isEmpty) ? "" : self.profile.mailingaddressprovince
                self.accountdict["mailingaddresscountry"] = (self.profile.mailingaddresscountry.isEmpty) ? "" : self.profile.mailingaddresscountry
                self.accountdict["mailingaddresspostalcode"] = (self.profile.mailingaddresspostalcode.isEmpty) ? "" : self.profile.mailingaddresspostalcode
                
                
                
                self.accountdict["mailingaddress"] = dict
                self.accountdict["gender"] = (self.profile.gender.isEmpty) ? "" : self.profile.gender
                dict = NSMutableDictionary()
                dict["billingaddressstreet"] = (self.profile.billingaddressstreet.isEmpty) ? "" : self.profile.billingaddressstreet
                dict["billingaddresscity"] = (self.profile.billingaddresscity.isEmpty) ? "" : self.profile.billingaddresscity
                dict["billingaddressprovince"] = (self.profile.billingaddressprovince.isEmpty) ? "" : self.profile.billingaddressprovince
                dict["billingaddresscountry"] = (self.profile.billingaddresscountry.isEmpty) ? "" : self.profile.billingaddresscountry
                dict["billingaddresspostalcode"] = (self.profile.billingaddresspostalcode.isEmpty) ? "" : self.profile.billingaddresspostalcode
                
                self.accountdict["billingaddressstreet"] = (self.profile.billingaddressstreet.isEmpty) ? "" : self.profile.billingaddressstreet
                self.accountdict["billingaddresscity"] = (self.profile.billingaddresscity.isEmpty) ? "" : self.profile.billingaddresscity
                self.accountdict["billingaddressprovince"] = (self.profile.billingaddressprovince.isEmpty) ? "" : self.profile.billingaddressprovince
                self.accountdict["billingaddresscountry"] = (self.profile.billingaddresscountry.isEmpty) ? "" : self.profile.billingaddresscountry
                self.accountdict["billingaddresspostalcode"] = (self.profile.billingaddresspostalcode.isEmpty) ? "" : self.profile.billingaddresspostalcode
                self.accountdict["billingaddress"] = dict
                
                
                
                self.accountdict["aianumber"] = (self.profile.aia.isEmpty) ? "AIA# " : self.profile.aia
                self.accountdict["aslanumber"] = (self.profile.aslanumber.isEmpty) ? "" : self.profile.aslanumber
                self.accountdict["publicdirectory"] = self.profile.publicdirectory
                self.accountdict["bio"] = self.profile.bio
                self.accountdict["website"] = self.profile.website
                self.accountdict["location"] = self.profile.location
                self.accountdict["linkedinlink"] = self.profile.linkedin
                self.accountdict["facebooklink"] = self.profile.facebook
                self.accountdict["twitterlink"] = self.profile.twitter
                self.accountdict["dob"] = self.profile.dob
                self.accountdict["department"] = self.profile.department
                self.accountdict["firstname"] = self.profile.fname
                self.accountdict["lastname"] = self.profile.lname
                self.accountdict["jobtitle"] = self.profile.jobtitle
                self.accountdict["company"] = self.profile.company
                self.tempaccountdict = NSMutableDictionary()
                for (key,value) in self.accountdict{
                    self.tempaccountdict[key] = value
                }
                    Utility.showToast(message: "Profile updated successfully")
                    self.spinner.isHidden = true
                    self.tableView.alpha = 1
                    self.view.isUserInteractionEnabled = true
                    //self.submitbtn.isEnabled = false
                    //self.submitbtn.alpha = 0.3
                    //self.submitbtn.setTitle("Submit", for: .normal)
                    self.tableView.reloadData()
                })
            }else{
                var statuscode = error?._code as! Int
                if(statuscode != -999){
                    DispatchQueue.main.async( execute: {
                    self.spinner.isHidden = true
                    self.submitbtn.isEnabled = true
                    self.view.isUserInteractionEnabled = true
                    self.tableView.alpha = 1
                    //self.view.isUserInteractionEnabled = true
                        Utility.showToast(message: "Something went wrong, try again later!")
                        self.submitbtn.setTitle("Submit", for: .normal)
                        
                    })
                }else{
                    //self.spinner.isHidden = true
                }
            }
        })
    }
    
    func singleTapping() {
        self.showaction()
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(section == 3){
        return 0.54 * UIScreen.main.bounds.size.height
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.tabBarController?.selectedIndex = 1
        if(indexPath.section == 3 && indexPath.row == 0){
            self.performSegue(withIdentifier: "aboutme", sender: nil)
        }else{
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            if((indexPath.section == 1 && indexPath.row == 2) || (indexPath.section == 2 && indexPath.row == 2)){
                self.view.endEditing(true)
                var temp = [String]()
                for (item,value) in countries{
                    var s = value as! String
                    temp.append(s)
                }
                temp = temp.sorted()
                var cell = tableView.cellForRow(at: indexPath) as! TextwithLabel
                let p = StringPickerPopover(title: "Country", choices: temp)
                    .setSelectedRow(0)
                    .setDoneButton(title: "Done", color : UIColor.white,action: { (popover, selectedRow, selectedString) in
                        print("done row \(selectedRow) \(selectedString)")
                        if(indexPath.section == 1 && indexPath.row == 2){
                            var dict = NSMutableDictionary()
                            dict["mailingaddressstreet"] = (self.profile.mailingaddresscountry.isEmpty) ? "" : self.profile.mailingaddressstreet
                            dict["mailingaddresscity"] = (self.profile.mailingaddresscity.isEmpty) ? "" : self.profile.mailingaddresscity
                            dict["mailingaddressprovince"] = ""
                            dict["mailingaddresscountry"] = temp[selectedRow]
                            dict["mailingaddresspostalcode"] = (self.profile.mailingaddresspostalcode.isEmpty) ? "" : self.profile.mailingaddresspostalcode
                            self.tempaccountdict["mailingaddress"] = dict
                            
                            self.tempaccountdict["mailingaddresscountry"] = temp[selectedRow]
                            //self.tableView.reloadData()
                            self.tableView(tableView, didSelectRowAt: NSIndexPath.init(row: indexPath.row + 1, section: indexPath.section) as IndexPath )
                        }else{
                            var dict = NSMutableDictionary()
                            dict["billingaddressstreet"] = (self.profile.billingaddressstreet.isEmpty) ? "" : self.profile.billingaddressstreet
                            dict["billingaddresscity"] = (self.profile.billingaddresscity.isEmpty) ? "" : self.profile.billingaddresscity
                            dict["billingaddressprovince"] = ""
                            dict["billingaddresscountry"] = temp[selectedRow]
                            dict["billingaddresspostalcode"] = (self.profile.billingaddresspostalcode.isEmpty) ? "" : self.profile.billingaddresspostalcode
                            self.tempaccountdict["billingaddress"] = dict
                            
                            self.tempaccountdict["billingaddresscountry"] = temp[selectedRow]
                            //self.tableView.reloadData()
                            self.tableView(tableView, didSelectRowAt: NSIndexPath.init(row: indexPath.row + 1, section: indexPath.section) as IndexPath )
                        }
                    })
                    .setCancelButton(title: "Cancel", color : UIColor.white,action: { (_, _, _) in
                        self.tableView.reloadData()
                        print("cancel")}
                )
                
                DispatchQueue.main.async {
                    p.appear(originView: cell.contentView, baseViewController: self)
                }
            }else if((indexPath.section == 1 && indexPath.row == 3) || (indexPath.section == 2 && indexPath.row == 3)){
                self.view.endEditing(true)
                var temp = [String]()
                for (item,value) in countries{
                    var s = value as! String
                    temp.append(s)
                }
                temp = temp.sorted()
                var cell = tableView.cellForRow(at: indexPath) as! TextwithLabel
                var current_code = ""
                if(indexPath.section == 1 && indexPath.row == 3){
                    if(self.tempaccountdict["mailingaddresscountry"] as! String == ""){
                        Utility.showToast(message: "Please select country first")
                        self.tableView.reloadData()
                        return
                    }
                    var s = self.tempaccountdict["mailingaddresscountry"] as! String
                    for (item,value) in countries{
                        var str = value as! String
                        if(str == s){
                            current_code = item as! String
                            break
                        }
                    }
                    if((countryjson["divisions"] as! [String : Any])[current_code] != nil){
                    states = (countryjson["divisions"] as! [String : Any])[current_code] as! [String : Any]
                    temp = [String]()
                    for (item,value) in states{
                        var s = value as! String
                        temp.append(s)
                    }
                    }else{
                        temp.removeAll()
                        temp.append(s)
                    }
                }else if(indexPath.section == 2 && indexPath.row == 3){
                        if(self.tempaccountdict["billingaddresscountry"] as! String == ""){
                            Utility.showToast(message: "Please select country first")
                            self.tableView.reloadData()
                            return
                        }
                    var s = self.tempaccountdict["mailingaddresscountry"] as! String
                    for (item,value) in countries{
                        var str = value as! String
                        if(str == s){
                            current_code = item as! String
                            break
                        }
                    }
                    if((countryjson["divisions"] as! [String : Any])[current_code] != nil){
                    states = (countryjson["divisions"] as! [String : Any])[current_code] as! [String : Any]
                    temp = [String]()
                    for (item,value) in states{
                        var s = value as! String
                        temp.append(s)
                    }
                    }else{
                        temp.removeAll()
                        temp.append(s)
                    }
                }
                
                temp = temp.sorted()
                let p = StringPickerPopover(title: "Province", choices: temp)
                    .setSelectedRow(0)
                    .setDoneButton(title: "Done", color : UIColor.white,action: { (popover, selectedRow, selectedString) in
                        print("done row \(selectedRow) \(selectedString)")
                        if(indexPath.section == 1 && indexPath.row == 3){
                            var dict = NSMutableDictionary()
                            dict["mailingaddressstreet"] = (self.profile.mailingaddresscountry.isEmpty) ? "" : self.profile.mailingaddressstreet
                            dict["mailingaddresscity"] = (self.profile.mailingaddresscity.isEmpty) ? "" : self.profile.mailingaddresscity
                            dict["mailingaddressprovince"] = temp[selectedRow]
                            dict["mailingaddresscountry"] = self.tempaccountdict["mailingaddresscountry"]
                            dict["mailingaddresspostalcode"] = (self.profile.mailingaddresspostalcode.isEmpty) ? "" : self.profile.mailingaddresspostalcode
                            self.tempaccountdict["mailingaddress"] = dict
                            
                            self.tempaccountdict["mailingaddressprovince"] = temp[selectedRow]
                            self.tableView.reloadData()
                            DispatchQueue.main.async( execute: {
                                self.spinner.isHidden = false
                                self.view.isUserInteractionEnabled = false
                                self.tableView.alpha = 0.3
                                self.updateData()
                            })
                        }else{
                            var dict = NSMutableDictionary()
                            dict["billingaddressstreet"] = (self.profile.billingaddressstreet.isEmpty) ? "" : self.profile.billingaddressstreet
                            dict["billingaddresscity"] = (self.profile.billingaddresscity.isEmpty) ? "" : self.profile.billingaddresscity
                            dict["billingaddressprovince"] = temp[selectedRow]
                            dict["billingaddresscountry"] = self.tempaccountdict["billingaddresscountry"]
                            dict["billingaddresspostalcode"] = (self.profile.billingaddresspostalcode.isEmpty) ? "" : self.profile.billingaddresspostalcode
                            self.tempaccountdict["billingaddress"] = dict
                            self.tempaccountdict["billingaddressprovince"] = temp[selectedRow]
                            self.tableView.reloadData()
                            DispatchQueue.main.async( execute: {
                                self.spinner.isHidden = false
                                self.view.isUserInteractionEnabled = false
                                self.tableView.alpha = 0.3
                                self.updateData()
                            })
                        }
                    })
                    .setCancelButton(title: "Cancel", color : UIColor.white,action: { (_, _, _) in
                        self.tableView.reloadData()
                        print("cancel")}
                )
                DispatchQueue.main.async {
                    p.appear(originView: cell.contentView, baseViewController: self)
                }
            }else{
            let cell = tableView.cellForRow(at: indexPath)
            if(cell is TextwithLabel){
                self.navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(self.cancel(button:)))
                
                self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(self.done(button:)))
                if((cell as! TextwithLabel).txtfield.isUserInteractionEnabled){
                    (cell as! TextwithLabel).txtfield.becomeFirstResponder()
                }else{
                    self.view.endEditing(true)
                    self.navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(self.cancel(button:)))
                    
                    self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(self.done(button:)))
                    
                }
                }
            }
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.tableView.reloadData()
        let acc = self.navigationController
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "aboutme"){
            var v = segue.destination as! aboutme
            v.accountdict = self.tempaccountdict
            v.profile = self.profile
        }
    }
    
    func showaction(){
        let actionSheet = UIAlertController.init(title: "Please select any options below", message: nil, preferredStyle: .actionSheet)
        let preview = UIAlertAction.init(title: "Preview Photo", style: UIAlertActionStyle.default, handler: { (action) in
            //self.openCamera()
            let cell = self.tableView.cellForRow(at: NSIndexPath.init(row: 0, section: 0) as IndexPath) as! accountcell
            let configuration = ImageViewerConfiguration { config in
                config.imageView = cell.imgview
            }
            
            let imageViewerController = ImageViewerController(configuration: configuration)
            
            self.present(imageViewerController, animated: true)
        })
        
        let take_photo = UIAlertAction.init(title: "Take Photo", style: UIAlertActionStyle.default, handler: { (action) in
            //self.openCamera()
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                var imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        let choose = UIAlertAction.init(title: "Choose Photo", style: UIAlertActionStyle.default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                var imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        
        let remove = UIAlertAction.init(title: "Remove Photo", style: UIAlertActionStyle.default, handler: { (action) in
            //self.showPhotoLibrary()
            let image = UIImage(named: "usgbc")
            Utility.clearTempFolder()
            self.saveImageDocumentDirectory(image: image!)
            let imagePath = (self.getDirectoryPath() as NSString).appendingPathComponent("upload.jpg")
            var uploadimg = UIImage(contentsOfFile: imagePath)!
            let cell = self.tableView.cellForRow(at: (NSIndexPath.init(item: 0, section: 0) as NSIndexPath) as IndexPath) as! accountcell
            if(self.profile.gender == "Male"){
                cell.imgview.image = UIImage.init(named: "male")
            }
            if(self.profile.gender == "Female"){
                cell.imgview.image = UIImage.init(named: "female")
            }
            if(image != nil){
                DispatchQueue.main.async( execute: {
                    self.updateprofilepic(url: self.uploadimg, path: imagePath, action: "delete")
                })
            }
        })
        
        if(profile.image.isEmpty){
            remove.isEnabled = false
            preview.isEnabled = false
        }
        
        actionSheet.addAction(preview)
        actionSheet.addAction(take_photo)
        actionSheet.addAction(choose)
        actionSheet.addAction(remove)
        
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in
            // self.dismissViewControllerAnimated(true, completion: nil) is not needed, this is handled automatically,
            //Plus whatever method you define here, gets called,
            //If you tap outside the UIAlertController action buttons area, then also this handler gets called.
        }))
        //Present the controller
        
        if let popoverPresentationController = actionSheet.popoverPresentationController {
            let cell = self.tableView.cellForRow(at: NSIndexPath.init(row: 0, section: 0) as IndexPath) as! accountcell
            popoverPresentationController.sourceView = cell.imgview
            popoverPresentationController.sourceRect = cell.imgview.frame
        }
        //self.presentViewController(shareMenu, animated: true, completion: nil)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let cell = self.tableView.cellForRow(at: (NSIndexPath.init(item: 0, section: 0) as NSIndexPath) as IndexPath) as! accountcell
        print(info)
        Utility.clearTempFolder()
        //let url = generateImageUrl(fileName: "upload", image: image)
        //cell.imgview.image = image
        if (picker.sourceType == .camera){
            var metadata = info[UIImagePickerControllerMediaMetadata] as! NSDictionary
                print(metadata)
        }
        
        saveImageDocumentDirectory(image: image)
        let imagePath = (self.getDirectoryPath() as NSString).appendingPathComponent("upload.jpg")
        uploadimg = UIImage(contentsOfFile: imagePath)!
        cell.imgview.image = uploadimg        
        if(image != nil){
        DispatchQueue.main.async( execute: {
            self.updateprofilepic(url: self.uploadimg, path: imagePath, action: "upload")
        })
        }
        
        self.dismiss(animated:true, completion: nil)
    }
        
    func saveImageDocumentDirectory(image : UIImage){
        let fileManager = FileManager.default
        let paths =  (NSSearchPathForDirectoriesInDomains(.documentDirectory , .userDomainMask, true)[0] as NSString).appendingPathComponent("upload.jpg")
        print(paths)
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
    var uploadimg = UIImage()

    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory , .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func cancel(button : UIBarButtonItem){
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = defaultbtn
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = nil
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
        self.view.endEditing(true)
        self.tableView.reloadData()
        
    }
    func done(button : UIBarButtonItem){
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = defaultbtn
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = nil
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
        self.view.endEditing(true)
        //someSelector()
        if(self.accountdict == self.tempaccountdict){
            
        }else{
            DispatchQueue.main.async( execute: {
                self.spinner.isHidden = false
                self.view.isUserInteractionEnabled = false
                self.tableView.alpha = 0.3
                self.updateData()
            })
        }
        
    }
  
    @IBAction func submit(_ sender: Any) {
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(self.cancel(button:)))
        
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(self.done(button:)))
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        self.navigationItem.backBarButtonItem = defaultbtn
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
        self.view.endEditing(true)
        if(textField.tag == 1){
            self.tempaccountdict["firstname"] = textField.text
        }else if(textField.tag == 2){
            self.tempaccountdict["lastname"] = textField.text
        }else if(textField.tag == 3){
            self.tempaccountdict["jobtitle"] = textField.text
        }else if(textField.tag == 4){
            self.tempaccountdict["department"] = textField.text
        }else if(textField.tag == 5){
            self.tempaccountdict["company"] = textField.text
        }else if(textField.tag == 6){
            self.tempaccountdict["email"] = textField.text
        }else if(textField.tag == 7){
            self.tempaccountdict["aianumber"] = textField.text
        }else if(textField.tag == 8){
            self.tempaccountdict["aslanumber"] = textField.text
        }
        else if(textField.tag == 1000){
            self.tempaccountdict["mailingaddressstreet"] = textField.text
        }else if(textField.tag == 1001){
            self.tempaccountdict["mailingaddresscity"] = textField.text
        }else if(textField.tag == 1003){
            //self.tempaccountdict["mailingaddressprovince"] = textField.text
        }
            //else if(textField.tag == 1003){
//            self.tempaccountdict["mailingaddresscountry"] = textField.text
//        }
        else if(textField.tag == 1004){
            self.tempaccountdict["mailingaddresspostalcode"] = textField.text
        }else if(textField.tag == 2000){
            self.tempaccountdict["billingaddressstreet"] = textField.text
        }else if(textField.tag == 2001){
            self.tempaccountdict["billingaddresscity"] = textField.text
        }else if(textField.tag == 2003){
            //self.tempaccountdict["billingaddressprovince"] = textField.text
        }else if(textField.tag == 2002){
            //self.tempaccountdict["billingaddresscountry"] = textField.text
        }else if(textField.tag == 2004){
            self.tempaccountdict["billingaddresspostalcode"] = textField.text
        }
    }
    
    
    func updateprofilepic(url :  UIImage, path : String, action : String){
        DispatchQueue.main.async( execute: {
            Utility.showLoading()
        })
        ApiManager.shared.updatePersonalProfilepic(image: url, path: path, action : action, callback: {(dict, error) in
            if(error == nil && dict != nil){
                DispatchQueue.main.async( execute: {
                    print(dict)
                    if(action == "upload"){
                        Utility.showToast(message: "Photo updated successfully")
                        Utility.hideLoading()
                        self.loadPersonalProfile()
                    }else{
                        Utility.showToast(message: "Photo removed successfully")
                        Utility.hideLoading()
                        self.profile.image = ""
                        self.tableView.reloadData()
                    }
                })
                
            }else{
                DispatchQueue.main.async( execute: {
                    Utility.hideLoading()
                    Utility.showToast(message: "Something went wrong!")
                    print(error)
                })
            }
            
        })
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

