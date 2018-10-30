//
//  SettingsController.swift
//  LGSideMenuControllerDemo
//
//  Created by Group10 on 29/01/18.
//  Copyright © 2018 Cole Dunsby. All rights reserved.
//

import Foundation
class SettingsController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet var tblSettings: UITableView!
    let step:Float=10 // If you want UISlider to snap to steps by 10
//     "Messages",
    private let titlesArray = ["Vicinity Radius",
                               "FAQs",
                               "Contact Us",
                              
                               "Sign out"]
    private let tagsArray = ["Set the distance of the bus from the pickup point when you want the alarm to ring",
                             "",
                             "",
                             "Editing the registered mobile number will re-initiate the authentication process"]
    let number :Int = 2000
    
    var alert :UIAlertController? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.navigationController?.navigationBar.topItem?.title = "Settings"
        tblSettings.register(UINib.init(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "settingscell")
        print("settings controller")
        tblSettings.dataSource = self
        tblSettings.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // navigationItem.title = "One"
        self.navigationController?.navigationBar.topItem?.title = "Settings"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        
        self.navigationController?.navigationBar.barTintColor = UIColor( red: 12/255, green: 133/255, blue: 145/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        if(indexPath.row == 1){
            let mainViewController = sideMenuController!
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let profileController = storyboard.instantiateViewController(withIdentifier: "FAQsVC") as! FAQsVC
            let navigationController = mainViewController.rootViewController as! NavigationController
            navigationController.pushViewController(profileController, animated: true)
        }else if (indexPath.row == 2){
            let mainViewController = sideMenuController!
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let profileController = storyboard.instantiateViewController(withIdentifier: "Group10VC") as! Group10VC
            let navigationController = mainViewController.rootViewController as! NavigationController
            navigationController.pushViewController(profileController, animated: true)
        }else{
            if(titlesArray[indexPath.row] == "Sign out"){
                popUp(strTitle: "Sign out")
            }else{
                popUpWithSlider(strTitle: titlesArray[indexPath.row])
            }
            
        }
    }
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        return (indexPath.row == 1 || indexPath.row == 3) ? 22.0 : 44.0
        return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingscell", for: indexPath) as! SettingsTableViewCell
        //        print("items \(items[indexPath] as! StudentDbInfo)")
        print(titlesArray[indexPath.row] )
        cell.lblSettings.text = titlesArray[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        print(indexPath.row)
        
        if(indexPath.row == 0){
            cell.ivSettings.image = UIImage(named:"setting1-2x.png")
            
        }else if indexPath.row == 1 {
            cell.ivSettings.image = UIImage(named:"setting5-2x.png")
        }else if indexPath.row == 2 {
            cell.ivSettings.image = UIImage(named:"setting6-2x.png")
        }
//        else if indexPath.row == 3 {
//            cell.ivSettings.image = UIImage(named:"setting7-2x.png")
//        }
        else if indexPath.row == 3 {
            cell.ivSettings.image = UIImage(named:"setting8-2x.png")
        }

        cell.lblTag.text = tagsArray[indexPath.row]
        cell.lblTag.sizeToFit()
        
        return cell
    }
    func popUp(strTitle:String)  {
        
        let alert = UIAlertController(title: strTitle, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Enter phone number here..."
            textField.text = Utility().getPhone()
            textField.keyboardType = UIKeyboardType.phonePad
        })
        
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
              Utility().setSignInStatus(status: false)
//            if let name = self.alert?.textFields?.first?.text {
//            print("Your name: \(self.alert?.textFields?.first?.text)")

            
            self.requestToSignOut()
                
//            }
        }))
        
        self.present(alert, animated: true)
    }
    
    func popUpWithSlider(strTitle: String) {
        alert = UIAlertController(title: "Alert App", message: "100", preferredStyle: .alert)
        
        //        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: nil)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert?.addAction(CancelAction)
        
        
        alert?.message = "1000"
        let slider: UISlider =  UISlider(frame:CGRect(x: 10, y: 65, width: 250, height: 15))
        slider.minimumValue = 0
        slider.maximumValue = 2000
        slider.value = 1000
        slider.addTarget(self,action:#selector(MessagesController.sliderValueDidChange(_:)), for:.valueChanged)
        
        alert?.view.addSubview(slider)
        
        // Support display in iPad
        alert?.popoverPresentationController?.sourceView = self.view
        alert?.popoverPresentationController?.sourceRect = CGRect(x:0.0,y:0.0,width:self.view.bounds.size.width / 2.0, height:(self.view.bounds.size.height / 2.0)+120)
        
        self.present(alert!, animated: true, completion: nil)
    }
    @objc func sliderValueDidChange(_ sender:UISlider!)
    {
        
        // Use this code below only if you want UISlider to snap to values step by step
        let roundedStepValue = round(sender.value / step) * step
        sender.value = roundedStepValue
        alert?.message = String(roundedStepValue)
//        print("Slider step value \(Int(roundedStepValue))")
    }
//    func popUpWithSlider(strTitle:String)  {
//
//        let alert = UIAlertController(title: strTitle, message: nil, preferredStyle: .alert)
//
//        let lblTitle: UILabel =  UILabel(frame:CGRect(x: 80, y: 60, width: 250, height: 30))
//        alert.view.addSubview(lblTitle)
//        lblTitle.text = "100"
//
//        let slider: UISlider =  UISlider(frame:CGRect(x: 10, y: 80, width: 250, height: 15))
//        slider.minimumValue = 50
//        slider.maximumValue = 100
//        slider.value = 20
//        slider.addTarget(self,action:#selector(SettingsController.sliderValueDidChange(_:)), for:.valueChanged)
//
//        alert.view.addSubview(slider)
//
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
////        self.present(alert, animated: true, completion: nil)
//
//        // Support display in iPad
//        alert.popoverPresentationController?.sourceView = self.view
//        alert.popoverPresentationController?.sourceRect = CGRect(x:0.0,y:0.0,width:self.view.bounds.size.width / 2.0, height:(self.view.bounds.size.height / 2.0)+60)
//
//        self.present(alert, animated: true, completion: nil)
//    }
//    @objc func sliderValueDidChange(_ sender:UISlider!)
//    {
//
//        // Use this code below only if you want UISlider to snap to values step by step
//        let roundedStepValue = round(sender.value / step) * step
//        sender.value = roundedStepValue
//        print("Slider step value \(Int(roundedStepValue))")
//    }
    
    func requestToSignOut() {
        
        if NetworkReachability.isConnectedToNetwork()
        {
            DispatchQueue.main.async {
                Utility.showLoading()
            }
            let jsonObject: [String : Any] = [
                "data":[
                     "key" : Utility().getTokenUniqueDetail()
                ]
            ]
            var convertString:String?=nil
            if let dataString  = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
                let str = String(data: dataString, encoding: .utf8) {
                convertString=str
                print(str)
            }
            var dictonary:NSDictionary? = nil
            if let data = convertString?.data(using: String.Encoding.utf8) {
                
                do {
                    dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as NSDictionary?
                    
                } catch let error as NSError {
                    print(error)
                }
            }
            let requestType = "POST"
            let api = GlobalConstants.API.baseUrl + GlobalConstants.API.appLogout
            
            APIHandler().loginApiDetails(parameters: dictonary, api: api, requestType: requestType, completionHandler: { (sucess,response, error) in
                DispatchQueue.main.async {
                    DispatchQueue.main.async {
                     
                      Utility.hideLoading()
                    }
                    if sucess {
                        if(response != nil){
                        print("response \(String(describing: response))")
                        
                        let status = response!["status"] as! String
                        if(status == "failure"){
                            
                            //                         message = "No OTP found"
                            DispatchQueue.main.async {
                                self.showPopup(msg: response!["message"] as! String)
                            }
                        }else{
                            Utility().setSignInStatus(status: false)
                            Utility().savePhoneNumberAndotpToken(mob: "",optValue: "")
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let otpController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            self.navigationController?.pushViewController(otpController, animated: true)
                        }
                        
                    }else{
                        DispatchQueue.main.async {
                            self.showPopup(msg: "Error ")
                        }
                    }
                    }
                }
            })
        }else{
            self.showPopup(msg: GlobalConstants.Errors.internetConnectionError)
        }
        
    }
    func showPopup(msg:String)  {
        let alertController = UIAlertController(title: "Alert App", message: msg, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okButton)
        self.present(alertController, animated: true, completion: nil)
    }
}
