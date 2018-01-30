//
//  AccountSettingsViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 19/07/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

class AccountSettingsViewController:UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var cell = "Cell"
    var tableView = UITableView()
    var accountInfoList : [AccountInfo] = []
    var profile: AccountProfile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.initUITableView()
            self.loadAccountProfile()
            Utility.showLoading()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tabBarController?.title = "Account Settings"
//        let editImage = UIImage(named: "edit")!.withRenderingMode(.alwaysTemplate)
//        let navEditButton = UIBarButtonItem(image: editImage, style: .plain, target: self, action: #selector(AccountSettingsViewController.handleEdit))
//        tabBarController?.navigationItem.rightBarButtonItem = navEditButton
//        tabBarController?.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
//        tabBarController?.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Bounce back to the main thread to update the UI
        DispatchQueue.main.async {
            Utility.hideLoading()
        }
    }
    
    func initViews(){
        let a1 = AccountInfo()
        a1.title = "Name"
        a1.info = "\(profile.fname) \(profile.lname)"
        accountInfoList.append(a1)
        let a2 = AccountInfo()
        a2.title = "Email & privacy"
        a2.info = Utility().getUserDetail()
        accountInfoList.append(a2)
//        let a3 = AccountInfo()
//        a3.title = "Password"
//        a3.info = profile.password
//        accountInfoList.append(a3)
        let a4 = AccountInfo()
        a4.title = "About"
        a4.info = (profile.dob.isEmpty) ? "" : "Date of birth: \(profile.dob)"
        a4.info += (!a4.info.isEmpty) ? ((profile.gender.isEmpty) ? "" : "\nGender: \(profile.gender)") : ""
        a4.info += (!a4.info.isEmpty) ? ((profile.studentID.isEmpty) ? "" : "\nStudend ID: \(profile.studentID)") : ""
        a4.info += (!a4.info.isEmpty) ? ((profile.currentInstitute.isEmpty) ? "" : "\nCurrent educational institution: \(profile.currentInstitute)") : ""
        a4.info += (!a4.info.isEmpty) ? ((profile.graduationDate.isEmpty) ? "" : "\nGraduation date: \(profile.graduationDate)") : ""
        a4.info = (a4.info.isEmpty) ? "Not available" : a4.info
        accountInfoList.append(a4)
        print(profile.currentInstitute)
        let a5 = AccountInfo()
        a5.title = "Mailing address"
        a5.info = (profile.mailingaddressstreet.isEmpty) ? "" : "Street: \(profile.mailingaddressstreet)"
        a5.info += (!a5.info.isEmpty) ? ((profile.mailingaddresscity.isEmpty) ? "" : "\nCity: \(profile.mailingaddresscity)") : ""
        a5.info += (!a5.info.isEmpty) ? ((profile.mailingaddressprovince.isEmpty) ? "" : "\nProvince/State: \(profile.mailingaddressprovince)") : ""
        a5.info += (!a5.info.isEmpty) ? ((profile.mailingaddresscountry.isEmpty) ? "" : "\nCountry: \(profile.mailingaddresscountry)") : ""
        a5.info += (!a5.info.isEmpty) ? ((profile.mailingaddresspostalcode.isEmpty) ? "" : "\nPostal code: \(profile.mailingaddresspostalcode)") : ""
        a5.info = (a5.info.isEmpty) ? "Not available" : a5.info
        accountInfoList.append(a5)
        let a6 = AccountInfo()
        a6.title = "Billing address"
        a6.info = (profile.billingaddressstreet.isEmpty) ? "" : "Street: \(profile.billingaddressstreet)"
        a6.info += (!a6.info.isEmpty) ? ((profile.billingaddresscity.isEmpty) ? "" : "\nCity: \(profile.billingaddresscity)") : ""
        a6.info += (!a6.info.isEmpty) ? ((profile.billingaddressprovince.isEmpty) ? "" : "\nProvince/State: \(profile.billingaddressprovince)") : ""
        a6.info += (!a6.info.isEmpty) ? ((profile.billingaddresscountry.isEmpty) ? "" : "\nCountry: \(profile.billingaddresscountry)") : ""
        a6.info += (!a6.info.isEmpty) ? ((profile.billingaddresspostalcode.isEmpty) ? "" : "\nPostal code: \(profile.billingaddresspostalcode)") : ""
        a6.info = (a6.info.isEmpty) ? "Not available" : a6.info
        accountInfoList.append(a6)
        let a7 = AccountInfo()
        a7.title = "Phone number"
        a7.info = (profile.phone.isEmpty) ? "Not available" : profile.phone
        accountInfoList.append(a7)
        let a8 = AccountInfo()
        a8.title = "AIA#"
        a8.info = (profile.aia.isEmpty) ? "AIA# N/A" : profile.aia
        accountInfoList.append(a8)
        let a9 = AccountInfo()
        a9.title = "ASLA member #"
        a9.info = (profile.aslanumber.isEmpty) ? "ASLA# N/A" : profile.aslanumber
        accountInfoList.append(a9)
        tableView.reloadData()
    }
    
    func loadAccountProfile(){
        Utility.showLoading()
        ApiManager.shared.getAccountProfile(callback: {(profile, error) in
            if(error == nil && profile != nil){
                Utility.hideLoading()
                self.profile = profile!
                self.initViews()
            }else{
                Utility.hideLoading()
                Utility.showToast(message: "Something went wrong!")
            }
        })
    }
    
    func handleEdit(){
        let updateAccountSettingsViewController = UpdateAccountSettingsViewController()
        updateAccountSettingsViewController.profile = profile
        navigationController?.pushViewController(updateAccountSettingsViewController, animated: true)
    }
    
    //To initialize UITableView
    func initUITableView() {
        view.backgroundColor = UIColor.white
        tableView.frame = view.frame
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(AccountSettingsViewCell.self, forCellReuseIdentifier: cell)
        view.addSubview(tableView)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountInfoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cell, for:indexPath as IndexPath) as! AccountSettingsViewCell
        cell.selectionStyle = .none
        cell.titleLabel.text = accountInfoList[indexPath.row].title
        cell.infoLabel.text = accountInfoList[indexPath.row].info
        return cell
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 128, right: 0)
    }
}
