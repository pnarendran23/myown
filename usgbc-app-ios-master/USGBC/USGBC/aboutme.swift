//
//  aboutme.swift
//  USGBC
//
//  Created by Group X on 23/01/18.
//  Copyright © 2018 Group10 Technologies. All rights reserved.
//

import UIKit

class aboutme: UIViewController,UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    @IBOutlet weak var submitbtn: UIButton!
    @IBAction func submit(_ sender: Any) {
        DispatchQueue.main.async( execute: {
            Utility.showLoading()
            self.submitbtn.isEnabled = false
            self.submitbtn.setTitle("Submitting..", for: .normal)
            self.updatedata()
        })
    }
    
    @IBOutlet weak var dpickerview: UIView!
    @IBOutlet weak var dpicker: UIDatePicker!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var pickerview: UIView!
    @IBOutlet weak var tableView: UITableView!
    var accountdict = NSMutableDictionary()
    var defaultbtn = UIBarButtonItem()
    var tempaccountdict = NSMutableDictionary()
    var profile : PersonalProfile!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.submitbtn.frame = CGRect(x:self.submitbtn.frame.origin.x,y:self.tableView.frame.origin.y + self.tableView.frame.size.height,width:self.submitbtn.frame.size.width,height:(self.view.frame.size.height - (self.tableView.frame.origin.y + self.tableView.frame.size.height)))
        self.submitbtn.isEnabled = false
            self.submitbtn.alpha = 0.3
        print(self.tempaccountdict)
        dpicker.datePickerMode = .date        
        self.dpickerview.isHidden = true
        self.pickerview.isHidden = true
        self.submitbtn.setTitle("Submit", for: .normal)
        dpicker.addTarget(self, action: #selector(self.changeDate(dpicker:)), for: .valueChanged)
        let viewController = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2]
        defaultbtn = (viewController?.navigationItem.backBarButtonItem!)!
        for (key,value) in self.accountdict{
            self.tempaccountdict[key] = value
        }
        self.tableView.register(UINib.init(nibName: "TextwithLabel", bundle: nil), forCellReuseIdentifier: "cell")
        self.navigationItem.title = "About me"
        // Do any additional setup after loading the view.
    }
    
    func changeDate(dpicker : UIDatePicker){
         var dateformat = DateFormatter()
        dateformat.dateFormat = "dd/MM/yy"
        let str = dateformat.string(from: dpicker.date)
        self.tempaccountdict["dob"] = str
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()        
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 4
        }
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(row == 0){
            return "Male"
        }
        return "Female"
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TextwithLabel
            cell.txtfield.delegate = self
            cell.txtfield.isUserInteractionEnabled = true
            cell.txtfield.tag = (1000 * indexPath.section) + indexPath.row
            if(indexPath.section == 0 &&  indexPath.row == 0){
                    cell.lbl.text = "Bio"
                    cell.txtfield.text = ((self.tempaccountdict["bio"] as! String).isEmpty) ? "" :  self.tempaccountdict["bio"] as! String
            }else if(indexPath.section == 0 && indexPath.row == 1){
                cell.lbl.text = "DOB"
                cell.txtfield.isUserInteractionEnabled = false
                cell.txtfield.text = ((self.tempaccountdict["dob"] as! String).isEmpty) ? "" :  self.tempaccountdict["dob"] as! String
                var s = cell.txtfield.text
                
                if(s != ""){
                    var dateformat = DateFormatter()
                    dateformat.dateFormat = "dd/MM/yy"                    
                    
                }
            }else if(indexPath.section == 0 && indexPath.row == 2){
                cell.lbl.text = "Website"
                cell.txtfield.text = ((self.tempaccountdict["website"] as! String).isEmpty) ? "" :  self.tempaccountdict["website"] as! String
            }else if(indexPath.row == 3){
                cell.lbl.text = "Gender"
                cell.txtfield.isUserInteractionEnabled = false
                cell.txtfield.text = ((self.tempaccountdict["gender"] as! String).isEmpty) ? "" :  (self.tempaccountdict["gender"] as! String).capitalized
            }else if(indexPath.section == 1){
                if(indexPath.row == 0){
                    cell.lbl.text = "Facebook"
                    cell.txtfield.text = ((self.tempaccountdict["facebooklink"] as! String).isEmpty) ? "" :  self.tempaccountdict["facebooklink"] as! String
                }else if(indexPath.row == 1){
                    cell.lbl.text = "Twitter"
                    cell.txtfield.text = ((self.tempaccountdict["twitterlink"] as! String).isEmpty) ? "" :  self.tempaccountdict["twitterlink"] as! String
                }else if(indexPath.row == 2){
                    cell.lbl.text = "LinkedIn"
                    cell.txtfield.text = ((self.tempaccountdict["linkedinlink"] as! String).isEmpty) ? "" :  self.tempaccountdict["linkedinlink"] as! String
                }
            }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if(cell is TextwithLabel){
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(self.cancel(button:)))
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(self.done(button:)))
            if((cell as! TextwithLabel).txtfield.isUserInteractionEnabled){
                dpickerview.isHidden = true
                pickerview.isHidden = true
                (cell as! TextwithLabel).txtfield.becomeFirstResponder()
            }else{
                self.view.endEditing(true)
                self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(self.cancel(button:)))
                
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(self.done(button:)))
                if(indexPath.row == 1){
                    var dateformat = DateFormatter()
                    dateformat.dateFormat = "dd/MM/yy"
                    var date = NSDate()
                    if(self.tempaccountdict["dob"] != nil){
                        if(self.tempaccountdict["dob"] as! String == ""){
                            date = NSDate()
                        }else{
                            if(dateformat.date(from: self.tempaccountdict["dob"] as! String) == nil){
                            date = NSDate()
                            }else{
                            date = dateformat.date(from: self.tempaccountdict["dob"] as! String) as! NSDate
                            }
                        }
                    }
                    dpicker.date = date as Date
                    dpickerview.isHidden = false
                    pickerview.isHidden = true
                }else{
                    picker.selectRow(0, inComponent: 0, animated: true)
                    if(self.tempaccountdict["gender"] as! String == ""){
                        picker.selectRow(0, inComponent: 0, animated: true)
                        if((self.tempaccountdict["gender"] as! String).lowercased() == "male"){
                           picker.selectRow(0, inComponent: 0, animated: true)
                        }else if((self.tempaccountdict["gender"] as! String).lowercased() == "female"){
                            picker.selectRow(0, inComponent: 0, animated: false)
                        }
                    }
                    dpickerview.isHidden = true
                    pickerview.isHidden = false
                }
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(self.cancel(button:)))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(self.done(button:)))
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        self.navigationItem.backBarButtonItem = defaultbtn
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
        self.view.endEditing(true)
        if(textField.tag == 0){
            self.tempaccountdict["bio"] = textField.text
        }else if(textField.tag == 1){
            self.tempaccountdict["dob"] = textField.text
        }else if(textField.tag == 2){
            self.tempaccountdict["website"] = textField.text
        }else if(textField.tag == 4){
            self.tempaccountdict["gender"] = textField.text
        }else if(textField.tag == 1000){
            self.tempaccountdict["facebooklink"] = textField.text
        }else if(textField.tag == 1001){
            self.tempaccountdict["twitterlink"] = textField.text
        }else if(textField.tag == 1002){
            self.tempaccountdict["linkedinlink"] = textField.text
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 1){
            return "Social Media"
        }
        return ""
    }
    
    
    func cancel(button : UIBarButtonItem){
        self.navigationItem.backBarButtonItem = defaultbtn
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
        self.view.endEditing(true)
        dpickerview.isHidden = true
        pickerview.isHidden = true
        self.tableView.reloadData()
    }
    func done(button : UIBarButtonItem){
        self.navigationItem.backBarButtonItem = defaultbtn
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
        self.view.endEditing(true)        
        dpickerview.isHidden = true
        pickerview.isHidden = true
        if(self.picker.selectedRow(inComponent: 0) == 0){
            self.tempaccountdict["gender"] = "male"
        }else{
            self.tempaccountdict["gender"] = "female"
        }
        if(self.accountdict == self.tempaccountdict){
            self.submitbtn.isEnabled = false
            self.submitbtn.alpha = 0.3
        }else{
            self.submitbtn.isEnabled = true
            self.submitbtn.alpha = 1
        }
        self.tableView.reloadData()
       
    }
    
    
    func updatedata(){
        ApiManager.shared.updatePersonalProfile(firstname : self.tempaccountdict["firstname"] as! String,lastname : self.tempaccountdict["lastname"] as! String,jobtitle : self.tempaccountdict["jobtitle"] as! String,department : self.tempaccountdict["department"] as! String, company :self.tempaccountdict["company"] as! String, email : self.tempaccountdict["email"] as! String, aia : self.tempaccountdict["aianumber"] as! String, aslanumber: self.tempaccountdict["aslanumber"] as! String, phone : self.profile.phone, address1 : self.profile.address1, address2 : self.profile.address2, city : self.profile.city, province : self.profile.province, country : self.profile.country, postal_code : self.profile.postal_code,mailstreet : self.tempaccountdict["mailingaddressstreet"] as! String, mailcity : self.tempaccountdict["mailingaddresscity"] as! String, mailprovince : self.tempaccountdict["mailingaddressprovince"] as! String, mailcountry : self.tempaccountdict["mailingaddresscountry"] as! String, mailpostalcode : self.tempaccountdict["mailingaddresspostalcode"] as! String, billstreet : self.tempaccountdict["billingaddressstreet"] as! String,billcity : self.tempaccountdict["billingaddresscity"] as! String, billprovince : self.tempaccountdict["billingaddressprovince"] as! String, billcountry : self.tempaccountdict["billingaddresscountry"] as! String, billpostalcode : self.tempaccountdict["billingaddresspostalcode"] as! String, bio : self.tempaccountdict["bio"] as! String, dob : self.tempaccountdict["dob"] as! String, gender : self.tempaccountdict["gender"] as! String, website : self.tempaccountdict["website"] as! String, facebook : self.tempaccountdict["facebooklink"] as! String, linkedin : self.tempaccountdict["linkedinlink"] as! String, twitter : self.tempaccountdict["twitterlink"] as! String, publicdirectory : self.tempaccountdict["publicdirectory"] as! String,callback: { (profile, error) in
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
                    imageView.kf.setImage(with: URL(string: "http://dev.usgbc.org/\(self.profile.image)"), placeholder: image)
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
                    Utility.hideLoading()
                    self.submitbtn.isEnabled = false
                    self.submitbtn.alpha = 0.3
                    self.submitbtn.setTitle("Submit", for: .normal)
                    self.tableView.reloadData()
                })
            }else{
                var statuscode = error?._code as! Int
                if(statuscode != -999){
                    DispatchQueue.main.async( execute: {
                        Utility.hideLoading()
                        self.submitbtn.isEnabled = true
                        self.submitbtn.alpha = 1
                        //self.view.isUserInteractionEnabled = true
                        Utility.showToast(message: "Something went wrong, try again later!")
                        self.submitbtn.setTitle("Submit", for: .normal)
                        
                    })
                }else{
                    //Utility.hideLoading()
                }
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
