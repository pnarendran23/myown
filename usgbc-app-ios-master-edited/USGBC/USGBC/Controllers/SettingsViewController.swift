//
//  SettingsViewController.swift
//  USGBC
//
//  Created by Vishal Raj on 10/08/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

protocol SettingsDelegate: class {
    func refreshQuickMenu()
}

class SettingsViewController: UIViewController {
    
    var settings: [SettingsMenu] = []
    var selectedSettings: [SettingsMenu] = []
    let apiManager = ApiManager()
    var count = 0
    var settingChanged = false
    weak var delegate: SettingsDelegate?
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadSettingsMenus()
        getSelectedSettings()
        initViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.main.async {
            Utility.hideLoading()
            if (self.isMovingFromParentViewController || self.isBeingDismissed) {
                if(self.settingChanged){
                    self.delegate?.refreshQuickMenu()
                }
            }
        }
        
    }
    
    func initViews(){
        title = "Settings"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SettingsCell", bundle: nil), forCellReuseIdentifier: "SettingsCell")
        tableView.register(UINib(nibName: "SubFilterCell", bundle: nil), forCellReuseIdentifier: "SubFilterCell")
        tableView.tableFooterView = UIView()
        tableView.allowsMultipleSelection = true
    }
    
    func loadSettingsMenus(){
        JsonManager.shared.getSettings { (settings, error) in
            if(error == nil){
                self.settings = settings!
            }
        }
    }
    
    func saveSettings(section: Int, sectionName: String, path: Int, selected: Bool){
        let realm = try! Realm()
        let preSettings = realm.objects(SettingsMenu.self)
        if(preSettings.count > 0){
            try! realm.write{
                preSettings[section].sectionName = sectionName
                preSettings[section].sectionList[path].selected = selected
            }
        }else{
            settings[section].sectionName = sectionName
            settings[section].sectionList[path].selected = selected
            do{
                try realm.write { () -> Void in
                    realm.add(settings)
                }
            }catch {
                print(error.localizedDescription)
            }
        }
        settingChanged = true
    }
    
    func getSelectedSettings(){
        let realm = try! Realm()
        selectedSettings = Array(realm.objects(SettingsMenu.self))
        if(selectedSettings.count > 0){
            settings = selectedSettings
        }
    }

    @IBAction func handleSave(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func updateNotificationSettings(status: String){
        let utility = Utility()
        let params = ["app_id": utility.getAppID(), "updated_on": Utility.getCurrentDate(), "partneralias": "usgbcmobile", "partnerpwd": "usgbcmobilepwd", "notification_status": status]
        print(params)
        ApiManager.shared.updateFCMDevice(params: params) { (message, error) in
            if(error == nil && message != nil){
                Utility.showToast(message: message!)
            }else{
                Utility.showToast(message: "Something went wrong!")
            }
        }
    }
    
    func switchStateDidChange(_ sender:UISwitch!) {
        if (sender.isOn == true){
            saveSettings(section: 0, sectionName: "Notification", path: 0, selected: true)
            if #available(iOS 10.0, *) {
                // SETUP FOR NOTIFICATION FOR iOS >= 10.0
                let center  = UNUserNotificationCenter.current()
                //center.delegate = self
                center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                    if error == nil{
                        DispatchQueue.main.async(execute: {
                            UIApplication.shared.registerForRemoteNotifications()
                            Utility().saveNotifcationStatus(status: "1")
                            self.updateNotificationSettings(status: "1")
                        })
                    }
                }
            }else{
                // SETUP FOR NOTIFICATION FOR iOS < 10.0
                let settings = UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(settings)
                
                // This is an asynchronous method to retrieve a Device Token
                // Callbacks are in AppDelegate.swift
                // Success = didRegisterForRemoteNotificationsWithDeviceToken
                // Fail = didFailToRegisterForRemoteNotificationsWithError
                UIApplication.shared.registerForRemoteNotifications()
                Utility().saveNotifcationStatus(status: "1")
                 self.updateNotificationSettings(status: "1")
            }
        }else{
            UIApplication.shared.unregisterForRemoteNotifications()
            saveSettings(section: 0, sectionName: "Notification", path: 0, selected: false)
            Utility().saveNotifcationStatus(status: "0")
            self.updateNotificationSettings(status: "0")
        }
    }
}

// MARK: UITableView delegates
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
            case 0:
                return "Notification"
            case 1:
                return "Quick menu"
            default:
                return ""
            }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section) {
            case 0:
                return 62
            case 1:
                return 44
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.hex(hex: Colors.listBack)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
            case 0:
                return settings.first!.sectionList.count
            case 1:
                return settings.last!.sectionList.count
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
                cell.selectionStyle = .none
                cell.titleLabel.text = settings.first?.sectionList[indexPath.row].name
                if(Utility().getNotifcationStatus() == "0"){
                    cell.uiSwitch.isOn = false
                }else if(Utility().getNotifcationStatus() == "1"){
                    cell.uiSwitch.isOn = true
                }
                cell.uiSwitch.addTarget(self, action: #selector(SettingsViewController.switchStateDidChange(_:)), for: .valueChanged)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SubFilterCell", for: indexPath) as! SubFilterCell
                cell.selectionStyle = .none
                let emptyCheckImage = UIImage(named: "unchecked")
                let emptyCheckmark = UIImageView(image: emptyCheckImage)
                emptyCheckmark.tintColor = UIColor.hex(hex: Colors.primaryColor)
                let checkImage = UIImage(named: "checked")
                let checkmark = UIImageView(image: checkImage)
                checkmark.tintColor = UIColor.hex(hex: Colors.primaryColor)
                if(settings.last?.sectionList[indexPath.row].selected)!{
                    cell.accessoryType = .checkmark
                    cell.accessoryView = checkmark
                    count = count + 1
                }else{
                    cell.accessoryType = .none
                    cell.accessoryView = emptyCheckmark
                }
                cell.subFilterLabel.text = settings.last?.sectionList[indexPath.row].name
                return cell
            default:
                return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 1){
            var selected: Bool = false
            let emptyCheckImage = UIImage(named: "unchecked")
            let emptyCheckmark = UIImageView(image: emptyCheckImage)
            emptyCheckmark.tintColor = UIColor.hex(hex: Colors.primaryColor)
            let checkImage = UIImage(named: "checked")
            let checkmark = UIImageView(image: checkImage)
            checkmark.tintColor = UIColor.hex(hex: Colors.primaryColor)
            if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
                if(count > 3){
                    tableView.cellForRow(at: indexPath)?.accessoryType = .none
                    tableView.cellForRow(at: indexPath)?.accessoryView = emptyCheckmark
                    selected = false
                    count -= 1
                    saveSettings(section: 1, sectionName: "Quick Menu", path: indexPath.row, selected: selected)
                }else{
                    Utility.showToast(message: "Minimum three items!")
                }
            }else{
                if(count < 5){
                    tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                    tableView.cellForRow(at: indexPath)?.accessoryView = checkmark
                    selected = true
                    count += 1
                    saveSettings(section: 1, sectionName: "Quick Menu", path: indexPath.row, selected: selected)
                }else{
                    Utility.showToast(message: "Maximum five items!")
                }
            }
        }
    }
}
