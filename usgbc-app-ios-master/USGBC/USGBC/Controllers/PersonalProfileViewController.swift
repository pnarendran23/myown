//
//  PersonalProfileViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 19/07/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit

class PersonalProfileViewController:UIViewController{
    
    var cell = "Cell"
    var tableView = UITableView()
    var accountInfoList : [AccountInfo] = []
    var profile: PersonalProfile!
    var profileImage: UIImageView!
    var titleLabel: UILabel!
    var headerView: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        tabBarController?.title = "Personal Profile"
        DispatchQueue.main.async {
            self.initUITableView()
            Utility.showLoading()
            self.loadPersonalProfile()
        }
        
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        // Bounce back to the main thread to update the UI
    }
    
   
    
    func initViews(){
        let image = UIImage(named: "usgbc")
        profileImage.kf.setImage(with: URL(string: "http://dev.usgbc.org/\(profile.image)"), placeholder: image)
        titleLabel.text = "\(profile.fname) \(profile.lname)"
        headerView.isHidden = false
        let a2 = AccountInfo()
        a2.title = "Job title"
        a2.info = (profile.jobtitle.isEmpty) ? "Not available" : profile.jobtitle
        accountInfoList.append(a2)
        let a3 = AccountInfo()
        a3.title = "Department"
        a3.info = (profile.department.isEmpty) ? "Not available" : profile.department
        accountInfoList.append(a3)
        let a4 = AccountInfo()
        a4.title = "Company"
        a4.info = (profile.company.isEmpty) ? "Not available" : profile.company
        accountInfoList.append(a4)
        let a5 = AccountInfo()
        a5.title = "Bio"
        a5.info = (profile.bio.isEmpty) ? "Not available" : profile.bio
        accountInfoList.append(a5)
        let a6 = AccountInfo()
        a6.title = "Location"
        a6.info = (profile.mailingaddressstreet.isEmpty) ? "" : "Street: \(profile.mailingaddressstreet)"
        a6.info += (!a6.info.isEmpty) ? ((profile.mailingaddresscity.isEmpty) ? "" : "\nCity: \(profile.mailingaddresscity)") : ""
        a6.info += (!a6.info.isEmpty) ? ((profile.mailingaddressprovince.isEmpty) ? "" : "\nProvince/State: \(profile.mailingaddressprovince)") : ""
        a6.info += (!a6.info.isEmpty) ? ((profile.mailingaddresscountry.isEmpty) ? "" : "\nCountry: \(profile.mailingaddresscountry)") : ""
        a6.info += (!a6.info.isEmpty) ? ((profile.mailingaddresspostalcode.isEmpty) ? "" : "\nPostal code: \(profile.mailingaddresspostalcode)") : ""
        a6.info = (a6.info.isEmpty) ? "Not available" : a6.info
        accountInfoList.append(a6)
        let a7 = AccountInfo()
        a7.title = "Website"
        a7.info = (profile.website.isEmpty) ? "Not available" : profile.website
        accountInfoList.append(a7)
        let a8 = AccountInfo()
        a8.title = "Social networks"
        a8.info = (profile.facebook.isEmpty) ? "" : "Facebook: \(profile.facebook)"
        a8.info += (!a8.info.isEmpty) ? ((profile.twitter.isEmpty) ? "" : "\nTwitter: \(profile.twitter)") : ""
        a8.info += (!a8.info.isEmpty) ? ((profile.linkedin.isEmpty) ? "" : "\nLinkedin: \(profile.linkedin)") : ""
        a8.info = (a8.info.isEmpty) ? "Not available" : a8.info
        accountInfoList.append(a8)
        let a9 = AccountInfo()
        a9.title = "AIA#"
        a9.info = (profile.aia.isEmpty) ? "AIA# N/A" : profile.aia
        accountInfoList.append(a9)
        tableView.reloadData()
    }
    
    func loadPersonalProfile(){        
        ApiManager.shared.getPersonalProfile(callback: {(profile, error) in
            if(error == nil && profile != nil){
                
                self.profile = profile!
                self.initViews()
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
    
    func handleEdit(){
        navigationController?.pushViewController(UpdatePersonalProfileViewController(), animated: true)
    }
    
    //To initialize UITableView
    func initUITableView() {
        headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        headerView.backgroundColor = UIColor.hex(hex: Colors.listBack)
        headerView.isHidden = true
        profileImage = UIImageView.init(frame: CGRect(x: 10, y: 10, width: 80, height: 80))
        headerView.addSubview(profileImage)
        
        titleLabel = UILabel.init(frame: CGRect(x: 100, y: 8, width: view.frame.width - 20, height: 30))
        titleLabel.font = UIFont(name: "Gotham-Bold", size: 14.0)
        titleLabel.textColor = UIColor.darkGray
        titleLabel.textAlignment = .left
        headerView.addSubview(titleLabel)
        
        let publicDirectoryText: UILabel = UILabel.init(frame: CGRect(x: 100, y: 41, width: view.frame.width - 20, height: 30))
        publicDirectoryText.text = "Public directory listing"
        publicDirectoryText.font = UIFont(name: "Gotham-Medium", size: 14.0)
        publicDirectoryText.textColor = UIColor.hex(hex: Colors.textColorSecondaryTwo)
        publicDirectoryText.textAlignment = .left
        headerView.addSubview(publicDirectoryText)
        
        let directorySwitch = UISwitch()
        directorySwitch.frame = CGRect(x: view.frame.width - 68, y: 38, width: 0, height: 0)
        directorySwitch.tintColor = UIColor.hex(hex: Colors.primaryColor)
        directorySwitch.onTintColor = UIColor.hex(hex: Colors.primaryColor)
        directorySwitch.isOn = true
        directorySwitch.setOn(false, animated: false)
        //directorySwitch.addTarget(self, action: #selector(PersonalProfileViewController.publicDirChange(_:)), forControlEvents: .ValueChanged)
        headerView.addSubview(directorySwitch)
        
        tableView.frame = view.frame
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(AccountSettingsViewCell.self, forCellReuseIdentifier: cell)
        tableView.tableHeaderView = headerView
        view.addSubview(tableView)
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 128, right: 0)
    }
}

extension PersonalProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
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
}
