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

class accsettings: UIViewController, UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    var accountInfoList : [AccountInfo] = []
    var profile: PersonalProfile!
    var singleTap: UITapGestureRecognizer!
    var accountdict : NSMutableDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initviews()
        AppUtility.lockOrientation(.portrait)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let acc = self.navigationController
        
        
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initviews()
    }
    
    func initviews(){
        if(tableView != nil){
        tableView.register(UINib.init(nibName: "accountcell", bundle: nil), forCellReuseIdentifier: "accountcell")
        }
        self.accountdict = NSMutableDictionary()
    
        DispatchQueue.main.async( execute: {
        self.navigationItem.title = "Account settings"
        Utility.showLoading()
        self.loadPersonalProfile()
    
        })
    }
    
    func loadPersonalProfile(){
        ApiManager.shared.getPersonalProfile(callback: {(profile, error) in
            if(error == nil && profile != nil){
                DispatchQueue.main.async( execute: {
                  Utility.hideLoading()
                })
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
                //self.tableView.parallaxHeader.view.addSubview(label)
                self.accountdict["email"] = Utility().getUserDetail()
                var dict = NSMutableDictionary()
                dict["mailingaddressstreet"] = (self.profile.mailingaddressstreet.isEmpty) ? "" : self.profile.mailingaddressstreet
                dict["mailingaddresscity"] = (self.profile.mailingaddresscity.isEmpty) ? "" : self.profile.mailingaddresscity
                dict["mailingaddressprovince"] = (self.profile.mailingaddressprovince.isEmpty) ? "" : self.profile.mailingaddressprovince
                dict["mailingaddresscountry"] = (self.profile.mailingaddresscountry.isEmpty) ? "" : self.profile.mailingaddresscountry
                dict["mailingaddresspostalcode"] = (self.profile.mailingaddresspostalcode.isEmpty) ? "" : self.profile.mailingaddresspostalcode
                
                self.accountdict["mailingaddress"] = dict
                self.accountdict["gender"] = (self.profile.gender.isEmpty) ? "N/A" : self.profile.gender
                dict = NSMutableDictionary()
                dict["billingaddressstreet"] = (self.profile.billingaddressstreet.isEmpty) ? "" : self.profile.billingaddressstreet
                dict["billingaddresscity"] = (self.profile.billingaddresscity.isEmpty) ? "" : self.profile.billingaddresscity
                dict["billingaddressprovince"] = (self.profile.billingaddressprovince.isEmpty) ? "" : self.profile.billingaddressprovince
                dict["billingaddresscountry"] = (self.profile.billingaddresscountry.isEmpty) ? "" : self.profile.billingaddresscountry
                dict["billingaddresspostalcode"] = (self.profile.billingaddresspostalcode.isEmpty) ? "" : self.profile.billingaddresspostalcode
                self.accountdict["billingaddress"] = dict
                
                self.accountdict["AIA"] = (self.profile.aia.isEmpty) ? "AIA# N/A" : self.profile.aia
                self.accountdict["asla_number"] = (self.profile.aslanumber.isEmpty) ? "ASLA# N/A" : self.profile.aslanumber
                
                self.accountdict["bio"] = self.profile.bio
                self.accountdict["website"] = self.profile.website
                self.accountdict["location"] = self.profile.location
                self.accountdict["linkedin"] = self.profile.linkedin
                self.accountdict["facebook"] = self.profile.facebook
                self.accountdict["twitter"] = self.profile.twitter
                self.accountdict["dob"] = self.profile.dob
                
                self.tableView.reloadData()
                
            }else{
                Utility.showToast(message: "Something went wrong!")
            }
            DispatchQueue.main.async {
                //Utility.hideLoading()
            }
            DispatchQueue.main.async {
                Utility.hideLoading()
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
        if(self.accountdict.allKeys.count > 0){
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
        if(self.accountdict.allKeys.count > 0){
        if(section == 1){
            return (accountdict["mailingaddress"] == nil) ? 0 : (accountdict["mailingaddress"] as! NSDictionary).allKeys.count
        }else if(section == 2){
            return (accountdict["billingaddress"] == nil) ? 0 : (accountdict["billingaddress"] as! NSDictionary).allKeys.count
        }else if(section == 3){
            return 1
            }
        return 4
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
            return UIScreen.main.bounds.size.width
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
            if(self.profile.gender == "Male"){
                cell.imgview.image = UIImage.init(named: "male")
            }
            if(self.profile.gender == "Female"){
                cell.imgview.image = UIImage.init(named: "female")
            }
            if(!self.profile.image.isEmpty){
                cell.imgview.kf.setImage(with: URL(string: "http://dev.usgbc.org/\(self.profile.image)"), placeholder: image)
            }
            /*//self.tableView.parallaxHeader.view = imageView
             self.tableView.parallaxHeader.height = 400
             self.tableView.parallaxHeader.minimumHeight = 0
             self.tableView.parallaxHeader.mode = .topFill*/
            var label = UILabel.init(frame: CGRect(x:0,y:0.8 * 400, width : self.view.bounds.width,height:400-(0.8 * 400)))
            cell.label.text = "\(self.profile.fname) \(self.profile.lname) | \(self.profile.jobtitle) \n \(self.profile.department) | \(self.profile.company)"
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell!.selectionStyle = .none
        cell?.textLabel?.text = "asdsad"
        if(indexPath.row == 1){
            cell?.textLabel?.text = "Email"
            cell?.detailTextLabel?.text = self.accountdict["email"] as! String
        }
        else if(indexPath.row == 2){
            cell?.textLabel?.text = "AIA#"
            cell?.detailTextLabel?.text = self.accountdict["AIA"] as! String
        }
        else if(indexPath.row == 3){
            cell?.textLabel?.text = "ASLA number"
            cell?.detailTextLabel?.text = self.accountdict["asla_number"] as! String
        }
        if(indexPath.section == 1){
            var dict = self.accountdict["mailingaddress"] as! NSMutableDictionary
            if(indexPath.row == 0){
                cell?.textLabel?.text = "Street"
                cell?.detailTextLabel?.text = dict["mailingaddressstreet"] as! String
            }else if(indexPath.row == 1){
                cell?.textLabel?.text = "City"
                cell?.detailTextLabel?.text = dict["mailingaddresscity"] as! String
            }else if(indexPath.row == 2){
                cell?.textLabel?.text = "Province"
                cell?.detailTextLabel?.text = dict["mailingaddressprovince"] as! String
            }else if(indexPath.row == 3){
                cell?.textLabel?.text = "Country"
                cell?.detailTextLabel?.text = dict["mailingaddresscountry"] as! String
            }else if(indexPath.row == 4){
                cell?.textLabel?.text = "Postal code"
                cell?.detailTextLabel?.text = dict["mailingaddresspostalcode"] as! String
            }
        }else if(indexPath.section == 2){
            var dict = self.accountdict["billingaddress"] as! NSMutableDictionary
            if(indexPath.row == 0){
                cell?.textLabel?.text = "Street"
                cell?.detailTextLabel?.text = dict["billingaddressstreet"] as! String
            }else if(indexPath.row == 1){
                cell?.textLabel?.text = "City"
                cell?.detailTextLabel?.text = dict["billingaddresscity"] as! String
            }else if(indexPath.row == 2){
                cell?.textLabel?.text = "Province"
                cell?.detailTextLabel?.text = dict["billingaddressprovince"] as! String
            }else if(indexPath.row == 3){
                cell?.textLabel?.text = "Country"
                cell?.detailTextLabel?.text = dict["billingaddresscountry"] as! String
            }else if(indexPath.row == 4){
                cell?.textLabel?.text = "Postal code"
                cell?.detailTextLabel?.text = dict["billingaddresspostalcode"] as! String
            }
        }
        
        
        return cell!
        
    }
    
    func singleTapping() {
        self.showaction()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.tabBarController?.selectedIndex = 1
        if(indexPath.section == 3 && indexPath.row == 0){
            self.performSegue(withIdentifier: "aboutme", sender: nil)
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
            v.accountdict = self.accountdict
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
            self.profile.image = ""
            self.tableView.reloadData()
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
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let cell = self.tableView.cellForRow(at: (NSIndexPath.init(item: 0, section: 0) as NSIndexPath) as IndexPath) as! accountcell
        cell.imgview.image = image
        self.dismiss(animated:true, completion: nil)
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

