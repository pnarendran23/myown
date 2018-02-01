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
        dpicker.datePickerMode = .date
        self.dpickerview.isHidden = true
        self.pickerview.isHidden = true
        dpicker.addTarget(self, action: #selector(self.changeDate(dpicker:)), for: .valueChanged)
        let viewController = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2]
        defaultbtn = (viewController?.navigationItem.backBarButtonItem!)!
        tempaccountdict = accountdict
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
                    cell.txtfield.text = ((self.tempaccountdict["facebook"] as! String).isEmpty) ? "" :  self.tempaccountdict["facebook"] as! String
                }else if(indexPath.row == 1){
                    cell.lbl.text = "Twitter"
                    cell.txtfield.text = ((self.tempaccountdict["twitter"] as! String).isEmpty) ? "" :  self.tempaccountdict["twitter"] as! String
                }else if(indexPath.row == 2){
                    cell.lbl.text = "LinkedIn"
                    cell.txtfield.text = ((self.tempaccountdict["linkedin"] as! String).isEmpty) ? "" :  self.tempaccountdict["linkedin"] as! String
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
                        date = dateformat.date(from: self.tempaccountdict["dob"] as! String) as! NSDate
                    }
                    dpicker.date = date as Date
                    dpickerview.isHidden = false
                    pickerview.isHidden = true
                }else{
                    picker.selectRow(0, inComponent: 0, animated: true)
                    if(self.tempaccountdict["gender"] != nil){
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
            self.tempaccountdict["facebook"] = textField.text
        }else if(textField.tag == 1001){
            self.tempaccountdict["twitter"] = textField.text
        }else if(textField.tag == 1002){
            self.tempaccountdict["linkedin"] = textField.text
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
        
        ApiManager.shared.updatePersonalProfile(firstname: self.profile.fname, lastname: self.profile.lname, phone: self.profile.phone, address1: self.profile.address1, address2: self.profile.address2, city: self.profile.city, province: self.profile.province, country: self.profile.country, postal_code: self.profile.postal_code, email: self.profile.email, mailstreet: self.profile.mailingaddressstreet, mailcity: self.profile.mailingaddresscity, mailprovince: self.profile.mailingaddressprovince, mailcountry: self.profile.mailingaddresscountry, mailpostalcode: self.profile.mailingaddresspostalcode, billstreet: self.profile.billingaddressstreet, billcity: self.profile.billingaddresscity, billprovince: self.profile.billingaddressprovince, billcountry: self.profile.billingaddresscountry, billpostalcode: self.profile.billingaddresspostalcode, bio: self.tempaccountdict["bio"] as! String, dob: self.tempaccountdict["dob"] as! String, website: self.tempaccountdict["website"] as! String, facebook: self.tempaccountdict["facebook"] as! String, linkedin: self.tempaccountdict["linkedin"] as! String, twitter: self.tempaccountdict["twitter"] as! String)
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
